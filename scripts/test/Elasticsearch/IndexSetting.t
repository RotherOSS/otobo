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

use Test2::V0;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $MigObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Elasticsearch::Migration');
my $ESObject  = $Kernel::OM->Get('Kernel::System::Elasticsearch');

my $Template = {
    number_of_shards                   => '[% Data.NS | uri %]',
    number_of_replicas                 => '[% Data.NR | uri %]',
    'index.mapping.total_fields.limit' => 2000,
};

my $Index1 = $ESObject->IndexSettingsGet(
    Config => {
        NS          => 5,
        NR          => 10,
        FieldsLimit => 1000,
    },
    Template => $Template,
);

is(
    $Index1->{number_of_shards}, 5,
    '#1 number_of_shards'
);
is(
    $Index1->{number_of_replicas}, 10,
    '#1 number_of_replicas'
);

# FieldsLimit can not be changed by settings/sysconfig
is(
    $Index1->{'index.mapping.total_fields.limit'}, 2000,
    '#1 index.mapping.total_fields.limit'
);

# Missing settings are taken from the template
my $Index2 = $ESObject->IndexSettingsGet(
    Config => {
        NS => 5,
        NR => 10,
    },
    Template => $Template,
);
is(
    $Index2->{'index.mapping.total_fields.limit'}, 2000,
    '#2 missing settings'
);

# Expansion test
my $Data = {
    index => {
        number_of_shards   => 'XXX[% Data.NS |uri %]XXX',
        number_of_replicas => '[% Data.NR |uri %]',
        scalar             => {
            number  => 123,
            string  => '456',
            nullval => undef,
            zero    => 0,
        },
        empty     => {},
        arraytest => {
            array  => [ 'abc', 'def', 'ghi' ],
            nested => [
                { value1 => 123 },
                {
                    value2 => 456,
                    value3 => 789
                },
            ],
            empty => [],
        },
    },
    'index.mapping.total_fields.limit' => 2000,
};

my $Expanded = $ESObject->_ExpandTemplate(
    Item   => $Data,
    Config => {
        NS => 0,
        NR => 1,
    },
    LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
);

is(
    $Expanded->{index}->{number_of_shards}, 'XXX0XXX',
    '#3 number_of_shards template expansion',
);

is(
    $Expanded->{index}->{scalar}->{number}, 123,
    '#3 expand scalar-number',
);
is(
    $Expanded->{index}->{scalar}->{string}, '456',
    '#3 expand scalar-string',
);
is(
    $Expanded->{index}->{scalar}->{nullval}, undef,
    '#3 expand scalar-nullval',
);
is(
    $Expanded->{index}->{scalar}->{zero}, 0,
    '#3 expand scalar-zero',
);
is(
    ref $Expanded->{index}->{empty}, 'HASH',
    '#3 expand index-empty',
);
is(
    $Expanded->{index}->{arraytest}->{array}->[2], 'ghi',
    '#3 expand index-arraytest-array (string)',
);
is(
    $Expanded->{index}->{arraytest}->{nested}->[1]->{value3}, 789,
    '#3 expand index-arraytest-array (number)',
);
is(
    ref $Expanded->{index}->{arraytest}->{empty}, 'ARRAY',
    '#3 expand index-arraytest-empty',
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
