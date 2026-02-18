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
my $SLAObject     = $Kernel::OM->Get('Kernel::System::SLA');
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
my $ValidObject   = $Kernel::OM->Get('Kernel::System::Valid');

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
    Key   => 'Ticket::Service',
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

my %ServiceData = (
    Name    => 'TestService1' . $RandomID,
    Comment => 'TestComment1' . $RandomID,
    ValidID => $ValidID,
);
my %ServiceExpectedData = (
    Name      => 'TestService1' . $RandomID,
    NameShort => 'TestService1' . $RandomID,
    Comment   => 'TestComment1' . $RandomID,
    Valid     => 'valid',
);

# create test service
my $AddSuccess = $ServiceObject->ServiceAdd(
    %ServiceData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'service created successfully' );

# testing export
my $ExportData = $ServiceObject->ExportServices(
    UserID => $TestUserID,
);
is(
    $ExportData,
    hash {
        field 'TestService1' . $RandomID => \%ServiceExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    Name      => 'TestService2' . $RandomID,
    NameShort => 'TestService2' . $RandomID,
    Comment   => 'TestComment2' . $RandomID,
    Valid     => 'valid',
);

my $ImportSuccess = $ServiceObject->ImportServices(
    Services => {
        'TestService2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported service successfully' );

my $ServiceID = $ServiceObject->ServiceLookup(
    Name => 'TestService2' . $RandomID,
);
my %ImportedService = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => $TestUserID,
);
is(
    \%ImportedService,
    hash {
        field 'Name'      => 'TestService2' . $RandomID;
        field 'NameShort' => 'TestService2' . $RandomID;
        field 'Comment'   => 'TestComment2' . $RandomID;
        field 'ValidID'   => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

# testing sla
my %SLAData = (
    ServiceIDs          => [$ServiceID],
    Name                => 'TestSLA1' . $RandomID,
    Calendar            => '',
    FirstResponseTime   => 0,
    FirstResponseNotify => 0,
    UpdateTime          => 0,
    UpdateNotify        => 0,
    SolutionTime        => 0,
    SolutionNotify      => 0,
    ValidID             => $ValidID,
    Comment             => 'TestComment1' . $RandomID,
);
my %SLAExpectedData = (
    Services            => [ 'TestService2' . $RandomID ],
    Name                => 'TestSLA1' . $RandomID,
    Calendar            => '',
    FirstResponseTime   => 0,
    FirstResponseNotify => 0,
    UpdateTime          => 0,
    UpdateNotify        => 0,
    SolutionTime        => 0,
    SolutionNotify      => 0,
    Valid               => 'valid',
    Comment             => 'TestComment1' . $RandomID,
);

my $SLAAddSuccess = $SLAObject->SLAAdd(
    %SLAData,
    UserID => $TestUserID,
);
ok( $SLAAddSuccess, 'added SLA successfully' );

# testing export
my $SLAExportData = $SLAObject->ExportSLAs(
    UserID => $TestUserID,
);
is(
    $SLAExportData,
    hash {
        field 'TestSLA1' . $RandomID => \%SLAExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %SLAImportData = (
    Services            => [ 'TestService2' . $RandomID ],
    Name                => 'TestSLA2' . $RandomID,
    Calendar            => '',
    FirstResponseTime   => 0,
    FirstResponseNotify => 0,
    UpdateTime          => 0,
    UpdateNotify        => 0,
    SolutionTime        => 0,
    SolutionNotify      => 0,
    Valid               => 'valid',
    Comment             => 'TestComment2' . $RandomID,
);

my $SLAImportSuccess = $SLAObject->ImportSLAs(
    SLAs => {
        'TestSLA2' . $RandomID => \%SLAImportData,
    },
    UserID => $TestUserID,
);
ok( $SLAImportSuccess, 'imported SLA successfully' );

my $SLAID = $SLAObject->SLALookup(
    Name => 'TestSLA2' . $RandomID,
);
my %ImportedSLA = $SLAObject->SLAGet(
    SLAID  => $SLAID,
    UserID => $TestUserID,
);
is(
    \%ImportedSLA,
    hash {
        field 'ServiceIDs'          => [$ServiceID];
        field 'Name'                => 'TestSLA2' . $RandomID;
        field 'Calendar'            => '';
        field 'FirstResponseTime'   => 0;
        field 'FirstResponseNotify' => 0;
        field 'UpdateTime'          => 0;
        field 'UpdateNotify'        => 0;
        field 'SolutionTime'        => 0;
        field 'SolutionNotify'      => 0;
        field 'ValidID'             => $ValidID;
        field 'Comment'             => 'TestComment2' . $RandomID;

        etc();
    },
    'imported data looks as expected'
);

done_testing;
