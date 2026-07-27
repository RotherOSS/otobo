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

package Kernel::Output::HTML::Elasticsearch::ElasticsearchTicketGeneric;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

use parent qw(Kernel::Output::HTML::Elasticsearch::ElasticsearchGeneric);

our $ObjectManagerDisabled = 1;

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => Translatable('Shown Elasticsearch Results'),
            Name  => $Self->{PrefKeyShown},
            Block => 'Option',
            Data  => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
                50 => '50',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
        },
    );

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ESSearchQuery = $ParamObject->GetParam( Param => 'FulltextES' ) || $ParamObject->GetParam( Param => 'AdditionalFilter' );

    my $Result = $Self->_ElasticSearchTickets(
        Query => $ESSearchQuery,
    );

    if ( $Result->{TotalTicketCount} == 0 ) {
        return '';
    }

    my $TicketIDs = $Result->{TicketIDs};

    my @Columns = $SearchObjects->{Ticket}->{Attributes}->@*;

    $Self->ShowPagination(
        ESSearchQuery => $ESSearchQuery,
        ItemsPerPage  => $Self->{PageShown} || $SearchObjects->{Ticket}{Count},
        TotalResults  => $Result->{TotalTicketCount},
        AJAX          => $Param{AJAX},
    );

    $Self->ShowHeaders(
        Columns         => \@Columns,
        AttributeHeader => $SearchObjects->{Ticket}->{AttributeHeader},
        SortColumn      => 'Age',
    );

    # show tickets
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Queues      = $QueueObject->QueueList( Valid => 0 );

    my $Count = 0;
    TICKETID:
    for my $TicketEntry ( @{$TicketIDs} ) {
        $Count++;

        my ( $TicketID, $TicketParam ) = ( %{$TicketEntry} );

        for my $Attr ( @{ $SearchObjects->{Ticket}{Attributes} } ) {

            # prepare special attributes
            if ( $Attr eq 'Age' ) {
                $TicketParam->{Age} = $LayoutObject->CustomerAge(
                    Age   => $TicketParam->{Age},
                    Space => ' ',
                );
            }
            elsif ( $Attr eq 'Created' ) {
                my $CreatedFormat = $ConfigObject->Get('Elasticsearch::QuickSearchCreatedFormat');
                if ($CreatedFormat) {
                    $TicketParam->{Created} = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            Epoch => $TicketParam->{Created},
                        }
                    )->Format(
                        Format => $CreatedFormat,
                    );
                }
            }
            elsif ( $Attr eq 'Queue' ) {
                $TicketParam->{Queue} = $TicketParam->{Queue} // $Queues{ $TicketParam->{QueueID} };
            }
        }

        # show ticket
        $LayoutObject->Block(
            Name => 'ElasticSearchResultGenericRow',
            Data => $TicketParam,
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

            my $BlockType = '';
            my $CSSClass  = '';

            $DataValue = $TicketParam->{$Column};

            $BlockType = "ElasticSearchResultGenericColumn";

            if ( $Column eq 'TicketNumber' ) {
                $BlockType = "ElasticSearchResultGenericTicketNumber";
            }

            $LayoutObject->Block(
                Name => $BlockType,
                Data => {
                    GenericValue => $DataValue || '-',
                    TicketID     => $TicketID,
                    TicketNumber => $DataValue || '-',
                    Class        => $CSSClass  || '',
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

sub _ElasticSearchTickets {

    my ( $Self, %Param ) = @_;

    my $Query = $Param{Query};

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');

    # get objects
    my %Result = (
        TicketIDs        => [],
        TotalTicketCount => 0,
    );

    if ( !$Query ) {
        return \%Result;
    }

    if ( $SearchObjects->{Ticket} && $SearchObjects->{Ticket}{Count} ) {

        my $SearchResult = $ESObject->TicketSearch(
            Fulltext => $Query,
            UserID   => $Self->{UserID},
            Limit    => $Self->{PageShown} || $SearchObjects->{Ticket}{Count},
            From     => $Self->{StartHit} - 1,
            Result   => 'FULL',
            OrderBy  => $Self->{OrderBy},
            SortBy   => 'Age',
        );

        my @TicketIDs = $SearchResult->{Data}->@*;
        $Result{TicketIDs}        = \@TicketIDs;
        $Result{TotalTicketCount} = $SearchResult->{Total} // 0;
    }

    return \%Result;
}

1;
