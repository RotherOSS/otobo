# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::Output::HTML::ToolBar::TicketSearchProfile;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::SearchProfile'
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get user data
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Self->{UserID},
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create search profiles string
    my $ProfilesStrg = $LayoutObject->BuildSelection(
        Data => {
            '', '-',
            $Kernel::OM->Get('Kernel::System::SearchProfile')->SearchProfileList(
                Base      => 'TicketSearch',
                UserLogin => $User{UserLogin},
            ),
        },
        Name       => 'Profile',
        ID         => 'ToolBarSearchProfile',
        Title      => $LayoutObject->{LanguageObject}->Translate('Search template'),
        SelectedID => '',
        Max        => $Param{Config}->{MaxWidth},
        Class      => 'Modernize',
    );

    my $Priority = $Param{Config}->{'Priority'};
    my %Return   = ();
    $Return{ $Priority++ } = {
        Block       => $Param{Config}->{Block},
        Description => $Param{Config}->{Description},
        Name        => $Param{Config}->{Name},
        Image       => '',
        Link        => $ProfilesStrg,
        AccessKey   => '',
    };
    return %Return;
}

1;
