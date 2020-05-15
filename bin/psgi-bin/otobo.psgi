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

# this package is used for rpc.pl
package OTOBO::RPC {
    use Kernel::System::ObjectManager;

    sub new {
        my $Self = shift;

        my $Class = ref($Self) || $Self;
        bless {} => $Class;

        return $Self;
    }

    sub Dispatch {
        my ( $Self, $User, $Pw, $Object, $Method, %Param ) = @_;

        $User ||= '';
        $Pw   ||= '';
        local $Kernel::OM = Kernel::System::ObjectManager->new(
            'Kernel::System::Log' => {
                LogPrefix => 'OTOBO-RPC',
            },
        );

        my %CommonObject;

        $CommonObject{ConfigObject}          = $Kernel::OM->Get('Kernel::Config');
        $CommonObject{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        $CommonObject{CustomerUserObject}    = $Kernel::OM->Get('Kernel::System::CustomerUser');
        $CommonObject{EncodeObject}          = $Kernel::OM->Get('Kernel::System::Encode');
        $CommonObject{GroupObject}           = $Kernel::OM->Get('Kernel::System::Group');
        $CommonObject{LinkObject}            = $Kernel::OM->Get('Kernel::System::LinkObject');
        $CommonObject{LogObject}             = $Kernel::OM->Get('Kernel::System::Log');
        $CommonObject{PIDObject}             = $Kernel::OM->Get('Kernel::System::PID');
        $CommonObject{QueueObject}           = $Kernel::OM->Get('Kernel::System::Queue');
        $CommonObject{SessionObject}         = $Kernel::OM->Get('Kernel::System::AuthSession');
        $CommonObject{TicketObject}          = $Kernel::OM->Get('Kernel::System::Ticket');

        # We want to keep providing the TimeObject as legacy API for now.
        ## nofilter(TidyAll::Plugin::OTOBO::Migrations::OTOBO6::TimeObject)
        $CommonObject{TimeObject} = $Kernel::OM->Get('Kernel::System::Time');
        $CommonObject{UserObject} = $Kernel::OM->Get('Kernel::System::User');

        my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
        my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

        if (
            !defined $RequiredUser
            || !length $RequiredUser
            || !defined $RequiredPassword || !length $RequiredPassword
            )
        {
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
            );
            return;
        }

        if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Auth for user $User (pw $Pw) failed!",
            );
            return;
        }

        if ( !$CommonObject{$Object} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "No such Object $Object!",
            );
            return "No such Object $Object!";
        }

        return $CommonObject{$Object}->$Method(%Param);
    }

=item DispatchMultipleTicketMethods()

to dispatch multiple ticket methods and get the TicketID

    my $TicketID = $RPC->DispatchMultipleTicketMethods(
        $SOAP_User,
        $SOAP_Pass,
        'TicketObject',
        [ { Method => 'TicketCreate', Parameter => \%TicketData }, { Method => 'ArticleCreate', Parameter => \%ArticleData } ],
    );

