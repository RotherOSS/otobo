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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $WebService = 'webservice' . $Helper->GetRandomID();

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test cases
my @Tests = (
    {
        Name     => 'No Options',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing name value',
        Options  => ['--name'],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path',
        Options  => [ '--name', $WebService ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path value',
        Options  => [ '--name', $WebService, '--source-path' ],
        ExitCode => 1,
    },

    {
        Name     => 'Non existing source-path',
        Options  => [ '--name', $WebService, '--source-path', $WebService ],
        ExitCode => 1,
    },
    {
        Name    => 'Non YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.wsdl"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Non web service YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/BookOrdering.yml"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Correct YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.yml"
        ],
        ExitCode => 0,
    },
    {
        Name    => 'Duplicate name',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.yml"
        ],
        ExitCode => 1,
    },
);

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::WebService::Add');

for my $Test (@Tests) {

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name}",
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
