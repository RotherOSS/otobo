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

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Shell');

my $DependencyMissing;
for my $Dependency ( 'Devel::REPL', 'Data::Printer' ) {
    $DependencyMissing = 1 if !$Kernel::OM->Get('Kernel::System::Main')->Require( $Dependency, Silent => 1 );
}

if ($DependencyMissing) {
    $Self->True( 1, "Not all prerequisites installed, skipping tests" );
}
else {

    my @Tests = (
        {
            Name     => 'Hello World',
            Code     => "'Hello World!';",
            Result   => '"Hello World!"',
            ExitCode => 0,
        },
        {
            Name     => 'OTOBO Version string',
            Code     => '$Kernel::OM->Get("Kernel::Config")->Get("Version");',
            Result   => '"' . $ConfigObject->Get('Version') . '"',
            ExitCode => 0,
        },
        {
            Name     => 'OTOBO Version variable',
            Code     => 'my $OTOBOVersion = $Kernel::OM->Get("Kernel::Config")->Get("Version");',
            Result   => '"' . $ConfigObject->Get('Version') . '"',
            ExitCode => 0,
        },
        {
            Name   => 'Hash variable',
            Code   => 'my %Hash = ( Test1 => 1, Test2 => 2 )',
            Result => '\ {
        Test1   1,
        Test2   2
    }',
            ExitCode => 0,
        },
        {
            Name   => 'List variable',
            Code   => 'my @List = ( "Test1", 1, "Test1", 2 )',
            Result => '\ [
        [0] "Test1",
        [1] 1,
        [2] "Test1",
        [3] 2
    ]',
            ExitCode => 0,
        },
    );

    for my $Test (@Tests) {

        my $Result;
        my $ExitCode;
        {
            local *STDOUT;
            open STDOUT, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
            $ExitCode = $CommandObject->Execute( '--eval', $Test->{Code} );
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
        }

        $Self->Is(
            $ExitCode,
            $Test->{ExitCode},
            "Dev::Tools::Shell exit code '$Test->{Name}'",
        );

        chomp $Result;

        $Self->Is(
            $Result,
            $Test->{Result},
            "Dev::Tools::Shell output '$Test->{Name}'",
        );
    }
}

$Self->DoneTesting();
