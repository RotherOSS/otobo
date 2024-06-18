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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::MPMModel;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules

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
    # Check for mod_perl by trying to load Apache2::Module and see whether Apache2::Module::top_module() is available.
    return $Self->GetResults() unless $MainObject->Require( 'Apache2::Module', Silent => 1 );
    return $Self->GetResults() unless defined &Apache2::Module::top_module;

    my $MPMModel;
    my %KnownModels = (
        'worker.c'  => 1,
        'prefork.c' => 1,
        'event.c'   => 1,
    );

    MODULE:
    for ( my $Module = Apache2::Module::top_module(); $Module; $Module = $Module->next() ) {
        if ( $KnownModels{ $Module->name() } ) {
            $MPMModel = $Module->name();
        }
    }

    if ( $MPMModel eq 'prefork.c' ) {
        $Self->AddResultOk(
            Identifier => 'MPMModel',
            Label      => Translatable('MPM model'),
            Value      => $MPMModel,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'MPMModel',
            Label      => Translatable('MPM model'),
            Value      => $MPMModel,
            Message    => Translatable("OTOBO requires apache to be run with the 'prefork' MPM model."),
        );
    }

    return $Self->GetResults();
}

1;
