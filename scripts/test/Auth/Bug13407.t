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

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# configure auth backend to db
$ConfigObject->Set(
    Key   => 'AuthBackend',
    Value => 'DB',
);

# no additional auth backends
for my $Count ( 1 .. 10 ) {

    $ConfigObject->Set(
        Key   => "AuthBackend$Count",
        Value => '',
    );
}

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TestUserID;
my $UserRand = 'example-user' . $Helper->GetRandomID();

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add test user
$TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

# make sure that the customer user objects gets recreated for each loop.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::User',
        'Kernel::System::Auth',
    ],
);

my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

my $PasswordSet = $UserObject->SetPassword(
    UserLogin => $UserRand,
    PW        => '123',
);

$Self->True(
    $PasswordSet,
    "Password set"
);

my $AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    $UserRand,
    "First authentication ok",
);

$ConfigObject->Get('PreferencesGroups')->{Password}->{PasswordMaxLoginFailed} = 2;

for ( 1 .. 2 ) {
    $AuthResult = $AuthObject->Auth(
        User => $UserRand,
        Pw   => 'wrong',
    );

    $Self->Is(
        $AuthResult,
        undef,
        "Wrong authentication",
    );
}

$AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    undef,
    "Authentication not possible any more after too many failures",
);

my %User = $UserObject->GetUserData(
    UserID => $TestUserID,
);
delete $User{UserPw};    # Don't update/break password.

my $Update = $UserObject->UserUpdate(
    %User,
    ValidID      => 1,
    ChangeUserID => 1,
);

$Self->True(
    $Update,
    "User revalidated"
);

$AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    $UserRand,
    "Authentication possible again after revalidation",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
