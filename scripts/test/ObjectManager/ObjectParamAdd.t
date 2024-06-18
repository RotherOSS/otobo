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
use v5.24;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Kernel::OM
use Kernel::System::ObjectManager;

my $ObjectManager = Kernel::System::ObjectManager->new();

$ObjectManager->ObjectParamAdd(
    'Kernel::Config' => {
        Data => 'Test payload',
    },
);

is(
    $ObjectManager->{Param}->{'Kernel::Config'},
    {
        Data => 'Test payload',
    },
    'ObjectParamAdd set key',
);

$ObjectManager->ObjectParamAdd(
    'Kernel::Config' => {
        Data2 => 'Test payload 2',
    },
);
is(
    $ObjectManager->{Param}->{'Kernel::Config'},
    {
        Data  => 'Test payload',
        Data2 => 'Test payload 2',
    },
    'ObjectParamAdd set key',
);

$ObjectManager->ObjectParamAdd(
    'Kernel::Config' => {
        Data  => undef,
        Data3 => undef,
    },
);
is(
    $ObjectManager->{Param}->{'Kernel::Config'},
    {
        Data  => undef,
        Data2 => 'Test payload 2',
        Data3 => undef,
    },
    'ObjectParamAdd keys with undefined value',
);

$ObjectManager->ObjectParamAdd(
    'Kernel::Config' => {
        Data2 => undef,
    },
);

is(
    $ObjectManager->{Param}->{'Kernel::Config'},
    {
        Data  => undef,
        Data2 => undef,
        Data3 => undef,
    },
    'ObjectParamAdd another key with undefined value',
);

done_testing;
