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

# get needed objects
my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
my $XMLObject      = $Kernel::OM->Get('Kernel::System::XML');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# -------------------------------------------------------------------------------------------- #
# Test creating a table with a column that needs data type translation in the DB drivers
# -------------------------------------------------------------------------------------------- #
my $XML = '
<Table Name="test_a">
    <Column Name="time_unit" Required="true" Size="10,2" Type="DECIMAL"/>
</Table>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );

# make a copy of the XMLArray (deep clone it),
# it will be needed for a later comparison
my @XMLARRAYCopy = @{ $StorableObject->Clone( Data => \@XMLARRAY ) };

# check that the copy is the same as the original
$Self->IsDeeply(
    \@XMLARRAY,
    \@XMLARRAYCopy,
    '@XMLARRAY equals @XMLARRAYCopy',
);

# create the SQL from the XMLArray
# the function SQLProcessor MUST NOT modify the given array reference
# see also Bug#12764 - Database function SQLProcessor() modifies given parameter data
# https://bugs.otrs.org/show_bug.cgi?id=12764
my @SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() CREATE TABLE',
);

# check that the copy is STILL the same as the original
$Self->IsDeeply(
    \@XMLARRAY,
    \@XMLARRAYCopy,
    '@XMLARRAY equals @XMLARRAYCopy',
);

# cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
