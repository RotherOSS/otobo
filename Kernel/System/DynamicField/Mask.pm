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

package Kernel::System::DynamicField::Mask;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;
use namespace::autoclean;

# core modules
use List::Util qw(first);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Backend

=head1 DESCRIPTION

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=head2 new()

create a DynamicFieldMask backend object. Do not use it directly, instead use:

    my $DynamicFieldMaskObject = $Kernel::OM->Get('Kernel::System::DynamicField::Mask');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 EditSectionRender()

creates the field HTML to be used in edit masks for multiple dynamic fields.

    my $Success = $DynamicFieldMaskObject->EditSectionRender(
        Content               => \@Content,
        DynamicFields         => \%DynamicFieldConfigs,
        UpdatableFields       => $Self->_GetFieldsToUpdate(),
        LayoutObject          => $LayoutObject,
        ParamObject           => $ParamObject,
        DynamicFieldValues    => {                  # optional - else taken from ParamObject
            DynamicField_Name1 => [...],
            DynamicField_Name2 => 'Value',
        },
        PossibleValuesFilter  => {                  # optional
            DynamicField_Name1 => {...},
        },
        Errors                => {                  # optional
            DynamicField_Name1 => {...},
        }
        Visibility            => \%Visibility,      # optional
        SeparateDynamicFields => {                  # optional TODO: deprecate
            Name3 => 1,
        }
    );

=cut

