# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AgentReferenceSearch;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # only search is supported
    return $LayoutObject->JSONReply(
        Data => {
            Success  => 0,
            Messsage => qq{Subaction '$Self->{Subaction}' is not supported!},
        },
    ) if $Self->{Subaction};

    # Get name of the dynamic field from $ParamObject, bail out when not found.
    # The multi value fields are marked by a trailing qr{_\d+}.
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Field       = $ParamObject->GetParam( Param => 'Field' );
    my $FieldName;
    if (
        !$Field
        ||

        # possible constellations:
        #   Autocomplete_DynamicField_Fieldname
        #   Autocomplete_Search_DynamicField_Fieldname
        $Field !~ m{ \A (?: Autocomplete (?: _Search )? ) _DynamicField_ (.*?) (?:_[0-9a-f]+)? \z }xms
        )
    {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => 'Need Field!',
            },
        );
    }
    else {
        $FieldName = $1;    # remove either the prefix 'Autocomplete_DynamicField_' or the prefix 'Search_DynamicField_'
    }

    # Get config for the dynamic field and check the sanity.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldConfig        = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $FieldName,
    );
    if (
        !IsHashRefWithData($DynamicFieldConfig)
        ||
        !$DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsReferenceField',
        )
        )
    {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => qq{Error reading the dynamic field '$FieldName'!},
            }
        );
    }

    # search referenced object
    my $MaxResults = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );
    my $Term       = $ParamObject->GetParam( Param => 'Term' ) || '';

    my @ObjectIDs = $DynamicFieldBackendObject->SearchObjects(
        DynamicFieldConfig => $DynamicFieldConfig,    # this might contain search restrictions
        Term               => $Term,
        MaxResults         => $MaxResults,
        UserID             => 1,                      # TODO: what about Permission check
        ParamObject        => $ParamObject,
    );

    # differentiate depending on whether field is multivalue
    my @FormDataObjectIDs = @ObjectIDs;
    if ( $DynamicFieldConfig->{Config}{MultiValue} ) {

        # if so, do GetFormData() and store value combined with ObjectIDs
        my $LastSearchResults = $Kernel::OM->Get('Kernel::System::Web::FormCache')->GetFormData(
            LayoutObject => $LayoutObject,
            Key          => 'PossibleValues_DynamicField_' . $DynamicFieldConfig->{Name},
        );

        if ($LastSearchResults) {
            for my $ResultItem ( $LastSearchResults->@* ) {
                if ( none { $_ eq $ResultItem } @FormDataObjectIDs ) {
                    push @FormDataObjectIDs, $ResultItem;
                }
            }
        }
    }

    # store all possible values for this field and form id for later verification
    $Kernel::OM->Get('Kernel::System::Web::FormCache')->SetFormData(
        LayoutObject => $LayoutObject,
        FormID       => $ParamObject->GetParam( Param => 'FormID' ),
        Key          => 'PossibleValues_DynamicField_' . $Param{DynamicFieldConfig}{Name},
        Value        => \@FormDataObjectIDs,
    );

    my @Results;
    for my $ObjectID (@ObjectIDs) {
        my %Description = $DynamicFieldBackendObject->ObjectDescriptionGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $ObjectID,
            UserID             => 1,                     # TODO: what about Permission check
        );

        push @Results, {
            Key   => $ObjectID,
            Value => $Description{Long},
        };
    }

    # sort results by value
    @Results = sort { $a->{Value} cmp $b->{Value} } @Results;

    return $LayoutObject->JSONReply(
        Data => \@Results,
    );
}

1;
