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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0 qw(:DEFAULT), qw(etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# define needed variable
my $RandomID = $Helper->GetRandomID;

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);
my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
    Group => 'users',
);

my %QueueData = (
    Name                => 'TestQueue1' . $RandomID,
    GroupID             => $GroupID,
    Calendar            => '',
    FirstResponseTime   => '',
    FirstResponseNotify => '',
    UpdateTime          => '',
    UpdateNotify        => '',
    SolutionTime        => '',
    SolutionNotify      => '',
    UnlockTimeout       => '',
    FollowUpID          => 1,
    FollowUpLock        => 0,
    DefaultSignKey      => '',
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => 'TestComment1' . $RandomID,
    ValidID             => $ValidID,
);
my %QueueExpectedData = (
    Name                => 'TestQueue1' . $RandomID,
    RealName            => 'OTOBO System',
    Group               => 'users',
    Calendar            => '',
    FirstResponseTime   => 0,
    FirstResponseNotify => 0,
    UpdateTime          => 0,
    UpdateNotify        => 0,
    SolutionTime        => 0,
    SolutionNotify      => 0,
    UnlockTimeout       => 0,
    FollowUp            => 'possible',
    FollowUpLock        => 0,
    DefaultSignKey      => 0,
    SystemAddress       => {
        Comment  => "Standard Address.",
        Name     => "otobo\@localhost",
        Queue    => "Postmaster",
        Realname => "OTOBO System",
        Valid    => "valid",
    },
    Salutation => {
        Comment     => "Standard Salutation.",
        ContentType => "text/plain; charset=utf-8",
        Name        => "system standard salutation (en)",
        Text        => "Dear <OTOBO_CUSTOMER_REALNAME>,\n\nThank you for your request.\n\n",
        Valid       => "valid",
    },
    Signature => {
        Comment     => "Standard Signature.",
        ContentType => "text/plain; charset=utf-8",
        Name        => "system standard signature (en)",
        Text        =>
            "\nYour Ticket-Team\n\n <OTOBO_Agent_UserFirstname> <OTOBO_Agent_UserLastname>\n\n--\n Super Support - Waterford Business Park\n 5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA\n Email: hot\@example.com - Web: http://www.example.com/\n--",
        Valid => "valid",
    },
    Comment => 'TestComment1' . $RandomID,
    Valid   => 'valid',
);

# create test queue
my $AddSuccess = $QueueObject->QueueAdd(
    %QueueData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'queue created successfully' );

