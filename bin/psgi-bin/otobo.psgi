#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

=head1 DESCRIPTION

A PSGI application.

=head1 DEPENDENCIES

There are some requirements for running this application. Do something like the commands used
in F<otobo.web.dockerfile>.

    cp cpanfile.docker cpanfile
    cpanm --local-lib local Carton
    PERL_CPANM_OPT="--local-lib /opt/otobo_install/local" carton install

=head1 Profiling

In order to activate profiling install L<Plack::Middleware::Profiler::NYTProf>
and activate profiling by assigning C<$ProfilingIsActive> a true value. There is no need
to start Plack with special options or with a special environment.

See L<https://metacpan.org/pod/Plack::Middleware::Profiler::NYTProf> for the available options.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# expect that otobo.psgi is two level below the OTOBO home dir
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
## nofilter(TidyAll::Plugin::OTOBO::Perl::SyntaxCheck)
## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

# core modules
use Cwd            qw(abs_path);
use Data::Dumper   ();              ## no critic qw(Modules::ProhibitEvilModules)
use Encode         ();              ## no perlimports
use File::Basename qw(dirname);
use File::Path     qw(make_path);

# CPAN modules
use DateTime 1.08    ();                                   ## no perlimports
use Template         ();                                   ## no perlimports
use Plack::Builder   qw(builder enable enable_if mount);
use Plack::Request   ();
use Plack::Response  ();
use Plack::App::File ();
use Plack::App::Directory;

# OTOBO modules
use Kernel::Config;                                        # assure that Kernel/Config.pm exists, though the file might be modified later
use Kernel::System::ModuleRefresh ();                      # based on Module::Refresh
use Kernel::System::ObjectManager ();
use Kernel::System::Web::App      ();

# Preload Net::DNS if it is installed. It is important to preload Net::DNS because otherwise loading
#   could take more than 30 seconds.
eval {
    require Net::DNS;
};

# Put the modules in %INC into %Module::Refresh::CACHE.
# This is important for Kernel/Config.pm as that file might be modified by installer.pl
# between the start of the web server and the first use of $ModuleRefreshMiddleware or $SyncFromS3Middleware.
Kernel::System::ModuleRefresh->new;

# for activating profiling
my $ProfilingIsActive = 0;

# The OTOBO home is determined from the location of otobo.psgi.
my $Home = abs_path("$Bin/../..");

# The question whether there is a S3 backend must the resolved early.
# Beware that $S3Active won't be updated when S3 is activated afterwards.
my $S3Active = Kernel::Config->new( Level => 'Clear' )->Get('Storage::S3::Active');

# The S3 backend object will be needed in the SyncFromS3 middleware
if ($S3Active) {
    require Kernel::System::Storage::S3;
}

################################################################################
# Middlewares
################################################################################

# Set a single entry in %ENV.
# $ENV{GATEWAY_INTERFACE} is used for determining whether a command runs in a web context.
# This setting is used internally by Kernel::System::Log, and in the support data collector.
# In the CPAN module DBD::mysql, $ENV{GATEWAY_INTERFACE} would enable mysql_auto_reconnect.
# In order to counter that, mysql_auto_reconnect is explicitly disabled in Kernel::System::DB::mysql.
my $SetSystemEnvMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # only the side effects are important
        local $ENV{GATEWAY_INTERFACE} = 'CGI/1.1';

        # enable for debugging UrlMap
        #local $ENV{PLACK_URLMAP_DEBUG} = 1;

        return $App->($Env);
    };
};

# Set a single entry in the PSGI environment.
my $SetPSGIEnvMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # this setting is only used by a test page
        $Env->{SERVER_SOFTWARE} //= 'otobo.psgi';

        return $App->($Env);
    };
};

# Determine, and possibly munge, the script name.
# This needs to be done early, as access checking middlewares need that info.

