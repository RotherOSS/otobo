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

package Kernel::System::YAML;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use Encode ();

# CPAN modules
use YAML::XS ();
use Try::Tiny;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::YAML - wrapper functions for YAML::XS

=head1 DESCRIPTION

Functions for YAML serialization / deserialization.

=head2 new()

create a YAML object. Do not use it directly, instead use:

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 Dump()

Dump a Perl data structure to a YAML string.

    my $YAMLString = $YAMLObject->Dump(
        Data     => $Data,
    );

The generated string is upgraded to have utf8 as its internal representation.

=cut

sub Dump {
    my ( $Self, %Param ) = @_;

    # check for needed data
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );

        return;
    }

    my $String = YAML::XS::Dump( $Param{Data} ) || "--- ''\n";

    # Tell Perl that the dumped octetts are a UTF-8 encoded string and
    # that we want the internal representation to be UTF-8.
    utf8::decode($String);
    utf8::upgrade($String);

    return $String;
}

=head2 Load()

Load a YAML string to a Perl data structure.
This string must be a encoded in UTF8.

    my $PerlStructureScalar = $YAMLObject->Load(
        Data => $YAMLString,
    );

In case of a failure C<undef> is returned.

When multiple documents are contained in the input string, then only the last document is returned.

=cut

sub Load {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return unless defined $Param{Data};

    # TODO: use utf::encode() because that is the actual intent
    if ( Encode::is_utf8( $Param{Data} ) ) {
        Encode::_utf8_off( $Param{Data} );
    }

    # The resulting data structure may contain strings
    # that are internally encoded in latin1.
    # Load() is called in scalar context. This means that when multiple documents are contained in the input string,
    # then the last document is returned.
    my $Result = try {
        YAML::XS::Load( $Param{Data} );
    }
    catch {

        # $@ is not clobbered in this simple case
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Loading the YAML string failed: ' . $_,
        );

        my $DumpString = $Param{Data};
        if ( length $DumpString > 1000 ) {
            $DumpString = substr( $DumpString, 0, 1000 ) . '[...]';
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => qq{YAML data was: "$DumpString"},
        );

        undef;    # that kind of indicates failure
    };

    return $Result;
}

1;
