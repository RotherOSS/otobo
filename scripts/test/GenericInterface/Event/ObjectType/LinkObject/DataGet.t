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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %LinkObjectTemplate = (
    SourceObject => 'Ticket',
    SourceKey    => 123,
    TargetObject => 'Ticket',
    TargetKey    => 456,
    Type         => 'ParentChild',
    State        => 'Valid',
);

my %ExpectedDataRaw = %LinkObjectTemplate;

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing SourceObject',
        Config => {
            Data => {
                %LinkObjectTemplate,
                SourceObject => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing SourceKey',
        Config => {
            Data => {
                %LinkObjectTemplate,
                SourceKey => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing TargetObject',
        Config => {
            Data => {
                %LinkObjectTemplate,
                TargetObject => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing TargetKey',
        Config => {
            Data => {
                %LinkObjectTemplate,
                TargetKey => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Type',
        Config => {
            Data => {
                %LinkObjectTemplate,
                Type => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing State',
        Config => {
            Data => {
                %LinkObjectTemplate,
                State => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                %LinkObjectTemplate,
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::LinkObject');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
