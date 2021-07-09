#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

=head1 NAME

otobo.psgi - OTOBO PSGI application

=head1 SYNOPSIS

    # using the default webserver
    plackup bin/psgi-bin/otobo.psgi

    # using the webserver Gazelle
    plackup --server Gazelle bin/psgi-bin/otobo.psgi

    # new process for every request , useful for development
    plackup --server Shotgun bin/psgi-bin/otobo.psgi

    # with profiling (untested)
    PERL5OPT=-d:NYTProf NYTPROF='trace=1:start=no' plackup bin/psgi-bin/otobo.psgi

=head1 DESCRIPTION

A PSGI application.

=head1 DEPENDENCIES

There are some requirements for running this application. Do something like the commands used
in F<otobo.web.dockerfile>.

    cp cpanfile.docker cpanfile
    cpanm --local-lib local Carton Net::DNS Gazelle
    cpanm --local-lib local --force XMLRPC::Transport::HTTP Net::Server Linux::Inotify2
    PERL_CPANM_OPT="--local-lib /opt/otobo_install/local" carton install

=head1 Profiling

To profile single requests, install Devel::NYTProf and start this script as:

    PERL5OPT=-d:NYTProf NYTPROF='trace=1:start=no' plackup bin/psgi-bin/otobo.psgi

For actual profiling append C<&NYTProf=mymarker> to a request.
This creates a file called nytprof-mymarker.out, which you can process with

    nytprofhtml -f nytprof-mymarker.out

Then point your browser at nytprof/index.html.

=cut

use strict;
use warnings;
use v5.24;
use utf8;

# expect that otobo.psgi is two level below the OTOBO root dir
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

## nofilter(TidyAll::Plugin::OTOBO::Perl::Dumper)
## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
## nofilter(TidyAll::Plugin::OTOBO::Perl::SyntaxCheck)
## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

# This package is used by rpc.pl.
# NOTE: this is mostly untested
package OTOBO::RPC {

    use Kernel::System::ObjectManager;

    sub new {
        my $Self = shift;

        my $Class = ref($Self) || $Self;

        return bless {} => $Class;
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
        ## nofilter(TidyAll::Plugin::OTOBO::Migrations::OTOBO10::TimeObject)
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
use CGI       ();
use CGI::Carp ();
use CGI::PSGI;
use Module::Refresh;
use Plack::Builder;
use Plack::Request;
use Plack::Response;
use Plack::App::File;
use SOAP::Transport::HTTP::Plack;

#use Data::Peek; # for development

# OTOBO modules
use Kernel::GenericInterface::Provider;
use Kernel::System::ObjectManager;
use Kernel::System::Web::InterfaceAgent           ();
use Kernel::System::Web::InterfaceCustomer        ();
use Kernel::System::Web::InterfaceInstaller       ();
use Kernel::System::Web::InterfaceMigrateFromOTRS ();
use Kernel::System::Web::InterfacePublic          ();

# Preload Net::DNS if it is installed. It is important to preload Net::DNS because otherwise loading
#   could take more than 30 seconds.
eval {
    require Net::DNS;
};

# this might improve performance
CGI->compile(':cgi');

################################################################################
# Middlewares
################################################################################

# conditionally enable profiling, UNTESTED
my $NYTProfMiddleWare = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # check whether this request runs under Devel::NYTProf
        my $ProfilingIsOn = 0;
        if ( $ENV{NYTPROF} && $Env->{QUERY_STRING} =~ m/NYTProf=([\w-]+)/ ) {
            $ProfilingIsOn = 1;
            DB::enable_profile("nytprof-$1.out");
        }

        # do the work
        my $Res = $App->($Env);

        # clean up profiling, write the output file
        DB::finish_profile() if $ProfilingIsOn;

        return $Res;
    };
};

# Set some entries in %ENV.
# GATEWAY_INTERFACE is used for determining whether a command runs in a web context
# Per default it would enable mysql_auto_reconnect.
# But mysql_auto_reconnect is explicitly disabled in Kernel::System::DB::mysql.
# OTOBO_RUNS_UNDER_PSGI indicates that PSGI is used.
my $SetEnvMiddleWare = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # only the side effects are important
        local $ENV{OTOBO_RUNS_UNDER_PSGI} = '1';
        local $ENV{GATEWAY_INTERFACE}     = 'CGI/1.1';

        # enable for debugging UrlMap
        #local $ENV{PLACK_URLMAP_DEBUG} = 1;

        return $App->($Env);
    };
};

