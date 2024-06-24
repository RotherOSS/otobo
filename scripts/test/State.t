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

# get state object
my $StateObject = $Kernel::OM->Get('Kernel::System::State');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add state
my $StateName = 'state' . $Helper->GetRandomID();
my $StateID   = $StateObject->StateAdd(
    Name    => $StateName,
    Comment => 'some comment',
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

$Self->True(
    $StateID,
    'StateAdd()',
);

my %State = $StateObject->StateGet( ID => $StateID );

$Self->True(
    $State{Name} eq $StateName,
    'StateGet() - Name',
);
$Self->True(
    $State{Comment} eq 'some comment',
    'StateGet() - Comment',
);
$Self->True(
    $State{ValidID} eq 1,
    'StateGet() - ValidID',
);

my %StateList = $StateObject->StateList(
    UserID => 1,
);
$Self->True(
    exists $StateList{$StateID} && $StateList{$StateID} eq $StateName,
    'StateList() contains the state ' . $StateName . ' with ID ' . $StateID,
);

my $StateType = $StateObject->StateTypeLookup(
    StateTypeID => 1,
);

$Self->True(
    $StateType,
    'StateTypeLookup()',
);

my @List = $StateObject->StateGetStatesByType(
    StateType => [$StateType],
    Result    => 'ID',
);
$Self->True(
    ( grep { $_ eq $StateID } @List ),
    "StateGetStatesByType() contains the state $StateName with ID $StateID",
);

my $StateNameUpdate = $StateName . 'update';
my $StateUpdate     = $StateObject->StateUpdate(
    ID      => $StateID,
    Name    => $StateNameUpdate,
    Comment => 'some comment 1',
    ValidID => 2,
    TypeID  => 1,
    UserID  => 1,
);

$Self->True(
    $StateUpdate,
    'StateUpdate()',
);

%State = $StateObject->StateGet( ID => $StateID );

$Self->True(
    $State{Name} eq $StateNameUpdate,
    'StateGet() - Name',
);
$Self->True(
    $State{Comment} eq 'some comment 1',
    'StateGet() - Comment',
);
$Self->True(
    $State{ValidID} eq 2,
    'StateGet() - ValidID',
);

@List = $StateObject->StateGetStatesByType(
    StateType => [$StateType],
    Result    => 'ID',
);
$Self->True(
    grep { $_ ne $StateID } @List,
    "StateGetStatesByType() does not contain the state $StateNameUpdate with ID $StateID",
);

my %StateTypeList = $StateObject->StateTypeList(
    UserID => 1,
);

$Self->True(
    ( grep { $_ eq 'new' } values %StateTypeList ),
    "StateGetStatesByType() does not contain the state 'new'",
);

$Self->True(
    ( grep { $_ eq 'open' } values %StateTypeList ),
    "StateGetStatesByType() does not contain the state 'open'",
);

# Check log message if StateGet is not found any data.
# See PR#2009 for more information ( https://github.com/OTRS/otrs/pull/2009 ).
my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
%State = $StateObject->StateGet( ID => '999999' );

my $ErrorMessage = $LogObject->GetLogEntry(
    Type => 'error',
    What => 'Message',
);

$Self->Is(
    $ErrorMessage,
    "StateID '999999' not found!",
    "StateGet() - '999999' not found",
);

my $NoDataState = 'no_data_state' . $Helper->GetRandomID();
%State = $StateObject->StateGet( Name => $NoDataState );

$ErrorMessage = $LogObject->GetLogEntry(
    Type => 'error',
    What => 'Message',
);

$Self->Is(
    $ErrorMessage,
    "State '$NoDataState' not found!",
    "StateGet() - $NoDataState not found",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
