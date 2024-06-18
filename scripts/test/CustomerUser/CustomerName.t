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

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID  = $Helper->GetRandomID();
my $Firstname = "Firstname$RandomID";
my $Lastname  = "Lastname$RandomID";
my $Login     = "Login$RandomID";

# Create test customer user.
my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $Firstname,
    UserLastname   => $Lastname,
    UserCustomerID => "Customer$RandomID",
    UserLogin      => $Login,
    UserEmail      => "$Login\@example.com",
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserID,
    "CustomerUserID $CustomerUserID is created",
);

my $CustomerUserConfig = $ConfigObject->Get('CustomerUser');

my @Tests = (
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname###$Lastname"
    },
    {
        CustomerUserNameFieldsJoin => '***',
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname***$Lastname"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'first_name', 'last_name' ],
        ExpectedResult             => "$Firstname $Lastname"
    },
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname###$Firstname"
    },
    {
        CustomerUserNameFieldsJoin => '***',
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname***$Firstname"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'last_name', 'first_name' ],
        ExpectedResult             => "$Lastname $Firstname"
    },
    {
        CustomerUserNameFieldsJoin => '###',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname###$Lastname###$Login"
    },
    {
        CustomerUserNameFieldsJoin => undef,
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname $Lastname $Login"
    },
    {
        CustomerUserNameFieldsJoin => ' ',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname $Lastname $Login"
    },
    {
        CustomerUserNameFieldsJoin => '',
        CustomerUserNameFields     => [ 'first_name', 'last_name', 'login' ],
        ExpectedResult             => "$Firstname$Lastname$Login"
    },
);

for my $Test (@Tests) {

    $CustomerUserConfig->{CustomerUserNameFieldsJoin} = $Test->{CustomerUserNameFieldsJoin};
    $CustomerUserConfig->{CustomerUserNameFields}     = $Test->{CustomerUserNameFields};

    $Helper->ConfigSettingChange(
        Key   => 'CustomerUser',
        Value => $CustomerUserConfig,
    );

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => $Login,
    );

    $Self->Is(
        $Name,
        $Test->{ExpectedResult},
        "ExpectedResult '$Test->{ExpectedResult}' is correct",
    );

    $CacheObject->CleanUp();
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
