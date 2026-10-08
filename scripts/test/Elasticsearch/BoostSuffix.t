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
use List::Util qw(any);
use Test2::V0;


use Kernel::GenericInterface::Invoker::Elasticsearch::ManagementCommon qw(RemoveESWeightedSearchBoostSuffix);

my @Tests = (
    {
        Name     => 'WithoutSuffix',
        Data     => 'Title',
        Expected => 'Title',
    },
    {
        Name     => 'WithSuffix',
        Data     => 'Title',
        Expected => 'Title',
    },
    {
        Name     => 'ArrayWithSuffix',
        Data     => [ 'Title^3', 'Body' ],
        Expected => [ 'Title', 'Body' ],
    },
    {
        Name     => 'HashWithSuffix',
        Data     => { Key1 => 'Title^3', Key2 => 'Body' },
        Expected => { Key1 => 'Title', Key2 => 'Body' },
    },
    {
        Name     => 'NestedStructureWithSuffixes',
        Data     => {
            'Article' => [
                'From^2',
                'To',
                'Body',
                'Subject'
            ],
            'Attachment' => [
                'Content',
                'Filename'
            ],
            'DynamicField' => [],
            'Ticket' => [
                'Title^3',
                'TicketNumber'
            ]
        },
        Expected => {
            'Article' => [
                'From',
                'To',
                'Body',
                'Subject'
            ],
            'Attachment' => [
                'Content',
                'Filename'
            ],
            'DynamicField' => [],
            'Ticket' => [
                'Title',
                'TicketNumber'
            ]
        },
    },
);

for my $Test ( @Tests ) {

    subtest $Test->{Name} => sub {

        my $Result = RemoveESWeightedSearchBoostSuffix( Data => $Test->{Data} );
        is( $Result, $Test->{Expected}, $Test->{Name} );
    };
}

done_testing;
