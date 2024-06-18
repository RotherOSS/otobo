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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $WebService = 'webservice' . $Helper->GetRandomID();

# get web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

# create a base web service
my $WebServiceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebService,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);

my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $TargetPath = "$Home/var/tmp/$WebService.yaml";

# test cases
my @Tests = (
    {
        Name     => 'No Options',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing webservice-id value',
        Options  => ['--webservice-id'],
        ExitCode => 1,
    },
    {
        Name     => 'Missing target-path',
        Options  => [ '--webservice-id', $WebServiceID ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing target-path value',
        Options  => [ '--webservice-id', $WebServiceID, '--target-path' ],
        ExitCode => 1,
    },
    {
        Name     => 'Wrong webservice-id',
        Options  => [ '--webservice-id', $WebService, '--target-path', $TargetPath ],
        ExitCode => 1,
    },
    {
        Name     => 'Correct Dump',
        Options  => [ '--webservice-id', $WebServiceID, '--target-path', $TargetPath ],
        ExitCode => 0,
    },
);

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::WebService::Dump');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $YAMLObject    = $Kernel::OM->Get('Kernel::System::YAML');

for my $Test (@Tests) {

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name}",
    );

    if ( !$Test->{ExitCode} ) {

        my $WebService = $WebserviceObject->WebserviceGet(
            Name => $WebService,
        );

        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $TargetPath,
            Mode     => 'utf8',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        my $Config = $YAMLObject->Load(
            Data => ${$ContentSCALARRef},
        );

        $Self->IsDeeply(
            $WebService->{Config},
            $Config,
            "$Test->{Name} - web service config"
        );
    }
}

if ( -e $TargetPath ) {

    my $Success = unlink $TargetPath;

    $Self->True(
        $Success,
        "Deleted temporary file $TargetPath with true",
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
