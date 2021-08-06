# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

my $Index1 = $MigObject->_IndexSettingsGet(
    Config => {
        NS          => 5,
        NR          => 10,
        FieldsLimit => 1000,
    }
);

Test2::V0::is(
    $Index1->{NS}, 5,
    '#1 number_of_shards'
);
Test2::V0::is(
    $Index1->{NR}, 10,
    '#1 number_of_replicas'
);
Test2::V0::is(
    $Index1->{FieldsLimit}, 1000,
    '#1 index.mapping.total_fields.limit'
);

# When admin changes Elasticsearch::ArticleIndexCreationSettings, FieldsLimit is missing
my $Index2 = $MigObject->_IndexSettingsGet(
    Config => {
        NS => 5,
        NR => 10,
    }
);
Test2::V0::is(
    $Index2->{FieldsLimit}, 2000,
    '#2 index.mapping.total_fields.limit'
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

my $Expanded = $MigObject->_ExpandTemplate(
    Item   => $Data,
    Config => {
        NS => 0,
        NR => 1,
    },
    LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
);

Test2::V0::is(
    $Expanded->{index}->{number_of_shards}, 'XXX0XXX',
    '#4 number_of_shards template expansion',
);

Test2::V0::is(
    $Expanded->{index}->{scalar}->{number}, 123,
    '#4 expand scalar-number',
);
Test2::V0::is(
    $Expanded->{index}->{scalar}->{string}, '456',
    '#4 expand scalar-string',
);
Test2::V0::is(
    $Expanded->{index}->{scalar}->{nullval}, undef,
    '#4 expand scalar-nullval',
);
Test2::V0::is(
    $Expanded->{index}->{scalar}->{zero}, 0,
    '#4 expand scalar-zero',
);
Test2::V0::is(
    ref $Expanded->{index}->{empty}, 'HASH',
    '#4 expand index-empty',
);
Test2::V0::is(
    $Expanded->{index}->{arraytest}->{array}->[2], 'ghi',
    '#4 expand index-arraytest-array',
);
Test2::V0::is(
    $Expanded->{index}->{arraytest}->{nested}->[1]->{value3}, 789,
    '#4 expand index-arraytest-array',
);
Test2::V0::is(
    ref $Expanded->{index}->{arraytest}->{empty}, 'ARRAY',
    '#4 expand index-arraytest-empty',
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
