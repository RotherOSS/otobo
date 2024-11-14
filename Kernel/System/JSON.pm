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

package Kernel::System::JSON;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use JSON::XS          ();
use Types::Serialiser ();
use Try::Tiny;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::JSON - JSON lib that wraps JSON::XS

=head1 DESCRIPTION

Provide support for serializing Perl data structures to JSON
and for deserializing JSON to Perl data structures.

Also included are helper methods for dealing with boolean values.

=head1 PUBLIC INTERFACE

=head2 new()

create a JSON object. Do not use it directly, instead use:

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

=cut

sub new {
    my ($Type) = @_;

    # allocate a new hash for object
    return bless {}, $Type;
}

=head2 Encode()

Serialise a Perl data structure into a string that contains JSON.
Supported data structures are hashrefs, arrayrefs and simple scalars like strings and numbers.
An undefined value is fine too.
The result will be Perl string that may have code points greater 255.

    my $JSONString = $JSONObject->Encode(
        Data          => $Data,
        SortKeys      => 1, # (optional) (0|1) default 0, to sort the keys of the JSON data
        Pretty        => 1, # (optional) (0|1) default 0, to pretty print
    );

=cut

sub Encode {
    my ( $Self, %Param ) = @_;

    # an undefined value is fine for the parameter Data
    if ( !exists $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );

        return;
    }

    # create a JSON::XS compatible object
    my $JSONObject = JSON::XS->new;

    # grudgingly accept data that is neither a hash- nor an array reference
    $JSONObject->allow_nonref(1);

    # sort the keys of the JSON data
    if ( $Param{SortKeys} ) {
        $JSONObject->canonical(1);
    }

    # pretty print - can be useful for debugging purposes
    if ( $Param{Pretty} ) {
        $JSONObject->pretty(1);
    }

    # Briefly the option TypeAllString was supported. The aim was
    # to put numbers into double quotes so that the JS side can be sure about what it will receive.
    # However the type_all_string attribute is only available in Cpanel::JSON::XS >= 4.18. So this
    # feature can't be used in OTOBO and the option has been removed.
    #if ( $Param{TypeAllString} ) {
    #    $JSONObject->type_all_string(1);
    #}

    # Serialise the Perl data structure into the format JSON.
    #
    # The attribute utf8 of $JSONObject is not set. This means
    # that the result of encode() will be a Perl string that may
    # contain character with a code point greater 255.
    # Unicode LS and PS are not replaced. But see below.
    # $Param{Data}->{sample_newline} = "\x{2028}" if ref $Param{Data} eq 'HASH';
    #
    # The method encode() croaks on error, so there should be no circumstances
    # where undef or an empty list is returned. But, just in case, return the JSON
    # for an empty string in that case.
    # Note that the string `q{0}` is valid JSON and thus should not be
    # turned into the string `q{""}`.
    my $JSONEncoded = $JSONObject->encode( $Param{Data} ) // q{""};

    #use Devel::Peek;
    #Dump( $JSONEncoded );

    # Special handling of problematic unicode code points:
    #   U+02028 - LINE SEPARATOR
    #   U+02029 - PARAGRAPH SEPARATOR
    # These two characters are valid in JSON but not in JavaScript.
    # See http://timelessrepo.com/json-isnt-a-javascript-subset or
    # https://www.cnblogs.com/rubylouvre/archive/2011/05/16/2048198.html
    #
    # In Kernel::System::JSON the stance is that the generated JSON should
    # be both valid JSON and valid JavaScript. Therefore the two characters
    # are coded as \u escapes.
    #
    # Nevertheless, using the generated JSON as JavaScript is strongly discouraged.
    $JSONEncoded =~ s/\x{2028}/\\u2028/xmsg;
    $JSONEncoded =~ s/\x{2029}/\\u2029/xmsg;

    return $JSONEncoded;
}

=head2 Decode()

Deserialize a JSON string to a Perl data structure. Booleans are mapped to the values C<0> and C<1>.

    my $PerlStructureScalar = $JSONObject->Decode(
        Data => '{"Key1":"Value1","Key2":42,"Key3":"Another Value", "Key4":true, "Key5":false}'
    );

Returns:

    $PerlStructureScalar = {
            Key1   => 'Value1',
            Key2   => 42,
            Key3   => 'Another Value'
            Key4   => 1,
            Key5   => 0,
    }

In case of an error, an empty list is returned.

=cut

sub Decode {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return unless defined $Param{Data};

    # create a JSON::XS compatible object that does the actual parsing
    my $JSONObject = JSON::XS->new;

    # grudgingly accept data that is neither a hash- nor an array reference
    $JSONObject->allow_nonref(1);

    # In OTOBO 10.0.x and OTOBO 10.1.x there is a tree walker that
    # replaces the boolean values, that is instances of JSON::PP::Boolean,
    # with the plain integer values 0 and 1.
    # This behavior is reproduced with explicitly declaring
    # what should be emitted for JSON booleans 'true' and 'false'.
    # Note that when using Cpanel::JSON::XS, the attribute unblessed_bool can be used
    # for the same purpose.
    $JSONObject->boolean_values( 0, 1 );

    # Deserialize JSON and get a Perl data structure.
    # Use Try::Tiny as JSON::XS->decode() dies when providing a malformed JSON string.
    # In that case we want to return an empty list.
    my $Success = 1;
    my $Scalar  = try {
        $JSONObject->decode( $Param{Data} );
    }
    catch {
        $Success = 0;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Decoding the JSON string failed: ' . $_,
        );

        undef;    # keep $Scalar undefined
    };

    return unless $Success;    # decode threw an exception
    return $Scalar;            # return the data structure, which might also be 0, '', or undef.
}

=head2 True()

returns a constant that can be mapped to a boolean true value
in JSON rather than a string with "true".

    my $Constant = $JSONObject->True();
    my $JSON     = $JSONObject->Encode(
        Data => $Constant,
    );

This will return the string C<q{true}>.
If you pass the perl string C<q{true}> to JSON, it will return C<q{"true"}>
as a JSON string instead.

=cut

sub True {
    return Types::Serialiser::true;
}

=head2 False()

like C<True()>, but for a false boolean value.

    my $Constant = $JSONObject->False();
    my $JSON     = $JSONObject->Encode(
        Data => $Constant,
    );

This returns the String C<q{false}>.

=cut

sub False {
    return Types::Serialiser::false;
}

=head2 ToBoolean()

Return a boolean constant depending on whether the parameter evaluates to B<true> or B<false>
in a Perl context.

    my $Constant = $JSONObject->ToBoolean( 2 > 3 );
    my $JSON = $JSONObject->Encode(
        Data => $Constant,
    );

In this case the returned JSON will be C<q{false}>. For true expressions we get C<q{true}>.

=cut

sub ToBoolean {
    my ( $Self, $Scalar ) = @_;

    return $Scalar ? $Self->True : $Self->False;
}

=head2 IsBool()

Indicates whether the passed in variable is a boolean value. Specifically whether it is an
instance of C<Types::Serialiser::Boolean>. Note that C<Types::Serialiser::Boolean> is an alias for C<JSON::PP::Boolean>.

    my $IsBool1 = $JSONObject->IsBool(1);                   # assigns undef
    my $IsBool2 = $JSONObject->IsBool( $JSONObject->False); # assigns 1

In this case the returned JSON will be C<q{false}>. For true expressions we get C<q{true}>.

=cut

sub IsBool {
    my ( $Self, $Scalar ) = @_;

    return Types::Serialiser::is_bool($Scalar);
}

1;
