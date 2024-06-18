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

package Kernel::Language::hu_WebserviceTicketInvoker;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminGenericInterfaceInvokerTicket
    $Self->{Translation}->{'General invoker data'} = 'Általános meghívó adatok';
    $Self->{Translation}->{'Settings for outgoing request data'} = 'Beállítások a kimenő kérés adataihoz';
    $Self->{Translation}->{'Only the selected ticket fields will be considered for the request data.'} =
        'Csak a kijelölt jegymezők lesznek figyelembe véve a kérés adatainál.';
    $Self->{Translation}->{'Article fields'} = 'Bejegyzés mezői';
    $Self->{Translation}->{'Only the selected article fields will be considered for the request data.'} =
        'Csak a kijelölt bejegyzésmezők lesznek figyelembe véve a kérés adatainál.';
    $Self->{Translation}->{'Ticket dynamic fields'} = 'Jegy dinamikus mezők';
    $Self->{Translation}->{'Only the selected ticket dynamic fields will be considered for the request data.'} =
        'Csak a kijelölt jegy dinamikus mezők lesznek figyelembe véve a kérés adatainál.';
    $Self->{Translation}->{'Article dynamic fields'} = 'Bejegyzés dinamikus mezők';
    $Self->{Translation}->{'Only the selected article dynamic fields will be considered for the request data.'} =
        'Csak a kijelölt bejegyzés dinamikus mezők lesznek figyelembe véve a kérés adatainál.';
    $Self->{Translation}->{'Number of articles'} = 'Bejegyzések száma';
    $Self->{Translation}->{'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.'} =
        'A kimenő kérés adatai csak a beállított számú bejegyzést fogják tartalmazni. Ha üresen van hagyva, akkor csak 1 bejegyzés lesz elküldve.';
    $Self->{Translation}->{'Communication channels'} = 'Kommunikációs csatornák';
    $Self->{Translation}->{'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.'} =
        'A kimenő kérés adatai csak a kijelölt kommunikációs csatornák bejegyzéseit fogja figyelembe venni. Ha üresen van hagyva, akkor az összes kommunikációs csatorna által létrehozott bejegyzés használva lesz.';
    $Self->{Translation}->{'The outgoing request data will only consider articles created with the selected customer visibility.'} =
        'A kimenő kérés adatai csak a kijelölt ügyfélláthatósággal létrehozott bejegyzéseket fogja figyelembe venni.';
    $Self->{Translation}->{'Sender Types'} = 'Küldőtípusok';
    $Self->{Translation}->{'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.'} =
        'A kimenő kérés adatai csak a kijelölt küldőtípusok által létrehozott bejegyzéseket fogja figyelembe venni. Ha üresen van hagyva, akkor az összes küldőtípus által létrehozott bejegyzés használva lesz.';
    $Self->{Translation}->{'Mapping'} = 'Leképezés';
    $Self->{Translation}->{'Settings for incoming response data'} = 'Beállítások a bejövő válasz adataihoz';
    $Self->{Translation}->{'Remote TicketID dynamic field'} = 'Távoli jegyazonosító dinamikus mező';
    $Self->{Translation}->{'The selected ticket dynamic field is being used to store the remote TicketID.'} =
        'A kijelölt jegy dinamikus mező lesz használva a távoli jegyazonosító tárolásához.';
    $Self->{Translation}->{'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.'} =
        'Ha üresen van hagyva, akkor a távoli jegyazonosító nem lesz eltárolva, hacsak nem határoz meg egy rendszerbeállítási értéket ehhez a webszolgáltatáshoz.';
    $Self->{Translation}->{'The selected field is already in use by the Ticket dynamic fields option.'} =
        'A kijelölt mezőt már használja a jegy dinamikus mező beállítás.';
    $Self->{Translation}->{'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.'} =
        'Csak a kijelölt jegy dinamikus mezők lesznek figyelembe véve a bejövő válasz adatainak feldolgozásához. Ha üresen van hagyva, akkor nem lesz dinamikus mező feldolgozva.';
    $Self->{Translation}->{'Event data'} = 'Eseményadatok';

    # Template: AdminGenericInterfaceTransportHTTPREST
    $Self->{Translation}->{'Additional request headers (all invokers)'} = 'További kérésfejlécek (összes meghívó)';
    $Self->{Translation}->{'Additional request headers (invoker specific)'} = 'További kérésfejlécek (meghívóra jellemző)';
    $Self->{Translation}->{'Remove all headers for this invoker'} = 'Az összes fejléc eltávolítása ennél a meghívónál';
    $Self->{Translation}->{'Headers for invoker'} = 'Fejlécek a meghívóhoz';
    $Self->{Translation}->{'Additional response headers (all operations)'} = 'További válaszfejlécek (összes művelet)';
    $Self->{Translation}->{'Additional response headers (operation specific)'} = 'További válaszfejlécek (műveletre jellemző)';
    $Self->{Translation}->{'Remove all headers for this operation'} = 'Az összes fejléc eltávolítása ennél a műveletnél';
    $Self->{Translation}->{'Headers for operation'} = 'Fejlécek a művelethez';
    $Self->{Translation}->{'Common headers'} = 'Közös fejlécek';
    $Self->{Translation}->{'Header Name'} = 'Fejléc neve';
    $Self->{Translation}->{'Remove header'} = 'Fejléc eltávolítása';
    $Self->{Translation}->{'Add header'} = 'Fejléc hozzáadása';

    # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
    $Self->{Translation}->{'This key is already used'} = 'Ez a kulcs már használatban van';
    $Self->{Translation}->{'This key is not allowed'} = 'Ez a kulcs nem engedélyezett';

    # SysConfig
    $Self->{Translation}->{'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).'} =
        'Bejegyzés-attribútumok, amelyeknek elérhetőnek kell lenniük a jegymeghívó beállítási előtétprogramján (0 = látható/kiválasztható, 1 = alapértelmezett/előre kiválasztott).';
    $Self->{Translation}->{'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).'} =
        'Egy eredménymező meghatározása a meghívó válaszának jegyazonosítójához webszolgáltatásonként (WebszolgáltatásAzonosító => DinamikusMezőNév).';
    $Self->{Translation}->{'GenericInterface module registration for the TicketCreate invoker layer.'} =
        'Általános felület modul regisztráció a TicketCreate meghívóréteghez.';
    $Self->{Translation}->{'GenericInterface module registration for the TicketUpdate invoker layer.'} =
        'Általános felület modul regisztráció a TicketUpdate meghívóréteghez.';
    $Self->{Translation}->{'Outbound request headers not allowed to be used in frontend configuration.'} =
        'Kimenő kérésfejlécek, amelyek nem engedélyezettek az előtétprogram beállításában való használathoz.';
    $Self->{Translation}->{'Outbound response headers not allowed to be used in frontend configuration.'} =
        'Kimenő válaszfejlécek, amelyek nem engedélyezettek az előtétprogram beállításában való használathoz.';
    $Self->{Translation}->{'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).'} =
        'Jegyattribútumok, amelyeknek elérhetőnek kell lenniük a jegymeghívó beállítási előtétprogramján (0 = látható/kiválasztható, 1 = alapértelmezett/előre kiválasztott).';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Add Event Trigger',
    'An error occurred during communication.',
    'Cancel',
    'Delete',
    'Delete this Event Trigger',
    'Delete this Invoker',
    'It is not possible to add a new event trigger because the event is not set.',
    );

}

1;
