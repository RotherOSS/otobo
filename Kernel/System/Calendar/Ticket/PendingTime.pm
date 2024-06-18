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

package Kernel::System::Calendar::Ticket::PendingTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Calendar::Ticket::PendingTime - PendingTime appointment type

=head1 DESCRIPTION

PendingTime ticket appointment type.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketPendingTimeObject = $Kernel::OM->Get('Kernel::System::Calendar::Ticket::PendingTime');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 GetTime()

returns time value for pending time appointment type.

    my $PendingTime = $TicketPendingTimeObject->GetTime(
        Type     => 'PendingTime',
        TicketID => 1,
    );

=cut

sub GetTime {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{TicketID},
    );
    return if !$Ticket{UntilTime};

    # Calculate pending time.
    my $PendingTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $PendingTimeObject->Add(
        Seconds => $Ticket{UntilTime},
    );

    return $PendingTimeObject->ToString();
}

=head2 SetTime()

set ticket pending time to supplied time value.

    my $Success = $TicketPendingTimeObject->SetTime(
        Type     => 'PendingTime',
        Value    => '2016-01-01 00:00:00'
        TicketID => 1,
    );

returns 1 if successful.

=cut

sub SetTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Value TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $PendingTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Value},
        },
    );
    my $PendingTimeSetings = $PendingTimeObject->Get();

    # set pending time
    my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPendingTimeSet(
        %{$PendingTimeSetings},
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    return $Success;
}

1;
