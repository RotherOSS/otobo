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

package Kernel::Modules::AgentContactWDSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Return empty list when Subaction was passed as subactions are not supported here.
    return $LayoutObject->JSONReply( Data => [] ) if $Self->{Subaction};

    # Get FieldName from $ParamObject, bail out when not found
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $FieldName   = $ParamObject->GetParam( Param => 'Field' );
    if (
        !$FieldName
        ||
        (
            $FieldName !~ m{ \A Autocomplete_DynamicField_ (.*) \z }xms
            && $FieldName !~ m{ \A Search_DynamicField_ (.*) \z }xms
        )
        )
    {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => 'Need Field!',
            }
        );
    }
    else {
        $FieldName = $1;    # effectively remove prefix Autocomplete_DynamicField_ or Search_DynamicField_
    }

    # Get config for the dynamic field and check the sanity
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $FieldName,
    );
    if (
        !IsHashRefWithData($DynamicField)
        || $DynamicField->{FieldType} ne 'ContactWD'
        || $DynamicField->{ValidID} ne 1
        )
    {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => 'Error reading dynamic field!',
            }
        );
    }

    # search contacts, rthe results will be returned as JSON
    my @Results;
    {
        my $Search               = $ParamObject->GetParam( Param => 'Term' ) || '';
        my $RemainingResultCount = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );

        # make search safe and use '*' as wildcard
        $Search =~ s{ \A \s+ }{}xms;
        $Search =~ s{ \s+ \z }{}xms;
        $Search = 'A' . $Search . 'Z';
        my @SearchParts = split /\*/, $Search;
        for my $SearchPart (@SearchParts) {
            $SearchPart = quotemeta($SearchPart);
        }
        $Search = join '.*', @SearchParts;
        $Search =~ s{ \A A }{}xms;
        $Search =~ s{ Z \z }{}xms;

        # get possible contacts
        my $PossibleContacts = $DynamicField->{Config}->{ContactsWithData};
        my $SearchableFields = $DynamicField->{Config}->{SearchableFieldsComputed};
        CONTACT:
        for my $Contact ( sort { lc($a) cmp lc($b) } keys %{$PossibleContacts} ) {

            # check whether the contact matches the search term
            my %ContactData = %{ $PossibleContacts->{$Contact} };
            my $SearchMatch;
            FIELD:
            for my $Field ( @{$SearchableFields} ) {
                next FIELD if $ContactData{$Field} !~ m{ $Search }xmsi;

                $SearchMatch = 1;

                last FIELD;
            }

            next CONTACT unless $SearchMatch;

            # only valid contacts are returned
            next CONTACT unless $ContactData{ValidID};
            next CONTACT unless $ContactData{ValidID} eq 1;

            push @Results, {
                Key   => $Contact,
                Value => $ContactData{Name},
            };
            $RemainingResultCount--;

            # only a limited number of contacts are returned
            last CONTACT if $RemainingResultCount <= 0;
        }
    }

    return $LayoutObject->JSONReply(
        Data => \@Results,
    );
}

1;