# TODO: is this still relevant ?
# $Env->{SCRIPT_NAME} contains the matching mountpoint. Can be e.g. '/otobo' or '/otobo/index.pl'
# $Env->{PATH_INFO} contains the path after the $Env->{SCRIPT_NAME}. Can be e.g. '/index.pl' or ''
# The extracted ScriptFileName should be something like:
#     customer.pl, index.pl, installer.pl, migration.pl, nph-genericinterface.pl, or public.pl
# Note the only the last part of the mount is considered. This means that e.g. duplicated '/'
# are gracefully ignored.

# Force a new manifestation of $Kernel::OM.
# This middleware must be enabled before there is any access to the classes that are
# managed by the OTOBO object manager. Inversely this means that applications that follow this middleware
# can make use of $Kernel::OM, e.g $Kernel::OM->Get('Kernel::Config').
# Completion of the middleware destroys the localised $Kernel::OM, thus
# triggering event handlers.
my $ManageObjectsMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # make sure that the managed objects will be recreated for the current request
        local $Kernel::OM = Kernel::System::ObjectManager->new();

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

# Squash slashes just like Apache2 does when MergeSlashes is enabled.
# This is the default behaviour in Apache2 and in Nginx.
my $MergeSlashesMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # squash duplicate slashes
        $Env->{PATH_INFO} =~ s!/{2,}!/!g;

        return $App->($Env);
    };
};

# '/' is translated to '/index.html', just like Apache DirectoryIndex
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

# With S3 support, loader files are initially stored in S3.
# Sync them to the local file system so that Plack::App::File can deliver them.
# Checking the name is sufficient as the loader files contain a checksum.
my $SyncFromS3Middleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # We need a path like 'skins/Agent/default/css-cache/CommonCSS_1ecc5b62f0219ea138682633a165f251.css'
        # Double slashes are not ignored in S3.
        my $PathBelowHtdocs = $Env->{PATH_INFO};
        $PathBelowHtdocs =~ s!/$!!;
        $PathBelowHtdocs =~ s!^/!!;

        # The location on the file system is something like:
        # /opt/otobo/var/httpd/htdocs/skins/Customer/css-cache
        my $Location = "$Home/var/httpd/htdocs/$PathBelowHtdocs";

        if ( !-e $Location ) {

            # Use the same approach for static files as used in $ModuleRefreshMiddleware.
            # Check for every request whether Kernel/Config.pm has been modified
            Kernel::System::ModuleRefresh->refresh_module_if_modified('Kernel/Config.pm');

            # make sure that the directory where the object should be stored exists
            # make_path() croaks when the dir can't be created
            make_path( dirname($Location) );

            my $StorageS3Object = Kernel::System::Storage::S3->new(
                ConfigObject => Kernel::Config->new( Level => 'Clear' ),
            );
            my $S3Key = join '/', 'var/httpd/htdocs', $PathBelowHtdocs;
            $StorageS3Object->SaveObjectToFile(
                Key      => $S3Key,
                Location => $Location,
            );
        }

        return $App->($Env);
    };
};

