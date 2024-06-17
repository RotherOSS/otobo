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

package Kernel::System::GenericAgent::NotifyAgentGroupOfCustomQueue;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Ticket',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    # get used calendar
    my $Calendar = $TicketObject->TicketCalendarGet(
        %Ticket,
    );

    # get time object
    my $StopDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # check if it is during business hours, then send escalation info
    my $StartDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $StopDateTimeObject->ToEpoch() - ( 10 * 60 ),
        }
    );

    my $CountedTime = StartDateTimeObject->Delta(
        DateTimeObject => $StopDateTimeObject,
        ForWorkingTime => 1,
        Calendar       => $Calendar,
    );
    if ( !$CountedTime ) {
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  =>
                    "Send no escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }
        return 1;
    }

    # check if it's a escalation of escalation notification
    # check escalation times
    my $EscalationType = '';
    TYPE:
    for my $Type (
        qw(FirstResponseTimeEscalation UpdateTimeEscalation SolutionTimeEscalation
        FirstResponseTimeNotification UpdateTimeNotification SolutionTimeNotification)
        )
    {
        if ( defined $Ticket{$Type} ) {
            if ( $Type =~ /TimeEscalation$/ ) {
                $EscalationType = 'Escalation';
                last TYPE;
            }
            elsif ( $Type =~ /TimeNotification$/ ) {
                $EscalationType = 'EscalationNotifyBefore';
                last TYPE;
            }
        }
    }

    # check
    if ( !$EscalationType ) {
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  =>
                    "Can't send escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because ticket is not escalated!",
            );
        }
        return;
    }

    # trigger notification event
    $TicketObject->EventHandler(
        Event => 'Notification' . $EscalationType,
        Data  => {
            TicketID              => $Param{TicketID},
            CustomerMessageParams => \%Param,
        },
        UserID => 1,
    );

    return 1;
}

1;
