#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

=head1 NAME

otobo.psgi - OTOBO PSGI application

=head1 SYNOPSIS

    # the default webserver
    plackup bin/psgi-bin/otobo.psgi

    # Starman
    plackup --server Starman bin/psgi-bin/otobo.psgi

=head1 DESCRIPTION

A PSGI application.

=head1 Profiling

To profile single requests, install Devel::NYTProf and start this script as
PERL5OPT=-d:NYTProf NYTPROF='trace=1:start=no' plackup bin/psgi-bin/otobo.psgi
then append &NYTProf=mymarker to a request.
This creates a file called nytprof-mymarker.out, which you can process with
nytprofhtml -f nytprof-mymarker.out
Then point your browser at nytprof/index.html

=cut

use strict;
use warnings;
use 5.24.0;

use lib '/opt/otobo/';
use lib '/opt/otobo/Kernel/cpan-lib';
use lib '/opt/otobo/Custom';


# core modules
use Data::Dumper;
use POSIX 'SEEK_SET';

# CPAN modules
use DateTime ();
use Template ();
use Encode qw(:all);
use CGI::PSGI ();
use CGI::Parse::PSGI ();
use CGI::Carp ();
use Plack::Builder;
use Plack::Middleware::ErrorDocument;
use Plack::Middleware::Header;
use Plack::App::File;
use Plack::App::CGIBin;
use Module::Refresh;

# for future use:
#use Plack::Middleware::CamelcadeDB;
#use Plack::Middleware::Expires;
#use Plack::Middleware::Debug;

# enable this if you use mysql
#use DBD::mysql ();
#use Kernel::System::DB::mysql;

# enable this if you use postgresql
#use DBD::Pg ();
#use Kernel::System::DB::postgresql;

# enable this if you use oracle
#use DBD::Oracle ();
#use Kernel::System::DB::oracle;

# OTOBO modules
use Kernel::System::Web::InterfaceAgent ();
use Kernel::System::Web::InterfaceCustomer ();
use Kernel::System::Web::InterfacePublic ();
use Kernel::System::Web::InterfaceInstaller ();
use Kernel::System::Web::InterfaceMigrateFromOTRS ();
use Kernel::GenericInterface::Provider;
use Kernel::System::ObjectManager;

# Preload Net::DNS if it is installed. It is important to preload Net::DNS because otherwise loading
#   could take more than 30 seconds.
eval { require Net::DNS };

# this might improve performance
CGI::PSGI->compile(':cgi');

print STDERR "PLEASE NOTE THAT PLACK SUPPORT IS AS OF MAY 2020 EXPERIMENTAL AND NOT SUPPORTED!\n";

# some pre- and postprocessing for the dynamic content
my $MiddleWare = sub {
    my $app = shift;

    return sub {
        my $env = shift;

        # Reload files in @INC that have changed since the last request.
        # This is a replacement for:
        #    PerlModule Apache2::Reload
        #    PerlInitHandler Apache2::Reload
        eval {
            Module::Refresh->refresh();
        };
        warn $@ if $@;

        # check whether this request runs under Devel::NYTProf
        my $ProfilingIsOn = 0;
        if ( $ENV{NYTPROF} && $ENV{QUERY_STRING} =~ m/NYTProf=([\w-]+)/ ) {
            $ProfilingIsOn = 1;
            DB::enable_profile("nytprof-$1.out");
        }

        # $env->{SCRIPT_NAME} contains the matching mountpoint. Can be e.g. '/otobo/' or '/otobo/index.pl'
        # $env->{PATH_INFO} contains the path after the $env->{SCRIPT_NAME}. Can be e.g. 'rpc.pl' or ''
        # The extracted OTOBOHandle is something like index.pl, customer.pl, or rpc.pl
        my ($OTOBOHandle) = ( $env->{SCRIPT_NAME} . $env->{PATH_INFO} ) =~ m{/([A-Za-z\-_]+\.pl)};

        # Fallback to agent login if we could not determine handle...
        if ( !defined $OTOBOHandle || ! -e "/opt/otobo/bin/cgi-bin/$OTOBOHandle" ) {
            $OTOBOHandle = 'index.pl';
        }

        # for further reference in $App
        $env->{'otobo.handle'} = $OTOBOHandle;

        # Populate $ENV{SCRIPT_NAME} as OTOBO needs it in some places.
        # TODO: This is almost certainly a misuse of $ENV{SCRIPT_NAME}
        $ENV{SCRIPT_NAME}      = $OTOBOHandle;
        $env->{SCRIPT_NAME}    = $OTOBOHandle;  # needed for Plack::App::CGIBin

        # do the work
        my $res = $app->($env);

        # clean up profiling, write the output file
        DB::finish_profile() if $ProfilingIsOn;

        return $res;
    };
};

