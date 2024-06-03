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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::GenericInterface::DebugLog::Cleanup');

my ( $Result, $ExitCode );

my @Tests = (
    {
        Name     => 'No Params',
        Config   => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing created-before-days value',
        Config   => ['--created-before-days'],
        ExitCode => 1,
    },
    {
        Name     => 'Negative created-before-days value',
        Config   => [ '--created-before-days', '-1' ],
        ExitCode => 1,
    },
    {
        Name     => '0 created-before-days value',
        Config   => [ '--created-before-days', '0' ],
        ExitCode => 1,
    },
    {
        Name     => '20 years ago created-before-days value',
        Config   => [ '--created-before-days', 7_300 ],
        ExitCode => 0,
    },
);

for my $Test (@Tests) {

    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
        $ExitCode = $CommandObject->Execute( @{ $Test->{Config} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name} ExitCode",
    );
}

$Self->DoneTesting();
