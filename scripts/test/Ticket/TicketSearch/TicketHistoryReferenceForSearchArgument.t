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

use strict;
use warnings;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet FixedTimeUnset);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Test for arguments that should have mapping.
my @ArgsWithReference = qw(
    CreatedStates
    CreatedStateIDs
    CreatedQueues
    CreatedQueueIDs
    CreatedPriorities
    CreatedPriorityIDs
    CreatedTypes
    CreatedTypeIDs
    CreatedUserIDs
    TicketChangeTimeNewerDate
    TicketChangeTimeNewerMinutes
    TicketChangeTimeOlderDate
    TicketChangeTimeOlderMinutes
    TicketLastChangeTimeNewerDate
    TicketLastChangeTimeNewerMinutes
    TicketLastChangeTimeOlderDate
    TicketLastChangeTimeOlderMinutes
    TicketCloseTimeNewerDate
    TicketCloseTimeNewerMinutes
    TicketCloseTimeOlderDate
    TicketCloseTimeOlderMinutes
);

for my $Arg (@ArgsWithReference) {
    my $THRef = $TicketObject->_TicketHistoryReferenceForSearchArgument(
        Argument => $Arg,
    );
    $Self->True(
        $THRef,
        "TicketSearch :: ticket-history reference for '${ Arg }' exists!",
    );
}

# Test for argument that should not have mapping.
{
    my $THRef = $TicketObject->_TicketHistoryReferenceForSearchArgument(
        Argument => 'ArgWithNoMapping',
    );
    $Self->False(
        $THRef,
        "TicketSearch :: ticket-history reference for 'ArgWithNoMapping' doesn't exists!",
    );
}

# Test for tickets changed|closed older|newer than X minutes
{
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TestName     = sub {
        return sprintf 'TicketSearch(%s) :: %s!', shift, shift;
    };

    my @Tests = (
        {
            Name             => 'Tickets closed less than 1 minute ago',
            SearchParam      => 'TicketCloseTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets closed older than 1 minute ago',
            SearchParam      => 'TicketCloseTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },

        {
            Name             => 'Tickets changed less than 1 minute ago',
            SearchParam      => 'TicketChangeTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets changed older than 1 minute ago',
            SearchParam      => 'TicketChangeTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },

        {
            Name             => 'Tickets where last change is less than 1 minute ago',
            SearchParam      => 'TicketLastChangeTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets where last change is older than 1 minute ago',
            SearchParam      => 'TicketLastChangeTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },
    );

    for my $Test (@Tests) {
        my $TicketBaseDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        if ( $Test->{FixedTimeMinutes} ) {
            $TicketBaseDTObject->Subtract(
                Minutes => $Test->{FixedTimeMinutes},
            );
            FixedTimeSet($TicketBaseDTObject);
        }

        my $TicketID = $TicketObject->TicketCreate(
            Title    => 'Some Ticket_Title',
            Queue    => 'Junk',
            Lock     => 'unlock',
            Priority => '3 normal',
            State    => 'closed successful',
            OwnerID  => 1,
            UserID   => 1,
        );

        FixedTimeUnset();

        $Self->True(
            $TicketID,
            $TestName->( $Test->{SearchParam}, 'Test ticket created successfully' ),
        );

        my @TicketIDs = $TicketObject->TicketSearch(
            Result               => 'ARRAY',
            StateType            => ['closed'],
            UserID               => 1,
            Limit                => 1,
            $Test->{SearchParam} => $Test->{SearchParamValue},
        );
        $Self->True(
            scalar(@TicketIDs) == 1,
            $TestName->( $Test->{SearchParam}, $Test->{Name}, ),
        );

        $Self->True(
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            $TestName->( $Test->{SearchParam}, 'Test ticket deleted', ),
        );
    }
}

$Self->DoneTesting();