# testing export
my $ExportData = $QueueObject->ExportQueues();
is(
    $ExportData,
    hash {
        field 'TestQueue1' . $RandomID => \%QueueExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    Name                => 'TestQueue2' . $RandomID,
    Group               => 'users',
    Calendar            => '',
    FirstResponseTime   => '',
    FirstResponseNotify => '',
    UpdateTime          => '',
    UpdateNotify        => '',
    SolutionTime        => '',
    SolutionNotify      => '',
    UnlockTimeout       => '',
    FollowUp            => 'possible',
    FollowUpLock        => 0,
    DefaultSignKey      => '',
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => 'TestComment2' . $RandomID,
    Valid               => 'valid',
);

my $ImportSuccess = $QueueObject->ImportQueues(
    Queues => {
        'TestQueue2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported queue successfully' );

my $QueueID = $QueueObject->QueueLookup(
    Queue => 'TestQueue2' . $RandomID,
);
my %ImportedQueue = $QueueObject->QueueGet(
    ID => $QueueID,
);
is(
    \%ImportedQueue,
    hash {
        field 'Name'                => 'TestQueue2' . $RandomID;
        field 'RealName'            => 'OTOBO System';
        field 'Email'               => 'otobo@localhost';
        field 'GroupID'             => $GroupID;
        field 'Calendar'            => '';
        field 'FirstResponseTime'   => 0;
        field 'FirstResponseNotify' => 0;
        field 'UpdateTime'          => 0;
        field 'UpdateNotify'        => 0;
        field 'SolutionTime'        => 0;
        field 'SolutionNotify'      => 0;
        field 'UnlockTimeout'       => 0;
        field 'FollowUpID'          => 1;
        field 'FollowUpLock'        => 0;
        field 'DefaultSignKey'      => 0;
        field 'Comment'             => 'TestComment2' . $RandomID;
        field 'SystemAddressID'     => 1;
        field 'SalutationID'        => 1;
        field 'SignatureID'         => 1;
        field 'ValidID'             => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

# testing queue import with additional new signature, salutation and system address
my %AdvancedImportData = (
    Name                => 'TestQueue3' . $RandomID,
    Group               => 'users',
    Calendar            => '',
    FirstResponseTime   => '',
    FirstResponseNotify => '',
    UpdateTime          => '',
    UpdateNotify        => '',
    SolutionTime        => '',
    SolutionNotify      => '',
    UnlockTimeout       => '',
    FollowUp            => 'possible',
    FollowUpLock        => 0,
    DefaultSignKey      => '',
    SystemAddress       => {
        Comment  => 'TestAddressComment' . $RandomID,
        Name     => 'some@test.address',
        Queue    => 'TestQueue3' . $RandomID,
        Realname => 'TestAddress',
        Valid    => 'valid',
    },
    Salutation => {
        Comment     => 'TestSalutationComment' . $RandomID,
        ContentType => 'text/plain; charset=utf-8',
        Name        => 'TestSalutation' . $RandomID,
        Text        => "Dear <OTOBO_CUSTOMER_REALNAME>,\n\nThank you for your request.\n\n",
        Valid       => 'valid',
    },
    Signature => {
        Comment     => 'TestSignature' . $RandomID,
        ContentType => 'text/plain; charset=utf-8',
        Name        => 'TestSignature' . $RandomID,
        Text        =>
            "\nYour Ticket-Team\n\n <OTOBO_Agent_UserFirstname> <OTOBO_Agent_UserLastname>\n\n--\n Super Support - Waterford Business Park\n 5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA\n Email: hot\@example.com - Web: http://www.example.com/\n--",
        Valid => 'valid',
    },
    Comment => 'TestComment3' . $RandomID,
    Valid   => 'valid',
);

my $AdvancedImportSuccess = $QueueObject->ImportQueues(
    Queues => {
        'TestQueue2' . $RandomID => \%AdvancedImportData,
    },
    UserID => $TestUserID,
);
ok( $AdvancedImportSuccess, 'imported queue successfully' );

my $AdvancedQueueID = $QueueObject->QueueLookup(
    Queue => 'TestQueue3' . $RandomID,
);
my %AdvancedImportedQueue = $QueueObject->QueueGet(
    ID => $AdvancedQueueID,
);
my %SystemAddressList        = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList();
my %ReverseSystemAddressList = reverse %SystemAddressList;
my $SystemAddressID          = $ReverseSystemAddressList{'some@test.address'};
my %SalutationList           = $Kernel::OM->Get('Kernel::System::Salutation')->SalutationList();
my %ReverseSalutationList    = reverse %SalutationList;
my $SalutationID             = $ReverseSalutationList{ 'TestSalutation' . $RandomID };
my %SignatureList            = $Kernel::OM->Get('Kernel::System::Signature')->SignatureList();
my %ReverseSignatureList     = reverse %SignatureList;
my $SignatureID              = $ReverseSignatureList{ 'TestSignature' . $RandomID };
is(
    \%AdvancedImportedQueue,
    hash {
        field 'Name'                => 'TestQueue3' . $RandomID;
        field 'RealName'            => 'TestAddress';
        field 'Email'               => 'some@test.address';
        field 'GroupID'             => $GroupID;
        field 'Calendar'            => '';
        field 'FirstResponseTime'   => 0;
        field 'FirstResponseNotify' => 0;
        field 'UpdateTime'          => 0;
        field 'UpdateNotify'        => 0;
        field 'SolutionTime'        => 0;
        field 'SolutionNotify'      => 0;
        field 'UnlockTimeout'       => 0;
        field 'FollowUpID'          => 1;
        field 'FollowUpLock'        => 0;
        field 'DefaultSignKey'      => '';
        field 'Comment'             => 'TestComment3' . $RandomID;
        field 'SystemAddressID'     => $SystemAddressID;
        field 'SalutationID'        => $SalutationID;
        field 'SignatureID'         => $SignatureID;
        field 'ValidID'             => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

done_testing;
