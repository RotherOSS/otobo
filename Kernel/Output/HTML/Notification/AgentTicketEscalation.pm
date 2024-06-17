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

package Kernel::Output::HTML::Notification::AgentTicketEscalation;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Ticket',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # only show the escalations on ticket overviews
    return ''
        if $LayoutObject->{Action}
        !~ /^AgentTicket(Queue|Service|(Status|Locked|Watch|Responsible)View)/;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check result cache
    my $CacheTime = $Param{Config}->{CacheTime} || 40;
    if ($CacheTime) {
        my $Output = $CacheObject->Get(
            Type => 'TicketEscalation',
            Key  => 'EscalationResult::' . $Self->{UserID} . '::' . $LayoutObject->{UserLanguage},
        );
        return $Output if defined $Output;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get all overtime tickets
    my $ShownMax            = $Param{Config}->{ShownMax}            || 25;
    my $EscalationInMinutes = $Param{Config}->{EscalationInMinutes} || 120;
    my @TicketIDs           = $TicketObject->TicketSearch(
        Result                           => 'ARRAY',
        Limit                            => $ShownMax,
        TicketEscalationTimeOlderMinutes => -$EscalationInMinutes,
        Permission                       => 'rw',
        UserID                           => $Self->{UserID},
    );

    # get escalations
    my $ResponseTime = '';
    my $UpdateTime   = '';
    my $SolutionTime = '';
    my $Comment      = '';
    my $Count        = 0;
    for my $TicketID (@TicketIDs) {
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # check response time
        if ( defined $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeHuman} = $LayoutObject->CustomerAgeInHours(
                Age   => $Ticket{FirstResponseTime},
                Space => ' ',
            );
            if ( $Ticket{FirstResponseTimeEscalation} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationFirstResponseTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $ResponseTime .= $LayoutObject->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{FirstResponseTimeNotification} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationFirstResponseTimeWillBeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $ResponseTime .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }

        # check update time
        if ( defined $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeHuman} = $LayoutObject->CustomerAgeInHours(
                Age   => $Ticket{UpdateTime},
                Space => ' ',
            );
            if ( $Ticket{UpdateTimeEscalation} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationUpdateTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $UpdateTime .= $LayoutObject->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{UpdateTimeNotification} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationUpdateTimeWillBeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $UpdateTime .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }

        # check solution
        if ( defined $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeHuman} = $LayoutObject->CustomerAgeInHours(
                Age   => $Ticket{SolutionTime},
                Space => ' ',
            );
            if ( $Ticket{SolutionTimeEscalation} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationSolutionTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $SolutionTime .= $LayoutObject->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{SolutionTimeNotification} ) {
                $LayoutObject->Block(
                    Name => 'TicketEscalationSolutionTimeWillBeOver',
                    Data => \%Ticket,
                );
                my $Data = $LayoutObject->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $SolutionTime .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }
    }
    if ( $Count == $ShownMax ) {
        $Comment .= $LayoutObject->Notify(
            Priority => 'Error',
            Info     => Translatable('There are more escalated tickets!'),
        );
    }
    my $Output = $ResponseTime . $UpdateTime . $SolutionTime . $Comment;

    # cache result
    if ($CacheTime) {
        $CacheObject->Set(
            Type  => 'TicketEscalation',
            Key   => 'EscalationResult::' . $Self->{UserID} . '::' . $LayoutObject->{UserLanguage},
            Value => $Output,
            TTL   => $CacheTime,
        );
    }

    return $Output;
}

1;