# This middleware is inspired by Plack::Middleware::Refresh. But we roll our own implementation,
# as OTOOB has special requirements. All loaded modules are refreshed after a cooldown time
# of 10s has passed since the last refresh cycle.
#
# An exception is Kernel/Config.pm which is checked for every request. This is mostly for
# installer.pl and migration.pl which actually modify this file.
#
# The modules in Kernel/Config/Files must be exempted from the reloading
# as it is OK when they are changed or removed. These existing module files are reloaded
# for every request in Kernel::Config::Defaults::new().
my $ModuleRefreshMiddleware = sub {
    my $App = shift;

    return sub {
        my $Env = shift;

        # Fill %Module::Refresh::CACHE with all entries in %INC if that hasn't happened before.
        # Add $RelativeFile to %Module::Refresh::CACHE as $RelativeFile was required above and thus surely is in %INC.
        # Check for every request whether Kernel/Config.pm has been modified.
        Kernel::System::ModuleRefresh->refresh_module_if_modified('Kernel/Config.pm');

        # make sure that there is a refresh in the first iteration
        state $LastRefreshTime = 0;

        # don't do work for every request, just every $RefreshCooldown secondes
        my $Now                     = time;
        my $SecondsSinceLastRefresh = $Now - $LastRefreshTime;
        my $RefreshCooldown         = 10;

        # Maybe useful for debugging, these variables can be printed out in frontend modules.
        # See https://github.com/RotherOSS/otobo/issues/1422
        #$Kernel::Now = $Now;
        #$Kernel::SecondsSinceLastRefresh = $SecondsSinceLastRefresh;
        #$Kernel::LastRefreshTime         = $LastRefreshTime;

        if ( $SecondsSinceLastRefresh > $RefreshCooldown ) {

            $LastRefreshTime = $Now;

            # refresh modules,
            # igoring non-OTOBO modules, Kernel/Config.pm and the module files in Kernel/Config/Files
            MODULE:
            for my $Module ( sort keys %INC ) {
                next MODULE unless $Module =~ m[^(?:Kernel|var/packagesetup)/];
                next MODULE if $Module eq 'Kernel/Config.pm';
                next MODULE if $Module =~ m[^Kernel/Config/Files/];

                Kernel::System::ModuleRefresh->refresh_module_if_modified($Module);
            }
        }

        return $App->($Env);
    };
};

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

# Handler for 'otobo', 'otobo/', 'otobo/not_existent', 'otobo/some/thing' and such.
# Would also work for /dummy if mounted accordingly.
# Redirect via a relative URL to Frontend::DefaultInterface.
# There is no permission check.
my $RedirectOtoboApp = sub {
    my $Env = shift;

    # determine the default interface,
    # fall back to the Agent interface when the configured default interface is not activated.
    my $Interface = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::DefaultInterface') || 'index.pl';
    my $Active    = 1;
    if ( $Interface eq 'customer.pl' ) {
        $Active = $Kernel::OM->Get('Kernel::Config')->Get('CustomerFrontend::Active');
    }
    elsif ( $Interface eq 'public.pl' ) {
        $Active = $Kernel::OM->Get('Kernel::Config')->Get('PublicFrontend::Active');
    }

    if ( !$Active ) {
        $Interface = 'index.pl';
    }

    # Construct a relative path to the default interface.
    # In $OrigPath multiple sequential slashes seem to be collapsed to a single slash. This might result
    # in broken redirects. But it looks like the broken redirects are redirected again and finally
    # we end up in the default interface. All is fine as long we don't walk up too high, i.e. above 'otobo/'.
    my $Redirect;
    if ( $Env->{PATH_INFO} eq '' ) {

        # Special case for https://example.com/otobo . The path below 'otobo' is empty. So for redirecting
        # we needed information how we got here. Often REQUEST_URI is '/otobo' but this is not guaranteed.
        my ($LastComponent) = reverse split /\//, $Env->{REQUEST_URI};
        $Redirect = join '/', $LastComponent, $Interface;    # e.g. otobo/index.pl
    }
    else {

        # hike up the appropriate number of levels, e.g. '',  '..',  or '../../../..'
        my $OrigPath = Plack::Request->new($Env)->path;
        my $Levels   = $OrigPath =~ tr[/][];
        $Redirect = join '/', ( map {'..'} ( 1 .. ( $Levels - 1 ) ) ), $Interface;
    }

    # redirect
    my $Res = Plack::Response->new;
    $Res->redirect($Redirect);

    # send the PSGI response arrayref
    return $Res->finalize;
};

