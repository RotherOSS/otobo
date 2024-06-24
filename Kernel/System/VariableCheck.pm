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

package Kernel::System::VariableCheck;

use strict;
use warnings;

# core modules
use Exporter qw(import);

# CPAN modules

# OTOBO modules

# set up the exported symbols
our %EXPORT_TAGS = (    ## no critic qw(OTOBO::RequireCamelCase)
    all => [
        'IsArrayRefWithData',
        'IsHashRefWithData',
        'IsInteger',
        'IsIPv4Address',
        'IsIPv6Address',
        'IsMD5Sum',
        'IsNotEqual',
        'IsNumber',
        'IsPositiveInteger',
        'IsString',
        'IsStringWithData',
        'DataIsDifferent',
    ],
);
Exporter::export_ok_tags('all');

=head1 NAME

Kernel::System::VariableCheck - helper functions to check variables

=head1 DESCRIPTION

Provides several helper functions to check variables, e.g.
if a variable is a string, a hash ref etc. This is helpful for
input data validation, for example.

Call this module directly without instantiating:

    use Kernel::System::VariableCheck qw(:all);             # export all functions into the calling package
    use Kernel::System::VariableCheck qw(IsHashRefWitData); # export just one function

    if (IsHashRefWithData($HashRef)) {
        ...
    }

The functions can be grouped as follows:

=head2 Variable type checks

=over 4

=item * L</IsString()>

=item * L</IsStringWithData()>

=item * L</IsArrayRefWithData()>

=item * L</IsHashRefWithData()>

=back

=head2 Number checks

=over 4

=item * L</IsNumber()>

=item * L</IsInteger()>

=item * L</IsPositiveInteger()>

=back

=head2 Special data format checks

=over 4

=item * L</IsIPv4Address()>

=item * L</IsIPv6Address()>

=item * L</IsMD5Sum()>

=back

=head2 Generic comparison

=over 4

=item * L</DataIsDifferent()>

=back

=head1 PUBLIC INTERFACE

=head2 IsString()

test supplied data to determine if it is a string - an empty string is valid

returns 1 if data matches criteria or undef otherwise

    my $Result = IsString(
        'abc', # data to be tested
    );

=cut

## no critic (Perl::Critic::Policy::Subroutines::RequireArgUnpacking)

sub IsString {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData;
    return if !defined $TestData;

    return 1;
}

=head2 IsStringWithData()

test supplied data to determine if it is a non zero-length string

returns 1 if data matches criteria or undef otherwise

    my $Result = IsStringWithData(
        'abc', # data to be tested
    );

=cut

sub IsStringWithData {
    my $TestData = $_[0];

    return if !IsString(@_);
    return if $TestData eq '';

    return 1;
}

=head2 IsArrayRefWithData()

test supplied data to determine if it is an array reference and contains at least one key

returns 1 if data matches criteria or undef otherwise

    my $Result = IsArrayRefWithData(
        [ # data to be tested
            'key',
            ...
        ],
    );

=cut

sub IsArrayRefWithData {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData ne 'ARRAY';
    return if !@{$TestData};

    return 1;
}

=head2 IsHashRefWithData()

tests supplied data to determine if it is a hash reference and contains at least one key/value pair.

Returns 1 if data matches criteria or undef otherwise

    my $Result = IsHashRefWithData(
        { # data to be tested
            'key' => 'value',
            ...
        },
    );

=cut

sub IsHashRefWithData {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData ne 'HASH';
    return if !%{$TestData};

    return 1;
}

=head2 IsNumber()

test supplied data to determine if it is a number
(integer, floating point, possible exponent, positive or negative)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsNumber(
        999, # data to be tested
    );

=cut

sub IsNumber {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{
        \A [-]? (?: \d+ | \d* [.] \d+ | (?: \d+ [.]? \d* | \d* [.] \d+ ) [eE] [-+]? \d* ) \z
    }xms;

    return 1;
}

=head2 IsInteger()

test supplied data to determine if it is an integer (only digits, positive or negative)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsInteger(
        999, # data to be tested
    );

=cut

sub IsInteger {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [-]? (?: 0 | [1-9] \d* ) \z }xms;

    return 1;
}

=head2 IsPositiveInteger()

test supplied data to determine if it is a positive integer (only digits and positive)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsPositiveInteger(
        999, # data to be tested
    );

=cut

sub IsPositiveInteger {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [1-9] \d* \z }xms;

    return 1;
}

=head2 IsIPv4Address()

test supplied data to determine if it is a valid IPv4 address (syntax check only)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsIPv4Address(
        '192.168.0.1', # data to be tested
    );

=cut

