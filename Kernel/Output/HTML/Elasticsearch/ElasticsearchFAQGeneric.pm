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

package Kernel::Output::HTML::Elasticsearch::ElasticsearchFAQGeneric;

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

    my $Result = $Self->_ElasticSearchFAQ(
        Query => $ESSearchQuery,
    );

    if ( $Result->{TotalFAQCount} == 0 ) {
        return '';
    }

    my $FAQIDs = $Result->{FAQIDs};

    my @Columns = $SearchObjects->{FAQ}->{Attributes}->@*;

    $Self->ShowPagination(
        ESSearchQuery => $ESSearchQuery,
        ItemsPerPage  => $Self->{PageShown} || $SearchObjects->{FAQ}{Count},
        TotalResults  => $Result->{TotalFAQCount},
        AJAX          => $Param{AJAX},
    );

    $Self->ShowHeaders(
        Columns         => \@Columns,
        AttributeHeader => $SearchObjects->{FAQ}->{AttributeHeader},
        SortColumn      => '',
    );

    # show FAQs
    my $Count = 0;
    FAQID:
    for my $FAQID ( @{$FAQIDs} ) {
        $Count++;

        my ( $FAQID, $FAQParam ) = ( %{$FAQID} );

        # show customer
        $LayoutObject->Block(
            Name => 'ElasticSearchResultGenericRow',
            Data => \$FAQParam,
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

            $DataValue = $$FAQParam{$Column};

            if ( $Column eq 'Number' ) {
                $BlockType = "ElasticSearchResultGenericFAQNumber";
            }

            $LayoutObject->Block(
                Name => $BlockType,
                Data => {
                    GenericValue => $DataValue || '-',
                    FAQID        => $FAQID,
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

sub _ElasticSearchFAQ {

    my ( $Self, %Param ) = @_;

    my $Query = $Param{Query};

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');

    # get objects
    my %Result = (
        FAQIDs        => [],
        TotalFAQCount => 0,
    );

    if ( !$Query ) {
        return \%Result;
    }

    if ( $SearchObjects->{FAQ} && $SearchObjects->{FAQ}{Count} ) {

        # Search faq by ES.
        my $SearchResult = $ESObject->FAQSearch(
            Fulltext => $Query,
            UserID   => $Self->{UserID},
            Limit    => $Self->{PageShown} || $SearchObjects->{FAQ}{Count},
            From     => $Self->{StartHit} - 1,
            Result   => 'FULL',
        );

        my @FAQIDs = $SearchResult->{Data}->@*;
        $Result{FAQIDs}        = \@FAQIDs;
        $Result{TotalFAQCount} = $SearchResult->{Total} // 0;
    }

    return \%Result;
}

1;