# Fix for environment settings in the FCGI-Proxy case.
# E.g. when apaches2-httpd-fcgi.include.conf is used.
my $FixFCGIProxyMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # In the apaches2-httpd-fcgi.include.conf case all incoming request should be handled.
        # This means that otobo.psgi expects that SCRIPT_NAME is either '' or '/' and that
        # PATH_INFO is something like '/otobo/index.pl'.
        # But we get PATH_INFO = '' and SCRIPT_NAME = '/otobo/index.pl'.
        if ( $Env->{PATH_INFO} eq '' && ( $Env->{SCRIPT_NAME} ne '' && $Env->{SCRIPT_NAME} ne '/' ) ) {
            ( $Env->{PATH_INFO}, $Env->{SCRIPT_NAME} ) = ( $Env->{SCRIPT_NAME}, '/' );
        }

        return $App->($Env);
    };
};

# Translate '/' is translated to '/index.html'
my $ExactlyRootMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        if ( $Env->{PATH_INFO} eq '' || $Env->{PATH_INFO} eq '/' ) {
            $Env->{PATH_INFO} = '/index.html';
        }

        return $App->($Env);
    };
};

# This is inspired by Plack::Middleware::Refresh. But we roll our own middleware,
# as OTOOB has special requirements.
# The modules in Kernel/Config/Files must be exempted from the reloading
# as it is OK when they are removed. These not removed modules are reloaded
# for every request in Kernel::Config::Defaults::new().
my $ModuleRefreshMiddleware;
{
    my $RefreshCooldown = 10;
    my $LastRefreshTime = time - 10;
    Module::Refresh->new();

    $ModuleRefreshMiddleware = sub {
        my $App = shift;

        return sub {
            my $Env = shift;

            # don't do work for every request, just every $RefreshCooldown secondes
            if ( time > $LastRefreshTime + $RefreshCooldown ) {

                $LastRefreshTime = time;

                # refresh modules, igoring the files in Kernel/Config/Files
                MODULE:
                for my $Module ( sort keys %INC ) {
                    next MODULE if $Module =~ m[^Kernel/Config/Files/];

                    Module::Refresh->refresh_module_if_modified($Module);
                }
            }

            return $App->($Env);
        };
    };
}

################################################################################
# Apps
################################################################################

# The most basic App, no permission check
my $HelloApp = sub {
    my $Env = shift;

    # Initially $Message is a string with active UTF8-flag.
    # But turn it into a byte array, at that is wanted by Plack.
    # The actual bytes are not changed.
    my $Message = "Hallo 🌍!";
    utf8::encode($Message);

    return [
        '200',
        [ 'Content-Type' => 'text/plain;charset=utf-8' ],
        [$Message],
    ];
};

# Sometimes useful for debugging, no permission check
my $DumpEnvApp = sub {
    my $Env = shift;

    # collect some useful info
    local $Data::Dumper::Sortkeys = 1;
    my $Message = Data::Dumper->Dump(
        [ "DumpEnvApp:", scalar localtime, $Env, \%ENV, \@INC, \%INC, '🦦' ],
        [qw(Title Time Env ENV INC_array INC_hash otter)],
    );

    # add some unicode
    $Message .= "unicode: 🦦 ⛄ 🥨\n";

    # emit the content as UTF-8
    utf8::encode($Message);

    return [
        '200',
        [ 'Content-Type' => 'text/plain;charset=utf-8' ],
        [$Message],
    ];
};

# Handler andler for 'otobo', 'otobo/', 'otobo/not_existent', 'otobo/some/thing' and such.
# Would also work for /dummy if mounted accordingly.
# Redirect via a relative URL to otobo/index.pl.
# No permission check,
my $RedirectOtoboApp = sub {
    my $Env = shift;

    # construct a relative path to otobo/index.pl
    my $Req      = Plack::Request->new($Env);
    my $OrigPath = $Req->path();
    my $Levels   = $OrigPath =~ tr[/][];
    my $NewPath  = join '/', map( {'..'} ( 1 .. $Levels ) ), 'otobo/index.pl';

    # redirect
    my $Res = Plack::Response->new();
    $Res->redirect($NewPath);

    # send the PSGI response
    return $Res->finalize();
};

