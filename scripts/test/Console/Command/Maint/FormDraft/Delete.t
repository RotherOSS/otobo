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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::FormDraft::Delete');

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - without any options",
);

# try to execute command with --expired option
$ExitCode = $CommandObject->Execute('expired');

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - with --expired option",
);

# try to execute command with --object-type option without velue
$ExitCode = $CommandObject->Execute('--object-type');

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - with ----object-type option without value",
);

# get FormDraft object
my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

# create test Ticket
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

$Self->True(
    $TicketID,
    "Ticket is created - $TicketID"
);

FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-02-01 10:10:00',
        },
    )->ToEpoch()
);

# test FormDraftAdd and FormDraftListGet functions
for ( 1 .. 3 ) {

    # create FormDraft
    my $FormDraftAdd = $FormDraftObject->FormDraftAdd(
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType    => 'Ticket',
        ObjectID      => $TicketID,
        Action        => 'AgentTicketNote',
        FormDraftName => 'UnitTest FormDraft' . $HelperObject->GetRandomID(),
        UserID        => 1,
    );

    $Self->True(
        $TicketID,
        "FormDraft is created"
    );

    # set fix time in order so further created drafts will be expired
    # to test command with expired option and without it as well
    FixedTimeSet(
        $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => '2016-01-15 10:10:00',
            },
        )->ToEpoch()
    );
}

FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-02-01 10:10:00',
        },
    )->ToEpoch()
);

# execute command with --object-type option with velue ticket and --expired option
$ExitCode = $CommandObject->Execute( '--object-type', 'Ticket', '--expired' );

# just check exit code
$Self->Is(
    $ExitCode,
    0,
    "Maint::FormDraft::Delete exit code - with ----object-type option with 'Ticket' value and --expired option",
);

my $FormDraftList = $FormDraftObject->FormDraftListGet(
    ObjectType => 'Ticket',
    ObjectID   => $TicketID,
    Action     => 'AgentTicketNote',
    UserID     => 1,
);

$Self->Is(
    scalar @{$FormDraftList},
    1,
    "Expired FormDraft is deleted"
);

# execute command with --object-type option with velue Ticket
$ExitCode = $CommandObject->Execute( '--object-type', 'Ticket' );

# just check exit code
$Self->Is(
    $ExitCode,
    0,
    "Maint::FormDraft::Delete exit code - with ----object-type option with 'Ticket' value",
);

$Self->DoneTesting();
