# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::TicketOverviewMenu::Sort;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::Language',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed params
    for my $Needed (qw(Action UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SortConfiguration = $Kernel::OM->Get('Kernel::Config')->Get('TicketOverviewMenuSort')->{SortAttributes}
        || {
            Age   => 1,
            Title => 1,
        };

    if ( !IsHashRefWithData($SortConfiguration) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Wrong configuration 'TicketOverviewMenuSort###SortAttributes' for ticket"
                . " overview sort options.",
        );
        return;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @SortData;
    my $SelectedSortByOption;
    for my $CurrentSortByOption ( sort keys %{$SortConfiguration} ) {

        # add separator
        if (@SortData) {
            push @SortData, {
                Key      => '-',
                Value    => '-------------------------',
                Disabled => 1,
            };
        }

        my $TranslatedValue =
            $LayoutObject->{LanguageObject}->Translate('Order by') . ' "' .
            $LayoutObject->{LanguageObject}->Translate($CurrentSortByOption) . '"';

        for my $CurrentOrderBy (qw(Down Up)) {

            my $Selected = 0;
            if (
                $CurrentSortByOption eq $Param{SortBy}
                && $CurrentOrderBy eq $Param{OrderBy}
                )
            {
                $Selected             = 1;
                $SelectedSortByOption = 1;
            }

            my $OrderByTranslation = $CurrentOrderBy eq 'Down' ? 'ascending' : 'descending';
            $OrderByTranslation = $LayoutObject->{LanguageObject}->Translate($OrderByTranslation);

            push @SortData, {
                Key      => "$CurrentSortByOption|$CurrentOrderBy",
                Value    => "$TranslatedValue ($OrderByTranslation)",
                Selected => $Selected,
            };
        }

    }

    return if !@SortData;

    my %ReturnData;
    $ReturnData{HTML} = $LayoutObject->BuildSelection(
        Data  => \@SortData,
        Name  => 'SortBy',
        Title => $LayoutObject->{LanguageObject}->Translate('Order by'),
    );

    return if !$ReturnData{HTML};

    # build redirect param hash for Core.App.InternalRedirect
    my %RedirectParams;
    $RedirectParams{Action} = "\'$Self->{Action}\'";
    for my $PossibleParam (qw(Filter)) {
        if ( $Param{$PossibleParam} ) {
            $RedirectParams{$PossibleParam} = "\'$Param{ $PossibleParam }\'";
        }
    }

    if ( $Param{LinkFilter} ) {
        my @SplittedLinkFilters = split( /[;&]/, $Param{LinkFilter} );
        for my $CurrentLinkFilter ( sort @SplittedLinkFilters ) {
            my @KeyValue = split( /=/, $CurrentLinkFilter );
            if ( defined $KeyValue[1] ) {
                $RedirectParams{ $KeyValue[0] } = "\'$KeyValue[1]\'";
            }
        }
    }

    $RedirectParams{SortBy}  = 'Selection[0]';
    $RedirectParams{OrderBy} = 'Selection[1]';

    my $RedirectParamsString = '';
    my $ParamLength          = scalar keys %RedirectParams;
    my $ParamCounter         = 0;
    for my $ParamKey ( sort keys %RedirectParams ) {
        $ParamCounter++;
        $RedirectParamsString .= "$ParamKey: $RedirectParams{$ParamKey}";

        # prevent comma after last element for correct functionality in IE
        if ( $ParamCounter < $ParamLength ) {
            $RedirectParamsString .= ",\n";
        }
        else {
            $RedirectParamsString .= "\n";
        }
    }

    $LayoutObject->AddJSOnDocumentComplete( Code => <<"JS" );
\$("#SortBy").change(function(){
    var Selection = \$(this).val().split('|');
    if ( Selection.length === 2 ) {
        Core.App.InternalRedirect({
            ${RedirectParamsString}
        });
    }
});
JS

    $ReturnData{HTML} = '<li class="AlwaysPresent SortBy">'
        . $ReturnData{HTML}
        . '</li>';

    $ReturnData{Block} = 'DocumentActionRowHTML';

    return \%ReturnData;
}

1;
