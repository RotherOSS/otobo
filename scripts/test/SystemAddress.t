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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper              = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

my $QueueRand1 = $Helper->GetRandomID;
my $QueueRand2 = $Helper->GetRandomID;

my $QueueID1 = $QueueObject->QueueAdd(
    Name                => $QueueRand1,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

my $QueueID2 = $QueueObject->QueueAdd(
    Name                => $QueueRand2,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

# add SystemAddress
my $SystemAddressEmail    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = 'OTOBO-Team';

my %SystemAddressData = (
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => $QueueID1,
    ValidID  => 1,
);

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    %SystemAddressData,
    UserID => 1,
);
ok( $SystemAddressID, 'SystemAddressAdd() - first system address' );

my $SystemAddressIDWrong = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

is(
    $SystemAddressIDWrong,
    undef,
    'SystemAddressAdd() - Try to add new system address with existing system address name',
);

# add SystemAddress
my $SystemAddressEmail2    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname2 = "OTOBO-Team2";
my $SystemAddressID2       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail2,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

ok( $SystemAddressID2, 'SystemAddressAdd() - second system address' );

# try to update SystemAddress with existing name
my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID2,
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
is(
    $SystemAddressUpdate,
    undef,
    'SystemAddressUpdate() - Try to update new system address with existing system address name',
);

my %SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressData ) {
    is(
        $SystemAddress{$Key},
        $SystemAddressData{$Key},
        'SystemAddressGet() - $Key',
    );
}

# caching
%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressData ) {
    is(
        $SystemAddress{$Key},
        $SystemAddressData{$Key},
        'SystemAddressGet() - $Key',
    );
}

my %SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 0 );
ok(
    exists $SystemAddressList{$SystemAddressID} && $SystemAddressList{$SystemAddressID} eq $SystemAddressEmail,
    "SystemAddressList() contains the SystemAddress $SystemAddressID",
);

# caching
%SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 1 );
ok(
    exists $SystemAddressList{$SystemAddressID} && $SystemAddressList{$SystemAddressID} eq $SystemAddressEmail,
    "SystemAddressList() contains the SystemAddress $SystemAddressID",
);

my @Tests = (
    {
        Address => uc($SystemAddressEmail),
        QueueID => $QueueID1,
    },
    {
        Address => lc($SystemAddressEmail),
        QueueID => $QueueID1,
    },
    {
        Address => $SystemAddressEmail,
        QueueID => $QueueID1,
    },
    {
        Address => '2' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ', ' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ')' . $SystemAddressEmail,
        QueueID => undef,
    },
);
for my $Test (@Tests) {
    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );

    # cached
    $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );
}

my %SystemAddressDataUpdate = (
    Name     => '2' . $SystemAddressEmail,
    Realname => '2' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => $QueueID2,
    ValidID  => 2,
);

$SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    %SystemAddressDataUpdate,
    ID     => $SystemAddressID,
    UserID => 1,
);
ok( $SystemAddressUpdate, 'SystemAddressUpdate()' );

%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressDataUpdate ) {
    is(
        $SystemAddress{$Key},
        $SystemAddressDataUpdate{$Key},
        'SystemAddressGet() - $Key',
    );
}

# add test valid system address
my $SystemAddressID1 = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail . 'first',
    Realname => $SystemAddressRealname . 'first',
    Comment  => 'some comment',
    QueueID  => $QueueID1,
    ValidID  => 1,
    UserID   => 1,
);

# test SystemAddressQueueList() method - get all addresses
my %SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 0 );

ok(
    exists $SystemQueues{$QueueID2} && $SystemQueues{$QueueID2} == $SystemAddressID,
    "SystemAddressQueueList() contains the QueueID2",
);
ok(
    exists $SystemQueues{$QueueID1} && $SystemQueues{$QueueID1} == $SystemAddressID1,
    "SystemAddressQueueList() contains the QueueID1",
);

# test SystemAddressQueueList() method -  get only valid system addresses
%SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 1 );

ok(
    !exists $SystemQueues{$QueueID2},
    "SystemAddressQueueList() does not contain the invalid QueueID2",
);
ok(
    exists $SystemQueues{$QueueID1} && $SystemQueues{$QueueID1} == $SystemAddressID1,
    "SystemAddressQueueList() contains the valid QueueID1",
);

# Test SystemAddressIsUsed() function.
my $SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => 1,
);
ok(
    $SystemAddressIsUsed,
    "SystemAddressIsUsed() - Correctly detected system address in use"
);

$SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => $SystemAddressID2,
);
is(
    $SystemAddressIsUsed,
    undef,
    "SystemAddressIsUsed() - Correctly detected system address not in use"
);

my $AutoResponse = $Kernel::OM->Get('Kernel::System::AutoResponse')->AutoResponseAdd(
    Name        => 'Some::AutoResponse',
    ValidID     => 1,
    Subject     => 'Some Subject..',
    Response    => 'Auto Response Test....',
    ContentType => 'text/plain',
    AddressID   => $SystemAddressID2,
    TypeID      => 1,
    UserID      => 1,
);

ok(
    $AutoResponse,
    "AutoResponseAdd() - $AutoResponse"
);

$SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => $SystemAddressID2,
);
ok(
    $SystemAddressIsUsed,
    "SystemAddressIsUsed() - Correctly detected system address in use after adding auto response"
);

$SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    Name     => '3' . $SystemAddressEmail,
    Realname => '3' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => $QueueID2,
    ValidID  => 2,
    ID       => $SystemAddressID2,
    UserID   => 1,
);
is(
    $SystemAddressUpdate,
    undef,
    "SystemAddressUpdate() -
        This system address $SystemAddressID2 cannot be set to invalid,
        because it is used in one or more queue(s) or auto response(s)",
);

subtest 'SystemAddressIsLocalAddress' => sub {
    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');
    my @AddressTests       = (
        {
            # not local because the address was updated
            Address         => $SystemAddressEmail,
            ExpectedIsLocal => 0,
        },
        {
            # local because that is the updated address
            Address         => '2' . $SystemAddressEmail,
            ExpectedIsLocal => 0,
        },
        {
            Address         => $SystemAddressEmail2,
            ExpectedIsLocal => 1,
        },
        {
            Address         => "dummy$SystemAddressEmail",
            ExpectedIsLocal => 0,
        },
        {
            Address         => "dummy$SystemAddressEmail2",
            ExpectedIsLocal => 0,
        },
        {
            Address         => 'Postmaster',
            ExpectedIsLocal => 0,
        },
    );
    for my $Test (@AddressTests) {
        my $IsLocalAddress = $SystemAddressObject->SystemAddressIsLocalAddress(
            Address => $Test->{Address},
        );
        is(
            ( $IsLocalAddress ? 1 : 0 ),
            $Test->{ExpectedIsLocal},
            "Address $Test->{Address} is local"
        );

        my ($AddressObject) = $EmailAddressObject->ParseAddressLine( Line => $Test->{Address} );
        my $IsLocalAddressObject = $SystemAddressObject->SystemAddressIsLocalAddress(
            AddressObject => $AddressObject,
        );
        is(
            ( $IsLocalAddressObject ? 1 : 0 ),
            $Test->{ExpectedIsLocal},
            "Address object $Test->{Address} is local"
        );
    }
};

done_testing;