# a port of index.pl to PSGI
my $App = builder {
    enable "Plack::Middleware::ErrorDocument",
        403 => '/otobo/index.pl';  # forbidden files

    # do some pre- and postprocessing in an inline middleware
    enable $MiddleWare;

    sub {
        my $env = shift;

        # set up the CGI-Object from the PSGI environemnt
        my $WebRequest = CGI::PSGI->new($env);

        # 0=off;1=on;
        my $Debug = 0;

        my $stdout  = IO::File->new_tmpfile;

        {
            my $saver = SelectSaver->new("::STDOUT");

            {
                # no need to bend STDIN, as input is handled by CGI::PSGI
                local *STDOUT = $stdout;
                local *STDERR = $env->{'psgi.errors'};

                my $OTOBOHandle = $env->{'otobo.handle'} // 'index.pl';

                # nph-genericinterface.pl has specific logging
                my @ObjectManagerArgs;
                if ( $OTOBOHandle eq 'npt-genericinterface.pl' ) {
                    push  @ObjectManagerArgs,
                        'Kernel::System::Log' => {
                            LogPrefix => 'GenericInterfaceProvider',
                        },
                }

                local $Kernel::OM = Kernel::System::ObjectManager->new(@ObjectManagerArgs);

                # find the relevant interface class
                my $Interface;
                {
                    if ( $OTOBOHandle eq 'index.pl' ) {
                        $Interface = Kernel::System::Web::InterfaceAgent->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    elsif ( $OTOBOHandle eq 'customer.pl' ) {
                        $Interface = Kernel::System::Web::InterfaceCustomer->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    elsif ( $OTOBOHandle eq 'public.pl' ) {
                        $Interface = Kernel::System::Web::InterfacePublic->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    elsif ( $OTOBOHandle eq 'installer.pl' ) {
                        $Interface = Kernel::System::Web::InterfaceInstaller->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    elsif ( $OTOBOHandle eq 'migration.pl' ) {
                        $Interface = Kernel::System::Web::InterfaceMigrateFromOTRS->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    elsif ( $OTOBOHandle eq 'nph-genericinterface.pl' ) {
                        $Interface = Kernel::GenericInterface::Provider->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                    else {

                        # fallback
                        $Interface //= Kernel::System::Web::InterfaceAgent->new(
                            Debug      => $Debug,
                            WebRequest => $WebRequest,
                        );
                    }
                }

                # do the work
                $Interface->Run;
            }
        }

        # start reading the output from the start
        seek( $stdout, 0, SEEK_SET ) or croak("Can't seek stdout handle: $!");

        my $res = CGI::Parse::PSGI::parse_cgi_output($stdout);

        return $res;
    };
};

builder {
    # Server the static files in var/httpd/httpd.
    # Same as: Alias /otobo-web/ "/opt/otobo/var/httpd/htdocs/"
    # Access is granted for all.
    # Set the Cache-Control headers as in apache2-httpd.include.conf
    mount '/otobo-web' => builder {

            # Cache css-cache for 30 days
            enable_if { $_[0]->{PATH_INFO} =~ m{skins/.*/.*/css-cache/.*\.(?:css|CSS)$} } 'Header', set => [ 'Cache-Control' => 'max-age=2592000 must-revalidate' ];

            # Cache css thirdparty for 4 hours, including icon fonts
            enable_if { $_[0]->{PATH_INFO} =~ m{skins/.*/.*/css/thirdparty/.*\.(?:css|CSS|woff|svn)$} } 'Header', set => [ 'Cache-Control' => 'max-age=14400 must-revalidate' ];

            # Cache js-cache for 30 days
            enable_if { $_[0]->{PATH_INFO} =~ m{js/js-cache/.*\.(?:js|JS)$} } 'Header', set => [ 'Cache-Control' => 'max-age=2592000 must-revalidate' ];

            # Cache js thirdparty for 4 hours
            enable_if { $_[0]->{PATH_INFO} =~ m{js/thirdparty/.*\.(?:js|JS)$} } 'Header', set => [ 'Cache-Control' => 'max-age=14400 must-revalidate' ];

            Plack::App::File->new(root => '/opt/otobo/var/httpd/htdocs')->to_app;
        };

    # Port of index.pl, customer.pl to Plack
    mount '/otobo/index.pl'    => $App;
    mount '/otobo/customer.pl' => $App;

    # Serve the remaining CGI-scripts in bin/cgi-bin.
    # Same as: ScriptAlias /otobo/ "/opt/otobo/bin/cgi-bin/"
    # Access checking is done by the application.
    mount '/otobo'     => builder {

        # do some pre- and postprocessing in an inline middleware
        enable $MiddleWare;

        enable "Plack::Middleware::ErrorDocument",
            403 => '/otobo/index.pl';  # forbidden files

        # Execute the scripts in the appropriate environment.
        # The scripts are actually compiled by CGI::Compile,
        # CGI::initialize_globals() is called implicitly.
        Plack::App::CGIBin->new(root => '/opt/otobo/bin/cgi-bin')->to_app;
    };
};
