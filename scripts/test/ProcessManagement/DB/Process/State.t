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

use Kernel::System::VariableCheck qw(:all);

# get state objects
my $StateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process::State');

my $LocalStateList = $StateObject->{StateList};

my $UserID = 1;

#
# StateList tests
#
my $StateList = $StateObject->StateList();

$Self->IsNot(
    ref $StateList,
    'HASH',
    'StateList Test 1: Empty params | should not be HASH',
);
$Self->Is(
    $StateList,
    undef,
    'StateList Test 1: Empty params | should be undef',
);

$StateList = $StateObject->StateList( UserID => $UserID );

$Self->Is(
    ref $StateList,
    'HASH',
    'StateList Test 1: Empty params | should be HASH',
);
$Self->IsDeeply(
    $StateList,
    $LocalStateList,
    'StateList Test 2: Correct | should be undef',
);

#
# StateLookup tests
#
my @Tests = (
    {
        Name    => 'StateLookup Test1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'StateLookup Test2: No EntityID and Name',
        Config => {
            EntityID => undef,
            Name     => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test3: No UserID',
        Config => {
            ID     => 'S1',
            Name   => undef,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test4: Wrong EntityID',
        Config => {
            EntityID => 'NonExistent',
            Name     => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test5: Wrong Name',
        Config => {
            EntityID => undef,
            Name     => 'NonExistent',
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test6: EntityID 1',
        Config => {
            EntityID => 'S1',
            Name     => undef,
            UserID   => $UserID,
        },
        Result  => 'Active',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test7: EntityID 2',
        Config => {
            EntityID => 'S2',
            Name     => undef,
            UserID   => $UserID,
        },
        Result  => 'Inactive',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test8: EntityID 3',
        Config => {
            EntityID => 'S3',
            Name     => undef,
            UserID   => $UserID,
        },
        Result  => 'FadeAway',
        Success => 1,
    },

    {
        Name   => 'StateLookup Test9: Name Active',
        Config => {
            EntityID => undef,
            Name     => 'Active',
            UserID   => $UserID,
        },
        Result  => 'S1',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test10: Name Inactive',
        Config => {
            EntityID => undef,
            Name     => 'Inactive',
            UserID   => $UserID,
        },
        Result  => 'S2',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test11: Name FadeAway',
        Config => {
            EntotyID => undef,
            Name     => 'FadeAway',
            UserID   => $UserID,
        },
        Result  => 'S3',
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Result = $StateObject->StateLookup( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $Result,
            undef,
            "$Test->{Name} | Result should not undef",
        );
        $Self->Is(
            $Result,
            $Test->{Result},
            "$Test->{Name} | Result should be $Test->{Result}",
        );
    }
    else {
        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} | Result should be undef",
        );
    }
}

$Self->DoneTesting();