# Check whether PublicFrontend::Active is on. If so serve the public interface.
# Otherwise act as if the public interface does not exist and redirect to the default interface.
my $CheckPublicInterfaceApp = sub {
    my $Env = shift;

    my $Active = $Kernel::OM->Get('Kernel::Config')->Get('PublicFrontend::Active');

    return Kernel::System::Web::App->new(
        Interface => 'Kernel::System::Web::InterfacePublic',
    )->to_app->($Env) if $Active;

    # trick $RedirectOtoboApp into doing the right thing
    $Env->{PATH_INFO} = 'public.pl';

    return $RedirectOtoboApp->($Env);
};

# Check whether CustomerFrontend::Active is on. If so serve the customer interface.
# Otherwise act as if the customer interface does not exist and redirect to the default interface.
my $CheckCustomerInterfaceApp = sub {
    my $Env = shift;

    my $Active = $Kernel::OM->Get('Kernel::Config')->Get('CustomerFrontend::Active');

    return Kernel::System::Web::App->new(
        Interface => 'Kernel::System::Web::InterfaceCustomer',
    )->to_app->($Env) if $Active;

    # trick $RedirectOtoboApp into doing the right thing
    $Env->{PATH_INFO} = 'customer.pl';

    return $RedirectOtoboApp->($Env);
};

# Serve the static assets in var/httpd/htdocs.
# When S3 is supported there is a check whether missing files can be fetched from S3.
# Access is granted for all.
my $HtdocsApp = builder {

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

    # loader files might have to be synced from S3
    enable_if {
        $S3Active
            &&
            (
                $_[0]->{PATH_INFO} =~ m{skins/.*/.*/css-cache/.*\.(?:css|CSS)$}
                ||
                $_[0]->{PATH_INFO} =~ m{js/js-cache/.*\.(?:js|JS)$}
            )
    }
    $SyncFromS3Middleware;

    Plack::App::File->new( root => "$Home/var/httpd/htdocs" )->to_app();
};

# Support for customer.pl, index.pl, installer.pl, migration.pl, nph-genericinterface.pl.
# Support for public.pl if PublicFrontend::Active is on.
# Redirect to Frontend::DefaultInterface as a fallback
my $OTOBOApp = builder {

    # compress the output
    # do not enable 'Plack::Middleware::Deflater', as there were errors with 'Wide characters in print'
    #enable 'Plack::Middleware::Deflater',
    #    content_type => [ 'text/html', 'text/javascript', 'application/javascript', 'text/css', 'text/xml', 'application/json', 'text/json' ];

    # a simplistic detection whether we are behinde a reverse proxy
    enable_if { $_[0]->{HTTP_X_FORWARDED_HOST} } 'Plack::Middleware::ReverseProxy';

    # enable profiling only when Plack::Middleware::Profiler::NYTProf is installed
    if ($ProfilingIsActive) {
        enable 'Profiler::NYTProf',

            #enable_profile => sub { return $Env->{QUERY_STRING} =~ m/NYTProf=([\w-]+)/ ? 1 : 0; }, # untested
            report_dir => sub { return 'var/httpd/htdocs/nytprof' },
            ;
    }

    # Check every 10s for changed Perl modules.
    # Exclude the modules in Kernel/Config/Files as these modules
    # are already reloaded Kernel::Config::Defaults::new().
    enable $ModuleRefreshMiddleware;

    # add the Content-Length header, unless it already is set
    # this applies also to content from Kernel::System::Web::Exception
    enable 'Plack::Middleware::ContentLength';

    # we might catch an instance of Kernel::System::Web::Exception
    enable 'Plack::Middleware::HTTPExceptions';

    # set up %ENV
    enable $SetSystemEnvMiddleware;

    # set up $Env
    enable $SetPSGIEnvMiddleware;

    # force destruction and recreation of managed objects
    enable $ManageObjectsMiddleware;

    # The actual functionality of OTOBO is implemented as a set of Plack apps.
    # Dispatching is done with an URL map.
    # Kernel::System::Web::App loads the interface modules and calls the Response() method.
    # Add "Debug => 1" in order to enable debugging.

    # enable for debugging
    #mount '/dump_env' => $DumpEnvApp;
    #mount '/hello'    => $HelloApp;

    mount '/index.pl' => Kernel::System::Web::App->new(
        Interface => 'Kernel::System::Web::InterfaceAgent',
    )->to_app;

    mount '/installer.pl' => builder {

        # check the SecureMode
        # Alternatively we could use Plack::Middleware::Access, but that modules is not available as a Debian package
        enable 'OTOBO::SecureModeAccessFilter',
            rules => [
                deny => 'securemode_is_on',
            ];

        Kernel::System::Web::App->new(
            Interface => 'Kernel::System::Web::InterfaceInstaller',
        )->to_app;
    };

    mount '/migration.pl' => builder {

        # check the SecureMode
        # Alternatively we could use Plack::Middleware::Access, but that modules is not available as a Debian package
        enable 'OTOBO::SecureModeAccessFilter',
            rules => [
                deny => 'securemode_is_on',
            ];

        Kernel::System::Web::App->new(
            Interface => 'Kernel::System::Web::InterfaceMigrateFromOTRS',
        )->to_app;
    };

    mount '/nph-genericinterface.pl' => Kernel::System::Web::App->new(
        Interface => 'Kernel::GenericInterface::Provider',
    )->to_app;

    # the following interfaces can be deactivated in the SysConfig
    mount '/customer.pl' => $CheckCustomerInterfaceApp;
    mount '/public.pl'   => $CheckPublicInterfaceApp;

    # redirect to Frontend::DefaultInterface when in doubt
    mount '/' => $RedirectOtoboApp;
};

