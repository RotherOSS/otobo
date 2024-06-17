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

my $Success = $Helper->ProvideTestDatabase();
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
}
else {
    $Self->True(
        $Success,
        'ProvideTestDatabase - Database cleared',
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @Tables   = $DBObject->ListTables();

    $Self->Is(
        scalar @Tables,
        0,
        'No tables found',
    );

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @DatabaseXMLFiles = (
        "$Home/scripts/database/otobo-schema.xml",
        "$Home/scripts/database/otobo-initial_insert.xml",
    );

    $Success = $Helper->ProvideTestDatabase(
        DatabaseXMLFiles => \@DatabaseXMLFiles,
    );

    $Self->True(
        $Success,
        'ProvideTestDatabase - Load and execute XML files',
    );

    @Tables = $DBObject->ListTables();

    # Count number of table elements in OTOBO schema for comparison.
    my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $DatabaseXMLFiles[0],
    );
    my $TableCount = () = ( ${$XMLString} =~ /<Table/g );

    $Self->Is(
        scalar @Tables,
        $TableCount,
        'OTOBO tables found',
    );
}

# Cleanup is done by TmpDatabaseCleanup().

$Self->DoneTesting();
