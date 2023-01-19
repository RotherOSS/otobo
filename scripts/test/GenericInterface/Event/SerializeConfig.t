# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

# Prevent used once warning
use Kernel::System::ObjectManager;

my @Tests = (
    {
        Name => 'Simple Values',
        Data => {
            Key1 => 1,
            Key2 => 2,
            Key3 => 3,
        },
        ExpectedResult => {
            Key1 => 1,
            Key2 => 2,
            Key3 => 3,
        },
        Success => 1,
    },
    {
        Name => 'Simple Array',
        Data => {
            Key1 => [ 1, 2, 3 ],
        },
        ExpectedResult => {
            Key1_0 => 1,
            Key1_1 => 2,
            Key1_2 => 3,
        },
        Success => 1,
    },
    {
        Name => 'Simple Hash',
        Data => {
            Key1 => {
                KeyA => 1,
                KeyB => 2,
                KeyC => 3
            },
        },
        ExpectedResult => {
            Key1_KeyA => 1,
            Key1_KeyB => 2,
            Key1_KeyC => 3,
        },
        Success => 1,
    },
    {
        Name => 'Hash of Arrays',
        Data => {
            Key1 => {
                KeyA => [ 1, 2, 3 ],
                KeyB => [ 1, 2, 3 ],
                KeyC => [ 1, 2, 3 ],
            },
        },
        ExpectedResult => {
            Key1_KeyA_0 => 1,
            Key1_KeyA_1 => 2,
            Key1_KeyA_2 => 3,
            Key1_KeyB_0 => 1,
            Key1_KeyB_1 => 2,
            Key1_KeyB_2 => 3,
            Key1_KeyC_0 => 1,
            Key1_KeyC_1 => 2,
            Key1_KeyC_2 => 3,
        },
        Success => 1,
    },

    # TODO: This is not supported
    # {
    #     Name => 'Array of Hashes',
    #     Data => {
    #         Key1 => [
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #         ],
    #     },
    #     ExpectedResult => {
    #         Key1_0_KeyA => 1,
    #         Key1_0_KeyB => 2,
    #         Key1_0_KeyC => 3,
    #         Key1_1_KeyA => 1,
    #         Key1_1_KeyB => 2,
    #         Key1_1_KeyC => 3,
    #         Key1_2_KeyA => 1,
    #         Key1_2_KeyB => 2,
    #         Key1_2_KeyC => 3,
    #     },
    #     Success => 1,
    # },
);

my $EventHandlerObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::Handler');

TEST:
for my $Test (@Tests) {

    my %Result;

    my $ConditionCheck = $EventHandlerObject->_SerializeConfig(
        Data  => $Test->{Data},
        SHash => \%Result,
    );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "$Test->{Name} - _SerializeConfig()"
    );
}

$Self->DoneTesting();
