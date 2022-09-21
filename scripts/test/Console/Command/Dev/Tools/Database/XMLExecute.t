# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Database::XMLExecute');

my ( $Result, $ExitCode );

my $Home           = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $TableCreateXML = "$Home/scripts/test/Console/Command/Dev/Tools/Database/XMLExecute/TableCreate.xml";
my $TableDropXML   = "$Home/scripts/test/Console/Command/Dev/Tools/Database/XMLExecute/TableDrop.xml";

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

$ExitCode = $CommandObject->Execute($TableCreateXML);
$Self->Is(
    $ExitCode,
    0,
    "Table created",
);

my $Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
    SQL => "SELECT * FROM test_xml_execute",
);
$Self->True(
    $Success,
    "SELECT after table create",
);
while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) { }

$ExitCode = $CommandObject->Execute($TableDropXML);
$Self->Is(
    $ExitCode,
    0,
    "Table dropped",
);

$Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
    SQL => "SELECT * FROM test_xml_execute",
);
$Self->False(
    $Success,
    "SELECT after table drop",
);

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
