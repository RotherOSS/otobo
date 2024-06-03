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

package Kernel::System::SupportDataCollector::Plugin::Database::OutdatedTables;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my %ExistingTables = map { lc($_) => 1 } $Kernel::OM->Get('Kernel::System::DB')->ListTables();

    my @OutdatedTables;

    # This table was removed with OTOBO 10 (if empty).
    if ( $ExistingTables{gi_object_lock_state} ) {
        my $SolManConnectorInstalled;

        for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {
            if ( $Package->{Name}->{Content} eq 'OTOBOGenericInterfaceConnectorSAPSolMan' ) {
                $SolManConnectorInstalled = 1;
            }
        }

        push @OutdatedTables, 'gi_object_lock_state' if !$SolManConnectorInstalled;
    }

    if ( !@OutdatedTables ) {
        $Self->AddResultOk(
            Label => Translatable('Outdated Tables'),
            Value => '',
        );
    }
    else {
        $Self->AddResultWarning(
            Label   => Translatable('Outdated Tables'),
            Value   => join( ', ', @OutdatedTables ),
            Message => Translatable("Outdated tables were found in the database. These can be removed if empty."),
        );
    }

    return $Self->GetResults();
}

1;
