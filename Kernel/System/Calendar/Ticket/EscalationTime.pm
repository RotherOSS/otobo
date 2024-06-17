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

package Kernel::System::Calendar::Ticket::EscalationTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Calendar::Ticket::EscalationTime - EscalationTime appointment type

=head1 DESCRIPTION

EscalationTime ticket appointment type.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketEscalationTimeObject = $Kernel::OM->Get('Kernel::System::Calendar::Ticket::EscalationTime');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 GetTime()

returns time value for escalation time appointment type.

    my $SolutionTime = $TicketEscalationTimeObject->GetTime(
        Type     => 'SolutionTime',
        TicketID => 1,
    );

=cut

sub GetTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{TicketID},
    );
    return if !$Ticket{ $Param{Type} . 'DestinationDate' };

    # return escalation destination date
    return $Ticket{ $Param{Type} . 'DestinationDate' };
}

=head2 SetTime()

does nothing, as you cannot explicitly set ticket escalation times.
returns 1 to prevent errors in log.

=cut

sub SetTime {
    return 1;
}

1;
