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

package Kernel::System::Ticket::Event::GenericAgent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::GenericAgent',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # check for TicketID
    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID! in Data",
        );
        return;
    }

    # Loop protection: only execute this handler once for each ticket and event.
    return
        if $Kernel::OM->Get('Kernel::System::Ticket')->{'_GenericAgent::AlreadyProcessed'}
        ->{ $Param{Data}->{TicketID} }->{ $Param{Event} }++;

    # get generic agent object
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    my %JobEventList = $GenericAgentObject->JobEventList();

    # no configured jobs is OK
    return 1 if !IsHashRefWithData( \%JobEventList );

    # loop over jobs
    JOB:
    for my $JobName ( sort keys %JobEventList ) {

        next JOB if !IsArrayRefWithData( $JobEventList{$JobName} );

        # check if the job is connected to this event
        my @Events = @{ $JobEventList{$JobName} };
        next JOB if !grep { $_ eq $Param{Event} } @Events;

        # execute the job
        my $Result = $GenericAgentObject->JobRun(
            Job          => $JobName,
            OnlyTicketID => $Param{Data}->{TicketID},
            UserID       => 1,                          # run the job as system user
        );
    }

    return 1;
}

1;
