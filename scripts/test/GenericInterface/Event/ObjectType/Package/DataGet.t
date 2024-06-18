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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
my $FileString = $MainObject->FileRead(
    Location => "$Home/scripts/test/sample/PackageManager/TestPackage.opm",
    Mode     => 'utf8',
    Type     => 'Local',
    Result   => 'SCALAR',
);
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $Success       = $PackageObject->RepositoryAdd(
    String    => ${$FileString},
    FromCloud => 0,
);
$Self->True(
    $Success,
    'RepositoryAdd()',
);

my %ExpectedDataRaw = $PackageObject->PackageParse(
    String => ${$FileString},
);
$ExpectedDataRaw{MD5sum} = $MainObject->MD5sum( String => $FileString );
$ExpectedDataRaw{Status} = 'not installed';

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                Name => 'Test',
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::Package');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