sub IsIPv4Address {
    my $TestData = $_[0];

    return unless IsStringWithData(@_);
    return unless $TestData =~ m{ \A [\d\.]+ \z }xms;

    my @Part = split /\./, $TestData;

    # four parts delimited by '.' needed
    return unless scalar @Part eq 4;

    for my $Part (@Part) {

        # allow numbers 0 to 255, no leading zeroes
        return unless $Part =~ m{
            \A (?: \d | [1-9] \d | [1] \d{2} | [2][0-4]\d | [2][5][0-5] ) \z
        }xms;
    }

    return 1;
}

=head2 IsIPv6Address()

test supplied data to determine if it is a valid IPv6 address (syntax check only)
shorthand notation and mixed IPv6/IPv4 notation allowed
# FIXME IPv6/IPv4 notation currently not supported

returns 1 if data matches criteria or undef otherwise

    my $Result = IsIPv6Address(
        '0000:1111:2222:3333:4444:5555:6666:7777', # data to be tested
    );

=cut

sub IsIPv6Address {
    my $TestData = $_[0];

    return unless IsStringWithData(@_);

    # only hex characters (0-9,A-Z) plus separator ':' allowed
    return unless $TestData =~ m{ \A [\da-f:]+ \z }xmsi;

    # special case - equals only zeroes
    return 1 if $TestData eq '::';

    # special cases - address must not start or end with single ':'
    return if $TestData =~ m{ \A : [^:] }xms;
    return if $TestData =~ m{ [^:] : \z }xms;

    # special case - address must not start and end with ':'
    return if $TestData =~ m{ \A : .+ : \z }xms;

    my $SkipFirst;
    if ( $TestData =~ m{ \A :: }xms ) {
        $TestData  = 'X' . $TestData;
        $SkipFirst = 1;
    }
    my $SkipLast;
    if ( $TestData =~ m{ :: \z }xms ) {
        $TestData .= 'X';
        $SkipLast = 1;
    }
    my @Part = split /:/, $TestData;
    if ($SkipFirst) {
        shift @Part;
    }
    if ($SkipLast) {
        delete $Part[-1];
    }
    return if scalar @Part < 2 || scalar @Part > 8;
    return if scalar @Part ne 8 && $TestData !~ m{ :: }xms;

    # handle full addreses
    if ( scalar @Part eq 8 ) {
        my $EmptyPart;
        PART:
        for my $Part (@Part) {
            if ( $Part eq '' ) {
                return if $EmptyPart;
                $EmptyPart = 1;
                next PART;
            }
            return if $Part !~ m{ \A [\da-f]{1,4} \z }xmsi;
        }
    }

    # handle shorthand addresses
    my $ShortHandUsed;
    PART:
    for my $Part (@Part) {
        next PART if $Part eq 'X';

        # empty part means shorthand - do we already have more than one consecutive empty parts?
        return if $Part eq '' && $ShortHandUsed;
        if ( $Part eq '' ) {
            $ShortHandUsed = 1;
            next PART;
        }
        return if $Part !~ m{ \A [\da-f]{1,4} \z }xmsi;
    }

    return 1;
}

=head2 IsMD5Sum()

test supplied data to determine if it is an C<MD5> sum (32 hex characters)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsMD5Sum(
        '6f1ed002ab5595859014ebf0951522d9', # data to be tested
    );

=cut

sub IsMD5Sum {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [\da-f]{32} \z }xmsi;

    return 1;
}

=head2 DataIsDifferent()

compares two data structures with each other. Returns 1 if
they are different, undef otherwise.

Non-references are compared by their stringified values.

    my $DataIsDifferent = DataIsDifferent(
        Data1 => 2.4,
        Data2 => '2.4',
    ); # not different

    my $DataIsDifferent = DataIsDifferent(
        Data1 => 2.4,
        Data2 => '2.40',
    ); # different

Data parameters can be passed by reference. The supported types, as returned by C<ref>, are
"SCALAR", "ARRAY", "HASH", or "REF". When the parameters are references to different types
then they are reported as different.
Blessed references are always reported as different. References of all other types,
such as "CODE", "FORMAT", "IO", GLOB", "LVALUE", or "REGEXP", are also always reported as being different.

    my $Blessed = bless {}, 'Some::Name::Space';
    my $DataIsDifferent = DataIsDifferent(
        Data1 => $Blessed,
        Data2 => $Blessed,
    ); # different

References to SCALAR are compared by their stringified dereferenced values.

    my ($Num, $Canonical, $NonCanonical) = ( 3.6, '3.6', '3.60');
    my $DataIsDifferent = DataIsDifferent(
        Data1 => \$Num,
        Data2 => \$Canonical,
    ); # not different

    my $DataIsDifferent = DataIsDifferent(
        Data1 => \$Num,
        Data2 => \$NonCanonical,
    ); # different

