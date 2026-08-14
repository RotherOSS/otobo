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

package Kernel::Output::HTML::Elasticsearch::ElasticsearchCustomerGeneric;

use strict;
use warnings;

use parent qw(Kernel::Output::HTML::Elasticsearch::ElasticsearchGeneric);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ESSearchQuery = $ParamObject->GetParam( Param => 'FulltextES' ) || $ParamObject->GetParam( Param => 'AdditionalFilter' );

    my $Result = $Self->_ElasticSearchCustomers(
        Query => $ESSearchQuery,
    );

    if ( $Result->{TotalCustomerCompanyCount} == 0 ) {
        return '';
    }

    my $CustomerKeys = $Result->{CustomerKeys};

    my @Columns = $SearchObjects->{CustomerCompany}->{Attributes}->@*;

    $Self->ShowPagination(
        ESSearchQuery => $ESSearchQuery,
        ItemsPerPage  => $Self->{PageShown} || $SearchObjects->{CustomerCompany}{Count},
        TotalResults  => $Result->{TotalCustomerCompanyCount},
        AJAX          => $Param{AJAX},
    );

    $Self->ShowHeaders(
        Columns         => \@Columns,
        AttributeHeader => $SearchObjects->{CustomerCompany}->{AttributeHeader},
        SortColumn      => 'CustomerID',
    );

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    # show customers
    my $Count = 0;
    CUSTOMER:
    for my $CustomerKey ( @{$CustomerKeys} ) {
        $Count++;

        my %CustomerCompanyData = $CustomerCompanyObject->CustomerCompanyGet(
            CustomerID => $CustomerKey,
        );

        # show customer
        $LayoutObject->Block(
            Name => 'ElasticSearchResultGenericRow',
            Data => \%CustomerCompanyData,
        );

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

            $DataValue = $CustomerCompanyData{$Column};

            if ( $Column eq 'CustomerCompanyName' ) {
                $BlockType = "ElasticSearchResultGenericCustomerCompanyName";
            }

            $LayoutObject->Block(
                Name => $BlockType,
                Data => {
                    GenericValue => $DataValue || '-',
                    CustomerID   => $CustomerCompanyData{CustomerID},
                    CustomerName => $CustomerCompanyData{CustomerCompanyName},
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

sub _ElasticSearchCustomers {

    my ( $Self, %Param ) = @_;

    my $Query = $Param{Query};

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');

    # get objects
    my %Result = (
        CustomerKeys              => [],
        TotalCustomerCompanyCount => 0,
    );

    if ( !$Query ) {
        return \%Result;
    }

    if ( $SearchObjects->{CustomerCompany} && $SearchObjects->{CustomerCompany}{Count} ) {

        # Search customer by ES.
        my $SearchResult = $ESObject->CustomerCompanySearch(
            Fulltext => $Query,
            Limit    => $Self->{PageShown} || $SearchObjects->{CustomerCompany}{Count},
            From     => $Self->{StartHit} - 1,
            Result   => 'ARRAY',
            SortBy   => 'CustomerID',
            OrderBy  => $Self->{OrderBy},
        );

        my @CustomerKeys = $SearchResult->{Data}->@*;
        $Result{CustomerKeys}              = \@CustomerKeys;
        $Result{TotalCustomerCompanyCount} = $SearchResult->{Total} // 0;
    }

    return \%Result;
}

1;
