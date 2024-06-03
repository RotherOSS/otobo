# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::Language::de_oooCustomer;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Login
    $Self->{Translation}->{'Your Tickets. Your OTOBO.'} = 'Deine Tickets. Dein OTOBO.';

    # Dashboard
    $Self->{Translation}->{'# FAQ Article № 1'}                                  = '# FAQ Artikel № 1';
    $Self->{Translation}->{'List of features coming with the OTOBO beta version.'} = 'Liste der Features, die in der OTOBO beta Version enthalten sein werden.';
    $Self->{Translation}->{'Show >'}                                               = 'Anzeigen >';
    $Self->{Translation}->{'Message of the day'}                                   = 'Aktuelle Informationen';
    $Self->{Translation}->{'Welcome %s, to your OTOBO.'}                           = 'Willkommen %s, in Deinem OTOBO.';
    $Self->{Translation}->{'Have fun exploring this preliminary version of the OTOBO customer interface!'}
        = 'Viel Spaß beim Ansehen dieser im Aufbau befindlichen Kundenansicht von OTOBO!';
    $Self->{Translation}->{'Your last tickets'}   = 'Deine letzten Tickets';
    $Self->{Translation}->{'Your external tools'} = 'Externe Tools';

    return;

}

1;
