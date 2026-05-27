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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM
use HTTP::Request::Common qw(GET);

my @Tests = (
    {
        Desc     => 'SimpleParam',
        Url      => 'http://www.example.com?Item=1&Item=2&Item=3',
        Param    => 'Item',
        Throws   => undef,
        Expected => [ 1, 2, 3 ],
        Check    => undef,
        Default  => undef,
    },
    {
        Desc     => 'SimpleParamExplicitCheck',
        Url      => 'http://www.example.com?Item=1&Item=2&Item=3',
        Param    => 'Item',
        Throws   => undef,
        Expected => [ 1, 2, 3 ],
        Check    => 'positive_integer',
        Default  => undef,
    },
    {
        Desc     => 'TicketIDs',
        Url      => 'http://www.example.com?TicketID=1&TicketID=2&TicketID=3',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => [ 1, 2, 3 ],
        Check    => undef,
        Default  => undef,
    },
    {
        Desc     => 'SimpleParamDefaults',
        Url      => 'http://www.example.com?Item=a&Item=b&Item=c',
        Param    => 'Item',
        Throws   => undef,
        Expected => [ 42, 42, 42 ],
        Check    => 'positive_integer',
        Default  => 42,
    },
    {
        Desc     => 'SimpleMissingValues',
        Url      => 'http://www.example.com?Item=&Item=&Item=',
        Param    => 'Item',
        Throws   => undef,
        Expected => ['','',''],
        Check    => 'positive_integer',
        Default  => 42,
    },
    {
        Desc     => 'RegExCheck',
        Url      => 'http://www.example.com?Item=Player1&Item=Player2&Item=Player4',
        Param    => 'Item',
        Throws   => undef,
        Expected => [ 'Player1', 'Player2', 'Player4' ],
        Check    => qr/^Player[0-9]+$/,
        Default  => 42,
    },

    # failure

    {
        Desc     => 'SimpleFail',
        Url      => 'http://www.example.com?Item=a&Item=b&Item=c',
        Param    => 'Item',
        Throws   => 'Kernel::System::Web::Exception',
        Expected => undef,
        Check    => 'positive_integer',
        Default  => undef,
    },

);

for my $Test (@Tests) {

    subtest $Test->{Desc} => sub {

        my $Url      = $Test->{Url};
        my $Param    = $Test->{Param};
        my $Throws   = $Test->{Throws};
        my $Check    = $Test->{Check};
        my $Default  = $Test->{Default};
        my $Expected = $Test->{Expected};

        # start with an empty plate
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Web::Request'],
        );

        # fake web request params
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Web::Request' => {
                HTTPRequest => GET($Url),
            }
        );

        # get the ParamObject
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        # get the value, validation might throw
        my @Value;
        eval {

            if ( !$Check && !$Default ) {
                @Value = $ParamObject->GetArray(
                    Param => $Param,
                );
            }
            elsif ( !$Default )
            {
                @Value = $ParamObject->GetArray(
                    Param => $Param,
                    Check => $Check,
                );
            }
            elsif ( !$Check )
            {
                @Value = $ParamObject->GetArray(
                    Param   => $Param,
                    Default => $Default,
                );
            }
            else
            {
                @Value = $ParamObject->GetArray(
                    Param   => $Param,
                    Check   => $Check,
                    Default => $Default,
                );
            }

            my $MaxExpected = $Expected->$#*;
            if ( $MaxExpected == -1 ) {

                is( scalar @Value, 0, 'empty result' );
            }
            else {

                for my $Index ( 0 .. $MaxExpected ) {

                    is(
                        $Value[$Index],
                        $Expected->[$Index],
                        "Expected " . ( $Param // '' )
                            . " value '" . ( $Value[$Index] // '' )
                            . "' to match '" . ( $Expected->[$Index] // '' ) . "'."
                    );
                }
            }
        };
        if ($@) {

            if ($Throws) {

                ok( ref($@) eq $Throws, "Expected to throw a $Throws Exception" );
            }
            else {
                ok( 0, 'Not expected to throw' );
            }
        }
    }
}

done_testing;