References to "ARRAY" recursively compares the respective elements. But beware that
a string comparison is made before recursive descent.

    my $Blessed = bless {}, 'Some::Name::Space';
    my $DataIsDifferent = DataIsDifferent(
        Data1 => [$Blessed],
        Data2 => [$Blessed],
    ); # not different

References to "HASH" recursively compares the respective elements. But beware that
a string comparison is made before the recursive descent.

    my $Blessed = bless {}, 'Some::Name::Space';
    my $DataIsDifferent = DataIsDifferent(
        Data1 => { Key => $Blessed },
        Data2 => { Key => $Blessed },
    ); # not different

References to REF are compared by recursively calling C<DataIsDifferent()> on their dereferenced values.

    my ($Num, $Canonical, $NonCanonical) = ( 4.8, '4.8', '4.80');
    my $DataIsDifferent = DataIsDifferent(
        Data1 => \\$Num,
        Data2 => \\$Canonical,
    ); # not different

    my $DataIsDifferent = DataIsDifferent(
        Data1 => \\$Num,
        Data2 => \\$NonCanonical,
    ); # different

=cut

sub DataIsDifferent {
    my (%Param) = @_;

    # non-references
    if ( ref $Param{Data1} eq '' && ref $Param{Data2} eq '' ) {

        # do nothing, it's ok
        return if !defined $Param{Data1} && !defined $Param{Data2};

        # return diff, because its different
        return 1 if !defined $Param{Data1} || !defined $Param{Data2};

        # return diff, because its different
        return 1 if $Param{Data1} ne $Param{Data2};

        # return, because its not different
        return;
    }

    # SCALAR
    if ( ref $Param{Data1} eq 'SCALAR' && ref $Param{Data2} eq 'SCALAR' ) {

        # do nothing, it's ok
        return if !defined ${ $Param{Data1} } && !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if !defined ${ $Param{Data1} } || !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if ${ $Param{Data1} } ne ${ $Param{Data2} };

        # return, because its not different
        return;
    }

    # ARRAY
    if ( ref $Param{Data1} eq 'ARRAY' && ref $Param{Data2} eq 'ARRAY' ) {
        my @A = @{ $Param{Data1} };
        my @B = @{ $Param{Data2} };

        # check if the count is different
        return 1 if $#A ne $#B;

        # compare array
        COUNT:
        for my $Count ( 0 .. $#A ) {

            # do nothing, it's ok
            next COUNT if !defined $A[$Count] && !defined $B[$Count];

            # Left and right side are not both undefined,
            # so either side being undefined implies a difference.
            return 1 unless defined $A[$Count];
            return 1 unless defined $B[$Count];

            # Note that string equality also holds for arbitrary references
            # to the same underlying data structure.
            if ( $A[$Count] ne $B[$Count] ) {
                if ( ref $A[$Count] eq 'ARRAY' || ref $A[$Count] eq 'HASH' ) {
                    return 1 if DataIsDifferent(
                        Data1 => $A[$Count],
                        Data2 => $B[$Count]
                    );

                    next COUNT;
                }

                # this also holds for ref to SCALAR, that are not different when compared directly
                return 1;
            }
        }
        return;
    }

    # HASH
    if ( ref $Param{Data1} eq 'HASH' && ref $Param{Data2} eq 'HASH' ) {

        # make a shallow copy as the comparison modifies the data structures
        my %A = $Param{Data1}->%*;
        my %B = $Param{Data2}->%*;

        # compare %A with %B and remove it if checked
        KEY:
        for my $Key ( sort keys %A ) {

            # non-existence is different to existence
            return 1 unless exists $B{$Key};

            # Check if both are undefined
            if ( !defined $A{$Key} && !defined $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};

                next KEY;
            }

            # Left and right side are not both undefined,
            # so either side being undefined implies a difference.
            return 1 unless defined $A{$Key};
            return 1 unless defined $B{$Key};

            # Note that string equality also holds for arbitrary references
            # to the same underlying data structure.
            if ( $A{$Key} eq $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};

                next KEY;
            }

            # return if values are different
            if ( ref $A{$Key} eq 'ARRAY' || ref $A{$Key} eq 'HASH' ) {
                return 1 if DataIsDifferent(
                    Data1 => $A{$Key},
                    Data2 => $B{$Key}
                );
                delete $A{$Key};
                delete $B{$Key};

                next KEY;
            }

            # this also holds for ref to SCALAR, that are not different when compared directly
            return 1;
        }

        # extra attributes on the left side imply a difference
        return 1 if %B;

        # no difference was found
        return;
    }

    if ( ref $Param{Data1} eq 'REF' && ref $Param{Data2} eq 'REF' ) {
        return 1 if DataIsDifferent(
            Data1 => ${ $Param{Data1} },
            Data2 => ${ $Param{Data2} }
        );
        return;
    }

    # Everything else is considered to be different,
    # even if the params stringify to the same string.
    return 1;
}

1;
