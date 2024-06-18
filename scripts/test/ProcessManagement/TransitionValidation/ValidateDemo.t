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

# get needed objects
my $HelperObject     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ValidationObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo');

# sanity check
$Self->Is(
    ref $ValidationObject,
    'Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo',
    "ValidationObject created successfully",
);

my @Tests = (
    {
        Name    => '1 - No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => '2 - No Data',
        Config => {
            Data => undef,
        },
        Success => 0,
    },
    {
        Name   => '3 - No Queue',
        Config => {
            Data => {
                Queue => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => '4 - Wrong Data Format',
        Config => {
            Data => 'Data',
        },
        Success => 0,
    },
    {
        Name   => '5 - Wrong Queue format',
        Config => {
            Data => {
                Queue => {
                    Name => 'Raw'
                },
            },
        },
        Success => 0,
    },
    {
        Name   => '6 - Empty Queue',
        Config => {
            Data => {
                Queue => '',
            },
        },
        Success => 0,
    },
    {
        Name   => '7 - Wrong Queue (Misc)',
        Config => {
            Data => {
                Queue => 'Misc',
            },
        },
        Success => 0,
    },
    {
        Name   => '8 - Correct Queue (Raw)',
        Config => {
            Data => {
                Queue => 'Raw',
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    my $ValidateResult = $ValidationObject->Validate( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            $ValidateResult,
            1,
            "Validate() ValidationDemo for test $Test->{Name} should return 1",
        );
    }
    else {
        $Self->IsNot(
            $ValidateResult,
            1,
            "Validate() ValidationDemo for test $Test->{Name} should not return 1",
        );
    }
}

$Self->DoneTesting();
