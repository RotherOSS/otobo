# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

use strict;
use warnings;

# core modules
use Encode qw();

# CPAN modules
use YAML::XS qw();

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::YAML - YAML wrapper functions

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

Dump a perl data structure to a YAML string.

    my $YAMLString = $YAMLObject->Dump(
        Data     => $Data,
    );

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

Load a YAML string to a perl data structure.
This string must be a encoded in UTF8.

    my $PerlStructureScalar = $YAMLObject->Load(
        Data => $YAMLString,
    );

=cut

sub Load {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return unless defined $Param{Data};

    if ( Encode::is_utf8( $Param{Data} ) ) {
        Encode::_utf8_off( $Param{Data} );
    }

    # There is a currently a problem with YAML loader it cant load YAML representations of:
    #   0, '0' or ''.
    # This workaround looks for this special cases and returns the correct value without using the
    #   loader
    if ( $Param{Data} =~ m{\A---[ ](?: '0' | 0 )\n\z}msx ) {
        return 0;
    }
    elsif ( $Param{Data} eq "--- ''\n" ) {
        return '';
    }

    my $Result;
    if ( !eval { $Result = YAML::XS::Load( $Param{Data} ) } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Loading the YAML string failed: ' . $@,
        );
        my $DumpString = $Param{Data};
        if ( length $DumpString > 1000 ) {
            $DumpString = substr( $DumpString, 0, 1000 ) . '[...]';
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => qq{YAML data was: "$DumpString"},
        );
    }

    # The resulting data structure may contain strings
    # that are internally encoded in latin1.
    return $Result;
}

1;
