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

package Kernel::System::Console::Command::Maint::Ticket::QueueIndexCleanup;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Cleanup unneeded entries from StaticDB queue index.');

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Module = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::IndexModule');
    if ( $Module =~ m{StaticDB} ) {
        my $Error = "$Module is the active queue index, aborting.\n";
        $Error .= "Use Maint::Ticket::QueueIndexRebuild to regenerate the active index.\n";

        die $Error;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Cleaning up ticket queue index...</yellow>\n");

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Records = 0;
    $DBObject->Prepare(
        SQL => 'SELECT count(*) from ticket_index'
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Records += $Row[0];
    }
    $DBObject->Prepare(
        SQL => 'SELECT count(*) from ticket_lock_index'
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Records += $Row[0];
    }

    if ( !$Records ) {
        $Self->Print("<green>Queue index is already clean.</green>\n");

        return $Self->ExitCodeOk();
    }

    $DBObject->Do(
        SQL => 'DELETE FROM ticket_index',
    );
    $DBObject->Do(
        SQL => 'DELETE FROM ticket_lock_index',
    );

    $Self->Print("<green>Done ($Records records deleted).</green>\n");

    return $Self->ExitCodeOk();
}

1;
