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
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
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

# define needed variable
my $RandomID = $Helper->GetRandomID;

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);

my %GroupData = (
    Name    => 'TestGroup1' . $RandomID,
    Comment => 'TestComment1' . $RandomID,
    ValidID => $ValidID,
);
my %GroupExpectedData = (
    Name    => 'TestGroup1' . $RandomID,
    Comment => 'TestComment1' . $RandomID,
    Valid   => 'valid',
);

# create test group
my $AddSuccess = $GroupObject->GroupAdd(
    %GroupData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'group created successfully' );

# testing export
my $ExportData = $GroupObject->ExportGroups();
is(
    $ExportData,
    hash {
        field 'TestGroup1' . $RandomID => \%GroupExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    Name    => 'TestGroup2' . $RandomID,
    Comment => 'TestComment2' . $RandomID,
    Valid   => 'valid',
);

my $ImportSuccess = $GroupObject->ImportGroups(
    Groups => {
        'TestGroup2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported group successfully' );

my $GroupID = $GroupObject->GroupLookup(
    Group => 'TestGroup2' . $RandomID,
);
my %ImportedGroup = $GroupObject->GroupGet(
    ID => $GroupID,
);
is(
    \%ImportedGroup,
    hash {
        field 'Name'    => 'TestGroup2' . $RandomID;
        field 'Comment' => 'TestComment2' . $RandomID;
        field 'ValidID' => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

done_testing;