# Server the static files in var/httpd/httpd.
# Same as: Alias /otobo-web/ "/opt/otobo/var/httpd/htdocs/"
# Access is granted for all.
# Set the Cache-Control headers as in apache2-httpd.include.conf
my $StaticApp = builder {

    # Cache css-cache for 30 days
    enable_if { $_[0]->{PATH_INFO} =~ m{skins/.*/.*/css-cache/.*\.(?:css|CSS)$} } 'Plack::Middleware::Header',
        set => [ 'Cache-Control' => 'max-age=2592000 must-revalidate' ];

    # Cache css thirdparty for 4 hours, including icon fonts
    enable_if { $_[0]->{PATH_INFO} =~ m{skins/.*/.*/css/thirdparty/.*\.(?:css|CSS|woff|svn)$} } 'Plack::Middleware::Header',
        set => [ 'Cache-Control' => 'max-age=14400 must-revalidate' ];

    # Cache js-cache for 30 days
    enable_if { $_[0]->{PATH_INFO} =~ m{js/js-cache/.*\.(?:js|JS)$} } 'Plack::Middleware::Header',
        set => [ 'Cache-Control' => 'max-age=2592000 must-revalidate' ];

    # Cache js thirdparty for 4 hours
    enable_if { $_[0]->{PATH_INFO} =~ m{js/thirdparty/.*\.(?:js|JS)$} } 'Plack::Middleware::Header',
        set => [ 'Cache-Control' => 'max-age=14400 must-revalidate' ];

    Plack::App::File->new( root => "$FindBin::Bin/../../var/httpd/htdocs" )->to_app();
};

