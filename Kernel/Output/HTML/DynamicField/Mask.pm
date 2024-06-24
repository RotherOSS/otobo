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

package Kernel::Output::HTML::DynamicField::Mask;

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
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::Output::HTML::DynamicField::Mask

=head1 DESCRIPTION

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=head2 new()

create a DynamicFieldMask backend object. Do not use it directly, instead use:

    my $DynamicFieldMaskObject = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask');

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
        },
        AJAXUpdate            => (1|0),             # optional render dynamic fields with or without AJAXUpdate, defaults to 1
        CustomerInterface     => 1,                 # optional indicates which templates are needed, defaults to 0 (Agent interface)
        Object                => \%Object,          # optional data needed for evaluating script fields and fetching reference field possible values
    );

=cut

sub EditSectionRender {
    my ( $Self, %Param ) = @_;

    my $TemplateFile = $Param{CustomerInterface} ? 'DynamicField/CustomerEditField' : 'DynamicField/AgentEditField';

    $Param{Content} ||= [];

    if ( ref $Param{Content} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid content!",
        );

        return;
    }

    # check needed params
    for my $Needed (qw(DynamicFields LayoutObject ParamObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    $Param{DynamicFieldValues}   ||= {};
    $Param{PossibleValuesFilter} ||= {};
    $Param{Errors}               ||= {};

    my $RenderRow = sub {
        my %Row = @_;

        # prepare row block
        {
            # special treatment for separate dynamic fields based on first field TODO: maybe discard?
            my $RowBlockName = $Param{SeparateDynamicFields} && $Param{SeparateDynamicFields}->{ $Row{Fields}[0]{DF} }
                ? 'Row_DynamicField_' . $Row{Fields}[0]{DF} : 'Row_DynamicField';

            # collect special classes
            my $RowClassString = $Row{Columns} > 1 ? ' MultiColumn' : '';
            $RowClassString .= ( first { $Param{DynamicFields}{ $_->{DF} }{Config}{MultiValue} } $Row{Fields}->@* ) ? ' MultiValue' : '';

            # hide complete row if no field is visible
            if ( $Param{Visibility} && !grep { $Param{Visibility}{"DynamicField_$_->{DF}"} } $Row{Fields}->@* ) {
                $RowClassString .= ' oooACLHidden';
            }

            # TODO: think about using a separate template for dynamic fields and maybe ->Output() in the end; only possible without separate DFs
            $Param{LayoutObject}->Block(
                Name => $RowBlockName,
                Data => {
                    TemplateColumns => $Row{ColumnWidth},
                    RowClasses      => $RowClassString,
                },
            );
        }

        # prepare dynamic field HTML and positioning
        my @ValueGrid;
        my @MultiValueTemplates;
        my $CellStart = 1;
        FIELD:
        for my $Field ( $Row{Fields}->@* ) {
            if ( !$Param{DynamicFields}{ $Field->{DF} } ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need DynamicFieldConfig for '$Field->{DF}'!",
                );

                next FIELD;
            }

            my $DynamicField = $Param{DynamicFields}{ $Field->{DF} };
            my $DFName       = "DynamicField_$Field->{DF}";
            my $FieldClasses = 'Field' . ( $DynamicField->{FieldType} eq 'RichText' ? ' RichTextField' : '' );

            # don't set a default value for hidden fields
            my %InvisibleNoDefault;
            if (
                $Param{Visibility}
                && !$Param{Visibility}{$DFName}
                )
            {
                %InvisibleNoDefault = (
                    ACLHidden => 1,
                );

                if (
                    $DynamicField->{FieldType} ne 'Date'
                    && $DynamicField->{FieldType} ne 'DateTime'
                    )
                {
                    $InvisibleNoDefault{UseDefaultValue}      = 0;
                    $InvisibleNoDefault{OverridePossibleNone} = 1;
                }
            }

            # set errors if present
            my %Error;
            if ( $Param{Errors}{ $Field->{DF} } ) {
                %Error = $Param{Errors}{ $Field->{DF} }->%*;
            }

            # get field html
            my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicField,
                PossibleValuesFilter => $Param{PossibleValuesFilter}{$DFName},
                Value                => $Param{DynamicFieldValues}{$DFName},
                LayoutObject         => $Param{LayoutObject},
                ParamObject          => $Param{ParamObject},
                AJAXUpdate           => $Param{AJAXUpdate} // 1,
                Mandatory            => $Field->{Mandatory},
                Readonly             => $Field->{Readonly},
                CustomerInterface    => $Param{CustomerInterface},
                Object               => $Param{Object},
                %Error,
                %InvisibleNoDefault,
            );

            my $CellClassString = '';

            # hide fields
            if ( $Param{Visibility} && !$Param{Visibility}{$DFName} ) {
                $CellClassString .= ' oooACLHidden';
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
                CellClasses => $CellClassString,
                Readonly    => $Field->{Readonly},
            );

            # multi value
            # The label is show only for the first value
            if ( $DynamicField->{Config}{MultiValue} ) {
                for my $ValueRowIndex ( 0 .. $#{ $DynamicFieldHTML->{MultiValue} } ) {
                    push $ValueGrid[$ValueRowIndex]->@*, {
                        Name => $ColBlockName,
                        Data => {
                            %CellBlockData,
                            Label        => $DynamicFieldHTML->{Label},                           # TODO: fix the numbering of 'id' and 'for'
                            Field        => $DynamicFieldHTML->{MultiValue}[$ValueRowIndex],
                            FieldClasses => $FieldClasses,
                            Index        => $ValueRowIndex,
                            CellClasses  => $CellClassString . ' MultiValue_' . $ValueRowIndex,
                        },
                    };
                }

                push @MultiValueTemplates, {
                    Name => 'Template' . $ColBlockName,
                    Data => {
                        %CellBlockData,
                        Label        => $DynamicFieldHTML->{Label},                # TODO: fix the numbering of 'id' and 'for'
                        Field        => $DynamicFieldHTML->{MultiValueTemplate},
                        FieldClasses => $FieldClasses,
                    }
                };
            }

            # no multi value
            else {
                push $ValueGrid[0]->@*, {
                    Name => $ColBlockName,
                    Data => {
                        %CellBlockData,
                        Field        => $DynamicFieldHTML->{Field},
                        FieldClasses => $FieldClasses,
                        Label        => $DynamicFieldHTML->{Label},
                        Index        => 0,
                    },
                };
            }
        }

        # block all dynamic fields for this df row
        for my $ValueRow (@ValueGrid) {
            for my $FieldData ( $ValueRow->@* ) {
                $Param{LayoutObject}->Block(
                    $FieldData->%*,
                );
            }
        }

        for my $FieldData (@MultiValueTemplates) {
            $Param{LayoutObject}->Block(
                $FieldData->%*,
            );
        }
    };

    # cycle through content rows
    ELEMENT:
    for my $Element ( $Param{Content}->@* ) {
        if ( !IsHashRefWithData($Element) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Misconfigured Definition!",
            );

            next ELEMENT;
        }

        if ( $Element->{DF} ) {
            $RenderRow->(
                Fields      => [$Element],
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
            my @Widths = $Element->{Grid}{ColumnWidth} ? ( $Element->{Grid}{ColumnWidth} =~ /([\d\.]*\w+)/g ) : ();

            if ( @Widths < $Element->{Grid}{Columns} ) {
                push @Widths, ('1fr') x ( $Element->{Grid}{Columns} - @Widths );
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

    return $Param{LayoutObject}->Output(
        TemplateFile => $TemplateFile,
    );
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

    return;

}

1;
