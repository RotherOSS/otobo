# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

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

my $UserRandom = 'unittest-' . $Helper->GetRandomID();
my $UserID     = $UserObject->UserAdd(
    UserFirstname => 'John',
    UserLastname  => 'Doe',
    UserLogin     => $UserRandom,
    UserEmail     => $UserRandom . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    "UserID $UserID is created",
);

my %Tests = (
    0 => "John Doe",
    1 => "Doe, John",
    2 => "John Doe ($UserRandom)",
    3 => "Doe, John ($UserRandom)",
    4 => "($UserRandom) John Doe",
    5 => "($UserRandom) Doe, John",
    6 => "Doe John",
    7 => "Doe John ($UserRandom)",
    8 => "($UserRandom) Doe John",
    9 => "DoeJohn",                   # chinese
);

for my $Order ( sort keys %Tests ) {
    $ConfigObject->Set(
        Key   => 'FirstnameLastnameOrder',
        Value => $Order,
    );
    $Self->Is(
        $UserObject->UserName( UserID => $UserID ),
        $Tests{$Order},
        "UserName FirstnameLastnameOrder $Order",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
