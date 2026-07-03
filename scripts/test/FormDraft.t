# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use List::AllUtils qw(pairs);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# Get FormDraft object.
my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

# Get Helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# Create test Ticket.
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otobo.org',
    OwnerID      => 1,
    UserID       => 1,
);
ok(
    $TicketID,
    "TicketCreate() $TicketID",
);

# Create test scenarios for FormDraftAdd().
my @Tests = (
    {
        Name       => 'No FormData - Add Fail',
        FormData   => undef,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No ObjectType - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => undef,
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No ObjectID - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => undef,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No Action - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => undef,
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No UserID - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => undef,
        Success    => 0,
    },
    {
        Name     => 'All Parameters OK with Attachment - Add Success',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        FileData => [
            {
                'Content'     => 'Dear customer\n\nthank you!',
                'ContentType' => 'text/plain',
                'ContentID'   => undef,
                'Filename'    => 'thankyou.txt',
                'Filesize'    => 25,
                'FileID'      => 1,
                'Disposition' => 'attachment',
            },
        ],
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 1,
    },
);

# Test FormDraftAdd and FormDraftListGet functions.
my %FormDraftIDToObjectID;
my $FormDraftID;
for my $Test (@Tests) {

    # Create FormDraft.
    my $FormDraftAdd = $FormDraftObject->FormDraftAdd(
        FormData   => $Test->{FormData},
        FileData   => $Test->{FileData},
        ObjectType => $Test->{ObjectType},
        ObjectID   => $Test->{ObjectID},
        Action     => $Test->{Action},
        Title      => $Test->{Title},
        UserID     => $Test->{UserID},
    );

    if ( !$Test->{Success} ) {
        is(
            $FormDraftAdd,
            undef,
            "FormDraftAdd() $Test->{Name}",
        );
    }
    else {
        ok(
            $FormDraftAdd,
            "FormDraftAdd() $Test->{Name}",
        );

        # Get all FormDrafts for test Ticket, expecting one result.
        my $FormDraftList = $FormDraftObject->FormDraftListGet(
            ObjectType => 'Ticket',
            ObjectID   => $Test->{ObjectID},
            Action     => 'AgentTicketNote',
        );
        is(
            scalar @{$FormDraftList},
            1,
            "FormDraftListGet() success"
        );

        # Get created FormDraft ID.
        $FormDraftID = $FormDraftList->[0]->{FormDraftID};
        $FormDraftIDToObjectID{ $FormDraftList->[0]{FormDraftID} } = $Test->{ObjectID};

        # Test FormDraftGet() data with content.
        my $FormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $FormDraftID,
            ObjectID    => $Test->{ObjectID},
            GetContent  => 1,
        );

        # Verify value from FormDraftGet().
        for my $FormDraftGetParam (qw(FormData FileData ObjectID ObjectType Title Action)) {
            is(
                $FormDraft->{$FormDraftGetParam},
                $Test->{$FormDraftGetParam},
                "FormDraftGet() param $FormDraftGetParam"
            );
        }

        # Test FormDraftGet() without content.
        $FormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $FormDraftID,
            ObjectID    => $Test->{ObjectID},
            GetContent  => 0,
        );
        is(
            $FormDraft->{FileData},
            undef,
            'FormDraftGet() without content FileData'
        );
    }
}

# Create test scenarios for FormDraftUpdate().
@Tests = (
    {
        Name        => 'No FormData - Update Fail',
        FormData    => undef,
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No ObjectType - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => undef,
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No ObjectID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => undef,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No Action - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => undef,
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No UserID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => undef,
        Success     => 0,
    },
    {
        Name     => 'No FormDraftID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => undef,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different ObjectType - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Article',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different ObjectID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID + 1,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different Action - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketPriority',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'All Parameters OK - Update Success',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 1,
    },
    {
        Name     => 'All Parameters OK - Update Success - utf8 characters in title',
        FormData => {
            Subject => 'UnitTest Subject - Update - шђчћж',
            Body    => 'UnitTest Body - Update - шђчћж',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update - utf8 characters - шђчћж',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 1,
    },
);

# Test FormDraftUpdate().
for my $Test (@Tests) {

    # Update FormDraft.
    my $FormDraftUpdate = $FormDraftObject->FormDraftUpdate(
        FormData    => $Test->{FormData},
        ObjectType  => $Test->{ObjectType},
        ObjectID    => $Test->{ObjectID},
        Action      => $Test->{Action},
        Title       => $Test->{Title},
        FormDraftID => $Test->{FormDraftID},
        UserID      => $Test->{UserID},
    );

    if ( !$Test->{Success} ) {
        is(
            $FormDraftUpdate,
            undef,
            "FormDraftUpdate() $Test->{Name}",
        );
    }
    else {
        ok(
            $FormDraftUpdate,
            "FormDraftUpdate() $Test->{Name}",
        );

        # Get updated FormDraft data and check values.
        my $UpdatedFormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $Test->{FormDraftID},
            ObjectID    => $Test->{ObjectID},
            GetContent  => 1,
        );
        is(
            $UpdatedFormDraft->{FormData}->{Subject},
            $Test->{FormData}->{Subject},
            "FormDraftUpdate() updated param FormData - Subject"
        );
        is(
            $UpdatedFormDraft->{FormData}->{Body},
            $Test->{FormData}->{Body},
            "FormDraftUpdate() updated param FormData - Body"
        );
        is(
            $UpdatedFormDraft->{Title},
            $Test->{Title},
            "FormDraftUpdate() updated param Title"
        );
    }
}

# Test FormDraftDelete().
for my $FormDraftData ( pairs %FormDraftIDToObjectID ) {
    my ( $FormDraftID, $ObjectID ) = $FormDraftData->@*;
    my $FormDraftDelete = $FormDraftObject->FormDraftDelete(
        FormDraftID => $FormDraftID,
        ObjectID    => $ObjectID,
    );
    ok(
        $FormDraftDelete,
        'FormDraftDelete() success'
    );

    # Sanity check.
    my $FormDraft = $FormDraftObject->FormDraftGet(
        FormDraftID => $FormDraftID,
        ObjectID    => $ObjectID,
        GetContent  => 1,
    );
    is(
        $FormDraft->{Title},
        undef,
        'FormDraftDelete() check Title'
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
