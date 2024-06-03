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
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get customer user object
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# add two users
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID = $Helper->GetRandomID();

my @CustomerLogins;
for my $Key ( 1 .. 2 ) {

    my $UserRand = 'Duplicate' . $Key . $RandomID;

    my $UserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test' . $Key,
        UserLastname   => 'Lastname Test' . $Key,
        UserCustomerID => $UserRand . '-Customer-Id',
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Email@example.com',
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );

    push @CustomerLogins, $UserID;

    $Self->True(
        $UserID,
        "CustomerUserAdd() - $UserID",
    );

    my $Update = $CustomerUserObject->CustomerUserUpdate(
        Source         => 'CustomerUser',
        ID             => $UserRand,
        UserFirstname  => 'Firstname Test Update' . $Key,
        UserLastname   => 'Lastname Test Update' . $Key,
        UserCustomerID => $UserRand . '-Customer-Update-Id',
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Update@example.com',
        ValidID        => 1,
        UserID         => 1,
    );

    $Self->True(
        $Update,
        "CustomerUserUpdate$Key() - $UserID",
    );
}

my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerLogins[0],
);

my $Customer1Email = $CustomerData{UserEmail};

# create a new customer with email address of customer 1
my $UserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => "Firstname Add $RandomID",
    UserLastname   => "Lastname Add $RandomID",
    UserCustomerID => "CustomerID Add $RandomID",
    UserLogin      => "UserLogin Add $RandomID",
    UserEmail      => $Customer1Email,
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

$Self->False(
    $UserID,
    "CustomerUserAdd() - not possible for duplicate email address",
);

%CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerLogins[1],
);

# update user 1 with email address of customer 2
my $Update = $CustomerUserObject->CustomerUserUpdate(
    %CustomerData,
    Source    => 'CustomerUser',
    ID        => $CustomerData{UserLogin},
    UserEmail => $Customer1Email,
    UserID    => 1,
);

$Self->False(
    $Update,
    "CustomerUserUpdate() - not possible for duplicate email address",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