# Port of customer.pl, index.pl, installer.pl, migration.pl, nph-genericinterface.pl, and public.pl to Plack.
my $OTOBOApp = builder {

    # compress the output
    # do not enable 'Plack::Middleware::Deflater', as there were errors with 'Wide characters in print'
    #enable 'Plack::Middleware::Deflater',
    #    content_type => [ 'text/html', 'text/javascript', 'application/javascript', 'text/css', 'text/xml', 'application/json', 'text/json' ];

    # a simplistic detection whether we are behind a revers proxy
    enable_if { $_[0]->{HTTP_X_FORWARDED_HOST} } 'Plack::Middleware::ReverseProxy';

    # conditionally enable profiling
    enable $NYTProfMiddleWare;

    # set %ENV
    enable $SetEnvMiddleWare;

    # Check ever 10s for changed Perl modules.
    # Exclude the modules in Kernel/Config/Files as these modules
    # are already reloaded Kernel::Config::Defaults::new().
    enable $ModuleRefreshMiddleware;

    # we might catch an instance of Kernel::System::Web::Exception
    enable 'Plack::Middleware::HTTPExceptions';

    # No need to set %ENV or redirect STDIN.
    # But STDOUT and STDERR is still like in CGI scripts.
    # logic taken from the scripts in bin/cgi-bin and from CGI::Emulate::PSGI
    sub {
        my $Env = shift;

        # make sure to have a clean CGI.pm for each request, see CGI::Compile
        CGI::initialize_globals() if defined &CGI::initialize_globals;

        # this setting is only used by a test page
        $Env->{SERVER_SOFTWARE} //= 'otobo.psgi';

        # $Env->{SCRIPT_NAME} contains the matching mountpoint. Can be e.g. '/otobo' or '/otobo/index.pl'
        # $Env->{PATH_INFO} contains the path after the $Env->{SCRIPT_NAME}. Can be e.g. '/index.pl' or ''
        # The extracted ScriptFileName should be something like:
        #     customer.pl, index.pl, installer.pl, migration.pl, nph-genericinterface.pl, or public.pl
        # Note the only the last part of the mount is considered. This means that e.g. duplicated '/'
        # are gracefully ignored.
        my ($ScriptFileName) = ( ( $Env->{SCRIPT_NAME} // '' ) . ( $Env->{PATH_INFO} // '' ) ) =~ m{/([A-Za-z\-_]+\.pl)};

        # Fallback to agent login if we could not determine handle...
        $ScriptFileName //= 'index.pl';

        # params for the interface modules
        my %InterfaceParams = (
            Debug   => 0,      # pass 1 for enabling debug messages
            PSGIEnv => $Env,
        );

        # InterfaceInstaller has been converted to returning a string instead of printing the STDOUT.
        # This means that we don't have to capture STDOUT.
        # Headers are set in the 'Kernel::System::Web::Response' object.
        {
            # make sure that the managed objects will be recreated for the current request
            local $Kernel::OM = Kernel::System::ObjectManager->new();

            # do the work, return a not encoded Perl string from the appropriate interface module to Plack
            my $Content = eval {

                if ( $ScriptFileName eq 'customer.pl' ) {
                    return Kernel::System::Web::InterfaceCustomer->new(%InterfaceParams);
                }

                if ( $ScriptFileName eq 'index.pl' ) {
                    return Kernel::System::Web::InterfaceAgent->new(%InterfaceParams);
                }

                if ( $ScriptFileName eq 'installer.pl' ) {
                    return Kernel::System::Web::InterfaceInstaller->new(%InterfaceParams);
                }

                if ( $ScriptFileName eq 'migration.pl' ) {
                    return Kernel::System::Web::InterfaceMigrateFromOTRS->new(%InterfaceParams);
                }

                if ( $ScriptFileName eq 'nph-genericinterface.pl' ) {
                    return Kernel::GenericInterface::Provider->new(%InterfaceParams);
                }

                if ( $ScriptFileName eq 'public.pl' ) {
                    return Kernel::System::Web::InterfacePublic->new(%InterfaceParams);
                }

                # index.pl is the fallback
                warn " using fallback InterfaceAgent for ScriptFileName: '$ScriptFileName'\n";

                return Kernel::System::Web::InterfaceAgent->new(%InterfaceParams);
            }->Content();

            # Apply output filters for specific interfaces.
            # The output filters still work with proper Perl strings.
            my %HasOutputFilter = (
                'customer.pl' => 1,
                'index.pl'    => 1,
                'public.pl'   => 1,
            );

            if ( $HasOutputFilter{$ScriptFileName} ) {
                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

                $LayoutObject->ApplyOutputFilters( Output => \$Content );
            }

            # The OTOBO response object already has the HTPP headers.
            # Enhance it with the HTTP status code and the content.
            # Keep the HTTP status code when it already was set.
            # Otherwise assume that the request was successful and set the code to 200.
            # The content is UTF-8 encoded. This is in line with the header
            #   'Content-Type'    => 'text/html; charset=utf-8'
            # which was added Kernel::Output::HTML::Layout::_AddHeadersToResponseOBject().
            my $ResponseObject = $Kernel::OM->Get('Kernel::System::Web::Response');
            $ResponseObject->Code(200) unless $ResponseObject->Code();
            utf8::encode($Content);
            $ResponseObject->Content($Content);

            # for debugging: warn DDump( $ResponseObject->{Response}->{body} )

            # return the PSGI response, a funnny unblessed array reference with three elements
            return $ResponseObject->Finalize();
        }
    };
};

# Port of rpc.pl
# See http://blogs.perl.org/users/confuseacat/2012/11/how-to-use-soaptransporthttpplack.html
# TODO: this is not tested yet.
# TODO: There can be problems when the wrapped objects expect a CGI environment.
my $Soap = SOAP::Transport::HTTP::Plack->new();

my $RPCApp = builder {

    # GATEWAY_INTERFACE is used for determining whether a command runs in a web context
    # OTOBO_RUNS_UNDER_PSGI is a signal that PSGI is used
    enable 'Plack::Middleware::ForceEnv',
        OTOBO_RUNS_UNDER_PSGI => '1',
        GATEWAY_INTERFACE     => 'CGI/1.1';

    sub {
        my $Env = shift;

        return $Soap->dispatch_to(
            'OTOBO::RPC'
        )->handler( Plack::Request->new($Env) );
    };
};

################################################################################
# finally, the complete PSGI application itself
################################################################################

builder {

    # for debugging
    #enable 'Plack::Middleware::TrafficLog';

    # fiddling with '/'
    enable $ExactlyRootMiddleware;

    # fixing PATH_INFO
    enable_if { ( $_[0]->{FCGI_ROLE} // '' ) eq 'RESPONDER' } $FixFCGIProxyMiddleware;

    # Server the static files in var/httpd/httpd.
    mount '/otobo-web' => $StaticApp;

    # uncomment for trouble shooting
    #mount '/hello'          => $HelloApp;
    #mount '/dump_env'       => $DumpEnvApp;
    #mount '/otobo/hello'    => $HelloApp;
    #mount '/otobo/dump_env' => $DumpEnvApp;

    # Provide routes that are the equivalents of the scripts in bin/cgi-bin.
    # The pathes are such that $Env->{SCRIPT_NAME} and $Env->{PATH_INFO} are set up just like they are set up under mod_perl,
    mount '/otobo'                         => $RedirectOtoboApp;    # redirect to /otobo/index.pl when in doubt
    mount '/otobo/customer.pl'             => $OTOBOApp;
    mount '/otobo/index.pl'                => $OTOBOApp;
    mount '/otobo/installer.pl'            => $OTOBOApp;
    mount '/otobo/migration.pl'            => $OTOBOApp;
    mount '/otobo/nph-genericinterface.pl' => $OTOBOApp;
    mount '/otobo/public.pl'               => $OTOBOApp;

    # some SOAP stuff
    mount '/otobo/rpc.pl' => $RPCApp;

    # some static pages, '/' is already translate to '/index.html'
    mount "/robots.txt" => Plack::App::File->new( file => "$FindBin::Bin/../../var/httpd/htdocs/robots.txt" )->to_app();
    mount "/index.html" => Plack::App::File->new( file => "$FindBin::Bin/../../var/httpd/htdocs/index.html" )->to_app();
};

# enable for debugging: dump debugging info, including the PSGI environment, for any request
#$DumpEnvApp;
