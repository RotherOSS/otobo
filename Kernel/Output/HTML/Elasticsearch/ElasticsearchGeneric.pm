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

package Kernel::Output::HTML::Elasticsearch::ElasticsearchGeneric;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get sorting params
    for my $Item (qw(SortBy OrderBy)) {
        $Self->{$Item} = $ParamObject->GetParam( Param => $Item ) || $Param{$Item};
    }

    if ( !$Self->{OrderBy} ) {
        $Self->{OrderBy} = "Down";
    }

    $Self->{PrefKeyShown} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{ $Self->{PrefKeyShown} }
        || $Self->{Config}->{Limit};

    $Self->{StartHit} = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => Translatable('Shown Elasticsearch Results'),
            Name  => $Self->{PrefKeyShown},
            Block => 'Option',
            Data  => {
                3  => ' 3',
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

sub ShowPagination {

    my ( $Self, %Param ) = @_;

    my $ESSearchQuery = $Param{ESSearchQuery};
    my $ItemsPerPage  = $Param{ItemsPerPage};
    my $TotalResults  = $Param{TotalResults};
    my $AJAX          = $Param{AJAX};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get filter ticket counts
    $LayoutObject->Block(
        Name => 'ElasticSearchResultGenericFilter',
        Data => {
            %Param,
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
    );

    my $LinkPage =
        'Subaction=Element;Name=' . $Self->{Name}
        . ';FulltextES=' . $ESSearchQuery
        . ';OrderBy=' . ( $Self->{OrderBy} || '' )
        . ';';

    my %PageNav = $LayoutObject->PageNavBar(
        StartHit    => $Self->{StartHit},
        PageShown   => $Self->{PageShown} || $ItemsPerPage,
        AllHits     => $TotalResults      || 1,
        Action      => 'Action=' . $LayoutObject->{Action},
        Link        => $LinkPage,
        AJAXReplace => 'Dashboard' . $Self->{Name},
        IDPrefix    => 'Dashboard' . $Self->{Name},
        AJAX        => $AJAX,
    );

    $LayoutObject->Block(
        Name => 'ElasticSearchResultGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    return;
}

sub ShowHeaders {

    my ( $Self, %Param ) = @_;

    my @Columns         = $Param{Columns}->@*;
    my $AttributeHeader = $Param{AttributeHeader};
    my $SortColumn      = $Param{SortColumn} || '';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # show table header
    $LayoutObject->Block(
        Name => 'ElasticSearchResultGenericHeader',
        Data => {},
    );

    # # remove (-) from name for JS config
    my $WidgetName = $Self->{Name};
    $WidgetName =~ s{-}{}g;

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'HeaderColumn' . $WidgetName,
        Value => \@Columns
    );

    # # show non-labeled table headers
    my $CSS = '';

    # show all needed headers
    HEADERCOLUMN:
    for my $HeaderColumn (@Columns) {

        $CSS = '';
        if ( $HeaderColumn eq $SortColumn ) {

            $CSS = $Self->{OrderBy} eq 'Up' ? 'SortAscendingLarge' : 'SortDescendingLarge';
        }

        my $HeaderColumnName = $AttributeHeader->{$HeaderColumn};

        my $Title = $LayoutObject->{LanguageObject}->Translate(
            $HeaderColumnName
        );

        # add surrounding container
        $LayoutObject->Block(
            Name => 'GeneralOverviewHeader',
        );

        $LayoutObject->Block(
            Name => 'ElasticSearchResultGenericHeaderColumn',
            Data => {
                HeaderColumnName     => $HeaderColumn || '',
                HeaderNameTranslated => $Title,
                CSS                  => $CSS || '',
            },
        );

        if ( $HeaderColumn eq $SortColumn ) {

            $LayoutObject->Block(
                Name => 'ElasticSearchResultGenericHeaderColumnLink',
                Data => {
                    %Param,
                    HeaderColumnName     => $HeaderColumn || '',
                    HeaderNameTranslated => $Title,
                    CSS                  => $CSS || '',
                    Name                 => $Self->{Name},
                    Title                => $Title,
                },
            );

            $LayoutObject->AddJSData(
                Key   => 'ColumnSortable' . $HeaderColumn . $WidgetName,
                Value => {
                    HeaderColumnName => $HeaderColumn,
                    Name             => $Self->{Name},
                    SortBy           => $Self->{SortBy} || $HeaderColumn,
                    OrderBy          => $Self->{OrderBy} eq "Up" ? "Down" : "Up",
                    SortingColumn    => $SortColumn,
                },
            );

        }
        else {
            $LayoutObject->Block(
                Name => 'ElasticSearchResultGenericHeaderColumnEmpty',
                Data => {
                    %Param,
                    HeaderNameTranslated => $Title,
                    HeaderColumnName     => $HeaderColumn,
                    CSS                  => $CSS,
                    Title                => $Title,
                },
            );
        }
    }

    return;
}

1;
