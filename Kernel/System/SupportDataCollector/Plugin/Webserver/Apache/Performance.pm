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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    # No web request or no apache webserver, skip this check.
    if ( !$ENV{GATEWAY_INTERFACE} || !$ENV{SERVER_SOFTWARE} || $ENV{SERVER_SOFTWARE} !~ m{apache}i ) {
        return $Self->GetResults();
    }

    # Check for CGI accelerator
    if ( $ENV{MOD_PERL} ) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => $ENV{MOD_PERL},
        );
    }
    elsif ( $INC{'CGI/Fast.pm'} || $ENV{FCGI_ROLE} || $ENV{FCGI_SOCKET_PATH} ) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => 'fastcgi',
        );
    }
    else {
        $Self->AddResultWarning(
            Identifier => "CGIAcceleratorUsed",
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => '',
            Message    => Translatable('You should use FastCGI or mod_perl to increase your performance.'),
        );
    }

    if ( $ENV{MOD_PERL} ) {
        my $ModDeflateLoaded =
            Apache2::Module::loaded('mod_deflate.c') || Apache2::Module::loaded('mod_deflate.so');

        if ($ModDeflateLoaded) {
            $Self->AddResultOk(
                Identifier => "ModDeflateLoaded",
                Label      => Translatable('mod_deflate Usage'),
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ModDeflateLoaded",
                Label      => Translatable('mod_deflate Usage'),
                Value      => 'not active',
                Message    => Translatable('Please install mod_deflate to improve GUI speed.'),
            );
        }

        my $ModFilterLoaded =
            Apache2::Module::loaded('mod_filter.c') || Apache2::Module::loaded('mod_filter.so');

        if ($ModFilterLoaded) {
            $Self->AddResultOk(
                Identifier => "ModFilterLoaded",
                Label      => Translatable('mod_filter Usage'),
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ModFilterLoaded",
                Label      => Translatable('mod_filter Usage'),
                Value      => 'not active',
                Message    => Translatable('Please install mod_filter if mod_deflate is used.'),
            );
        }

        my $ModHeadersLoaded =
            Apache2::Module::loaded('mod_headers.c') || Apache2::Module::loaded('mod_headers.so');

        if ($ModHeadersLoaded) {
            $Self->AddResultOk(
                Identifier => "ModHeadersLoaded",
                Label      => Translatable('mod_headers Usage'),
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ModHeadersLoaded",
                Label      => Translatable('mod_headers Usage'),
                Value      => 'not active',
                Message    => Translatable('Please install mod_headers to improve GUI speed.'),
            );
        }

        # check if Apache::Reload is loaded
        my $ApacheReloadUsed = 0;
        for my $Module ( sort keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;
            if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                $ApacheReloadUsed = $Module;
            }
        }

        if ($ApacheReloadUsed) {
            $Self->AddResultOk(
                Identifier => "ApacheReloadUsed",
                Label      => Translatable('Apache::Reload Usage'),
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ApacheReloadUsed",
                Label      => Translatable('Apache::Reload Usage'),
                Value      => 'not active',
                Message    =>
                    Translatable(
                        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.'
                    ),
            );
        }

        my $ApacheDBIUsed;
        for my $Module ( sort keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;
            if ( $Module eq 'Apache::DBI' || $Module eq 'Apache2::DBI' ) {
                $ApacheDBIUsed = $Module;
            }
        }

        if ($ApacheDBIUsed) {
            $Self->AddResultOk(
                Identifier => "ApacheDBIUsed",
                Label      => Translatable('Apache2::DBI Usage'),
                Value      => 'active',
            );
        }
        else {
            $Self->AddResultWarning(
                Identifier => "ApacheDBIUsed",
                Label      => Translatable('Apache2::DBI Usage'),
                Value      => 'not active',
                Message    =>
                    Translatable(
                        'Apache2::DBI should be used to get a better performance  with pre-established database connections.'
                    ),
            );
        }

    }

    return $Self->GetResults();
}

1;