################################################################################
# finally, the complete PSGI application itself
################################################################################

builder {

    # for debugging
    #enable 'Plack::Middleware::TrafficLog';

    # users can overwrite the 404 page
    # note that 404 below /otobo/ already redirects to Frontend::DefaultInterface
    enable "Plack::Middleware::ErrorDocument",
        404 => "$Home/var/httpd/htdocs/404.html";

    # fiddling with slashes
    enable $MergeSlashesMiddleware;
    enable $ExactlyRootMiddleware;

    # fixing PATH_INFO
    enable_if { ( $_[0]->{FCGI_ROLE} // '' ) eq 'RESPONDER' } $FixFCGIProxyMiddleware;

    # Server the static assets in var/httpd/htdocs.
    mount '/otobo-web' => $HtdocsApp;

    # Alternative mounts are also possible.
    # Note that Frontend::WebPath needs to be adapted when the path is changed.
    #mount '/otobo/assets' => $HtdocsApp;

    # uncomment for trouble shooting
    #mount '/hello'          => $HelloApp;
    #mount '/dump_env'       => $DumpEnvApp;

    # Provide routes that are the equivalents of the scripts in bin/cgi-bin.
    # The pathes are such that $Env->{SCRIPT_NAME} and $Env->{PATH_INFO} are set up just like they are set up under mod_perl,
    mount '/otobo' => $OTOBOApp;

    # some static pages, '/' is already translate to '/index.html'
    mount "/robots.txt" => Plack::App::File->new( file => "$Home/var/httpd/htdocs/robots.txt" )->to_app;
    mount "/index.html" => Plack::App::File->new( file => "$Home/var/httpd/htdocs/index.html" )->to_app;
    mount "/health"     => Plack::App::File->new( file => "$Home/var/httpd/htdocs/health" )->to_app;

    # only useful for profiling
    if ($ProfilingIsActive) {
        mount '/nytprof' => Plack::App::Directory->new( root => "$Home/var/httpd/htdocs/nytprof" )->to_app();
    }

    # otherwise an error 404 it thrown, which is handled by Plack::Middleware::ErrorDocument
};

# enable for debugging: dump debugging info, including the PSGI environment, for any request
#$DumpEnvApp;
