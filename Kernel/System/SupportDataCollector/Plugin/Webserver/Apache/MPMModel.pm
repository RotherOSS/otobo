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

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    # No web request or no apache webserver with mod_perl, skip this check.
    if ( !$ENV{GATEWAY_INTERFACE} || !$ENV{SERVER_SOFTWARE} || $ENV{SERVER_SOFTWARE} !~ m{apache}i || !$ENV{MOD_PERL} )
    {
        return $Self->GetResults();
    }

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
