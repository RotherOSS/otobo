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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::RoleLink');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid role)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but role doesn't exist)",
);

# create actual role
my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
    Name    => $RandomName,
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID,
    "Test role is created - $RoleID",
);

# provide minimum options (invalid group)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but group doesn't exist)",
);

# provide minimum options (invalid permission)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', 'admin', '--permission', 'xx' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but invalid permission parameter)",
);

# provide minimum options (all ok)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', 'admin', '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (all ok)",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
