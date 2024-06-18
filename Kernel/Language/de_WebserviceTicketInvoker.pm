# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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


package Kernel::Language::de_WebserviceTicketInvoker;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminGenericInterfaceInvokerTicket
    $Self->{Translation}->{'General invoker data'} = 'Allgemeine Invoker-Daten';
    $Self->{Translation}->{'Settings for outgoing request data'} = 'Einstellungen für ausgehende Anfragedaten';
    $Self->{Translation}->{'Only the selected ticket fields will be considered for the request data.'} =
        'Nur die ausgewählten Ticket-Felder werden für die Anfragedaten verwendet.';
    $Self->{Translation}->{'Article fields'} = 'Artikel-Felder';
    $Self->{Translation}->{'Only the selected article fields will be considered for the request data.'} =
        'Nur die ausgewählten Artikel-Felder werden für die Anfragedaten verwendet.';
    $Self->{Translation}->{'Ticket dynamic fields'} = 'Dynamische Ticket-Felder';
    $Self->{Translation}->{'Only the selected ticket dynamic fields will be considered for the request data.'} =
        'Nur die ausgewählten dynamischen Ticket-Felder werden für die Anfragedaten verwendet.';
    $Self->{Translation}->{'Article dynamic fields'} = 'Dynamische Artikel-Felder';
    $Self->{Translation}->{'Only the selected article dynamic fields will be considered for the request data.'} =
        'Nur die ausgewählten dynamischen Artikel-Felder werden für die Anfragedaten verwendet.';
    $Self->{Translation}->{'Number of articles'} = 'Anzahl an Artikeln';
    $Self->{Translation}->{'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.'} =
        'Die ausgehenden Anfragedaten beinhalten nur die konfigurierte Anzahl an Artikeln. Es wird nur ein Artikel versendet, sofern die Auswahl leer gelassen wird.';
    $Self->{Translation}->{'Communication channels'} = 'Kommunikationskanäle';
    $Self->{Translation}->{'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.'} =
        'Die Daten der ausgehenden Anfrage berücksichtigen nur Artikel der ausgewählten Kommunikationskanäle. Wenn leer gelassen, werden Artikel verwendet, die von allen Kommunikationskanälen erstellt wurden.';
    $Self->{Translation}->{'The outgoing request data will only consider articles created with the selected customer visibility.'} =
        'Die Daten der ausgehenden Anforderung berücksichtigen nur Artikel, die mit der ausgewählten Sichtbarkeit für Kundensicht erstellt wurden.';
    $Self->{Translation}->{'Sender Types'} = 'Sendertypen';
    $Self->{Translation}->{'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.'} =
        'Die ausgehenden Anfragedaten berücksichtigen nur Artikel, die von den ausgewählten Sendertypen angelegt wurden. Wenn leer gelassen, werden Artikel verwendet, die von allen Sendertypen angelegt wurden.';
    $Self->{Translation}->{'Mapping'} = 'Mapping';
    $Self->{Translation}->{'Settings for incoming response data'} = 'Einstellungen für eingehende Antwortdaten';
    $Self->{Translation}->{'Remote TicketID dynamic field'} = 'Dynamisches Feld für die entfernte TicketID';
    $Self->{Translation}->{'The selected ticket dynamic field is being used to store the remote TicketID.'} =
        'Das ausgewählte dynamische Ticket-Feld wird genutzt, um die entfernte TicketID zu speichern.';
    $Self->{Translation}->{'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.'} =
        'Ohne dass ein entsprechender SysConfig-Wert für diesen Webservice definiert wurde, wird die entfernte TicketID nicht gespeichert, sofern die Auswahl leer gelassen wird.';
    $Self->{Translation}->{'The selected field is already in use by the Ticket dynamic fields option.'} =
        'Das ausgewählte Dynamische Feld wird bereits von der Option Dynamische Ticket-Felder genutzt.';
    $Self->{Translation}->{'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.'} =
        'Nur die ausgewählten dynamischen Ticket-Felder werden für die Verarbeitung der eingehenden Antwortdaten verwendet. Es wird kein dynamisches Feld verwendet, sofern die Auswahl leer gelassen wird.';
    $Self->{Translation}->{'Event data'} = 'Ereignisdaten';

    # Template: AdminGenericInterfaceTransportHTTPREST
    $Self->{Translation}->{'Additional request headers (all invokers)'} = 'Zusätzliche Anfrage-Header (alle Invoker)';
    $Self->{Translation}->{'Additional request headers (invoker specific)'} = 'Zusätzliche Anfrage-Header (Invoker-spezifisch)';
    $Self->{Translation}->{'Remove all headers for this invoker'} = 'Entferne alle Header für diesen Invoker';
    $Self->{Translation}->{'Headers for invoker'} = 'Header für Invoker';
    $Self->{Translation}->{'Additional response headers (all operations)'} = 'Zusätzliche Antwort-Header (alle Operationen)';
    $Self->{Translation}->{'Additional response headers (operation specific)'} = 'Zusätzliche Antwort-Header (Operation-spezifisch)';
    $Self->{Translation}->{'Remove all headers for this operation'} = 'Entferne alle Header für diese Operation';
    $Self->{Translation}->{'Headers for operation'} = 'Header für Operation';
    $Self->{Translation}->{'Common headers'} = 'Allgemeine Header';
    $Self->{Translation}->{'Header Name'} = 'Header-Name';
    $Self->{Translation}->{'Remove header'} = 'Entferne Header';
    $Self->{Translation}->{'Add header'} = 'Header hinzufügen';

    # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
    $Self->{Translation}->{'This key is already used'} = 'Dieser Schlüssel wird bereits genutzt';
    $Self->{Translation}->{'This key is not allowed'} = 'Dieser Schlüssel ist nicht erlaubt';

    # SysConfig
    $Self->{Translation}->{'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).'} =
        'Artikel-Attribute welche in der Ticket-Invoker Konfigurationsmaske verfügbar sein sollen (0 = sichtbar/auswählber, 1 = standard/vorausgewählt).';
    $Self->{Translation}->{'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).'} =
        'Definiert ein dynamisches Feld für das Ergebnis der Invoker-Antworten pro Webservice (WebserviceID => DynamicFieldName).';
    $Self->{Translation}->{'GenericInterface module registration for the TicketCreate invoker layer.'} =
        'GenericInterface-Modulregistrierung für den TicketCreate Invoker Layer.';
    $Self->{Translation}->{'GenericInterface module registration for the TicketUpdate invoker layer.'} =
        'GenericInterface-Modulregistrierung für den TicketUpdate Invoker Layer.';
    $Self->{Translation}->{'Outbound request headers not allowed to be used in frontend configuration.'} =
        'Ausgehende Anfrage-Header welche nicht innerhalb der Frontend-Konfiguration erlaubt sind.';
    $Self->{Translation}->{'Outbound response headers not allowed to be used in frontend configuration.'} =
        'Ausgehende Antwort-Header welche nicht innerhalb der Frontend-Konfiguration erlaubt sind.';
    $Self->{Translation}->{'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).'} =
        'Ticket-Attribute welche in der Ticket-Invoker Konfigurationsmaske verfügbar sein sollen (0 = sichtbar/auswählber, 1 = standard/vorausgewählt).';


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