sub EditSectionRender {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Content DynamicFields LayoutObject ParamObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{Content} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid content!",
        );

        return;
    }

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    $Param{DynamicFieldValues}   ||= {};
    $Param{PossibleValuesFilter} ||= {};
    $Param{Errors}               ||= {};

    my $RenderRow = sub {
        my %Row = @_;

        # prepare row block
        my $RowReadOnly;
        {
            # set complete row read only, if one element is
            $RowReadOnly = ( first { $_->{ReadOnly} } $Row{Fields}->@* ) ? 1 : 0;

            # special treatment for separate dynamic fields based on first field TODO: maybe discard?
            my $RowBlockName = $Param{SeparateDynamicFields} && $Param{SeparateDynamicFields}->{ $Row{Fields}[0]{DF} }
                ? 'Row_DynamicField_' . $Row{Fields}[0]{DF} : 'Row_DynamicField';

            # collect special classes
            my $RowClassString = $Row{Columns} > 1 ? ' MultiColumn' : '';

            # hide complete row if no field is visible
            if ( $Param{Visibility} && !grep { $Param{Visibility}{"DynamicField_$_->{DF}"} } $Row{Fields}->@* ) {
                $RowClassString .= ' oooACLHidden';
            }

            # TODO: think about using a separate template for dynamic fields and maybe ->Output() in the end; only possible without separate DFs
            $Param{LayoutObject}->Block(
                Name => $RowBlockName,
                Data => {
                    TemplateColumns => $Row{ColumnWidths},
                    RowClasses      => $RowClassString,
                },
            );
        }

        # in case of multirow and multivalue, get the largest multi value size
        my $MultiValueMaxCount = 0;
        if ( $Row{Columns} > 1 && first { $Param{DynamicFields}{ $_->{DF} }{Config}{MultiValue} } $Row{Fields}->@* ) {
            for my $Field ( $Row{Fields}->@* ) {
                if ( !ref $Param{DynamicFieldValues}{ $Field->{DF} } ) {
                    $MultiValueMaxCount ||= $Param{DynamicFieldValues}{ $Field->{DF} } ? 1 : 0;
                }
                elsif ( scalar $Param{DynamicFieldValues}{ $Field->{DF} } > $MultiValueMaxCount ) {
                    $MultiValueMaxCount = scalar $Param{DynamicFieldValues}{ $Field->{DF} };
                }
            }
        }

        # prepare dynamic field HTML and positioning
        my @ValueGrid;
        my @MultiValueTemplates;
        my $CellStart = 1;
        for my $Field ( $Row{Fields}->@* ) {
            my $DynamicField = $Param{DynamicFields}{ $Field->{DF} };
            my $DFName       = "DynamicField_$DynamicField->{Name}";

            # don't set a default value for hidden fields
            my %InvisibleNoDefault;
            if (
                $Param{Visibility}
                && !$Param{Visibility}{ $DFName }
                && $DynamicField->{FieldType} ne 'Date'
                && $DynamicField->{FieldType} ne 'DateTime'
                )
            {
                %InvisibleNoDefault = (
                    UseDefaultValue      => 0,
                    OverridePossibleNone => 1,
                );
            }

            # set errors if present
            my %Error;
            if ( $Param{Errors}{ $DFName } ) {
                %Error = $Param{Errors}{ $DFName }->%*;
            }

            # fill dynamic field values with empty strings until it matches the maximum value count
            if ( $MultiValueMaxCount && $DynamicField->{Config}{MultiValue} ) {
                if ( !defined $Param{DynamicFieldValues}{ $DFName } ) {
                    $Param{DynamicFieldValues}{ $DFName } = [];
                }
                elsif ( !ref $Param{DynamicFieldValues}{ $DFName } ) {
                    $Param{DynamicFieldValues}{ $DFName } = [ $Param{DynamicFieldValues}{ $DFName } ];
                }

                if ( scalar $Param{DynamicFieldValues}{ $DFName }->@* < $MultiValueMaxCount ) {
                    push $Param{DynamicFieldValues}{ $DFName }->@*, ('') x ( $MultiValueMaxCount - scalar $Param{DynamicFieldValues}{ $DFName }->@* );
                }
            }

            # get field html
            my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicField,
                PossibleValuesFilter => $Param{PossibleValuesFilter}{ $DFName },
                Value                => $Param{DynamicFieldValues}{ $DFName },
                LayoutObject         => $Param{LayoutObject},
                ParamObject          => $Param{ParamObject},
                AJAXUpdate           => 1,
                UpdatableFields      => $Param{UpdatableFields},
                Mandatory            => $Field->{Mandatory},
                ReadOnly             => $Field->{ReadOnly},
                %Error,
                %InvisibleNoDefault,
            );

            my $CellClassString = '';

            # hide fields
            if ( $Param{Visibility} && !$Param{Visibility}{ $DFName} ) {
                $CellClassString .= ' oooACLHidden';

                # ACL hidden fields cannot be mandatory
                if ( $Field->{Mandatory} ) {
                    $DynamicFieldHTML =~ s/(class=.+?Validate_Required)/$1_IfVisible/g;
                }
            }

            # column placement
            if ( $Field->{ColumnStart} && $Field->{ColumnStart} > $CellStart ) {
                $CellStart = int $Field->{ColumnStart};
            }

            my $CellSpan  = $Field->{ColumnSpan} ? int $Field->{ColumnSpan} : 1;
            my $CellStyle = "grid-column: $CellStart / span $CellSpan";

            $CellStart += $CellSpan;

            # special treatment for separate dynamic fields
            my $ColBlockName = $Param{SeparateDynamicFields} && $Param{SeparateDynamicFields}->{ $Field->{DF} }
                ? 'DynamicField_' . $Field->{DF} : 'DynamicField';

            my %CellBlockData = (
                Name        => $DynamicField->{Name},
                CellStyle   => $CellStyle,
                Tooltip     => $DynamicField->{Config}{Tooltip},
                MultiValue  => $DynamicField->{Config}{MultiValue},
                RowReadOnly => $RowReadOnly,
                CellClasses => $CellClassString,
            );

            # multi value
            if ( $DynamicField->{Config}{MultiValue} ) {
                for my $ValueRowIndex ( 0 .. $MultiValueMaxCount ) {
                    my %Label = $ValueRowIndex == 0 ? ( Label => $DynamicFieldHTML->{Label} ) : ();

                    push $ValueGrid[ $ValueRowIndex ]->@*, {
                        Name => $ColBlockName,
                        Data => {
                            %CellBlockData,
                            %Label,
                            Field       => $DynamicFieldHTML->{MultiValue}[0],
                            Index       => $ValueRowIndex,
                            CellClasses => $CellClassString . ' MultiValue_' . $ValueRowIndex,
                        },
                    }
                }

                push @MultiValueTemplates, {
                    Name => 'Template' . $ColBlockName,
                    Data => {
                        %CellBlockData,
                        Field => $DynamicFieldHTML->{MultiValueTemplate},
                    }
                }
            }

            # no multi value
            else {
                push $ValueGrid[0]->@*, {
                    Name => $ColBlockName,
                    Data => {
                        %CellBlockData,
                        Field => $DynamicFieldHTML->{Field},
                        Label => $DynamicFieldHTML->{Label},
                        Index => 0,
                    },
                }
            }
        }

        # block all dynamic fields for this df row
        for my $ValueRowIndex ( 0 .. $MultiValueMaxCount ) {
            for my $FieldData ( $ValueGrid[ $ValueRowIndex ]->@* ) {
                $Param{LayoutObject}->Block(
                    $FieldData->%*,
                );
            }
        }

        for my $FieldData ( @MultiValueTemplates ) {
            $Param{LayoutObject}->Block(
                $FieldData->%*,
            );
        }
    };

    # cycle through content rows
    ELEMENT:
    for my $Element ( $Param{Content}->@* ) {
        if ( !IsHashRefWithData( $Element ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Misconfigured Definition!",
            );

            next ELEMENT;
        }

        if ( $Element->{DF} ) {
            $RenderRow->(
                Fields      => [ $Element ],
                Columns     => 1,
                ColumnWidth => '1fr',
            );
        }
        elsif ( $Element->{Grid} ) {
            if ( !IsArrayRefWithData( $Element->{Grid}{Rows} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Misconfigured Grid - need Rows as Array!",
                );

                next ELEMENT;
            }
            if ( $Element->{Grid}{Columns} !~ /^0*[1-9]\d*$/ ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Misconfigured Grid - need Columns as integer > 0!",
                );

                next ELEMENT;
            }

            # basic corrections for grid-template-rows
            my @Widths = ( $Element->{Grid}{ColumnWidth} =~ /([\d\.]*\w+)/g );
            
            if ( @Widths < $Element->{Grid}{Columns} ) {
                push @Widths, ('1fr') x ( $Element->{Grid}{ColumnWidth} - @Widths )
            }

            my $ColumnWidth = join( ' ', @Widths[ 0 .. $Element->{Grid}{Columns} - 1 ] );

            for my $Row ( $Element->{Grid}{Rows}->@* ) {
                $RenderRow->(
                    Fields      => $Row,
                    Columns     => $Element->{Grid}{Columns},
                    ColumnWidth => $ColumnWidth,
                );
            }
        }
    }

    return 1;
}

=head2 DisplaySectionRender()

creates the field HTML to be used in display masks for multiple dynamic fields.

    my $SectionHTML = $DynamicFieldMaskObject->DisplaySectionRender(
    );

=cut

sub DisplaySectionRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw()) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

}


1;
