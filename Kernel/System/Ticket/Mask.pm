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

package Kernel::System::Ticket::Mask;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::Ticket::Mask - functions to prepare and administrate ticket masks

=head1 DESCRIPTION

functions to prepare and administrate ticket masks

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MaskObject = $Kernel::OM->Get('Kernel::System::Ticket::Mask');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 DefinitionSet()

Set the definition for a ticket mask

    my $Success = $MaskObject->DefinitionSet(
        DefinitionString => $YAMLString,
        Mask             => $Mask,
        UserID           => $UserID,
    );

=cut

sub DefinitionSet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/UserID Mask DefinitionString/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my $DefinitionRef = $YAMLObject->Load(
        Data => $Param{DefinitionString},
    );

    return {
        Success => 0,
        Error   => Translatable('Base structure is not valid. Please provide an array with data in YAML format.'),
    } if !IsArrayRefWithData($DefinitionRef);

    # TODO: Introduce some checks on $DefinitionRef syntax

    my $DynamicFieldReturn = $Self->_DefinitionDynamicFieldGet( Definition => $Param{DefinitionString} );

    return {
        Success => 0,
        Error   => $DynamicFieldReturn->{Error} // Translatable('Error parsing dynamic fields.'),
    } if !$DynamicFieldReturn || !$DynamicFieldReturn->{Success};

    my $DynamicFieldString = $YAMLObject->Dump(
        Data => $DynamicFieldReturn->{DynamicFields},
    );

    if ( !$DynamicFieldString ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not dump YAML!',
        );

        return;
    }

    $Self->DefinitionDelete(
        Mask => $Param{Mask},
    );

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'INSERT INTO frontend_mask_definition ( mask, definition, dynamic_field, create_time, create_by ) VALUES ( ?, ?, ?, current_timestamp, ? )',
        Bind => [ \$Param{Mask}, \$Param{DefinitionString}, \$DynamicFieldString, \$Param{UserID} ],
    );

    return {
        Success => 1,
    };
}

=head2 DefinitionGet()

Get the definition for a ticket mask

    my $Definition = $MaskObject->DefinitionGet(
        Mask   => $Mask,
        Return => 'Raw', # optional - return only the raw yaml string for the mask without dynamic fields
    );

=cut

sub DefinitionGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Mask/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => 'SELECT definition, dynamic_field FROM frontend_mask_definition WHERE mask = ?',
        Bind  => [ \$Param{Mask} ],
        Limit => 1,
    );

    my ( $DefinitionString, $DynamicFieldString ) = $DBObject->FetchrowArray();

    return if !$DefinitionString;

    return $DefinitionString if $Param{Return} && $Param{Return} eq 'Raw';

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my $Definition = $YAMLObject->Load(
        Data => $DefinitionString,
    );

    my $DynamicFields = $YAMLObject->Load(
        Data => $DynamicFieldString,
    );

    return {
        Mask          => $Definition,
        DynamicFields => $DynamicFields,
    };
}

=head2 DefinitionDelete()

Delete the definition for a ticket mask

    my $Success = $MaskObject->DefinitionDelete(
        Mask => $Mask,
    );

=cut

sub DefinitionDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Mask/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM frontend_mask_definition WHERE mask = ?',
        Bind => [ \$Param{Mask} ],
    );
}

=head2 ConfiguredMasksList()

Get all configured masks

    my @Masks = $MaskObject->ConfiguredMasksList();

=cut

sub ConfiguredMasksList {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => 'SELECT mask FROM frontend_mask_definition',
    );

    my @Masks;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Masks, $Row[0];
    }

    return @Masks;
}

sub _DefinitionDynamicFieldGet {
    my ( $Self, %Param ) = @_;

    $Param{DefinitionPerl} //= $Kernel::OM->Get('Kernel::System::YAML')->Load(
        Data => $Param{Definition},
    );

    my %ContentHash  = ref $Param{DefinitionPerl} && ref $Param{DefinitionPerl} eq 'HASH'  ? $Param{DefinitionPerl}->%* : ();
    my @ContentArray = ref $Param{DefinitionPerl} && ref $Param{DefinitionPerl} eq 'ARRAY' ? $Param{DefinitionPerl}->@* : ();

    if ( !%ContentHash && !@ContentArray ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Definition or DefinitionPerl as hash or array!",
        );

        return;
    }

    my %DynamicFields;

    for my $Key ( keys %ContentHash ) {
        if ( $Key eq 'DF' ) {
            $DynamicFields{ $ContentHash{$Key} } = \%ContentHash;
        }
        elsif ( ref $ContentHash{$Key} ) {
            %DynamicFields = (
                %DynamicFields,
                $Self->_DefinitionDynamicFieldGet( DefinitionPerl => $ContentHash{$Key} ),
            );
        }
    }

    for my $Entry (@ContentArray) {
        if ( ref $Entry ) {
            %DynamicFields = (
                %DynamicFields,
                $Self->_DefinitionDynamicFieldGet( DefinitionPerl => $Entry ),
            );
        }
    }

    if ( $Param{Definition} ) {
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my %ReturnDynamicFields;

        DYNAMICFIELD:
        for my $Name ( keys %DynamicFields ) {
            my $DynamicField = $DynamicFieldObject->DynamicFieldGet( Name => $Name );

            return {
                Success => 0,
                Error   => sprintf( Translatable('No dynamic field "%s".'), $Name ),
            } if !$DynamicField;

            return {
                Success => 0,
                Error   => sprintf( Translatable('Dynamic field "%s" not valid.'), $Name ),
            } if !$DynamicField->{ValidID} eq '1';

            return {
                Success => 0,
                Error   => sprintf( Translatable('Dynamic field "%s" already in use in a Set.'), $Name ),
            } if $DynamicField->{Config}{PartOfSet};

            # Dynamic field has to be listed even without parameters
            $ReturnDynamicFields{$Name} = undef;

            for my $Attribute (qw/Mandatory Label Readonly/) {
                if ( defined $DynamicFields{$Name}{$Attribute} ) {
                    $ReturnDynamicFields{$Name}{$Attribute} = $DynamicFields{$Name}{$Attribute};
                }
            }
        }

        return {
            Success       => 1,
            DynamicFields => \%ReturnDynamicFields,
        };
    }

    return %DynamicFields;
}

1;
