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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::CustomerLink');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid customer)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $RandomName, '--group-name', $RandomName, '--permission',
    'ro'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but customer user doesn't exist)",
);

my $CustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $RandomName,
    UserLastname   => $RandomName,
    UserCustomerID => $RandomName,
    UserLogin      => $RandomName,
    UserEmail      => $RandomName . '@example.com',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserLogin,
    "Test customer is created - $CustomerUserLogin",
);

# provide minimum options (invalid group)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', $RandomName,
    '--permission',          'ro'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but group doesn't exist)",
);

# provide minimum options (invalid permission)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', 'users', '--permission',
    'xx'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but invalid permission parameter)",
);

# provide minimum options (okay)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', 'users', '--permission',
    'ro'
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay)",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
