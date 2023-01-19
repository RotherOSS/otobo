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

package Kernel::Output::HTML::NavBar::AdminFavourites;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Unicode::Collate::Locale;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get process management configuration
    my $FrontendModuleConfig     = $ConfigObject->Get('Frontend::Module')->{Admin};
    my $FrontendNavigationConfig = $ConfigObject->Get('Frontend::Navigation')->{Admin};

    # check if the registration config is valid
    return if !IsHashRefWithData($FrontendModuleConfig);
    return if !IsHashRefWithData($FrontendNavigationConfig);
    return if !IsArrayRefWithData( $FrontendNavigationConfig->{'001-Framework'} );

    my $NameForID = $FrontendNavigationConfig->{'001-Framework'}->[0]->{Name};
    $NameForID =~ s/[ &;]//ig;

    # check if the module name is valid
    return if !$NameForID;

    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $PrefFavourites = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $UserPreferences{AdminNavigationBarFavourites},
    ) || [];

    my %Return = %{ $Param{NavBar}->{Sub} || {} };

    my @Favourites;
    MODULE:
    for my $Module ( sort @{$PrefFavourites} ) {
        my $ModuleConfig = $ConfigObject->Get('Frontend::NavigationModule')->{$Module};
        next MODULE if !$ModuleConfig;
        $ModuleConfig->{Link} //= "Action=$Module";
        push @Favourites, $ModuleConfig;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Create collator according to the user chosen language.
    my $Collator = Unicode::Collate::Locale->new(
        locale => $LayoutObject->{LanguageObject}->{UserLanguage},
    );

    @Favourites = sort {
        $Collator->cmp(
            $LayoutObject->{LanguageObject}->Translate( $a->{Name} ),
            $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
        )
    } @Favourites;

    if (@Favourites) {
        my $AdminModuleConfig = $ConfigObject->Get('Frontend::NavigationModule')->{Admin};
        $AdminModuleConfig->{Name} = $LayoutObject->{LanguageObject}->Translate('Overview');
        $AdminModuleConfig->{Link} //= "Action=Admin";
        unshift @Favourites, $AdminModuleConfig;
    }

    my $Counter = 0;
    for my $Favourite (@Favourites) {
        $Return{ $FrontendModuleConfig->{NavBarName} }->{$Counter} = $Favourite;
        $Counter++;
    }

    return ( Sub => \%Return );
}

1;
