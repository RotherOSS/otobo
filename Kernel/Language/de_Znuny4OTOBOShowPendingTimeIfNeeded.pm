# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Language::de_Znuny4OTOBOShowPendingTimeIfNeeded;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.'} = 'Diese Konfiguration registriert ein Outputfilter, um die Erinnerungszeit via Javascript auszublenden.';
    $Self->{Translation}->{'List of JS files to always be loaded for the agent interface.'} = 'Liste von JS-Dateien, die immer für den Agenten-Interfaace geladen werden.';

    return 1;
}

1;
