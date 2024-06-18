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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# prepare the environment
my $Success = $Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'DaemonModules###UnitTest1',
    Value => '1',
);
$Self->True(
    $Success,
    "Added UnitTest1 daemon to the config",
);
$Success = $Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'DaemonModules###UnitTest2',
    Value => {
        AnyKey => 1,
    },
);
$Self->True(
    $Success,
    "Added UnitTest2 daemon to the config",
);
$Success = $Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'DaemonModules###UnitTest3',
    Value => {
        Module => 'Kernel::System::Daemon::DaemonModules::NotExistent',
    },
);
$Self->True(
    $Success,
    "Added UnitTest3 daemon to the config",
);

my @Tests = (
    {
        Name     => 'No hash setting daemon module',
        Params   => ['UnitTest1'],
        ExitCode => 1,
    },
    {
        Name     => 'Wrong module setting daemon module',
        Params   => ['UnitTest2'],
        ExitCode => 1,
    },
    {
        Name     => 'Not existing module setting daemon module',
        Params   => ['UnitTest3'],
        ExitCode => 1,
    },
    {
        Name     => 'Not existing daemon module',
        Params   => ['UnitTestNotExisiting'],
        ExitCode => 1,
    },
    {
        Name     => 'SchedulerTaskWorker daemon module',
        Params   => ['SchedulerTaskWorker'],
        ExitCode => 0,
    },
    {
        Name     => 'All daemon modules',
        Params   => [],
        ExitCode => 0,
    },
);

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Daemon::Summary');

for my $Test (@Tests) {

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name} Command exit code",
    );
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
