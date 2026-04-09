# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Output::HTML::Elasticsearch::ElasticsearchCustomerUserGeneric;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

use parent qw(Kernel::Output::HTML::Elasticsearch::ElasticsearchGeneric);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ESSearchQuery = $ParamObject->GetParam( Param => 'FulltextES' ) || $ParamObject->GetParam( Param => 'AdditionalFilter' );

    my $Result = $Self->_ElasticSearchCustomerUsers(
        Query => $ESSearchQuery,
    );

    if ( $Result->{TotalCustomerUserCount} == 0 ) {
        return '';
    }

    my $CustomerUserKeys = $Result->{CustomerUserKeys};

    my @Columns = $SearchObjects->{CustomerUser}->{Attributes}->@*;

    $Self->ShowPagination(
        ESSearchQuery => $ESSearchQuery,
        ItemsPerPage  => $Self->{PageShown} || $SearchObjects->{CustomerUser}{Count},
        TotalResults  => $Result->{TotalCustomerUserCount},
        AJAX          => $Param{AJAX},
    );

    $Self->ShowHeaders(
        Columns         => \@Columns,
        AttributeHeader => $SearchObjects->{CustomerUser}->{AttributeHeader},
        SortColumn      => 'UserLogin',
    );

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # show customer users
    my $Count = 0;
    CUSTOMERUSER:
    for my $CustomerUserKey ( @{$CustomerUserKeys} ) {

        $Count++;

        my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUserKey,
        );

        # show customer user
        $LayoutObject->Block(
            Name => 'ElasticSearchResultGenericRow',
            Data => \%CustomerUserData,
        );

        # save column content
        my $DataValue;

        # show all needed columns
        COLUMN:
        for my $Column (@Columns) {

            $LayoutObject->Block(
                Name => 'GeneralOverviewRow',
            );

            $LayoutObject->Block(
                Name => 'ElasticSearchResultGenericTicketColumn',
                Data => {},
            );

            my $BlockType = "ElasticSearchResultGenericColumn";

            $DataValue = $CustomerUserData{$Column};

            if ( $Column eq 'UserLogin' ) {
                $BlockType = "ElasticSearchResultGenericCustomerUserLogin";
            }

            $LayoutObject->Block(
                Name => $BlockType,
                Data => {
                    GenericValue => $DataValue || '-',
                    UserLogin    => $CustomerUserData{UserLogin},
                    Class        => '',
                },
            );
        }
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'ElasticsearchResultGeneric',
        Data         => {
            %{ $Self->{Config} },
            Name                  => $Self->{Name},
            AdditionalFilterValue => $ESSearchQuery,
        },
        AJAX => $Param{AJAX},
    );

    return $Content;
}

sub _ElasticSearchCustomerUsers {

    my ( $Self, %Param ) = @_;

    my $Query = $Param{Query};

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');

    # get objects
    my %Result = (
        CustomerUserKeys       => [],
        TotalCustomerUserCount => 0,
    );

    if ( !$Query ) {
        return \%Result;
    }

    if ( $SearchObjects->{CustomerUser} && $SearchObjects->{CustomerUser}{Count} ) {

        # Search customer by ES.
        my $SearchResult = $ESObject->CustomerUserSearch(
            Fulltext => $Query,
            Limit    => $Self->{PageShown} || $SearchObjects->{CustomerUser}{Count},
            From     => $Self->{StartHit} - 1,
            Result   => 'ARRAY',
            SortBy   => 'UserLogin',
            OrderBy  => $Self->{OrderBy},
        );

        my @CustomerUserKeys = $SearchResult->{Data}->@*;
        $Result{CustomerUserKeys}       = \@CustomerUserKeys;
        $Result{TotalCustomerUserCount} = $SearchResult->{Total} // 0;
    }

    return \%Result;
}

1;
