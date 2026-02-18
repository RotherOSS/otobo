# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0 qw(:DEFAULT), qw(etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $TypeObject  = $Kernel::OM->Get('Kernel::System::Type');
my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# activate sysconfig setting
$Helper->ConfigSettingChange(
    Key   => 'Ticket::Type',
    Valid => 1,
    Value => 1,
);

# define needed variable
my $RandomID = $Helper->GetRandomID;

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);

my %TypeData = (
    Name    => 'TestType1' . $RandomID,
    ValidID => $ValidID,
);
my %TypeExpectedData = (
    Name  => 'TestType1' . $RandomID,
    Valid => 'valid',
);

# create test type
my $AddSuccess = $TypeObject->TypeAdd(
    %TypeData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'type created successfully' );

# testing export
my $ExportData = $TypeObject->ExportTypes();
is(
    $ExportData,
    hash {
        field 'TestType1' . $RandomID => \%TypeExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    Name  => 'TestType2' . $RandomID,
    Valid => 'valid',
);

my $ImportSuccess = $TypeObject->ImportTypes(
    Types => {
        'TestType2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported type successfully' );

my $TypeID = $TypeObject->TypeLookup(
    Type => 'TestType2' . $RandomID,
);
my %ImportedType = $TypeObject->TypeGet(
    ID => $TypeID,
);
is(
    \%ImportedType,
    hash {
        field 'Name'    => 'TestType2' . $RandomID;
        field 'ValidID' => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

done_testing;
