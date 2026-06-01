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
        Url      => 'http://www.example.com?SomeFantasyParam=Garfield',
        Param    => 'SomeFantasyParam',
        Throws   => undef,
        Expected => 'Garfield',
        Check    => undef,
        Default  => undef,
    },
    {
        Desc     => 'SimpleTicketID',
        Url      => 'http://www.example.com?TicketID=123',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => '123',
        Check    => undef,
        Default  => undef,
    },
    {
        Desc     => 'ExplicitTicketID',
        Url      => 'http://www.example.com?TicketID=123',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => '123',
        Check    => 'positive_integer',
        Default  => undef,
    },
    {
        Desc     => 'ExplicitTicketIDWithUnusedDefault',
        Url      => 'http://www.example.com?TicketID=123',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => '123',
        Check    => 'positive_integer',
        Default  => 42,
    },
    {
        Desc     => 'ExplicitTicketIDWithUsedDefault',
        Url      => 'http://www.example.com?TicketID=abc',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => '42',
        Check    => undef,
        Default  => 42,
    },
    {
        Desc     => 'MissingTicketID',
        Url      => 'http://www.example.com',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => undef,
        Check    => undef,
        Default  => undef,
    },
    {
        Desc     => 'TicketIDRegexMatch',
        Url      => 'http://www.example.com?TicketID=xyz',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => 'xyz',
        Check    => qr/^x.z$/,
        Default  => undef,
    },
    {
        Desc     => 'EmptyTicketID',
        Url      => 'http://www.example.com?TicketID=',
        Param    => 'TicketID',
        Throws   => undef,
        Expected => '',
        Check    => undef,
        Default  => undef,
    },

    # Failure case

    {
        Desc    => 'NegativeTicketID',
        Url     => 'http://www.example.com?TicketID=-1',
        Param   => 'TicketID',
        Throws  => 'Kernel::System::Web::Exception',
        Check   => undef,
        Default => undef,
    },
    {
        Desc     => 'ExplicitNegativeTicketID',
        Url      => 'http://www.example.com?TicketID=-1',
        Param    => 'TicketID',
        Throws   => 'Kernel::System::Web::Exception',
        Expected => '123',
        Check    => 'positive_integer',
        Default  => undef,
    },
    {
        Desc     => 'TicketIDRegexMismatch',
        Url      => 'http://www.example.com?TicketID=abc',
        Param    => 'TicketID',
        Throws   => 'Kernel::System::Web::Exception',
        Expected => 'xyz',
        Check    => qr/^x.z$/,
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
        my $Value;
        eval {

            if ( !$Check && !$Default ) {
                $Value = $ParamObject->GetParam(
                    Param => $Param,
                );
            }
            elsif ( !$Default )
            {
                $Value = $ParamObject->GetParam(
                    Param => $Param,
                    Check => $Check,
                );
            }
            elsif ( !$Check )
            {
                $Value = $ParamObject->GetParam(
                    Param   => $Param,
                    Default => $Default,
                );
            }
            else
            {
                $Value = $ParamObject->GetParam(
                    Param   => $Param,
                    Check   => $Check,
                    Default => $Default,
                );
            }

            is( $Value, $Expected, "Expected " . ( $Param // '' ) . " value '" . ( $Value // '' ) . "' to match '" . ( $Expected // '' ) . "'." );

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
