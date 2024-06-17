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
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $JSON = '';

    # search customers
    if ( !$Self->{Subaction} ) {

        # get needed params
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $Search      = $ParamObject->GetParam( Param => 'Term' ) || '';
        my $MaxResults  = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );
        my $FieldName   = $ParamObject->GetParam( Param => 'Field' );

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if (
            !$FieldName
            ||
            (
                $FieldName !~ m{ \A Autocomplete_DynamicField_ (.*) \z }xms
                && $FieldName !~ m{ \A Search_DynamicField_ (.*) \z }xms
            )
            )
        {
            return $Self->_ReturnJSON(
                Content => $LayoutObject->JSONEncode(
                    Data => {
                        Success  => 0,
                        Messsage => 'Need Field!',
                    }
                ),
            );
        }
        $FieldName = $1;

        # get dynamic field
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            Name => $FieldName,
        );
        if (
            !IsHashRefWithData($DynamicField)
            || $DynamicField->{FieldType} ne 'ContactWD'
            || $DynamicField->{ValidID} ne 1
            )
        {
            return $Self->_ReturnJSON(
                Content => $LayoutObject->JSONEncode(
                    Data => {
                        Success  => 0,
                        Messsage => 'Error reading dynamic field!',
                    }
                ),
            );
        }

        # make search safe and use '*' as wildcard
        $Search =~ s{ \A \s+ }{}xms;
        $Search =~ s{ \s+ \z }{}xms;
        $Search = 'A' . $Search . 'Z';
        my @SearchParts = split '\*', $Search;
        for my $SearchPart (@SearchParts) {
            $SearchPart = quotemeta($SearchPart);
        }
        $Search = join '.*', @SearchParts;
        $Search =~ s{ \A A }{}xms;
        $Search =~ s{ Z \z }{}xms;

        # get possible contacts
        my @Data;
        my $MaxResultCount   = $MaxResults;
        my $PossibleContacts = $DynamicField->{Config}->{ContactsWithData};
        my $SearchableFields = $DynamicField->{Config}->{SearchableFieldsComputed};
        CONTACT:
        for my $Contact ( sort { lc($a) cmp lc($b) } keys %{$PossibleContacts} ) {
            my %ContactData = %{ $PossibleContacts->{$Contact} };
            my $SearchMatch;
            FIELD:
            for my $Field ( @{$SearchableFields} ) {
                next FIELD if $ContactData{$Field} !~ m{ $Search }xmsi;
                $SearchMatch = 1;
                last FIELD;
            }
            next CONTACT if !$SearchMatch;

            next CONTACT if !$ContactData{ValidID};
            next CONTACT if $ContactData{ValidID} ne 1;
            push @Data, {
                Key   => $Contact,
                Value => $ContactData{Name},
            };
            $MaxResultCount--;
            last CONTACT if $MaxResultCount <= 0;
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@Data,
        );
    }

    return $Self->_ReturnJSON(
        Content => $JSON,
    );
}

sub _ReturnJSON {
    my ( $Self, %Param ) = @_;

    # send JSON response
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $Param{Content} || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
