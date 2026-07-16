# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

use v5.26;
use strict;
use warnings;
use utf8;

# core modules
use Scalar::Util qw(looks_like_number);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');

my $ValidateNegativeSub = sub {
    my %Param = @_;

    my $Value = $Param{Value};

    return {
        Success => 0,
        Error   => 'not a number',
    } unless looks_like_number($Value);

    return {
        Success => 0,
        Error   => 'not negative',
    } unless $Value < 0;

    return {
        Success => 1,
        Value   => $Value,
    };
};

my @Tests = (
    {
        Line        => __LINE__,
        Description => 'default validator active, valid value',
        Value       => 11,
        Key         => 'TicketID',
        Expected    => { Success => 1 },
    },
    {
        Line        => __LINE__,
        Description => 'default validator active, invalid value',
        Value       => -11,
        Key         => 'TicketID',
        Expected    => { Success => 0 },
    },
    {
        Line        => __LINE__,
        Description => 'default validator disabled',
        Value       => -11,
        Key         => 'TicketID',
        Validator   => 'anything',
        Expected    => { Success => 1 },
    },
    {
        Line        => __LINE__,
        Description => 'sub that checks for negative number, with value -11.11',
        Value       => -11.11,
        Key         => 'DepthOfSea',
        Validator   => $ValidateNegativeSub,
        Expected    => { Success => 1 },
    },
    {
        Line        => __LINE__,
        Description => 'sub that checks for negative number, with value -0',
        Value       => -0,
        Key         => 'DepthOfSea',
        Validator   => $ValidateNegativeSub,
        Expected    => { Success => 0 },
    },
    {
        Line        => __LINE__,
        Description => 'sub that checks for negative number, with value 0',
        Value       => 0,
        Key         => 'DepthOfSea',
        Validator   => $ValidateNegativeSub,
        Expected    => { Success => 0 },
    },
    {
        Line        => __LINE__,
        Description => 'sub that checks for negative number, with value 11.11',
        Value       => 11.11,
        Key         => 'DepthOfSea',
        Validator   => $ValidateNegativeSub,
        Expected    => { Success => 0 },
    },
);

# add some test with Type::Tiny
if ( $MainObject->Require( 'Types::Standard', Silent => 1 ) ) {

    my $FanShirtSizeSub = sub {
        my %Param = @_;

        my $Value = $Param{Value};

        # compile the type only once
        # No need to import anything
        state $ShirtSizeType = Types::Standard::Enum[qw( S M L XL XXL )];

        return {
            Success => 0,
            Error   => 'is not a shirt size',
        } unless $ShirtSizeType->check($Value);

        return {
            Success => 1,
            Value   => $Value,
        };
    };

    push @Tests,
        {
            Line        => __LINE__,
            Description => 'valid fan shirt size',
            Value       => 'XL',
            Key         => 'FanShirtSize but the key does not matter',
            Validator   => $FanShirtSizeSub,
            Expected    => { Success => 1 },
        },
        {
            Line        => __LINE__,
            Description => 'invalid fan shirt size',
            Value       => 'huge 👕',
            Key         => 'FanShirtSize but the key does not matter',
            Validator   => $FanShirtSizeSub,
            Expected    => { Success => 0 },
        },
        ;
}

for my $Test (@Tests) {
    my $Desc      = ( $Test->{Description} // 'no description' ) . " (Key=$Test->{Key}, Line=$Test->{Line})";
    my $Validator = $Test->{Validator} // $CheckItemObject->GetDefaultValidator( Key => $Test->{Key} )->{Check};

    my $Result = $CheckItemObject->Validate(
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        Validator => $Validator,
    );
    like( $Result, $Test->{Expected}, $Desc );
}

done_testing;