=cut

    sub DispatchMultipleTicketMethods {
        my ( $Self, $User, $Pw, $Object, $MethodParamArrayRef ) = @_;

        $User ||= '';
        $Pw   ||= '';

        # common objects
        local $Kernel::OM = Kernel::System::ObjectManager->new(
            'Kernel::System::Log' => {
                LogPrefix => 'OTOBO-RPC',
            },
        );

        my %CommonObject;

        $CommonObject{ConfigObject}          = $Kernel::OM->Get('Kernel::Config');
        $CommonObject{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        $CommonObject{CustomerUserObject}    = $Kernel::OM->Get('Kernel::System::CustomerUser');
        $CommonObject{EncodeObject}          = $Kernel::OM->Get('Kernel::System::Encode');
        $CommonObject{GroupObject}           = $Kernel::OM->Get('Kernel::System::Group');
        $CommonObject{LinkObject}            = $Kernel::OM->Get('Kernel::System::LinkObject');
        $CommonObject{LogObject}             = $Kernel::OM->Get('Kernel::System::Log');
        $CommonObject{PIDObject}             = $Kernel::OM->Get('Kernel::System::PID');
        $CommonObject{QueueObject}           = $Kernel::OM->Get('Kernel::System::Queue');
        $CommonObject{SessionObject}         = $Kernel::OM->Get('Kernel::System::AuthSession');
        $CommonObject{TicketObject}          = $Kernel::OM->Get('Kernel::System::Ticket');
        $CommonObject{TimeObject}            = $Kernel::OM->Get('Kernel::System::Time');
        $CommonObject{UserObject}            = $Kernel::OM->Get('Kernel::System::User');

        my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
        my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

        if (
            !defined $RequiredUser
            || !length $RequiredUser
            || !defined $RequiredPassword || !length $RequiredPassword
            )
        {
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
            );
            return;
        }

        if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Auth for user $User (pw $Pw) failed!",
            );
            return;
        }

        if ( !$CommonObject{$Object} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "No such Object $Object!",
            );
            return "No such Object $Object!";
        }

        my $TicketID;
        my $Counter;

        for my $MethodParamEntry ( @{$MethodParamArrayRef} ) {

            my $Method    = $MethodParamEntry->{Method};
            my %Parameter = %{ $MethodParamEntry->{Parameter} };

            # push ticket id to params if there is no ticket id
            if ( !$Parameter{TicketID} && $TicketID ) {
                $Parameter{TicketID} = $TicketID;
            }

            my $ReturnValue = $CommonObject{$Object}->$Method(%Parameter);

            # remember ticket id if method was TicketCreate
            if ( !$Counter && $Object eq 'TicketObject' && $Method eq 'TicketCreate' ) {
                $TicketID = $ReturnValue;
            }

            $Counter++;
        }

        return $TicketID;
    }
}


# core modules
use Data::Dumper;

# CPAN modules
use DateTime ();
use Template ();
use Encode qw(:all);
use CGI ();
use CGI::Carp ();
use CGI::Emulate::PSGI ();
use Module::Refresh;
use Plack::Builder;
use Plack::Middleware::ErrorDocument;
use Plack::Middleware::Header;
use Plack::Middleware::ForceEnv;
use Plack::App::File;
use SOAP::Transport::HTTP::Plack;

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
CGI->compile(':cgi');

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

        # $env->{SCRIPT_NAME} contains the matching mountpoint. Can be e.g. '/otobo' or '/otobo/index.pl'
        # $env->{PATH_INFO} contains the path after the $env->{SCRIPT_NAME}. Can be e.g. '/rpc.pl' or ''
        # The extracted ScriptFileName is something like index.pl, customer.pl, or rpc.pl
        my ($ScriptFileName) = ( $env->{SCRIPT_NAME} . $env->{PATH_INFO} ) =~ m{/([A-Za-z\-_]+\.pl)};

        # Fallback to agent login if we could not determine handle...
        if ( !defined $ScriptFileName || ! -e "/opt/otobo/bin/cgi-bin/$ScriptFileName" ) {
            $ScriptFileName = 'index.pl';
        }

        # for further reference in $App
        $env->{'otobo.script_file_name'} = $ScriptFileName;

        # do the work
        my $res = $app->($env);

        # clean up profiling, write the output file
        DB::finish_profile() if $ProfilingIsOn;

        return $res;
    };
};

