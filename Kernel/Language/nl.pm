# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# Copyright (C) 2010 Ton van Boven <ton 'at' avebo.nl>
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::Language::nl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D-%M-%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D-%M-%Y';
    $Self->{DateInputFormat}     = '%D-%M-%Y';
    $Self->{DateInputFormatLong} = '%D-%M-%Y - %T';
    $Self->{Completeness}        = 0.666666666666667;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL beheer',
        'Actions' => 'Acties',
        'Create New ACL' => 'Nieuwe ACL aanmaken',
        'Deploy ACLs' => 'ACLs activeren',
        'Export ACLs' => 'Exporteer ACLs',
        'Filter for ACLs' => 'Filter op ACLs',
        'Just start typing to filter...' => 'Start met typen om te filteren',
        'Configuration Import' => 'Configuratie importeren',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hier kunt u een configuratiebestand met ACLs importeren in uw systeem. Het bestand moet in .yml formaat zijn, zoals geexporteerd door de ACL module.',
        'This field is required.' => 'Dit veld is verplicht.',
        'Overwrite existing ACLs?' => 'Overschrijf bestaande ACLs?',
        'Upload ACL configuration' => 'ACL-configuratie uploaden?',
        'Import ACL configuration(s)' => 'Importeer ACL-configuratie',
        'Description' => 'Omschrijving',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Om nieuwe ACLs aan te maken kunt u deze importeren vanuit een bestand of een compleet nieuwe aanmaken.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Wijzigingen aan de ACLs worden pas actief als u de ACLs activeert. Door ',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Let op: deze tabel toont de volgorde waarin de ALCs worden toegepast. Als u de volgorde waarin deze worden uitgevoerd moet aanpassen, verander dan de namen van de ACLs.',
        'ACL name' => 'ACL-naam',
        'Comment' => 'Opmerking',
        'Validity' => 'Geldigheid',
        'Export' => 'Exporteer',
        'Copy' => 'Kopiëer',
        'No data found.' => 'Geen gegevens gevonden.',
        'No matches found.' => 'Niets gevonden.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Bewerk ACL %s',
        'Edit ACL' => 'Bewerkt ACL',
        'Go to overview' => 'Naar het overzicht',
        'Delete ACL' => 'Verwijder ACL',
        'Delete Invalid ACL' => 'Verwijder ongeldige ACL',
        'Match settings' => 'Activatie-criteria',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Stel activatie-criteria in voor deze ACL. Gebruik \'Attributen\' om de huidige waarden te gebruiken of \'DatabaseAttributen\' om de waarden uit de database voor het huidige ticket te gebruiken.',
        'Change settings' => 'Verander instellingen',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Geef aan wat u wilt dat gebeurt als de activatie-criteria kloppen.',
        'Check the official %sdocumentation%s.' => 'Bekijk de officiële %sdocumentatie%s',
        'Show or hide the content' => 'Toon of verberg de inhoud',
        'Edit ACL Information' => 'Bewerk ACL-informatie',
        'Name' => 'Naam',
        'Stop after match' => 'Stop met filters na match',
        'Edit ACL Structure' => 'Bewerk ACL-structuur',
        'Save ACL' => 'ACL Opslaan',
        'Save' => 'Opslaan',
        'or' => 'of',
        'Save and finish' => 'Opslaan en voltooien',
        'Cancel' => 'Annuleren',
        'Do you really want to delete this ACL?' => 'Wilt u deze ACL verwijderen?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Maak een nieuwe ACL aan. Na het aanmaken kunt u de eigenschappen aanpassen door deze te bewerken.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Kalender beheer',
        'Add Calendar' => 'Kalender toevoegen',
        'Edit Calendar' => 'Kalender bewerken',
        'Calendar Overview' => 'Kalender overzicht',
        'Add new Calendar' => 'Nieuwe kalender toevoegen',
        'Import Appointments' => 'Afspraken importeren',
        'Calendar Import' => 'Kalender import',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Hier kunt u een configuratiebestand uploaden om een ​​kalender naar uw systeem te importeren. Het bestand moet in .yml-indeling zijn zoals geëxporteerd door de kalenderbeheermodule.',
        'Overwrite existing entities' => 'Overschrijf bestaande records',
        'Upload calendar configuration' => 'Upload kalender configuratie',
        'Import Calendar' => 'Importeer kalender',
        'Filter for Calendars' => 'Filter voor kalenders',
        'Filter for calendars' => 'Filter voor kalenders',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Afhankelijk van het groepsveld geeft het systeem gebruikers toegang tot de kalender op basis van hun machtigingsniveau.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Alleen lezen: gebruikers kunnen alle afspraken in deze kalender raadplegen en exporteren.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Verplaats naar: Gebruikers kunnen afspraken in de agenda wijzigen, maar zonder de kalender te wijzigen.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Maken: gebruikers kunnen afspraken maken en verwijderen in de kalender',
        'Read/write: users can manage the calendar itself.' => 'Lezen/Schrijven: gebruikers kunnen de kalender beheren',
        'Group' => 'Groep',
        'Changed' => 'Gewijzigd',
        'Created' => 'Aangemaakt',
        'Download' => 'Downloaden',
        'URL' => 'URL',
        'Export calendar' => 'Exporteer kalender',
        'Download calendar' => 'Download kalender',
        'Copy public calendar URL' => 'Kopieer publieke kalender URL',
        'Calendar' => 'Kalender',
        'Calendar name' => 'Kalender naam',
        'Calendar with same name already exists.' => 'Er bestaat al een kalender met deze naam.',
        'Color' => 'Kleur',
        'Permission group' => 'Permissie groep',
        'Ticket Appointments' => 'Ticket afspraken',
        'Rule' => 'Regel',
        'Remove this entry' => 'Verwijder deze sleutel',
        'Remove' => 'Verwijderen',
        'Start date' => 'Begindatum',
        'End date' => 'Einddatum',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Gebruik de opties hieronder om te beperken voor welke tickets er automatisch afspraken worden aangemaakt.',
        'Queues' => 'Wachtrijen',
        'Please select a valid queue.' => 'Selecteer een geldige wachtrij.',
        'Search attributes' => 'Zoekeigenschappen',
        'Add entry' => 'Sleutel toevoegen',
        'Add' => 'Toevoegen',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definieer regels voor het automatisch aanmaken van afspraken in deze kalender, gebaseerd op gegevens van het ticket',
        'Add Rule' => 'Regel toevoegen',
        'Submit' => 'Versturen',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Afspraak importeren',
        'Go back' => 'Ga terug',
        'Uploaded file must be in valid iCal format (.ics).' => 'Opgeladen bestanden moeten een geldige iCal indeling hebben (.ics)',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Als de gewenste kalender hier niet zichtbaar is, controleer dan of je ten minste \'create\' rechten hebt.',
        'Upload' => 'Upload',
        'Update existing appointments?' => 'Bestaande afspraken bijwerken?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Alle bestaande afspraken in de kalender met dezelfde UniqueID zullen overschreven worden.',
        'Upload calendar' => 'Upload kalender',
        'Import appointments' => 'Afspraken importeren',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Meldingen voor afspraken beheren',
        'Add Notification' => 'Melding toevoegen',
        'Edit Notification' => 'Bewerk melding',
        'Export Notifications' => 'Meldingen exporteren',
        'Filter for Notifications' => 'Filter voor notificaties',
        'Filter for notifications' => 'Filter voor notificaties',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Hier kun je configuratiebestanden uploaden om Afspraak Notificaties te importeren. Het bestand moet in .yml formaat zoals geëxporteerd door de notificatie module.',
        'Overwrite existing notifications?' => 'Bestaande meldingen overschrijven?',
        'Upload Notification configuration' => 'Upload meldingconfiguratie',
        'Import Notification configuration' => 'Melding configuratie importeren',
        'List' => 'Overzicht',
        'Delete' => 'Verwijderen',
        'Delete this notification' => 'Melding verwijderen',
        'Show in agent preferences' => 'Tonen bij voorkeuren Agent',
        'Agent preferences tooltip' => 'Agent voorkeuren tooltip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Dit bericht wordt getoond op de agent voorkeuren pagina als een tooltip voor deze notificatie.',
        'Toggle this widget' => 'Klap in/uit',
        'Events' => 'Gebeurtenissen',
        'Event' => 'Gebeurtenis',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Hier kun je kiezen welke gebeurtenissen deze notificatie inschakelen. Een extra ticket filter kan worden toegepast om de notificatie alleen te versturen als het ticket voldoet aan bepaalde criteria.',
        'Appointment Filter' => 'Filter afspraken',
        'Type' => 'Type',
        'Title' => 'Titel',
        'Location' => 'Locatie',
        'Team' => 'Team',
        'Resource' => 'Middel',
        'Recipients' => 'Ontvangers',
        'Send to' => 'Versturen naar',
        'Send to these agents' => 'Verstuur naar deze gebruikers',
        'Send to all group members (agents only)' => 'Verstuur naar alle groepsleden (alleen behandelaars)',
        'Send to all role members' => 'Verstuur naar alle leden van een rol',
        'Send on out of office' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Also send if the user is currently out of office.' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Once per day' => 'Eén keer per dag',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => 'Meldingsmethoden',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Dit zijn de mogelijke manieren die kunnen worden gebruikt om meldingen te versturen naar elke ontvanger. Selecteer minimaal één methode.',
        'Enable this notification method' => 'Zet deze meldingen methode aan',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Op zijn minst één methode is vereist per melding.',
        'Active by default in agent preferences' => 'Standaard actief in agent voorkeuren',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Dit is de standaard waarde voor toegewezen ontvangers die geen keuze hebben gemaakt voor deze melding in hun voorkeuren. Als deze waarde is aangevinkt, wordt het bericht naar deze behandelaars gestuurd.',
        'This feature is currently not available.' => 'Deze feature is niet beschikbaar op het moment.',
        'Upgrade to %s' => 'Upgrade naar %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'Geen data gevonden',
        'No notification method found.' => 'Geen meldingen methoden gevonden',
        'Notification Text' => 'Meldingstekst',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Deze taal is niet aanwezig of ingeschakeld in het systeem. Deze meldingstekst kan verwijderd worden wanneer deze niet meer nodig is.',
        'Remove Notification Language' => 'Verwijder de taal voor de meldingen',
        'Subject' => 'Onderwerp',
        'Text' => 'Tekst',
        'Message body' => 'Berichttekst',
        'Add new notification language' => 'Voeg nieuwe taal voor meldingen toe',
        'Save Changes' => 'Wijzigingen opslaan',
        'Tag Reference' => 'Tag verwijzing',
        'Notifications are sent to an agent.' => 'Meldingen zijn verzonden naar de behandelaar.',
        'You can use the following tags' => 'U kunt de volgende tags gebruiken',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => 'Om de afspraak eigenschap te krijgen',
        ' e. g.' => ' bijv.',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => 'Eigenschappen van de ontvanger voor deze melding',
        'Config options' => 'Attributen van de configuratie',
        'Example notification' => 'Voorbeeld van de melding',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Aanvullende ontvanger e-mailadres',
        'This field must have less then 200 characters.' => 'Dit veld mag maximaal 200 karakters bevatten',
        'Article visible for customer' => 'Article zichtbaar voor klant',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Wanneer de melding wordt verstuurd naar de klant of een extra e-mail adres, wordt een artikel aangemaakt.',
        'Email template' => 'Email sjabloon',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Gebruik deze template om de complete mail te genereren (alleen voor HTML email).',
        'Enable email security' => 'Email beveiliging inschakelen',
        'Email security level' => 'Niveau van email beveiliging',
        'If signing key/certificate is missing' => 'Als signeer sleutel/certificaat ontbreekt',
        'If encryption key/certificate is missing' => 'Als encryptie sleutel/certificaat ontbreekt',

        # Template: AdminAttachment
        'Attachment Management' => 'Beheer bijlagen',
        'Add Attachment' => 'Nieuwe bijlage',
        'Edit Attachment' => 'Bijlage bewerken',
        'Filter for Attachments' => 'Filter op bijlagen',
        'Filter for attachments' => 'Filter op bijlagen',
        'Filename' => 'Bestandsnaam',
        'Download file' => 'Download bijlage',
        'Delete this attachment' => 'Verwijder bijlage',
        'Do you really want to delete this attachment?' => 'Ben je zeker dat je deze bijlage wil verwijderen?',
        'Attachment' => 'Bijlage',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Beheer automatische antwoorden',
        'Add Auto Response' => 'Nieuw automatisch antwoord',
        'Edit Auto Response' => 'Bewerk automatisch antwoord',
        'Filter for Auto Responses' => 'Filter op automatische antwoorden',
        'Filter for auto responses' => 'Filter op automatische antwoorden',
        'Response' => 'Antwoord',
        'Auto response from' => 'Automatisch antwoord van',
        'Reference' => 'Referentie',
        'To get the first 20 character of the subject.' => 'Voor de eerste 20 tekens van het onderwerp.',
        'To get the first 5 lines of the email.' => 'Voor de eerste vijf regels van het e-mail bericht.',
        'To get the name of the ticket\'s customer user (if given).' => 'Om de naam van de klant te verkrijgen (indien gegeven)',
        'To get the article attribute' => 'Voor de attributen van de interactie',
        'Options of the current customer user data' => 'Attributen van de huidige klant',
        'Ticket owner options' => 'Attributen van de ticket eigenaar',
        'Ticket responsible options' => 'Attributen van de verantwoordelijke',
        'Options of the current user who requested this action' => 'Attributen van de huidige gebruiker',
        'Options of the ticket data' => 'Attributen van het ticket',
        'Options of ticket dynamic fields internal key values' => 'Attributen van dynamische velden, interne waarden',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Waarden van dynamische velden, voor Dropdown en Multiselect velden',
        'Example response' => 'Voorbeeld',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud Service Beheer',
        'Support Data Collector' => 'Verzamelaar van supportgegevens',
        'Support data collector' => 'Verzamelaar van supportgegevens',
        'Hint' => 'Opmerking',
        'Currently support data is only shown in this system.' => 'Momenteel worden enkel ondersteuningsgegevens getoond in dit systeem.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Configuratie',
        'Send support data' => 'Ondersteuningsgegevens versturen',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Opslaan',
        'System Registration' => 'Systeemregistratie',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Registreer dit Systeem',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Systeemregistratie is uitgeschakeld voor uw systeem. Gelieve uw configuratie na te kijken.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Houd er rekening mee dat wanneer u gebruik wilt maken van de OTOBO cloud diensten uw systeem geregistreerd moet zijn.',
        'Register this system' => 'Registreer dit systeem',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Hier kan u beschikbare Cloud diensten configureren die beveiligd communiceren met %s.',
        'Available Cloud Services' => 'Beschikbare Cloud Diensten',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Communicatielogboek',
        'Time Range' => 'Bereik van tijd',
        'Show only communication logs created in specific time range.' =>
            'Toon alleen communicatielogboeken gemaakt binnen een bepaald tijdbereik.',
        'Filter for Communications' => 'Filter op communicatie',
        'Filter for communications' => 'Filter op communicatie',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Op dit scherm ziet u een overzicht van de binnenkomende en uitgaande communicatie.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'U kunt de sortering en volgorde van de kolommen wijzigen door op de kolomkop te klikken.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Als u op de verschillende items klikt, wordt u omgeleid naar een gedetailleerd scherm over het bericht.',
        'Status for: %s' => 'Status van: %s',
        'Failing accounts' => 'Probleemaccount',
        'Some account problems' => 'Bepaalde account problemen',
        'No account problems' => 'Geen account probleem',
        'No account activity' => 'Geen activiteit van account',
        'Number of accounts with problems: %s' => 'Aantal accounts met problemen: %s',
        'Number of accounts with warnings: %s' => 'Aantal account met waarschuwingen: %s',
        'Failing communications' => 'Falende communicatie',
        'No communication problems' => 'Geen communicatie problemen',
        'No communication logs' => 'Geen communicatielogboek',
        'Number of reported problems: %s' => 'Aantal met gemelde problemen: %s',
        'Open communications' => 'Open communicaties',
        'No active communications' => 'Geen actieve communicatie',
        'Number of open communications: %s' => 'Aantal actieve communicatie: %s',
        'Average processing time' => 'Gemiddelde verwerkingstijd',
        'List of communications (%s)' => 'Lijst met communicatie (%s)',
        'Settings' => 'Instellingen',
        'Entries per page' => 'Items per pagina',
        'No communications found.' => 'Geen communicatie gevonden.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Accountstatus',
        'Back to overview' => 'Terug naar het overzicht',
        'Filter for Accounts' => 'Account filter',
        'Filter for accounts' => 'Filter op accounts',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'U kunt de sortering en volgorde van de kolommen wijzigen door op de kolomkop te klikken.',
        'Account status for: %s' => 'Accountstatus voor: %s',
        'Status' => 'Status',
        'Account' => 'Account',
        'Edit' => 'Wijzig',
        'No accounts found.' => 'Geen accounts gevonden.',
        'Communication Log Details (%s)' => 'Communicatielogboek gegevens (%s)',
        'Direction' => 'Richting',
        'Start Time' => 'Begintijd',
        'End Time' => 'Eindtijd',
        'No communication log entries found.' => 'Geen communicatielogboekitems gevonden',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Tijdsduur',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioriteit',
        'Module' => 'Module',
        'Information' => 'Informatie',
        'No log entries found.' => 'Geen logvermeldingen gevonden',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Detailweergave voor %s communicatie gestart om %s',
        'Filter for Log Entries' => 'Filter op logitems',
        'Filter for log entries' => 'Filter op logitems',
        'Show only entries with specific priority and higher:' => 'Toon enkel items met deze prioriteit, of hoger',
        'Communication Log Overview (%s)' => 'Communicatielogboek overzicht (%s)',
        'No communication objects found.' => 'Geen communicatie objecten gevonden.',
        'Communication Log Details' => 'Communicatielogboek details',
        'Please select an entry from the list.' => 'Selecteer een item uit de lijst.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Contact met gegevens',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Terug naar zoekresultaat',
        'Select' => 'Selecteer',
        'Search' => 'Zoeken',
        'Wildcards like \'*\' are allowed.' => 'Wildcards zijn toegestaan.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Geldigheid',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Beheer bedrijven',
        'Add Customer' => 'Klant toevoegen',
        'Edit Customer' => 'Klant bewerken',
        'List (only %s shown - more available)' => 'Lijst (slechts %s getoond - meer beschikbaar)',
        'total' => 'totaal',
        'Please enter a search term to look for customers.' => 'Typ om te zoeken naar klanten.',
        'Customer ID' => 'Klantcode',
        'Please note' => 'Let op',
        'This customer backend is read only!' => 'Deze klanten backend is niet te wijzigen!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Beheer Bedrijf - Groep koppelingen',
        'Notice' => 'Notitie',
        'This feature is disabled!' => 'Deze functie is niet geactiveerd.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Gebuik deze mogelijkheid alleen als u groep-permissies voor klanten wilt gebruiken.',
        'Enable it here!' => 'Inschakelen',
        'Edit Customer Default Groups' => 'Bewerk standaard groepen voor klanten',
        'These groups are automatically assigned to all customers.' => 'Deze groepen worden toegewezen aan alle klanten.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filter op groepen',
        'Select the customer:group permissions.' => 'Selecteer de permissies voor bedrijf:groep.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (de klant zal geen tickets kunnen zien).',
        'Search Results' => 'Zoekresultaat',
        'Customers' => 'Bedrijven',
        'Groups' => 'Groepen',
        'Change Group Relations for Customer' => 'Bewerk gekoppelde groepen voor deze klant',
        'Change Customer Relations for Group' => 'Bewerk gekoppelde klanten voor deze groep',
        'Toggle %s Permission for all' => '%s permissies aan/uit',
        'Toggle %s permission for %s' => '%s permissies aan/uit voor %s',
        'Customer Default Groups:' => 'Standaard groepen',
        'No changes can be made to these groups.' => 'Deze groepen kunnen niet gewijzigd worden.',
        'ro' => 'alleen lezen',
        'Read only access to the ticket in this group/queue.' => 'Leesrechten op de tickets in deze groep/wachtrij.',
        'rw' => 'lezen + schrijven',
        'Full read and write access to the tickets in this group/queue.' =>
            'Volledige lees- en schrijfrechten op de tickets in deze groep/wachtrij.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Beheer klanten',
        'Add Customer User' => 'Nieuwe klant',
        'Edit Customer User' => 'Klant bewerken',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Klanten zijn nodig om een historie te kunnen inzien en om in te loggen via het klantenscherm.',
        'List (%s total)' => 'Lijst (%s in totaal)',
        'Username' => 'Gebruikersnaam',
        'Email' => 'E-mail',
        'Last Login' => 'Laatst ingelogd',
        'Login as' => 'Inloggen als',
        'Switch to customer' => 'Omschakelen naar klant',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Deze klanten backend is niet te wijzigen maar de voorkeuren van deze klant kunnen aangepast worden!',
        'This field is required and needs to be a valid email address.' =>
            'Dit veld is verplicht en moet een geldig e-mailadres zijn.',
        'This email address is not allowed due to the system configuration.' =>
            'Dit e-mailadres is niet toegestaan.',
        'This email address failed MX check.' => 'Dit e-mailadres klopt niet.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS probleem geconstateerd. Kijk in de log voor meer details en pas uw configuratie aan.',
        'The syntax of this email address is incorrect.' => 'De syntax van dit e-mailadres klopt niet.',
        'This CustomerID is invalid.' => 'Deze klantcode is ongeldig.',
        'Effective Permissions for Customer User' => 'Effectieve machtigingen voor klanten',
        'Group Permissions' => 'Groepsrechten',
        'This customer user has no group permissions.' => 'Deze klant heeft geen groepsrechten.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'De bovenstaande tabel toont de effectieve rechten van de groep voor deze klant. De matrix houdt rekening met alle overgeërfde rechten (bv. via klantgroepen). Merk op: de tabel houdt geen rekening met wijzigingen die in dit formulier werden aangebracht en nog niet opgeslagen zijn.',
        'Customer Access' => 'Bedrijf toegang',
        'Customer' => 'Klant',
        'This customer user has no customer access.' => 'Deze klant heeft geen toegang.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Beheer Klant Gebruiker-Klant koppelingen',
        'Select the customer user:customer relations.' => 'Selecteer de klant gebruiker:klant relaties.',
        'Customer Users' => 'Klanten',
        'Change Customer Relations for Customer User' => 'Bewerk Klan Relaties voor Klant gebruiker',
        'Change Customer User Relations for Customer' => 'Wijzig Klant Gebruiker koppelingen voor Klant',
        'Toggle active state for all' => 'Alles actief aan/uit',
        'Active' => 'Actief',
        'Toggle active state for %s' => 'Actief aan/uit voor %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Beheer Klant gebruiker - Groep koppelingen',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Gebruik deze functie alleen als u groepsrechten voor klantgebruikers wilt definiëren.',
        'Edit Customer User Default Groups' => 'Bewerk de klant - groep koppeling',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filter op groepen',
        'Select the customer user - group permissions.' => 'Selecteer de Klant gebruiker - groep permissies',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (tickets zijn niet toegankelijk voor de klant gebruiker).',
        'Customer User Default Groups:' => 'Klant Gebruiker Standaard Groepen:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Beheer Klantgebruiker-Service relaties',
        'Edit default services' => 'Beheer standaard services',
        'Filter for Services' => 'Filter op services',
        'Filter for services' => 'Filter voor Services',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Beheer van dynamische velden',
        'Add new field for object' => 'Nieuw veld voor object',
        'Filter for Dynamic Fields' => 'Filter op Dynamische Velden',
        'Filter for dynamic fields' => 'Filter op dynamische velden',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => 'Webservice',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Externe webservices kunnen als databronnen geconfigureerd worden voor dynamische velden',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Met deze functie kunt u (meerdere) contacten met gegevens toevoegen aan tickets.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Om een nieuw veld toe te voegen selecteert u het veldtype uit de objectlijst, het object definieert de grens van het veld en deze kan na het aanmaken niet worden gewijzigd.',
        'Dynamic Fields List' => 'Lijst met dynamische velden',
        'Dynamic fields per page' => 'Dynamische velden per pagina',
        'Label' => 'Label',
        'Order' => 'Volgorde',
        'Object' => 'Object',
        'Delete this field' => 'Verwijder dit veld',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => '',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            '',
        'DynamicFields Import' => '',
        'DynamicFields Export' => '',
        'Dynamic Fields Screens' => '',
        'Here you can manage the dynamic fields in the respective screens.' =>
            '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamische velden',
        'Go back to overview' => 'Terug naar het overzicht',
        'General' => 'Algemeen',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dit veld is verplicht. Het kan aleen alfanumerieke tekens bevatten.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Moet uniek zijn en kan alleen alfanumerieke tekens bevatten.',
        'Changing this value will require manual changes in the system.' =>
            'Na aanpassen van deze waarde zijn handmatige aanpassingen in het systeem nodig.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Deze naam wordt getoond in de schermen waar dit veld actief is.',
        'Field order' => 'Veldvolgorde',
        'This field is required and must be numeric.' => 'Dit veld is verplicht en moet numeriek zijn.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Dit is de volgorde waarin de velden worden weergegeven op de schermen waar ze geactiveerd zijn.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Veldtype',
        'Object type' => 'Objecttype',
        'Internal field' => 'Intern veld',
        'This field is protected and can\'t be deleted.' => 'Dit veld is beschermd en kan niet worden verwijderd.',
        'This dynamic field is used in the following config settings:' =>
            'Dit dynamische veld wordt gebruikt in de volgende configuratie-instellingen:',
        'Field Settings' => 'Veld-instellingen',
        'Default value' => 'Standaard waarde',
        'This is the default value for this field.' => 'Dit is de standaard-waarde voor dit veld.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Sleutel',
        'Value' => 'Waarde',
        'Remove value' => 'Waarde verwijderen',
        'Add Field' => '',
        'Add value' => 'Waarde toevoegen',
        'These are the possible data attributes for contacts.' => '',
        'Mandatory fields' => '',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            '',
        'Sorted fields' => '',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            '',
        'Searchable fields' => '',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            '',
        'Translatable values' => 'Waarden zijn vertaalbaar',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Als u deze optie activeerd zullen de waarden vertaald worden in de taal van de eindgebruiker.',
        'Note' => 'Notitie',
        'You need to add the translations manually into the language translation files.' =>
            'U moet de vertalingen zelf toevoegen aan de vertalingsbestanden.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Mogelijke waarden',
        'Datatype' => '',
        'Filter' => 'Filter',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Toon koppeling',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hier kunt u een optionele hyperlink opgeven die getoond wordt in de overzichten en zoom-schermen.',
        'Example' => 'Voorbeeld',
        'Link for preview' => 'Link voor voorvertoning',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Poort',
        'Table / View' => '',
        'User' => 'Gebruiker',
        'Password' => 'Wachtwoord',
        'Identifier' => 'Identifier',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Multiselect',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standaard verschil met huidige datum',
        'This field must be numeric.' => 'Dit veld moet numeriek zijn.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Het verschil tot de huidige tijd (in seconden) ten behoeve van de standaard waarde van dit veld.',
        'Define years period' => 'Geef mogelijke periode',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activeer deze feature om een minimale en maximale waarde te kiezen in het jaar-veld van de datum.',
        'Years in the past' => 'Jaren in het verleden',
        'Years in the past to display (default: 5 years).' => '(standaard: 5 jaar).',
        'Years in the future' => 'Jaren in de toekomst',
        'Years in the future to display (default: 5 years).' => '(standaard: 5 jaar).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => 'Beperk het invoeren van datumgegevens',
        'Here you can restrict the entering of dates of tickets.' => 'Hier kunt u het invoeren van datumgegevens van tickets beperken.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Waarde toevoegen',
        'Add empty value' => 'Lege waarde toevoegen',
        'Activate this option to create an empty selectable value.' => 'Activeer deze optie om een lege selecteerbare waarde toe te voeten.',
        'Tree View' => 'Boomweergave',
        'Activate this option to display values as a tree.' => 'Activeer deze optie om waarden in een boomstructuur weer te geven.',

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '',
        'Select the items you want to ' => '',
        'Select the desired elements and confirm the import with \'import\'.' =>
            '',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            '',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            '',
        'Toggle all available elements' => '',
        'Fields' => 'Velden',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Overzicht',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'U kunt de elementen ook van volgorde te wijzigen door ze te slepen met de muis.',
        'Filter available elements' => '',
        'selected to available elements' => '',
        'Available Elements' => '',
        'Filter disabled elements' => '',
        'selected to disabled elements' => '',
        'Toggle all disabled elements' => '',
        'Disabled Elements' => '',
        'Filter assigned elements' => '',
        'selected to assigned elements' => '',
        'Toggle all assigned elements' => '',
        'Assigned Elements' => '',
        'Filter assigned required elements' => '',
        'selected to assigned required elements' => '',
        'Toggle all assigned required elements' => '',
        'Assigned Required Elements' => '',
        'Reset' => 'Opnieuw',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Aantal regels',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Geef de hoogte van het invoervak voor dit veld (in regels)',
        'Number of cols' => 'Aantal kolommen',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Geef de breedte van het invoervak voor dit veld (in kolommen)',
        'Check RegEx' => 'Controleer RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hier kunt u een reguliere expressie opgeven om de waarde te controleren. De regex zal met de xms modifier worden uitgevoerd.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ongeldig RegEx',
        'Error Message' => 'Foutmelding',
        'Add RegEx' => 'Regex toevoegen',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Sjabloon',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Grootte',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Dit veld is verplicht',
        'The web service to be executed for possible values.' => '',
        'Invoker' => '',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            '',
        'Activate this option to allow multiselect on results.' => '',
        'Cache TTL' => '',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            '',

        # Template: AdminEmail
        'Admin Message' => 'Admin Bericht',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Vanuit dit scherm kunt u een bericht sturen aan behandelaars of klanten.',
        'Create Administrative Message' => 'Stuur een bericht',
        'Your message was sent to' => 'Uw bericht is verstuurd aan',
        'From' => 'Van',
        'Send message to users' => 'Stuur bericht aan gebruikers',
        'Send message to group members' => 'Stuur bericht aan accounts met groep',
        'Group members need to have permission' => 'Leden van de groep moeten permissies hebben',
        'Send message to role members' => 'Stuur bericht naar accounts met rol',
        'Also send to customers in groups' => 'Stuur ook naar klanten in deze groepen',
        'Body' => 'Bericht tekst',
        'Send' => 'Verstuur',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Generieke Agent Taakbeheer',
        'Edit Job' => 'Bewerk taak',
        'Add Job' => 'Taak toevoegen',
        'Run Job' => 'Voer taak uit',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Laatst uitgevoerd',
        'Run Now!' => 'Nu uitvoeren',
        'Delete this task' => 'Verwijder deze taak',
        'Run this task' => 'Voer deze taak',
        'Job Settings' => 'Taak instellingen',
        'Job name' => 'Naam',
        'The name you entered already exists.' => 'De naam die u hebt opgegeven bestaat al.',
        'Automatic Execution (Multiple Tickets)' => 'Automatische Uitvoering (Meerder Tickets)',
        'Execution Schedule' => 'Tijdschema',
        'Schedule minutes' => 'minuten',
        'Schedule hours' => 'uren',
        'Schedule days' => 'dagen',
        'Automatic execution values are in the system timezone.' => 'Automatische uitvoering waardes bevinden zich binnen de systeemtijdzone.',
        'Currently this generic agent job will not run automatically.' =>
            'Deze taak zal niet automatisch draaien.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Om automatisch uit te voeren selecteer ten minste één waarde bij minuten, uren en dagen.',
        'Event Based Execution (Single Ticket)' => 'Gebeurtenis gebaseerde uitvoering (één ticket)',
        'Event Triggers' => 'Event triggers',
        'List of all configured events' => 'Lijst van beschikbare events',
        'Delete this event' => 'Verwijder dit event',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Naast of in plaats van uitvoeren op een tijdschema kunt u ook ticket events selecteren die deze taak triggeren.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Als een ticket-event plaatsvindt zal dit filter worden toegepast om te toetsen of dit ticket voldoet. Alleen dan wordt deze taak uitgevoerd.',
        'Do you really want to delete this event trigger?' => 'Wilt u deze event trigger verwijderen?',
        'Add Event Trigger' => 'Nieuwe event trigger toevoegen',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Selecteer Tickets',
        '(e. g. 10*5155 or 105658*)' => '(bijvoorbeeld 10*5155 or 105658*)',
        '(e. g. 234321)' => '(bijvoorbeeld 234321)',
        'Customer user ID' => 'Klantgebruiker ID',
        '(e. g. U5150)' => '(bijvoorbeeld U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Zoek in tekst van een interactie. Gebruik wildcards (bijvoorbeeld "Mar*in" of "Jans*").',
        'To' => 'Aan',
        'Cc' => 'Cc',
        'Service' => 'Service',
        'Service Level Agreement' => 'Service Level Agreement',
        'Queue' => 'Wachtrij',
        'State' => 'Status',
        'Agent' => 'Behandelaar',
        'Owner' => 'Eigenaar',
        'Responsible' => 'Verantwoordelijke',
        'Ticket lock' => 'Vergrendeling',
        'Dynamic fields' => 'Dynamische velden',
        'Add dynamic field' => '',
        'Create times' => 'Tijdstip van aanmaken',
        'No create time settings.' => 'Alle',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'and' => 'en',
        'Last changed times' => 'Tijdstip van laatste wijziging',
        'No last changed time settings.' => 'Geen instellingen voor tijdstip laatste wijziging.',
        'Ticket last changed' => 'Laatste wijziging ticket',
        'Ticket last changed between' => 'Laatste wijziging ticket tussen',
        'Change times' => 'Tijdstip van wijzigen',
        'No change time settings.' => 'Alle',
        'Ticket changed' => 'Ticket gewijzigd',
        'Ticket changed between' => 'Ticket gewijzigd tussen',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Tijdstip van sluiten',
        'No close time settings.' => 'Alle',
        'Ticket closed' => 'Ticket gesloten',
        'Ticket closed between' => 'Ticket gesloten tussen',
        'Pending times' => 'Tijdstip van wachten',
        'No pending time settings.' => 'Niet op zoeken',
        'Ticket pending time reached' => 'Ticket wachtend tot tijd bereikt',
        'Ticket pending time reached between' => 'Ticket wachtend tot tijd tussen',
        'Escalation times' => 'Tijdstip van escalatie',
        'No escalation time settings.' => 'Niet op zoeken',
        'Ticket escalation time reached' => 'Escalatiemoment bereikt',
        'Ticket escalation time reached between' => 'Escalatiemoment bereikt tussen',
        'Escalation - first response time' => 'Escalatie - eerste reactietijd',
        'Ticket first response time reached' => 'Escalatiemoment eerste reactie bereikt',
        'Ticket first response time reached between' => 'Escalatiemoment eerste reactie bereikt tussen',
        'Escalation - update time' => 'Escalatie - tijd van bijwerken',
        'Ticket update time reached' => 'Escalatiemoment - tijd van bijwerken bereikt',
        'Ticket update time reached between' => 'Escalatiemoment - tijd van bijwerken bereikt tussen',
        'Escalation - solution time' => 'Escalatie - tijd van oplossen',
        'Ticket solution time reached' => 'Escalatiemoment - tijd van oplossen bereikt',
        'Ticket solution time reached between' => 'Escalatiemoment - tijd van oplossen bereikt tussen',
        'Archive search option' => 'Zoek in archief',
        'Update/Add Ticket Attributes' => 'Update/toevoegen ticketattributen',
        'Set new service' => 'Nieuwe service',
        'Set new Service Level Agreement' => 'Nieuwe Service Level Agreement',
        'Set new priority' => 'Nieuwe prioriteit',
        'Set new queue' => 'Nieuwe wachtrij',
        'Set new state' => 'Nieuwe status',
        'Pending date' => 'In de wacht: datum',
        'Set new agent' => 'Nieuwe behandelaar',
        'new owner' => 'nieuwe eigenaar',
        'new responsible' => 'nieuwe verantwoordelijke',
        'Set new ticket lock' => 'Nieuwe vergrendeling',
        'New customer user ID' => 'Nieuwe klantgebruiker ID',
        'New customer ID' => 'Nieuwe klantcode',
        'New title' => 'Nieuwe titel',
        'New type' => 'Nieuw type',
        'Archive selected tickets' => 'Archiveer geselecteerde tickets',
        'Add Note' => 'Notitie toevoegen',
        'Visible for customer' => 'Zichtbaar voor klant',
        'Time units' => 'Bestede tijd',
        'Execute Ticket Commands' => 'Ticketcommando\'s uitvoeren',
        'Send agent/customer notifications on changes' => 'Stuur behandelaars / klanten een melding bij wijzigingen',
        'CMD' => 'Commando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Dit commando zal worden uitgevoerd. ARG[0] is het nieuwe ticketnummer. ARG[1] is het nieuwe ticketid.',
        'Delete tickets' => 'Verwijder tickets.',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Waarschuwing: alle geselecteerde tickets worden verwijderd uit de database en kunnen niet terug worden geplaatst.',
        'Execute Custom Module' => 'Start externe module',
        'Param %s key' => 'Parameter %s sleutel',
        'Param %s value' => 'Parameter %s waarde',
        'Results' => 'Resultaten',
        '%s Tickets affected! What do you want to do?' => '%s tickets gevonden! Wat wilt u doen?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Waarschuwing: u hebt voor VERWIJDEREN gekozen!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Waarschuwing: Er worden %s tickets geraakt, maar slechts %s tickets kunnen worden aangepast gedurende één taak executie.',
        'Affected Tickets' => 'Gevonden tickets',
        'Age' => 'Leeftijd',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface Web Service Beheer',
        'Web Service Management' => 'Webservice Beheer',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Ga terug naar webservice',
        'Clear' => 'Leegmaken',
        'Do you really want to clear the debug log of this web service?' =>
            'Wilt u de debug-log van deze webservice leegmaken?',
        'Request List' => 'Lijst van verzoeken',
        'Time' => 'Tijd',
        'Communication ID' => 'Communicatie ID',
        'Remote IP' => 'IP-adres afzender',
        'Loading' => 'Laden',
        'Select a single request to see its details.' => 'Kies een verzoek om de details te zien.',
        'Filter by type' => 'Filter op type',
        'Filter from' => 'Filter op afzender',
        'Filter to' => 'Filter op bestemming',
        'Filter by remote IP' => 'Filter op IP-adres',
        'Limit' => 'Beperk tot',
        'Refresh' => 'Vernieuwen',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Alle configuratiedata gaat verloren.',
        'General options' => 'Algemene opties',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Geef een unieke naam op voor deze Web Service.',
        'Error handling module backend' => '',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => 'Foutmelding inhoud filter',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => 'Foutcode',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => 'Foutmelding',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'Wilt u deze invoker echt verwijderen?',
        'Invoker Details' => 'Invoker details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'De naam wordt gebruikt om een operatie van een webservice aan te roepen.',
        'Invoker backend' => 'Invoker backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Deze OTOBO invoker module zal worden aangeroepen om de data te formatteren voordat deze naar het andere systeem verstuurd wordt.',
        'Mapping for outgoing request data' => 'Mapping voor uitgaande data.',
        'Configure' => 'Configureer',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'De data van de invoker van OTOBO wordt verwerkt door deze mapping om het om te zetten in het formaat wat het communicerende systeem verwacht.',
        'Mapping for incoming response data' => 'Koppeling voor inkomende response-data',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'De data van het antwoord wordt verwerkt door deze koppeling om dit om te zetten in het formaat wat de OTOBO invoker verwacht.',
        'Asynchronous' => 'Asynchroon',
        'Condition' => 'Conditie',
        'Edit this event' => 'Bewerk deze gebeurtenis',
        'This invoker will be triggered by the configured events.' => 'De invoker wordt aangeroepen door de geconfigureerde events.',
        'Add Event' => 'Gebeurtenis toevoegen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Om een nieuw event toe te voegen, selecteer het event object en de naam van het event en klik op de "+".',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Asynchrone event-triggers worden in de achtergrond afgehandeld door de OTOBO Scheduler Daemon (aangeraden).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone event triggers worden afgehandeld direct tijdens het event (blocking).',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Ga terug naar',
        'Delete all conditions' => 'Verwijder alle condities',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => 'Algemene Instellingen',
        'Event type' => 'Gebeurtenis type',
        'Conditions' => 'Condities',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Type koppeling tussen condities',
        'Remove this Condition' => 'Verwijder conditie',
        'Type of Linking' => 'Type koppeling',
        'Add a new Field' => 'Nieuw veld',
        'Remove this Field' => 'Verwijder dit veld',
        'And can\'t be repeated on the same condition.' => 'En kan niet worden herhaald in dezelfde conditie.',
        'Add New Condition' => 'Nieuwe conditie',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Eenvoudige koppeling',
        'Default rule for unmapped keys' => 'Standaardregel voor nietgekoppelde sleutels',
        'This rule will apply for all keys with no mapping rule.' => 'Deze regel geldt voor alle sleutelwaarden zonder koppeling.',
        'Default rule for unmapped values' => 'Standaardregel voor nietgekoppelde waarden',
        'This rule will apply for all values with no mapping rule.' => 'Deze regel geldt voor alle waarden zonder koppeling.',
        'New key map' => 'Nieuwe sleutelkoppeling',
        'Add key mapping' => 'Voeg sleutelkoppeling toe',
        'Mapping for Key ' => 'Koppeling voor sleutel',
        'Remove key mapping' => 'Verwijder sleutelkoppeling',
        'Key mapping' => 'Sleutelkoppeling',
        'Map key' => 'Koppel sleutel',
        'matching the' => 'die overeenkomen met',
        'to new key' => 'aan nieuwe sleutel',
        'Value mapping' => 'Waardekoppeling',
        'Map value' => 'Koppel waarde',
        'to new value' => 'aan nieuwe waarde',
        'Remove value mapping' => 'Verwijder waardekoppeling',
        'New value map' => 'Nieuwe waardekoppeling',
        'Add value mapping' => 'Voeg waardekoppeling toe',
        'Do you really want to delete this key mapping?' => 'Deze sleutelkoppeling verwijderen?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => 'MacOS Sneltoetsen',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => 'Zoek',
        'Find next' => 'Zoek volgende',
        'Find previous' => 'Zoek vorige',
        'Find and replace' => 'Zoek en vervang',
        'Find and replace all' => 'Zoek en vervang alle',
        'XSLT Mapping' => 'XSLT-toewijzing',
        'XSLT stylesheet' => 'XSLT stylesheet',
        'The entered data is not a valid XSLT style sheet.' => 'De ingevoerde data is geen geldig XSLT stylesheet.',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => 'Data bevat',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => 'Reguliere expressie',
        'Replace' => 'Vervang',
        'Remove regex' => 'Regex verwijderen',
        'Add regex' => 'Regex toevoegen',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '',
        'Edit Operation' => '',
        'Do you really want to delete this operation?' => 'Wilt u deze operatie echt verwijderen?',
        'Operation Details' => 'Operatie-details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'De naam wordt normaal gesproken gebruikt om deze Web Service aan te roepen vanaf een ander systeem.',
        'Operation backend' => 'Operatie-backend',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Deze OTOBO operatie-module zal intern worden gebruikt om de data voor de respons te genereren.',
        'Mapping for incoming request data' => 'Koppeling voor inkomende data',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'De inkomende data wordt verwerkt door deze koppeling, om het om te zetten naar de data die OTOBO verwacht.',
        'Mapping for outgoing response data' => 'Koppeling voor respons-data',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'De respons-data wordt verwerkt door deze koppeling, om het om te zetten naar de data die het andere systeem verwacht.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Netwerk Transport',
        'Properties' => 'Eigenschappen',
        'Route mapping for Operation' => 'Route maken voor actie',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Bepaal de route die gemapt moet worden op deze operatie. Variabelen gemarkeerd met een \':\' woden gemapt op de ingevoerde naam en doorgegeven met de maping (bv. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Geldige verzoek methoden voor Operatie',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Beperk deze operatie tot verschillende verzoek methoden. Als er geen methode is geselecteerd wordt alles geaccepteerd.',
        'Maximum message length' => 'Maximale bericht-lengte',
        'This field should be an integer number.' => 'Dit veld moet een getal bevatten.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Hier kun je het maximum aantal bytes bepalen van REST berichten die OTOBO verwerkt.',
        'Send Keep-Alive' => 'Verstuur Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Deze configuratie bepaalt of binnenkomende verbindingen worden afgesloten of in leven worden gehouden.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Eindpunt',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'time-out',
        'Timeout value for requests.' => '',
        'Authentication' => 'Authenticatie',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'BasicAuth Gebruiker',
        'The user name to be used to access the remote system.' => 'De gebruikersnaam om toegang te krijgen tot het andere systeem.',
        'BasicAuth Password' => 'BasicAuth Wachtwoord',
        'The password for the privileged user.' => 'Wachtwoord',
        'Use Proxy Options' => 'Gebruik Proxy Opties',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Proxy-server',
        'URI of a proxy server to be used (if needed).' => 'URI van de proxy-server (indien nodig).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-gebruikersnaam',
        'The user name to be used to access the proxy server.' => 'De gebruikersnaam voor toegang tot de proxy-server.',
        'Proxy Password' => 'Proxy-wachtwoord',
        'The password for the proxy user.' => 'Het wachtwoord voor de proxy-gebruiker.',
        'Skip Proxy' => 'Proxy overslaan',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Configureer SSL opties',
        'Show or hide SSL options to connect to the remote system.' => 'Toon of verberg SSL opties om te verbinden naar het andere systeem',
        'Client Certificate' => 'Client Certificaat',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'bv. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Client Certificaatsleutel',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'bv. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Client Certificaatsleutel wachtwoord',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Het volledige pad en de naam van het CA certificaat dat het SSL certificaat valideert.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'Bijvoorbeeld /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Het volledige pad van de directory waar de CA-certificaten worden opgeslagen.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'bijvoorbeeld /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Controller mapping voor Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'De controller waar de invoker zijn verzoeken naar moet versturen. Variabelen die beginnen met een \':\' worden vervangen door de data waarde en doorgegeven met het verzoek. (bijvoorbeeld Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Geldig verzoek commando voor Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Een specifiek HTTP commando om te gebruiken voor de verzoeken met deze Invoker (optioneel).',
        'Default command' => 'Standaard opdracht',
        'The default HTTP command to use for the requests.' => 'De standaard HTTP opdracht die gebruikt wordt bij verzoeken.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'bv. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'SOAP-action separator',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI om SOAP methods een context te geven.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => 'Verzoek naamschema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Selecteer hoe de SOAP verzoeken wrapper gemaakt zou moeten worden.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' is gebruikt als voorbeeld voor invoker/operation name.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' wordt gebruikt als voorbeeld voor eigenlijk geconfigureerde waarde.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Tekst die gebruikt moet worden als wrapper naam achtervoegsel of vervanging.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Gebruik geen XML element namen (gebruik geen \'<\' en geen \'&\').',
        'Response name scheme' => 'Antwoord naamschema',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Selecteer hoe SOAP antwoorden functie gemaakt zou moeten worden.',
        'Response name free text' => 'Antwoord naam vrije tekst',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Hier kunt u de maximale berichtgrootte (in bytes) opgeven van de berichten die OTOBO zal verwerken.',
        'Encoding' => 'Karakterset',
        'The character encoding for the SOAP message contents.' => 'De karakterset voor de inhoud van het SOAP-bericht.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'bijv. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => 'Sorteer voorkeuren',
        'Add new first level element' => 'Voeg nieuw eerste level element toe',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Uitgaande sorteer volgorde voor xml velden (structuur begint onder functie naam warpper) - zie SOAP transport documentatie.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webservice toevoegen',
        'Edit Web Service' => 'Bewerk webservice',
        'Clone Web Service' => 'Kloon Webservice',
        'The name must be unique.' => 'De naam moet uniek zijn',
        'Clone' => 'Kloon',
        'Export Web Service' => 'Exporteer Webservice',
        'Import web service' => 'Importeer webservice',
        'Configuration File' => 'Configuratiebestand',
        'The file must be a valid web service configuration YAML file.' =>
            'Het bestand moet een geldig web service YAML bestand zijn.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importeer',
        'Configuration History' => 'Configuratiegeschiedenis',
        'Delete web service' => 'Verwijder webservice',
        'Do you really want to delete this web service?' => 'Wilt u deze webservice verwijderen?',
        'Ready2Adopt Web Services' => 'Ready2Adopt Webservices',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => 'Importeer Ready2Adopt webservice',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Na opslaan blijft u in dit scherm.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Als u terug wilt na het overzicht klik dan op de "Naar het overzicht" knop.',
        'Remote system' => 'Ander systeem',
        'Provider transport' => 'Provider-transport',
        'Requester transport' => 'Requester-transport',
        'Debug threshold' => 'Debug-niveau',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'In Provider-modus levert OTOBO web services die aangeroepen worden door andere systemen.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'In Requester-modus gebruikt OTOBO web services van andere systemen.',
        'Network transport' => 'Netwerk-transport',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Operaties zijn individuele systeemfuncties die aangeroepen kunnen worden door andere systemen.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers verzamelen data voor een aanroep naar een ander systeem, en om de responsdata van het andere systeem te verwerken.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Inkomende koppeling',
        'Outbound mapping' => 'Uitgaande koppeling',
        'Delete this action' => 'Verwijder deze actie',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Minimaal één %s heeft een controller die niet aanwezig is of actief is, controleer de controller registratie of verwijder %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Geschiedenis',
        'Go back to Web Service' => 'Ga terug naar webservice',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hier kunt u oudere versies van de huidige web service-configuratie bekijken, exporteren of terugzetten.',
        'Configuration History List' => 'Configuratie-geschiedenis',
        'Version' => 'Versie',
        'Create time' => 'Aanmaaktijd',
        'Select a single configuration version to see its details.' => 'Selecteer een configuratie-versie om de details te bekijken.',
        'Export web service configuration' => 'Exporteer webserviceconfiguratie',
        'Restore web service configuration' => 'Herstel webserviceconfiguratie',
        'Do you really want to restore this version of the web service configuration?' =>
            'Wilt u echt deze versie van de webservice-configuratie herstellen?',
        'Your current web service configuration will be overwritten.' => 'De huidige webservice-configuratie zal worden overschreven.',

        # Template: AdminGroup
        'Group Management' => 'Groepenbeheer',
        'Add Group' => 'Groep toevoegen',
        'Edit Group' => 'Bewerk groep',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Maak nieuwe groepen aan om tickets te kunnen scheiden en de juiste wachtrijen aan behandelaars te tonen (bijv. support, sales, management).',
        'It\'s useful for ASP solutions. ' => 'Bruikbaar voor ASP situaties.',

        # Template: AdminLog
        'System Log' => 'Logboek',
        'Here you will find log information about your system.' => 'Hier is de OTOBO log te raadplegen.',
        'Hide this message' => 'Verberg dit paneel',
        'Recent Log Entries' => 'Recente Logboekregels',
        'Facility' => 'Maatregel',
        'Message' => 'Bericht',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Beheer e-mail accounts',
        'Add Mail Account' => 'Mail account toevoegen',
        'Edit Mail Account for host' => '',
        'and user account' => 'en gebruikersaccount',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => 'Systeemconfiguratie',
        'Host' => 'Server',
        'Delete account' => 'Verwijder account',
        'Fetch mail' => 'Mail ophalen',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => 'Bijvoorbeeld: mail.example.com',
        'IMAP Folder' => 'IMAP folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Alleen aanpassen als u uit een andere folder dan INBOX mails wilt ophalen.',
        'Trusted' => 'Vertrouwd',
        'Dispatching' => 'Sortering',
        'Edit Mail Account' => 'Bewerk mail account',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Administratieoverzicht',
        'Filter for Items' => '',
        'Favorites' => 'Favorieten',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => 'Koppelingen',
        'View the admin manual on Github' => '',
        'No Matches' => 'Geen overeenkomsten',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Ticket meldingen beheer',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Hier kunt u configuratie bestanden uploaden om Ticket meldingen te importeren. Het bestand moet in .yml format zijn zoals geëxporteerd door de Ticket meldingen module.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Hier kun je kiezen welke events deze notificatie inschakelen. Een extra ticket filter kan worden toegepast om de notificatie alleen te versturen als het ticket voldoet aan bepaalde criteria.',
        'Ticket Filter' => 'Ticket filter',
        'Lock' => 'Vergrendel',
        'SLA' => 'SLA',
        'Customer User ID' => 'Klantgebruiker ID',
        'Article Filter' => 'Filter interacties',
        'Only for ArticleCreate and ArticleSend event' => 'Alleen voor ArticleCreate en ArticleSend event',
        'Article sender type' => 'Soort verzender',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Als ArticleCreate of ArticleSend wordt gebruikt als trigger event, moet je een article filter spcificeren. Selecteer minimaal één van de artikel filter velden.',
        'Customer visibility' => 'Klant zichtbaarheid',
        'Communication channel' => 'Communicatiekanaal',
        'Include attachments to notification' => 'Voeg bijlagen toe aan melding',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Verstuur slechts éénmaal per dag over één ticket via de geselecteerde methode',
        'This field is required and must have less than 4000 characters.' =>
            'Dit veld is vereist en mag maximaal 4000 tekens bevatten.',
        'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een behandelaar.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste klant-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste klant-interactie te tonen.',
        'Attributes of the current customer user data' => 'Attributen van de huidige klantengegevens',
        'Attributes of the current ticket owner user data' => 'Eigenschappen van de huidige ticket eigenaar',
        'Attributes of the current ticket responsible user data' => 'Eigenschappen van de huidige ticket responsible',
        'Attributes of the current agent user who requested this action' =>
            'Eigenschappen van de agent die deze actie uitvoert',
        'Attributes of the ticket data' => 'Eigenschappen van de ticket gegevens',
        'Ticket dynamic fields internal key values' => 'Ticket dynamisch veld voor interne sleutelwaarden',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Ticket dynamisch veld weergave waarden, handig voor dropdown en multiselect velden',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'PGP beheer',
        'Add PGP Key' => 'PGP sleutel toevoegen',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => 'Configureer het hier!',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Hier kunt u de keyring beheren die is ingesteld in de systeemconfiguratie.',
        'Introduction to PGP' => 'Introductie tot PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Verloopt',
        'Delete this key' => 'Verwijder deze sleutel',
        'PGP key' => 'PGP sleutel',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakketbeheer',
        'Uninstall Package' => 'Verwijder pakket',
        'Uninstall package' => 'Verwijder pakket',
        'Do you really want to uninstall this package?' => 'Wilt u dit pakket echt verwijderen?',
        'Reinstall package' => 'Herinstalleer pakket',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Wilt u dit pakket echt herinstalleren? Eventuele handmatige aanpassingen gaan verloren.',
        'Go to updating instructions' => 'Ga naar update instructies',
        'Go to the OTOBO customer portal' => 'Ga naar het OTOBO klantenportaal',
        'package information' => 'pakketinformatie',
        'Package installation requires a patch level update of OTOBO.' =>
            '',
        'Package update requires a patch level update of OTOBO.' => '',
        'Please note that your installed OTOBO version is %s.' => '',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            '',
        'This package can only be installed on OTOBO version %s or older.' =>
            '',
        'This package can only be installed on OTOBO version %s or newer.' =>
            '',
        'Why should I keep OTOBO up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'Als u meer vragen heeft beantwoorden we deze graag.',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Installeer pakket',
        'Update Package' => 'Update pakket',
        'Continue' => 'Doorgaan',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Zorg dat uw database pakketten van groter dan %s MB accepteert. Op dit moment is de maximale grootte %s MB. Pas de waarde voor max_allowed_packet in het mysql configuratiebestand aan om problemen te voorkomen.',
        'Install' => 'Installeer',
        'Update repository information' => 'Vernieuw repository gegevens',
        'Cloud services are currently disabled.' => 'Cloud services zijn op dit moment uitgeschakeld.',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => 'Schakel cloud diensten in',
        'Update all installed packages' => '',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Leverancier',
        'Action' => 'Actie',
        'Module documentation' => 'Moduledocumentatie',
        'Local Repository' => 'Lokale Repository',
        'This package is verified by OTOBOverify (tm)' => 'Dit pakket is geverifieerd door OTOBOverify (tm)',
        'Uninstall' => 'Verwijder',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakket onjuist geïnstalleerd. Installeer het pakket opnieuw.',
        'Reinstall' => 'Herinstalleer',
        'Features for %s customers only' => 'Functionaliteit voor alleen %s klanten',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Met %s kun je profiteren van de volgende optionele functionaliteit. Neem contact op met %s voor meer informatie.',
        'Package Information' => 'Pakketinformatie',
        'Download package' => 'Download pakket',
        'Rebuild package' => 'Genereer pakket opnieuw',
        'Metadata' => 'Metadata',
        'Change Log' => 'Wijzigingen',
        'Date' => 'Datum',
        'List of Files' => 'Overzicht van bestanden',
        'Permission' => 'Permissie',
        'Download file from package!' => 'Download bestand van pakket.',
        'Required' => 'Verplicht',
        'Primary Key' => 'Primaire Sleutel',
        'Auto Increment' => 'Automatisch ophogen',
        'SQL' => 'SQL statement',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Verschillen in bestand %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance log',
        'Range' => 'Bereik',
        'last' => 'laatste',
        'This feature is enabled!' => 'Deze functie is ingeschakeld.',
        'Just use this feature if you want to log each request.' => 'Activeer de Performance Log alleen als u ieder verzoek wilt loggen.',
        'Activating this feature might affect your system performance!' =>
            'Deze functie gaat zelf ook een beetje ten koste van de performance.',
        'Disable it here!' => 'Uitschakelen',
        'Logfile too large!' => 'Logbestand te groot.',
        'The logfile is too large, you need to reset it' => 'Het logbestand is te groot, u moet het resetten',
        'Interface' => 'Interface',
        'Requests' => 'Verzoeken',
        'Min Response' => 'Minimaal',
        'Max Response' => 'Maximaal',
        'Average Response' => 'Gemiddelde',
        'Period' => 'Looptijd',
        'minutes' => 'minuten',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Gemiddeld',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'E-mail filterbeheer',
        'Add PostMaster Filter' => 'Nieuw e-mail filter',
        'Edit PostMaster Filter' => 'Bewerk e-mail filter',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Om inkomende e-mails te routeren op basis van e-mail headers. Matching op tekst of met behulp van regular expressions.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Als u alleen wilt filteren op het e-mailadres, gebruik dan EMAILADDRESS:info@example.local in Van, Aan of CC.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Als u regular expressions gebruikt dan kunt u ook de gevonden waarde tussen haakjes () gebruiken als [***] in de \'Set\' actie.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Verwijder filter',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter conditie',
        'AND Condition' => 'EN conditie',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dit veld kan een woord bevatten of een regular expression.',
        'Negate' => 'Omdraaien (negate)',
        'Set Email Headers' => 'Nieuwe waarden',
        'Set email header' => 'Stel email kop in',
        'with value' => '',
        'The field needs to be a literal word.' => 'Dit veld moet een letterlijke waarde bevatten.',
        'Header' => 'Type',

        # Template: AdminPriority
        'Priority Management' => 'Prioriteitenbeheer',
        'Add Priority' => 'Nieuwe prioriteit',
        'Edit Priority' => 'Bewerk prioriteit',
        'Filter for Priorities' => 'Filter voor Prioriteiten',
        'Filter for priorities' => 'Filter voor prioriteiten',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => 'Deze prioriteit wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminProcessManagement
        'Process Management' => 'Procesbeheer',
        'Filter for Processes' => 'Filter op processen',
        'Filter for processes' => 'Filter voor processen',
        'Create New Process' => 'Nieuw proces',
        'Deploy All Processes' => 'Deploy alle processen',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier kunt u een proces importeren vanuit een configuratiebestand. Het bestand moet in .yml formaat zijn, zoals geëxporteerd door de procesbeheer-module.',
        'Upload process configuration' => 'Upload procesconfiguratie',
        'Import process configuration' => 'Importeer procesconfiguratie',
        'Ready2Adopt Processes' => 'Ready2Adopt processen',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => 'Importeer Ready2Adopt proces',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Om een nieuw proces aan te maken kunt u een bestand importeren, aangemaakt op een ander systeem, of een compleet nieuw proces aanmaken.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Wijzigingen aan de processen hebben alleen invloed op het systeem als u de proces-data synchroniseert. Door het synchroniseren van de processen worden de wijzigingen weggeschreven naar de configuratie.',
        'Processes' => 'Processen',
        'Process name' => 'Naam',
        'Print' => 'Afdrukken',
        'Export Process Configuration' => 'Exporteer procesconfiguratie',
        'Copy Process' => 'Kopiëer proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annuleren & sluiten',
        'Go Back' => 'Terug',
        'Please note, that changing this activity will affect the following processes' =>
            'Let op: het wijzigen van deze activiteit heeft invloed op de volgende processen',
        'Activity' => 'Activiteit',
        'Activity Name' => 'Naam',
        'Activity Dialogs' => 'Dialogen',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt dialogen toevoegen aan deze activiteit door de elementen met de muis van links naar rechts te slepen.',
        'Filter available Activity Dialogs' => 'Filter beschikbare dialogen',
        'Available Activity Dialogs' => 'Beschikbare dialogen',
        'Name: %s, EntityID: %s' => 'Naam: %s. ID: %s',
        'Create New Activity Dialog' => 'Nieuwe dialoog',
        'Assigned Activity Dialogs' => 'Toegewezen dialogen',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Let op: het wijzigen van deze dialoog heeft invoed op de volgende activiteiten',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Let op: klanten kunnen de volgende velden niet zien of gebruiken: Eigenaar, Verantwoordelijke, Vergrendeling, Wacht tot datum en Klantcode.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Het Wachtrij veld kan alleen gebruikt door klanten wanneer een nieuw ticket wordt aangemaakt.',
        'Activity Dialog' => 'Dialoog',
        'Activity dialog Name' => 'Naam',
        'Available in' => 'Beschikbaar in',
        'Description (short)' => 'Beschrijving (kort)',
        'Description (long)' => 'Beschrijving (lang)',
        'The selected permission does not exist.' => 'De gekozen permissie bestaat niet.',
        'Required Lock' => 'Vergrendeling nodig',
        'The selected required lock does not exist.' => 'De gekozen vergrendeling bestaat niet.',
        'Submit Advice Text' => 'Verstuur-advies tekst',
        'Submit Button Text' => 'Tekst op Verstuur-knop',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt velden aan deze dialoog toevoegen door de elementen met de muis van links naar rechts te slepen.',
        'Filter available fields' => 'Filter beschikbare velden',
        'Available Fields' => 'Beschikbare velden',
        'Assigned Fields' => 'Toegewezen velden',
        'Communication Channel' => 'Communicatiekanaal',
        'Is visible for customer' => 'Is zichtbaar voor de klant',
        'Display' => 'Weergave',

        # Template: AdminProcessManagementPath
        'Path' => 'Pad',
        'Edit this transition' => 'Bewerk transitie',
        'Transition Actions' => 'Transitie-acties',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt transitie-acties aan deze transitie toevoegen door de elementen met de muis van links naar rechts te slepen.',
        'Filter available Transition Actions' => 'Filter beschikbare transitie-acties',
        'Available Transition Actions' => 'Beschikbare transitie-acties',
        'Create New Transition Action' => 'Nieuwe transitie-actie',
        'Assigned Transition Actions' => 'Gekoppelde transitie-acties',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Activiteiten',
        'Filter Activities...' => 'Filter activiteiten',
        'Create New Activity' => 'Nieuwe activiteit',
        'Filter Activity Dialogs...' => 'Filter dialogen...',
        'Transitions' => 'Transities',
        'Filter Transitions...' => 'Filter transities...',
        'Create New Transition' => 'Nieuwe transitie',
        'Filter Transition Actions...' => 'Filter transitie-acties...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Bewerk proces',
        'Print process information' => 'Print proces',
        'Delete Process' => 'Verwijder proces',
        'Delete Inactive Process' => 'Verwijder inactief proces',
        'Available Process Elements' => 'Beschikbare proces-elementen',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'De elementen hierboven kunnen verplaatst worden naar de canvas aan de rechterzijde door middel van slepen.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'U kunt activiteiten op de canvas plaatsen om ze toe te wijzen aan dit proces.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Om een dialoog toe te voegen aan een activiteit sleept u de dialoog uit deze lijst naar de activiteit geplaatst op de canvas.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Acties kunnen gekoppeld worden aan een transitie door het actie-element naar het label van een transitie te slepen.',
        'Edit Process Information' => 'Bewerk proces-informatie',
        'Process Name' => 'Naam',
        'The selected state does not exist.' => 'De geselecteerde status bestaat niet.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Beheren activiteiten, dialogen en transities',
        'Show EntityIDs' => 'Toon ID\'s',
        'Extend the width of the Canvas' => 'Vergroot de breedte van de canvas',
        'Extend the height of the Canvas' => 'Vergroot de hoogte van de canvas',
        'Remove the Activity from this Process' => 'Verwijder de activiteit uit dit proces',
        'Edit this Activity' => 'Bewerk deze activiteit',
        'Save Activities, Activity Dialogs and Transitions' => 'Bewaar activiteiten, dialogen en transities',
        'Do you really want to delete this Process?' => 'Wilt u dit proces verwijderen?',
        'Do you really want to delete this Activity?' => 'Wilt u deze activiteit verwijderen?',
        'Do you really want to delete this Activity Dialog?' => 'Wilt u deze dialoog verwijderen?',
        'Do you really want to delete this Transition?' => 'Wilt u deze transitie verwijderen?',
        'Do you really want to delete this Transition Action?' => 'Wilt u deze transitie-actie verwijderen?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Wilt u deze activiteit van de canvas verwijderen? Dit kan alleen ongedaan worden gemaakt door dit scherm te verlaten zonder opslaan.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Wilt u deze transitie van de canvas verwijderen? Dit kan alleen ongedaan worden gemaakt door dit scherm te verlaten zonder opslaan.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In dit scherm kunt u een nieuw proces aanmaken. Om het nieuwe proces beschikbaar te maken voor uw gebruikers moet u de status op \'Actief\' zetten en vervolgens een synchronisatie uitvoeren.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'Annuleren & sluiten',
        'Start Activity' => 'Start activiteit',
        'Contains %s dialog(s)' => 'Bevat %s dialoog(en)',
        'Assigned dialogs' => 'Toegewezen dialogen',
        'Activities are not being used in this process.' => 'Er zijn geen activiteiten in dit proces.',
        'Assigned fields' => 'Toegewezen velden',
        'Activity dialogs are not being used in this process.' => 'Er zijn geen dialogen in dit proces.',
        'Condition linking' => 'Condities koppelen',
        'Transitions are not being used in this process.' => 'Er zijn geen overgangen in dit proces.',
        'Module name' => 'Modulenaam',
        'Transition actions are not being used in this process.' => 'Er zijn geen transitie-acties in dit proces.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Let op: het wijzigen van deze transitie heeft invloed op de volgende processen',
        'Transition' => 'Transitie',
        'Transition Name' => 'Naam',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Let op: het wijzigen van deze transitie-actie heeft invloed op de volgende processen',
        'Transition Action' => 'Transitie-actie',
        'Transition Action Name' => 'Naam',
        'Transition Action Module' => 'Transitie-actiemodule',
        'Config Parameters' => 'Configuratie',
        'Add a new Parameter' => 'Nieuwe parameter',
        'Remove this Parameter' => 'Verwijder deze parameter',

        # Template: AdminQueue
        'Queue Management' => 'Wachtrij Beheer',
        'Add Queue' => 'Nieuwe wachtrij',
        'Edit Queue' => 'Bewerk wachtrij',
        'Filter for Queues' => 'Filter op wachtrijen',
        'Filter for queues' => 'Filter op wachtrijen',
        'A queue with this name already exists!' => 'Er bestaat al een wachtrij met deze naam',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Deze wachtrij is beschikbaar in een SysConfig instelling, bevestiging voor het updaten van instellingen naar de nieuwe wachtrij is nodig!',
        'Sub-queue of' => 'Onderdeel van',
        'Unlock timeout' => 'Ontgrendel tijdsoverschrijding',
        '0 = no unlock' => '0 = geen ontgrendeling',
        'hours' => 'uren',
        'Only business hours are counted.' => 'Alleen openingstijden tellen mee.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Als een ticket vergrendeld is en de behandelaar handelt het ticket niet af voor het verstrijken van de tijdsoverschrijding, wordt het ticket automatisch ontgrendeld en komt deze weer beschikbaar voor andere gebruikers.',
        'Notify by' => 'Melding bij',
        '0 = no escalation' => '0 = geen escalatie',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Als er geen klant naam, het externe e-mail of telefoon, bekend is voor de hier ingestelde tijd dan wordt het ticket geëscaleerd.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Als er iets wordt toegevoegd aan het ticket, b.v. een reactie per e-mail of via het web, dan zal de escalatie update tijd worden gereset. Als er geen klantencontact plaatsvindt, per e-mail of telefoon, voor de hier gedefiniëerde tijd, dan wordt het ticket geëscaleerd.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Als het ticket niet is afgesloten voor de hier gedefiniëerde tijd, dan wordt het ticket geëscaleerd.',
        'Follow up Option' => 'Reactie optie',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Bepaalt of reacties op gesloten tickets zorgen voor heropenen voor het ticket, geweigerd wordt, of een nieuw ticket genereert.',
        'Ticket lock after a follow up' => 'Ticket wordt vergrendeld na een reactie',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Als een ticket gesloten is en de klant een reactie stuurt dan wordt het ticket gekoppeld aan de oude eigenaar.',
        'System address' => 'Systeem adres',
        'Will be the sender address of this queue for email answers.' => 'Is het afzenderadres van deze wachtrij voor antwoorden per e-mail.',
        'Default sign key' => 'Standaard sleutel voor ondertekening.',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Aanhef',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'Signature' => 'Handtekening',
        'The signature for email answers.' => 'De ondertekening voor beantwoording van berichten per e-mail.',
        'This queue is used in the following config settings:' => 'Deze wachtrij wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Beheer Wachtrij - Automatische antwoorden koppelingen',
        'Change Auto Response Relations for Queue' => 'Bewerk automatische antwoorden voor wachtrij',
        'This filter allow you to show queues without auto responses' => 'Dit filter staat je toe om wachtrijen te zien die geen automatisch antwoord hebben.',
        'Queues without Auto Responses' => 'Wachtrijen zonder automatisch antwoord',
        'This filter allow you to show all queues' => 'Dit filter staat je toe om alle wachtrijen weer te geven',
        'Show All Queues' => 'Toon alle wachtrijen',
        'Auto Responses' => 'Automatische antwoorden',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Beheer Sjabloon - Wachtrij koppelingen',
        'Filter for Templates' => 'Filter op sjablonen',
        'Filter for templates' => 'Filter op sjablonen',
        'Templates' => 'Sjablonen',

        # Template: AdminRegistration
        'System Registration Management' => 'Beheer systeemregistratie',
        'Edit System Registration' => 'Bewerk Systeemregistratie',
        'System Registration Overview' => '',
        'Register System' => 'Registreer Systeem',
        'Validate OTOBO-ID' => 'Valideer OTOBO-ID',
        'Deregister System' => 'Deregistreer systeem',
        'Edit details' => 'Bewerk gegevens',
        'Show transmitted data' => 'Toon verstuurde gegevens',
        'Deregister system' => 'Deregistreer systeem',
        'Overview of registered systems' => 'Overzicht van geregistreerde systemen',
        'This system is registered with OTOBO Team.' => '',
        'System type' => 'Systeemtype',
        'Unique ID' => 'Uniek ID',
        'Last communication with registration server' => 'Laatste communicatie met registratieserver',
        'System Registration not Possible' => 'Systeemregistratie niet mogelijk',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Het is niet mogelijk om je systeem te registreren als OTOBO Daemon niet correct is opgestart!',
        'Instructions' => 'Instructies',
        'System Deregistration not Possible' => 'Systeemuitschrijving niet mogelijk',
        'OTOBO-ID Login' => 'OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Lees meer',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'U moet inloggen met uw OTOBO-ID om uw systeem te registreren',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Uw OTOBO-ID is het emailadres waarmee u zich heeft ingeschreven op de OTOBO.com website.',
        'Data Protection' => 'Gegevens beveiliging',
        'What are the advantages of system registration?' => 'Wat zijn de voordelen van systeemregistratie?',
        'You will receive updates about relevant security releases.' => 'U krijgt bericht over relevante security-releases',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Door middel van uw systeemregistratie kunnen wij onze dienstverlening aan u verbeteren, omdat we alle relevante informatie beschikbaar hebben.',
        'This is only the beginning!' => 'Dit is nog maar het begin.',
        'We will inform you about our new services and offerings soon.' =>
            'We zullen u binnenkort informeren over onze nieuwe diensten!',
        'Can I use OTOBO without being registered?' => 'Kan ik OTOBO gebruiken zonder te registreren?',
        'System registration is optional.' => 'Systeemregistratie is optioneel.',
        'You can download and use OTOBO without being registered.' => 'U kunt OTOBO downloaden en gebruiken zonder geregistreerd te zijn.',
        'Is it possible to deregister?' => 'Is het mogelijk om te deregistreren?',
        'You can deregister at any time.' => 'U kunt op elk moment deregistreren.',
        'Which data is transfered when registering?' => 'Welke data wordt verstuurd als ik mij registreer?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTOBO-versie, database-versie, gebruikt besturingssysteem en Perl-versie.',
        'Why do I have to provide a description for my system?' => 'Waarom moet ik een beschrijving van mijn systeem invullen?',
        'The description of the system is optional.' => 'Deze beschrijving is optioneel.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'De beschrijving en systeem-type die u specificeert helpen u om uw systeem te identificeren en een overzicht te houden van uw geregistreerde systemen.',
        'How often does my OTOBO system send updates?' => 'Hoe vaak verstuurt mijn OTOBO-systeem updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Uw systeem verstuurt op regelmatige basis updates.',
        'Typically this would be around once every three days.' => 'Normaal gesproken is dit ongeveer eens per drie dagen.',
        'If you deregister your system, you will lose these benefits:' =>
            'Als je je systeem deregistreert, verlies je de volgende voordelen:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'U moet inloggen met uw OTOBO-ID om uw systeem te deregistreren.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Heeft u nog geen OTOBO-ID?',
        'Sign up now' => 'Gebruikersnaam registreren',
        'Forgot your password?' => 'Wachtwoord vergeten?',
        'Retrieve a new one' => 'Wachtwoord herstellen',
        'Next' => 'Volgende',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => 'Attribuut',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO-versie',
        'Operating System' => 'Besturingssysteem',
        'Perl Version' => 'Perl-versie',
        'Optional description of this system.' => 'Optionele omschrijving van dit systeem.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Registreer',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => 'Deregistreer',
        'You can modify registration settings here.' => 'Je kunt je registratie instellingen hier aanpassen',
        'Overview of Transmitted Data' => 'Overzicht van verstuurde gegevens',
        'There is no data regularly sent from your system to %s.' => 'Er zijn geen gegevens die regelmatig worden verzonden van jouw systeem naar %s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'De volgende gegevens over jouw systeem worden maximaal elke 3 dagen verzonden naar %s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'De gegevens worden verstuurd in JSON format via een beveiligde https verbinding',
        'System Registration Data' => 'Systeemregistratie gegevens',
        'Support Data' => 'Ondersteuningsgegevens',

        # Template: AdminRole
        'Role Management' => 'Beheer rollen',
        'Add Role' => 'Nieuwe rol',
        'Edit Role' => 'Bewerk rol',
        'Filter for Roles' => 'Filter op rollen',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Maak een nieuwe rol en koppel deze aan groepen. Vervolgens kunt u rollen toewijzen aan gebruikers.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Er zijn geen rollen gedefiniëerd. Maak een nieuwe aan.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Beheer Rol-Groep koppelingen',
        'Roles' => 'Rollen',
        'Select the role:group permissions.' => 'Selecteer de rol-groep permissies.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Als niets is geselecteerd, heeft deze rol geen permissies op deze groep.',
        'Toggle %s permission for all' => 'Permissies %s aan/uit',
        'move_into' => 'verplaats naar',
        'Permissions to move tickets into this group/queue.' => 'Permissies om tickets naar deze groep/wachtrij te verplaatsen.',
        'create' => 'aanmaken',
        'Permissions to create tickets in this group/queue.' => 'Permissies om tickets in deze groep/wachtrij aan te maken.',
        'note' => 'notitie',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissies om notities aan tickets in de wachtrijen behorende bij deze groep toe te voegen.',
        'owner' => 'eigenaar',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissies om de eigenaar van de tickets in de wachtrijen behorende bij deze groep te wijzigen.',
        'priority' => 'prioriteit',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissies om de prioriteit van een ticket in deze groep/wachtrij te wijzigen.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Beheer Behandelaar-Rol koppelingen',
        'Add Agent' => 'Nieuwe behandelaar',
        'Filter for Agents' => 'Filter op behandelaars',
        'Filter for agents' => 'Filter op behandelaars',
        'Agents' => 'Behandelaars',
        'Manage Role-Agent Relations' => 'Beheer Rol-Behandelaar koppelingen',

        # Template: AdminSLA
        'SLA Management' => 'SLA beheer',
        'Edit SLA' => 'Bewerk SLA',
        'Add SLA' => 'Nieuwe SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Gebruik alleen cijfers.',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME beheer',
        'Add Certificate' => 'Nieuw certificaat',
        'Add Private Key' => 'Nieuwe private sleutel',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => 'Onjuiste SMIME configuratie',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => 'Controleer SMIME configuratie',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filter op certificaten',
        'To show certificate details click on a certificate icon.' => 'Klik op een certificaat icoon om de details van een certificaat weer te geven.',
        'To manage private certificate relations click on a private key icon.' =>
            'Om je privé certificaat relaties te beheren, klik je op een privé sleutel icoon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hier kun je relaties toevoegen aan je prive certificaten, deze worden in de S/MIME ondertekening meegezonden wanneer je dit certificaat gebruikt om e-mail te ondertekenen.',
        'See also' => 'Zie voor meer informatie',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Hier kunt u de certificaten en private sleutels van OTOBO beheren.',
        'Hash' => 'Hash',
        'Create' => 'Aanmaken',
        'Handle related certificates' => 'Beheer gekoppelde certificaten',
        'Read certificate' => 'Lees certificaat',
        'Delete this certificate' => 'Verwijder certificaat',
        'File' => 'Bestand',
        'Secret' => 'Geheim',
        'Related Certificates for' => 'Gekoppelde certificaten voor',
        'Delete this relation' => 'Verwijder deze koppeling',
        'Available Certificates' => 'Beschikbare certificaten',
        'Filter for S/MIME certs' => 'Filter voor S/MIME certificaten',
        'Relate this certificate' => 'Koppel dit certificaat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME Certificaat',
        'Certificate Details' => 'Certificaat details',
        'Close this dialog' => 'Sluit venster',

        # Template: AdminSalutation
        'Salutation Management' => 'Beheer aanheffen',
        'Add Salutation' => 'Nieuwe aanhef',
        'Edit Salutation' => 'Bewerk aanhef',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'bijv.',
        'Example salutation' => 'Aanhef voorbeeld',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode wordt normaal gesproken geactiveerd na afronding van de installatie.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Als Secure Mode nog niet actief is activeer dit via de Systeemconfiguratie omdat de applicatie al draait.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL console',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hier kun je SQL invoeren om direct naar de database te versturen. Het is niet mogelijk om de inhoud van de tabellen aan te passen, alleen select queries zijn toegestaan.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier kunt u SQL statements invoeren die direct door de database worden uitgevoerd.',
        'Options' => 'Opties',
        'Only select queries are allowed.' => 'Alleen select queries zijn toegestaan.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'De syntax van uw SQL query bevat een fout.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Er mist tenminste een parameter.',
        'Result format' => 'Uitvoeren naar',
        'Run Query' => 'Uitvoeren',
        '%s Results' => '',
        'Query is executed.' => 'Query is uitgevoerd.',

        # Template: AdminService
        'Service Management' => 'Service beheer',
        'Add Service' => 'Nieuwe service',
        'Edit Service' => 'Bewerk Service',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Onderdeel van',

        # Template: AdminSession
        'Session Management' => 'Sessies',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Alle sessies',
        'Agent sessions' => 'Behandelaar-sessies',
        'Customer sessions' => 'Klant-sessies',
        'Unique agents' => 'Unieke behandelaars',
        'Unique customers' => 'Unieke klanten',
        'Kill all sessions' => 'Alle sessies verwijderen',
        'Kill this session' => 'Verwijder deze sessie',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Sessie',
        'Kill' => 'Verwijder',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Handtekening-beheer',
        'Add Signature' => 'Nieuwe handtekening',
        'Edit Signature' => 'Bewerk handtekening',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Handtekening-voorbeeld',

        # Template: AdminState
        'State Management' => 'Status beheer',
        'Add State' => 'Nieuwe status',
        'Edit State' => 'Bewerk status',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Let op',
        'Please also update the states in SysConfig where needed.' => 'Pas ook de namen van de status aan in SysConfig waar nodig.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Status type',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => 'Deze status wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => 'Schakel Cloud Diensten in',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Je kunt handmatig de Support Data versturen door op deze knop te sturen:',
        'Send Update' => 'Verstuur Update',
        'Currently this data is only shown in this system.' => 'Op dit moment worden deze gegevens alleen in dit systeem weergegeven.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Een support bundel kan gegenereerd worden door op deze knop te drukken (inclusief: systeem registratie informatie, ondersteuningsgegevens, een lijst met geïnstalleerde pakketen en alle lokaal aanepaste bronconde bestanden).',
        'Generate Support Bundle' => 'Genereer support bundel',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Kies één van de volgende opties.',
        'Send by Email' => 'Verstur via Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'De support bundel is te groot om te verstuen per mail, deze optie is niet beschikbaar.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Het e-mail adres voor deze gebruiker is ongeldig, deze optie is niet beschikbaar.',
        'Sending' => 'Afzender',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => 'Download bestand',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Fout: Support gegevens konden niet worden verzameld (%s).',
        'Details' => 'Details',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add System Email Address' => 'Nieuw e-mailadres',
        'Edit System Email Address' => 'Bewerk e-mailadres',
        'Add System Address' => 'Nieuw systeem adres',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle inkomende berichten met dit adres in Aan of CC worden toegewezen aan de geselecteerde wachtrij.',
        'Email address' => 'E-mailadres',
        'Display name' => 'Weergegeven naam',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'De weergegeven naam en het e-mailadres worden gebruikt voor uitgaande mail.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'online administrator documentatie',
        'System configuration' => 'Systeemconfiguratie',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => 'Zoek in alle instellingen...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => 'Help',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => 'Gemaakte Wijzigingen',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => 'Geselecteerde wijzigingen uitrollen',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => '',
        'Filter for Deployments' => '',
        'Recent Deployments' => '',
        'Restore' => '',
        'View Details' => '',
        'Restore this deployment.' => '',
        'Export this deployment.' => '',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => '',
        'by' => 'door',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importeren & Exporteren',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => 'Upload systeemconfiguratie',
        'Import system configuration' => 'Importeer systeemconfiguratie',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Zoek naar',
        'Search for category' => '',
        'Settings I\'m currently editing' => 'Instellingen die ik momenteel bewerk',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => 'U bewerkt momenteel geen instellingen.',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Categorie',
        'Run search' => 'Voer zoekopdracht uit',

        # Template: AdminSystemConfigurationSettingHistoryDetails
        'Change History' => '',
        'Change History of %s' => '',
        'No modified values for this setting, the default value is used.' =>
            '',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => '',
        'Users Value' => '',
        'For' => '',
        'Delete all user values.' => '',
        'No user value for this setting.' => '',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systeem onderhoudsbeheer.',
        'Schedule New System Maintenance' => 'Plan een nieuw systeem onderhoud.',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Plan een systeem onderhoudsperiode om aan Agents en Klanten aan te kondigen dat het systeem voor een bepaalde periode down is.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Een bepaalde tijd voordat het systeem onderhoud begint krijgen de gebruikers een melding op elk scherm waarin het onderhoud wordt aangekondigd.',
        'Stop date' => 'Einddatum',
        'Delete System Maintenance' => 'Verwijder Systeemonderhoudstijdsvak.',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Ongeldige datum.',
        'Login message' => 'Login bericht',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Toon login bericht',
        'Notify message' => 'Melding bericht',
        'Manage Sessions' => 'Beheer sessies',
        'All Sessions' => 'Alle Sessies',
        'Agent Sessions' => 'Gebruikerssessies',
        'Customer Sessions' => 'Klant Sessies',
        'Kill all Sessions, except for your own' => 'Stop alle sessies, behalve die van jezelf',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Nieuw sjabloon',
        'Edit Template' => 'Bewerk sjabloon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Een sjabloon is een standaardtext die uw behandelaars helpt sneller tickets aan te maken of te beantwoorden.',
        'Don\'t forget to add new templates to queues.' => 'Vergeet niet de sjablonen aan wachtrijen te koppelen.',
        'Attachments' => 'Bijlagen',
        'Delete this entry' => 'Verwijder antwoord',
        'Do you really want to delete this template?' => 'Wilt u deze template echt verwijderen?',
        'A standard template with this name already exists!' => 'Er bestaat al een standaard template met deze naam!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Sjablonen van het type \'Aanmaken\' ondersteunen alleen deze tags',
        'Example template' => 'Voorbeeld-sjabloon',
        'The current ticket state is' => 'De huidige ticketstatus is',
        'Your email address is' => 'Uw e-mailadres is',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Actief aan/uit voor alles',
        'Link %s to selected %s' => 'Koppel %s aan %s',

        # Template: AdminType
        'Type Management' => 'Type beheer',
        'Add Type' => 'Nieuw type',
        'Edit Type' => 'Bewerk type',
        'Filter for Types' => 'Filter voor Types',
        'Filter for types' => 'Filter voor types',
        'A type with this name already exists!' => 'Er bestaat al een type met deze naam!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Beheer behandelaars',
        'Edit Agent' => 'Bewerk behandelaar',
        'Edit personal preferences for this agent' => 'Persoonlijke instellingen voor deze behandelaar bewerken',
        'Agents will be needed to handle tickets.' => 'Behandelaar-accounts zijn nodig om te kunnen werken in het systeem.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'vergeet niet om een behandelaar aan groepen en/of rollen te koppelen.',
        'Please enter a search term to look for agents.' => 'Typ om te zoeken naar behandelaars.',
        'Last login' => 'Laatst ingelogd',
        'Switch to agent' => 'Omschakelen naar behandelaar',
        'Title or salutation' => 'Titel of Aanhef',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'A user with this username already exists!' => 'Er bestaat al een gebruiker met deze naam!',
        'Will be auto-generated if left empty.' => 'Zal automatisch worden gegenereerd indien leeg.',
        'Mobile' => 'Mobiel',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => 'Deze behandelaar heeft geen groepsrechten',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Beheer Behandelaar-Groep koppelingen',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => 'Kalenders beheren',
        'Add Appointment' => 'Nieuwe Afspraak',
        'Today' => 'Vandaag',
        'All-day' => 'de gehele dag',
        'Repeat' => 'Herhaal',
        'Notification' => 'Melding',
        'Yes' => 'Ja',
        'No' => 'Nee',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Nieuwe afspraak toevoegen',
        'Calendars' => 'Kalenders',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Basis informatie',
        'Date/Time' => 'Datum/Tijd',
        'Invalid date!' => 'Geen geldige datum.',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => 'Elke',
        'day(s)' => 'dag(en)',
        'week(s)' => 'weken',
        'month(s)' => 'maand(en)',
        'year(s)' => 'jaren',
        'On' => 'Aan',
        'Monday' => 'maandag',
        'Mon' => 'ma',
        'Tuesday' => 'dinsdag',
        'Tue' => 'di',
        'Wednesday' => 'woensdag',
        'Wed' => 'wo',
        'Thursday' => 'donderdag',
        'Thu' => 'do',
        'Friday' => 'vrijdag',
        'Fri' => 'vr',
        'Saturday' => 'zaterdag',
        'Sat' => 'za',
        'Sunday' => 'zondag',
        'Sun' => 'zo',
        'January' => 'januari',
        'Jan' => 'jan',
        'February' => 'februari',
        'Feb' => 'feb',
        'March' => 'maart',
        'Mar' => 'mrt',
        'April' => 'april',
        'Apr' => 'apr',
        'May_long' => 'mei',
        'May' => 'mei',
        'June' => 'juni',
        'Jun' => 'jun',
        'July' => 'juli',
        'Jul' => 'jul',
        'August' => 'augustus',
        'Aug' => 'aug',
        'September' => 'september',
        'Sep' => 'sep',
        'October' => 'oktober',
        'Oct' => 'okt',
        'November' => 'november',
        'Nov' => 'nov',
        'December' => 'december',
        'Dec' => 'dec',
        'Relative point of time' => '',
        'Link' => 'Koppel',
        'Remove entry' => 'Verwijder sleutel',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Klantinformatie overzicht',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Klant',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Let op: klant is ongeldig!',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Klantgebruiker adresboek',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Sjabloon',
        'Create Template' => 'Maak sjabloon',
        'Create New' => 'Nieuw',
        'Save changes in template' => 'Sla wijzigingen op in sjabloon',
        'Filters in use' => 'Filters in gebruik',
        'Additional filters' => 'Extra filters',
        'Add another attribute' => 'Voeg attribuut toe',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '(bv. Term* of *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Selecteer alles',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => 'Selecteer deze klantgebruiker',
        'Add selected customer user to' => 'Voeg geselecteerde klantgebruiker toe aan',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Verander zoekopties',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Klant gebruiker informatie overzicht',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'De OTOBO Daemon is een achtergrondproces dat a synchrone taken uitvoert, dat wil zeggen, escalatie van tickets, gebeurtenissen, emails en dergelijke.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Een draaiende OTOBO Daemon is vereist voor een correcte werking van het systeem.',
        'Starting the OTOBO Daemon' => 'De OTOBO Daemon wordt opgestart',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Zorg er voor dat het bestand \'%s\' bestaat (zonder .dist extensie). Deze cron taak controleert elke 5 minuten of de OTOBO Daemon loopt en start hem als het nodig is.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Voer \'%s start\' uit om ervoor te zorgen dat de cron jobs van de gebruiker \'otobo\' actief zijn.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Controleer na 5 minuten of de OTOBO Daemon draait in het systeem (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nieuwe Afspraak',
        'Tomorrow' => 'Morgen',
        'Soon' => 'Binnenkort',
        '5 days' => '5 dagen',
        'Start' => 'Begin',
        'none' => 'geen',

        # Template: AgentDashboardCalendarOverview
        'in' => 'over',

        # Template: AgentDashboardCommon
        'Save settings' => 'Instellingen opslaan',
        'Close this widget' => 'Sluit deze widget',
        'more' => 'meer',
        'Available Columns' => 'Beschikbare kolommen',
        'Visible Columns (order by drag & drop)' => 'Beschikbare kolommen (sorteer door middel van drag & drop)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Bewerk klant koppelingen',
        'Open' => 'Open',
        'Closed' => 'Gesloten',
        '%s open ticket(s) of %s' => '%s open ticket(s) van %s',
        '%s closed ticket(s) of %s' => '%s gesloten ticket(s) van %s',
        'Edit customer ID' => 'Klantcode aanpassen',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Geëscaleerde tickets',
        'Open tickets' => 'Open tickets',
        'Closed tickets' => 'Gesloten tickets',
        'All tickets' => 'Alle tickets',
        'Archived tickets' => 'Gearchiveerde tickets',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Klantgebruiker informatie',
        'Phone ticket' => 'Telefoon-ticket',
        'Email ticket' => 'E-mail-ticket',
        'New phone ticket from %s' => 'Nieuw telefoonticket van %s',
        'New email ticket to %s' => 'Nieuw emailticket aan %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is beschikbaar.',
        'Please update now.' => 'Voer nu een update uit.',
        'Release Note' => 'Releasenote',
        'Level' => 'Soort',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Geplaatst %s geleden.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'De configuratie voor deze statistieken widget bevat fouten, controleer je instelingen.',
        'Download as SVG file' => 'Download als SVG file',
        'Download as PNG file' => 'Download als PNG file',
        'Download as CSV file' => 'Download als CSV file',
        'Download as Excel file' => 'Download als Excel file',
        'Download as PDF file' => 'Download als PDF file',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Selecteer een geldige grafiek output format in de configuratie van deze widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'De inhoud van deze rapportage wordt voor u aangemaakt, even geduld.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Deze statistiek kan op dit moment niet worden gebruikt omdat de configuratie gecorrigeerd moet worden door de statistieken administrator. ',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Mijn vergrendelde tickets',
        'My watched tickets' => 'Mijn gevolgde tickets',
        'My responsibilities' => 'Tickets waarvoor ik verantwoordelijk ben',
        'Tickets in My Queues' => 'Tickets in mijn wachtrijen',
        'Tickets in My Services' => 'Tickets in mijn services',
        'Service Time' => 'Service tijd',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Totaal',

        # Template: AgentDashboardUserOnline
        'out of office' => 'afwezigheid',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'tot',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Terug',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Om een tekst te tonen, zoals nieuws of een licentie, die de agent moet accepteren.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => 'Bestaande koppelingen beheren',
        'Link with' => 'Koppel met',
        'Start search' => 'Begin met zoeken',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Wachtwoord wijzigen',
        'Current password' => 'Huidig wachtwoord',
        'New password' => 'Nieuw wachtwoord',
        'Repeat new password' => '',
        'Password needs to be renewed every %s days.' => '',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            '',
        'Password length must be at least %s characters.' => '',
        'Password requires at least two lower- and two uppercase characters.' =>
            '',
        'Password requires at least two characters.' => '',
        'Password requires at least one digit.' => '',
        'Change config options' => '',
        'Admin permissions are required!' => '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Bewerk uw voorkeuren',
        'Personal Preferences' => 'Eigen voorkeuren',
        'Preferences' => 'Voorkeuren',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Hier stelt u uw eigen voorkeuren in. Bewaar uw wijzigingen door op het vinkje dat rechts staat te klikken',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => 'Dynamische Acties',
        'Filter settings...' => 'Filter instellingen...',
        'Filter for settings' => '',
        'Save all settings' => 'Alle instellingen opslaan',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Avatars zijn uitgeschakeld door de systeembeheerder. Uw initialen worden gebruikt.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'U kunt uw eigen avatar afbeeling registreren door uw e-mail adres   %s op %s te gebruiken. Let op: het kan enige tijd duren voordat uw avatar beschikbaar is vanwege buffering.',
        'Off' => 'Uit',
        'End' => 'Einde',
        'This setting can currently not be saved.' => 'Deze instelling kan op dit moment niet worden opgeslagen.',
        'This setting can currently not be saved' => 'Deze instelling kan op dit moment niet worden opgeslagen',
        'Save this setting' => 'Sla deze instelling op',
        'Did you know? You can help translating OTOBO at %s.' => 'Wist je dat je kunt helpen om OTOBO te vertalen via %s?',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => 'Wist je dat?',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => 'Proces',
        'Split' => 'Splits',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Statistiekbeheer',
        'Add Statistics' => 'Statistieken toevoegen',
        'Read more about statistics in OTOBO' => 'Lees meer over statistieken in OTOBO',
        'Dynamic Matrix' => 'Dynamische matrix',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Dynamische lijst',
        'Each row contains data of one entity.' => '',
        'Static' => 'Statistiek',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'Algemene specificatie',
        'Create Statistic' => 'Maak statistiek',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Statistieken bewerken',
        'Run now' => 'Voer nu uit',
        'Statistics Preview' => 'Voorbeeld van rapportages',
        'Save Statistic' => 'Statistieken opslaan',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Statistieken importeren',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiek',
        'Run' => 'Voer uit',
        'Edit statistic "%s".' => 'Bewerk rapportage "%s".',
        'Export statistic "%s"' => 'Exporteer rapportage "%s"',
        'Export statistic %s' => 'Exporteer Rapportage %s',
        'Delete statistic "%s"' => 'Verwijder rapportage "%s"',
        'Delete statistic %s' => 'Verwijder rapportage %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Statistieken overzicht',
        'View Statistics' => 'Statistieken bekijken',
        'Statistics Information' => '',
        'Created by' => 'Aangemaakt door',
        'Changed by' => 'Gewijzigd door',
        'Sum rows' => 'Toon totaal per rij',
        'Sum columns' => 'Toon totaal per kolom',
        'Show as dashboard widget' => 'Toon als dashboard-widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Deze rapportage bevat configuratiefouten en kan niet worden gebruikt',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => 'Verander de eigenaar van %s %s %s',
        'Close %s%s%s' => 'Sluit %s%s%s',
        'Add Note to %s%s%s' => 'Voeg notitie aan %s%s%s',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => 'Wijzig de prioriteit van %s%s%s',
        'Change Responsible of %s%s%s' => 'Wijzig de verantwoordelijke van %s%s%s',
        'The ticket has been locked' => 'Het ticket is vergrendeld',
        'Undo & close' => 'Ongedaan maken & sluiten',
        'Ticket Settings' => 'Ticket instellingen',
        'Queue invalid.' => 'Wachtrij ongeldig',
        'Service invalid.' => 'Service is ongeldig.',
        'SLA invalid.' => 'SLA ongeldig',
        'New Owner' => 'Nieuwe eigenaar',
        'Please set a new owner!' => 'Kies een nieuwe eigenaar.',
        'Owner invalid.' => 'Eigenaar ongeldig',
        'New Responsible' => 'Nieuwe verantwoordelijke',
        'Please set a new responsible!' => 'Kies een nieuwe verantwoordelijke!',
        'Responsible invalid.' => 'Verantwoordelijke ongeldig',
        'Next state' => 'Status',
        'State invalid.' => 'Status ongeldig',
        'For all pending* states.' => 'Voor alle cases die staan te wachten',
        'Add Article' => 'Voeg Artikel toe',
        'Create an Article' => 'Maak een Artikel',
        'Inform agents' => 'Stel gebruikers op de hoogte',
        'Inform involved agents' => 'Stel betrokken gebruikers op de hoogte',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hier kun je extra gebruikers aanvinken die een notificatie zouden moeten krijgen over het nieuwe artikel.',
        'Text will also be received by' => '',
        'Text Template' => 'Tekstsjabloon',
        'Setting a template will overwrite any text or attachment.' => 'Het instellen van een template overschrijft alle testen en bijlagen.',
        'Invalid time!' => 'Geen geldige tijd.',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Bounce naar',
        'You need a email address.' => 'E-mailadres is verplicht.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Een e-mailadres is verplicht. U kunt geen lokale adressen gebruiken.',
        'Next ticket state' => 'Status',
        'Inform sender' => 'Informeer afzender',
        'Send mail' => 'Bericht versturen',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket bulk-actie',
        'Send Email' => 'Stuur e-mail',
        'Merge' => 'Samenvoegen',
        'Merge to' => 'Voeg samen met',
        'Invalid ticket identifier!' => 'Ongeldige ticket identifier.',
        'Merge to oldest' => 'Voeg samen met oudste',
        'Link together' => 'Koppelen',
        'Link to parent' => 'Koppel aan vader',
        'Unlock tickets' => 'Ontgrendel tickets',
        'Execute Bulk Action' => 'Bulkactie uitvoeren',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            'Dit adres is geregistreerd als een systee adres en kan niet worden gebruikt.',
        'Please include at least one recipient' => 'Voeg tenminste één ontvanger toe',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => 'Klantgebruiker adresboek',
        'Remove Ticket Customer' => 'Verwijder ',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Verwijder deze en geef een nieuwe met een correcte waarde.',
        'This address already exists on the address list.' => 'Dit adres is al toegevoegd.',
        'Remove Cc' => 'Verwijder CC',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Verwijder BCC',
        'Date Invalid!' => 'Datum ongeldig.',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Wijzig klant van %s%s%s',
        'Customer Information' => 'Klantinformatie',
        'Customer user' => 'Klant',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Maak nieuw e-mail ticket',
        'Example Template' => 'Voorbeeld Template',
        'To customer user' => 'Aan klant',
        'Please include at least one customer user for the ticket.' => 'Selecteer tenminste een klant voor dit ticket.',
        'Select this customer as the main customer.' => 'Selecteer deze klant als hoofd-klant',
        'Remove Ticket Customer User' => 'Verwijder klant van ticket',
        'From queue' => 'In wachtrij',
        'Get all' => 'Gebruik alle',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: eerste antwoord tijd is voorbij (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: eerste antwoord tijd zal voorbij zijn binnen %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket $s: vervolg tijd zal voorbij zijn binnen %s.',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: oplossing tijd is voorbij (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: oplossing tijd zal voorbij zijn binnen %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'Aangemaakt op',
        'Article' => 'Interactie',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Samenvoegen %s%s%s',
        'Merge Settings' => 'Samenvoegingsinstellingen',
        'You need to use a ticket number!' => 'Gebruik een ticketnummer.',
        'A valid ticket number is required.' => 'Een geldig ticketnummer is verplicht.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => 'Beperk de zoekopdracht tot tickets met dezelfde klantcode (%s).',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Geen geldig e-mailadres.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Nieuwe wachtrij',
        'Move' => 'Verplaatsen',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Geen tickets gevonden.',
        'Open / Close ticket action menu' => 'Open / Sluit ticket actie menu',
        'Select this ticket' => 'Selecteer dit ticket',
        'Sender' => 'Afzender',
        'First Response Time' => 'Eerste reactie',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossingstijd',
        'Move ticket to a different queue' => 'Verplaats naar nieuwe wachtrij',
        'Change queue' => 'Verplaats naar wachtrij',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Verwijder actieve filters voor dit scherm.',
        'Tickets per page' => 'Tickets per pagina',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Kanaal ontbreekt',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Herstel overzicht',
        'Column Filters Form' => 'Kolom filter formulier',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Splits in nieuw telefoon ticket',
        'Save Chat Into New Phone Ticket' => 'Bewaar chat in nieuw telefoon ticket',
        'Create New Phone Ticket' => 'Maak nieuw telefoon ticket aan',
        'Please include at least one customer for the ticket.' => 'Voeg ten minste één klant toe voor dit ticket.',
        'To queue' => 'In wachtrij',
        'Chat protocol' => 'Chat protocol',
        'The chat will be appended as a separate article.' => 'De chat wordt toegevoegd als een apart artikel',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Zonder opmaak',
        'Download this email' => 'Download deze e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Nieuw proces-ticket',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Voeg ticket toe aan een proces',

        # Template: AgentTicketSearch
        'Profile link' => 'Koppeling naar sjabloon',
        'Output' => 'Uitvoeren naar',
        'Fulltext' => 'Volledig',
        'Customer ID (complex search)' => 'Klantcode (complexe zoekopdracht)',
        '(e. g. 234*)' => '(bv. 234*)',
        'Customer ID (exact match)' => 'Klantcode (exacte overeenkomst)',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '(bv. U51*)',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Lock state' => 'Vergrendeling',
        'Watcher' => 'Volger',
        'Article Create Time (before/after)' => 'Aanmaaktijd interactie (voor/na)',
        'Article Create Time (between)' => 'Aanmaaktijd interactie (tussen)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Aanmaaktijd ticket (voor/na)',
        'Ticket Create Time (between)' => 'Aanmaaktijd ticket (tussen)',
        'Ticket Change Time (before/after)' => 'Ticket gewijzigd (voor/na)',
        'Ticket Change Time (between)' => 'Ticket gewijzigd (tussen)',
        'Ticket Last Change Time (before/after)' => 'Meest recente ticket wijziging (voor/na)',
        'Ticket Last Change Time (between)' => 'Meest recente ticket wijziging (tussen)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Ticket gesloten (voor/na)',
        'Ticket Close Time (between)' => 'Ticket gesloten (tussen)',
        'Ticket Escalation Time (before/after)' => 'Ticket escalatietijd (voor/na)',
        'Ticket Escalation Time (between)' => 'Ticket escaltietijd (tussen)',
        'Archive Search' => 'Zoek in archief',

        # Template: AgentTicketZoom
        'Sender Type' => 'Soort verzender',
        'Save filter settings as default' => 'Sla filter op als standaard',
        'Event Type' => 'Gebeurtenis type',
        'Save as default' => 'Opslaan als standaard',
        'Drafts' => 'Concepten',
        'Change Queue' => 'Wijzig wachtrij',
        'There are no dialogs available at this point in the process.' =>
            'Op dit moment zijn er geen dialogen beschikbaar.',
        'This item has no articles yet.' => 'Dit item heeft nog geen interacties.',
        'Ticket Timeline View' => 'Ticket tijdslijn weergave',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Nieuw filter',
        'Set' => 'Nieuwe waarden',
        'Reset Filter' => 'Herstel filter',
        'No.' => 'Nr.',
        'Unread articles' => 'Ongelezen interacties',
        'Via' => 'Via',
        'Important' => 'Belangrijk',
        'Unread Article!' => 'Ongelezen interactie.',
        'Incoming message' => 'Binnenkomend bericht',
        'Outgoing message' => 'Uitgaand bericht',
        'Internal message' => 'Intern bericht',
        'Sending of this message has failed.' => 'Versturen van dit bericht is mislukt.',
        'Resize' => 'Grootte wijzigen',
        'Mark this article as read' => 'Markeer het artikel als gelezen',
        'Show Full Text' => 'Geef volledige tekst weer',
        'Full Article Text' => 'Volledige artikel tekst',
        'No more events found. Please try changing the filter settings.' =>
            'Geen events meer gevonden. Probeer de filter instellingen aan te passen.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'via %s',
        'by %s' => 'door %s',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Om links te openen in het volgende artikel, kan het nodig zijn om de toetsen Ctrl of Cmd of Shift in te druken terwijl je op de link klikt (afhankelijk van jouw browser en besturingssysteem)',
        'Close this message' => 'Sluit dit bericht',
        'Image' => 'Afbeelding',
        'PDF' => 'PDF',
        'Unknown' => 'Onbekend',
        'View' => 'Weergave',

        # Template: LinkTable
        'Linked Objects' => 'Gekoppelde objecten',

        # Template: TicketInformation
        'Archive' => 'Archief',
        'This ticket is archived.' => 'Dit ticket is gearchiveerd.',
        'Note: Type is invalid!' => 'Let op: Type is ongeldig!',
        'Pending till' => 'In de wacht tot',
        'Locked' => 'Vergrendeling',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Bestede tijd',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Om uw privacy te beschermen is actieve inhoud geblokkeerd.',
        'Load blocked content.' => 'Laad actieve inhoud.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'U kunt',
        'go back to the previous page' => 'terug naar de vorige pagina',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => 'Nieuw ticket',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Error gegevens',
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript niet beschikbaar',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Waarschuwing',
        'The browser you are using is too old.' => 'De browser die u gebruikt is te oud.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Zie de documentatie of vraag uw beheerder voor meer informatie.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'Een moment alstublieft, je wordt doorverwezen',
        'Login' => 'Inloggen',
        'Your user name' => 'Uw gebruikersnaam',
        'User name' => 'Gebruikersnaam',
        'Your password' => 'Uw wachtwoord',
        'Forgot password?' => 'Wachtwoord vergeten?',
        'Your 2 Factor Token' => 'Uw 2 stappen code',
        '2 Factor Token' => '2 stappen code',
        'Log In' => 'Inloggen',
        'Request Account' => '',
        'Request New Password' => 'Vraag nieuw wachtwoord aan',
        'Your User Name' => 'Uw gebruikersnaam',
        'A new password will be sent to your email address.' => 'Een nieuw wachtwoord wordt naar uw e-mailadres verzonden.',
        'Create Account' => 'Maak account',
        'Please fill out this form to receive login credentials.' => 'Vul dit formulier in om een gebruikersnaam aan te maken.',
        'How we should address you' => 'Hoe moeten we u adresseren?',
        'Your First Name' => 'Uw voornaam',
        'Your Last Name' => 'Uw achternaam',
        'Your email address (this will become your username)' => 'Uw e-mailadres (dit wordt uw gebruikersnaam)',

        # Template: CustomerNavigationBar
        'Logout' => 'Afmelden',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Welkom!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Pagina',
        'Tickets' => 'Tickets',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Sjabloon',
        'e. g. 10*5155 or 105658*' => 'bijv. 2010*5155 of 20100802*',
        'CustomerID' => 'Klantcode',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Typen',
        'Time Restrictions' => '',
        'No time settings' => 'Niet zoeken op tijd',
        'All' => 'Alle',
        'Specific date' => 'Specifieke datum',
        'Only tickets created' => 'Alleen tickets aangemaakt',
        'Date range' => 'Datum range',
        'Only tickets created between' => 'Alleen tickets aangemaakt tussen',
        'Ticket Archive System' => 'Ticket archievering',
        'Save Search as Template?' => 'Zoekopdracht opslaan als sjabloon?',
        'Save as Template?' => 'Bewaar als sjabloon?',
        'Save as Template' => 'Bewaar',
        'Template Name' => 'Template naam',
        'Pick a profile name' => 'Naam voor dit sjabloon',
        'Output to' => 'Uitvoer naar',

        # Template: CustomerTicketSearchResultShort
        'of' => 'van',
        'Search Results for' => 'Zoekresultaat voor',
        'Remove this Search Term.' => 'Verwijder deze zoekterm',

        # Template: CustomerTicketZoom
        'Reply' => 'Beantwoord',
        'Discard' => '',
        'Ticket Information' => 'Ticket-informatie',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => 'Toon interactie',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Waarschuwing',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Event informatie',
        'Ticket fields' => 'Ticket-velden',

        # Template: Error
        'Send a bugreport' => 'Een bug report indienen',
        'Expand' => 'Klap uit',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => 'Concept bijwerken',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'Edit personal preferences' => 'Eigen voorkeuren bewerken',
        'Personal preferences' => 'Eigen voorkeuren',
        'You are logged in as' => 'Ingelogd als',

        # Template: Installer
        'JavaScript not available' => 'JavaScript is niet beschikbaar',
        'Step %s' => 'Stap %s',
        'License' => 'Licentie',
        'Database Settings' => 'Database configuratie',
        'General Specifications and Mail Settings' => 'Algemene instellingen en mailconfiguratie',
        'Finish' => 'Voltooien',
        'Welcome to %s' => 'Welkom bij %s',
        'Germany' => 'Duitsland',
        'Phone' => 'Telefoon',
        'Switzerland' => '',
        'Web site' => 'Website',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configureer uitgaande mail',
        'Outbound mail type' => 'Uitgaande mail type',
        'Select outbound mail type.' => 'Selecteer e-mail soort.',
        'Outbound mail port' => 'Uitgaande mail poort',
        'Select outbound mail port.' => 'Kies de TCP poort voor uitgaand e-mail verkeer.',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP authenticatie',
        'Does your SMTP host need authentication?' => 'Heeft uw SMTP host authenticatie nodig?',
        'SMTP auth user' => 'SMTP auth user',
        'Username for SMTP auth.' => 'Login voor SMTP authenticatie',
        'SMTP auth password' => 'SMTP auth password',
        'Password for SMTP auth.' => 'Wachtwoord voor SMTP authenticatie',
        'Configure Inbound Mail' => 'Configureer binnenkomende mail',
        'Inbound mail type' => 'Ingaande mail type',
        'Select inbound mail type.' => 'Selecteer e-mail soort.',
        'Inbound mail host' => 'Ingaande mail host',
        'Inbound mail host.' => 'Hostnaam mailserver voor inkomende mail.',
        'Inbound mail user' => 'User',
        'User for inbound mail.' => 'Login voor inkomende mail server.',
        'Inbound mail password' => 'Password',
        'Password for inbound mail.' => 'Wachtwoord voor inkomende mail server.',
        'Result of mail configuration check' => 'Resultaat van mailconfiguratie test',
        'Check mail configuration' => 'Test mailconfiguratie',
        'Skip this step' => 'Sla dit over',

        # Template: InstallerDBResult
        'Done' => 'Klaar',
        'Error' => 'Fout',
        'Database setup successful!' => 'Database-installatie afgerond.',

        # Template: InstallerDBStart
        'Install Type' => 'Installatie-type',
        'Create a new database for OTOBO' => 'Maak een nieuwe database voor OTOBO aan',
        'Use an existing database for OTOBO' => 'Gebruik een bestaande database voor OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Als er een root-wachtwoord voor deze database nodig is, vul deze hier in. Anders moet dit veld leeg blijven.',
        'Database name' => 'Database-naam',
        'Check database settings' => 'Test database instellingen',
        'Result of database check' => 'Resultaat van database test',
        'Database check successful.' => 'Database controle gelukt.',
        'Database User' => 'Database-gebruiker',
        'New' => 'Nieuw',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Een nieuwe database gebruiker met beperkte permissies wordt aangemaakt voor deze OTOBO omgeving.',
        'Repeat Password' => 'Herhaal wachtwoord',
        'Generated password' => 'Gegenereerd wachtwoord',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Wachtwoorden komen niet overeen',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Om OTOBO te gebruiken moet u nu de webserver herstarten.',
        'Restart your webserver' => 'Herstart webserver',
        'After doing so your OTOBO is up and running.' => 'Hierna is OTOBO klaar voor gebruik.',
        'Start page' => 'Inlogpagina',
        'Your OTOBO Team' => 'Het OTOBO team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Licentie niet accepteren',
        'Accept license and continue' => 'Accepteer licentie en ga door',

        # Template: InstallerSystem
        'SystemID' => 'Systeem identificatie',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'De identifier van het systeem. Ieder ticketnummer en elk HTTP sessie ID bevat dit nummer.',
        'System FQDN' => 'OTOBO FQDN',
        'Fully qualified domain name of your system.' => 'Fully Qualified Domain Name van het systeem.',
        'AdminEmail' => 'E-mailadres beheerder',
        'Email address of the system administrator.' => 'E-mailadres van de beheerder.',
        'Organization' => 'Organisatie',
        'Log' => 'Log',
        'LogModule' => 'Logmodule',
        'Log backend to use.' => 'Te gebruiken logbestand.',
        'LogFile' => 'Logbestand',
        'Webfrontend' => 'Web Frontend',
        'Default language' => 'Standaard taal',
        'Default language.' => 'Standaard taal.',
        'CheckMXRecord' => 'Check MX Record',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-mailadressen die handmatig worden ingevoerd worden gecontroleerd met de MX records gevonden in de DNS. Gebruik deze mogelijkheid niet als uw DNS traag is of geen publieke adressen kan herleiden.',

        # Template: LinkObject
        'Delete link' => 'Koppeling verwijderen',
        'Delete Link' => 'Koppeling verwijderen',
        'Object#' => 'Object#',
        'Add links' => 'Links toevoegen',
        'Delete links' => 'Links verwijderen',

        # Template: Login
        'Lost your password?' => 'Wachtwoord vergeten?',
        'Back to login' => 'Terug naar inlogscherm',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => 'Open URL in nieuw tabblad',
        'Close preview' => 'Voorvertoning sluiten',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Een preview is niet beschikbaar omdat het geen embedding toestaat. ',

        # Template: Copy
        'Start migration' => '',
        'Result of data migration' => '',
        'Last successful task:' => '',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            '',
        'Clean up and finish' => '',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            '',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            '',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            '',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            '',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            '',
        'All entered passwords are cached until the migration is finished.' =>
            '',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            '',
        'If you need support, just ask our experts – either at' => '',
        'OTOBO forum' => '',
        'or directly via mail to' => '',
        'Cached data found' => '',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            '',
        'An error occured.' => '',
        'Discard previous progress' => '',
        'Insecure HTTP connection' => '',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            '',
        'Continue anyways :(' => '',
        ' Continue anyways :(' => '',

        # Template: OTRSFileSettings
        'OTRS server' => '',
        'SSH User' => '',
        'OTRS home directory' => '',
        'Check settings' => '',
        'Result of settings check' => '',
        'Settings check successful.' => '',

        # Template: PreChecks
        'Execute migration pre-checks' => '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Functionaliteit niet beschikbaar',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Helaas, maar deze functionaliteit van OTOBO is op dit moment niet beschikbaar voor mobiele apparaten. Als je de functionaliteit toch wil gebruiken kun je swichen naar desktop weergave of je desktop device gebruiken.',

        # Template: Motd
        'Message of the Day' => 'Bericht van de dag',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Onvoldoende permissies',
        'Back to the previous page' => 'Terug naar de vorige pagina',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Draait op',

        # Template: Pagination
        'Show first page' => 'Toon eerste pagina',
        'Show previous pages' => 'Toon vorige pagina\'s',
        'Show page %s' => 'Toon pagina %s',
        'Show next pages' => 'Toon volgende pagina\'s',
        'Show last page' => 'Toon laatste pagina',

        # Template: PictureUpload
        'Need FormID!' => 'Geen FormID gevonden.',
        'No file found!' => 'Geen bestand gevonden.',
        'The file is not an image that can be shown inline!' => 'Dit bestand kan niet inline worden weergegeven.',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Door de eindgebruiker instelbare meldingen gevonden.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Ontvang berichten voor meldingen \'%s\' via transport methode \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Procesinformatie',
        'Dialog' => 'Dialoog',

        # Template: Article
        'Inform Agent' => 'Informeer behandelaar',

        # Template: PublicDefault
        'Welcome' => 'Wekom',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissies',
        'You can select one or more groups to define access for different agents.' =>
            'U kunt één of meerdere groepen definiëren die deze rapportage kunnen gebruiken.',
        'Result formats' => 'Resultaat formulieren',
        'Time Zone' => 'Tijdzone',
        'The selected time periods in the statistic are time zone neutral.' =>
            'De geselecteerd tijdsperiode in de statistieken zijn tijdzone neutraal.',
        'Create summation row' => 'Voeg somrij toe',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => 'Voeg somkolom toe',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'Cace resultaten',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Maak een dashboard-widget van dit rapport die behandelaars in hun dashboard kunnen activeren.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Inschakelen van de dashboard widget activeert caching voor dit rapport  in het dashboard.',
        'If set to invalid end users can not generate the stat.' => 'Als deze op ongeldig staat, kan het rapport niet gebruikt worden.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Er zijn problemen met de configuratie van dit rapport:',
        'You may now configure the X-axis of your statistic.' => 'Je kun nu de X-as instellen van jouw rapport.',
        'This statistic does not provide preview data.' => 'Dit rapport geeft geen voorbeeldgegevens.',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'De voorbeeldweergave gebruikt willekeurige gegevens en houdt geen rekening met data filters.',
        'Configure X-Axis' => 'Configureer X-As',
        'X-axis' => 'X-as',
        'Configure Y-Axis' => 'Configureer Y-As',
        'Y-axis' => 'Y-As',
        'Configure Filter' => 'Configureer filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Kies een element, of schakel de optie \'Statisch\' uit.',
        'Absolute period' => 'Absolute periode',
        'Between %s and %s' => '',
        'Relative period' => 'Relatieve periode',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'De historische complete %s en de huidige en aankomende complete %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Sta niet toe om dit element te wijzigen wanneer de statistiek wordt gegenereerd.',

        # Template: StatsParamsWidget
        'Format' => 'Formaat',
        'Exchange Axis' => 'Wissel assen',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Geen element geselecteerd.',
        'Scale' => 'Schaal',
        'show more' => 'Toon meer',
        'show less' => 'Toon minder',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'De geselecteerde tijdsperiode bepaalt het standaard tijdsvenster voor deze statistiek om gegevens van te verzamelen.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Bepaalt de tijdseenheid die wordt gebruikt om de geselecteerde periode te splitsen in rapportage data punten.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'De schaal van de Y-as moet groter zijn dan de schaal voor de X-as (bijvoorbeeld: X-as => Maand, Y-as => Jaar).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Deze instelling is uitgeschakeld',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => 'Uitschakelen',
        'Enable this setting, so it becomes effective' => 'Schakel deze instellin in, zodat deze actief wordt.',
        'Enable' => 'Inschakelen',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Sta niet langer toe dat gebruikers deze instelling aanpassen aan hun persoonlijke voorkeuren',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => 'Directe link kopieren',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => 'Verwijder van favorieten',
        'Add this setting to your favorites' => '',
        'Add to favourites' => 'Toevoegen aan favorieten',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => 'Sla wijzigingen van deze instelling op',
        'Edit this setting' => 'Instelling bewerken',
        'Enable this setting' => 'Instelling inschakelen',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => 'Nu',
        'User modification' => '',
        'enabled' => 'ingeschakeld',
        'disabled' => 'uitgeschakeld',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => 'Bewerk zoekopdracht',
        'Go back to admin: ' => 'Ga terug naar admin:',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => 'Ongeldige instellingen',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => 'Alle gewijzigde instellingen opslaan',
        'Cancel editing for all settings' => 'Annuleer wijzigingen voor alle instellingen',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => 'Momenteel bewerkt door mij.',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => 'Huidige instelling opslaan',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => 'Navigatie',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO Testpagina',
        'Unlock' => 'Ontgrendel',
        'Welcome %s %s' => 'Welkom %s %s',
        'Counter' => 'Teller',

        # Template: Warning
        'Go back to the previous page' => 'Terug naar de vorige pagina',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Concept titel',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Bevestigen',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => '',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => '',
        'Running' => '',
        'Finished' => 'Afgerond',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Nieuwe sleutel toevoegen',

        # JS Template: AddHashKey
        'Add key' => 'Sleutel toevoegen',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => 'Nu uitrollen',
        'Try again' => '',

        # JS Template: DialogReset
        'Reset options' => '',
        'Reset setting on global level.' => '',
        'Reset globally' => '',
        'Remove all user changes.' => '',
        'Reset locally' => '',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'Klantcodes',
        'Fax' => 'Fax',
        'Street' => 'Straat',
        'Zip' => 'Postcode',
        'City' => 'Plaats',
        'Country' => 'Land',
        'Mr.' => 'Dhr.',
        'Mrs.' => 'Mevr.',
        'Address' => 'Adres',
        'View system log messages.' => 'Bekijk het OTOBO logboek.',
        'Edit the system configuration settings.' => 'Bewerk de systeemconfiguratie.',
        'Update and extend your system with software packages.' => 'Voeg functies toe aan uw systeem door het installeren van pakketten.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'De ACL-informatie in de database is niet gesynchroniseerd met het systeem. Activeer alle ACLs.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACL\'s kunnen niet worden geïmporteerd vanwege een onbekende fout, kijk in de OTOBO loggegevens voor meer informatie.',
        'The following ACLs have been added successfully: %s' => 'De volgende ACL\'s zijn succesvol toegevoegd: %s',
        'The following ACLs have been updated successfully: %s' => 'De volgende ACLs zijn succesvol bijgewerkt: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Er zijn fouten opgetreden tijdens het toevoegen/bijwerken van de volgende ACLs: %s. Controleer de log bestanden voor meer informatie.',
        'There was an error creating the ACL' => 'Er is iets mis gegaan tijdens het bijwerken van de ACL',
        'Need ACLID!' => 'ACLID is vereist!',
        'Could not get data for ACLID %s' => 'Kon gegevens voor ACLID %s niet ophalen',
        'There was an error updating the ACL' => 'Er is een fout opgetreden bij het bijwerken van de ACL.',
        'There was an error setting the entity sync status.' => 'Er is een fout opgegeven bij het instellen van de synchronisatiestatus.',
        'There was an error synchronizing the ACLs.' => 'Er is een fout opgetreden met het synchroniseren van de ACL\'s.',
        'ACL %s could not be deleted' => 'ACL %s kon niet worden verwijderd',
        'There was an error getting data for ACL with ID %s' => 'Er is een fout opgetreden met het ophalen van de gegevens voor ACL met ID %s',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Exacte overeenkomst',
        'Negated exact match' => '',
        'Regular expression' => 'Reguliere expressie',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '',
        'Please contact the administrator.' => '',
        'No CalendarID!' => '',
        'You have no access to this calendar!' => '',
        'Error updating the calendar!' => '',
        'Couldn\'t read calendar configuration file.' => '',
        'Please make sure your file is valid.' => '',
        'Could not import the calendar!' => '',
        'Calendar imported!' => '',
        'Need CalendarID!' => '',
        'Could not retrieve data for given CalendarID' => '',
        'Successfully imported %s appointment(s) to calendar %s.' => '',
        '+5 minutes' => '+5 minuten',
        '+15 minutes' => '+15 minuten',
        '+30 minutes' => '+30 minuten',
        '+1 hour' => '+1 uur',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Geen rechten',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Naam van de melding bestaat reeds!',
        'Notification added!' => 'Melding toegevoegd!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Er is een fout opgetreden bij het ophalen van de gegevens met ID:%s!',
        'Unknown Notification %s!' => 'Onbekende melding %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Er is een fout opgetreden bij het genereren van de melding',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Meldingen konden niet worden geïmporteerd vanwege een onbekende fout. Kijk de OTOBO logbestanden na voor meer informatie.',
        'The following Notifications have been added successfully: %s' =>
            'De volgende melding is succesvol toegevoegd: %s',
        'The following Notifications have been updated successfully: %s' =>
            'De volgende melding is succesvol bijgewerkt: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Er zijn fouten opgetreden bij het toevoegen/aanpassen van de volgende melding: %s. Kijk de OTOBO logbestanden na voor meer informatie.',
        'Notification updated!' => 'Melding bijgewerkt!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Bijlage toegevoegd.',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => 'Alle communicatie',
        'Last 1 hour' => 'Laatste uur',
        'Last 3 hours' => 'Laatste 3 uur',
        'Last 6 hours' => 'Laatste 6 uur',
        'Last 12 hours' => 'Laatste 12 uur',
        'Last 24 hours' => 'Laatste 24 uur',
        'Last week' => 'Laatste week',
        'Last month' => 'Laatste maand',
        'Invalid StartTime: %s!' => '',
        'Successful' => 'Succesvol',
        'Processing' => '',
        'Failed' => 'Mislukt',
        'Invalid Filter: %s!' => '',
        'Less than a second' => 'Minder dan een seconde',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => 'Debug',
        'Info' => 'Informatie',
        'Warn' => '',
        'days' => 'dagen',
        'day' => 'dag',
        'hour' => 'uur',
        'minute' => 'minuut',
        'seconds' => 'seconden',
        'second' => 'seconde',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => '',
        'No data found for given contact in given source!' => '',
        'Contact updated!' => '',
        'No field data found!' => '',
        'Contact created!' => '',
        'Error creating contact!' => '',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            '',
        'No data found for given source!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Bedrijf bijgewerkt!',
        'Dynamic field %s not found!' => 'Dynamisch veld %s niet gevonden!',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Bedrijf %s bestaat al!',
        'Customer company added!' => 'Bedrijf toegevoegd!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Klant aangepast.',
        'New phone ticket' => 'Nieuw telefoon-ticket',
        'New email ticket' => 'Nieuw e-mail-ticket',
        'Customer %s added' => 'Klant %s toegevoegd.',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Velden configuratie is niet geldig',
        'Objects configuration is not valid' => 'Object configuratie is niet geldig',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Kon dynamische velden niet herstellen, kijk in het logbestand voor details.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Ongedefinieerde subactie.',
        'Need %s' => 'Heb %s nodig',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'Het veld bevat niet alleen maar ASCII letters en cijfers.',
        'There is another field with the same name.' => 'Er is een ander veld met dezelfde naam.',
        'The field must be numeric.' => 'Het veld moet numeriek zijn.',
        'Need ValidID' => 'Heb ValidID nodig',
        'Could not create the new field' => 'Het nieuwe veld kon niet worden aangemaakt',
        'Need ID' => 'Heb ID nodig',
        'Could not get data for dynamic field %s' => 'Kon de gegevens voor dynamisch veld %s niet ophalen',
        'Change %s field' => '',
        'The name for this field should not change.' => 'De naam van dit veld zou niet moeten veranderen.',
        'Could not update the field %s' => 'Het veld %s kon niet bijgewerkt worden.',
        'Currently' => 'Huidige',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Deze veldwaarde is gedupliceerd.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to reset the setting!' => '',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Selecteer minimaal één ontvanger.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minu(u)t(en)',
        'hour(s)' => 'u(u)r(en)',
        'Time unit' => 'Tijd',
        'within the last ...' => 'in de laatste ...',
        'within the next ...' => 'in de volgende ...',
        'more than ... ago' => 'langer dan ... geleden',
        'Unarchived tickets' => 'Ongearchiveerde tickets',
        'archive tickets' => 'archiveer tickets',
        'restore tickets from archive' => 'tickets van archief herstellen',
        'Need Profile!' => 'Profiel vereist!',
        'Got no values to check.' => 'Had geen waarden om te controleren',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Verwijder de volgende woorden omdat ze niet kunnen worden gebruikt voor het selecteren van een ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID is vereist!',
        'Could not get data for WebserviceID %s' => 'Kon gegevens van WebserviceID %s niet ophalen',
        'ascending' => 'aflopend',
        'descending' => 'oplopend',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Communicatie type vereist!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => 'alle modules overslaan',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 seconden',
        '15 seconds' => '15 seconden',
        '30 seconds' => '30 seconden',
        '45 seconds' => '45 seconden',
        '1 minute' => '1 minuut',
        '2 minutes' => '2 minuten',
        '3 minutes' => '3 minuten',
        '4 minutes' => '4 minuten',
        '5 minutes' => '5 minuten',
        '10 minutes' => '10 minuten',
        '15 minutes' => '15 minuten',
        '30 minutes' => '30 minuten',
        '1 hour' => '1 uur',
        '2 hours' => '2 uu',
        '3 hours' => '3 uur',
        '4 hours' => '4 uur',
        '5 hours' => '5 uur',
        '6 hours' => '6 uur',
        '12 hours' => '12 uur',
        '18 hours' => '18 uu',
        '1 day' => '1 dag',
        '2 days' => '2 dagen',
        '3 days' => '3 dagen',
        '4 days' => '4 dagen',
        '6 days' => '6 dagen',
        '1 week' => '1 week',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Kon configuratie voor invoker %s niet bepalen.',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Invoker vereist!',
        'Need Event!' => 'Gebeurtenis vereist!',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'Configuratiebestand kon niet worden bijgewerkt voor Webservice met ID %s',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => 'Regexp',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Het geregistreerde configuratiebestand voor actie type %s kon niet worden opgehaald',
        'Could not get backend for %s %s' => 'Backend voor %s %s kon niet worden opgehaald',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Configuratiebestand kon niet bepaald worden voor operatie %s',
        'OperationType %s is not registered' => 'OperatieType %s is niet geregistreerd',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Geldige subactie vereist!',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Er is nog een webservice met dezelfde naam.',
        'There was an error updating the web service.' => 'Er is een fout opgetreden bij het bijwerken van de webservice.',
        'There was an error creating the web service.' => 'Er is een fout opgetreden bij het aanmaken van de webservice.',
        'Web service "%s" created!' => 'Webservice "%s" aangemaakt!',
        'Need Name!' => 'Heb Naam nodig!',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => 'Kan %s niet lezen!',
        'Need a file to import!' => 'Heb een bestand nodig om te importeren!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Het geïmporteerde bestand is geen geldig YAML bestand! Kijk in het logbestand voor details',
        'Web service "%s" deleted!' => 'Webservice "%s" verwijderd!',
        'OTOBO as provider' => 'OTOBO als provider',
        'Operations' => '',
        'OTOBO as requester' => 'OTOBO als requester',
        'Invokers' => 'Invokers',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Heb geen WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Groep bijgewerkt.',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'E-mailaccount toegevoegd.',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Toewijzen gebaseerd op e-mailadres.',
        'Dispatching by selected Queue.' => 'Toewijzen gebaseerd op geselecteerde wachtrij.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Eigenaar van het ticket',
        'Agent who is responsible for the ticket' => 'Verantwoordelijke voor het ticket',
        'All agents watching the ticket' => 'Alle agent die het ticket in de gaten houden',
        'All agents with write permission for the ticket' => 'Alle agents met schrijf rechten voor het ticket',
        'All agents subscribed to the ticket\'s queue' => 'Alle agents die zich hebben ingeschreven op de wachtrij',
        'All agents subscribed to the ticket\'s service' => 'Alle agents die zich hebben ingeschreven op de service',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Alle agents die zich zowel op de wachtrij, als op de service hebben ingeschreven',
        'Customer user of the ticket' => 'Klantgebruiker van het ticket',
        'All recipients of the first article' => 'Alle ontvangers van het eerste artikel',
        'All recipients of the last article' => 'Alle ontvangers van het laatste artikel',
        'Invisible to customer' => 'Onzichtbaar voor klant',
        'Visible to customer' => 'Zichtbaar voor klant',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => 'Heb param Sleutel nodig om te verwijderen!',
        'Key %s deleted!' => 'Sleutel %s is verwijderd!',
        'Need param Key to download!' => 'Heb param Sleutel nodig om te downloaden!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '',
        'No such package!' => 'Pakket bestaat niet.',
        'No such file %s in package!' => 'Geen bestand %s in pakket!',
        'No such file %s in local file system!' => 'Geen bestand %s in bestandssysteem!',
        'Can\'t read %s!' => 'Kan %s niet lezen!',
        'File is OK' => '',
        'Package has locally modified files.' => 'Pakket heeft lokaal bewerkte bestanden.',
        'Package not verified by the OTOBO Team!' => '',
        'Not Started' => '',
        'Updated' => 'Bijgewerkt',
        'Already up-to-date' => '',
        'Installed' => 'Geïnstalleerd',
        'Not correctly deployed' => '',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Pakket niet gecontroleerd vanwege een communicatiefout met de server!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '',
        'Can\'t get OTOBO Feature Add-on list from server!' => '',
        'Can\'t get OTOBO Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Filter %s bestaat niet',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioriteit toegevoegd.',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Proces informatie uit de database is niet gesynchroniseerd met de systeemconfiguratie. Voer een synchronisatie uit.',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => 'Kan %s:%s niet verwijderen',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => 'Heb %s nodig!',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Er is een fout opgetreden met het genereren van een nieuwe EntityID voor deze Activiteit',
        'There was an error creating the Activity' => 'Er is een fout opgetreden bij het aanmaken van de activiteit',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de synchronisatie status van de activiteit: %s',
        'Need ActivityID!' => 'Heb ActivityID nodig!',
        'Could not get data for ActivityID %s' => 'Kan gegevens niet ophalen van ActivityID %s',
        'There was an error updating the Activity' => 'Er is een fout opgetreden tijdens het bijwerken van de activiteit.',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Ontbrekende parameter: Heb Activiteit en ActiviteitDialoog nodig!',
        'Activity not found!' => 'Activiteit niet gevonden!',
        'ActivityDialog not found!' => 'ActiviteitDialoog niet gevonden',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActiviteitDialoog al toegewezen aan Activiteit. Je kunt een ActiviteitDialoog niet twee keer toevoegen!',
        'Error while saving the Activity to the database!' => 'Fout bij het opslaan van de Activiteit in de database!',
        'This subaction is not valid' => 'Deze subactie is niet geldig',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de synchronisatiestatus van ActiviteitDialoog item: %s',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => 'Gegevens van ActiviteitDialoogID %s konden niet worden opgehaald',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => 'Behandelaar interface',
        'Customer Interface' => 'Klant interface',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Er is een fout opgetreden bij het genereren van een nieuwe EntiteitID voor deze transitie',
        'There was an error creating the Transition' => 'Er is een fout opgetreden bij het aanmaken van de Transitie',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de syncrhonisatie status van Transiti: %s',
        'Need TransitionID!' => 'Heb TranistieID nodig!',
        'Could not get data for TransitionID %s' => 'Kon gegevens voor TansitiID %s niet ophalen',
        'There was an error updating the Transition' => 'Er is een fout opgetreden bij het bijwerken van de Transitie',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Minimaal één geldige configuratie parameter is vereist',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Er is een fout opgetreden bij het genereren van een nieuwe EntiteitID voor deze TransactieActie',
        'There was an error creating the TransitionAction' => 'Er is een fout opgetreden bij het aanmaken van de TransactieActie',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de entiteit synchronisatie status voor de TransactieActie:%s',
        'Need TransitionActionID!' => 'TransacActieID is vereist!',
        'Could not get data for TransitionActionID %s' => 'Kon gegevens van TransactieActieID %s niet ophalen',
        'There was an error updating the TransitionAction' => 'Er is een fout opgetreden tijdens het bijwerken van TransitieActie',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => 'Fout: Niet alle sleutels hebben waarden of vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Wachtrij bijgewerkt.',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-geen-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Wachtrijen (zonder automatische antwoorden)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Verander gekoppelde wachtrijen voor sjabloon',
        'Change Template Relations for Queue' => 'Verander gekoppelde sjablonen voor wachtrij',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktie',
        'Test' => 'Test',
        'Training' => 'Training',
        'Development' => 'Ontwikkeling',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rol bijgewerkt.',
        'Role added!' => 'Rol toegevoegd.',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Bewerk gekoppelde groepen voor rol',
        'Change Role Relations for Group' => 'Bewerk gekoppelde rollen voor groep',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rol',
        'Change Role Relations for Agent' => 'Bewerk gekoppelde rollen voor behandelaar',
        'Change Agent Relations for Role' => 'Bewerk gekoppelde behandelaars voor rol',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Activeer %s eerst.',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME omgeving werkt niet. Zie logbestand voor meer informatie!',
        'Need param Filename to delete!' => 'Heb parameter Bestandsnaam nodig om te verwijderen!',
        'Need param Filename to download!' => 'Heb parameter Bestandsnaam nodig om te downloaden',
        'Needed CertFingerprint and CAFingerprint!' => 'Heb CertFingerprint en CAFingerprint nodig!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerbrint moet anders zijn dan CertFingerprint',
        'Relation exists!' => 'Relatie bestaat al!',
        'Relation added!' => 'Relatie toegevoegd!',
        'Impossible to add relation!' => 'Niet mogelijk de relatie toe te voegen!',
        'Relation doesn\'t exists' => 'Relatie bestaat niet',
        'Relation deleted!' => 'Relatie verwijderd!',
        'Impossible to delete relation!' => 'Niet mogelijk de relatie te verwijderen!',
        'Certificate %s could not be read!' => 'Certificaat %s kon niet worden gelezen!',
        'Needed Fingerprint' => 'Vingerafdruk is benodigd',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Aanhef toegevoegd!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Handtekening bijgewerkt.',
        'Signature added!' => 'Handtekening toegevoegd.',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Status toegevoegd.',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Bestand %skan niet worden gelezen!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'E-mailadres toegevoegd.',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Ongeldige instellingen',
        'There are no invalid settings active at this time.' => 'Er zijn op dit moment geen ongeldige instellingen actief.',
        'You currently don\'t have any favourite settings.' => 'U hebt momenteel geen favoriete instellingen.',
        'The following settings could not be found: %s' => 'De volgende instellingen kunnen niet worden gevonden: %s',
        'Import not allowed!' => 'Importeren is niet toegestaan!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'Systeemconfiguratie kon niet worden geïmporteerd vanwege een onbekende fout. Raadpleeg de OTOBO-logboeken voor meer informatie.',
        'Category Search' => 'Categorie zoeken',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Sommige geïmporteerde instellingen zijn niet aanwezig in de huidige  configuratie of het was niet mogelijk om deze bij te werken. Raadpleeg het OTOBO-logboek voor meer informatie.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'U moet de instelling inschakelen voor vergrendeling!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'U kunt niet aan deze instelling werken omdat %s (%s) is er momenteel mee aan het werk.',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'System was not able to lock the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => 'Instelling niet gevonden.',
        'Missing Settings!' => 'Ontbrekende Instellingen!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => '',
        'Modified Version' => '',
        'Reset To Default' => '',
        'Default Version' => '',
        'No setting name or modified version id received!' => '',
        'Was not possible to revert the historical value!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => '',
        'System was not able to delete the user setting values!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Begindatum moet vóór de einddatum liggen!',
        'There was an error creating the System Maintenance' => 'Er is een fout opgetreden bij het aanmaken van het systeem onderhoudsvenster',
        'Need SystemMaintenanceID!' => 'Heb een SysteemOnderhoudsID nodig!',
        'Could not get data for SystemMaintenanceID %s' => 'Kon gegevens voor SystemOnderhoudID %s niet ophalen',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Sessie is beëindigd!',
        'All sessions have been killed, except for your own.' => 'Alle sessies zijn beëindigd behalve die van uzelf.',
        'There was an error updating the System Maintenance' => 'Er is een fout opgetreden bij het update van het Systeem Onderhoudsvenster',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Het was niet mogelijk om het Systeem Onderhoudsvenster %s te verwijderen!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Sjabloon bijgewerkt!',
        'Template added!' => 'Sjabloon toegevoegd!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Verander gekoppelde bijlagen voor sjabloon',
        'Change Template Relations for Attachment' => 'Verander gekoppelde sjablonen voor bijlage',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Heb Type nodig!',
        'Type added!' => 'Type toegevoegd.',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Behandelaar aangepast.',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Bewerk gekoppelde groepen voor behandelaar',
        'Change Agent Relations for Group' => 'Bewerk gekoppelde behandelaars voor groep',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Maand',
        'Week' => 'Week',
        'Day' => 'Dag',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Alle afspraken',
        'Appointments assigned to me' => 'Afspraken aan mij toegewezen',
        'Showing only appointments assigned to you! Change settings' => 'Alleen afspraken zijn weergeven die aan u zijn toegewezen! Wijzig de instellingen',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Afspraak niet gevonden!',
        'Never' => 'Nooit',
        'Every Day' => 'Elke dag',
        'Every Week' => 'Elke week',
        'Every Month' => 'Elke maand',
        'Every Year' => 'Elk jaar',
        'Custom' => '',
        'Daily' => 'Dagelijks',
        'Weekly' => 'Wekelijks',
        'Monthly' => 'Maandelijks',
        'Yearly' => 'Jaarlijks',
        'every' => 'elke',
        'for %s time(s)' => '',
        'until ...' => 'tot ...',
        'for ... time(s)' => 'voor ... keer',
        'until %s' => 'tot %s',
        'No notification' => 'Geen melding',
        '%s minute(s) before' => '%s minuut(en) voor',
        '%s hour(s) before' => '%s uur(en) voor',
        '%s day(s) before' => '%s dag(en) voor',
        '%s week before' => '%s week(en) voor',
        'before the appointment starts' => 'voordat de afspraak begint',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Klantgeschiedenis',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Geen configuratie gevonden voor %s',
        'Statistic' => 'Rapportage',
        'No preferences for %s!' => 'Geen voorkeuren voor %s',
        'Can\'t get element data of %s!' => 'Kan element gegevens van %s niet ophalen!',
        'Can\'t get filter content data of %s!' => 'Kan filter gegevens van %s niet ophalen!',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => 'Je hebt ro rechten nodig!',
        'Can not delete link with %s!' => 'Kan relatie met %s niet verwijderen!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Kan relatie met %s niet aanmaken!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parameter groep is vereist!',
        'This feature is not available.' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => 'Ongeldige subactie.',
        'Statistic could not be imported.' => 'Rapport kon niet worden geïmporteerd.',
        'Please upload a valid statistic file.' => 'Upload een geldig rapportage bestand.',
        'Export: Need StatID!' => 'Exporteren: Heb geen StatID!',
        'Delete: Get no StatID!' => 'Verwijderen: Heb geen StatID!',
        'Need StatID!' => 'Heb geen StatID!',
        'Could not load stat.' => 'Kon rapportage niet laden',
        'Add New Statistic' => 'Voeg een nieuwe statistiek toe',
        'Could not create statistic.' => 'Kon rapportage niet aanmaken.',
        'Run: Get no %s!' => 'Uitvoeren: heb geen %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Heb geen TicketID!',
        'You need %s permissions!' => 'Je hebt %s permissies nodig!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'U moet de eigenaar zijn om deze actie uit te voeren.',
        'Please change the owner first.' => 'Verander de eigenaar eerst.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'Kan validatie op veld %s niet uitvoeren!',
        'No subject' => 'Geen onderwerp',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Vorige eigenaar',
        'wrote' => 'schreef',
        'Message from' => 'Bericht van',
        'End message' => 'Einde van het bericht',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s is vereist!',
        'Plain article not found for article %s!' => 'Volledige artikel niet gevonden voor artikel %s!',
        'Article does not belong to ticket %s!' => 'Artikel hoort niet bij ticket %s!',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => '',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Adres %s vervangen met vastgelegde klant-adres.',
        'Customer user automatically added in Cc.' => 'Klant automatisch toegevoegd als CC.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Ticket "%s" aangemaakt.',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Volgende week',
        'Ticket Escalation View' => 'Ticket escalatie',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Doorgestuurd bericht van',
        'End forwarded message' => 'Einde doorgestuurd bericht',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nieuwe interactie',
        'Pending' => 'Wachten',
        'Reminder Reached' => 'Moment van herinnering bereikt',
        'My Locked Tickets' => 'Mijn vergrendelde tickets',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Kan een ticket niet samenvoegen met zichzelf!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '%s heeft de chat verlaten.',
        'This chat has been closed and will be removed in %s hours.' => 'Deze chat is gesloten en wordt in %s uren verwijderd.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket vergrendeld.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Heb TicketID nodig!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Kon ActiviteitDialoogEntiteidID "%s" niet verkrijgen!',
        'No Process configured!' => 'Geen Proces geconfigureerd!',
        'The selected process is invalid!' => 'Het geselecteerde proces is niet geldig!',
        'Process %s is invalid!' => 'Proces %s is ongeldig!',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Geen ActiviteitDialog geconfigureerd voor %s in _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Geen Start ActiviteitEntiteitID of Start ActiviteitDialoogEntiteitID voor Proces: %s in _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Geen Ticket voor TicketID: %s in _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Kon geen ActiviteitEntiteitID bepalen. Dynamisch veld of Configuratie is niet juist ingesteld!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Configuratie Waarde ontbreekt!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Heb geen ProcesEntiteitID of TicketID en ActiviteitDialoogEntiteitID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Verkreeg geen StartActiviteitDialoog en StartActiviteitDialoog voor het ProcesEntiteitID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Kan ticket "%s" niet ophalen!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Kan ProcesEntiteitID of ActiviteitEntiteitID niet verkrijgen voor ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Kan ActiviteitDialoog configuratie voor ActiviteitDialoogEntiteitID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Kan gegevens niet verkrijgen voor veld "%s" van ActiviteitDialoog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Wacht op tijd kan alleen gebruikt worden wanneer Status of StatusID is geconfigureerd voor dezelfde ActiviteitDialoog. ActiviteitDialoog: %s!',
        'Pending Date' => 'Wacht tot datum',
        'for pending* states' => 'voor \'wachtend op-\' statussen',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Beschikbare tickets',
        'including subqueues' => 'Inclusief sub-wachtrijen',
        'excluding subqueues' => 'Exclusief sub-wachtrijen',
        'QueueView' => 'Wachtrijoverzicht',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Mijn verantwoordelijke tickets',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'laatste zoekopdracht',
        'Untitled' => '',
        'Ticket Number' => 'Ticketnummer',
        'Ticket' => 'Ticket',
        'printed by' => 'afgedrukt door',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'Ongeldige gebruikers',
        'Normal' => 'Normaal',
        'CSV' => '',
        'Excel' => '',
        'in more than ...' => 'over meer dan ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Service View',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Statusoverzicht',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mijn gevolgde tickets',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Ticket aangemaakt',
        'Type Updated' => '',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => '',
        'Internal Chat' => '',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => '',
        'Note Added (Customer)' => '',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => '',
        'Outgoing Answer' => '',
        'Service Updated' => '',
        'Link Added' => '',
        'Incoming Customer Email' => '',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => 'Uitgaande e-mail',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => 'Uitgaand telefoongesprek',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Inkomend telefoongesprek',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => '',
        'External Chat' => '',
        'Queue Changed' => '',
        'Notification Was Sent' => 'Melding is verstuurd.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Stuur interactie naar een mailadres',
        'Forward' => 'Doorsturen',
        'Fields with no group' => 'Velden zonder groep',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Het artikel kan niet worden geopend! Mogelijk staat hij op een andere artikelpagina?',
        'Show one article' => 'Toon één interactie',
        'Show all articles' => 'Toon alle interacties',
        'Show Ticket Timeline View' => 'Geef ticket tijdslijn weer',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'Mijn tickets',
        'Company Tickets' => 'Tickets van groep',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Werkelijke naam van klant',
        'Created within the last' => 'Aangemaakt in de laatste',
        'Created more than ... ago' => 'Aangemaakt langer dan ... geleden',
        'Please remove the following words because they cannot be used for the search:' =>
            'Verwijder de volgende woorden van je zoekactie omdat daar niet op gezocht kan worden:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => '',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => '',
        'Install OTOBO' => 'Installeer OTOBO',
        'Intro' => 'Introductie',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Database-keuze',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Database aanmaken',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Systeemconfiguratie',
        'Syslog' => '',
        'Configure Mail' => 'Configureer mail',
        'Mail Configuration' => 'E-mailconfiguratie',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Database bevat al data - deze moet leeg zijn!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Artikel terugsturen naar een ander e-mailadres',
        'Bounce' => 'Bounce',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Allen beantwoorden',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Notitie beantwoorden',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Splits deze interactie',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Broncode',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Print deze interactie',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Markeer',
        'Unmark' => 'Verwijder markering',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Versleuteld',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Getekend',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Teken',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Tonen',
        'Refresh (minutes)' => '',
        'off' => 'uit',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Getoonde klanten',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => '',
        'Can\'t get OTOBO News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Laat tickets zien',
        'Shown Columns' => 'Toon kolommen',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Dit ticket heeft geen titel of onderwerp',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Afgelopen 7 dagen',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standaard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'u',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Dit is een',
        'email' => 'e-mail',
        'click here' => 'klik hier',
        'to open it in a new window.' => 'om deze in een nieuw venster te openen.',
        'Year' => 'Jaar',
        'Hours' => 'Uren',
        'Minutes' => 'Minuten',
        'Check to activate this date' => 'Selecteer om deze datum te gebruiken',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Geen toegang! Onvoldoende permissies.',
        'No Permission' => '',
        'Show Tree Selection' => 'Toon boomweergave',
        'Split Quote' => 'Splits quote',
        'Remove Quote' => 'Verwijder citaat',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Gekoppeld als',
        'Search Result' => '',
        'Linked' => 'Gekoppeld',
        'Bulk' => 'Bulk',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Light',
        'Unread article(s) available' => 'Ongelezen interactie(s) aanwezig',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Online behandelaars: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Er zijn nog meer geëscaleerde tickets.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Online klanten: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO Daemon is niet actief.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'U staat geregistreerd als afwezig. Wilt u dit aanpassen?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Zorg ervoor dat je minimaal één transportmethode hebt gekozen voor verplichtte notificaties.',
        'Preferences updated successfully!' => 'Uw voorkeuren zijn gewijzigd.',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Geef een einddatum op die na de startdatum ligt.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Herhaal wachtwoord',
        'The current password is not correct. Please try again!' => 'Het ingegeven wachtwoord klopt niet. Probeer het opnieuw.',
        'Please supply your new password!' => 'Geef je nieuwe wachtwoord op.',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan het wachtwoord niet bijwerken, het moet minstens %s tekens lang zijn.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan het wachtwoord niet bijwerken, het moet minstens 1 cijfer bevatten.',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'ongeldig',
        'valid' => 'geldig',
        'No (not supported)' => 'Nee (niet beschikbaar)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Geen historische volledige of huidige aankomende volledige relatieve tijdswaarden geselecteerd.',
        'The selected time period is larger than the allowed time period.' =>
            'De geselecteerde tijdsperiode is groter dan de toegestane tijdsperiode',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Er is geen tijdschaal beschikbaar voor de geselecteerde tijdsschaal waarde op de X as.',
        'The selected date is not valid.' => 'De geselecteerde datum is niet geldig.',
        'The selected end time is before the start time.' => 'De geselecteerde einddtijd is voor de starttijd.',
        'There is something wrong with your time selection.' => 'Er is iets mis met je tijdsselectie.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select one element for the X-axis.' => 'Selecteer een element voor X-as.',
        'You can only use one time element for the Y axis.' => 'Je kunt slechts één tijdselement voor de Y as gebruiken.',
        'You can only use one or two elements for the Y axis.' => 'Je kunt slechts één of twee elementen gebruiken voor de Y as.',
        'Please select at least one value of this field.' => 'Selecteer minimaal één waarde voor dit veld.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select a time scale.' => 'Selecteer een tijdsschaal.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'De tijdsinterval is te klein, kies een grotere interval.',
        'second(s)' => 'seconden',
        'quarter(s)' => 'kwarta(a)l(en)',
        'half-year(s)' => 'halve-jaren',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Verwijder de volgende woorden omdat ze niet gebruikt kunnen worden om tickets te beperken: %s',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Inhoud',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Ontgrendelen om dit ticket vrij te geven',
        'Lock it to work on it' => 'Vergrendel dit ticket',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Stop met volgen',
        'Remove from list of watched tickets' => 'Verwijder van lijst met gevolgde tickets',
        'Watch' => 'Volg',
        'Add to list of watched tickets' => 'Voeg toe aan lijst met gevolgde tickets',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sorteren op',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nieuwe vergrendelde tickets',
        'Locked Tickets Reminder Reached' => 'Vergrendelde tickets herinnering bereikt',
        'Locked Tickets Total' => 'Totaal aantal vergrendelde tickets',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nieuwe tickets verantwoordelijk',
        'Responsible Tickets Reminder Reached' => 'Tickets verantwoordelijk herinnering bereikt',
        'Responsible Tickets Total' => 'Totaal aantal tickets verantwoordelijk',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Nieuwe gevolgde tickets',
        'Watched Tickets Reminder Reached' => 'Gevolgde tickets herinnering bereikt',
        'Watched Tickets Total' => 'Totaal gevolgde tickets',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Ticket Dynamische Velden',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Het is momenteel niet mogelijk om in te loggen omwille van een gepland systeemonderhoud.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => 'Sessie-limiet bereikt. Probeert u later opnieuw in te loggen.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Uw sessie is ongeldig. Meldt u opnieuw aan.',
        'Session has timed out. Please log in again.' => 'Uw sessie is verlopen. Meldt u opnieuw aan.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => 'Sla het afleveren van de melding over',
        'Send unsigned notification' => 'Stuur een niet-ondertekende melding',
        'Send unencrypted notification' => 'Stuur een niet-gecodeerde melding',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Configuratie opties verwijzing',
        'This setting can not be changed.' => 'Deze instelling kan niet worden aangepast.',
        'This setting is not active by default.' => 'Deze instelling is standaard niet ingeschakeld.',
        'This setting can not be deactivated.' => 'Deze instelling kan niet worden uitgeschakeld.',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'voor/na',
        'between' => 'tussen',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Dit veld is verplicht of ',
        'The field content is too long!' => 'De inhoud van het veld is te lang!',
        'Maximum size is %s characters.' => 'De maximumlengte bedraagt %s karakters.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => '',
        'Deployment completed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => '',
        'Migration failed.' => '',
        'Migrate database table auto_response.' => '',
        'Migration completed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => '',
        'Completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Check if OTOBO version is correct.' => '',
        'Check if OTOBO and OTRS connect is possible.' => '',
        'Can\'t open RELEASE file from OTRSHome: %s!' => '',
        'Copy and migrate files from OTRS' => '',
        'All needed files copied and migrated, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Need %s for Oracle db!' => '',
        'Copy database.' => '',
        'System was unable to connect to OTRS database.' => '',
        'System was unable to complete data transfer.' => '',
        'Data transfer completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO and OTRS version is correct.' => '',
        '%s does not exist!' => '',
        'Can\'t read OTOBO RELEASE file: %s: %s!' => '',
        'No OTOBO system found!' => '',
        'You are trying to run this script on the wrong framework version %s!' =>
            '',
        'OTOBO Version is correct: %s.' => '',
        'Check if OTRS version is correct.' => '',
        'Can\'t read OTRS RELEASE file: %s: %s!' => '',
        'No OTRS system found!' => '',
        'OTRS Version is correct: %s.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => '',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            '',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            '',
        'An error occured during SysConfig data migration.' => '',
        'SysConfig data migration completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => '',
        'No web service existent, done.' => '',
        'Can\'t add web service for Elasticsearch. File %s not found!.' =>
            '',
        'Migration completed. Please activate the web service in Admin -> Web Service when ElasticSearch installation is completed.' =>
            '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => '',
        'OTOBO Home exists.' => '',
        'Check if we are able to connect to OTRS Home.' => '',
        'Can\'t connect to OTRS file directory.' => '',
        'Connect to OTRS file directory is possible.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => '',
        'Connect to OTRS database or sanity checks failed.' => '',
        'Database connect and sanity checks completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => '',
        'The following packages are only installed in OTRS:' => '',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            '',
        'The same packages are installed on both systems, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => '',
        '%s script does not exist.' => '',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            '',
        'All required Perl modules have been installed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Niet is staat om het meldingen configuratie bestand te lezen. Zorg ervoor dat het bestand geldig is.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Geïmporteerde melding is een tekst die meer dan 400 karakters bevat.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'geïnstalleerd',
        'Unable to parse repository index document.' => 'Kan repository index document niet verwerken.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Geen pakketten gevonden in deze repository voor de huidige framework versie. De repository bevaty alleen pakketten voor andere framework versies.',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '',
        'Package not verified by the OTOBO community!' => '',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inactief',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Kan registratieserver niet bereiken. Probeer het later nogmaals.',
        'No content received from registration server. Please try again later.' =>
            'Geen data ontvangen van registratieserver. Probeer het later nogmaals.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Gebruikersnaam en wachtwoord komen niet overeen.',
        'Problems processing server result. Please try again later.' => 'Problemen met het verwerken van data van registratieserver. Probeer het later nogmaals.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Totaal',
        'week' => 'week',
        'quarter' => 'kwartaal',
        'half-year' => 'half-jaar',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Status type',
        'Created Priority' => 'Aangemaakt met prioriteit',
        'Created State' => 'Aangemaakt met status',
        'Create Time' => 'Aangemaakt op',
        'Pending until time' => '',
        'Close Time' => 'Afsluitingstijd',
        'Escalation' => 'Escalatie',
        'Escalation - First Response Time' => 'Escalatie - eerste reactietijd',
        'Escalation - Update Time' => 'Escalatie - tijd van bijwerken',
        'Escalation - Solution Time' => 'Escalatie - tijd van oplossen',
        'Agent/Owner' => 'Behandelaar/eigenaar',
        'Created by Agent/Owner' => 'Aangemaakt door behandelaar/eigenaar',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Gebruik',
        'Ticket/Article Accounted Time' => 'Bestede tijd voor ticket en interacties',
        'Ticket Create Time' => 'Aanmaaktijd ticket',
        'Ticket Close Time' => 'Sluittijd ticket',
        'Accounted time by Agent' => 'Bestede tijd per behandelaar',
        'Total Time' => 'Totale tijd',
        'Ticket Average' => 'Gemiddelde per ticket',
        'Ticket Min Time' => 'Minimumtijd voor ticket',
        'Ticket Max Time' => 'Maximumtijd voor ticket',
        'Number of Tickets' => 'Aantal tickets',
        'Article Average' => 'Gemiddelde per interactie',
        'Article Min Time' => 'Minimumtijd voor interactie',
        'Article Max Time' => 'Maximumtijd voor interactie',
        'Number of Articles' => 'Aantal interacties',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Attributen om af te drukken',
        'Sort sequence' => 'Sorteervolgorde',
        'State Historic' => 'Historische status',
        'State Type Historic' => 'Historische status type',
        'Historic Time Range' => 'Historische tijdsvenster',
        'Number' => 'Nummer',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Dagen',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Uiterlijk Tabel',
        'Internal Error: Could not open file.' => 'Interne Fout: kan bestand niet openen.',
        'Table Check' => 'Tabel Controle',
        'Internal Error: Could not read file.' => 'Interne fout: kan het bestand niet lezen.',
        'Tables found which are not present in the database.' => 'Tabellen gevonden die niet aanwezig zijn in de database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Database omvang',
        'Could not determine database size.' => 'Kan database omvang niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Database versie',
        'Could not determine database version.' => 'Kan de database versie niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Client verbinding karakterset',
        'Setting character_set_client needs to be utf8.' => 'Instelling character_set_client moet staan op utf8',
        'Server Database Charset' => 'Server Database karakterinstelling',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Tabel Karacterset',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log bestandsgrootte',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'De instelling innodb_log_file_size meot minimaal 256MB zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximale Query Lengte',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Query Cache grootte',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'De instelling \'query_cache_size\' gebruikt worden (minimaal 10MB, maar niet meer dan 512 MB)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Standaard Storage Engine',
        'Table Storage Engine' => 'Tabel Storage Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Er zijn tabellen gevonden die een afwijkende storage engine gebruiken.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x of hoger is vereist.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG instelling',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG moet ingesteld zijn op al32utf8 (GERMAN_GERMANY.AL32UTF8)',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT instelling',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT moet ingesteld zijn op \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT instelling SQL controle',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Instelling client_encoding moet UNICODE of UTF8 zijn',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Instelling server_encoding moet UNICODE of UTF8 zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datum Format',
        'Setting DateStyle needs to be ISO.' => 'Instelling DateStyle moet ISO zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO Schijfpartitie',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Harde schijf gebruik',
        'The partition where OTOBO is located is almost full.' => 'De partitie waar OTOBO op staat is bijna vol.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'De partitie waar OTOBO op staat heeft voldoende ruimte.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Versie',
        'Could not determine distribution.' => 'Kan de versie niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel versie',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Systeem Belasting',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'De systeem belasting zou niet meer moeten zijn dan het aantal CPUs dat het systeem heeft (een belasting van 8 of minder voor een systeem met 8 CPU\'s).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modules',
        'Not all required Perl modules are correctly installed.' => 'Niet alle vereiste Perl modules zijn correct geïnstalleerd',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Vrije Swap ruimte (%)',
        'No swap enabled.' => 'Geen swap ingeschakeld.',
        'Used Swap Space (MB)' => 'Gebruikte Swap ruimte (MB)',
        'There should be more than 60% free swap space.' => 'Er zou meer dan 60% vrije swap ruimte moeten zijn.',
        'There should be no more than 200 MB swap space used.' => 'Er zou niet meer dan 200MB swap ruimte in gebruik moeten zijn.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => 'Gemiddelde verwerkingstijd van de verbinding(en)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => '',
        'Could not determine value.' => 'Kon waarde niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Deamon is niet actief.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => '',
        'Ticket History Entries' => 'Ticket Historie gegevens',
        'Articles' => 'Interacties',
        'Attachments (DB, Without HTML)' => 'Bijlagen (Database, zonder HTML)',
        'Customers With At Least One Ticket' => 'Klanten met minimaal één ticket',
        'Dynamic Field Values' => 'Dynamische veldwaarden',
        'Invalid Dynamic Fields' => 'Ongeldige Dynamische velden',
        'Invalid Dynamic Field Values' => 'Ongeldige Dynamische Veld Waarden',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Maanden tussen het eerste en laatste ticket',
        'Tickets Per Month (avg)' => 'Tickets per maand (gemiddeld)',
        'Open Tickets' => 'Open tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Standaard SOAP gebruikersnaam en wachtwoord',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Standaard Admin Wachtwoord',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (Domeinnaam)',
        'Please configure your FQDN setting.' => 'Configureer de FQDN instelling.',
        'Domain Name' => 'Domeinnaam',
        'Your FQDN setting is invalid.' => 'De FQDN instelling is ongeldig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Bestandsysteem beschrijfbaar',
        'The file system on your OTOBO partition is not writable.' => 'Het bestandsysteem op de OTOBO partitie is niet schrijfbaar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Pakket installatie status',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Sommige pakketten zijn niet correct geïnstalleerd.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'De gekozen SystemID is ongeldig, er mogen alleen cijfers in voorkomen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Ticket Index Module',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Je hebt meer dan 60.000 tickets en zou een StaticDB backend moeten gebruiken. Zie ook de administrator handleiding (Performance Tuning) voor meer informatie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Je zou niet meer dan 8.000 openstaande tickets in uw systeem moeten hebben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket Zoek Indexering Module',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Weesrecords in de table ticket_lock_index.',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'De tabel ticket_lock_index bevat weesreckords. Om sw StaticDB te schonen voert u het volgende script: uit bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup".',
        'Orphaned Records In ticket_index Table' => 'Weesrecords in de table ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => 'Tijdzone van de server',
        'OTOBO time zone' => '',
        'OTOBO time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM model',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO vereist dat apache wordt uitgevoerd met de \'prefork\' MPM model.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator Gebruik',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Gebruik FastCGI of mod_perl om performance te verbetern.',
        'mod_deflate Usage' => 'mod_deflate Gebruik',
        'Please install mod_deflate to improve GUI speed.' => 'Installeer mod_deflate om GUI snelheid te verbeteren.',
        'mod_filter Usage' => 'mod_filter Gebruik',
        'Please install mod_filter if mod_deflate is used.' => 'Installeer mod_filter wanneer mod_deflate wordt gebruikt.',
        'mod_headers Usage' => 'mod_headers Usage',
        'Please install mod_headers to improve GUI speed.' => 'Installeer mod_headers om GUI snelheid te verbeteren.',
        'Apache::Reload Usage' => 'Apache::Reload Gebruik',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload of Apache2::Reload worden gebruikt als PerlModule en PerlInitHandler om te voorkomen dat de webserver herstart wanneer modules worden geïnstalleerd of geupgrade.',
        'Apache2::DBI Usage' => 'Apach2::DBI Gebruik',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Gelieve Apache2:DBI te gebruiken om de performantie met vooraf gelegde connecties met databases te verbeteren',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver versie',
        'Could not determine webserver version.' => 'Kan versie van webserver niet bepalen.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Gelijktijdige gebruikers',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Probleem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '',
        'Disabled' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Inloggen mislukt. Uw gebruikersnaam of wachtwoord is niet correct.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Afmelden gelukt.',
        'Feature not active!' => 'Deze functie is niet actief.',
        'Sent password reset instructions. Please check your email.' => 'Wachtwoord reset instructies zijn verstuurd. Controleer uw e-mail.',
        'Invalid Token!' => 'Fout token!',
        'Sent new password to %s. Please check your email.' => 'Nieuw wachtwoord gestuurd aan %s. Controleer uw e-mail.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Dit e-mail adres bestaat reeds. Gelieve in te loggen of uw wachtwoord te resetten.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Het is niet toegestaan om u met dit e-mailadres te registreren. Gelieve contact op te nemen met de Support afdeling.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nieuw account aangemaakt. Login informatie gestuurd aan %s. Controleer uw e-mail.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'tijdelijk ongeldig',
        'Group for default access.' => 'Groep voor standaard toegang.',
        'Group of all administrators.' => 'Groep voor alle administrators.',
        'Group for statistics access.' => 'Groep voor statistieken toegang.',
        'new' => 'nieuw',
        'All new state types (default: viewable).' => 'Alle nieuwe status types (standaard: zichtbaar)',
        'open' => 'open',
        'All open state types (default: viewable).' => 'Alle open status types (standaard: zichtbaar)',
        'closed' => 'gesloten',
        'All closed state types (default: not viewable).' => 'Alle gesloten status types (standaard: niet zichtbaar).',
        'pending reminder' => 'wachtend op een herinnering',
        'All \'pending reminder\' state types (default: viewable).' => 'Alle \'wacht op reminder\' status types (standaard: zichtbaar)',
        'pending auto' => 'wachtend',
        'All \'pending auto *\' state types (default: viewable).' => 'Alle \'wacht op automatisch *\' status types (standaard: zichtbaar).',
        'removed' => 'verwijderd',
        'All \'removed\' state types (default: not viewable).' => 'Alle \'verwijderd\' status types (standaard: niet zichtbaar).',
        'merged' => 'samengevoegd',
        'State type for merged tickets (default: not viewable).' => 'Status type voor samengevoegde tickets (standaard: niet zichtbaar).',
        'New ticket created by customer.' => 'Niet ticket aangemaakt door klant.',
        'closed successful' => 'succesvol gesloten',
        'Ticket is closed successful.' => 'Ticket is succesvol gesloten.',
        'closed unsuccessful' => 'niet succesvol gesloten',
        'Ticket is closed unsuccessful.' => 'Ticket is niet succesvol gesloten.',
        'Open tickets.' => 'Openstaande tickets.',
        'Customer removed ticket.' => 'Klant heeft ticket verwijderd.',
        'Ticket is pending for agent reminder.' => 'Ticket wacht op reminder voor agent.',
        'pending auto close+' => 'wachtend op automatisch succesvol sluiten',
        'Ticket is pending for automatic close.' => 'Ticket wacht op automatisch sluiten.',
        'pending auto close-' => 'wachtend op automatisch niet succesvol sluiten',
        'State for merged tickets.' => 'Status voor samengevoegde tickets.',
        'system standard salutation (en)' => 'Systeem standaard aanhef (en)',
        'Standard Salutation.' => 'Standaard Aanhef',
        'system standard signature (en)' => 'sandaard ondertekening (engels)',
        'Standard Signature.' => 'Standaard ondertekening',
        'Standard Address.' => 'Standaard Adres.',
        'possible' => 'mogelijk',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Follow-ups voor gesloten ticket zijn mogelijk. Tickets worden heropend.',
        'reject' => 'afwijzen',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Follow-ups voor gesloten tickets zijn niet mogelijk. Er wordt geen nieuw ticket aangemaakt.',
        'new ticket' => 'nieuw ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Postmaster wachtrij.',
        'All default incoming tickets.' => 'Alle standaard binnenkomende tickets',
        'All junk tickets.' => 'Alle span tickets.',
        'All misc tickets.' => 'Alle diverse tickets.',
        'auto reply' => 'automatisch antwoorden',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatisch antwoord welke wordt verstuurd wanneer een nieuw ticket is aangemaakt.',
        'auto reject' => 'automatisch weigeren',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatisch antwoord welke wordt verzonden wanneer een follow-up wordt geweigerd (wanneer een follow-up wordt geweigerd).',
        'auto follow up' => 'automatisch opvolgen',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatische bevestiging die wordt verstuurd nadat een folluw-up is ontvangen voor een ticket (wanner een follow-up mogelijk is).',
        'auto reply/new ticket' => 'automatisch antwoord/nieuw ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatisch antwoord welke wordt verstoord nadat een follow-up is afgewezen en een nieuw ticket is aangemaakt (voor het geval dat een follow-up een nieuw ticket is).',
        'auto remove' => 'automatisch verwijderen',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Automatisch verwijderen wordt verstuud wanneer een klant het verzoek heeft verwijderd.',
        'default reply (after new ticket has been created)' => 'standaard antwoord (wanneer een nieuw ticket is aangemaakt)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'standaard afwijzing (na follow-up en afwijzing van een gesloten ticket)',
        'default follow-up (after a ticket follow-up has been added)' => 'standaard follow-up (wanneer een ticket follow-up is toegevoegd)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'standaard afwijzing/nieuw ticket aangemaakt (na een gesloten follow up en nieuw ticket is aangemaakt)',
        'Unclassified' => 'niet geclassificeerd',
        '1 very low' => '1 zeer laag',
        '2 low' => '2 laag',
        '3 normal' => '3 normaal',
        '4 high' => '4 hoog',
        '5 very high' => '5 zeer hoog',
        'unlock' => 'niet vergrendeld',
        'lock' => 'vergrendeld',
        'tmp_lock' => 'tijdelijk_lock',
        'agent' => 'behandelaar',
        'system' => 'systeem',
        'customer' => 'klant',
        'Ticket create notification' => 'Melding bij het aanmaken van een ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'U ontvangt een melding telkens wanneer een nieuw ticket wordt aangemaakt in een van uw "Mijn wachtrijen" of "Mijn diensten".',
        'Ticket follow-up notification (unlocked)' => 'Melding bij een nieuwe reactie op een ticket (niet vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een ontgrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'Ticket follow-up notification (locked)' => 'Melding bij een nieuwe reactie op een ticket (vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een vergrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'Ticket lock timeout notification' => 'Melding bij tijdsoverschrijding van een vergrendeld ticket',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'U ontvangt een melding zodra een ticket van u automatisch wordt ontgrendeld.',
        'Ticket owner update notification' => 'Melding bij een nieuwe eigenaar',
        'Ticket responsible update notification' => 'Melding bij een nieuwe verantwoordelijke',
        'Ticket new note notification' => 'Melding bij een nieuwe notitie',
        'Ticket queue update notification' => 'Melding bij het verplaatsen van een ticket',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'U ontvangt een melding als een ticket wordt verplaatst naar een van uw "Mijn wachtrijen".',
        'Ticket pending reminder notification (locked)' => 'Melding wanneer een reminder afloopt (vergrendeld)',
        'Ticket pending reminder notification (unlocked)' => 'Melding wanneer een reminder afloopt (niet vergrendeld)',
        'Ticket escalation notification' => 'Ticket escalatie melding',
        'Ticket escalation warning notification' => 'Ticket escalatie waarschuwing notificatie',
        'Ticket service update notification' => 'Ticket service update melding',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'U ontvangt een melding als de service van een ticket is gewijzigd in een van uw \'Mijn services\'.',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => 'Foutmelding bij het versturen van de e-mail over dit ticket',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Alles toevoegen',
        'An item with this name is already present.' => 'Er bestaat al een item met deze naam.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dit item bevat sub-items. Weet u zeker dat u dit item inclusief subitems wilt verwijderen?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '',
        'Less' => '',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wilt u dit veld definitief verwijderen? Alle data in dit veld wordt ook verwijderd!',
        'Delete field' => 'Verwijder veld',
        'Deleting the field and its data. This may take a while...' => 'Dit veld en al zijn data word verwijderd. Dit kan even duren....',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Selectie verwijderen',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Verwijder deze event trigger.',
        'Duplicate event.' => 'Dupliceer event.',
        'This event is already attached to the job, Please use a different one.' =>
            'Dit event is al gekoppeld aan deze taak. Kies een andere.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Er is een fout opgetreden tijdens de communicatie.',
        'Request Details' => 'Details verzoek',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Toon of verberg de inhoud.',
        'Clear debug log' => 'Leeg debug-log.',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Verwijder deze invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Verwijder sleutelkoppeling',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Verwijder deze operatie',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Kloon webservice',
        'Delete operation' => 'Verwijder operatie',
        'Delete invoker' => 'Verwijder invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WAARSCHUWING: Als u de naam van de groep \'admin\'aanpast voordat u de bijbehorende wijzigingen in de Systeemconfiguratie heeft aangebracht, zult u geen beheer-permissies meer hebben in OTOBO. Als dit gebeurt, moet u de naam van de groep aanpassen met een SQL statement.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Weet u zeker dat u de taal van deze melding wilt verwijderen?',
        'Do you really want to delete this notification?' => 'Wenst u deze melding te verwijderen?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => '',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Verwijder van canvas',
        'No TransitionActions assigned.' => 'Geen transitie-acties toegewezen.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Er zijn nog geen dialogen toegewezen. Kies een dialoog uit de lijst en sleep deze hiernaartoe.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Deze activiteit kan niet worden verwijderd omdat het de start-activiteit is.',
        'Remove the Transition from this Process' => 'Verwijder deze transitie uit dit proces',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Als u deze knop of link gebruikt, verlaat u dit scherm en de huidige staat wordt automatisch opgeslagen. Wilt u doorgaan?',
        'Delete Entity' => 'Verwijderen',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Deze activiteit wordt al gebruikt in dit proces. U kunt het niet tweemaal gebruiken.',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Een niet-verbonden transitie is al op de canvas geplaatst. Verbindt deze transitie alvorens een nieuwe transitie te plaatsen.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Deze transitie wordt al gebruikt in deze activiteit. U kunt het niet tweemaal gebruiken.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Deze transitie-actie wordt al gebruikt in dit pad. U kunt het niet tweemaal gebruiken.',
        'Hide EntityIDs' => 'Verberg ID\'s',
        'Edit Field Details' => 'Bewerk veld-details',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Update versturen...',
        'Support Data information was successfully sent.' => 'Support Data is succesvol verstuurd',
        'Was not possible to send Support Data information.' => 'Het was niet mogelijk om Support Data te versturen.',
        'Update Result' => 'Update Resultaat',
        'Generating...' => 'Genereren...',
        'It was not possible to generate the Support Bundle.' => 'Het was niet mogelijk om de Support Bundel te genereren',
        'Generate Result' => 'Genereer Resultaat',
        'Support Bundle' => 'Support Bundel',
        'The mail could not be sent' => 'De mail kon niet verzonden woden.',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Bezig met laden...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => '',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => '',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Weet je zeker dat u dit systeemonderhoud wilt verwijderen?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Vorige',
        'Resources' => '',
        'Su' => 'zo',
        'Mo' => 'ma',
        'Tu' => 'di',
        'We' => 'wo',
        'Th' => 'do',
        'Fr' => 'vr',
        'Sa' => 'za',
        'This is a repeating appointment' => '',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '',
        'All occurrences' => '',
        'Just this occurrence' => '',
        'Too many active calendars' => '',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Dubbel adres',
        'It is going to be deleted from the field, please try again.' => 'Het wordt verwijderd van dit veld, probeer opnieuw.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Geef één of meerdere tekens of een wildcard als * op om een zoekopdracht uit te voeren.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informatie over de OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Bekijk de waarden in de als rood gemarkeerde velden.',
        'month' => 'maand',
        'Remove active filters for this widget.' => 'Verwijder actieve filters voor dit widget.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Helaas, maar je kun niet alle methoden voor notificatie markeren als verplicht.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Helaas is het niet mogelijk om alle methodes voor deze notificatie uit te zetten.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Omschakelen naar desktop weergave',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Verwijder de volgende woorden van je zoekactie omdat daar niet op gezocht kan worden:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Weet u zeker dat u deze rapportage wilt verwijderen?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Weet je zeker dat je door wil gaan?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filter interacties',
        'Apply' => 'Toepassen',
        'Event Type Filter' => 'Gebeurtenis type filter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Schuif de navigaiebalk',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Zet a.u.b. Compatibility Mode in Internet Explorer uit!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Omschakelen naar weergave voor telefoons / tablets',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => '',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Een of meerdere problemen zijn opgetreden.',

        # JS File: Core.Installer
        'Mail check successful.' => 'Mail controle gelukt.',
        'Error in the mail settings. Please correct and try again.' => 'Fout in de mailinstellingen. Corrigeer ze en probeer nog eens.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Open datumkiezer',
        'Invalid date (need a future date)!' => 'Ongeldig (datum kan niet in verleden zijn).',
        'Invalid date (need a past date)!' => 'Ongeldige datum (heb een datum in het verleden nodig!)',

        # JS File: Core.UI.InputFields
        'Not available' => 'Niet beschikbaar',
        'and %s more...' => 'en nog %s meer...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Alles weghalen',
        'Filters' => 'Filters',
        'Clear search' => 'Verwijder zoekactie',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Als u deze pagina verlaat worden alle openstaande popup-vensters ook gesloten.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Er is al een popup open voor dit ticket. Wilt u deze sluiten en de nieuwe laden?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan geen popup openen. Schakel popup blockers uit voor deze website.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Er zijn nu geen elementen beschikbaar om te kiezen.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'ja',
        'no' => 'nee',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Gegroepeerd',
        'Stacked' => 'Gestapeld',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Stream',
        'Expanded' => 'Uitgebreid',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to remove all user values?',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Click to select or drop files here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Ignore',
        'Import web service',
        'Information about the OTOBO Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Migrate',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Package',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Results',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show all',
        'Show current selection',
        'Show less',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This dynamic field database value is already selected.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTOBO Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Time needed',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Uninstall from OTOBO',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
