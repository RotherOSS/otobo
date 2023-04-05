# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

use List::Util qw(first);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
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
        Definition       => \@Definition,
        DefinitionString => $YAMLString,  # either Definition or DefinitionString is needed
        Mask             => $Mask,
        UserID           => $UserID,
    );

=cut

sub DefinitionSet {
    my ( $Self, %Param ) = @_;

    for my $Needed ( qw/UserID Mask/ ) {
        if ( !$Param{ $Needed } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Param{DefinitionString} ) {
        # Validate YAML code by converting it to Perl.
        my $DefinitionRef = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => $Param{DefinitionString},
        );

        if ( ref $DefinitionRef ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need and array in valid YAML!',
            );
            return;
        }
    }
    elsif ( $Param{Definition} ) {
        $Param{DefinitionString} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => $Param{Definition},
        );

        if ( !$Param{DefinitionString} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not generate YAML from provided Definition!',
            );
            return;
        }
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Definition or DefinitionString!',
        );
        return;
    }

    $Self->DefinitionDelete(
        Mask      => $Param{Mask},
        KeepCache => 1,
    );

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'INSERT INTO frontend_mask_definition ( mask, definition, create_time, create_by ) VALUES ( ?, ?, current_timestamp, ? )',
        Bind => [ \$Param{Mask}, \$Param{DefinitionString}, \$Param{UserID} ],
    );

    return 1;
}

=head2 DefinitionGet()

Get the definition for a ticket mask

    my $Definition = $MaskObject->DefinitionGet(
        Mask   => $Mask,
        Return => 'ARRAY', # Optional either ARRAY (default) or STRING which returns the YAML
    );

=cut

sub DefinitionGet {
    my ( $Self, %Param ) = @_;

    for my $Needed ( qw/Mask/ ) {
        if ( !$Param{ $Needed } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{Return} ||= 'ARRAY';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => 'SELECT definition FROM frontend_mask_definition WHERE mask = ?',
        Bind  => [ \$Param{Mask} ],
        Limit => 1,
    );

    my ( $DefinitionString ) = $DBObject->FetchrowArray();

    return if !$DefinitionString;

    return $DefinitionString if $Param{Return} eq 'STRING';

    return $Kernel::OM->Get('Kernel::System::YAML')->Load(
        Data => $DefinitionString,
    );
}

=head2 DefinitionDelete()

Delete the definition for a ticket mask

    my $Success = $MaskObject->DefinitionDelete(
        Mask => $Mask,
    );

=cut

sub DefinitionDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed ( qw/Mask/ ) {
        if ( !$Param{ $Needed } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL   => 'DELETE FROM frontend_mask_definition WHERE mask = ?',
        Bind  => [ \$Param{Mask} ],
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
        SQL   => 'SELECT mask FROM frontend_mask_definition',
    );

    my @Masks;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Masks, $Row[0];
    }

    return @Masks;
}

=head2 RenderInput()

Render input fields according to mask definition

    $MaskObject->RenderInput(
        GetParam => \%Param,
        LayoutObject => $LayoutObject,
        MaskDefinition => $MaskDefinition,
        DynamicFieldConfigs => $DynamicFieldConfigs,
        Config => $Config,
        SeparateDynamicFields => $SeparateDynamicFields,
    );

=cut

