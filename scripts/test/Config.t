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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Value = 'Testvalue';
$ConfigObject->Set(
    Key   => 'ConfigTestkey',
    Value => $Value,
);
my $Get = $ConfigObject->Get('ConfigTestkey');

$Self->Is(
    $Get,
    $Value,
    'Set() and Get()',
);

my $Home = $ConfigObject->Get('Home');
$Self->True(
    $Home,
    'check for configuration setting "Home"',
);

my $ConfigChecksum  = $ConfigObject->ConfigChecksum();
my $ConfigChecksum2 = $ConfigObject->ConfigChecksum();
$Self->True(
    $ConfigChecksum,
    'ConfigChecksum()',
);
$Self->Is(
    $ConfigChecksum,
    $ConfigChecksum2,
    'ConfigChecksum()',
);

# loads the defaults values
$ConfigObject->LoadDefaults();

# obtains the default home path
my $DefaultHome = $ConfigObject->Get('Home');

# changes the home path
my $DummyPath = '/some/dummy/path/that/has/nothing/to/do/with/this';
$ConfigObject->Set(
    Key   => 'Home',
    Value => $DummyPath,
);

# obtains the current home path
my $NewHome = $ConfigObject->Get('Home');

# makes sure that the current home path is the one we set
$Self->Is(
    $NewHome,
    $DummyPath,
    'Test Set() with "Home" - both paths are equivalent.',
);

# makes sure that the default home path and the current are different
$Self->IsNot(
    $NewHome,
    $DefaultHome,
    'Test Set() with "Home" - new path differs from the default.',
);

# loads the defaults values
$ConfigObject->LoadDefaults();

# obtains the default home path
$NewHome = $ConfigObject->Get('Home');

# checks that the default value obtained before is equivalent to the current
$Self->Is(
    $NewHome,
    $DefaultHome,
    'Test LoadDefaults() - both paths are equivalent.',
);

# makes sure that the current path is different from the one we set before loading the defaults
$Self->IsNot(
    $NewHome,
    $DummyPath,
    'Test LoadDefaults() with "Home" - new path differs from the dummy.',
);

$DefaultHome = $NewHome;

# loads the config values
$ConfigObject->Load();

# obtains the current home path
$NewHome = $ConfigObject->Get('Home');

# checks that the config value obtained before is equivalent to the current
$Self->Is(
    $NewHome,
    $Home,
    'Test Load() - both paths are equivalent.',
);

# restore to the previous state is done by RestoreDatabase

$Self->DoneTesting();
