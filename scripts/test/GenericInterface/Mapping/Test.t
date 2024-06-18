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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::GenericInterface::Debugger ();
use Kernel::GenericInterface::Mapping  ();

our $Self;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create a mapping instance
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type => 'Test',
    },
);
$Self->Is(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'MappingObject was correctly instantiated',
);

my @MappingTests = (
    {
        Name   => 'Test ToUpper',
        Config => { TestOption => 'ToUpper' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'ONE',
            two   => 'TWO',
            three => 'THREE',
            four  => 'FOUR',
            five  => 'FIVE',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test ToLower',
        Config => { TestOption => 'ToLower' },
        Data   => {
            one   => 'ONE',
            two   => 'TWO',
            three => 'THREE',
            four  => 'FOUR',
            five  => 'FIVE',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test Empty',
        Config => { TestOption => 'Empty' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => '',
            two   => '',
            three => '',
            four  => '',
            five  => '',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test without TestOption',
        Config => { TestOption => '' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test with unknown TestOption',
        Config => { TestOption => 'blah' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name          => 'Test with no Data',
        Config        => { TestOption => 'no data' },
        Data          => undef,
        ResultData    => {},
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name          => 'Test with empty Data',
        Config        => { TestOption => 'empty data' },
        Data          => {},
        ResultData    => {},
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name          => 'Test with wrong Data',
        Config        => { TestOption => 'no data' },
        Data          => [],
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1
    },
    {
        Name          => 'Test with wrong TestOption',
        Config        => { TestOption => 7 },
        Data          => 'something for data',
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test with a wrong TestOption',
        Config => { TestOption => 'ThisShouldBeAWrongTestOption' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },

);

TEST:
for my $Test (@MappingTests) {

    # create a mapping instance
    my $MappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'Test',
            Config => $Test->{Config},
        },
    );
    if ( $Test->{ConfigSuccess} ) {
        $Self->Is(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was correctly instantiated',
        );
        next TEST if ref $MappingObject ne 'Kernel::GenericInterface::Mapping';
    }
    else {
        $Self->IsNot(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was not correctly instantiated',
        );
        next TEST;
    }

    my $MappingResult = $MappingObject->Map(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $MappingResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' error message found',
        );
    }

    # instantiate another object
    my $SecondMappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'Test',
            Config => $Test->{Config},
        },
    );

    $Self->Is(
        ref $SecondMappingObject,
        'Kernel::GenericInterface::Mapping',
        $Test->{Name} . ' SecondMappingObject was correctly instantiated',
    );
}

$Self->DoneTesting();
