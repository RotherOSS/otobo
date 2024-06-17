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

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Initialize test database based on fresh OTOBO 10 schema.
my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => [
        "$Home/scripts/database/otobo-schema.xml",
        "$Home/scripts/database/otobo-initial_insert.xml",
    ],
);

if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
}
else {
    $Self->True(
        $Success,
        'ProvideTestDatabase - Load and execute OTOBO 10 XML files',
    );

    my @List = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList(
        Result => 'short',
    );

    if (@List) {
        $Self->True(
            0,
            'System should not contain any installed package',
        );
    }

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::UpgradeAll');

    my ( $Result, $ExitCode );
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
        $ExitCode = $CommandObject->Execute();
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->False(
        $ExitCode,
        'Admin::Package::UpgradeAll executes without any issue',
    );
    $Self->IsNot(
        $Result || '',
        '',
        'Admin::Package::UpgradeAll result',
    );
}

$Self->DoneTesting();
