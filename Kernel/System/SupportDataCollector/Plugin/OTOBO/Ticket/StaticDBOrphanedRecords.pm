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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::Ticket::StaticDBOrphanedRecords;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    my $Module = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::IndexModule');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Module !~ /StaticDB/ ) {

        my ( $OrphanedTicketLockIndex, $OrphanedTicketIndex );

        $DBObject->Prepare( SQL => 'SELECT count(*) from ticket_lock_index' );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $OrphanedTicketLockIndex = $Row[0];
        }

        if ($OrphanedTicketLockIndex) {
            $Self->AddResultWarning(
                Identifier => 'TicketLockIndex',
                Label      => Translatable('Orphaned Records In ticket_lock_index Table'),
                Value      => $OrphanedTicketLockIndex,
                Message    =>
                    Translatable(
                        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.'
                    ),
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'TicketLockIndex',
                Label      => Translatable('Orphaned Records In ticket_lock_index Table'),
                Value      => $OrphanedTicketLockIndex || '0',
            );
        }

        $DBObject->Prepare( SQL => 'SELECT count(*) from ticket_index' );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $OrphanedTicketIndex = $Row[0];
        }

        if ($OrphanedTicketLockIndex) {
            $Self->AddResultWarning(
                Identifier => 'TicketIndex',
                Label      => Translatable('Orphaned Records In ticket_index Table'),
                Value      => $OrphanedTicketIndex,
                Message    =>
                    Translatable(
                        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.'
                    ),
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'TicketIndex',
                Label      => Translatable('Orphaned Records In ticket_index Table'),
                Value      => $OrphanedTicketIndex || '0',
            );
        }
    }

    return $Self->GetResults();
}

1;