# Port of index.pl, customer.pl, public.pl, installer.pl, migration.pl, nph-genericinterface.pl to Plack.
my $App = builder {

    enable "Plack::Middleware::ErrorDocument",
        403 => '/otobo/index.pl';  # forbidden files

    # GATEWAY_INTERFACE is used for determining whether a command runs in a web context
    # OTOBO_RUNS_UNDER_PSGI is a signal that PSGI is used
    enable ForceEnv =>
        OTOBO_RUNS_UNDER_PSGI => '1',
        GATEWAY_INTERFACE     => 'CGI/1.1';

    # do some pre- and postprocessing in an inline middleware
    enable $MiddleWare;

    # Set the appropriate %ENV and file handles
    CGI::Emulate::PSGI->handler(

        # logic taken from the scripts in bin/cgi-bin
        sub {
            my $env = shift;

            # make sure to have a clean CGI.pm for each request, see CGI::Compile
            CGI::initialize_globals() if defined &CGI::initialize_globals;

            # 0=off;1=on;
            my $Debug = 0;

            # set in $MiddleWare
            my $ScriptFileName = $env->{'otobo.script_file_name'} // 'index.pl';

            # nph-genericinterface.pl has specific logging
            my @ObjectManagerArgs;
            if ( $ScriptFileName eq 'nph-genericinterface.pl' ) {
                push  @ObjectManagerArgs,
                    'Kernel::System::Log' => {
                        LogPrefix => 'GenericInterfaceProvider',
                    },
            }

            local $Kernel::OM = Kernel::System::ObjectManager->new(@ObjectManagerArgs);

            # find the relevant interface class
            my $Interface;
            {
                if ( $ScriptFileName eq 'index.pl' ) {
                    $Interface = Kernel::System::Web::InterfaceAgent->new(
                        Debug      => $Debug,
                    );
                }
                elsif ( $ScriptFileName eq 'customer.pl' ) {
                    $Interface = Kernel::System::Web::InterfaceCustomer->new(
                        Debug      => $Debug,
                    );
                }
                elsif ( $ScriptFileName eq 'public.pl' ) {
                    $Interface = Kernel::System::Web::InterfacePublic->new(
                        Debug      => $Debug,
                    );
                }
                elsif ( $ScriptFileName eq 'installer.pl' ) {
                    $Interface = Kernel::System::Web::InterfaceInstaller->new(
                        Debug      => $Debug,
                    );
                }
                elsif ( $ScriptFileName eq 'migration.pl' ) {
                    $Interface = Kernel::System::Web::InterfaceMigrateFromOTRS->new(
                        Debug      => $Debug,
                    );
                }
                elsif ( $ScriptFileName eq 'nph-genericinterface.pl' ) {
                    $Interface = Kernel::GenericInterface::Provider->new();
                }
                else {

                    # fallback
                    $Interface = Kernel::System::Web::InterfaceAgent->new(
                        Debug      => $Debug,
                    );
                }
            }

            # do the work
            $Interface->Run;
        }
    );
};


# Port of rpc.pl
# See http://blogs.perl.org/users/confuseacat/2012/11/how-to-use-soaptransporthttpplack.html
my $soap = SOAP::Transport::HTTP::Plack->new;

my $RPCApp = builder {

    # GATEWAY_INTERFACE is used for determining whether a command runs in a web context
    # OTOBO_RUNS_UNDER_PSGI is a signal that PSGI is used
    enable ForceEnv =>
        OTOBO_RUNS_UNDER_PSGI => '1',
        GATEWAY_INTERFACE     => 'CGI/1.1';

    sub {
        my $env = shift;

        return $soap->dispatch_to(
                'OTOBO::RPC'
            )->handler( Plack::Request->new( $env ) );
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

    # Wrap the CGI-scripts in bin/cgi-bin.
    # The pathes are explicit so the $ENV{SCRIPT_NAME} is set the same way as under mod_perl
    mount '/otobo/index.pl'                => $App;
    mount '/otobo/customer.pl'             => $App;
    mount '/otobo/public.pl'               => $App;
    mount '/otobo/installer.pl'            => $App;
    mount '/otobo/migration.pl'            => $App;
    mount '/otobo/nph-genericinterface.pl' => $App;
    mount '/otobo/rpc.pl'                  => $RPCApp;
};
