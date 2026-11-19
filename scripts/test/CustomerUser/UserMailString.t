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
use File::Basename qw(basename);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create non existing customer user login
my $UserRand;
{
    TRY:
    for my $Try ( 1 .. 20 ) {

        $UserRand = basename(__FILE__) . $Helper->GetRandomID;

        my %UserData = $CustomerUserObject->CustomerUserDataGet(
            User => $UserRand,
        );

        last TRY unless %UserData;

        next TRY unless $Try == 20;

        bail_out('Did not find non existing customer user login.');
    }
}

my %OriginalUserParams = (
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserTitle      => '',
    UserCustomerID => $UserRand . '-Customer-Id',
    UserLogin      => $UserRand,
    UserEmail      => $UserRand . '-Email@example.com',
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);
my $UserID = $CustomerUserObject->CustomerUserAdd(
    %OriginalUserParams,
);

ok( $UserID, "CustomerUserAdd() - $UserRand" );

# Test UserMailString in dependence of first name, last name, email, CustomerUserListFields
my @Tests = (
    {
        Name                   => 'regular case',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Stefanie Schmidt" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'last name first',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'last_name', 'first_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Schmidt Stefanie" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'inner spaces',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Sabine     Stefanie',                                                            # 5 spaces
        UserLastname           => 'Schmidt  (geb. Schmid)',                                                         # 2 spaces
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Sabine     Stefanie Schmidt  (geb. Schmid)" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'outer spaces',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => '   Stefanie   ',                                                                 # 3 spaces
        UserLastname           => '  Schmidt  ',                                                                    # 2 spaces
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"   Stefanie      Schmidt  " <Stefanie.Schmidt@example.org>},                   # 3+1+2 spaces between 'Stefanie' and 'Schmidt'
    },
    {
        Name                   => 'quotes in name',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'one quote " in first name',
        UserLastname           => 'two quotes "" in last name',
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"one quote \" in first name two quotes \"\" in last name" <Stefanie.Schmidt@example.org>},
    },
    {
        # In this test case we consistently escape backslash with a backslash in single quoted strings,
        # even when that is not required by Perl.
        Name                   => 'backslashes in name',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'one backslash \\ in first name',
        UserLastname           => 'two backslashes \\\\ in last name',
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"one backslash \\\\ in first name two backslashes \\\\\\\\ in last name" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'empty title in the middle',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'title', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Stefanie Schmidt" <Stefanie.Schmidt@example.org>},    # 1 space between 'Stefanie' and 'Schmidt' as the empty title is discarded
    },
    {
        Name                   => 'non empty title in the middle',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'title', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => 'von',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Stefanie von Schmidt" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'title 0 in the middle',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'title', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '0',
        UserEmail              => 'Stefanie.Schmidt@example.org',
        ExpectedUserMailString => q{"Stefanie 0 Schmidt" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'original email enclosed in <>',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '0',
        UserEmail              => '<Stefanie.Schmidt@example.org>',
        ExpectedUserMailString => q{Stefanie Schmidt <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'original email with single word phrase',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '0',
        UserEmail              => 'word <Stefanie.Schmidt@example.org>',
        ExpectedUserMailString => q{Stefanie Schmidt word <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'original email with multi word phrase',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '0',
        UserEmail              => '"two    words" <Stefanie.Schmidt@example.org>',
        ExpectedUserMailString => q{Stefanie Schmidt "two    words" <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'original email with multi word phrase not enclosed by quotes',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Stefanie',
        UserLastname           => 'Schmidt',
        UserTitle              => '0',
        UserEmail              => 'two    words <Stefanie.Schmidt@example.org>',
        ExpectedUserMailString => q{Stefanie Schmidt two    words <Stefanie.Schmidt@example.org>},
    },
    {
        Name                   => 'snowman ⛄',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Snowman',
        UserLastname           => '⛄',
        UserTitle              => '',
        UserEmail              => 'Snow.Man@example.org',
        ExpectedUserMailString => q{"Snowman ⛄" <Snow.Man@example.org>},
    },
    {
        Name                   => 'non-existing user list fields',
        Line                   => __LINE__,
        CustomerUserListFields => [ '', -2.33, 0, 'first_name', 'blubber', undef, 'last_name', 'email', 'not an email' ],
        UserFirstname          => 'Snowman',
        UserLastname           => '⛄',
        UserTitle              => '',
        UserEmail              => 'Snow.Man@example.org',
        ExpectedUserMailString => q{"Snowman ⛄" <Snow.Man@example.org>},
    },
    {
        Name                   => 'with title',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'title', 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Snowman',
        UserLastname           => '⛄',
        UserTitle              => 'Giant',
        UserEmail              => 'Snow.Man@example.org',
        ExpectedUserMailString => q{"Giant Snowman ⛄" <Snow.Man@example.org>},
    },
    {
        Name                   => 'title consisting of five spaces',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'title', 'first_name', 'last_name', 'email' ],
        UserFirstname          => 'Snowman',
        UserLastname           => '⛄',
        UserTitle              => '     ',
        UserEmail              => 'Snow.Man@example.org',
        ExpectedUserMailString => q{"      Snowman ⛄" <Snow.Man@example.org>},       # 5+1 spaces before 'Snowman'
    },
    {
        Name                   => 'single word phrase without quotation marks',
        Line                   => __LINE__,
        CustomerUserListFields => [ 'first_name', 'email' ],
        UserFirstname          => 'Snowman',
        UserLastname           => '⛄',
        UserTitle              => 'Giant',
        UserEmail              => 'Snow.Man@example.org',
        ExpectedUserMailString => q{Snowman <Snow.Man@example.org>},                 # 5+1 spaces before 'Snowman'
    },
);

for my $Test (@Tests) {
    subtest "$Test->{Name} (line $Test->{Line})" => sub {

        my $UpdateSuccess = $CustomerUserObject->CustomerUserUpdate(
            %OriginalUserParams,
            ID => $UserRand,
            $Test->%{qw(UserTitle UserFirstname UserLastname UserEmail)},
        );
        ok( $UpdateSuccess, "CustomerUserUpdate()" );

        # tweak which fields are used for UserMailString
        local $CustomerUserObject->{CustomerUser}->{CustomerUserMap}->{CustomerUserListFields} = $Test->{CustomerUserListFields};

        my %User = $CustomerUserObject->CustomerUserDataGet(
            User => $UserID,
        );

        # expect the changed fields
        is( $User{UserLogin},     $UserRand,              'UserLogin' );
        is( $User{UserTitle},     $Test->{UserTitle},     'UserTitle' );
        is( $User{UserFirstname}, $Test->{UserFirstname}, 'UserFirstname' );
        is( $User{UserLastname},  $Test->{UserLastname},  'UserLastname' );
        is( $User{UserEmail},     $Test->{UserEmail},     'UserEmail' );
        note("UserMailString: -->$User{UserMailString}<--");
        is( $User{UserMailString}, $Test->{ExpectedUserMailString}, 'ExpectedUserMailString' );
    };
}

done_testing;
