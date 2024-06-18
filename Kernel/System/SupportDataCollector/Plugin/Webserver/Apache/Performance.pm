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
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules
use Module::Loaded qw(is_loaded);

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Main',
);

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() unless $ENV{GATEWAY_INTERFACE};

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Checking for $ENV{MOD_PERL} is not reliable, see https://github.com/plack/Plack/issues/562.
    # Check for mod_perl by trying to load Apache2::Module and see whether Apache2::Module::loaded() is available.
    return $Self->GetResults() unless $MainObject->Require( 'Apache2::Module', Silent => 1 );
    return $Self->GetResults() unless defined &Apache2::Module::loaded;

    # Check for CGI accelerator
    # We are a bit sloppy here. If Apache2::Module has been loaded we assume the effectively we have mod_perl.
    # Checking $ENV{MOD_PERL} here is kind of useless, as Plack::Handler::Apache2 deletes $ENV{MOD_PERL}.
    if (1) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => 'mod_perl, as Apache2::Module is available',
        );
    }
    elsif ( is_loaded('CGI::Fast') || $ENV{FCGI_ROLE} || $ENV{FCGI_SOCKET_PATH} ) {
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

    # TODO: this does not really check whether the output filter has been activated
    if (1) {
        my $ModDeflateLoaded = Apache2::Module::loaded('mod_deflate.c') || Apache2::Module::loaded('mod_deflate.so');

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

        my $ModFilterLoaded = Apache2::Module::loaded('mod_filter.c') || Apache2::Module::loaded('mod_filter.so');

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

        my $ModHeadersLoaded = Apache2::Module::loaded('mod_headers.c') || Apache2::Module::loaded('mod_headers.so');

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
    }

    return $Self->GetResults();
}

1;