sub RenderInput {
    my ( $Self, %Param ) = @_;

    for my $Needed ( qw/GetParam LayoutObject MaskDefinition/ ) {
        if ( !$Param{ $Needed } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return 1 if !IsArrayRefWithData( $Param{DynamicFieldConfigs} );

    my %GetParam = %{ $Param{GetParam} };

    my %DynamicFieldConfigsHash = map { $_->{Name} => $_ } @{ $Param{DynamicFieldConfigs} };

    if ( !IsArrayRefWithData( $Param{MaskDefinition} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid mask definition!",
        );
        return;
    }
    for my $AreaDefinition ( @{ $Param{MaskDefinition} } ) {
        my %Area = ( Rows => [] );
        if ( IsHashRefWithData( $AreaDefinition->{Grid} ) ) {
            %Area            = $AreaDefinition->{Grid}->%*;
        }
        elsif ( IsArrayRefWithData( $AreaDefinition->{List} ) ) {
            $Area{Rows}      = [ map { [ $_ ] } $AreaDefinition->{List}->@* ];
            $Area{Columns}   = 1;
        }

        for my $Row ( @{ $Area{Rows} } ) {

            my $RowClassString = '';
            my $RowReadOnly = ( first { $_->{ReadOnly} } $Row->@* ) ? 1 : 0;

            # hide complete row if no field is visible
            if ( $Param{Visibility} && !grep { $Param{Visibility}{"DynamicField_$_->{Name}"} } @{ $Row } ) {
                $RowClassString .= ' oooACLHidden';
            }

            # special treatment for separate dynamic fields based on first field
            my $RowBlockName = $Param{SeparateDynamicFields} && $Param{SeparateDynamicFields}->{ $Row->[0]{Name} }
                ? 'Row_DynamicField_' . $Param{SeparateDynamicFields}->{ $Row->[0]{Name} } : 'Row_DynamicField';

            # Column size string is split in parts. Used are as many parts as columns are defined
            # Parts are checked against a regex
            my $ColumnSizeString = '';
            if ( $Area{ColumnSize} ) {
                my @ColumnSizes = split(' ', $Area{ColumnSize});
                my $ColumnIndex = 0;
                COLUMNSIZE:
                for my $ColumnSize ( @ColumnSizes ) {
                    next COLUMNSIZE if $ColumnSize !~ /^((\d(\.\d)?fr\s?)|(\d+px\s?)|auto\s?)+$/;
                    last COLUMNSIZE if $ColumnIndex == ( $Area{Columns} || 1 );
                    $ColumnSizeString .= $ColumnSize . ' ';
                    $ColumnIndex++;
                }
                while ( scalar split(' ', $ColumnSizeString) < $Area{Columns} ) {
                    $ColumnSizeString .= ' 1fr';
                }
            }
            $ColumnSizeString ||= "1fr " x $Area{Columns};

            $RowClassString .= $Area{Columns} > 1 ? ' MultiColumn' : '';
            my $MultiValueField = '';
            ELEMENT:
            for my $FieldItem ( $Row->@* ) {
                if ( $DynamicFieldConfigsHash{ $FieldItem->{Name} }->{Config}{MultiValue} ) {
                    $RowClassString .= ' MultiValue';
                    $MultiValueField = $FieldItem->{Name};
                    last ELEMENT;
                }
            }

            $Param{LayoutObject}->Block(
                Name => $RowBlockName,
                Data => {
                    TemplateColumns => $ColumnSizeString,
                    RowClasses      => $RowClassString,
                },
            );

            my @TemplateDataList;

            # DynamicFieldHTML is assumed to be a hash with separate html for each value
            my @HTMLCountKeys = keys $GetParam{DynamicFieldHTML}->{$MultiValueField}{HTML}->%*;
            my $MaxValueCount = @HTMLCountKeys ? $#HTMLCountKeys : 0;
            for ( my $RowIndex = 0; $RowIndex <= $MaxValueCount; $RowIndex++ ) {
                my $GridElementStart = 1;
                ELEMENT:
                for my $Element ( sort { ( $a->{Start} || 1 ) <=> ( $b->{Start} || 1 ) } @{ $Row } ) {
                    next ELEMENT if !IsHashRefWithData( $DynamicFieldConfigsHash{ $Element->{Name} } );
                    next ELEMENT if !IsHashRefWithData( $GetParam{DynamicFieldHTML}->{ $Element->{Name} } );

                    my $DynamicFieldConfig = $DynamicFieldConfigsHash{ $Element->{Name} };
                    my $DynamicFieldHTMLData   = $GetParam{DynamicFieldHTML}->{ $Element->{Name} };
                    my $DynamicFieldHTML = $DynamicFieldHTMLData->{HTML}{$RowIndex};
                    if ( !$DynamicFieldHTML && !$RowIndex ) {
                        $DynamicFieldHTML = $DynamicFieldHTMLData->{Field};
                    }
                    next ELEMENT if !$DynamicFieldHTML;

                    my $ColumnClassString = '';

                    # hide fields
                    if ( $Param{Visibility} && !$Param{Visibility}{"DynamicField_$Element->{Name}"} ) {
                        $ColumnClassString .= ' oooACLHidden';

                        # ACL hidden fields cannot be mandatory
                        if ( $Param{Config}->{DynamicField}->{ $Element->{Name} } == 2 ) {
                            $DynamicFieldHTML =~ s/(class=.+?Validate_Required)/$1_IfVisible/g;
                        }
                    }

                    # column placement
                    my $ColumnStyle = 'grid-column: ';
                    $GridElementStart = ($Element->{Start} && $Element->{Start} > $GridElementStart ) ? $Element->{Start} : $GridElementStart;
                    # saving element start for correct placing of rows with mixed fields (multivalue and non-multivalue)
                    $Element->{Start} = $GridElementStart;
                    $ColumnStyle   .= $GridElementStart . ' / ';
                    $GridElementStart++;
                    $ColumnStyle   .= $Element->{Span}  ? 'span ' . $Element->{Span} : 'span 1';

                    # special treatment for separate dynamic fields
                    my $ColBlockName = $Param{SeparateDynamicFields} && $Param{SeparateDynamicFields}->{ $Element->{Name} }
                        ? 'DynamicField_' . $Element->{Name} : 'DynamicField';

                    if ( $DynamicFieldConfig->{Config}{MultiValue} && $RowIndex == 0) {
                        my $TemplateConfig = {
                            $DynamicFieldConfig->%*,
                            Name => $DynamicFieldConfig->{Name} . ( $Param{IDSuffix} ? $Param{IDSuffix} : '' ) . '_Template',
                        };
                        my $FieldTemplateHTML = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->EditFieldRender(
                            DynamicFieldConfig => $TemplateConfig,
                            LayoutObject => $Param{LayoutObject},
                            ParamObject => $Kernel::OM->Get('Kernel::System::Web::Request'),
                            AJAXUpdate => 1,
                            UpdatableFields => $Param{AJAXUpdatableFields},
                            CustomerInterface => $Param{CustomerInterface} || 0,
                            ReadOnly => $Element->{ReadOnly} || 0,
                        );
                        push @TemplateDataList, { Field => ( $FieldTemplateHTML->{HTML}{'0'} || $FieldTemplateHTML->{Field} ), ColumnStyle => $ColumnStyle };
                    }

                    $ColumnClassString .= $DynamicFieldConfig->{Config}{MultiValue} ? ' MultiValue_' . $RowIndex : '';
                    my $CellBlockData = {
                        Name          => $DynamicFieldConfig->{Name},
                        ColumnStyle   => $ColumnStyle,
                        Field         => $DynamicFieldHTML,
                        Tooltip       => $DynamicFieldConfig->{Config}{Tooltip},
                        MultiValue    => $DynamicFieldConfig->{Config}{MultiValue},
                        RowReadOnly   => $RowReadOnly,
                        ColumnClasses => $ColumnClassString,
                        Index         => $RowIndex,
                    };
                    
                    if ( $RowIndex == 0 ) {
                        $CellBlockData->{Label} = $DynamicFieldHTMLData->{Label};
                    }

                    $Param{LayoutObject}->Block(
                        Name => $ColBlockName,
                        Data => $CellBlockData,
                    );
                }
            }
            # Add templates for dynamicfields at end of row
            for my $TemplateData ( @TemplateDataList ) {
                $Param{LayoutObject}->Block(
                    Name => 'DynamicFieldMultiValueTemplate',
                    Data => $TemplateData,
                );
            }
        }
    }

    return 1;
}

1;
