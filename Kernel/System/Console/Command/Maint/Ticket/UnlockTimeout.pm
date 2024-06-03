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

package Kernel::System::Console::Command::Maint::Ticket::UnlockTimeout;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Lock',
    'Kernel::System::State',
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Unlock tickets that are past their unlock timeout.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Unlocking tickets that are past their unlock timeout...</yellow>\n");

    my @UnlockStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Unlock',
        Result => 'ID',
    );
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    my @Tickets;

    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => "
            SELECT st.tn, st.id, st.timeout, sq.unlock_timeout, st.sla_id, st.queue_id
            FROM ticket st, queue sq
            WHERE st.queue_id = sq.id
                AND sq.unlock_timeout != 0
                AND st.ticket_state_id IN ( ${\(join ', ', @UnlockStateIDs)} )
                AND st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ",
    );

    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        push @Tickets, \@Row;
    }

    TICKET:
    for (@Tickets) {
        my @Row = @{$_};

        # get used calendar
        my $Calendar = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCalendarGet(
            QueueID => $Row[5],
            SLAID   => $Row[4],
        );

        my $StartDTObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Row[2],
            },
        );

        my $StopDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $StartStopDelta = $StartDTObject->Delta(
            DateTimeObject => $StopDTObject,
            ForWorkingTime => 1,
            Calendar       => $Calendar,
        );

        my $CountedTime = $StartStopDelta ? $StartStopDelta->{AbsoluteSeconds} : 0;

        next TICKET if $CountedTime < $Row[3] * 60;

        $Self->Print(" Unlocking ticket id $Row[0]... ");
        my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
            TicketID => $Row[1],
            Lock     => 'unlock',
            UserID   => 1,
        );
        if ($Unlock) {
            $Self->Print("<green>done.</green>\n");
        }
        else {
            $Self->Print("<red>failed.</red>\n");
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
