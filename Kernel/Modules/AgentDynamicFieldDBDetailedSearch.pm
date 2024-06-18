# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Modules::AgentDynamicFieldDBDetailedSearch;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get params
    for (qw(DynamicFieldName DynamicFieldID TicketID ActivityDialogID)) {
        $Param{$_} = $ParamObject->GetParam( Param => $_ );
    }

    # get the pure DynamicField name without prefix
    my $DynamicFieldName = substr( $Param{DynamicFieldName}, 13 );

    # if ActivityDialogID is set, strip it from DynamicFieldName
    my $DynamicFieldNameLong = $DynamicFieldName;
    if ( defined $Param{ActivityDialogID} && $Param{ActivityDialogID} != '' ) {
        $DynamicFieldName = substr( $DynamicFieldName, 0, index( $DynamicFieldName, '_' . $Param{ActivityDialogID} ) );
    }

    # get the dynamic field value for the current ticket
    my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $DynamicFieldName,
    );

    # determine the maximum amount of displayable results
    my $ResultLimit = 0;

    if (
        defined $DynamicFieldConfig->{Config}->{ResultLimit}
        && $DynamicFieldConfig->{Config}->{ResultLimit} =~ /^\d+$/
        && $DynamicFieldConfig->{Config}->{ResultLimit} > 0
        )
    {
        $ResultLimit = $DynamicFieldConfig->{Config}->{ResultLimit};
    }

    # ---------------------------------------------------------- #
    # DetailedSearch
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'DetailedSearch' ) {

        my @ParamNames = $ParamObject->GetParamNames();

        my %SearchAttributes;
        for my $ParamName (@ParamNames) {

            if ( $ParamName =~ m/^DetailedSearch_(\d+)_(?:.+?)$/ ) {

                my $ParamValue = $ParamObject->GetParam( Param => $ParamName );

                if ($ParamValue) {
                    $SearchAttributes{$1} = $ParamValue;
                }
            }
        }

        # perform the search
        my %Result;
        if (%SearchAttributes) {

            # get the dynamic field database object
            $Kernel::OM->ObjectParamAdd(
                'Kernel::System::DynamicFieldDB' => {
                    DynamicFieldConfig => $DynamicFieldConfig,
                },
            );
            my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

            # perform the search based on the given dynamic field config
            %Result = $DynamicFieldDBObject->DatabaseSearchByAttributes(
                Config      => $DynamicFieldConfig->{Config},
                Search      => \%SearchAttributes,
                ResultLimit => $ResultLimit,
                TicketID    => $Param{TicketID},
            );
        }

        # generate the back-button parameters
        my $SearchAttributeParameters = '';

        SEARCHATTRIBUTEKEY:
        for my $SearchAttributeKey ( sort keys %SearchAttributes ) {

            next SEARCHATTRIBUTEKEY if !$SearchAttributeKey;

            my $SearchAttribute =
                'SearchParam_'
                . $SearchAttributeKey
                . '_'
                . $SearchAttributes{$SearchAttributeKey}
                . ';';

            $SearchAttributeParameters .= $SearchAttribute;
        }

        # show the search result page
        $LayoutObject->Block(
            Name => 'SearchResultAction',
            Data => {
                FieldName        => $DynamicFieldNameLong,
                ActivityDialogID => $Param{ActivityDialogID},
                SearchParam      => $SearchAttributeParameters,
                TicketID         => $Param{TicketID},
            },
        );

        $LayoutObject->Block(
            Name => 'SearchResult',
            Data => {
                DynamicFieldID   => $Param{DynamicFieldID},
                DynamicFieldName => $DynamicFieldNameLong,
            },
        );

        # Map column names to labels.
        my %ColumnLabels;
        for my $Key ( sort keys %{ $DynamicFieldConfig->{Config}->{PossibleValues} } ) {
            if ( $Key =~ m/^FieldName_(\d+)$/ ) {
                $ColumnLabels{ $DynamicFieldConfig->{Config}->{PossibleValues}->{$Key} } = $DynamicFieldConfig->{Config}->{PossibleValues}->{"FieldLabel_$1"};
            }
        }

        # built the table header
        HEADER:
        for my $Header ( @{ $Result{Columns} } ) {

            next HEADER if !$Header;

            # show the search overview page
            $LayoutObject->Block(
                Name => 'SearchResultHeader',
                Data => {
                    SearchResultHeader => $ColumnLabels{$Header},
                },
            );
        }

        if ( IsArrayRefWithData( $Result{Data} ) ) {

            # build the result rows
            SEARCHRESULTROW:
            for my $SearchResultRow ( @{ $Result{Data} } ) {

                next SEARCHRESULTROW if !$SearchResultRow;

                # add a result row
                $LayoutObject->Block(
                    Name => 'SearchResultRow',
                    Data => {
                        Identifier => $SearchResultRow->{Identifier},
                    },
                );

                for my $SearchResultColumn ( @{ $SearchResultRow->{Data} } ) {

                    # add a result row
                    $LayoutObject->Block(
                        Name => 'SearchResultColumn',
                        Data => {
                            SearchResultColumn => $SearchResultColumn || '',
                        },
                    );
                }
            }
        }
        else {
            # no data found
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
    }

    # ---------------------------------------------------------- #
    # Overview
    # ---------------------------------------------------------- #
    else {

        # check for search parameters to restore
        my @ParamNames = $ParamObject->GetParamNames();

        my %SearchParameters;

        PARAMNAME:
        for my $ParamName (@ParamNames) {

            next PARAMNAME if !$ParamName;

            if ( $ParamName =~ m{^SearchParam_} ) {

                # get the search parameter
                my $SearchParam       = substr( $ParamName, 12 );
                my @SearchParamChunks = split( /_/, $SearchParam );

                # save the prepared search parameter keys and values
                $SearchParameters{ $SearchParamChunks[0] } = $SearchParamChunks[1];
            }
        }

        # show the search overview page
        $LayoutObject->Block(
            Name => 'SearchOverview',
            Data => {
                DynamicFieldID   => $Param{DynamicFieldID},
                DynamicFieldName => $DynamicFieldNameLong,
                ActivityDialogID => $Param{ActivityDialogID},
                TicketID         => $Param{TicketID},
            },
        );

        # prepare the possible values hash based on the
        # sequential number of any item
        my $PreparedPossibleValues = {};

        KEY:
        for my $Key ( sort keys %{ $DynamicFieldConfig->{Config}->{PossibleValues} } ) {

            next KEY if !$Key;

            if ( $Key =~ m/^\w+_(\d+)$/ ) {

                if ( !IsHashRefWithData( $PreparedPossibleValues->{$1} ) ) {
                    $PreparedPossibleValues->{$1} = {
                        "$Key" => $DynamicFieldConfig->{Config}->{PossibleValues}->{$Key},
                    };
                }
                else {
                    $PreparedPossibleValues->{$1}->{$Key} = $DynamicFieldConfig->{Config}->{PossibleValues}->{$Key};
                }
            }
        }

        my %FieldList;
        my $DefaultFieldAmount = 0;

        FIELDKEY:
        for my $FieldKey ( sort keys %{$PreparedPossibleValues} ) {

            next FIELDKEY if !$FieldKey;

            # just show the first three items at the beginning
            if ( $DefaultFieldAmount < 1 ) {

                $LayoutObject->Block(
                    Name => 'SearchField',
                    Data => {
                        FieldKey   => $FieldKey,
                        FieldName  => $PreparedPossibleValues->{$FieldKey}->{"FieldName_$FieldKey"},
                        FieldLabel =>
                            $PreparedPossibleValues->{$FieldKey}->{"FieldLabel_$FieldKey"},
                        FieldValue => $SearchParameters{$FieldKey},
                    },
                );
            }
            else {
                # prepare the select items
                $FieldList{ $FieldKey . '_' . $PreparedPossibleValues->{$FieldKey}->{"FieldName_$FieldKey"} } = $PreparedPossibleValues->{$FieldKey}->{"FieldLabel_$FieldKey"};

                # add the hidden search fields
                $LayoutObject->Block(
                    Name => 'SearchFieldHidden',
                    Data => {
                        FieldKey   => $FieldKey,
                        FieldName  => $PreparedPossibleValues->{$FieldKey}->{"FieldName_$FieldKey"},
                        FieldLabel =>
                            $PreparedPossibleValues->{$FieldKey}->{"FieldLabel_$FieldKey"},
                        FieldValue => $SearchParameters{$FieldKey},
                    },
                );
            }

            $DefaultFieldAmount++;
        }

        # build the select field for the several search criteria
        my $SelectFieldList = $LayoutObject->BuildSelection(
            Data         => \%FieldList,
            Name         => 'SelectFieldList',
            ID           => 'SelectFieldList',
            PossibleNone => 1,
            Translation  => 0,
        );

        $LayoutObject->Block(
            Name => 'SearchFieldList',
            Data => {
                SearchFieldList => $SelectFieldList,
            },
        );

        # get list of users
        my $Search = $ParamObject->GetParam( Param => 'Search' );
        my %List;

        my $Count = 1;
        for ( reverse sort { $List{$b} cmp $List{$a} } keys %List ) {
            $LayoutObject->Block(
                Name => 'Row',
                Data => {
                    Name  => $List{$_},
                    Email => $_,
                    Count => $Count,
                },
            );
            $Count++;
        }
    }

    # start with page ...
    my $Output = $LayoutObject->Header( Type => 'Small' );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentDynamicFieldDBDetailedSearch',
        Data         => {
            %Param,
            DynamicFieldName => $DynamicFieldNameLong,
        }
    );
    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

1;
