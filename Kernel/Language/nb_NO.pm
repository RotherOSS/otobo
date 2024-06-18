# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2004 Arne Georg Gleditsch <argggh at linpro.no>
# Copyright (C) 2005 Espen Stefansen <libbe at stefansen dot net>
# Copyright (C) 2006 Knut Haugen <knuthaug at linpro.no>
# Copyright (C) 2007-2009 Fredrik Andersen <fredrik.andersen at husbanken.no>
# Copyright (C) 2010-2011 Eirik Wulff <eirik at epledoktor.no>
# Copyright (C) 2011 Lars Erik Utsi Gullerud <lerik at nolink.net>
# Copyright (C) 2011 Espen Stefansen <libbe at stefansen dot net>
# Copyright (C) 2012 Lars Magnus Herland <lars.magnus at herland.priv.no>
# Copyright (C) 2013 Espen Stefansen <libbe at stefansen dot net>
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

package Kernel::Language::nb_NO;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M %Y %T';
    $Self->{DateFormatLong}      = '%A %D. %B %Y %T';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.948063644551186;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Administrasjon: ACL',
        'Filter by valid state' => '',
        'Include invalid ACLs' => '',
        'Actions' => 'Handlinger',
        'Create New ACL' => 'Opprett ACL',
        'Deploy ACLs' => 'Distribuere ACLer',
        'Export ACLs' => 'Eksporter ACLer',
        'Filter for ACLs' => 'Filter for ACLer',
        'Just start typing to filter...' => 'Bare start å skrive, for å filtrere...',
        'Configuration Import' => 'Import av konfigurasjon',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Her kan du laste opp en konfigurasjonsfil for å importere ACLer til systemet ditt. Filen må være på .yml format som eksportert av ACL editor modulen.',
        'This field is required.' => 'Dette feltet er obligatorisk.',
        'Overwrite existing ACLs?' => 'Overskriv eksisterende ACLer?',
        'Upload ACL configuration' => 'Last opp ACL konfigurasjon',
        'Import ACL configuration(s)' => 'Importer ACL-konfigurasjon(er)',
        'Description' => 'Beskrivelse',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'For å opprette en ny ACL kan du enten importere ACLer som ble eksportert fra et annet system eller opprettet en helt ny ACL.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Endringer i ACLene her påvirker bare systemets oppførsel dersom du distribuerer ACL-dataene etterpå. Ved å distribuere ACL-dataene, vil de nye endringene bli skrevet til konfigurasjonen.',
        'To delete an existing ACL you have to set the validity to invalid and save it. Afterwards a new button to delete the ACL will appear.' =>
            '',
        'ACLs' => 'ACLer',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Obs! Denne tabellen representerer eksekveringssekvensen på ACL\'ene. Dersom du trenger å endre på sekvensen på hvilke ACL\'er som utføres, vær vennlig å endre navnet på de berørte ACL\'ene.',
        'ACL name' => 'ACL navn',
        'Comment' => 'Kommentar',
        'Validity' => 'Gyldighet',
        'Export' => 'Eksporter',
        'Copy' => 'Kopier',
        'No data found.' => 'Ingen data funnet.',
        'No matches found.' => 'Ingen treff funnet.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Endre ACL %s',
        'Edit ACL' => 'Endre ACL',
        'Go to overview' => 'Gå til oversikt',
        'Delete ACL' => 'Slett ACL',
        'Delete Invalid ACL' => 'Slett ugyldig ACL',
        'Match settings' => 'Match innstillinger',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Opprett matchende kriterier for denne ACL\'en. Benytt \'Egenskaper\' for å matche gjeldende skjerm eller \'EgenskapDatabase\' for å matche attributter i databasen for gjeldende sak.',
        'Change settings' => 'Endre innstillinger',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Opprett de endringene du ønsker å utføre når kriteriene matcher. Merk at \'Muligens\' er en hviteliste, mens \'MuligensIkke\' er en svarteliste.',
        'Check the official %sdocumentation%s.' => 'Sjekk offisiell %sdocumentation%s.',
        'Show or hide the content' => 'Vis eller skjul innholdet',
        'Edit ACL Information' => 'Endre ACL informasjon',
        'Name' => 'Navn',
        'Stop after match' => 'Stopp ved treff',
        'Edit ACL Structure' => 'Endre ACL struktur',
        'Save ACL' => 'Lagre ACL',
        'Save' => 'Lagre',
        'or' => 'av',
        'Save and finish' => 'Lagre og fullfør',
        'Cancel' => 'Avbryt',
        'Do you really want to delete this ACL?' => 'Vil du virkelig fjerne denne ACLen?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Opprett en ny ACL ved å sende inn skjemaet. Etter at ACL\'en er opprettet vil du kunne legge til konfigurasjonselementer i \'edit\' modus.',

        # Template: AdminAbout
        'About' => 'Om',
        'Toggle this widget' => 'Slå av/på denne modulen',
        'This language is not present or enabled on the system. This text could be deleted if it is not needed anymore.' =>
            'Språket er ikke tilgjengelig eller slått på for systemet. Denne teksten kan slettes hvis den ikke lenger er nødvendig.',
        'Remove Language' => 'Fjern språk',
        'Text' => 'Tekst',
        'Message body' => 'Meldingstekst',
        'This field is required and must have less than 4000 characters.' =>
            'Dette feltet er påkrevd og må ha mindre enn 4000 tegn.',
        'Remove About Language' => 'Fjern Om språk',
        'Add new language' => 'Legg til nytt språk',
        'Save Changes' => 'Lagre endringer',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Kalenderadministrasjon',
        'Add Calendar' => 'Legg til kalender',
        'Edit Calendar' => 'Endre kalender',
        'Include invalid calendars' => '',
        'Calendar Overview' => 'Kalenderoversikt',
        'Add new Calendar' => 'Legg til ny kalender',
        'Import Appointments' => 'Importer avtaler',
        'Calendar Import' => 'Kalenderimport',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Her kan du laste opp en konfigurasjonsfil for å importere en kalender. Filen må være på samme \'.yml\' format som da den ble eksportert av kalenderhåndteringsmodulen.',
        'Overwrite existing entities' => 'Overskriv eksisterende entiteter',
        'Upload calendar configuration' => 'Last opp kalenderkonfigurasjon',
        'Import Calendar' => 'Importer kalender',
        'Filter for Calendars' => 'Filter for kalender',
        'Filter for calendars' => 'Filter for kalendere',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Brukere vil få tilgang til kalenderen i henhold til deres rettighetsnivå og gruppefelt.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Skrivebeskyttet: brukere kan se og eksportere alle avtaler i kalenderen.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Flytt inn i: brukere kan endre avtaler i kalenderen, men uten å endre kalendervalg.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Opprett: brukere kan opprette og slette avtaler i kalenderen.',
        'Read/write: users can manage the calendar itself.' => 'Les/skriv: brukere kan selv administrere kalenderen.',
        'Group' => 'Gruppe',
        'Changed' => 'Endret',
        'Created' => 'Opprettet',
        'Download' => 'Last ned',
        'URL' => 'URL',
        'Export calendar' => 'Eksporter kalender',
        'Download calendar' => 'Last ned kalender',
        'Copy public calendar URL' => 'Kopier offentlig kalender URL',
        'Calendar' => 'Kalender',
        'Calendar name' => 'Kalendernavn',
        'Calendar with same name already exists.' => 'Kalender med samme navn eksisterer allerede.',
        'Color' => 'Farge',
        'Permission group' => 'Rettighetersgruppe',
        'Ticket Appointments' => 'Avtaler tilknyttet saker',
        'Rule' => 'Regel',
        'Remove this entry' => 'Slett denne posten',
        'Remove' => 'Fjern',
        'Start date' => 'Startdato',
        'End date' => 'Sluttdato',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Bruk opsjonene under for å innskrenke hvilke saksavtaler som vil bli opprettet automatisk.',
        'Queues' => 'Køer',
        'Please select a valid queue.' => 'Vennligst velg en gyldig kø.',
        'Search attributes' => 'Søkeatributter',
        'Add entry' => 'Ny post',
        'Add' => 'Legg til',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definer regler for opprettelse av automatiske avtaler i denne kalenderen basert på saksinformasjon.',
        'Add Rule' => 'Legg til regel',
        'Submit' => 'Send',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Avtaleimport',
        'Go back' => 'Gå tilbake',
        'Uploaded file must be in valid iCal format (.ics).' => 'Den opplastede filen må være på gyldig iCal format (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Hvis den ønskede kalenderen ikke er listet opp her, vær vennlig å huske at du må ha rettigheten \'opprett\' i din profil.',
        'Upload' => 'Last opp',
        'Update existing appointments?' => 'Oppdater eksisterende avtaler?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Alle eksisterende kalenderavtaler med samme \'UniqueID\' vil bli overskrevet.',
        'Upload calendar' => 'Last opp kalender',
        'Import appointments' => 'Importer avtaler',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Administrer varsler om avtale',
        'Add Notification' => 'Legg til varsling',
        'Edit Notification' => 'Endre varsling',
        'Include invalid appointment notifications' => '',
        'Include invalid appoitnment notifications' => '',
        'Export Notifications' => 'Eksporter varslinger',
        'Filter for Notifications' => 'Filter for varslinger',
        'Filter for notifications' => 'Filter for varslinger',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Her kan du laste opp en konfigurasjonsfil for import av kalender til ditt system. Filen skal være i samme .yml-format som kalendermodulen eksporterer.',
        'Overwrite existing notifications?' => 'Overskriv eksisterende varslinger?',
        'Upload Notification configuration' => 'Last opp varslingskonfigurasjon',
        'Import Notification configuration' => 'Importer varslingskonfigurasjon',
        'List' => 'Liste',
        'Delete' => 'Slett',
        'Delete this notification' => 'Slett denne varslingen',
        'Show in agent preferences' => 'Vis i agent-innstillinger',
        'Agent preferences tooltip' => 'Hjelpetekst for agentinnstillinger',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Denne beskjeden vil bli vist på agent-innstillingsskjermen, som hjelpetekst for denne varslingen.',
        'Events' => 'Hendelser',
        'Event' => 'Hendelse',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Her kan du velge hvilke hendelser som skal utløse dette varselet. Et ekstra avtalefilter kan legges til nedenfor slik at kun meldinger som oppfyller visse kriterier sendes.',
        'Appointment Filter' => 'Avtalefilter',
        'Type' => 'Type',
        'Title' => 'Tittel',
        'Location' => 'Kart',
        'Team' => 'Gruppe',
        'Resource' => 'Ressurs',
        'Recipients' => 'Mottakere',
        'Send to' => 'Send til',
        'Send to these agents' => 'Sent til disse saksbehandlerne',
        'Send to all group members (agents only)' => 'Send til alle medlemmer av gruppen (kun agenter)',
        'Send to all role members' => 'Send til alle medlemmer av rolle',
        'Send on out of office' => 'Send ved ute av kontoret',
        'Also send if the user is currently out of office.' => 'Send også hvis brukeren ikke er på kontoret.',
        'Once per day' => 'En gang per dag',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Send kun melding til bruker en gang daglig per avtale, med valgt transportmetode.',
        'Notification Methods' => 'Varslingsmetoder',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Dette er de mulige metodene som kan brukes for å sende dette varselet til hver av mottakerne. Velg minst én metode nedenfor.',
        'Enable this notification method' => 'Aktiver denne varslingsmetoden',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Minst én metode er nødvendig per varsling.',
        'Active by default in agent preferences' => 'Aktiv som standard i agentpreferanser',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Dette er standardverdien for tildelte mottakeragenter som ikke har valgt dette varselet i innstillingene sine ennå. Hvis boksen er aktivert, vil varselet bli sendt til slike agenter.',
        'This feature is currently not available.' => 'Denne funksjonen er p.t. ikke tilgjengelig.',
        'Upgrade to %s' => 'Oppgrader til %s',
        'Please activate this transport in order to use it.' => 'Aktiver denne transporten for å bruke den.',
        'No data found' => 'Ingen data funnet',
        'No notification method found.' => 'Ingen varslingsmetode funnet.',
        'Notification Text' => 'Varslingstekst',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Dette språket er ikke tilstede eller aktivert på systemet. Denne varslingsteksten kan bli slettet hvis den ikke er nødvendig lenger.',
        'Remove Notification Language' => 'Fjern varslingsspråk',
        'Subject' => 'Emne',
        'Add new notification language' => 'Legg til nytt varslingsspråk',
        'Tag Reference' => 'Etikettreferanse',
        'Notifications are sent to an agent.' => 'Varslinger sendes til en saksbehandler.',
        'You can use the following tags' => 'Du kan bruke de følgende "tags"',
        'To get the first 20 character of the appointment title.' => 'For å hente de første 20 tegnene i avtaleoverskriften.',
        'To get the appointment attribute' => 'For å hente avtaleattributtet',
        ' e. g.' => ' f.eks.',
        'To get the calendar attribute' => 'For å hente kalenderattributtet',
        'Attributes of the recipient user for the notification' => 'Attributter til mottakerbrukeren for varselet',
        'Config options' => 'Valg for oppsett',
        'Example notification' => 'Eksempel på melding',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Ytterligere mottakeres e-postadresser',
        'This field must have less then 200 characters.' => 'Dette feltet må ha mindre enn 200 tegn.',
        'Article visible for customer' => 'Artikkelen er synlig for kunden',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'En artikkel vil bli opprettet hvis varselet sendes til kunden eller en ekstra e-postadresse.',
        'Email template' => 'E-post mal',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Bruk denne malen til å generere hele e-posten (kun for HTML-e-poster).',
        'Enable email security' => 'Aktiver e-postsikkerhet',
        'Email security level' => 'Sikkerhetsnivå for e-post',
        'If signing key/certificate is missing' => 'Hvis signeringsnøkkel/sertifikat mangler',
        'If encryption key/certificate is missing' => 'Hvis krypteringsnøkkel/sertifikat mangler',

        # Template: AdminAttachment
        'Attachment Management' => 'Administrasjon: Vedlegg',
        'Add Attachment' => 'Legg til vedlegg',
        'Edit Attachment' => 'Endre vedlegg',
        'Include invalid attachments' => '',
        'Filter for Attachments' => 'Filter for vedlegg',
        'Filter for attachments' => 'Filter for vedlegg',
        'Filename' => 'Filnavn',
        'Download file' => 'Last ned fil',
        'Delete this attachment' => 'Slett dette vedlegget',
        'Do you really want to delete this attachment?' => 'Vil du virkelig slette dette vedlegget?',
        'Attachment' => 'Relations',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administrasjon: Autosvar',
        'Add Auto Response' => 'Legg Til Autosvar',
        'Edit Auto Response' => 'Endre Autosvar',
        'Include invalid auto responses' => '',
        'Filter for Auto Responses' => 'Filter for Autosvar',
        'Filter for auto responses' => 'Filter for autosvar',
        'Response' => 'Svar',
        'Auto response from' => 'Autosvar fra',
        'Reference' => 'Referanse',
        'To get the first 20 character of the subject.' => 'For å hente de første 20 tegnene i overskriften.',
        'To get the first 5 lines of the email.' => 'For å hente de første 5 linjene i e-posten.',
        'To get the name of the ticket\'s customer user (if given).' => 'For å få navnet på sakens kundebruker (hvis gitt).',
        'To get the article attribute' => 'For å hente innlegg-attributtet',
        'Options of the current customer user data' => 'Valg for den nåværende brukerens brukerdata',
        'Ticket owner options' => 'Valg for sakens eier',
        'Ticket responsible options' => 'Valg for saksansvarlige',
        'Options of the current user who requested this action' => 'Valg for den nåværende brukeren som ba om denne handlingen',
        'Options of the ticket data' => 'Valg for sakens data',
        'Options of ticket dynamic fields internal key values' => 'Alternativer for interne nøkkelverdier i sakens dynamiske felt',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Alternativer for dynamiske saksfelt viser verdier, nyttige for rullegardin- og flervalgsfelt',
        'Example response' => 'Eksempel på svar',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Håndtering av skytjenester',
        'Support Data Collector' => 'Support Data Collector',
        'Support data collector' => 'Support data collector',
        'Hint' => 'Hint',
        'Currently support data is only shown in this system.' => 'For øyeblikket vises støttedata kun i dette systemet.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            'Noen ganger anbefales det å sende disse dataene til OTOBO-teamet for å få bedre støtte.',
        'Configuration' => 'Backups;Eldre',
        'Send support data' => 'Send support data',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            'Dette vil tillate systemet å sende ytterligere støttedatainformasjon til OTOBO-teamet.',
        'Update' => 'Oppdater',
        'System Registration' => 'Registrering av systemet',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'For å aktivere datasending, vennligst registrer systemet ditt hos OTOBO-teamet eller oppdater systemregistreringsinformasjonen din (sørg for å aktivere alternativet \'send støttedata\'.)',
        'Register this System' => 'Registrer dette systemet',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Registrering av systemet er deaktivert for ditt system. Vennligst undersøk din konfigurasjon.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            'Systemregistrering er en tjeneste fra OTOBO-teamet, som gir mange fordeler!',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Vennligst husk på at bruken av OTOBO sine skytjenester krever at systemet er registrert.',
        'Register this system' => 'Registrer dette systemet',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Her kan du finne konfigurere tilgjengelige skytjenester som kommuniserer sikkert med %s.',
        'Available Cloud Services' => 'Tilgjengelige skytjenester',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Kommunikasjonslogg',
        'Time Range' => 'Tidsspenn',
        'Show only communication logs created in specific time range.' =>
            'Vis kun kommunikasjonslogger opprettet i en bestemt tidsperiode.',
        'Filter for Communications' => 'Filter for kommunikasjon',
        'Filter for communications' => 'Filter for kommunikasjon',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'På denne skjermen kan du se en oversikt over innkommende og utgående kommunikasjon.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Du kan endre sorteringen og rekkefølgen på kolonnene ved å klikke på kolonneoverskriften.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Hvis du klikker på de forskjellige oppføringene, vil du bli omdirigert til et detaljert skjermbilde om meldingen.',
        'Status for: %s' => 'Status for: %s',
        'Failing accounts' => 'Sviktende kontoer',
        'Some account problems' => 'Noen kontoproblemer',
        'No account problems' => 'Ingen kontoproblemer',
        'No account activity' => 'Ingen kontoaktivitet',
        'Number of accounts with problems: %s' => 'Antall kontoer med problemer: %s',
        'Number of accounts with warnings: %s' => 'Antall kontoer med advarsler: %s',
        'Failing communications' => 'Sviktende kommunikasjon',
        'No communication problems' => 'Ingen kommunikasjonsproblemer',
        'No communication logs' => 'Ingen kommunikasjonslogger',
        'Number of reported problems: %s' => 'Antall rapporterte problemer: %s',
        'Open communications' => 'Åpen kommunikasjon',
        'No active communications' => 'Ingen aktiv kommunikasjon',
        'Number of open communications: %s' => 'Antall åpne kommunikasjoner: %s',
        'Average processing time' => 'Gjennomsnittlig behandlingstid',
        'List of communications (%s)' => 'Liste over kommunikasjon (%s)',
        'Settings' => 'Innstillinger',
        'Entries per page' => 'Oppføringer per side',
        'No communications found.' => 'Fant ingen kommunikasjon.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Kontostatus',
        'Back to overview' => 'Tilbake til oversikten',
        'Filter for Accounts' => 'Filter for kontoer',
        'Filter for accounts' => 'Filter for kontoer',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Du kan endre sorteringen og rekkefølgen på disse kolonnene ved å klikke på kolonneoverskriften.',
        'Account status for: %s' => 'Kontostatus for: %s',
        'Status' => 'Status',
        'Account' => 'Konto',
        'Edit' => 'Rediger',
        'No accounts found.' => 'Ingen kontoer funnet.',
        'Communication Log Details (%s)' => 'Detaljer for kommunikasjonslogg (%s)',
        'Direction' => 'Retning',
        'Start Time' => 'Starttid',
        'End Time' => 'Sluttid',
        'No communication log entries found.' => 'Ingen kommunikasjonsloggoppføringer funnet.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Varighet',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioritet',
        'Module' => 'Modul',
        'Information' => 'Informasjon',
        'No log entries found.' => 'Ingen loggoppføringer funnet.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Detaljvisning for %s kommunikasjon startet kl. %s',
        'Filter for Log Entries' => 'Filter for loggoppføringer',
        'Filter for log entries' => 'Filter for loggoppføringer',
        'Show only entries with specific priority and higher:' => 'Vis bare oppføringer med spesifikk prioritet og høyere:',
        'Communication Log Overview (%s)' => 'Oversikt over kommunikasjonslogg (%s)',
        'No communication objects found.' => 'Fant ingen kommunikasjon.',
        'Communication Log Details' => 'Kommunikasjonsloggdetaljer',
        'Please select an entry from the list.' => 'Velg en oppføring fra listen.',

        # Template: AdminContactWD
        'Contact with data management' => 'Kontakt med dataadministrasjon',
        'Contact with data' => 'Kontakt med data',
        'Add contact with data' => 'Legg til kontakt med data',
        'Edit contact with data' => 'Rediger kontakt med data',
        'Back to search results' => 'Tilbake til søkeresultatet',
        'Select' => 'Velg',
        'Search' => 'Index',
        'Wildcards like \'*\' are allowed.' => 'Jokertegn som \'*\ er tillatt.',
        'Please enter a search term to look for contacts with data.' => 'Skriv inn et søkeord for å se etter kontakter med data.',
        'Valid' => 'Gyldig',

        # Template: AdminCustomerAccept
        'Privacy Policy Management' => 'Håndtering av personvernregler',
        'Privacy Policy' => 'Personvernerklæring',
        'Remove PrivacyPolicy Language' => 'Fjern språk på personvernerklæring',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Administrasjon: Kunder',
        'Add Customer' => 'Legg til kunde',
        'Edit Customer' => 'Endre kunde',
        'Include invalid customer companies' => '',
        'List (only %s shown - more available)' => 'Liste (bare %s vist - mer tilgjengelig)',
        'total' => 'total',
        'Please enter a search term to look for customers.' => 'Vennligst skriv et søkekriterie for å lete etter kunder.',
        'Customer ID' => 'Kunde-ID',
        'Please note' => 'Vær oppmerksom på',
        'This customer backend is read only!' => 'Denne kundestøtten er skrivebeskyttet!',

        # Template: AdminCustomerDashboardInfoTile
        'Customer Info' => '',
        'Customer Info Management' => '',
        'Create new info tile entry' => '',
        'Filter for info tile entries' => '',
        'Create a new entry to be displayed on the info tile on the customer dashboard.' =>
            '',
        'Stop date' => 'Sluttdato',
        'Delete info tile entry' => '',

        # Template: AdminCustomerDashboardInfoTileEdit
        'Edit customer dashboard info tile entry' => '',
        'Date invalid!' => 'Ugyldig dato!',
        'Tile content' => '',
        'Content Body' => '',
        'Marquee content' => '',
        'Group Selection' => '',

        # Template: AdminCustomerDashboardInfoTileNew
        'Create new customer dashboard info tile entry' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Administrere forhold mellom Kunde og Gruppe',
        'Notice' => 'Notis',
        'This feature is disabled!' => 'Denne funksjonen er deaktivert!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Bruk denne funksjonen kun dersom du vil definere grupperettigheter for kunder.',
        'Enable it here!' => 'Aktiver denne her!',
        'Edit Customer Default Groups' => 'Endre standardgrupper for kunder',
        'These groups are automatically assigned to all customers.' => 'Disse gruppene blir automatisk tildelt alle nye kunder.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Du kan administrere disse gruppene via konfigurasjonsinnstillingen "CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filter for Grupper',
        'Select the customer:group permissions.' => 'Velg rettigheter for kunde:gruppe.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Hvis ingenting blir valgt vil det ikke være noen rettigheter for denne gruppen (saker vil ikke være synlige for brukeren).',
        'Search Results' => 'Søkeresultat',
        'Customers' => 'Kunder',
        'Groups' => 'Grupper',
        'Change Group Relations for Customer' => 'Endre grupperettigheter for Kunde',
        'Change Customer Relations for Group' => 'Endre kundekoplinger for gruppe',
        'Toggle %s Permission for all' => 'Slå av/på %s-tilgang for alle',
        'Toggle %s permission for %s' => 'Slå av/på %s-tilgang for %s',
        'Customer Default Groups:' => 'Standardgrupper for kunder:',
        'No changes can be made to these groups.' => 'Kan ikke endre disse gruppene.',
        'ro' => 'lesetilgang',
        'Read only access to the ticket in this group/queue.' => 'Kun lese-tilgang til saker i denne gruppen/køen.',
        'rw' => 'skrivetilgang',
        'Full read and write access to the tickets in this group/queue.' =>
            'Full lese- og skrive-tilgang til saker i denne gruppen/køen.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Administrasjon: Kundebruker',
        'Add Customer User' => 'Legg til kunde-bruker',
        'Edit Customer User' => 'Endre kunde-bruker',
        'Include invalid customer users' => '',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Kundebrukere trengs for å kunne ha kundehistorikk og mulighet til å logge inn via brukerpanelet.',
        'List (%s total)' => 'Liste (%s totalt)',
        'Username' => 'Brukernavn',
        'Email' => 'E-post',
        'Last Login' => 'Siste innlogging',
        'Login as' => 'Logg inn som',
        'Switch to customer' => 'Bytt til kunde',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Denne kunde-backenden er skrivebeskyttet, men kundens brukerpreferanser kan endres!',
        'This field is required and needs to be a valid email address.' =>
            'Dette feltet er påkrevd og trenger å være en gyldig e-postadresse.',
        'This email address is not allowed due to the system configuration.' =>
            'Denne e-postadressen er ikke tillatt i systemkonfigurasjonen.',
        'This email address failed MX check.' => 'Denne e-postadressen feilet i en DNS-test (ingen MX).',
        'DNS problem, please check your configuration and the error log.' =>
            'Navntjener (DNS) problem, vennligst se på konfigurasjonen og i error loggen.',
        'The syntax of this email address is incorrect.' => 'Syntaksen på denne e-postadressen er feil.',
        'This CustomerID is invalid.' => 'Denne kunde-IDen er ugyldig.',
        'Effective Permissions for Customer User' => 'Effektive tillatelser for kundebruker',
        'Group Permissions' => 'Gruppetilganger',
        'This customer user has no group permissions.' => 'Denne kunden har ingen gruppetillatelser.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Tabellen ovenfor viser effektive gruppetillatelser for kundebrukeren. Matrisen tar hensyn til alle nedarvede tillatelser (f.eks. via kundegrupper). Merk: Tabellen tar ikke hensyn til endringer som er gjort i dette skjemaet uten å sende det inn.',
        'Customer Access' => 'Kundetilgang',
        'Customer' => 'Kunde',
        'This customer user has no customer access.' => 'Denne kundebrukeren har ingen kundetilgang.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Tabellen ovenfor viser gitt kundetilgang for kundebrukeren etter tillatelseskontekst. Matrisen tar hensyn til all nedarvet tilgang (f.eks. via kundegrupper). Merk: Tabellen tar ikke hensyn til endringer som er gjort i dette skjemaet uten å sende det inn.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Administrer kundebruker-kunderelasjoner',
        'Select the customer user:customer relations.' => 'Velg kundebruker:kunderelasjoner.',
        'Customer Users' => 'Kunder',
        'Change Customer Relations for Customer User' => 'Endre kundeforhold for kundebruker',
        'Change Customer User Relations for Customer' => 'Endre kundebrukerforhold for kunden',
        'Toggle active state for all' => 'Slå av/på aktivisering for alle',
        'Active' => 'Aktiv',
        'Toggle active state for %s' => 'Slå av/på aktivisering for %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Administrer kundebruker-grupperelasjoner',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Bare bruk denne funksjonen hvis du vil definere gruppetillatelser for kundebrukere.',
        'Edit Customer User Default Groups' => 'Rediger standardgrupper for kundebrukere',
        'These groups are automatically assigned to all customer users.' =>
            'Disse gruppene blir automatisk tildelt alle kundebrukere.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Du kan styre disse gruppene gjennom innstillingen "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtrer for grupper',
        'Select the customer user - group permissions.' => 'Velg kundebruker - gruppetillatelser.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Hvis ingenting er valgt, er det ingen tillatelser i denne gruppen (saker vil ikke være tilgjengelige for kundebrukeren).',
        'Customer User Default Groups:' => 'Standardgrupper for kundebrukere:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Administrer kundeservicerelasjoner',
        'Edit default services' => 'Endre standardtjenester',
        'Filter for Services' => 'Filter for tjenester',
        'Filter for services' => 'Filter for tjenester',
        'Services' => 'Tjenester',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Administrasjon: Dynamiske felt',
        'Include invalid dynamic fields' => '',
        'Filter for Dynamic Fields' => 'Filter for dynamiske felt',
        'Filter for dynamic fields' => 'Filter for dynamiske felt',
        'Filter field by object type' => '',
        'Filter field by namespace' => '',
        'Add new field for object' => 'Legg til nytt felt for et objekt',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'For å legge til et nytt felt, velg felttypen fra en av objektets liste, objektet definerer grensen for feltet og det kan ikke endres etter feltopprettingen.',
        'New Dynamic Fields' => 'Nye dynamiske felt',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            'Vil du dra nytte av flere dynamiske felttyper? Du har full tilgang til følgende felttyper:',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Bruk eksterne databaser som konfigurerbare datakilder for dette dynamiske feltet.',
        'Web service' => 'Nettjeneste',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Eksternenettjenester kan konfigureres som datakilder for dette dynamiske feltet.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Denne funksjonen gjør det mulig å legge til (flere) kontakter med data til saker.',
        'Dynamic Fields List' => 'Liste over dynamiske felt',
        'Dynamic fields per page' => 'Dynamiske felt per side',
        'Label' => 'Etikett',
        'Order' => 'Sortering',
        'Object' => 'Objekt',
        'Copy this field' => '',
        'Delete this field' => 'Fjern dette feltet',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => 'Import / Eksport',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            'Her kan du laste opp en konfigurasjonsfil for å importere dynamiske felt til systemet ditt. Filen må være i .yml-format som eksportert av den dynamiske feltstyringsmodulen.',
        'DynamicFields Import' => 'Import av dynamiske felter',
        'DynamicFields Export' => 'Eksport av dynamiske felter',
        'Dynamic Fields Screens' => 'Dynamiske felt-skjermer',
        'Here you can manage the dynamic fields in the respective screens.' =>
            'Her kan du administrere de dynamiske feltene i de respektive skjermbildene.',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamiske felte',
        'Go back to overview' => 'Gå tilbake til oversikten',
        'General' => 'Generelt',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dette feltet er påkrevd, og innholdet må bare være bokstaver og tall.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Må være unikt og bare inneholde bokstaver og tall.',
        'Changing this value will require manual changes in the system.' =>
            'Endring av denne verdien vil kreve manuelle endringer i systemet.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Dette er navnet som vil bli vist på skjermen hvor feltet er aktivert.',
        'Field order' => 'Feltrekkefølge',
        'This field is required and must be numeric.' => 'Dette feltet er påkrevd og må inneholde tall.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Dette er rekkefølgen som vises på feltene på skjermen hvor de er aktive.',
        'Namespace' => 'Navneområde',
        'This is the namespace in which this field will be used as prefix with the name.' =>
            '',
        'Tooltip message:' => 'Verktøytipsmelding:',
        'This is the tooltip message shown inside the customer interface.' =>
            'Dette er verktøytipsmeldingen som vises i kundegrensesnittet.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Det er ikke mulig å ugyldiggjøre denne oppføringen, alle konfigurasjonsinnstillinger må endres på forhånd.',
        'Field type' => 'Felt type',
        'Object type' => 'Objekt type',
        'Internal field' => 'Internt felt',
        'This field is protected and can\'t be deleted.' => 'Dette feltet er beskyttet og kan ikke slettes.',
        'This dynamic field is used in the following config settings:' =>
            'Dette dynamiske feltet brukes i følgende konfigurasjonsinnstillinger:',
        'Field Settings' => 'Felt Innstillinger',
        'Default value' => 'Standardverdi',
        'This is the default value for this field.' => 'Dette er standardverdien for dette feltet.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => 'Legg til eller rediger kontakter',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            'For å legge til kontakter i dette feltet, fyll ut all nødvendig informasjon og lagre den.',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            'Klikk på feltnavnet fra oversikten for å redigere det og finn den tilsvarende handlingen i sidefeltet eller fra \'Saker\'-menyen.',
        'Name Field' => 'Navnefelt',
        'ValidID Field' => 'Gyldig ID-felt',
        'Other Fields' => 'Andre felt',
        'Key' => 'Nøkkel',
        'Value' => 'Verdi',
        'Remove value' => 'Fjern verdi',
        'Add Field' => 'Legg til felt',
        'Add value' => 'Legg til verdi',
        'These are the possible data attributes for contacts.' => 'Dette er de mulige dataattributtene for kontakter.',
        'Mandatory fields' => 'Obligatoriske felt',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            'Kommaseparert liste over obligatoriske nøkler (valgfritt). Nøklene "Navn" og "Gyldig ID" er alltid obligatoriske og trenger ikke å være oppført her.',
        'Sorted fields' => 'Sorterte felt',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            'Kommaseparert liste over nøkler i sorteringsrekkefølge (valgfritt). Taster som er oppført her kommer først, alle gjenværende felt etterpå og sortert alfabetisk.',
        'Searchable fields' => 'Søkbare felt',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            'Kommaseparert liste over søkbare nøkler (valgfritt). Nøkkel \'Navn\' er alltid søkbar og trenger ikke å være oppført her.',
        'Translatable values' => 'Oversettbare verdier',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Om du aktiverer dette valget vil verdiene bli oversatt til det bruker har definert som språk.',
        'Note' => 'Notis',
        'You need to add the translations manually into the language translation files.' =>
            'Du må legge til oversettelsen manuelt i språkfilen.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Tilgjengelige verdier',
        'Datatype' => 'Datatype',
        'Filter' => 'Filter',
        'Searchfield' => 'Søkefelt',
        'Listfield' => 'Listefelt',
        'Show link' => 'Vis lenke',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Her kan du angi en valgfri HTTP-lenke for feltverdien i Oversikter og Zoom-skjermer.',
        'Example' => 'Eksempel',
        'You can reference the field with its own field name. You can also refer to other fields, e.g. with \'DynamicField_OtherFieldName\'.' =>
            'Du kan referere til feltet med sitt eget feltnavn. Du kan også vise til andre felt, f.eks. med \'DynamicField_OtherFieldName\'.',
        'Link for preview' => 'Lenke for forhåndsvisning',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Hvis den er fylt ut, vil denne URL-en bli brukt for en forhåndsvisning som vises når denne lenken holdes i sak-zoom. Vær oppmerksom på at for at dette skal fungere, må det vanlige URL-feltet ovenfor også fylles ut.',
        'SID' => 'SID',
        'Driver' => 'Driver',
        'Server' => 'Tjener',
        'Port' => 'Port',
        'Table / View' => 'Tabell / Visning',
        'User' => 'Bruker',
        'Password' => 'Passord',
        'Identifier' => 'Nøkkel',
        'Must be unique column from the table entered in Table/View.' => 'Må være unik kolonne fra tabellen angitt i Tabell/Visning.',
        'Multiselect' => 'Flervalg',
        'CacheTTL' => 'CacheTTL',
        'Searchprefix' => 'Søkeprefiks',
        'Searchsuffix' => 'Søkesuffiks',
        'Result Limit' => 'Resultatgrense',
        'Case Sensitive' => 'Skiller mellom store og små bokstaver',
        'Multiple Values' => '',
        'Activate this option to allow multiple values for this field.' =>
            '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standard dato forskjeller',
        'This field must be numeric.' => 'Dette feltet må inneholde tall.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Forskjellen fra NÅ (i sekunder) for å beregne feltets standardverdi (f.eks. 3600 eller -60).',
        'Define years period' => 'Definer årsperiode',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktiver denne funksjonen for å definere et fast område av år (i fremtiden og i fortiden) som skal vises på årsdelen av feltet.',
        'Years in the past' => 'År i fortiden',
        'Years in the past to display (default: 5 years).' => 'År i det siste som skal vises (standard: 5 år).',
        'Years in the future' => 'År i fremtiden',
        'Years in the future to display (default: 5 years).' => 'År i fremtiden som skal vises (standard: 5 år).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Hvis spesialtegn (&, @, :, / osv.) ikke skal kodes, bruk \'url\' i stedet for \'uri\'-filter.',
        'Restrict entering of dates' => 'Begrens inntasting av datoer',
        'Here you can restrict the entering of dates of tickets.' => 'Her kan du begrense inntasting av datoer for saker.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Legg til verdi',
        'Add empty value' => 'Legg til tom verdi',
        'Activate this option to create an empty selectable value.' => 'Aktiver dette valget for å lage tomme valgbare verdier.',
        'Tree View' => 'Trestruktur',
        'Activate this option to display values as a tree.' => 'Aktiver dette valget for å vise verdier som en trestruktur.',

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '%s - %s',
        'Select the items you want to ' => 'Velg elementene du vil ',
        'Select the desired elements and confirm the import with \'import\'.' =>
            'Velg de ønskede elementene og bekreft importen med \'importer\'.',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            'Her kan du eksportere en konfigurasjonsfil med dynamiske felt og dynamiske feltskjermer for å importere disse på et annet system. Konfigurasjonsfilen eksporteres i yml-format.',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            'Følgende dynamiske felt kan ikke importeres på grunn av en ugyldig backend.',
        'Toggle all available elements' => 'Veksle alle tilgjengelige elementer',
        'Fields' => 'Felter',
        'Screens' => 'Skjermer',

        # Template: AdminDynamicFieldReference
        'Check ReferenceFilter' => '',
        'Below you can configure filters to restrict the list of referenced objects. The filters compare an attribute of the referenced object either to an attribute of the mask you are currently editing or to a fixed string.' =>
            '',
        'Object attribute' => '',
        'Select an attribute of the referenced object by which the selectable entries will be filtered.' =>
            '',
        'Invalid ReferenceFilter_ReferenceObjectAttribute' => '',
        'matches mask attribute' => '',
        'Select an attribute of the edit mask to compare the selected attribute of the referenced object against.' =>
            '',
        'matches string' => '',
        'Type a string to compare the selected attribute of the referenced object against.' =>
            '',
        'Add ReferenceFilter' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => 'Håndtering av dynamiske felt <-> skjermer',
        'Overview' => 'Oversikt',
        'Default Columns Screens' => 'Skjermer for standard kolonner',
        'Add DynamicField' => 'Legg til dynamisk felt',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            'Du kan tilordne elementer til denne skjermen/feltet ved å dra elementene med musen fra venstre liste til høyre liste.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Det er også mulig å sortere elementene i listen ved å dra og slippe.',
        'Filter available elements' => 'Filtrer tilgjengelige elementer',
        'selected to available elements' => 'valgt til tilgjengelige elementer',
        'Available Elements' => 'Tilgjengelige elementer',
        'Filter disabled elements' => 'Filtrer deaktiverte elementer',
        'selected to disabled elements' => 'valgt til deaktiverte elementer',
        'Toggle all disabled elements' => 'Veksle alle deaktiverte elementer',
        'Disabled Elements' => 'Deaktiverte elementer',
        'Filter assigned elements' => 'Filtrer tilordnede elementer',
        'selected to assigned elements' => 'valgt til tilordnede elementer',
        'Toggle all assigned elements' => 'Veksle alle tildelte elementer',
        'Assigned Elements' => 'Tilordnede elementer',
        'Filter assigned required elements' => 'Filtrer tildelte påkrevde elementer',
        'selected to assigned required elements' => 'valgt til tilordnede nødvendige elementer',
        'Toggle all assigned required elements' => 'Veksle alle tildelte nødvendige elementer',
        'Assigned Required Elements' => 'Tilordnede påkrevd elementer',
        'Reset' => 'Nullstill',

        # Template: AdminDynamicFieldScript
        'Expression' => '',
        'The function which will be evaluated.' => '',
        'Requirements' => '',
        'If set, the function will only be evaluated if all chosen attributes are set.' =>
            '',
        'Preview Triggers' => '',
        'If set, the field will be recalculated upon AJAX updates in edit masks.' =>
            '',
        'Storage Triggers (Events)' => '',
        'If set, the field will be recalculated for the following events.' =>
            '',
        'Check RegEx' => 'Sjekk RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Her kan du angi et regulært uttrykk for å kontrollere verdien. Regex vil bli utført med modifikatorene xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ugyldig RegEx',
        'Error Message' => 'Feilmelding',
        'Add RegEx' => 'Legg til RegEx',

        # Template: AdminDynamicFieldSet
        'Auto Indent Code' => '',
        'Comment/Uncomment Code' => '',
        'Search & Replace' => '',
        'Select All' => '',
        'Full Screen' => '',
        'The YAML array of included dynamic fields. Syntax: \'--- [{DF: Name},...]\'' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Antall rader',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Spesifiser høyden (i antall linjer) for dette feltet i endrings-modus.',
        'Number of cols' => 'Antall kolonner',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Spesifiser bredden (i antall tegn) for dette feltet i endrings-modus.',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Relations',
        'Style' => 'Stil',
        'bold' => 'fet skrift',
        'italic' => 'kursiv',
        'underline' => 'understreket',
        'Font style of the label.' => 'Skriftstilen til etiketten.',
        'Size' => 'Størrelse',
        'Font size of the label.' => 'Skriftstørrelse på etiketten.',
        'Color in hex.' => 'Farge i hex.',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Dette feltet er obligatorisk',
        'The web service to be executed for possible values.' => 'Webtjenesten som skal utføres for mulige verdier.',
        'Invoker' => 'Utløser',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            'Utløseren som skal brukes til å utføre forespørsler (utløseren må være av typen \'Generic::PassThrough\').',
        'Activate this option to allow multiselect on results.' => 'Aktiver dette alternativet for å tillate flervalg på resultater.',
        'Cache TTL' => 'Cache TTL',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            'Buffertid (i minutter), for å lagre de hentede mulige verdiene.',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            'Her kan du angi en valgfri HTTP-lenke for feltverdien i Oversikter og Zoom-skjermer. Valgfri HTTP-kobling fungerer bare for enkeltvalgte felt.',

        # Template: AdminEmail
        'Admin Message' => 'Admin-melding',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Med denne modulen kan administratorer sende meldinger til saksbehandlere, gruppe- eller rolle-medlemmer.',
        'Create Administrative Message' => 'Lag Administrativ melding',
        'Your message was sent to' => 'Meldingen ble sendt til',
        'From' => 'Fra',
        'Send message to users' => 'Send melding til brukere',
        'Send message to group members' => 'Send melding til gruppemedlemmer',
        'Group members need to have permission' => 'Gruppemedlemmer må ha tilgang',
        'Send message to role members' => 'Send melding til medlemmer av rolle',
        'Also send to customers in groups' => 'Send også til kunder i grupper',
        'Body' => 'Meldingstekst',
        'Send' => 'Send',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Generisk agent jobbehandler',
        'Edit Job' => 'Rediger jobb',
        'Add Job' => 'Legg til jobb',
        'Run Job' => 'Kjør jobb',
        'Include invalid jobs' => '',
        'Filter for Jobs' => 'Filter for jobber',
        'Filter for jobs' => 'Filter for jobber',
        'Last run' => 'Sist kjørt',
        'Run Now!' => 'Kjør nå!',
        'Delete this task' => 'Slett denne oppgaven',
        'Run this task' => 'Kjør denne oppgaven',
        'Job Settings' => 'Innstillinger for jobb',
        'Job name' => 'Navn',
        'The name you entered already exists.' => 'Navnet du oppga finnes allerede.',
        'Automatic Execution (Multiple Tickets)' => 'Automatisk utførelse (flere saker)',
        'Execution Schedule' => 'Utførelsesplan',
        'Schedule minutes' => 'Minutter',
        'Schedule hours' => 'Timer',
        'Schedule days' => 'Dager',
        'Automatic execution values are in the system timezone.' => 'Verdiene for automatisk utførelse er i systemets tidssone.',
        'Currently this generic agent job will not run automatically.' =>
            'Føreløpig vil ikke denne generiske agentjobben kjøres automatisk.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'For å skru på automatisk utførelse velg minst en verdi i form av minutter, timer og dager!',
        'Event Based Execution (Single Ticket)' => 'Hendelsesbasert gjennomføring (enkeltsak)',
        'Event Triggers' => 'Hendelse utløser',
        'List of all configured events' => 'Liste over alle konfigurerte hendelser',
        'Delete this event' => 'Fjern denne hendelsen',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'I tillegg til eller alternativt til en periodisk utførelse, kan du definere sakshendelser som vil utløse denne jobben.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Hvis en sakshendelse utløses, vil saksfilteret bli brukt for å sjekke om saken stemmer. Først da kjøres jobben på den saken.',
        'Do you really want to delete this event trigger?' => 'Vil du virkelig slette denne hendelsesutløseren?',
        'Add Event Trigger' => 'Legg til hendelse utløser',
        'To add a new event select the event object and event name' => 'For å legge til en ny hendelse, velg hendelsesobjektet og hendelsesnavnet',
        'Select Tickets' => 'Velg saker',
        '(e. g. 10*5155 or 105658*)' => 'f.eks. 10*5144 eller 105658*',
        '(e. g. 234321)' => 'f.eks. 234321',
        'Customer user ID' => 'Kundens bruker-ID',
        '(e. g. U5150)' => 'f.eks. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fulltekst-søk i innlegg (f.eks. "Mar*in" eller "Baue*").',
        'To' => 'Default;Tilbakestill',
        'Cc' => 'Kopi',
        'Service' => 'Tjeneste',
        'Service Level Agreement' => 'Tjenestenivåavtale',
        'Queue' => 'Kø',
        'State' => 'Status',
        'Agent' => 'Saksbehandler',
        'Owner' => 'Eier',
        'Responsible' => 'Ansvarlig',
        'Ticket lock' => 'Sakslås',
        'Dynamic fields' => 'Dynamiske felter',
        'Add dynamic field' => 'Legg til dynamisk felt',
        'Create times' => 'Opprettelsestidspunkt',
        'No create time settings.' => 'Ingen opprettelsestidspunkt innstillinger.',
        'Ticket created' => 'Sak opprettet',
        'Ticket created between' => 'Sak opprettet mellom',
        'and' => 'og',
        'Last changed times' => 'Sist endrede tider',
        'No last changed time settings.' => 'Ingen siste endrede tidsinnstillinger.',
        'Ticket last changed' => 'Saken ble sist endret',
        'Ticket last changed between' => 'Sak sist byttet mellom',
        'Change times' => 'Bytt tider',
        'No change time settings.' => 'Ingen endringstidspunkt innstillinger.',
        'Ticket changed' => 'Sak endret',
        'Ticket changed between' => 'Sak endret mellom',
        'Last close times' => 'Siste lukkede tider',
        'No last close time settings.' => 'Ingen siste innstillinger for lukket tid.',
        'Ticket last close' => 'Sak sist lukket',
        'Ticket last close between' => 'Sak sist lukket mellom',
        'Close times' => 'Stengningstidspunkt',
        'No close time settings.' => 'Ingen stengetid-innstilling.',
        'Ticket closed' => 'Sak låst',
        'Ticket closed between' => 'Sak låst mellom',
        'Pending times' => 'Ventetider',
        'No pending time settings.' => 'Ingen innstillinger for ventetid.',
        'Ticket pending time reached' => 'Ventetiden er nådd',
        'Ticket pending time reached between' => 'Ventetiden er nådd mellom',
        'Escalation times' => 'Eskaleringstid',
        'No escalation time settings.' => 'Ingen eskaleringsinnstillinger.',
        'Ticket escalation time reached' => 'Sakens eskaleringstid nådd',
        'Ticket escalation time reached between' => 'Sakens eskaleringstid nådd mellom',
        'Escalation - first response time' => 'Eskalering - første responstid',
        'Ticket first response time reached' => 'Sakens første responstid nådd',
        'Ticket first response time reached between' => 'Sakens første responstid nådd mellom',
        'Escalation - update time' => 'Eskalering - oppdateringtidspunkt',
        'Ticket update time reached' => 'Sakens oppdateringtidspunkt nådd',
        'Ticket update time reached between' => 'Sakens oppdateringstid nådd mellom',
        'Escalation - solution time' => 'Eskalering - løsnings-tid',
        'Ticket solution time reached' => 'Sakens løsnings-tid nådd',
        'Ticket solution time reached between' => 'Sakens løsnings-tid nådd mellom',
        'Archive search option' => 'Valg for arkivert søk',
        'Update/Add Ticket Attributes' => 'Oppdater/legg til saksattributter',
        'Set new service' => 'Sett ny tjeneste',
        'Set new Service Level Agreement' => 'Sett ny Tjenestenivåavtale',
        'Set new priority' => 'Sett ny prioritet',
        'Set new queue' => 'Sett ny kø',
        'Set new state' => 'Sett ny status',
        'Pending date' => 'Sett på vent til',
        'Set new agent' => 'Sett ny saksbehandler',
        'new owner' => 'ny eier',
        'new responsible' => 'ny ansvarlig',
        'Set new ticket lock' => 'Sett ny sakslås',
        'New customer user ID' => 'Ny kunde-ID',
        'New customer ID' => 'Ny Kunde-ID',
        'New title' => 'Nytt emne',
        'New type' => 'Ny type',
        'Archive selected tickets' => 'Arkiver valgte saker',
        'Add Note' => 'Legg til notis',
        'Visible for customer' => 'Synlig for kunden',
        'Time units' => 'Tidsenheter',
        'Execute Ticket Commands' => 'Utfør sakskommandoer',
        'Send agent/customer notifications on changes' => 'Send en saksbehandler-/kunde-varsling ved endringer',
        'CMD' => 'Kommando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Denne kommandoen vil bli kjørt. ARG[0] vil være saksnummer. ARG[1] saks-id.',
        'Delete tickets' => 'Slett saker',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'ADVARSEL: Alle saker som blir funnet av denne jobben vil bli slettet og kan ikke gjenopprettes!',
        'Execute Custom Module' => 'Kjør tilpasset modul',
        'Param %s key' => 'Nøkkel for Parameter %s',
        'Param %s value' => 'Verdi for Parameter %s',
        'Results' => 'Resultat',
        '%s Tickets affected! What do you want to do?' => '%s saker blir påvirket! Hva vil du gjøre?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'ADVARSEL: Du brukte SLETTE-valget. Alle saker som slettes blir borte for godt!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Advarsel: Det er %s saker berørt, men bare %s kan endres i løpet av én jobbutførelse!',
        'Affected Tickets' => 'Antall saker påvirket',
        'Age' => 'Alder',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Administrasjon: Generiske webtjenester',
        'Web Service Management' => 'Nettjenestehåndtering',
        'Debugger' => 'Feilsøker',
        'Go back to web service' => 'Gå tilbake til web tjeneste',
        'Clear' => 'Tøm',
        'Do you really want to clear the debug log of this web service?' =>
            'Vil du virkelig tømme feilsøkerloggen for denne web tjenesten?',
        'Request List' => 'Forespørselsliste',
        'Time' => 'Range;Historisk',
        'Communication ID' => 'Kommunikasjons-ID',
        'Remote IP' => 'Fjernstyrt IP',
        'Loading' => 'Laster',
        'Select a single request to see its details.' => 'Velg en enkelt forespørsel for å se detaljene.',
        'Filter by type' => 'Filtrer ut fra type',
        'Filter from' => 'Filtrer fra',
        'Filter to' => 'Filtrer til',
        'Filter by remote IP' => 'Filtrer ut fra ekstern IP',
        'Limit' => 'Grense',
        'Refresh' => 'Oppdater',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Legg til feilhåndtering',
        'Edit ErrorHandling' => 'Rediger feilhåndtering',
        'Do you really want to delete this error handling module?' => 'Vil du virkelig slette denne feilhåndteringsmodulen?',
        'All configuration data will be lost.' => 'Alle konfigurasjons-data vil gå tapt.',
        'General options' => 'Generelle alternativer',
        'The name can be used to distinguish different error handling configurations.' =>
            'Navnet kan brukes til å skille forskjellige feilhåndteringskonfigurasjoner.',
        'Please provide a unique name for this web service.' => 'Vennligst velg et unikt navn for denne webtjenesten.',
        'Error handling module backend' => 'Backend for feilhåndteringsmodul',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Denne OTOBO-feilhåndteringsmodulen vil bli kalt internt for å behandle feilhåndteringsmekanismen.',
        'Processing options' => 'Behandlingsalternativer',
        'Configure filters to control error handling module execution.' =>
            'Konfigurer filtre for å kontrollere utførelse av feilhåndteringsmoduler.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Bare forespørsler som samsvarer med alle konfigurerte filtre (hvis noen) vil utløse modulkjøring.',
        'Operation filter' => 'Driftsfilter',
        'Only execute error handling module for selected operations.' => 'Utfør bare feilhåndteringsmodul for utvalgte operasjoner.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Merk: Driften er ubestemt for feil som oppstår under mottak av innkommende forespørselsdata. Filtre som involverer dette feilstadiet skal ikke bruke operasjonsfilter.',
        'Invoker filter' => 'Utløserfilter',
        'Only execute error handling module for selected invokers.' => 'Utfør bare feilhåndteringsmodul for utvalgte utløsere.',
        'Error message content filter' => 'Innholdsfilter for feilmelding',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Skriv inn et regulært uttrykk for å begrense hvilke feilmeldinger som skal forårsake kjøring av feilhåndteringsmodul.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Feilmeldingsemne og data (som vist i feilsøkingsfeiloppføringen) vil vurderes for et samsvar.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Eksempel: Skriv inn \'^.*401 Uautorisert.*\ for å håndtere kun autentiseringsrelaterte feil.',
        'Error stage filter' => 'Feil trinnfilter',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Utfør bare feilhåndteringsmodulen på feil som oppstår under bestemte behandlingstrinn.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Eksempel: Håndter bare feil der kartlegging for utgående data ikke kunne brukes.',
        'Error code' => 'Feilkode',
        'An error identifier for this error handling module.' => 'En feilidentifikator for denne feilhåndteringsmodulen.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Denne identifikatoren vil være tilgjengelig i XSLT-Mapping og vises i feilsøkingsutdata.',
        'Error message' => 'Feilmelding',
        'An error explanation for this error handling module.' => 'En feilforklaring for denne feilhåndteringsmodulen.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Denne meldingen vil være tilgjengelig i XSLT-Mapping og vises i feilsøkingsutdata.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Definer om behandlingen skal stoppes etter at modulen ble utført, og hoppe over alle gjenværende moduler eller bare de fra samme backend.',
        'Default behavior is to resume, processing the next module.' => 'Standard oppførsel er å gjenoppta og behandle neste modul.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Denne modulen lar deg konfigurere planlagte forsøk for mislykkede forespørsler.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Standardoppførselen til GenericInterface-netttjenester er å sende hver forespørsel nøyaktig én gang og ikke å omplanlegge etter feil.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Hvis mer enn én modul som er i stand til å planlegge et nytt forsøk utføres for en individuell forespørsel, er modulen som ble utført sist autoritativ og avgjør om et nytt forsøk er planlagt.',
        'Request retry options' => 'Alternativer for å prøve kallet på nytt',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Alternativer for forsøk på nytt brukes når forespørsler forårsaker kjøring av feilhåndteringsmoduler (basert på behandlingsalternativer).',
        'Schedule retry' => 'Planlegg et nytt forsøk',
        'Should requests causing an error be triggered again at a later time?' =>
            'Bør forespørsler som forårsaker en feil utløses igjen på et senere tidspunkt?',
        'Initial retry interval' => 'Innledende forsøksintervall',
        'Interval after which to trigger the first retry.' => 'Intervall som det første forsøket på nytt skal utløses etter.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Merk: Dette og alle ytterligere gjenforsøksintervaller er basert på utførelsestiden for feilhåndteringsmodulen for den første forespørselen.',
        'Factor for further retries' => 'Faktor for ytterligere forsøk',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Hvis en forespørsel returnerer en feil selv etter et første forsøk på nytt, definer om påfølgende forsøk skal utløses med samme intervall eller i økende intervaller.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Eksempel: Hvis en forespørsel først utløses kl. 10:00 med startintervall på \'1 minutt\' og forsøksfaktor ved \'2\', vil gjenforsøk bli utløst kl. 10:01 (1 minutt), 10:03 (2*1=2) minutter), 10:07 (2*2=4 minutter), 10:15 (2*4=8 minutter), ...',
        'Maximum retry interval' => 'Maksimalt gjenforsøksintervall',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Hvis en ny forsøksintervallfaktor på \'1,5\' eller \'2\' er valgt, kan uønsket lange intervaller forhindres ved å definere det største tillatte intervallet.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Intervaller beregnet til å overskride det maksimale gjenforsøksintervallet vil da automatisk bli forkortet tilsvarende.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Eksempel: Hvis en forespørsel først utløses kl. 10.00 med startintervall på \'1 minutt\', forsøksfaktor ved \'2\' og maksimalt intervall ved \'5 minutter\', vil gjenforsøk bli utløst kl. 10.01 (1 minutt), 10 :03 (2 minutter), 10:07 (4 minutter), 10:12 (8=>5 minutter), 10:17, ...',
        'Maximum retry count' => 'Maksimalt antall forsøk på nytt',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Maksimalt antall forsøk før en mislykket forespørsel blir forkastet, ikke medregnet den første forespørselen.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Eksempel: Hvis en forespørsel først utløses kl. 10:00 med et startintervall på \'1 minutt\', prøvefaktor på \'2\' og maksimalt antall forsøk ved \'2\', vil gjenforsøk kun utløses kl. 10:01 og 10:02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Merk: Maksimalt antall gjenforsøk kan kanskje ikke nås hvis en maksimal gjenforsøksperiode også er konfigurert og nådd tidligere.',
        'This field must be empty or contain a positive number.' => 'Dette feltet må være tomt eller inneholde et positivt tall.',
        'Maximum retry period' => 'Maksimal prøveperiode',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Maksimal tidsperiode for gjenforsøk av mislykkede forespørsler før de forkastes (basert på utførelsestiden for feilhåndteringsmodulen for den første forespørselen).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Nye forsøk som normalt vil bli utløst etter at maksimumsperioden er utløpt (i henhold til beregning av nytt forsøksintervall) vil automatisk bli utløst nøyaktig ved maksimal periode.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Eksempel: Hvis en forespørsel først utløses kl. 10:00 med startintervall på \'1 minutt\', prøvefaktor på \'2\' og maksimal prøveperiode ved \'30 minutter\', vil gjenforsøk bli utløst kl. 10:01, 10:03, 10:07, 10:15 og til slutt kl 10:31=>10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Merk: Maksimal gjenforsøkstid kan kanskje ikke nås hvis et maksimalt antall gjenforsøk også er konfigurert og nådd tidligere.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Legg til utløser',
        'Edit Invoker' => 'Rediger utløser',
        'Do you really want to delete this invoker?' => 'Vil du virkelig fjerne denne anroperen?',
        'Invoker Details' => 'Detaljerte Anrop',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Navnet er typisk brukt for å kalle opp en handling på en fjernstyrt web tjeneste.',
        'Invoker backend' => 'Utløser-backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Denne OTOBO utløserbackend-modulen vil bli kalt for å forberede dataene som skal sendes til det eksterne systemet, og for å behandle responsdataene.',
        'Mapping for outgoing request data' => 'Kartlegging for utgående forespørselsdata',
        'Configure' => 'Konfigurer',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dataene fra utløseren til OTOBO vil bli behandlet av denne kartleggingen, for å transformere den til den typen data det eksterne systemet forventer.',
        'Mapping for incoming response data' => 'Kartlegging for innkommende svardata',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Svardataene vil bli behandlet av denne kartleggingen, for å transformere den til den typen data som brukeren av OTOBO forventer.',
        'Asynchronous' => 'Asynkron',
        'Condition' => 'Tilstand',
        'Edit this event' => 'Rediger denne hendelsen',
        'This invoker will be triggered by the configured events.' => 'Denne utløseren vil bli utløst av de konfigurerte hendelsene.',
        'Add Event' => 'Legg til hendelse',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'For å legge til en ny hendelse velg hendelsesobjektet og hendelsesnavnet og klikk på "+"-knappen',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Asynkrone hendelsestriggere håndteres av OTOBO Scheduler Daemon i bakgrunnen (anbefalt).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synkrone hendelsestriggere vil bli behandlet direkte under nettforespørselen.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Innstillinger for GenericInterface utløserhendelse for nettjeneste %s',
        'Go back to' => 'Gå tilbake til',
        'Delete all conditions' => 'Slett alle betingelser',
        'Do you really want to delete all the conditions for this event?' =>
            'Vil du virkelig slette alle betingelsene for dette arrangementet?',
        'General Settings' => 'Generelle innstillinger',
        'Event type' => 'Hendelsestype',
        'Conditions' => 'Tilstander',
        'Conditions can only operate on non-empty fields.' => 'Betingelser kan kun operere på ikke-tomme felt.',
        'Type of Linking between Conditions' => 'Koblingstype mellom tilstander',
        'Remove this Condition' => 'Slett denne tilstanden',
        'Type of Linking' => 'Koblingtype',
        'Add a new Field' => 'Legg til et nytt felt',
        'Remove this Field' => 'Fjern dette feltet',
        'And can\'t be repeated on the same condition.' => 'Og kan ikke gjentas på samme betingelse.',
        'Add New Condition' => 'Legg til ny tilstand',

        # Template: AdminGenericInterfaceInvokerTicket
        'General invoker data' => 'Generelle utløserdata',
        'Settings for outgoing request data' => 'Innstillinger for utgående forespørselsdata',
        'Ticket fields' => 'Saksfelt',
        'Only the selected ticket fields will be considered for the request data.' =>
            'Kun de valgte saksfeltene vil bli vurdert for forespørselsdataene.',
        'Article fields' => 'Artikkelfelt',
        'Only the selected article fields will be considered for the request data.' =>
            'Kun de valgte artikkelfeltene vil bli vurdert for forespørselsdataene.',
        'Ticket dynamic fields' => 'Dynamiske saksfelter',
        'Only the selected ticket dynamic fields will be considered for the request data.' =>
            'Bare de valgte dynamiske saksfeltene vil bli vurdert for forespørselsdataene.',
        'Article dynamic fields' => 'Dynamiske artikkelfelt',
        'Only the selected article dynamic fields will be considered for the request data.' =>
            'Bare de valgte dynamiske artikkelfeltene vil bli vurdert for forespørselsdataene.',
        'Number of articles' => 'Antall artikler',
        'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.' =>
            'De utgående forespørselsdataene vil kun inneholde det konfigurerte antallet artikler. Hvis den står tom, vil kun 1 artikkel bli sendt.',
        'Communication channels' => 'Kommunikasjonskanaler',
        'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.' =>
            'De utgående forespørselsdataene vil kun vurdere artikler fra de valgte kommunikasjonskanalene. Hvis den står tom, vil artikler opprettet av alle kommunikasjonskanaler bli brukt.',
        'Customer visibility' => 'Kundesynlighet',
        'The outgoing request data will only consider articles created with the selected customer visibility.' =>
            'De utgående forespørselsdataene vil kun vurdere artikler som er opprettet med valgt kundesynlighet.',
        'Sender Types' => 'Avsendertyper',
        'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.' =>
            'De utgående forespørselsdataene vil kun vurdere artikler opprettet av de valgte avsendertypene. Hvis den står tom, vil artikler laget av alle avsendertyper bli brukt.',
        'Mapping' => 'Kartlegging',
        'Settings for incoming response data' => 'Innstillinger for innkommende svardata',
        'Remote TicketID dynamic field' => 'Ekstern TicketID dynamisk felt',
        'The selected ticket dynamic field is being used to store the remote TicketID.' =>
            'Det valgte dynamiske saksfeltet brukes til å lagre den eksterne sak-IDen.',
        'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.' =>
            'Hvis den står tom, vil ikke den eksterne saksID-en bli lagret, med mindre du definerer en systemkonfigurasjonsverdi for denne webtjenesten.',
        'The selected field is already in use by the Ticket dynamic fields option.' =>
            'Det valgte feltet er allerede i bruk av alternativet dynamiske saksfelter.',
        'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.' =>
            'Bare de valgte dynamiske saksfeltene vurderes for behandling av innkommende svardata. Hvis det står tomt, vil ikke noe dynamisk felt bli behandlet.',
        'Event data' => 'Hendelsesdata',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Kartlegging Enkel',
        'Default rule for unmapped keys' => 'Standard regler for ukartlagte nøkler',
        'This rule will apply for all keys with no mapping rule.' => 'Denne regelen vil brukes på alle nøkler uten kartleggingsregel.',
        'Default rule for unmapped values' => 'Standard regler for ukartlagte verdier',
        'This rule will apply for all values with no mapping rule.' => 'Denne regelen vil brukes på alle verdien uten kartleggingsregel.',
        'New key map' => 'Nytt nøkkel mapping',
        'Add key mapping' => 'Legg til nøkkel for mapping',
        'Mapping for Key ' => 'Mapping for nøkkel ',
        'Remove key mapping' => 'Fjern nøkkel mapping',
        'Key mapping' => 'Nøkkel mapping',
        'Map key' => 'Mapping nøkkel',
        'matching the' => 'matcher',
        'to new key' => 'til ny nøkkel',
        'Value mapping' => 'Verdi mapping',
        'Map value' => 'Mapping verdi',
        'to new value' => 'til ny verdi',
        'Remove value mapping' => 'Fjern verdi for mapping',
        'New value map' => 'Ny verdi for mapping',
        'Add value mapping' => 'Legg til verdi for mapping',
        'Do you really want to delete this key mapping?' => 'Vil du virkelig slette denne nøkkelen for mapping?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Generelle snarveier',
        'MacOS Shortcuts' => 'MacOS-snarveier',
        'Comment/Uncomment code' => '',
        'Auto indent code' => '',
        'Jump to line' => '',
        'Autocomplete' => '',
        'Find' => 'Finn',
        'Find next' => 'Finn neste',
        'Find previous' => 'Finn forrige',
        'Find and replace' => 'Finn og erstatt',
        'Exit full screen' => '',
        'XSLT Mapping' => 'XSLT-kartlegging',
        'XSLT stylesheet' => 'XSLT-stilark',
        'The entered data is not a valid XSLT style sheet.' => 'De angitte dataene er ikke et gyldig XSLT-stilark.',
        'Here you can add or modify your XSLT mapping code.' => 'Her kan du legge til eller endre din XSLT-tilordningskode.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'Redigeringsfeltet lar deg bruke forskjellige funksjoner som automatisk formatering, endre vindusstørrelse samt tagg- og brakett-fullføring.',
        'Data includes' => 'Data inkluderer',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Velg ett eller flere sett med data som ble opprettet på tidligere forespørsels-/svarstadier som skal inkluderes i kartbare data.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Disse settene vil vises i datastrukturen ved \'/DataInclude/<DataSetName>\' (se debugger-utdata for faktiske forespørsler for detaljer).',
        'Data key regex filters (before mapping)' => 'Regex-filtre for datanøkkel (før kartlegging)',
        'Data key regex filters (after mapping)' => 'Regex-filtre for datanøkkel (etter kartlegging)',
        'Regular expressions' => 'Regex-er',
        'Replace' => 'Erstatt',
        'Remove regex' => 'Fjern regulært uttrykk',
        'Add regex' => 'Legg til regulært uttrykk',
        'These filters can be used to transform keys using regular expressions.' =>
            'Disse filtrene kan brukes til å transformere nøkler ved hjelp av regulære uttrykk.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'Datastrukturen vil gjennomgås rekursivt og alle konfigurerte regexes vil bli brukt på alle nøkler.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Brukstilfeller er f.eks. fjerne nøkkelprefikser som er uønskede eller korrigere nøkler som er ugyldige som XML-elementnavn.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Eksempel 1: Søk = \'^jira:\' / Replace = \'\' gjør \'jira:element\' til \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Eksempel 2: Søk = \'^\' / Replace = \'_\' gjør \'16x16\' til \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Eksempel 3: Søk = \'^(?<nummer>\d+) (?<tekst>.+?)\ / Erstatt = \'_\$+{tekst}_\$+{nummer}\' gjør \'16 elementname\' til \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'For informasjon om regulære uttrykk i Perl, se her:',
        'Perl regular expressions tutorial' => 'Opplæring i Perl regulære uttrykk',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Hvis modifikatorer er ønsket, må de spesifiseres i selve de regulære uttrykkene.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Regulære uttrykk definert her vil bli brukt før XSLT-tilordningen.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Regulære uttrykk definert her vil bli brukt etter XSLT-tilordningen.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Legg til operasjon',
        'Edit Operation' => 'Rediger operasjon',
        'Do you really want to delete this operation?' => 'Vil du virkelig slette denne handlingen?',
        'Operation Details' => 'Detaljerte handlinger',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Navnet brukes vanligvis til å kalle opp denne webtjenesteoperasjonen fra et eksternt system.',
        'Operation backend' => 'Operasjon backend',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Denne OTOBO-operasjonsbackend-modulen vil bli kalt internt for å behandle forespørselen, og generere data for svaret.',
        'Mapping for incoming request data' => 'Kartlegging for innkommende forespørselsdata',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Forespørselsdataene vil bli behandlet av denne kartleggingen, for å transformere den til den typen data OTOBO forventer.',
        'Mapping for outgoing response data' => 'Kartlegging for utgående svardata',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Responsdataene vil bli behandlet av denne kartleggingen, for å transformere den til den typen data det eksterne systemet forventer.',
        'Include Ticket Data' => 'Inkluder saksdata',
        'Include ticket data in response.' => 'Ta med saksdata som svar.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Nettverkstransport',
        'Properties' => 'Egenskaper',
        'Route mapping for Operation' => 'Rutekartlegging for Drift',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Definer ruten som skal tilordnes denne operasjonen. Variabler merket med en \':\' vil bli kartlagt til det angitte navnet og sendt sammen med de andre til kartleggingen. (f.eks. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Gyldige forespørselsmetoder for drift',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Begrens denne operasjonen til spesifikke forespørselsmetoder. Hvis ingen metode er valgt, vil alle forespørsler bli akseptert.',
        'Maximum message length' => 'Maksimal lengde på melding',
        'This field should be an integer number.' => 'Dette feltet inneholde et heltall.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Her kan du spesifisere maksimal størrelse (i byte) på REST-meldinger som OTOBO skal behandle.',
        'Send Keep-Alive' => 'Send Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Denne konfigurasjonen definerer om innkommende tilkoblinger skal stenges eller holdes i live.',
        'Additional response headers' => 'Ytterligere svaroverskrifter',
        'Add response header' => 'Legg til svaroverskrift',
        'Endpoint' => 'Sluttpunkt',
        'URI to indicate specific location for accessing a web service.' =>
            'URI for å angi spesifikk plassering for tilgang til en nettjeneste.',
        'e.g. https://www.otobo.de:10745/api/v1.0 (without trailing backslash)' =>
            'f.eks. https://www.otobo.de:10745/api/v1.0 (uten etterfølgende skråstrek)',
        'Timeout' => 'Pause',
        'Timeout value for requests.' => 'Tidsavbruddsverdi for forespørsler.',
        'Authentication' => 'Autentisering',
        'An optional authentication mechanism to access the remote system.' =>
            'En valgfri autentiseringsmekanisme for å få tilgang til det eksterne systemet.',
        'BasicAuth User' => 'BasicAuth-bruker',
        'The user name to be used to access the remote system.' => 'Brukernavnet til bruk for å få tilgang til det fjernstyrte systemet.',
        'BasicAuth Password' => 'BasicAuth-passord',
        'The password for the privileged user.' => 'Passordet for den priviligerte brukeren.',
        'Kerberos User' => '',
        'Kerberos keytab file' => '',
        'The kerberos keytab file for the privileged user.' => '',
        'Use Proxy Options' => 'Bruk proxy-alternativer',
        'Show or hide Proxy options to connect to the remote system.' => 'Vis eller skjul proxy-alternativer for å koble til det eksterne systemet.',
        'Proxy Server' => 'Proxy server',
        'URI of a proxy server to be used (if needed).' => 'URL til en proxytjener som skal brukes (dersom nødvendig).',
        'e.g. http://proxy_hostname:8080' => 'f.eks. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy bruker',
        'The user name to be used to access the proxy server.' => 'Brukernavnet som skal brukes for å få tilgang til proxy-serveren.',
        'Proxy Password' => 'Proxy passord',
        'The password for the proxy user.' => 'Passordet for proxybrukeren.',
        'Skip Proxy' => 'Hopp over proxy',
        'Skip proxy servers that might be configured globally?' => 'Vil du hoppe over proxy-servere som kan være konfigurert globalt?',
        'Use SSL Options' => 'Bruk SSL valg',
        'Show or hide SSL options to connect to the remote system.' => 'Vis eller skjul SSL valg for å koble til fjernstyrte systemer.',
        'Client Certificate' => 'Klientsertifikat',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Den fullstendige banen og navnet til SSL-klientsertifikatfilen (må være i PEM-, DER- eller PKCS#12-format).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'f.eks. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Klientsertifikatnøkkel',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Den fullstendige banen og navnet til SSL-klientsertifikatnøkkelfilen (hvis den ikke allerede er inkludert i sertifikatfilen).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'f.eks. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Passord for klientsertifikatnøkkel',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Passordet for å åpne SSL-sertifikatet hvis nøkkelen er kryptert.',
        'Certification Authority (CA) Certificate' => 'Sertifiseringsinstans (CA)-sertifikat',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Den fullstendige banen og navnet på sertifiseringsinstansens sertifikatfil som validerer SSL-sertifikatet.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'f.eks. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) Directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Den fullstendige banen til sertifiseringsinstanskatalogen der CA-sertifikatene er lagret i filsystemet.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'f.eks. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => 'SSL-vertsnavnbekreftelse.',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            'Avbryt forespørselen hvis vertsnavnet ikke kan bekreftes. Deaktiver med forsiktighet! Å hoppe over verifisering er en sikkerhetsrisiko! Hovedsakelig for testformål i tilfelle av selvsignerte SSL-sertifikater, eller hvis du vet hva du gjør.',
        'Controller mapping for Invoker' => 'Kontrollermapping for utløser',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Den behandlingsansvarlige som utløseren skal sende forespørsler til. Variabler merket med \':\' vil bli erstattet av dataverdien og sendt sammen med forespørselen. (f.eks. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Gyldig forespørselskommando for utløser',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'En spesifikk HTTP-kommando som skal brukes for forespørslene med denne utløseren (valgfritt).',
        'Default command' => 'Standard kommando',
        'The default HTTP command to use for the requests.' => 'Standard HTTP-kommando som skal brukes for forespørslene.',
        'Additional request headers (all invokers)' => 'Ytterligere forespørselshoder (alle utløsere)',
        'Additional request headers (invoker specific)' => 'Ytterligere forespørselshoder (utløser-spesifikke)',
        'Remove all headers for this invoker' => 'Fjern alle overskrifter for denne utløseren',
        'Headers for invoker' => 'Forespørselshoder for utløser',
        'Additional response headers (all operations)' => 'Ytterligere responshoder (alle operasjoner)',
        'Additional response headers (operation specific)' => 'Ytterligere responshoder (operasjonsspesifikke)',
        'Remove all headers for this operation' => 'Fjern alle hoder for denne operasjonen',
        'Headers for operation' => 'Hoder for drift',
        'Common headers' => 'Vanlige forespørselshoder',
        'Header Name' => 'Navn på forespørselshode',
        'Remove header' => 'Fjern forespørselshode',
        'Add header' => 'Legg til forespørselshode',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otobo.de:8000/Webservice/Example' => 'f.eks. https://local.otobo.de:8000/Webservice/Example',
        'Set SOAPAction' => 'Sett SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Sett til "Ja" for å sende en fylt SOAPAction-header.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Sett til "Nei" for å sende en tom SOAPAction-header.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Sett til "Ja" for å sjekke den mottatte SOAPAction-headeren (hvis den ikke er tom).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Sett til "Nei" for å ignorere den mottatte SOAPAction-headeren.',
        'SOAPAction scheme' => 'SOAPAction ordning',
        'Select how SOAPAction should be constructed.' => 'Velg hvordan SOAPAction skal bygges opp.',
        'Some web services require a specific construction.' => 'Noen webtjenester krever en spesifikk konstruksjon.',
        'Some web services send a specific construction.' => 'Noen webtjenester sender en bestemt konstruksjon.',
        'SOAPAction separator' => 'SOAPAction-separator',
        'Character to use as separator between name space and SOAP operation.' =>
            'Tegn som skal brukes som skilletegn mellom navneområde og SOAP-operasjon.',
        'Usually .Net web services use "/" as separator.' => 'Vanligvis bruker .Net webtjenester "/" som skilletegn.',
        'SOAPAction free text' => 'SOAPAction fritekst',
        'Text to be used to as SOAPAction.' => 'Tekst som skal brukes som SOAPAction.',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI for å gi SOAP-metoder en kontekst og redusere tvetydigheter.',
        'e.g. urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions' =>
            'f.eks. urn:otobo-com:soap:functions eller http://www.otobo.de/GenericInterface/actions',
        'Request name scheme' => 'Be om navneskjema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Velg hvordan SOAP request-funksjonsomslag skal konstrueres.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'Funksjonsnavn\' brukes som eksempel for faktisk utløser-/operasjonsnavn.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' brukes som eksempel for faktisk konfigurert verdi.',
        'Request name free text' => 'Be om navn fritekst',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Tekst som skal brukes som funksjonsomslagsnavnsuffiks eller erstatning.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Vennligst vurder navnebegrensninger for XML-elementer (ikke bruk f.eks. «<» og «&»).',
        'Response name scheme' => 'Svarnavnskjema',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Velg hvordan SOAP-responsfunksjonsinnpakningen skal konstrueres.',
        'Response name free text' => 'Svarnavn fritekst',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Her kan du spesifisere maksimal størrelse (i byte) på SOAP-meldinger som OTOBO skal behandle.',
        'Encoding' => 'Kodifisering',
        'The character encoding for the SOAP message contents.' => 'Tegnkodingen for SOAP-meldingens innhold.',
        'e.g. utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'f.eks. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => 'Sorteringsvalg',
        'Add new first level element' => 'Legg til nytt element på første nivå',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Utgående sorteringsrekkefølge for xml-felt (struktur som starter under funksjonsnavninnpakning) - se dokumentasjon for SOAP-transport.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Legg til webtjeneste',
        'Edit Web Service' => 'Rediger webtjeneste',
        'Include invalid webservices' => '',
        'Clone Web Service' => 'Klon nettjeneste',
        'The name must be unique.' => 'Dette navnet må være unikt.',
        'Clone' => 'Duplisere',
        'Export Web Service' => 'Eksporter webtjeneste',
        'Import web service' => 'Importer webtjeneste',
        'Configuration File' => 'Konfigurasjons-fil',
        'The file must be a valid web service configuration YAML file.' =>
            'Filen må være en godkjent YAML web tjeneste konfigurasjons-fil.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Her kan du angi et navn for webtjenesten. Hvis dette feltet er tomt, brukes navnet på konfigurasjonsfilen som navn.',
        'Import' => 'Importer',
        'Configuration History' => 'Konfigurasjonshistorikk',
        'Delete web service' => 'Fjern webtjeneste',
        'Do you really want to delete this web service?' => 'Vil du virkelig fjerne denne webtjenesten?',
        'Ready2Adopt Web Services' => 'Ready2Adopt nettjenester',
        'Here you can activate Ready2Adopt web services showcasing our best practices.' =>
            'Her kan du aktivere Ready2Adopt-netttjenester som viser våre beste fremgangsmåter.',
        'Import Ready2Adopt web service' => 'Importer Ready2Adopt webtjeneste',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Etter at du har lagret konfigurasjonen, blir du omdirigert igjen til redigeringsskjermen.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Hvis du vil gå tilbake til oversikten, klikk på "Gå til oversikt"-knappen.',
        'Remote system' => 'Fjernstyrt system',
        'Provider transport' => 'Leverandørtransport',
        'Requester transport' => 'Søkertransport',
        'Debug threshold' => 'Feilsøkergrense',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'I leverandørmodus tilbyr OTOBO webtjenester som brukes av eksterne systemer.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'I forespørselsmodus bruker OTOBO webtjenester til eksterne systemer.',
        'Network transport' => 'Nettverkstransport',
        'Error Handling Modules' => 'Feilhåndteringsmoduler',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Feilhåndteringsmoduler brukes til å reagere ved feil under kommunikasjonen. Disse modulene kjøres i en bestemt rekkefølge, som kan endres ved å dra og slippe.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Legg til feilhåndteringsmodul',
        'Operations are individual system functions which remote systems can request.' =>
            'Operasjoner er individuelle systemfunksjoner som eksterne systemer kan be om.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Utløsere forbereder data for en forespørsel til en ekstern nettjeneste, og behandler svardataene.',
        'Controller' => 'Kontrollerer',
        'Inbound mapping' => 'Inngående mapping',
        'Outbound mapping' => 'Utgående mapping',
        'Delete this action' => 'Fjern denne handlingen',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Minst én %s har en kontroller som enten ikke er aktiv eller ikke til stede, vennligst sjekk kontrollerregistreringen eller slett %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historikk',
        'Go back to Web Service' => 'Gå tilbake til Web Tjenester',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Her kan du se eldre versjoner av gjeldende web tjeneste konfigurasjon, eksportere og gjenopprette dem.',
        'Configuration History List' => 'Konfigurasjons-historikk',
        'Version' => 'is',
        'Create time' => 'Opprettelses tid',
        'Select a single configuration version to see its details.' => 'Velg en konfigurasjons-versjon for å se dens detaljer.',
        'Export web service configuration' => 'Eksporter konfigurasjonenn for web tjenesten',
        'Restore web service configuration' => 'Gjenopprett web tjeneste konfigurasjonen',
        'Do you really want to restore this version of the web service configuration?' =>
            'Vil du virkelig gjenopprette denne versjonen av nettjenestekonfigurasjonen?',
        'Your current web service configuration will be overwritten.' => 'Din nåværende nettjenestekonfigurasjon vil bli overskrevet.',

        # Template: AdminGroup
        'Group Management' => 'Administrasjon: Grupper',
        'Add Group' => 'Legg til gruppe',
        'Edit Group' => 'Endre gruppe',
        'Include invalid groups' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '\'admin\'-gruppen gir tilgang til Admin-området, \'stats\'-gruppen til Statistikk-området.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Opprett grupper for å håndtere tilgangsrettigheter for forskjellige grupperinger av saksbehandlinger (f.eks. salgsavdelingen, service, innkjøp, osv.) ',
        'It\'s useful for ASP solutions. ' => 'Det er nyttig for ASP-løsninger. ',

        # Template: AdminImportExport
        'Import/Export Management' => 'Administrasjon av Import/Eksport',
        'Add template' => 'Legg til mal',
        'Create a template to import and export object information.' => 'Opprett en mal for å eksportere og importere informasjon.',
        'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.' =>
            '',
        'Number' => 'Nummer',
        'Format' => 'Format',
        'Start Import' => 'Start import',
        'Start Export' => 'Start eksport',
        'Delete this template' => '',
        'Step 1 of 5 - Edit common information' => '',
        'Name is required!' => 'Navn er påkrevd!',
        'Object is required!' => 'Objekt er påkrevd!',
        'Format is required!' => 'Format er påkrevd!',
        'Next' => 'Neste',
        'Step 2 of 5 - Edit object information' => '',
        'Back' => 'Tilbake',
        'Step 3 of 5 - Edit format information' => '',
        'is required!' => 'er påkrevd!',
        'Step 4 of 5 - Edit mapping information' => '',
        'No map elements found.' => 'Ingen elementer funnet.',
        'Up' => 'Stigende',
        'Down' => 'Synkende',
        'Add Mapping Element' => 'Legg til mapping-element',
        'Step 5 of 5 - Edit search information' => '',
        'Template Name' => 'Navn på mal',
        'Restrict export per search' => 'Begrens eksport per søk',
        'Finish' => 'Ferdig',
        'Import information' => 'Import-informasjon',
        'Source File' => 'Kildefil',
        'Import summary for %s' => '',
        'Records' => 'Rader',
        'Success' => 'Vellykket',
        'Failed' => 'Feilet',
        'Duplicate names' => 'Duplikate navn',
        'Last processed line number of import file' => 'Siste prosesserte linjenummer av importfil',
        'Ok' => 'Ok',
        'Do you really want to delete this template item?' => '',

        # Template: AdminLog
        'System Log' => 'Systemlogg',
        'Here you will find log information about your system.' => 'Her finner du logg-informasjon fra systemet ditt.',
        'Hide this message' => 'Skjul denne meldingen',
        'Recent Log Entries' => 'Siste Loggmeldinger',
        'Facility' => 'Innretning',
        'Message' => 'Text;Chatmeldingstekst;;False;;;Perl',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administrasjon: E-postkontoer',
        'Add Mail Account' => 'Legg til e-postkonto',
        'Edit Mail Account for host' => 'Rediger e-postkonto for vert',
        'and user account' => 'og brukerkonto',
        'Include invalid Mail Accounts' => '',
        'Filter for Mail Accounts' => 'Filter for e-postkontoer',
        'Filter for mail accounts' => 'Filter for e-postkontoer',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Alle innkommende e-poster med én konto vil bli sendt i den valgte køen.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Hvis kontoen din er merket som klarert, vil X-OTOBO-overskriftene som allerede eksisterer ved ankomsttid (for prioritet osv.) beholdes og brukes, for eksempel i PostMaster-filtre.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Utgående e-post kan konfigureres via Sendmail*-innstillingene i %s.',
        'System Configuration' => 'Systeminstillinger',
        'Host' => 'Tjener',
        'Delete account' => 'Slett konto',
        'Fetch mail' => 'Hent e-post',
        'Do you really want to delete this mail account?' => 'Vil du virkelig slette denne e-postkontoen?',
        'Example: mail.example.com' => 'F.eks.: mail.eksempel.com',
        'IMAP Folder' => 'IMAP mappe',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Endre denne om du må hente e-post fra en annen mappe en INBOX.',
        'Trusted' => 'Betrodd',
        'Dispatching' => 'Fordeling',
        'Edit Mail Account' => 'Rediger e-postkonto',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Administrasjonsoversikt',
        'Filter for Items' => 'Filtrer etter varer',
        'Favorites' => 'Favoritter',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Du kan legge til favoritter ved å flytte markøren over elementer på høyre side og klikke på stjerneikonet.',
        'Links' => 'Lenker',
        'View the admin manual' => 'Se administrasjonsmanualen',
        'No Matches' => 'Ingen treff',
        'Sorry, your search didn\'t match any items.' => 'Beklager, søket ditt samsvarte ikke med noen elementer.',
        'Set as favorite' => 'Sett som favoritt',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Håndtering av saksvarsling',
        'Include invalid notifications' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Her kan du laste opp en konfigurasjonsfil for å importere saksvarsler til systemet ditt. Filen må være i .yml-format som eksportert av saksvarslingsmodulen.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Her kan du velge hvilke hendelser som skal utløse dette varselet. Et ekstra saksfilter kan brukes nedenfor for kun å sende for sak med visse kriterier.',
        'Ticket Filter' => 'Saksfilter',
        'Lock' => 'Ta sak',
        'SLA' => 'SLA',
        'Customer User ID' => 'Kundebruker-ID',
        'Article Filter' => 'Artikkelfilter',
        'Only for ArticleCreate and ArticleSend event' => 'Bare for ArticleCreate og ArticleSend-hendelser',
        'Article sender type' => 'Artikkelavsendertype',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Hvis ArticleCreate eller ArticleSend brukes som en triggerhendelse, må du spesifisere et artikkelfilter også. Velg minst ett av artikkelfilterfeltene.',
        'Communication channel' => 'Kommunikasjonskanal',
        'Include attachments to notification' => 'Bruk vedlegg i varslingen',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Varsle brukeren bare én gang om dagen om en enkeltsak med en valgt transport.',
        'Notifications are sent to an agent or a customer.' => 'Varslinger som sendes til saksbehandlere eller kunder.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'For å få de første 20 tegn av emnefeltet (fra den siste agentsaken).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'For å få de første 5 linjene av meldingen (fra den siste agentsaken).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'For å få de første 20 tegn av emnefeltet (fra den siste kundesaken).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'For å få de første 5 linjene av meldingen (fra den siste kundesaken).',
        'Attributes of the current customer user data' => 'Attributter til gjeldende kundebrukerdata',
        'Attributes of the current ticket owner user data' => 'Attributter til gjeldende brukerdata for sakseiere',
        'Attributes of the current ticket responsible user data' => 'Attributter til gjeldende saksansvarliges brukerdata',
        'Attributes of the current agent user who requested this action' =>
            'Attributter til gjeldende agentbruker som ba om denne handlingen',
        'Attributes of the ticket data' => 'Attributter til saksdataene',
        'Ticket dynamic fields internal key values' => 'Interne nøkkelverdier for saksdynamiske felt',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Viste verdier for dynamiske felt for sak, nyttige for rullegardin- og flervalgsfelt',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Bruk komma eller semikolon for å skille e-postadresser.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Du kan bruke OTOBO-tagger som <OTOBO_TICKET_DynamicField_...> for å sette inn verdier fra gjeldende sak.',

        # Template: AdminPGP
        'PGP Management' => 'Administrasjon: PGP',
        'Add PGP Key' => 'Legg Til PGP-nøkkel',
        'PGP support is disabled' => 'PGP støtte er deaktivert',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'For å kunne bruke PGP funksjonen i OTOBO må du først aktivere den.',
        'Enable PGP support' => 'Aktiver PGP støtte',
        'Faulty PGP configuration' => 'Feil i PGP konfigurasjonen',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP støtte er aktivert, men konfigurasjonen inneholder feil. Vær vennlig å gå igjennom konfigurasjonen ved å bruke knappen nedenfor.',
        'Configure it here!' => 'Konfigurer den her!',
        'Check PGP configuration' => 'Sjekk PGP konfigurasjon',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'På denne måten kan du direkte redigere nøkkelringen som er konfigurert i SysConfig.',
        'Introduction to PGP' => 'Introduksjon til PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingeravtrykk',
        'Expires' => 'Utgår',
        'Delete this key' => 'Slett denne nøkkelen',
        'PGP key' => 'PGP-nøkkel',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakkehåndterer',
        'Uninstall Package' => 'Avinstaller pakken',
        'Uninstall package' => 'Avinstaller pakke',
        'Do you really want to uninstall this package?' => 'Vil du virkelig avinstallere denne pakken?',
        'Reinstall package' => 're-installer pakken',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Vil du virkelig re-installere pakken? Alle manuelle endringer vil bli borte.',
        'Go to updating instructions' => 'Gå til oppdateringsinstruksjoner',
        'Go to the OTOBO customer portal' => 'Gå til OTOBO-kundeportalen',
        'package information' => 'pakkeinformasjon',
        'Package installation requires a patch level update of OTOBO.' =>
            'Pakkeinstallasjon krever en patch-nivåoppdatering av OTOBO.',
        'Package update requires a patch level update of OTOBO.' => 'Pakkeoppdatering krever en patch-nivåoppdatering av OTOBO.',
        'Please note that your installed OTOBO version is %s.' => 'Vær oppmerksom på at din installerte OTOBO-versjon er %s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'For å installere denne pakken må du oppdatere OTOBO til versjon %s eller nyere.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Denne pakken kan bare installeres på OTOBO versjon %s eller eldre.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Denne pakken kan bare installeres på OTOBO versjon %s eller nyere.',
        'Why should I keep OTOBO up to date?' => 'Hvorfor bør jeg holde OTOBO oppdatert?',
        'You will receive updates about relevant security issues.' => 'Du vil motta oppdateringer om relevante sikkerhetsproblemer.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Du vil motta oppdateringer for alle andre relevante OTOBO-problemer.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Hvordan kan jeg gjøre en oppdatering hvis jeg ikke har en kontrakt?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Finn all relevant informasjon i oppdateringsinstruksjonene på %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Hvis du har flere spørsmål, svarer vi gjerne på dem.',
        'Please visit our customer portal and file a request.' => 'Vennligst besøk vår kundeportal og send inn en forespørsel.',
        'Install Package' => 'Installer pakke',
        'Update Package' => 'Oppdater pakke',
        'Continue' => 'Fortsett',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Sørg for at databasen din aksepterer pakker over %s MB i størrelse (den godtar for øyeblikket bare pakker opptil %s MB). Vennligst tilpass max_allowed_packet-innstillingen for databasen for å unngå feil.',
        'Install' => 'Installer',
        'Update repository information' => 'Oppdater pakkelager-informasjon',
        'Cloud services are currently disabled.' => 'Skytjenester er for øyeblikket deaktivert.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify kan ikke fortsette!',
        'Enable cloud services' => 'Aktiver skytjenester',
        'Update all installed packages' => 'Oppdater alle installerte pakker',
        'Online Repository' => 'Pakkelager på nettet',
        'Vendor' => 'Forhandler',
        'Action' => 'Handling',
        'Module documentation' => 'Modul-dokumentasjon',
        'Local Repository' => 'Lokalt pakkelager',
        'This package is verified by OTOBOverify (tm)' => 'Denne pakken er verifisert av OTOBOverify (tm)',
        'Uninstall' => 'Avinstaller',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakken er ikke riktig installert! Vennligst installer pakken på nytt.',
        'Reinstall' => 're-installer',
        'Features for %s customers only' => 'Funksjoner tilgjengelig kun for %s kunder',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Med %s kan du dra nytte av følgende valgfrie funksjoner. Ta kontakt med %s hvis du trenger mer informasjon.',
        'Package Information' => 'Pakkeinformasjon',
        'Download package' => 'Last ned pakke',
        'Rebuild package' => 'Gjenoppbygg pakke',
        'Metadata' => 'Metadata',
        'Change Log' => 'Endrings-logg',
        'Date' => 'Dato',
        'List of Files' => 'Fil-liste',
        'Permission' => 'to',
        'Download file from package!' => 'Last ned fil fra pakke!',
        'Required' => 'Påkrevd',
        'Primary Key' => 'Primærnøkkel',
        'Auto Increment' => 'Automatisk økning',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Filforskjeller for fil %s',
        'File differences for file %s' => 'Forskjeller for filen %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ytelseslogg',
        'Range' => 'Rekkevidde',
        'last' => 'siste',
        'This feature is enabled!' => 'Denne funksjonen er aktivert!',
        'Just use this feature if you want to log each request.' => 'Bruk denne funksjonen kun dersom du vil logge hver forespørsel.',
        'Activating this feature might affect your system performance!' =>
            'Aktivering av denne funksjonen kan påvirke system-ytelsen!',
        'Disable it here!' => 'Deaktiver denne her!',
        'Logfile too large!' => 'Loggfilen er for stor!',
        'The logfile is too large, you need to reset it' => 'Loggfilen er for stor, du må nullstille den',
        'Interface' => 'Grensesnitt',
        'Requests' => 'Forespørsler',
        'Min Response' => 'Min Respons',
        'Max Response' => 'Max Respons',
        'Average Response' => 'Gjennomsnittlig Respons',
        'Period' => 'Periode',
        'minutes' => 'minutter',
        'Min' => 'Minimum',
        'Max' => 'Maks',
        'Average' => 'Gjennomsnitt',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administrasjon: E-postfilter',
        'Add PostMaster Filter' => 'Legg til Postmaster-filter',
        'Edit PostMaster Filter' => 'Endre Postmaster-filter',
        'Filter for PostMaster Filters' => 'Filter for PostMaster-filtre',
        'Filter for PostMaster filters' => 'Filter for PostMaster-filtre',
        'Search through PostMaster filters' => '',
        'Search all filter attributes' => '',
        'Limit search to selected header fields' => '',
        'Limit search to selected set fields' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'For å behandle eller filtrere innkommende e-poster basert på e-posthoder. Regulære uttrykk kan også brukes.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Dersom du ønsker å kun treffe e-postadresser, benytt EMAILADDRESS:info@example.com i Fra, Til eller Kopi.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Hvis du bruker "Regular Expressions" kan du også bruke verdien i () som [***] i "Sett"-verdier.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Du kan også bruke navngitte opptak %s og bruke navnene i \'Sett\'-handlingen %s (f.eks. Regexp: %s, Angi handling: %s). En samsvarende EMAILADDRESS har navnet \'%s\'.',
        'Delete this filter' => 'Slett dette filteret',
        'Do you really want to delete this postmaster filter?' => 'Vil du virkelig slette dette postmesterfilteret?',
        'A postmaster filter with this name already exists!' => 'Et postmesterfilter med dette navnet finnes allerede!',
        'Filter Condition' => 'Filter-tilstand',
        'AND Condition' => 'OG Tilstand',
        'Search header field' => 'Søkehodefelt',
        'for value' => 'for verdi',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Feltet må være et gyldig regulært uttrykk eller et bokstavelig ord.',
        'Negate' => 'Inverter',
        'Set Email Headers' => 'Sett meldingshoder',
        'Set email header' => 'Sett meldingshode',
        'with value' => 'med verdi',
        'The field needs to be a literal word.' => 'Feltet må inneholde et ord bestående av bokstaver.',
        'Header' => 'Overskrift',

        # Template: AdminPriority
        'Priority Management' => 'Administrasjon: Prioriteter',
        'Add Priority' => 'Ny Prioritering',
        'Edit Priority' => 'Endre Prioritering',
        'Include invalid priorities' => '',
        'Filter for Priorities' => 'Filtrer etter prioriteringer',
        'Filter for priorities' => 'Filtrer for prioriteringer',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Denne prioriteten er tilstede i en SysConfig-innstilling, bekreftelse for oppdatering av innstillinger for å peke til den nye prioriteten er nødvendig!',
        'This priority is used in the following config settings:' => 'Denne prioriteten brukes i følgende konfigurasjonsinnstillinger:',

        # Template: AdminProcessManagement
        'Process Management' => 'Prosessoppsett',
        'Include inactive processes' => '',
        'Filter for Processes' => 'Filter for prosesser',
        'Filter for processes' => 'Filter for prosesser',
        'Create New Process' => 'Opprett ny prosess',
        'Deploy All Processes' => 'Distribuer alle prosesser',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Her kan du laste opp en konfigurasjonsfil for å importere en prosess til systemet ditt. Filen må være i .yml-format som eksportert av prosessadministrasjonsmodulen.',
        'Upload process configuration' => 'Last opp prosess konfigurasjon',
        'Import process configuration' => 'Importer prosess konfigurasjon',
        'Ready2Adopt Processes' => 'Ready2Adopt-prosesser',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Her kan du aktivere Ready2Adopt-prosesser som viser frem vår beste praksis. Vær oppmerksom på at noe ekstra konfigurasjon kan være nødvendig.',
        'Import Ready2Adopt process' => 'Importer Ready2Adopt-prosess',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'For å opprette en ny prosess kan du enten importere en prosess som ble eksportert fra et annet system eller opprette en helt ny.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Endringer i prosessene her påvirker bare oppførselen til systemet hvis du synkroniserer prosessdataene. Ved å synkronisere prosessene vil de nyinnførte endringene bli skrevet til konfigurasjonen.',
        'Processes' => 'Prosesser',
        'Process name' => 'Prosessnavn',
        'Print' => 'Utskrift',
        'Export Process Configuration' => 'Eksporter prosesskonfigurasjon',
        'Copy Process' => 'Kopier prosess',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Avbryt og lukk',
        'Go Back' => 'Gå tilbake',
        'Please note, that changing this activity will affect the following processes' =>
            'Vær oppmerksom på at endring av denne aktiviteten vil påvirke følgende prosesser',
        'Activity' => 'cannot',
        'Activity Name' => 'Aktivitetsnavn',
        'Activity Dialogs' => 'Aktivitetsdialoger',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Du kan tildele aktivitetsdialoger til denne aktiviteten ved å dra elementet med musepekeren fra venstre liste til høyre liste.',
        'Filter available Activity Dialogs' => 'Filtrer tilgjengelige aktivitetsdialoger',
        'Available Activity Dialogs' => 'Tilgjengelige aktivitetsdialoger',
        'Name: %s, EntityID: %s' => 'Navn: %s, enhets-ID: %s',
        'Create New Activity Dialog' => 'Opprett ny aktivitetsdialog',
        'Assigned Activity Dialogs' => 'Tildel aktivitetsdialoger',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Vær oppmerksom på at endring av denne aktivitetsdialogen vil påvirke følgende aktiviteter',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Vær oppmerksom på at kundebrukere ikke vil kunne se eller bruke følgende felt: Eier, Ansvarlig, Lås, Ventende Tid og KundeID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Kø feltet kan bare benyttes av kunder når en ny sak opprettes.',
        'Activity Dialog' => 'Aktivitetsdialog',
        'Activity dialog Name' => 'Aktivitetsdialognavn',
        'Available in' => 'Tilgjengelig i',
        'Description (short)' => 'Beskrivelse (kort)',
        'Description (long)' => 'Beskrivelse (lang)',
        'The selected permission does not exist.' => 'Den valgte tilatelsen eksisterer ikke.',
        'Required Lock' => 'Påkrevd lås',
        'The selected required lock does not exist.' => 'Den valgte påkrevde låsen eksisterer ikke.',
        'Submit Advice Text' => 'Send inn råd-tekst',
        'Submit Button Text' => 'Tekst for Send inn-knapp',
        'Input Field Definition' => '',
        'Direct submit' => '',
        'This property won\'t take effect because there are fields configured as visible.' =>
            '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Du kan tilordne felt til denne aktivitetsdialogen ved å dra elementene med musen fra venstre liste til høyre liste.',
        'Filter available fields' => 'Tiltrer på tilgjengelige felter',
        'Available Fields' => 'Tilgjengelige felter',
        'Assigned Fields' => 'Tilordnede felter',
        'Communication Channel' => 'Kommunikasjonskanal',
        'Is visible for customer' => 'Er synlig for kunden',
        'Display' => 'Vis',

        # Template: AdminProcessManagementPath
        'Path' => 'Addrese',
        'Edit this transition' => 'Endre denne overgangen',
        'Transition Actions' => 'Overgangshandling',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Du kan tildele overgangshandlinger til denne overgangen ved å dra elementet med musepekeren fra venstre liste til høyre liste.',
        'Filter available Transition Actions' => 'Filtrer på tilgjengelige overgangshandlinger',
        'Available Transition Actions' => 'Tilgjengelige overgangshandlinger',
        'Create New Transition Action' => 'Opprett ny overgangshandling',
        'Assigned Transition Actions' => 'Tildel overgangshandling',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktiviteter',
        'Filter Activities...' => 'Filtrer aktiviteter...',
        'Create New Activity' => 'Opprett ny aktivitet',
        'Filter Activity Dialogs...' => 'Filtrer aktivitetsdialoger...',
        'Transitions' => 'Overganger',
        'Filter Transitions...' => 'Filtrer overganger...',
        'Create New Transition' => 'Opprett ny overgang',
        'Filter Transition Actions...' => 'Filtrer overgangshandlinger...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Endre prosess',
        'Print process information' => 'Skriv ut prosessinformasjon',
        'Delete Process' => 'Slett prosess',
        'Delete Inactive Process' => 'Slett inaktive prosesser',
        'Available Process Elements' => 'Tilgjengelige prosesselementer',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementene som er oppført ovenfor i denne sidelinjen kan flyttes til lerretsområdet til høyre ved å bruke dra og slipp.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Du kan plassere aktiviteter på lerretsområdet for å tilordne denne aktiviteten til prosessen.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'For å tilordne en aktivitetsdialog til en aktivitet slipper du aktivitetsdialogelementet fra denne sidelinjen over aktiviteten som er plassert i lerretsområdet.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Du kan starte en forbindelse mellom to aktiviteter ved å slippe overgangselementet over startaktiviteten til forbindelsen. Etter det kan du flytte den løse enden av pilen til Avslutt-aktiviteten.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Handlinger kan tilordnes en overgang ved å slippe handlingselementet på etiketten til en overgang.',
        'Edit Process Information' => 'Endre prosessinformasjon',
        'Process Name' => 'Prosessnavn',
        'The selected state does not exist.' => 'Den valgte tilstand eksisterer ikke.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Legg til og rediger aktiviteter, aktivitetsdialoger og overganger',
        'Show EntityIDs' => 'Vis enhets-IDer',
        'Extend the width of the Canvas' => 'Utvid bredden på lerretet',
        'Extend the height of the Canvas' => 'Forleng høyden på lerretet',
        'Remove the Activity from this Process' => 'Fjern aktiviteten fra denne prosessen',
        'Edit this Activity' => 'Endre denne aktiviteten',
        'Save Activities, Activity Dialogs and Transitions' => 'Lagre aktivitetene, aktivitets-dialogene og overgangene',
        'Do you really want to delete this Process?' => 'Vil du virkelig fjerne denne prosessen?',
        'Do you really want to delete this Activity?' => 'Vil du virkelig fjerne denne aktiviteten?',
        'Do you really want to delete this Activity Dialog?' => 'Vil du virkelig fjerne denne aktivitets-dialogen?',
        'Do you really want to delete this Transition?' => 'Vil du virkelig fjerne denne overgangen?',
        'Do you really want to delete this Transition Action?' => 'Vil du virkelig fjerne denne overgangshandlingen?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vil du virkelig fjerne denne aktiviteten fra lerretet? Dette kan bare angres ved å forlate denne skjermen uten å lagre.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vil du virkelig fjerne denne overgangen fra lerretet? Dette kan bare angres ved å forlate denne skjermen uten å lagre.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'På denne skjermen kan du opprette en ny prosess. For å gjøre den nye prosessen tilgjengelig for brukere, må du sørge for å sette statusen til "Aktiv" og synkronisere etter at du har fullført arbeidet.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'avbryt og lukk',
        'Start Activity' => 'Start aktivitet',
        'Contains %s dialog(s)' => 'Inneholder %s dialog(er)',
        'Assigned dialogs' => 'Tilordnede dialoger',
        'Activities are not being used in this process.' => 'Aktiviteter er ikke i bruk i denne prosessen.',
        'Assigned fields' => 'Tilordnede felter',
        'Activity dialogs are not being used in this process.' => 'Aktivitetsdialoger er ikke i bruk i denne prosessen.',
        'Condition linking' => 'Tilstandskobling',
        'Transitions are not being used in this process.' => 'Overganger er ikke i bruk i denne prosessen.',
        'Module name' => 'Modulnavn',
        'Transition actions are not being used in this process.' => 'Overgangshandlinger brukes ikke i denne prosessen.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Vær oppmerksom på at endring av denne overgangen vil påvirke følgende prosesser',
        'Transition' => 'Overgang',
        'Transition Name' => 'Overgangsnavn',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Vær oppmerksom på at endring av denne overgangshandlingen vil påvirke følgende prosesser',
        'Transition Action' => 'Overgangshandling',
        'Transition Action Name' => 'Overgangshandling-navn',
        'Transition Action Module' => 'Overgangshandling-modul',
        'Config Parameters' => 'Konfigurer parametere',
        'Add a new Parameter' => 'Legg til et nytt parameter',
        'Remove this Parameter' => 'Fjern dette parameteret',

        # Template: AdminQueue
        'Queue Management' => 'Køhåndtering',
        'Add Queue' => 'Legg til kø',
        'Edit Queue' => 'Endre kø',
        'Include invalid queues' => '',
        'Filter for Queues' => 'Filter for køer',
        'Filter for queues' => 'Filtrer for køer',
        'A queue with this name already exists!' => 'En kø med dette navnet eksisterer allerede!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Denne køen er tilstede i en SysConfig-innstilling, bekreftelse for oppdatering av innstillinger for å peke til den nye køen er nødvendig!',
        'Sub-queue of' => 'Under-kø av',
        'Unlock timeout' => 'Tidsintervall for å sette sak tilgjengelig for andre',
        '0 = no unlock' => '0 = ikke gjør saker tilgjengelig',
        'hours' => 'timer',
        'Only business hours are counted.' => 'Kun timene i åpningstiden telles.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Hvis en agent låser en sak og ikke stenger den før låsetiden har passert vil saken bli låst opp og komme tilgjengelig for andre saksbehandlere.',
        'Notify by' => 'Varsle ved',
        '0 = no escalation' => '0 = ingen eskalering',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis det ikke legges til en kundekontakt, enten e-post eller telefon, til en sak innen tiden definert her vil den bli eskalert.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis det kommer inn et objekt, f.eks. en oppfølging på e-post eller fra kundeportalen, vil eskaleringstiden bli nullstilt. Hvis ingen kundekontakt blir lagt til, enten som utgående e-post eller utgående telefon, innen tiden som er spesifisert her, vil saken bli eskalert.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Hvis saken ikke blir stengt innen tiden spesifisert her utløper vil den bli eskalert.',
        'Follow up Option' => 'Korrespondanse på avsluttet sak',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Forteller om oppfølginger på stengte saker skal gjenåpne saken, avvises eller føre til en ny sak.',
        'Ticket lock after a follow up' => 'Saken settes som privat etter oppfølgnings e-post',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Hvis en sak blir stengt og kunden sender en oppfølging vil saken bli låst til den forrige eieren.',
        'System address' => 'Systemadresse',
        'Will be the sender address of this queue for email answers.' => 'Avsenderadresse for e-post i denne køen.',
        'Default sign key' => 'Standard signeringsnøkkel',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'For å bruke en signeringsnøkkel, må PGP-nøkler eller S/MIME-sertifikater legges til med identifikatorer for valgt køsystemadresse.',
        'Salutation' => 'Hilsning',
        'The salutation for email answers.' => 'Hilsning for e-postsvar.',
        'Signature' => 'Signatur',
        'The signature for email answers.' => 'Signatur for e-postsvar.',
        'This queue is used in the following config settings:' => 'Denne køen brukes i følgende konfigurasjonsinnstillinger:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrasjon av Autosvar for Køer',
        'Change Auto Response Relations for Queue' => 'Endre Autosvar-kopling for Kø',
        'This filter allow you to show queues without auto responses' => 'Dette filteret lar deg vise køer uten autosvar',
        'Queues without Auto Responses' => 'Køer uten autosvar',
        'This filter allow you to show all queues' => 'Dette filteret lar deg vise alle køer',
        'Show All Queues' => 'Vis alle køer',
        'Auto Responses' => 'Autosvar',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Koplinger mellom Mal og Kø',
        'Filter for Templates' => 'Filter for Maler',
        'Filter for templates' => 'Filter for maler',
        'Templates' => 'Maler',

        # Template: AdminRegistration
        'System Registration Management' => 'Systemregistreringsadministrasjon',
        'Edit System Registration' => 'Endre systemregistrering',
        'System Registration Overview' => 'Systemregistreringsoversikt',
        'Register System' => 'Registrer System',
        'Validate OTOBO-ID' => 'Valider OTOBO-ID',
        'Deregister System' => 'Avregistrere system',
        'Edit details' => 'Endre detaljer',
        'Show transmitted data' => 'Vis overført data',
        'Deregister system' => 'Avregistrere system',
        'Overview of registered systems' => 'Oversikt over registrerte systemet',
        'This system is registered with OTOBO Team.' => 'Dette systemet er registrert hos OTOBO Team.',
        'System type' => 'Systemtype',
        'Unique ID' => 'Unik ID',
        'Last communication with registration server' => 'Sist kommunikasjon med registreringstjeneren',
        'System Registration not Possible' => 'Systemregistrering er ikke mulig',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Vennligst legg merket til at du ikke kan registrere systemet, dersom OTOBO tjenesten ikke kjører riktig!',
        'Instructions' => 'Instruksjoner',
        'System Deregistration not Possible' => 'Systemavregistrering ikke mulig',
        'OTOBO-ID Login' => 'OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'Systemregistrering er en tjeneste fra OTOBO Team, som gir mange fordeler!',
        'Read more' => 'Les mer',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Du må logge inn med din OTOBO-ID for å registrere systemet ditt.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Din OTOBO-ID er e-postadressen du brukte til å registrere deg på OTOBO.com-nettsiden.',
        'Data Protection' => 'Databeskyttelse',
        'What are the advantages of system registration?' => 'Hva er fordelene med registrering av systemet?',
        'You will receive updates about relevant security releases.' => 'Du vil motta oppdateringer om relevante sikkerhetsoppdateringer.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Med din systemregistrering kan vi forbedre tjenestene våre for deg, fordi vi har all relevant informasjon tilgjengelig.',
        'This is only the beginning!' => 'Dette er bare begynnelsen!',
        'We will inform you about our new services and offerings soon.' =>
            'Vi vil informere deg om våre nye tjenester og tilbud snart.',
        'Can I use OTOBO without being registered?' => 'Kan jeg bruke OTOBO uten å være registrert?',
        'System registration is optional.' => 'Registrering er valgfritt.',
        'You can download and use OTOBO without being registered.' => 'Du kan laste ned og bruke OTOBO uten å være registrert.',
        'Is it possible to deregister?' => 'Er det mulig å avregistrere seg?',
        'You can deregister at any time.' => 'Du kan avregistrere deg når som helst.',
        'Which data is transfered when registering?' => 'Hvilke data blir overført ved registrering?',
        'A registered system sends the following data to OTOBO Team:' => 'Et registrert system sender følgende data til OTOBO Team:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTOBO versjon, Database-, Operativsystem- og Perl versjon.',
        'Why do I have to provide a description for my system?' => 'Hvorfor må jeg gi en beskrivelse for mitt system?',
        'The description of the system is optional.' => 'Beskrivelsen er valgfri.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Beskrivelsen og systemtypen du angir hjelper deg med å identifisere og administrere detaljene til de registrerte systemene dine.',
        'How often does my OTOBO system send updates?' => 'Hvor ofte sender mitt OTOBO system oppdateringer?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ditt system vil sende oppdateringer til registreringstjeneren med jevne mellomrom.',
        'Typically this would be around once every three days.' => 'Typisk så vil dette være en gang vær tredje dag.',
        'If you deregister your system, you will lose these benefits:' =>
            'Hvis du avregistrerer systemet ditt, vil du miste disse fordelene:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Du må logge på med din OTOBO-ID for å avregistrere systemet ditt.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Har du ikke en OTOBO-ID enda?',
        'Sign up now' => 'Registrer deg her',
        'Forgot your password?' => 'Glemt ditt passord?',
        'Retrieve a new one' => 'Hent en ny en',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Disse dataene vil ofte bli overført til OTOBO Team når du registrerer dette systemet.',
        'Attribute' => 'Attributt',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO versjon',
        'Operating System' => 'Operativsystem',
        'Perl Version' => 'Perl versjon',
        'Optional description of this system.' => 'Valgfri beskrivelse av dette systemet.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Dette vil tillate systemet å sende ytterligere støttedatainformasjon til OTOBO Team.',
        'Register' => 'Registrer',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Hvis du fortsetter med dette trinnet, avregistreres systemet fra OTOBO Team.',
        'Deregister' => 'Avregistrere',
        'You can modify registration settings here.' => 'Du kan endre registreringsinnstillingene her.',
        'Overview of Transmitted Data' => 'Oversikt over overførte data',
        'There is no data regularly sent from your system to %s.' => 'Det finnes ikke noe jevnlig data som er sent fra ditt system til %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Følgende data sendes minimum hver 3. dag fra systemet til %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Dataene vil bli overført i JSON-format via en sikker https-tilkobling.',
        'System Registration Data' => 'Systemregistreringsdata',
        'Support Data' => 'Støttedata',

        # Template: AdminResponseTemplatesStatePreselection
        'Manage ticket state pre-selections for response templates' => '',
        'Edit Response' => '',
        'Pre-selected ticket state' => '',

        # Template: AdminRole
        'Role Management' => 'Administrasjon: Roller',
        'Add Role' => 'Ny Rolle',
        'Edit Role' => 'Endre Rolle',
        'Include invalid roles' => '',
        'Filter for Roles' => 'Filter for Roller',
        'Filter for roles' => 'Filtrer etter roller',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Opprett en rolle og legg grupper til rollen. Legg deretter til saksbehandlere til rollen.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Ingen roller er definerte. Vennligst bruk "Ny rolle" for å opprett en.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Koplinger mellom Rolle og Gruppe',
        'Roles' => 'Roller',
        'Select the role:group permissions.' => 'Velg rolle:grupperettigheter.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Hvis ingenting blir valgt vil det ikke være noen tilgang til gruppen (rollen vil ikke se saker for gruppen).',
        'Toggle %s permission for all' => 'Slå av/på tilgang for alle',
        'move_into' => 'Flytt til',
        'Permissions to move tickets into this group/queue.' => 'Rettighet til å flytte saker i denne gruppen/køen.',
        'create' => 'opprett',
        'Permissions to create tickets in this group/queue.' => 'Rettighet til å opprette saker i denne gruppen/køen.',
        'note' => 'notis',
        'Permissions to add notes to tickets in this group/queue.' => 'Rettigheter for å svare på saker i denne gruppen/køen.',
        'owner' => 'update',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Rettigheter til å endre eier av saker i denne gruppen/køen.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Rettighet til å endre prioritet i denne gruppen/køen.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Koplinger mellom Saksbehandlere og Roller',
        'Add Agent' => 'Legg til Saksbehandler',
        'Filter for Agents' => 'Filter for Saksbehandlere',
        'Filter for agents' => 'Filter for agenter',
        'Agents' => 'Saksbehandlere',
        'Manage Role-Agent Relations' => 'Koplinger mellom Rolle og Saksbehandler',

        # Template: AdminSLA
        'SLA Management' => 'Administrasjon: SLA',
        'Edit SLA' => 'Endre SLA',
        'Add SLA' => 'Ny SLA',
        'Include invalid SLAs' => '',
        'Filter for SLAs' => 'Filter for SLAer',
        'Please write only numbers!' => 'Vennligst skriv kun siffer!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Administrasjon: S/MIME',
        'Add Certificate' => 'Legg til sertifikat',
        'Add Private Key' => 'Legg til privat nøkkel',
        'SMIME support is disabled' => 'SMIME-støtte er deaktivert',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'For å kunne bruke SMIME i OTOBO, må du først aktivere det.',
        'Enable SMIME support' => 'Aktiver SMIME-støtte',
        'Faulty SMIME configuration' => 'Feil SMIME-konfigurasjon',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME-støtte er aktivert, men den relevante konfigurasjonen inneholder feil. Vennligst sjekk konfigurasjonen ved å bruke knappen nedenfor.',
        'Check SMIME configuration' => 'Sjekk SMIME-konfigurasjonen',
        'Filter for Certificates' => 'Filtrer etter sertifikater',
        'Filter for certificates' => 'Filter for sertifikater',
        'To show certificate details click on a certificate icon.' => 'For å vise detaljer rundt sertifikatet, trykk på et sertifikat ikon.',
        'To manage private certificate relations click on a private key icon.' =>
            'For å endre private sertifikat relasjoner, trykk på et privat nøkkel ikon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Her kan du legge til relasjoner til ditt private sertifikat, disse vil bli innebygd i S/MIME-signaturen hver gang du bruker dette sertifikatet til å signere en e-post.',
        'See also' => 'Se også',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'På denne måten kan du direkte redigere sertifikatet og private nøkler i filsystemet.',
        'Hash' => 'Hash',
        'Create' => 'Opprett',
        'Handle related certificates' => 'Behandle relaterte sertifikater',
        'Read certificate' => 'Les sertifikat',
        'Delete this certificate' => 'Slett dette sertifikatet',
        'File' => 'Fil',
        'Secret' => 'Hemmelighet',
        'Related Certificates for' => 'Relaterte sertifikater for',
        'Delete this relation' => 'Fjern denne relasjonen',
        'Available Certificates' => 'Tilgjengelige sertifikater',
        'Filter for S/MIME certs' => 'Filter for S/MIME certifikater',
        'Relate this certificate' => 'Relater dette sertifikatet',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME-sertifikat',
        'Certificate Details' => 'Sertifikatdetaljer',
        'Close this dialog' => 'Lukk denne dialogen',

        # Template: AdminSalutation
        'Salutation Management' => 'Administrasjon: Hilsninger',
        'Add Salutation' => 'Legg til hilsning',
        'Edit Salutation' => 'Endre hilsning',
        'Include invalid salutations' => '',
        'Filter for Salutations' => 'Filter for hilsener',
        'Filter for salutations' => 'Filter for hilsener',
        'e. g.' => 'f.eks.',
        'Example salutation' => 'Eksempel på hilsning',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'Sikker modus må aktiveres!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Sikkermodus vil (normalt) være satt etter førstegangs-installasjon er ferdig.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Hvis sikkermodus ikke er slått på, slå det på via Systemkonfigurasjon fordi applikasjonen er i drift.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL-boks',
        'Filter for Results' => 'Filtrer for resultater',
        'Filter for results' => 'Filtrer for resultater',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Her kan du skrive inn SQL for å sende den direkte til applikasjonsdatabasen. Det er ikke mulig å endre innholdet i tabellene, kun utvalgte spørringer er tillatt.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Her kan du skrive SQL for å sende kommandoer rett til OTOBO sin database.',
        'Options' => 'Reference;Referanse',
        'Only select queries are allowed.' => 'Kun select spørringer er mulig.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL-spørringen har en syntaks-feil. Vennligst sjekk den.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Det mangler minst ett parameter i bindingen. Vennligst sjekk den.',
        'Result format' => 'Format for resultatet',
        'Run Query' => 'Kjør spørring',
        '%s Results' => '%s resultater',
        'Query is executed.' => 'Spørringen er utført.',

        # Template: AdminService
        'Service Management' => 'Administrasjon: Tjenester',
        'Add Service' => 'Legg til Tjeneste',
        'Edit Service' => 'Endre Tjeneste',
        'Include invalid services' => '',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Tjenestenavnets maksimale lengde er 200 tegn (med undertjeneste).',
        'Sub-service of' => 'Under-tjeneste av',

        # Template: AdminSession
        'Session Management' => 'Administrasjon: Sesjoner',
        'Detail Session View for %s (%s)' => 'Detaljøktvisning for %s (%s)',
        'All sessions' => 'Alle sesjoner',
        'Agent sessions' => 'Saksbehandler-sesjoner',
        'Customer sessions' => 'Kunde-sesjoner',
        'Unique agents' => 'Unike saksbehandlere',
        'Unique customers' => 'Unike kunder',
        'Kill all sessions' => 'Terminer alle sesjoner',
        'Kill this session' => 'Terminer denne sesjonen',
        'Filter for Sessions' => 'Filtrer for økter',
        'Filter for sessions' => 'Filtrer for økter',
        'Session' => 'Sesjon',
        'Kill' => 'Terminer',
        'Detail View for SessionID: %s - %s' => 'Detaljvisning for økt-ID: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Administrasjon: Signaturer',
        'Add Signature' => 'Legg til signatur',
        'Edit Signature' => 'Endre Signatur',
        'Include invalid signatures' => '',
        'Filter for Signatures' => 'Filter for signaturer',
        'Filter for signatures' => 'Filtrer for signaturer',
        'Example signature' => 'Eksempel på signatur',

        # Template: AdminState
        'State Management' => 'Administrasjon: Statuser',
        'Add State' => 'Legg til status',
        'Edit State' => 'Endre status',
        'Include invalid states' => '',
        'Filter for States' => 'Filtrer etter tilstander',
        'Filter for states' => 'Filtrer etter tilstander',
        'Attention' => 'OBS',
        'Please also update the states in SysConfig where needed.' => 'Vennligst også oppdatert nødvendige statuser i SysConfig.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Denne tilstanden er tilstede i en SysConfig-innstilling, bekreftelse for oppdatering av innstillinger for å peke til den nye typen er nødvendig!',
        'State type' => 'Statustype',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Det er ikke mulig å ugyldiggjøre denne oppføringen fordi det ikke er andre flettetilstander i systemet!',
        'This state is used in the following config settings:' => 'Denne tilstanden brukes i følgende konfigurasjonsinnstillinger:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'Det er ikke mulig å sende støttedata til OTOBO Team!',
        'Enable Cloud Services' => 'Aktiver skytjenester',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Disse dataene sendes til OTOBO Team med jevne mellomrom. For å slutte å sende disse dataene må du oppdatere systemregistreringen din.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Du kan manuelt utløse sending av støttedata ved å trykke på denne knappen:',
        'Send Update' => 'Send oppdatering',
        'Currently this data is only shown in this system.' => 'Foreløpig vises disse dataene kun i dette systemet.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Det anbefales sterkt å sende disse dataene til OTOBO Team for å få bedre støtte.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'For å aktivere datasending, vennligst registrer systemet ditt hos OTOBO Team eller oppdater systemregistreringsinformasjonen din (sørg for å aktivere alternativet \'send støttedata\'.)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'En støttepakke (inkludert: systemregistreringsinformasjon, støttedata, en liste over installerte pakker og alle lokalt modifiserte kildekodefiler) kan genereres ved å trykke på denne knappen:',
        'Generate Support Bundle' => 'Generer støttepakke',
        'The Support Bundle has been Generated' => 'Støttepakken er generert',
        'Please choose one of the following options.' => 'Velg ett av følgende alternativer.',
        'Send by Email' => 'Send på e-post',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Støttepakken er for stor til å sende via e-post, dette alternativet er deaktivert.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'E-postadressen til denne brukeren er ugyldig, dette alternativet er deaktivert.',
        'Sending' => 'Queue;Sendingskø',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'Støttepakken sendes automatisk til OTOBO Team via e-post.',
        'Download File' => 'Last ned fil',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'En fil som inneholder støttepakken vil bli lastet ned til det lokale systemet. Vennligst lagre filen og send den til OTOBO-teamet ved å bruke en alternativ metode.',
        'Error: Support data could not be collected (%s).' => 'Feil: Støttedata kunne ikke samles inn (%s).',
        'Details' => 'for',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administrasjon: Systemets E-postadresser',
        'Add System Email Address' => 'Legg til Systemadresse',
        'Edit System Email Address' => 'Endre Systemadresse',
        'Include invalid system addresses' => '',
        'Add System Address' => 'Legg til systemadresse',
        'Filter for System Addresses' => 'Filter for systemadresser',
        'Filter for system addresses' => 'Filter for systemadresser',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'All innkommende e-post til denne adressen i To eller CC vil bli lagt i den valgte køen.',
        'Email address' => 'E-postadresse',
        'Display name' => 'Vist navn',
        'This email address is already used as system email address.' => 'Denne e-postadressen er allerede brukt som system-e-postadresse.',
        'The display name and email address will be shown on mail you send.' =>
            'Vist navn og e-postadresse vil vises på e-posten du sender ut.',
        'This system address cannot be set to invalid.' => 'Denne systemadressen kan ikke settes til ugyldig.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Denne systemadressen kan ikke settes til ugyldig, fordi den brukes i én eller flere kø(er) eller autosvar(er).',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'online administratordokumentasjon',
        'System configuration' => 'Systemkonfigurasjon',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Naviger gjennom de tilgjengelige innstillingene ved å bruke treet i navigasjonsboksen på venstre side.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Finn bestemte innstillinger ved å bruke søkefeltet nedenfor eller fra søkeikonet fra toppnavigasjonen.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Finn ut hvordan du bruker systemkonfigurasjonen ved å lese %s.',
        'Search in all settings...' => 'Søk i alle innstillinger...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Det er for øyeblikket ingen tilgjengelige innstillinger. Sørg for å kjøre \'otobo.Console.pl Maint::Config::Rebuild\' før du bruker programvaren.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Endrer distribusjon',
        'Help' => 'Hjelp',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Dette er en oversikt over alle innstillinger som vil være en del av distribusjonen hvis du starter den nå. Du kan sammenligne hver innstilling med dens tidligere tilstand ved å klikke på ikonet øverst til høyre.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'For å ekskludere visse innstillinger fra en distribusjon, klikk på avmerkingsboksen på overskriftslinjen til en innstilling.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Som standard vil du bare distribuere innstillinger som du endret på egen hånd. Hvis du ønsker å distribuere innstillinger endret av andre brukere også, vennligst klikk på koblingen øverst på skjermen for å gå inn i avansert distribusjonsmodus.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'En distribusjon har nettopp blitt gjenopprettet, noe som betyr at alle berørte innstillinger har blitt tilbakestilt til tilstanden fra den valgte distribusjonen.',
        'Please review the changed settings and deploy afterwards.' => 'Se gjennom de endrede innstillingene og distribuer etterpå.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'En tom liste over endringer betyr at det ikke er noen forskjeller mellom den gjenopprettede og gjeldende tilstanden til de berørte innstillingene.',
        'Changes Overview' => 'Oversikt over endringer',
        'There are %s changed settings which will be deployed in this run.' =>
            'Det er %s endrede innstillinger som vil bli distribuert i denne kjøringen.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Bytt til grunnleggende modus for å distribuere innstillinger bare endret av deg.',
        'You have %s changed settings which will be deployed in this run.' =>
            'Du har %s endret innstillinger som vil bli distribuert i denne kjøringen.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Bytt til avansert modus for å distribuere innstillinger endret av andre brukere også.',
        'There are no settings to be deployed.' => 'Det er ingen innstillinger som skal distribueres.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Bytt til avansert modus for å se distribuerbare innstillinger endret av andre brukere.',
        'Deploy selected changes' => 'Implementer valgte endringer',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => 'Implementeringshistorikk',
        'Filter for Deployments' => 'Filter for distribusjoner',
        'Recent Deployments' => 'Nylige distribusjoner',
        'Restore' => 'Gjenopprett',
        'View Details' => 'Vis detaljer',
        'Restore this deployment.' => 'Gjenopprett denne distribusjonen.',
        'Export this deployment.' => 'Eksporter denne distribusjonen.',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => 'Distribusjonsdetaljer',
        'by' => 'av',
        'No settings have been deployed in this run.' => 'Ingen innstillinger har blitt distribuert i denne kjøringen.',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Denne gruppen inneholder ingen innstillinger. Prøv å navigere til en av undergruppene.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Import & eksport',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Last opp en fil som skal importeres til systemet ditt (.yml-format som eksportert fra systemkonfigurasjonsmodulen).',
        'Upload system configuration' => 'Last opp systemkonfigurasjon',
        'Import system configuration' => 'Importer systemkonfigurasjon',
        'Download current configuration settings of your system in a .yml file.' =>
            'Last ned gjeldende konfigurasjonsinnstillinger for systemet i en .yml-fil.',
        'Include user settings' => 'Inkluder brukerinnstillinger',
        'Export current configuration' => 'Eksporter gjeldende konfigurasjon',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Søk etter',
        'Search for category' => 'Søk etter kategori',
        'Settings I\'m currently editing' => 'Innstillinger jeg er i ferd med å redigere',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Ditt søk etter "%s" i kategorien "%s" ga ingen resultater.',
        'Your search for "%s" in category "%s" returned one result.' => 'Ditt søk etter "%s" i kategorien "%s" ga ett resultat.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Ditt søk etter "%s" i kategorien "%s" ga %s resultater.',
        'You\'re currently not editing any settings.' => 'Du redigerer for øyeblikket ingen innstillinger.',
        'You\'re currently editing %s setting(s).' => 'Du redigerer for øyeblikket %s innstilling(er).',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategori',
        'Run search' => 'Start søk',

        # Template: AdminSystemConfigurationSettingHistoryDetails
        'Change History' => 'Endre historikk',
        'Change History of %s' => 'Endringslogg for %s',
        'No modified values for this setting, the default value is used.' =>
            'Ingen endrede verdier for denne innstillingen, standardverdien brukes.',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => 'Gjennomgå brukerinnstillingsverdien',
        'Users Value' => 'Brukerverdi',
        'For' => 'Til',
        'Delete all user values.' => 'Slett alle brukerverdier.',
        'No user value for this setting.' => 'Ingen brukerverdi for denne innstillingen.',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => 'Vis en egendefinert liste over innstillinger',
        'View single Setting: %s' => 'Vis enkelt Innstilling: %s',
        'Go back to Deployment Details' => 'Gå tilbake til distribusjonsdetaljer',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systemvedlikeholdsstyring',
        'Include invalid system maintenances' => '',
        'Schedule New System Maintenance' => 'Planlegg nytt systemvedlikehold',
        'Filter for System Maintenances' => 'Filter for systemvedlikehold',
        'Filter for system maintenances' => 'Filter for systemvedlikehold',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Planlegg en systemvedlikeholdsperiode for å kunngjøre agentene og kundene at systemet er nede i en tidsperiode.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'En tid før dette systemvedlikeholdet starter vil brukerne motta et varsel på hver skjerm som kunngjør om dette.',
        'Delete System Maintenance' => 'Slett systemvedlikehold',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Rediger systemvedlikehold',
        'Edit System Maintenance Information' => 'Rediger systemvedlikeholdsinformasjon',
        'Login message' => 'Innloggingsmelding',
        'This field must have less then 250 characters.' => 'Dette feltet må ha mindre enn 250 tegn.',
        'Show login message' => 'Vis innloggingsmelding',
        'Notify message' => 'Varselmelding',
        'Manage Sessions' => 'Sesjons-administrasjon',
        'All Sessions' => 'Alle sesjoner',
        'Agent Sessions' => 'Saksbehandler-sesjoner',
        'Customer Sessions' => 'Kunde-sesjoner',
        'Kill all Sessions, except for your own' => 'Avslutt alle økter, bortsett fra dine egne',

        # Template: AdminTemplate
        'Template Management' => 'Malbehandling',
        'Add Template' => 'Legg til Mal',
        'Edit Template' => 'Endre Mal',
        'Include invalid templates' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'En mal er en standardtekst som hjelper agentene dine til å skrive raskere saker, svar eller videresendinger.',
        'Don\'t forget to add new templates to queues.' => 'Ikke glem å legge til nye maler i køene.',
        'Attachments' => 'Vedlegg',
        'Delete this entry' => 'Slett denne posten',
        'Do you really want to delete this template?' => 'Virkelig slette denne malen?',
        'A standard template with this name already exists!' => 'En standard mal med dette navnet finnes allerede!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'For å få de første 20 tegnene i emnet for gjeldende/nyeste agentartikkel (gjeldende for Svar og Videresend, siste for Notat-maltype). Denne taggen støttes ikke for andre maltyper.',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'For å få de første 5 linjene i brødteksten til gjeldende/nyeste agentartikkel (gjeldende for svar og videresend, siste for notatmaltype). Denne taggen støttes ikke for andre maltyper.',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'For å få de første 20 tegnene i emnet for gjeldende/nyeste artikkel (gjeldende for Svar og Videresend, siste for Notat-maltype). Denne taggen støttes ikke for andre maltyper.',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'For å få de første 5 linjene i brødteksten til gjeldende/nyeste artikkel (gjeldende for svar og videresend, siste for notatmaltype). Denne taggen støttes ikke for andre maltyper.',
        'Create type templates only supports this smart tags' => 'Opprett type maler støtter bare denne smarttaggene',
        'Example template' => 'Eksempel på mal',
        'The current ticket state is' => 'Nåværende status på sak',
        'Your email address is' => 'Din e-postadresse er',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Administrer relasjoner mellom mal og vedlegg',
        'Toggle active for all' => 'Aktiver/Deaktiver alle',
        'Link %s to selected %s' => 'Koble %s til valgt %s',

        # Template: AdminTicketMask
        'Ticket Mask Management' => '',
        'Change mask definition' => '',
        'Ticket Mask' => '',
        'Change' => '',
        'Definition' => '',

        # Template: AdminTranslations
        'Translation Management' => '',
        'Add Translations' => '',
        'Edit Translations' => '',
        'Language' => 'Språk',
        'Deploy Translations' => '',
        'Translation States' => '',
        'New Translation' => '',
        'Editing Translation' => '',
        'Translation Marked for Deletion' => '',
        'Deployed Translation' => '',
        'Changes made here only affect the system behaviour after your draft translations have been deployed. By deploying them, all changes will be written to the language files.' =>
            '',
        'Select an object to start adding translations. Depending on your selection, single or multiple translations can be added.' =>
            '',
        'Edit active translations using provided text fields!' => '',
        'List custom translations for' => '',
        'Draft Translations' => '',
        'Filter for Draft Translations' => '',
        'Active Translations' => '',
        'Filter for Active Translations' => '',
        'Content' => 'Innhold',
        'Translation' => '',
        'Marked for Deletion' => '',
        'Edit Translation' => '',
        'Overwrites OTOBO translation' => '',
        'Undo Delete Translation' => '',
        'Delete Translation' => '',
        'Translations' => '',

        # Template: AdminType
        'Type Management' => 'Administrasjon: Typer',
        'Add Type' => 'Legg til sakstype',
        'Edit Type' => 'Endre sakstype',
        'Include invalid types' => '',
        'Filter for Types' => 'Filter for typer',
        'Filter for types' => 'Filter for typer',
        'A type with this name already exists!' => 'En type med dette navnet finnes allerede!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Denne typen er tilstede i en SysConfig-innstilling, bekreftelse for å oppdatere innstillingene for å peke til den nye typen er nødvendig!',
        'This type is used in the following config settings:' => 'Denne typen brukes i følgende konfigurasjonsinnstillinger:',

        # Template: AdminUser
        'Agent Management' => 'Saksbehandlere',
        'Edit Agent' => 'Endre Saksbehandler',
        'Include invalid users' => '',
        'Edit personal preferences for this agent' => 'Rediger personlige preferanser for denne agenten',
        'Agents will be needed to handle tickets.' => 'Saksbehandlere trengs for å behandle saker.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ikke glem å legge saksbehandlere i grupper og/eller roller!',
        'Please enter a search term to look for agents.' => 'Skriv et søk for å finne saksbehandlere.',
        'Last login' => 'Siste innlogging',
        'Switch to agent' => 'Bytt til saksbehandler',
        'Title or salutation' => 'Tittel eller hilsen',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Etternavn',
        'A user with this username already exists!' => 'En bruker med dette brukernavnet eksisterer allerede!',
        'Will be auto-generated if left empty.' => 'Blir automatisk generert hvis den står tom.',
        'Mobile' => 'Mobil',
        'Effective Permissions for Agent' => 'Effektive tillatelser for agent',
        'This agent has no group permissions.' => 'Denne agenten har ingen gruppetillatelser.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'Tabellen ovenfor viser effektive gruppetillatelser for agenten. Matrisen tar hensyn til alle nedarvede tillatelser (f.eks. via roller).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Koplinger mellom Saksbehandler og Gruppe',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Agendaoversikt',
        'Manage Calendars' => 'Kalenderadministrasjon',
        'Add Appointment' => 'Legg til avtale',
        'Today' => 'Idag',
        'All-day' => 'Hele dagen',
        'Repeat' => 'Gjenta',
        'Notification' => 'Varsling',
        'Yes' => 'Ja',
        'No' => 'Nei',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Ingen kalendere funnet. Vær vennlig å legge til en kalender først ved å benytte siden for kalenderadministrasjon.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Legg til ny avtale',
        'Calendars' => 'Kalendere',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Grunnleggende informasjon',
        'Date/Time' => 'Dato/tid',
        'Invalid date!' => 'Ugyldig dato!',
        'Please set this to value before End date.' => 'Sett denne til verdi før sluttdatoen.',
        'Please set this to value after Start date.' => 'Sett denne til verdi etter startdato.',
        'This an occurrence of a repeating appointment.' => 'Dette er en forekomst av en gjentatt avtale.',
        'Click here to see the parent appointment.' => 'Klikk her for å se foreldreavtalen.',
        'Click here to edit the parent appointment.' => 'Klikk her for å redigere foreldreavtalen.',
        'Frequency' => 'Frekvens',
        'Every' => 'Hver',
        'day(s)' => 'dag(er)',
        'week(s)' => 'uke(r)',
        'month(s)' => 'måned(er)',
        'year(s)' => 'år',
        'On' => 'På',
        'Monday' => 'mandag',
        'Mon' => 'man',
        'Tuesday' => 'tirsdag',
        'Tue' => 'tir',
        'Wednesday' => 'onsdag',
        'Wed' => 'ons',
        'Thursday' => 'torsdag',
        'Thu' => 'tor',
        'Friday' => 'fredag',
        'Fri' => 'fre',
        'Saturday' => 'lørdag',
        'Sat' => 'lør',
        'Sunday' => 'søndag',
        'Sun' => 'søn',
        'January' => 'januar',
        'Jan' => 'jan',
        'February' => 'februar',
        'Feb' => 'feb',
        'March' => 'mars',
        'Mar' => 'mar',
        'April' => 'april',
        'Apr' => 'apr',
        'May_long' => 'mai',
        'May' => 'mai',
        'June' => 'juni',
        'Jun' => 'jun',
        'July' => 'juli',
        'Jul' => 'jul',
        'August' => 'august',
        'Aug' => 'aug',
        'September' => 'september',
        'Sep' => 'sep',
        'October' => 'oktober',
        'Oct' => 'okt',
        'November' => 'november',
        'Nov' => 'nov',
        'December' => 'desember',
        'Dec' => 'des',
        'Relative point of time' => 'Relativt tidspunkt',
        'Link' => 'Koble',
        'Remove entry' => 'Slett post',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kundeinformasjonssenter',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Kunde-bruker',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Merk: Kunden er ugyldig!',
        'Start chat' => 'Start chat',
        'Video call' => 'Videosamtale',
        'Audio call' => 'Lydanrop',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Kundebrukers adressebok',
        'Search for recipients and add the results as \'%s\'.' => 'Søk etter mottakere og legg til resultatene som \'%s\'.',
        'Search template' => 'Bruk mal',
        'Create Template' => 'Ny mal',
        'Create New' => 'Ny',
        'Save changes in template' => 'Lagre endringer i mal',
        'Filters in use' => 'Filtre i bruk',
        'Additional filters' => 'Tilleggsfiltre',
        'Add another attribute' => 'Legg til attributt',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Attributtene med identifikatoren \'(kunde)\' er fra kundeselskapet.',
        '(e. g. Term* or *Term*)' => '(f.eks. Term* eller *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Velg alle',
        'The customer user is already selected in the ticket mask.' => 'Kundebrukeren er allerede valgt i saksmasken.',
        'Select this customer user' => 'Velg denne kundebrukeren',
        'Add selected customer user to' => 'Legg valgt kundebruker til',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Endre søke-innstillinger',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Kundebrukerinformasjonssenter',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO Daemon er en bakgrunnsprosess som utfører asynkrone oppgaver, f.eks. utløsning av sak-eskalering, e-postsending osv.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'En kjørende OTOBO agent er påkrevd for at systemet skal kjøre riktig.',
        'Starting the OTOBO Daemon' => 'Innstillinger for OTOBO Agenten',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Kontroller at filen \'%s\' eksisterer (uten .dist-utvidelse). Denne cron-jobben vil sjekke hvert 5. minutt om OTOBO Daemon kjører og starte den om nødvendig.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Kjør \'%s start\' for å sikre at cron-jobbene til \'otobo\'-brukeren er aktive.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Etter 5 minutter, sjekk at OTOBO Daemon kjører i systemet (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Kontrollpanel',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Ny avtale',
        'Tomorrow' => 'I morgen',
        'Soon' => 'Snart',
        '5 days' => '5 dager',
        'Start' => 'Start',
        'none' => 'ingen',

        # Template: AgentDashboardCalendarOverview
        'in' => 'om',

        # Template: AgentDashboardCommon
        'Save settings' => 'Lagre innstillinger',
        'Close this widget' => 'Lukk denne widgeten',
        'more' => 'mer',
        'Available Columns' => 'Tilgjengelige kolonner',
        'Visible Columns (order by drag & drop)' => 'Tilgjengelige kolonner (sorter ved dra og slipp)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Endre kundeforhold',
        'Open' => 'Åpen',
        'Closed' => 'Avsluttet',
        '%s open ticket(s) of %s' => '%s åpne sak(er) av %s',
        '%s closed ticket(s) of %s' => '%s lukkede sak(er) av %s',
        'Edit customer ID' => 'Rediger kunde-ID',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalerte saker',
        'Open tickets' => 'Åpne saker',
        'Closed tickets' => 'Lukkede saker',
        'All tickets' => 'Alle saker',
        'Archived tickets' => 'Arkiverte saker',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Merk: Kundebruker er ugyldig!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Kundebrukerinformasjon',
        'Phone ticket' => 'Telefonsak',
        'Email ticket' => 'E-postsak',
        'New phone ticket from %s' => 'Ny telefonsak fra %s',
        'New email ticket to %s' => 'Ny e-postsak til %s',

        # Template: AgentDashboardMyLastChangedTickets
        'No tickets found.' => 'Ingen saker funnet.',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilgjengelig!',
        'Please update now.' => 'Vennligst oppdater nå.',
        'Release Note' => 'Versjons-notis',
        'Level' => 'Nivå',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postet for %s siden.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Konfigurasjonen for denne statistikkwidgeten inneholder feil. Se gjennom innstillingene dine.',
        'Download as SVG file' => 'Last ned som SVG fil',
        'Download as PNG file' => 'Last ned som PNG fil',
        'Download as CSV file' => 'Last ned som CSV fil',
        'Download as Excel file' => 'Last ned som Excel fil',
        'Download as PDF file' => 'Last ned som PDF fil',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Velg et gyldig grafutdataformat i konfigurasjonen av denne widgeten.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Innholdet i denne statistikken forberedes for deg, vær tålmodig.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Denne statistikken kan for øyeblikket ikke brukes fordi konfigurasjonen må korrigeres av statistikkadministratoren.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Tilordnet kundebruker',
        'Accessible for customer user' => 'Tilgjengelig for kundebruker',
        'My locked tickets' => 'Mine saker',
        'My watched tickets' => 'Mine overvåkede saker',
        'My responsibilities' => 'Mine ansvar',
        'Tickets in My Queues' => 'Saker i Min Kø',
        'Tickets in My Services' => 'Saker i Mine Tjenester',
        'Service Time' => 'Tjenestetid',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Total',

        # Template: AgentDashboardUserOnline
        'out of office' => 'ikke på kontoret',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'time;Venter',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Detailed search' => 'Detaljert søk',
        'Add an additional attribute' => 'Legg til et ekstra attributt',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => 'Detaljvisning',

        # Template: AgentElasticsearchQuickResult
        'Tickets' => 'Saker',
        'ConfigItems' => 'ConfigItems',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'For å akseptere nyheter, en lisens eller endringer.',
        'Yes, accepted.' => 'Ja, godtatt.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Administrer koblinger for %s',
        'Create new links' => 'Lag nye lenker',
        'Manage existing links' => 'Administrer eksisterende lenker',
        'Link with' => 'Link med',
        'Start search' => 'Start søk',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Det er for øyeblikket ingen lenker. Vennligst klikk "Opprett nye lenker" øverst for å koble dette elementet til andre objekter.',

        # Template: AgentPassword
        'Password Policy' => 'Passordpolicy',
        'Your current password is older than %s days. You need to set a new one.' =>
            'Ditt nåværende passord er eldre enn %s dager. Du må sette en ny.',
        'Change password' => 'Endre passord',
        'Current password' => 'Nåværende passord',
        'New password' => 'Nytt passord',
        'Repeat new password' => 'Gjenta nytt passord',
        'Password needs to be renewed every %s days.' => 'Passordet må fornyes hver %s dag.',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            'Passordhistorikken er aktiv, du kan ikke bruke et passord som ble brukt de siste %s gangene.',
        'Password length must be at least %s characters.' => 'Passordlengden må være minst %s tegn.',
        'Password requires at least two lower- and two uppercase characters.' =>
            'Passord krever minst to små og to store tegn.',
        'Password requires at least two characters.' => 'Passord krever minst to tegn.',
        'Password requires at least one digit.' => 'Passord krever minst ett siffer.',
        'Change config options' => 'Endre konfigurasjonsalternativer',
        'Admin permissions are required!' => 'Administratortillatelser kreves!',

        # Template: AgentPreferences
        'Edit your preferences' => 'Endre dine innstillinger',
        'Personal Preferences' => 'Personlige innstillinger',
        'Preferences' => 'Innstillinger',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Vennligst merk: du redigerer for øyeblikket preferansene til %s.',
        'Go back to editing this agent' => 'Gå tilbake til å redigere denne agenten',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Sett opp dine personlige innstillinger. Lagre hver innstilling ved å klikke på haken til høyre.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Du kan bruke navigasjonstreet nedenfor til kun å vise innstillinger fra bestemte grupper.',
        'Dynamic Actions' => 'Dynamiske handlinger',
        'Filter settings...' => 'Filterinnstillinger...',
        'Filter for settings' => 'Filter for innstillinger',
        'Save all settings' => 'Lagre alle innstillinger',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Avatarer har blitt deaktivert av systemadministratoren. Du vil se initialene dine i stedet.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Du kan endre avatarbildet ditt ved å registrere deg med e-postadressen %s på %s. Vær oppmerksom på at det kan ta litt tid før den nye avataren din blir tilgjengelig på grunn av caching.',
        'End' => 'Slutt',
        'This setting can currently not be saved.' => 'Denne innstillingen kan for øyeblikket ikke lagres.',
        'This setting can currently not be saved' => 'Denne innstillingen kan for øyeblikket ikke lagres',
        'Save this setting' => 'Lagre denne innstillingen',
        'Did you know? You can help translating OTOBO at %s.' => 'Visste du? Du kan hjelpe til med å oversette OTOBO på %s.',

        # Template: SettingsList
        'Reset to default' => 'Tilbakestill til standard',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Velg fra gruppene til høyre for å finne innstillingene du ønsker å endre.',
        'Did you know?' => 'Visste du?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Du kan endre avataren din ved å registrere deg med e-postadressen din %s på %s',

        # Template: AgentSplitSelection
        'Target' => 'Mål',
        'Process' => 'configured!;Ingen',
        'Split' => 'Del',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Statistikkstyring',
        'Add Statistics' => 'Legg til statistikk',
        'Read more about statistics in OTOBO' => 'Les mer om statistikk i OTOBO',
        'Dynamic Matrix' => 'Dynamisk matrise',
        'Each cell contains a singular data point.' => 'Hver celle inneholder et enkelt datapunkt.',
        'Dynamic List' => 'Dynamisk liste',
        'Each row contains data of one entity.' => 'Hver rad inneholder data fra én enhet.',
        'Static' => 'Statisk',
        'Non-configurable complex statistics.' => 'Ikke-konfigurerbar kompleks statistikk.',
        'General Specification' => 'Generell spesifikasjon',
        'Create Statistic' => 'Lag statistikk',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Rediger statistikk',
        'Run now' => 'Kjør nå',
        'Statistics Preview' => 'Forhåndsvisning av statistikk',
        'Save Statistic' => 'Lagre statistikk',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Importstatistikk',
        'Import Statistics Configuration' => 'Importer statistikkonfigurasjon',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistikk',
        'Run' => 'Kjør',
        'Edit statistic "%s".' => 'Editer statistikk "%s".',
        'Export statistic "%s"' => 'Eksporter statistikk "%s"',
        'Export statistic %s' => 'Eksporter statistikk %s',
        'Delete statistic "%s"' => 'Slett statistikk "%s"',
        'Delete statistic %s' => 'Slett statistikk %s',

        # Template: AgentStatisticsReportsAdd
        'Report Management' => 'Rapporthåndtering',
        'Add Report' => 'Legg til rapport',

        # Template: AgentStatisticsReportsEdit
        'Edit Report' => 'Rediger rapport',
        'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.' =>
            'Her kan du kombinere flere statistikker til en rapport som du kan generere som PDF manuelt eller automatisk på konfigurerte tidspunkter.',
        'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.' =>
            'Vær oppmerksom på at du bare kan velge diagrammer som utdataformat for statistikk hvis du har konfigurert en av gjengivelsesbinærene på systemet ditt.',
        'Configure PhantomJS' => 'Konfigurer PhantomJS',
        'Configure GoogleChrome' => 'Konfigurer GoogleChrome',
        'General settings' => 'Generelle innstillinger',
        'Automatic generation settings' => 'Automatiske generasjonsinnstillinger',
        'Automatic generation times (cron)' => 'Automatiske generasjonstider (cron)',
        'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.' =>
            'Angi når rapporten skal genereres automatisk i cron-format, f.eks. g. "10 1 * * *" for hver dag kl. 01:10.',
        'Times are in the system timezone.' => 'Tidene er i systemets tidssone.',
        'Last automatic generation time' => 'Siste automatisk generasjonstid',
        'Next planned automatic generation time' => 'Neste planlagte automatiske genereringstid',
        'Automatic generation language' => 'Automatisk generasjonsspråk',
        'The language to be used when the report is automatically generated.' =>
            'Språket som skal brukes når rapporten genereres automatisk.',
        'Email subject' => 'E-postemne',
        'Specify the subject for the automatically generated email.' => 'Angi emnet for den automatisk genererte e-posten.',
        'Email body' => 'E-posttekst',
        'Specify the text for the automatically generated email.' => 'Spesifiser teksten for den automatisk genererte e-posten.',
        'Email recipients' => 'E-postmottakere',
        'Specify recipient email addresses (comma separated).' => 'Angi mottakers e-postadresser (kommaseparert).',
        'Output settings' => 'Utgangsinnstillinger',
        'Headline' => 'Overskrift',
        'Caption for preamble' => 'Bildetekst for ingress',
        'Preamble' => 'Innledning',
        'Caption for epilogue' => 'Bildetekst for epilog',
        'Epilogue' => 'Epilog',
        'Add statistic to report' => 'Legg til statistikk i rapporten',

        # Template: AgentStatisticsReportsOverview
        'Statistics Reports' => 'Statistikkrapporter',
        'Edit statistics report "%s".' => 'Rediger statistikkrapport "%s".',
        'Delete statistics report "%s"' => 'Slett statistikkrapport "%s"',

        # Template: AgentStatisticsReportsView
        'View Report' => 'Se rapport',
        'This statistics report contains configuration errors and can currently not be used.' =>
            'Denne statistikkrapporten inneholder konfigurasjonsfeil og kan for øyeblikket ikke brukes.',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Statistikk Oversikt',
        'View Statistics' => 'Se statistikk',
        'Statistics Information' => 'Statistikkinformasjon',
        'Created by' => 'Opprettet av',
        'Changed by' => 'Endret av',
        'Sum rows' => 'Summer rader',
        'Sum columns' => 'Summer kolonner',
        'Show as dashboard widget' => 'Vis som dashbord-widget',
        'Cache' => 'cleanup.;OTOBO',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Denne statistikken inneholder konfigurasjonsfeil og kan for øyeblikket ikke brukes.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Endre fritekst for %s%s%s',
        'Change Owner of %s%s%s' => 'Bytt eier av %s%s%s',
        'Close %s%s%s' => 'Lukk %s%s%s',
        'Add Note to %s%s%s' => 'Legg til notat til %s%s%s',
        'Set Pending Time for %s%s%s' => 'Angi ventetid for %s%s%s',
        'Change Priority of %s%s%s' => 'Endre prioritet for %s%s%s',
        'Change Responsible of %s%s%s' => 'Endre ansvarlig for %s%s%s',
        'Edit Article "%s" of %s%s%s' => '',
        'The ticket has been locked' => 'Saken har blitt låst',
        'Undo & close' => 'Angre og lukk',
        'Ticket Settings' => 'Oppsett av saker',
        'Queue invalid.' => 'Ugyldig kø.',
        'Service invalid.' => 'Tjenesten er ugyldig.',
        'SLA invalid.' => 'SLA ugyldig.',
        'New Owner' => 'Ny eier',
        'Please set a new owner!' => 'Vennligst sett en ny eier!',
        'Owner invalid.' => 'Eier ugyldig.',
        'New Responsible' => 'Ny ansvarlig',
        'Please set a new responsible!' => 'Vennligst angi en ny ansvarlig!',
        'Responsible invalid.' => 'Ansvarlig ugyldig.',
        'Next state' => 'Neste status',
        'State invalid.' => 'Tilstanden er ugyldig.',
        'For all pending* states.' => 'For alle med ventende tilstander.',
        'Add Article' => 'Legg til artikkel',
        'Create an Article' => 'Lag en artikkel',
        'Inform agents' => 'Informer saksbehandlerne',
        'Inform involved agents' => 'Informer involverte saksbehandlere',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Her kan du velge flere agenter som skal motta et varsel om den nye artikkelen.',
        'Text will also be received by' => 'Tekst vil også bli mottatt av',
        'Text Template' => 'Tekstmal',
        'Setting a template will overwrite any text or attachment.' => 'Hvis du angir en mal, overskrives all tekst eller vedlegg.',
        'Invalid time!' => 'Ugyldig tid!',

        # Template: AgentTicketArticleVersionView
        'Viewing Article Version#%s of current Article: #%s %s' => '',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Sprett %s%s%s',
        'Bounce to' => 'Oversend til',
        'You need a email address.' => 'Du trenger en e-postadresse.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Må ha en gyldig e-postadresse, og ikke en lokal adresse.',
        'Next ticket state' => 'Neste status på sak',
        'Inform sender' => 'Informer avsender',
        'Send mail' => 'Send e-posten',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Masseredigering av saker',
        'Send Email' => 'Send e-post',
        'Merge' => 'Flett',
        'Merge to' => 'Flett med',
        'Invalid ticket identifier!' => 'Ugyldig saksnummer!',
        'Merge to oldest' => 'Flett med eldste',
        'Link together' => 'Koble sammen',
        'Link to parent' => 'Koble til forelder',
        'Unlock tickets' => 'Lås opp saker',
        'Execute Bulk Action' => 'Utfør massehandling',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Skriv svar for %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Denne adressen er registrert som systemadresse og kan ikke brukes: %s',
        'Please include at least one recipient' => 'Vennligst oppgi minst en mottaker',
        'Select one or more recipients from the customer user address book.' =>
            'Velg én eller flere mottakere fra kundens brukeradressebok.',
        'Customer user address book' => 'Kundebrukers adressebok',
        'Remove Ticket Customer' => 'Fjern kunde fra sak',
        'Move to Cc' => 'Flytt til kopi',
        'Move to Bcc' => 'Flytt til Bcc',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Vennlist fjern innlegget og legg til en med riktige verdier.',
        'This address already exists on the address list.' => 'Denne adressen finnes allerede i adresseboken.',
        'Remove Cc' => 'Fjern Cc',
        'Move to To' => 'Flytt til Til',
        'Bcc' => 'Blindkopi',
        'Remove Bcc' => 'Fjern Bcc',
        'Date Invalid!' => 'Ugyldig dato!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Endre kunde for %s%s%s',
        'Customer Information' => 'Kundeinformasjon',
        'Customer user' => 'Kunde',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Opprett ny e-postsak',
        'Example Template' => 'Eksempel på mal',
        'To customer user' => 'Til kunde-bruker',
        'Please include at least one customer user for the ticket.' => 'Vennligst inkluder minst én kundebruker for saken.',
        'Select this customer as the main customer.' => 'Velg denne kunden som hovedkunden.',
        'Remove Ticket Customer User' => 'Fjern kundebruker fra sak',
        'From queue' => 'Fra kø',
        'Get all' => 'Hent alle',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Utgående e-post for %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Send e-post på nytt for %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Sak %s: første responstid er over (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Sak %s: første responstid vil være over om %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Sak %s: oppdateringstiden er over (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Sak %s: oppdateringstiden vil være over om %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Sak %s: løsningstiden er over (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Sak %s: løsningstiden vil være over om %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Videresend %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Historikk for %s%s%s',
        'Filter for history items' => 'Filtrer etter historieelementer',
        'Expand/collapse all' => 'Utvid/skjul alle',
        'CreateTime' => 'Opprettelsestidspunkt',
        'Article' => 'to',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Slå sammen %s%s%s',
        'Merge Settings' => 'Slå sammen innstillinger',
        'You need to use a ticket number!' => 'Du må bruke et saksnummer!',
        'A valid ticket number is required.' => 'Et gyldig Saksnummer er påkrevd.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Prøv å skrive inn deler av saksnummeret eller tittelen for å søke etter det.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Begrens søket til saker med samme kunde-ID (%s).',
        'Inform Sender' => 'Informer avsender',
        'Need a valid email address.' => 'Trenger en gyldig e-postadresse.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Flytt %s%s%s',
        'New Queue' => 'Ny kø',
        'Move' => 'Flytt',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Ingen saker ble funnet.',
        'Open / Close ticket action menu' => 'Åpne/lukk sakshandlingsmeny',
        'Select this ticket' => 'Velg denne saken',
        'Sender' => 'Avsender',
        'First Response Time' => 'Første responstid',
        'Update Time' => 'Oppdateringstid',
        'Solution Time' => 'Løsningstid',
        'Move ticket to a different queue' => 'Flytt saker til annen kø',
        'Change queue' => 'Endre kø',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Fjern aktive filtre for dette skjermbildet.',
        'Tickets per page' => 'Saker per side',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Mangler kanal',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Tilbakestill oversikten',
        'Column Filters Form' => 'Skjema for kolonnefiltre',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Del opp i ny telefonsak',
        'Save Chat Into New Phone Ticket' => 'Lagre chat i ny telefonsak',
        'Create New Phone Ticket' => 'Lag ny Telefon-sak',
        'Please include at least one customer for the ticket.' => 'Vennligst oppgi minst en kunde for denne saken.',
        'To queue' => 'Til kø',
        'Chat protocol' => 'Chat-protokoll',
        'The chat will be appended as a separate article.' => 'Chatten vil bli lagt ved som en egen artikkel.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefonsamtale for %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Se ren tekst for e-post for %s%s%s',
        'Plain' => 'Enkel',
        'Download this email' => 'Last ned denne e-posten',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Opprett ny prosess sak',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Registrer sak til en prosess',

        # Template: AgentTicketSearch
        'Profile link' => 'Lenke til profil',
        'Output' => 'Resultat',
        'Fulltext' => 'Fulltekst',
        'Customer ID (complex search)' => 'Kunde-ID (komplekst søk)',
        '(e. g. 234*)' => '(f.eks. 234*)',
        'Customer ID (exact match)' => 'Kunde-ID (eksakt samsvar)',
        'Assigned to Customer User Login (complex search)' => 'Tilordnet kundebrukerpålogging (komplekst søk)',
        '(e. g. U51*)' => '(f.eks. U51*)',
        'Assigned to Customer User Login (exact match)' => 'Tilordnet kundebrukerpålogging (eksakt samsvar)',
        'Accessible to Customer User Login (exact match)' => 'Tilgjengelig for kundebrukerpålogging (eksakt samsvar)',
        'Created in Queue' => 'Opprettet i kø',
        'Lock state' => 'Låsestatus',
        'Watcher' => 'Overvåker',
        'Article Create Time (before/after)' => 'Opprettelsestidspunkt for artikkel (før/etter)',
        'Article Create Time (between)' => 'Opprettelsestidspunkt for artikkel (mellom)',
        'Please set this to value before end date.' => 'Sett denne til verdi før sluttdatoen.',
        'Please set this to value after start date.' => 'Sett denne til verdi etter startdato.',
        'Ticket Create Time (before/after)' => 'Opprettelsestidspunkt for sak (før/etter)',
        'Ticket Create Time (between)' => 'Opprettelsestidspunkt for sak (mellom)',
        'Ticket Change Time (before/after)' => 'Endringstidspunkt for sak (før/etter)',
        'Ticket Change Time (between)' => 'Endringstidspunkt for sak (mellom)',
        'Ticket Last Change Time (before/after)' => 'Siste endringstid for sak (før/etter)',
        'Ticket Last Change Time (between)' => 'Tidspunkt for siste bytte av sak (mellom)',
        'Ticket Pending Until Time (before/after)' => 'Sak venter til tid (før/etter)',
        'Ticket Pending Until Time (between)' => 'Sak venter til tid (mellom)',
        'Ticket Close Time (before/after)' => 'Avslutningstidspunkt for sak (før/etter)',
        'Ticket Close Time (between)' => 'Avslutningstidspunkt for sak (mellom)',
        'Ticket Escalation Time (before/after)' => 'Saksopptrappingstid (før/etter)',
        'Ticket Escalation Time (between)' => 'Sakseskaleringstid (mellom)',
        'Archive Search' => 'Arkivsøk',

        # Template: AgentTicketZoom
        'Sender Type' => 'Sendertype',
        'Save filter settings as default' => 'Lagre filter som standard',
        'Event Type' => 'Hendelsestype',
        'Save as default' => 'Lagre som standard',
        'Drafts' => 'Utkast',
        'Change Queue' => 'Bytt kø',
        'There are no dialogs available at this point in the process.' =>
            'Det er ingen dialogbokser tilgjengelig på dette tidspunktet i prosessen.',
        'This item has no articles yet.' => 'Dette elementet har ingen artikler ennå.',
        'Ticket Timeline View' => 'Tidslinjevisning for saker',
        'Article Overview - %s Article(s)' => 'Artikkeloversikt – %s artikkel(er)',
        'Page %s' => 'Side %s',
        'Add Filter' => 'Legg til filter',
        'Set' => 'Sett',
        'Reset Filter' => 'Nullstill filter',
        'No.' => 'Nr.',
        'Unread articles' => 'Uleste innlegg',
        'Via' => 'Via',
        'Article Edited' => '',
        'Important' => 'Viktig',
        'Unread Article!' => 'Ulest innlegg!',
        'Incoming message' => 'Innkommende melding',
        'Outgoing message' => 'Utgående melding',
        'Internal message' => 'Intern melding',
        'Sending of this message has failed.' => 'Sending av denne meldingen mislyktes.',
        'The article was edited' => '',
        'Resize' => 'Gjør om størrelse',
        'Mark this article as read' => 'Marker denne artikkelen som lest',
        'Show Full Text' => 'Vis fulltekst',
        'Full Article Text' => 'Full artikkeltekst',
        'No more events found. Please try changing the filter settings.' =>
            'Fant ingen flere hendelser. Prøv å endre filterinnstillingene.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'via %s',
        'by %s' => 'av %s',
        'Toggle article details' => 'Veksle artikkeldetaljer',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Denne meldingen er under behandling. Har allerede prøvd å sende %s gang(er). Neste forsøk vil være %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'For å åpne koblinger i den følgende artikkelen, må du kanskje trykke Ctrl eller Cmd eller Shift-tasten mens du klikker på koblingen (avhengig av nettleseren og operativsystemet).',
        'Close this message' => 'Lukk denne meldingen',
        'Image' => 'Bilde',
        'PDF' => 'PDF',
        'Unknown' => 'Ukjent',
        'View' => 'Bilde',

        # Template: LinkTable
        'Linked Objects' => 'Koblede objekter',

        # Template: TicketInformation
        'Archive' => 'Arkiv',
        'This ticket is archived.' => 'Denne saken er arkivert.',
        'Note: Type is invalid!' => 'Merk: Typen er ugyldig!',
        'Pending till' => 'Utsatt til',
        'Locked' => 'Tilgjengelighet',
        '%s Ticket(s)' => '%s sak(er)',
        'Accounted time' => 'Benyttet tid',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'Forhåndsvisning av denne artikkelen er ikke mulig fordi %s kanal mangler i systemet.',
        'Please re-install %s package in order to display this article.' =>
            'Installer %s-pakken på nytt for å vise denne artikkelen.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'For å beskytte personvernet ditt ble eksternt innhold blokkert.',
        'Load blocked content.' => 'Last inn blokkert innhold.',

        # Template: Breadcrumb
        'Home' => 'Hjem',
        'Back to admin overview' => 'Tilbake til adminoversikt',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Denne funksjonen krever skytjenester',
        'You can' => 'Du kan',
        'go back to the previous page' => 'gå tilbake til forrige side',

        # Template: CustomerAccept
        'Click to accept' => 'Klikk for å godta',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'Kunde-ID kan ikke endres, ingen annen kunde-ID kan tilordnes denne saken.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Velg først en kundebruker, deretter kan du velge en kunde-ID som skal tilordnes denne saken.',
        'Select a customer ID to assign to this ticket.' => 'Velg en kunde-ID som skal tilordnes denne saken.',
        'From all Customer IDs' => 'Fra alle kunde-ID-er',
        'From assigned Customer IDs' => 'Fra tildelte kunde-ID-er',

        # Template: CustomerDashboard
        'Ticket Search' => 'Søk i saker',
        'New Ticket' => 'Ny sak',

        # Template: CustomerError
        'An Error Occurred' => 'En feil oppstod',
        'Error Details' => 'Feildetaljer',
        'Traceback' => 'Tilbakesporing',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s oppdaget mulige nettverksproblemer. Du kan enten prøve å laste inn denne siden på nytt manuelt eller vente til nettleseren din har reetablert tilkoblingen på egen hånd.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Forbindelsen er gjenopprettet etter et midlertidig tap av forbindelse. På grunn av dette kan elementene på denne siden ha sluttet å fungere korrekt. For å kunne bruke alle elementene riktig igjen, anbefales det sterkt å laste denne siden på nytt.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript ikke tilgjengelig',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'For å bruke denne programvaren, må du aktivere JavaScript i nettleseren din.',
        'Browser Warning' => 'Advarsel om nettleseren',
        'The browser you are using is too old.' => 'Nettleseren du bruker er for gammel.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Denne programvaren kjører med et stort antall nettlesere, vennligst oppgrader til en av disse.',
        'Please see the documentation or ask your admin for further information.' =>
            'Vennligst se dokumentasjonen eller spør din IT-ansvarlige for mer informasjon.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            'Nettleseren du bruker støtter ikke css-grid. Den er sannsynligvis for gammel.',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            'Internet Explorer er funksjonell, men ikke alle funksjoner støttes fullt ut. Vennligst vurder å oppdatere til en moderne nettleser.',
        'One moment please, you are being redirected...' => 'Et øyeblikk, du blir omdirigert...',
        'Login' => 'Innlogging',
        'Your user name' => 'Ditt brukernavn',
        'User name' => 'Brukernavn',
        'Your password' => 'Ditt passord',
        'Forgot password?' => 'Glemt passordet?',
        'Your 2 Factor Token' => 'Ditt 2-faktor-token',
        '2 Factor Token' => 'Tofaktor-token',
        'Log In' => 'Logg inn',
        'Request Account' => 'Be om konto',
        'Request New Password' => 'Be om nytt passord',
        'Your User Name' => 'Ditt brukernavn',
        'A new password will be sent to your email address.' => 'Nytt passord vil bli sendt til din e-postadresse.',
        'Create Account' => 'Opprett konto',
        'Please fill out this form to receive login credentials.' => 'Vennligst fyll ut dette skjemaet for å motta påloggingsinformasjon.',
        'How we should address you' => 'Hvordan skal vi tiltale deg',
        'Your First Name' => 'Ditt fornavn',
        'Your Last Name' => 'Ditt etternavn',
        'Your email address (this will become your username)' => 'Din e-postadresse (Dette vil bli ditt brukernavn)',

        # Template: CustomerNavigationBar
        'Logout' => 'Logg ut',

        # Template: CustomerPassword
        'Change Password' => 'Bytt passord',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            'Passordet må inneholde minst 3 av tegnklassene: små bokstaver, store bokstaver, siffer, spesialtegn.',

        # Template: CustomerTicketList
        'Welcome!' => 'Velkommen!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            'Du har ingen saker ennå. Klikk her for å opprette en ny.',
        'Nothing to show.' => 'Ingenting å vise.',
        'Click here for an unfiltered list of all your tickets.' => 'Klikk her for en ufiltrert liste over alle sakene dine.',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => 'Lag en ny sak',
        'Service level agreement' => 'Tjenestenivåavtale',

        # Template: CustomerTicketOverview
        'Your Tickets' => 'Dine saker',
        'Page' => 'Side',
        'Sort' => 'Sortere',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'f.eks. 10*5155 eller 105658*',
        'CustomerID' => 'Kunde-ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Fulltekstsøk i saker (f.eks. "John*n" eller "Will*")',
        'Types' => 'Typer',
        'Time Restrictions' => 'Tidsbegrensninger',
        'No time settings' => 'Ingen tidsinnstillinger',
        'All' => 'Packages;Oppdater',
        'Specific date' => 'Spesifikk dato',
        'Only tickets created' => 'Kun saker opprettet',
        'Date range' => 'Datointervall',
        'Only tickets created between' => 'Kun saker opprettet mellom',
        'Ticket Archive System' => 'Saksarkivsystem',
        'Save Search as Template?' => 'Lagre søk som mal?',
        'Save as Template?' => 'Lagre som mal?',
        'Save as Template' => 'Lagre som mal',
        'Pick a profile name' => 'Velg et profil navn',
        'Output to' => 'Skriv ut til',

        # Template: CustomerTicketSearchResultShort
        'of' => 'av',
        'Search Results for' => 'Søkeresultater for',
        'Remove this Search Term.' => 'Fjern dette søkekriteriet.',

        # Template: CustomerTicketZoom
        'Reply' => 'Svar',
        'Discard' => 'Kast',

        # Template: Chat
        'Expand article' => 'Utvid artikkel',

        # Template: MIMEBase
        'Article Information' => 'Artikkelinformasjon',

        # Template: TicketInfo
        'Ticket Information' => 'Saksinformasjon',
        'Categories' => 'Kategorier',
        'Further actions' => 'Ytterligere handlinger',

        # Template: CustomerWarning
        'Warning' => 'Advarsel',

        # Template: TileNewTicket
        'Issue%sa ticket' => 'Utsted%sen sak',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Hendelsesinformasjon',

        # Template: Error
        'Send a bugreport' => 'Send en feilrapport',
        'Expand' => 'Utvid',

        # Template: Footer
        'Powered by %s' => 'Drevet av %s',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Klikk for å slette dette vedlegget.',

        # Template: DraftButtons
        'Update draft' => 'Oppdater utkastet',
        'Save as new draft' => 'Lagre som nytt utkast',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Du har lastet utkastet "%s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Du har lastet utkastet "%s". Du endret det sist %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Du har lastet utkastet "%s". Det ble sist endret %s av %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Vær oppmerksom på at dette utkastet er utdatert fordi saken ble endret siden dette utkastet ble opprettet.',

        # Template: Header
        'Edit personal preferences' => 'Endre personlige innstillinger',
        'Personal preferences' => 'Personlige preferanser',
        'You are logged in as' => 'Du er innlogget som',

        # Template: Installer
        'JavaScript not available' => 'JavaScript er ikke tilgjengelig',
        'Step %s' => 'Steg %s',
        'License' => 'Lisens',
        'Database Settings' => 'Databaseinnstillinger',
        'General Specifications and Mail Settings' => 'Generelle spesifikasjoner og e-post-innstillinger',
        'Welcome to %s' => 'Velkommen til %s',
        'Germany' => 'Tyskland',
        'Phone' => 'Telefon',
        'Web site' => 'Websted',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Sett opp utgående e-post',
        'Outbound mail type' => 'Type',
        'Select outbound mail type.' => 'Velg type utgående e-post.',
        'Outbound mail port' => 'Utgående port for e-post',
        'Select outbound mail port.' => 'Velg port for utgående e-post.',
        'SMTP host' => 'SMTP-tjener',
        'SMTP host.' => 'SMTP-tjener.',
        'SMTP authentication' => 'SMTP-autentisering',
        'Does your SMTP host need authentication?' => 'Trenger SMTP-tjeneren din autentisering?',
        'SMTP auth user' => 'Bruker for autentisering',
        'Username for SMTP auth.' => 'Brukernavn for SMTP-autentisering.',
        'SMTP auth password' => 'Passord for autentisering',
        'Password for SMTP auth.' => 'Passord for SMTP-autentisering.',
        'Configure Inbound Mail' => 'Sett opp innkommende e-post',
        'Inbound mail type' => 'Type',
        'Select inbound mail type.' => 'Velg type for innkommende e-post.',
        'Inbound mail host' => 'E-post-tjener',
        'Inbound mail host.' => 'E-post-tjener.',
        'Inbound mail user' => 'Brukernavn',
        'User for inbound mail.' => 'Bruker for innkommende e-post.',
        'Inbound mail password' => 'Passord',
        'Password for inbound mail.' => 'Passord for innkommende e-post.',
        'Result of mail configuration check' => 'Resultat for e-postsjekk',
        'Check mail configuration' => 'Sjekk e-postkonfigurasjonen',
        'Skip this step' => 'Hopp over dette steget',

        # Template: InstallerDBResult
        'Done' => 'Ferdig',
        'Error' => 'Feil',
        'Database setup successful!' => 'Konfigurasjon av databasen var vellykket!',

        # Template: InstallerDBStart
        'Install Type' => 'Installasjonstype',
        'Create a new database for OTOBO' => 'Opprett en ny database for OTOBO',
        'Use an existing database for OTOBO' => 'Bruk en eksisterende database for OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Hvis du har satt et root-passord for din database må det bli skrevet inn her. Hvis ikke, la dette feltet være tomt.',
        'Database name' => 'Databasenavn',
        'Check database settings' => 'Sjekk database-oppsett',
        'Result of database check' => 'Resultat for databasesjekken',
        'Database check successful.' => 'Databasesjekk fullført.',
        'Database User' => 'Databasebruker',
        'New' => 'Statistics',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'En ny databasebruker med begrensede rettigheter vil bli opprettet for denne OTOBO-installasjonen.',
        'Generated password' => 'Opprett hvilkårlig passord',
        'Repeat Password' => 'Gjenta passord',
        'Passwords do not match' => 'Passordet stemmer ikke',

        # Template: InstallerFinish
        'Start page' => 'Startside',
        'Your OTOBO Team' => 'OTOBO-Teamet',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Ikke aksepter lisens',
        'Accept license and continue' => 'Aksepter lisensen og fortsett',

        # Template: InstallerSystem
        'SystemID' => 'System-ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identifikator for dette systemet. Saksnumre og HTTP-sesjoner bruker dette nummeret.',
        'HTTP Type' => 'HTTP-type',
        'Set the request scheme used for cookies and various links. For production purposes always use https.' =>
            'Angi forespørselsskjemaet som brukes for informasjonskapsler og ulike lenker. For produksjonsformål bruk alltid https.',
        'System FQDN' => 'Systemets tjenernavn (FQDN)',
        'Fully qualified domain name of your system.' => 'Fullt kvalifisert domene-navn for din tjener.',
        'AdminEmail' => 'Admin e-post',
        'Email address of the system administrator.' => 'E-postadresse til systemadministratoren.',
        'Organization' => 'Organisasjon',
        'Log' => 'Account',
        'LogModule' => 'Logg-modul',
        'Log backend to use.' => 'Loggmetode som skal brukes.',
        'LogFile' => 'Logg-fil',
        'Webfrontend' => 'Web-grensesnitt',
        'Default language' => 'Standardspråk',
        'Default language.' => 'Standardspråk.',
        'CheckMXRecord' => 'Sjekk MX-informasjon',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-postadresser som angis manuelt, sjekkes mot MX-oppføringer i DNS. Ikke bruk dette valget dersom din DNS er treg eller ikke gjør oppslag for offentlige adresser.',
        'Elasticsearch' => 'Elasticsearch',
        'Initialize Elasticsearch' => 'Initialiser Elasticsearch',
        'Elasticsearch server was found, and it has been activated automatically for OTOBO.' =>
            'Elasticsearch-serveren ble funnet, og den har blitt aktivert automatisk for OTOBO.',
        'Seemingly either no clean Elasticsearch server is running, or it is not using the standard configuration. To activate Elasticsearch manually, please edit the web service in the admin interface if necessary, activate \'Elasticsearch::Active\' and \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in the SysConfig and run the otobo.Console command \'Maint::Elasticsearch::Migration\'.' =>
            'Tilsynelatende kjører enten ingen ren Elasticsearch-server, eller så bruker den ikke standardkonfigurasjonen. For å aktivere Elasticsearch manuelt, vennligst rediger nettjenesten i administrasjonsgrensesnittet om nødvendig, aktiver \'Elasticsearch::Active\' og \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' i SysConfig og kjør kommandoen otobo.Console \'Maint::Elasticsearch::Migration\'.',

        # Template: LinkObject
        'Delete link' => 'Slett lenke',
        'Delete Link' => 'Slett lenke',
        'Object#' => 'Objekt#',
        'Add links' => 'Legg til lenker',
        'Delete links' => 'Slett lenker',

        # Template: Login
        'Lost your password?' => 'Mistet passord?',
        'Back to login' => 'Tilbake til innlogging',

        # Template: MetaFloater
        'Scale preview content' => 'Skaler forhåndsvisningsinnhold',
        'Open URL in new tab' => 'Åpne URL i ny fane',
        'Close preview' => 'Lukk forhåndsvisning',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'En forhåndsvisning av dette nettstedet kan ikke gis fordi det ikke tillot å bli innebygd.',

        # Template: Copy
        'Start migration' => 'Start migrering',
        'Result of data migration' => 'Resultat av datamigrering',
        'Last successful task:' => 'Siste vellykkede oppgave:',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            'Migreringen starter på nytt fra den siste fullførte oppgaven. Gjør en fullstendig omkjøring hvis du endret systemet i mellomtiden.',
        'Clean up and finish' => 'Rydd opp og fullfør',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            'Migreringen er fullført, takk for at du prøvde OTOBO - vi håper du vil like den.',
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'For å kunne bruke OTOBO, må følgende linje utføres på kommandolinjen som root.',
        'Restart your webserver' => 'Restart webserveren din',
        'After doing so your OTOBO is up and running.' => 'Etter dette vil OTOBO være oppe og kjøre.',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            'Dette migreringsskriptet vil lede deg trinn for trinn gjennom prosessen med å migrere sakssystemet ditt fra OTRS eller ((OTRS)) Community Edition versjon 6 til OTOBO 10.',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            'Det er ingen fare for det opprinnelige systemet ditt: ingenting er endret der.',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            'Instruksjoner og detaljer om migreringsforutsetninger finnes i migreringshåndboken. Vi anbefaler på det sterkeste å lese den før du starter migreringen.',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            'I tilfelle du må stanse migreringen, kan du gjenoppta den når som helst på samme tidspunkt så lenge hurtigbufferen ikke er slettet.',
        'All entered passwords are cached until the migration is finished.' =>
            'Alle angitte passord bufres til migreringen er fullført.',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            ' Alle med tilgang til denne siden, eller lesetillatelse for OTOBO Home Directory vil kunne lese dem. Hvis du avbryter migreringen, får du muligheten til å tømme hurtigbufferen ved å besøke denne siden igjen.',
        'If you need support, just ask our experts – either at' => 'Hvis du trenger støtte, spør ekspertene våre – enten på',
        'OTOBO forum' => 'OTOBO forum',
        'or directly via mail to' => 'eller direkte på mail til',
        'Cached data found' => 'Bufret data funnet',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            'Du fortsetter der du avbrøt migreringen forrige gang. Hvis du ikke ønsker dette, vennligst forkast din tidligere fremgang.',
        'An error occured.' => 'En feil oppstod.',
        'Discard previous progress' => 'Forkast tidligere fremgang',
        'Insecure HTTP connection' => 'Usikker HTTP-tilkobling',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            'Du bruker migreringsskriptet via http. Dette er svært usikkert da ulike passord kreves under prosessen, og vil bli overført ukryptert. Alle mellom deg og OTOBO-serveren vil kunne lese dem! Vurder å sette opp https i stedet.',
        'Continue anyways :(' => 'Fortsett uansett :(',
        ' Continue anyways :(' => ' Fortsett uansett :(',

        # Template: OTRSDBSettings
        'DSN' => 'DSN',
        'Skip DB migration' => 'Hopp over DB-migrering',
        'Expert option! Only works if the migration has already been done by hand.' =>
            'Ekspertalternativ! Fungerer kun hvis migreringen allerede er gjort for hånd.',
        'Skipped.' => 'Hoppet over.',

        # Template: OTRSFileSettings
        'OTRS server' => 'OTRS-server',
        'SSH User' => 'SSH-bruker',
        'OTRS home directory' => 'OTRS hjemmekatalog',
        'Check settings' => 'Sjekk innstillingene',
        'Result of settings check' => 'Resultat av innstillingskontroll',
        'Settings check successful.' => 'Innstillingssjekk vellykket.',

        # Template: PreChecks
        'Execute migration pre-checks' => 'Utfør forhåndssjekker for migrering',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Funksjonen er ikke tilgjengelig',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Beklager, men denne funksjonen til OTOBO er for øyeblikket ikke tilgjengelig for mobile enheter. Hvis du vil bruke den, kan du enten bytte til skrivebordsmodus eller bruke den vanlige skrivebordsenheten.',

        # Template: Motd
        'Message of the Day' => 'Dagens melding',
        'This is the message of the day. You can edit this in %s.' => 'Dette er dagens budskap. Du kan redigere dette i %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Utilstrekkelige rettigheter',
        'Back to the previous page' => 'Tilbake til forrige side',

        # Template: Alert
        'Alert' => 'Varsling',
        'Powered by' => 'Drevet av',

        # Template: Pagination
        'Show first page' => 'Vis første side',
        'Show previous pages' => 'Vis foregående sider',
        'Show page %s' => 'Vis side %s',
        'Show next pages' => 'Vis neste sider',
        'Show last page' => 'Vis siste side',

        # Template: PictureUpload
        'Need FormID!' => 'Trenger FormID!',
        'No file found!' => 'Ingen fil ble funnet!',
        'The file is not an image that can be shown inline!' => 'Filen er ikke et bilde som kan vises i nettleseren!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Ingen brukerkonfigurerbare varsler funnet.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Motta meldinger for varsel \'%s\' med transportmetoden \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Prosessinformasjon',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Informer Saksbehandler',

        # Template: PublicDefault
        'Welcome' => 'Velkommen',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Dette er det offentlige standardgrensesnittet til OTOBO! Det ble ikke gitt noen handlingsparameter.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Du kan installere en tilpasset offentlig modul (via pakkebehandlingen), for eksempel FAQ-modulen, som har et offentlig grensesnitt.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Tilgang',
        'You can select one or more groups to define access for different agents.' =>
            'Du kan velge en eller flere grupper for å gi tilgang for forskjellige saksbehandlere.',
        'Result formats' => 'Resultatformater',
        'Time Zone' => 'Tidssone',
        'The selected time periods in the statistic are time zone neutral.' =>
            'De valgte tidsperiodene i statistikken er tidssonenøytrale.',
        'Create summation row' => 'Opprett summeringsrad',
        'Generate an additional row containing sums for all data rows.' =>
            'Generer en ekstra rad som inneholder summer for alle datarader.',
        'Create summation column' => 'Opprett summeringskolonne',
        'Generate an additional column containing sums for all data columns.' =>
            'Generer en ekstra kolonne som inneholder summer for alle datakolonner.',
        'Cache results' => 'Cache-resultater',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Lagrer statistikkresultatdata i en hurtigbuffer som skal brukes i påfølgende visninger med samme konfigurasjon (krever minst ett valgt tidsfelt).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Oppgi statistikken som en widget som agenter kan aktivere i dashbordet.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Vær oppmerksom på at aktivering av dashboard-widgeten vil aktivere caching for denne statistikken i dashbordet.',
        'If set to invalid end users can not generate the stat.' => 'Hvis satt til ugyldig kan ikke sluttbrukere generere statistikken.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Det er problemer i konfigurasjonen av denne statistikken:',
        'You may now configure the X-axis of your statistic.' => 'Du kan nå konfigurere X-aksen til statistikken.',
        'This statistic does not provide preview data.' => 'Denne statistikken gir ikke forhåndsvisningsdata.',
        'Preview format' => 'Forhåndsvisningsformat',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Vær oppmerksom på at forhåndsvisningen bruker tilfeldige data og tar ikke hensyn til datafiltre.',
        'Configure X-Axis' => 'Konfigurer X-aksen',
        'X-axis' => 'X-akse',
        'Configure Y-Axis' => 'Konfigurer Y-aksen',
        'Y-axis' => 'Y-akse',
        'Configure Filter' => 'Konfigurer filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Vennligst velg kun ett element, eller deaktivere \'Fast\' knappen.',
        'Absolute period' => 'Absolutt periode',
        'Between %s and %s' => 'Mellom %s og %s',
        'Relative period' => 'Relativ periode',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Den siste komplette %s og den nåværende+kommende komplette %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Ikke tillat endringer i dette elementet når statistikken genereres.',

        # Template: StatsParamsWidget
        'Exchange Axis' => 'Bytt akser',
        'Configurable Params of Static Stat' => 'Konfigurerbare parametere for statisk stat',
        'No element selected.' => 'Ingen valgte elementer.',
        'Scale' => 'Skala',
        'show more' => 'vis mer',
        'show less' => 'vis mindre',

        # Template: D3
        'Download SVG' => 'Last ned SVG',
        'Download PNG' => 'Last ned PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Den valgte tidsperioden definerer standard tidsrammen for denne statistikken å samle inn data fra.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Definerer tidsenheten som skal brukes til å dele den valgte tidsperioden inn i rapporteringsdatapunkter.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Husk at skalaen for Y-aksen må være større enn skalaen for X-aksen (f.eks. X-aksen => Måned, Y-aksen => År).',

        # Template: StatsWidget
        'Remove statistic' => 'Fjern statistikk',
        'If you don\'t specify a title here, the title of the statistic will be used.' =>
            'Hvis du ikke spesifiserer en tittel her, vil tittelen på statistikken bli brukt.',
        'Preface' => 'Forord',
        'Postface' => 'Etterord',

        # Template: SettingHistoryListCompare
        'On ' => 'På ',
        'Reset to this value' => 'Tilbakestill til denne verdien',

        # Template: SettingsList
        'This setting is disabled.' => 'Denne innstillingen er deaktivert.',
        'This setting is fixed but not deployed yet!' => 'Denne innstillingen er løst, men ikke distribuert ennå!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Denne innstillingen blir for øyeblikket overstyrt i %s og kan derfor ikke endres her!',
        'Changing this setting is only available in a higher config level!' =>
            'Endring av denne innstillingen er bare tilgjengelig på et høyere konfigurasjonsnivå!',
        '%s (%s) is currently working on this setting.' => '%s (%s) jobber for øyeblikket med denne innstillingen.',
        'Toggle advanced options for this setting' => 'Slå på avanserte alternativer for denne innstillingen',
        'Disable this setting, so it is no longer effective' => 'Deaktiver denne innstillingen, slik at den ikke lenger er effektiv',
        'Disable' => 'Deaktiver',
        'Enable this setting, so it becomes effective' => 'Aktiver denne innstillingen, så den blir effektiv',
        'Enable' => 'Muliggjøre',
        'Reset this setting to its default state' => 'Tilbakestill denne innstillingen til standardtilstanden',
        'Reset setting' => 'Tilbakestill innstillingen',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Tillat brukere å tilpasse denne innstillingen fra sine personlige preferanser',
        'Allow users to update' => 'Tillat brukere å oppdatere',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Ikke lenger la brukere tilpasse denne innstillingen fra sine personlige preferanser',
        'Forbid users to update' => 'Forby brukere å oppdatere',
        'Show user specific changes for this setting' => 'Vis brukerspesifikke endringer for denne innstillingen',
        'Show user settings' => 'Vis brukerinnstillinger',
        'Copy a direct link to this setting to your clipboard' => 'Kopier en direkte lenke til denne innstillingen til utklippstavlen',
        'Copy direct link' => 'Kopier direkte lenke',
        'Remove this setting from your favorites setting' => 'Fjern denne innstillingen fra favorittinnstillingen',
        'Remove from favourites' => 'Fjern fra favoritter',
        'Add this setting to your favorites' => 'Legg til denne innstillingen til dine favoritter',
        'Add to favourites' => 'Legg til i favoritter',
        'Cancel editing this setting' => 'Avbryt redigering av denne innstillingen',
        'Save changes on this setting' => 'Lagre endringer på denne innstillingen',
        'Edit this setting' => 'Rediger denne innstillingen',
        'Enable this setting' => 'Aktiver denne innstillingen',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Denne gruppen inneholder ingen innstillinger. Prøv å navigere til en av undergruppene eller en annen gruppe.',

        # Template: SettingsListCompare
        'Now' => 'Nå',
        'User modification' => 'Brukerendring',
        'enabled' => 'aktivert',
        'disabled' => 'funksjonshemmet',
        'Setting state' => 'Innstillingstilstand',

        # Template: Actions
        'Edit search' => 'Rediger søk',
        'Go back to admin: ' => 'Gå tilbake til admin: ',
        'Deployment' => 'Utplassering',
        'My favourite settings' => 'Mine favorittinnstillinger',
        'Invalid settings' => 'Ugyldige innstillinger',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtrer synlige innstillinger...',
        'Enable edit mode for all settings' => 'Aktiver redigeringsmodus for alle innstillinger',
        'Save all edited settings' => 'Lagre alle redigerte innstillinger',
        'Cancel editing for all settings' => 'Avbryt redigering for alle innstillinger',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Alle handlinger fra denne widgeten gjelder kun for de synlige innstillingene til høyre.',

        # Template: Help
        'Currently edited by me.' => 'For øyeblikket redigert av meg.',
        'Modified but not yet deployed.' => 'Modifisert, men ikke utplassert ennå.',
        'Currently edited by another user.' => 'For øyeblikket redigert av en annen bruker.',
        'Different from its default value.' => 'Forskjellig fra standardverdien.',
        'Save current setting.' => 'Lagre gjeldende innstilling.',
        'Cancel editing current setting.' => 'Avbryt redigering av gjeldende innstilling.',

        # Template: Navigation
        'Navigation' => 'Navigasjon',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => 'Slett brukerens verdi.',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO Test-side',
        'Unlock' => 'Frigi sak',
        'Welcome %s %s' => 'Velkommen %s %s',
        'Counter' => 'Teller',

        # Template: TranslationsTable
        'Filter Content' => '',
        'Filter for Translations' => '',
        'No content available to translate.' => '',

        # Template: Warning
        'Go back to the previous page' => 'Tilbake til forrige side',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Vis',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Utkast til tittel',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Artikkelvisning',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Vil du virkelig slette "%s"?',
        'Confirm' => 'Bekreft',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Laster Vennligst vent...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => 'Vis alt',
        'Show less' => 'Vis mindre',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Klikk for å velge en fil for opplasting.',
        'Click to select or drop files here.' => 'Klikk for å velge eller slippe filer her.',
        'Click to select files or just drop them here.' => 'Klikk for å velge filer eller bare slipp dem her.',
        'Click to select a file or just drop it here.' => 'Klikk for å velge en fil eller bare slipp den her.',
        'Uploading...' => 'Laster opp...',

        # JS Template: MigrationState
        'Time needed' => 'Tid som trengs',

        # JS Template: PackageResolve
        'Package' => 'Pakke',
        'Uninstall from OTOBO' => 'Avinstaller fra OTOBO',
        'Ignore' => 'Overse',
        'Migrate' => 'Migrer',

        # JS Template: InformationDialog
        'Process state' => 'Prosesstilstand',
        'Running' => 'Løping',
        'Finished' => 'Ferdig',
        'No package information available.' => 'Ingen pakkeinformasjon tilgjengelig.',

        # JS Template: AddButton
        'Add new entry' => 'Ny post',

        # JS Template: AddHashKey
        'Add key' => 'Legg til nøkkel',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Implementeringskommentar...',
        'This field can have no more than 250 characters.' => 'Dette feltet kan ikke ha mer enn 250 tegn.',
        'Deploying, please wait...' => 'Implementerer, vennligst vent...',
        'Preparing to deploy, please wait...' => 'Forbereder distribusjon, vennligst vent...',
        'Deploy now' => 'Distribuer nå',
        'Try again' => 'Prøv igjen',

        # JS Template: DialogReset
        'Reset options' => 'Tilbakestill alternativer',
        'Reset setting on global level.' => 'Tilbakestill innstillingen på globalt nivå.',
        'Reset globally' => 'Tilbakestill globalt',
        'Remove all user changes.' => 'Fjern alle brukerendringer.',
        'Reset locally' => 'Tilbakestill lokalt',
        'user(s) have modified this setting.' => 'bruker(e) har endret denne innstillingen.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Vil du virkelig tilbakestille denne innstillingen til standardverdien?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Du kan bruke kategorivalget for å begrense navigasjonstreet nedenfor til oppføringer fra den valgte kategorien. Så snart du velger kategori, vil treet bli gjenoppbygd.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Database-backend',
        'CustomerIDs' => 'Kunde-IDer',
        'Fax' => 'Telefaks',
        'Street' => 'Gate',
        'Zip' => 'Postnr',
        'City' => 'By',
        'Country' => 'Land',
        'Mr.' => 'Hr.',
        'Mrs.' => 'Fru',
        'Manager' => '',
        'Address' => 'Adresse',
        'View system log messages.' => 'Vis systemloggmeldinger.',
        'Edit the system configuration settings.' => 'Endre på systeminnstillingene.',
        'Update and extend your system with software packages.' => 'Oppdater og utvid systemet med programvarepakker.',

        # Perl Module: Kernel/Language.pm
        '(in process)' => '(under arbeid)',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL informasjonen fra databasen er ikke i synk med systemkonfigurasjonen, vennligst distributer alle ACLer.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACL-er kunne ikke importeres på grunn av en ukjent feil, vennligst sjekk OTOBO-loggene for mer informasjon',
        'The following ACLs have been added successfully: %s' => 'Følgende tilgangskontrollister er lagt til: %s',
        'The following ACLs have been updated successfully: %s' => 'Følgende tilgangskontrollister har blitt oppdatert: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Det var feil ved å legge til/oppdatere følgende tilgangskontrollister: %s. Vennligst sjekk loggfilen for mer informasjon.',
        'There was an error creating the ACL' => 'Det oppsto en feil ved opprettelse av tilgangskontrollisten',
        'Need ACLID!' => 'Trenger ACLID!',
        'Could not get data for ACLID %s' => 'Kunne ikke hente data for ACLID %s',
        'There was an error updating the ACL' => 'Det oppsto en feil under oppdatering av tilgangskontrollisten',
        'There was an error setting the entity sync status.' => 'Det oppsto en feil under innstilling av enhetssynkroniseringsstatus.',
        'There was an error synchronizing the ACLs.' => 'Det oppsto en feil under synkronisering av tilgangskontrollistene.',
        'ACL %s could not be deleted' => 'ACL %s kunne ikke slettes',
        'There was an error getting data for ACL with ID %s' => 'Det oppsto en feil ved henting av data for ACL med ID %s',
        '%s (copy) %s' => '%s (kopi) %s\'',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Vær oppmerksom på at ACL-begrensninger vil bli ignorert for Superuser-kontoen (UserID 1).',
        'Exact match' => 'Nøyaktig treff',
        'Negated exact match' => 'Negert eksakt samsvar',
        'Regular expression' => 'Vanlig uttrykk',
        'Regular expression (ignore case)' => 'Regelmessig uttrykk (ignorer store og små bokstaver)',
        'Negated regular expression' => 'Negert regulært uttrykk',
        'Negated regular expression (ignore case)' => 'Negert regulært uttrykk (ignorer store og små bokstaver)',

        # Perl Module: Kernel/Modules/AdminAbout.pm
        'Could not update About message!' => 'Kunne ikke oppdatere Om melding!',
        'About message updated!' => 'Om melding oppdatert!',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Systemet kunne ikke opprette kalender!',
        'Please contact the administrator.' => 'Vennligst kontakt administratoren.',
        'No CalendarID!' => 'Ingen kalender-ID!',
        'You have no access to this calendar!' => 'Du har ikke tilgang til denne kalenderen!',
        'Error updating the calendar!' => 'Feil under oppdatering av kalenderen!',
        'Couldn\'t read calendar configuration file.' => 'Kunne ikke lese kalenderkonfigurasjonsfilen.',
        'Please make sure your file is valid.' => 'Sørg for at filen din er gyldig.',
        'Could not import the calendar!' => 'Kunne ikke importere kalenderen!',
        'Calendar imported!' => 'Kalender importert!',
        'Need CalendarID!' => 'Trenger CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Kunne ikke hente data for gitt kalender-ID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Vellykket importert %s avtale(r) til kalenderen %s.',
        '+5 minutes' => '+5 minutter',
        '+15 minutes' => '+15 minutter',
        '+30 minutes' => '+30 minutter',
        '+1 hour' => '+1 time\'',
        '+1 day' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Ingen rettigheter',
        'System was unable to import file!' => 'Systemet kunne ikke importere filen!',
        'Please check the log for more information.' => 'Vennligst sjekk loggen for mer informasjon.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Navnet på varselet finnes allerede!',
        'Notification added!' => 'Varsling lagt til!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Det oppsto en feil ved å hente data for varsling med ID:%s!',
        'Unknown Notification %s!' => 'Ukjent varsel %s!',
        '%s (copy)' => '%s (kopi)\'',
        'There was an error creating the Notification' => 'Det oppsto en feil da varselet skulle opprettes',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Varsler kunne ikke importeres på grunn av en ukjent feil, vennligst sjekk OTOBO-loggene for mer informasjon',
        'The following Notifications have been added successfully: %s' =>
            'Følgende varsler er lagt til: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Følgende varsler har blitt oppdatert: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Det var feil ved å legge til/oppdatere følgende varsler: %s. Vennligst sjekk loggfilen for mer informasjon.',
        'Notification updated!' => 'Varsling oppdatert!',
        'Agent (resources), who are selected within the appointment' => 'Agent (ressurser), som velges innenfor avtalen',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Alle agenter med (minst) lesetillatelse for avtalen (kalender)',
        'All agents with write permission for the appointment (calendar)' =>
            'Alle agenter med skrivetillatelse for avtalen (kalender)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'No permission to edit this attachment.' => '',
        'Attachment added!' => 'Vedlegg lagt til!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Autorespons lagt til!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'Ugyldig kommunikasjons-ID!',
        'All communications' => 'All kommunikasjon',
        'Last 1 hour' => 'Siste 1 time',
        'Last 3 hours' => 'Siste 3 timer',
        'Last 6 hours' => 'Siste 6 timer',
        'Last 12 hours' => 'Siste 12 timer',
        'Last 24 hours' => 'Siste 24 timer',
        'Last week' => 'Forrige uke',
        'Last month' => 'Forrige måned',
        'Invalid StartTime: %s!' => 'Ugyldig starttid: %s!',
        'Successful' => 'Vellykket',
        'Processing' => 'Behandling',
        'Invalid Filter: %s!' => 'Ugyldig filter: %s!',
        'Less than a second' => 'Mindre enn et sekund',
        'sorted descending' => 'sortert synkende',
        'sorted ascending' => 'sortert stigende',
        'Trace' => 'Spor',
        'Debug' => 'Feilsøk',
        'Info' => 'Informasjon',
        'Warn' => 'Varsle',
        'days' => 'dager',
        'day' => 'dag',
        'hour' => 'time',
        'minute' => 'minutt',
        'seconds' => 'sekunder',
        'second' => 'sekund',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => 'Ingen kontakt er gitt!',
        'No data found for given contact in given source!' => 'Ingen data funnet for gitt kontakt i gitt kilde!',
        'Contact updated!' => 'Kontakt oppdatert!',
        'No field data found!' => 'Ingen feltdata funnet!',
        'Contact created!' => 'Kontakt opprettet!',
        'Error creating contact!' => 'Feil ved opprettelse av kontakt!',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            'Ingen kilder funnet, minst ett "Kontakt med data" dynamisk felt må legges til systemet!',
        'No data found for given source!' => 'Ingen data funnet for gitt kilde!',

        # Perl Module: Kernel/Modules/AdminCustomerAccept.pm
        'Could not update Privacy Policy!' => 'Kunne ikke oppdatere personvernerklæringen!',
        'Privacy Policy updated!' => 'Personvernerklæring oppdatert!',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Kundebedrift oppdatert!',
        'Dynamic field %s not found!' => 'Dynamisk felt %s ikke funnet!',
        'Unable to set value for dynamic field %s!' => 'Kan ikke angi verdi for dynamisk felt %s!',
        'Customer Company %s already exists!' => 'Kundebedrift %s eksisterer allerede!',
        'Customer company added!' => 'Kundebedrift lagt til!',

        # Perl Module: Kernel/Modules/AdminCustomerDashboardInfoTile.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Startdato bør ikke defineres etter stoppdato!',
        'Name is missing!' => '',
        'Content is missing!' => '',
        'ValidID is missing!' => '',
        'Group is missing!' => '',
        'There was an error creating the info tile entry' => '',
        'Need ID!' => '',
        'This Entry does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Could not get data for ID %s' => '',
        'Info tile entry was added successfully!' => '',
        'Info tile entry was updated successfully!' => '',
        'Session has been killed!' => 'Sesjonen har blitt drept!',
        'All sessions have been killed, except for your own.' => 'Alle økter har blitt drept, bortsett fra dine egne.',
        'There was an error updating the info tile entry' => '',
        'It was not possible to delete the info tile entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Ingen konfigurasjon for \'CustomerGroupPermissionContext\' funnet!',
        'Please check system configuration.' => 'Vennligst sjekk systemkonfigurasjonen.',
        'Invalid permission context configuration:' => 'Ugyldig konfigurasjon av tillatelseskontekst:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Kunde oppdatert!',
        'New phone ticket' => 'Ny telefonsak',
        'New email ticket' => 'Ny e-postsak',
        'Customer %s added' => 'Kunde %s lagt til',
        'Customer user updated!' => 'Kundebruker oppdatert!',
        'Same Customer' => 'Samme kunde',
        'Direct' => 'Direkte',
        'Indirect' => 'Indirekte',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Endre kundebrukerforhold for gruppe',
        'Change Group Relations for Customer User' => 'Endre gruppeforhold for kundebruker',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Tildel kundebrukere til tjeneste',
        'Allocate Services to Customer User' => 'Tildel tjenester til kundebruker',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Feltkonfigurasjonen er ikke gyldig',
        'Objects configuration is not valid' => 'Objektkonfigurasjonen er ikke gyldig',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Kunne ikke tilbakestille Dynamic Field-rekkefølgen riktig, sjekk feilloggen for mer informasjon.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Udefinert delhandling.',
        'Need %s' => 'Trenger %s',
        'Add %s field' => 'Legg til %s felt',
        'The field must be numeric.' => 'Feltet må være numerisk.',
        'The field does not contain only ASCII letters and numbers.' => 'Feltet inneholder ikke bare ASCII-bokstaver og tall.',
        'There is another field with the same name.' => 'Det er et annet felt med samme navn.',
        'Need ValidID' => 'Trenger gyldig ID',
        'Could not create the new field' => 'Kunne ikke opprette det nye feltet',
        'Need ID' => 'Trenger ID',
        'Could not get data for dynamic field %s' => 'Kunne ikke hente data for dynamisk felt %s',
        'Change %s field' => 'Endre %s-feltet',
        'The name for this field should not change.' => 'Navnet på dette feltet skal ikke endres.',
        'Could not update the field %s' => 'Kunne ikke oppdatere feltet %s',
        'Currently' => 'Nåværende',
        'Unchecked' => 'Ikke merket',
        'Checked' => 'Krysset av',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => 'Denne feltnøkkelen er duplisert.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Denne feltverdien er duplisert.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Hindre oppføring av datoer i fremtiden',
        'Prevent entry of dates in the past' => 'Forhindre oppføring av datoer i fortiden',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'Syntax is incorrect. Please provide a parent element name in front of the double colon.' =>
            'Feil i syntaks. Vennligst legg til et foreldreelement foran det doble kolonet.',
        'An element is used as parent element, but not included itself. Please include it.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldLens.pm
        'The referenced dynamic field' => '',
        'Select the dynamic field that references an object' => '',
        'The attribute of the referenced object' => '',
        'Select the attribute dynamic field that references an object' =>
            '',
        'Not a valid dynamic field.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => 'Innstillingene ble lagret.',
        'System was not able to save the setting!' => 'Systemet kunne ikke lagre innstillingen!',
        'Setting is locked by another user!' => 'Innstillingen er låst av en annen bruker!',
        'System was not able to reset the setting!' => 'Systemet kunne ikke tilbakestille innstillingen!',
        'Settings were reset.' => 'Innstillingene ble tilbakestilt.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScript.pm
        'Need valid field driver.' => '',
        'Bad value in RequiredArgs.' => '',
        'Bad value in PreviewTriggers.' => '',
        'Bad value in StorageTriggers.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldSet.pm
        'Missing Dynamic Field.' => '',
        'No valid dynamic field "%s."' => '',
        'The dynamic field type "%s" of dynamic field "%s" can not be used in sets.' =>
            '',
        'The dynamic field "%s" is already in use in a ticket mask.' => '',
        'Misconfigured Grid - need Rows as Array!' => '',
        'Misconfigured Grid - need Columns as integer > 0!' => '',
        'Misconfigured Grid - Rows can\'t be empty!' => '',
        'Misconfigured Grid - Rows must contain entries with key \'DF\'!' =>
            '',
        'Missing Dynamic Field or Grid.' => '',
        'The field must be a valid YAML containing an array of dynamic fields.' =>
            '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Velg minst én mottaker.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minutt(er)',
        'hour(s)' => 'time(r)',
        'Time unit' => 'Tidsenhet',
        'within the last ...' => 'i løpet av de siste ...',
        'within the next ...' => 'i løpet av neste ...',
        'more than ... ago' => 'mer enn ... siden',
        'Unarchived tickets' => 'Aktive saker',
        'archive tickets' => 'arkivsaker',
        'restore tickets from archive' => 'gjenopprette saker fra arkivet',
        'Need Profile!' => 'Trenger profil!',
        'Got no values to check.' => 'Har ingen verdier å sjekke.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Vennligst fjern følgende ord fordi de ikke kan brukes til saksvalget:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Trenger WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Kunne ikke hente data for webtjeneste-ID %s',
        'ascending' => 'stigende',
        'descending' => 'synkende',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Trenger kommunikasjonstype!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Kommunikasjonstypen må være \'Requester\' eller \'Provider\'!',
        'Invalid Subaction!' => 'Ugyldig subaksjon!',
        'Need ErrorHandlingType!' => 'Trenger ErrorHandlingType!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s er ikke registrert',
        'Could not update web service' => 'Kunne ikke oppdatere nettjenesten',
        'Need ErrorHandling' => 'Trenger feilhåndtering',
        'Could not determine config for error handler %s' => 'Kunne ikke bestemme konfigurasjonen for feilbehandler %s',
        'Invoker processing outgoing request data' => 'Invoker behandler utgående forespørselsdata',
        'Mapping outgoing request data' => 'Kartlegging av utgående forespørselsdata',
        'Transport processing request into response' => 'Transportbehandlingsforespørsel til svar',
        'Mapping incoming response data' => 'Kartlegging av innkommende svardata',
        'Invoker processing incoming response data' => 'Invoker behandler innkommende svardata',
        'Transport receiving incoming request data' => 'Transport som mottar innkommende forespørselsdata',
        'Mapping incoming request data' => 'Kartlegging av innkommende forespørselsdata',
        'Operation processing incoming request data' => 'Operasjon som behandler innkommende forespørselsdata',
        'Mapping outgoing response data' => 'Kartlegging av utgående svardata',
        'Transport sending outgoing response data' => 'Transport sender utgående svardata',
        'skip same backend modules only' => 'bare hoppe over de samme backend-modulene',
        'skip all modules' => 'hoppe over alle moduler',
        'Operation deleted' => 'Operasjonen er slettet',
        'Invoker deleted' => 'Invoker slettet',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 sekunder',
        '15 seconds' => '15 sekunder',
        '30 seconds' => '30 sekunder',
        '45 seconds' => '45 sekunder',
        '1 minute' => '1 minutt',
        '2 minutes' => '2 minutter',
        '3 minutes' => '3 minutter',
        '4 minutes' => '4 minutter',
        '5 minutes' => '5 minutter',
        '10 minutes' => '10 minutter',
        '15 minutes' => '15 minutter',
        '30 minutes' => '30 minutter',
        '1 hour' => '1 time',
        '2 hours' => '2 timer',
        '3 hours' => '3 timer',
        '4 hours' => '4 timer',
        '5 hours' => '5 timer',
        '6 hours' => '6 timer',
        '12 hours' => '12 timer',
        '18 hours' => '18 timer',
        '1 day' => '1 dag',
        '2 days' => '2 dager',
        '3 days' => '3 dager',
        '4 days' => '4 dager',
        '6 days' => '6 dager',
        '1 week' => '1 uke',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Kunne ikke bestemme konfigurasjonen for invoker %s',
        'InvokerType %s is not registered' => 'InvokerType %s er ikke registrert',
        'MappingType %s is not registered' => 'MappingType %s er ikke registrert',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Trenger Invoker!',
        'Need Event!' => 'Trenger arrangement!',
        'Could not get registered modules for Invoker' => 'Kunne ikke hente registrerte moduler for Invoker',
        'Could not get backend for Invoker %s' => 'Kunne ikke hente backend for Invoker %s',
        'The event %s is not valid.' => 'Hendelsen %s er ikke gyldig.',
        'Could not update configuration data for WebserviceID %s' => 'Kunne ikke oppdatere konfigurasjonsdata for webtjeneste-ID %s',
        'This sub-action is not valid' => 'Denne underhandlingen er ikke gyldig',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => 'Regexp',
        'Validation Module' => 'Valideringsmodul',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerTicket.pm
        'Invisible only' => 'Kun usynlig',
        'Visible only' => 'Kun synlig',
        'Visible and invisible' => 'Synlig og usynlig',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Enkel kartlegging for utgående data',
        'Simple Mapping for Incoming Data' => 'Enkel kartlegging for innkommende data',
        'Could not get registered configuration for action type %s' => 'Kunne ikke hente registrert konfigurasjon for handlingstypen %s',
        'Could not get backend for %s %s' => 'Kunne ikke hente backend for %s %s',
        'Keep (leave unchanged)' => 'Behold (la uendret)',
        'Ignore (drop key/value pair)' => 'Ignorer (slippnøkkel/verdipar)',
        'Map to (use provided value as default)' => 'Kart til (bruk oppgitt verdi som standard)',
        'Exact value(s)' => 'Nøyaktig verdi(er)',
        'Ignore (drop Value/value pair)' => 'Ignorer (slipp verdi/verdi-par)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'XSLT-kartlegging for utgående data',
        'XSLT Mapping for Incoming Data' => 'XSLT-kartlegging for innkommende data',
        'Could not find required library %s' => 'Kunne ikke finne det nødvendige biblioteket %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Utgående forespørselsdata før behandling (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Utgående forespørselsdata før kartlegging (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Utgående forespørselsdata etter kartlegging (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Innkommende svardata før kartlegging (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Utgående feilhåndteringsdata etter feilhåndtering (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Innkommende forespørselsdata før kartlegging (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Innkommende forespørselsdata etter kartlegging (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Utgående svardata før kartlegging (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Utgående feilhåndteringsdata etter feilhåndtering (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Kunne ikke bestemme konfigurasjonen for operasjon %s',
        'OperationType %s is not registered' => 'Operasjonstype %s er ikke registrert',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Trenger gyldig subaksjon!',
        'This field should be an integer.' => 'Dette feltet skal være et heltall.',
        'File or Directory not found.' => 'Fant ikke filen eller katalogen.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Det finnes en annen nettjeneste med samme navn.',
        'There was an error updating the web service.' => 'Det oppsto en feil under oppdatering av nettjenesten.',
        'There was an error creating the web service.' => 'Det oppsto en feil ved opprettelse av nettjenesten.',
        'Web service "%s" created!' => 'Webtjeneste "%s" er opprettet!',
        'Need Name!' => 'Trenger navn!',
        'Need ExampleWebService!' => 'Trenger EksempelWebService!',
        'Could not load %s.' => 'Kunne ikke laste %s.',
        'Could not read %s!' => 'Kunne ikke lese %s!',
        'Need a file to import!' => 'Trenger en fil for å importere!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Den importerte filen har ikke gyldig YAML-innhold! Vennligst sjekk OTOBO-loggen for detaljer',
        'Web service "%s" deleted!' => 'Webtjeneste "%s" er slettet!',
        'OTOBO as provider' => 'OTOBO som en leverandør',
        'Operations' => 'Handlinger',
        'OTOBO as requester' => 'OTOBO som en etterspørrer',
        'Invokers' => 'Påkallere',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Fikk ingen WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Kunne ikke hente historikkdata for WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Gruppe oppdatert!',

        # Perl Module: Kernel/Modules/AdminImportExport.pm
        'No object backend found!' => '',
        'No format backend found!' => '',
        'Template not found!' => '',
        'Can\'t insert/update template!' => '',
        'Needed TemplateID!' => '',
        'Error occurred. Import impossible! See Syslog for details.' => '',
        'Error occurred. Export impossible! See Syslog for details.' => '',
        'Template List' => '',
        'number' => '',
        'number bigger than zero' => '',
        'integer' => '',
        'integer bigger than zero' => '',
        'Element required, please insert data' => '',
        'Invalid data, please insert a valid %s' => '',
        'Format not found!' => '',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'E-postkonto lagt til!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Henting av e-postkonto er allerede hentet av en annen prosess. Prøv igjen senere!',
        'Dispatching by email To: field.' => 'Utsending etter oppføringer i To:-felt.',
        'Dispatching by selected Queue.' => 'Utsending etter valgt kø.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'No permission to edit this ticket notification.' => '',
        'You need %s permissions!' => 'Du trenger %s tillatelser!',
        'Agent who created the ticket' => 'Agent som opprettet saken',
        'Agent who owns the ticket' => 'Saksbehandleren som eier saken',
        'Agent who is responsible for the ticket' => 'Agenten som er ansvarlig for saken',
        'All agents watching the ticket' => 'Alle saksbehandlere som overvåker saken',
        'All agents with write permission for the ticket' => 'Alle saksbehandlere med skrivetilgang til saken',
        'All agents subscribed to the ticket\'s queue' => 'Alle agenter abonnerte på sakens kø',
        'All agents subscribed to the ticket\'s service' => 'Alle agenter abonnerte på sakens tjeneste',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Alle agenter abonnerte på både sakens kø og service',
        'Customer user of the ticket' => 'Kundebruker av saken',
        'All recipients of the first article' => 'Alle mottakere av den første artikkelen',
        'All recipients of the last article' => 'Alle mottakere av den siste artikkelen',
        'Only send within working hours' => '',
        'Only send outside working hours' => '',
        'Invisible to customer' => 'Usynlig for kunden',
        'Visible to customer' => 'Synlig for kunden',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP-miljøet fungerer ikke. Vennligst sjekk loggen for mer informasjon!',
        'Need param Key to delete!' => 'Trenger param nøkkel for å slette!',
        'Key %s deleted!' => 'Nøkkel %s slettet!',
        'Need param Key to download!' => 'Trenger param nøkkel for å laste ned!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'No such package!' => 'Ingen slik pakke!',
        'No such file %s in package!' => 'Ingen slik fil %s i pakken!',
        'No such file %s in local file system!' => 'Ingen slik fil %s i lokalt filsystem!',
        'Can\'t read %s!' => 'Kan ikke lese %s!',
        'File is OK' => 'Filen er OK',
        'Package has locally modified files.' => 'Pakken har lokalt modifiserte filer.',
        'Package not verified by the OTOBO Team!' => 'Pakken er ikke bekreftet av OTOBO-teamet!',
        'Not Started' => 'Ikke begynt',
        'Updated' => 'Oppdatert',
        'Already up-to-date' => 'Allerede oppdatert',
        'Installed' => 'Installert',
        'Not correctly deployed' => 'Ikke riktig utplassert',
        'Package updated correctly' => 'Pakken er riktig oppdatert',
        'Package was already updated' => 'Pakken er allerede oppdatert',
        'Dependency installed correctly' => 'Dependency installert riktig',
        'The package needs to be reinstalled' => 'Pakken må installeres på nytt',
        'The package contains cyclic dependencies' => 'Pakken inneholder sykliske avhengigheter',
        'Not found in on-line repositories' => 'Ikke funnet i online-depoter',
        'Required version is higher than available' => 'Nødvendig versjon er høyere enn tilgjengelig',
        'Dependencies fail to upgrade or install' => 'Avhengigheter klarer ikke å oppgradere eller installere',
        'Package could not be installed' => 'Pakken kunne ikke installeres',
        'Package could not be upgraded' => 'Pakken kunne ikke oppgraderes',
        'Repository List' => 'Depotliste',
        'No packages found in selected repository. Please check log for more info!' =>
            'Ingen pakker funnet i det valgte depotet. Vennligst sjekk loggen for mer informasjon!',
        'Package not verified due a communication issue with verification server!' =>
            'Pakken er ikke bekreftet på grunn av et kommunikasjonsproblem med verifiseringsserveren!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Kan ikke koble til OTOBO Feature Add-on List server!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Kan ikke hente OTOBO Feature Add-on liste fra serveren!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Kan ikke hente OTOBO Feature Add-on fra serveren!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Ikke noe slikt filter: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioritet lagt til!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Prosessstyringsinformasjon fra databasen er ikke synkronisert med systemkonfigurasjon. Vennligst synkroniser alle prosesser.',
        'Need ExampleProcesses!' => 'Trenger eksempelprosesser!',
        'Need ProcessID!' => 'Trenger prosessID!',
        'Yes (mandatory)' => 'Ja (obligatorisk)',
        'Unknown Process %s!' => 'Ukjent prosess %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Det oppsto en feil under generering av en ny enhets-ID for denne prosessen',
        'The StateEntityID for state Inactive does not exists' => 'StateEntityID for state Inactive eksisterer ikke',
        'There was an error creating the Process' => 'Det oppsto en feil under opprettelsen av prosessen',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for prosessenhet: %s',
        'Could not get data for ProcessID %s' => 'Kunne ikke hente data for prosess-ID %s',
        'There was an error updating the Process' => 'Det oppsto en feil under oppdatering av prosessen',
        'Process: %s could not be deleted' => 'Prosess: %s kunne ikke slettes',
        'There was an error synchronizing the processes.' => 'Det oppsto en feil under synkronisering av prosessene.',
        'The %s:%s is still in use' => '%s:%s er fortsatt i bruk',
        'The %s:%s has a different EntityID' => '%s:%s har en annen enhets-ID',
        'Could not delete %s:%s' => 'Kunne ikke slette %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for %s enhet: %s',
        'Could not get %s' => 'Kunne ikke hente %s',
        'Need %s!' => 'Trenger %s!',
        'Process: %s is not Inactive' => 'Prosess: %s er ikke inaktiv',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Det oppsto en feil under generering av en ny enhets-ID for denne aktiviteten',
        'There was an error creating the Activity' => 'Det oppsto en feil under opprettelsen av aktiviteten',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for aktivitetsenhet: %s',
        'Need ActivityID!' => 'Trenger aktivitets-ID!',
        'Could not get data for ActivityID %s' => 'Kunne ikke hente data for aktivitets-ID %s',
        'There was an error updating the Activity' => 'Det oppsto en feil under oppdatering av aktiviteten',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Manglende parameter: Trenger aktivitet og aktivitetsdialog!',
        'Activity not found!' => 'Finner ikke aktivitet!',
        'ActivityDialog not found!' => 'ActivityDialog ikke funnet!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog er allerede tildelt aktivitet. Du kan ikke legge til en ActivityDialog to ganger!',
        'Error while saving the Activity to the database!' => 'Feil under lagring av aktiviteten i databasen!',
        'This subaction is not valid' => 'Denne underhandlingen er ikke gyldig',
        'Edit Activity "%s"' => 'Rediger aktivitet «%s»',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Det oppsto en feil under generering av en ny EntityID for denne ActivityDialog',
        'There was an error creating the ActivityDialog' => 'Det oppsto en feil ved opprettelse av ActivityDialog',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for ActivityDialog-enheten: %s',
        'Need ActivityDialogID!' => 'Trenger ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Kunne ikke hente data for ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'Det oppsto en feil under oppdatering av ActivityDialog',
        'Edit Activity Dialog "%s"' => 'Rediger aktivitetsdialog "%s"',
        'Agent Interface' => 'Agentgrensesnitt',
        'Customer Interface' => 'Kundegrensesnitt',
        'Agent and Customer Interface' => 'Agent- og kundegrensesnitt',
        'Do not show Field' => 'Ikke vis felt',
        'Show Field' => 'Vis felt',
        'Show Field As Mandatory' => 'Vis felt som obligatorisk',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Rediger bane',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Det oppsto en feil under generering av en ny enhets-ID for denne overgangen',
        'There was an error creating the Transition' => 'Det oppsto en feil da overgangen skulle opprettes',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for overgangsenhet: %s',
        'Need TransitionID!' => 'Trenger TransitionID!',
        'Could not get data for TransitionID %s' => 'Kunne ikke hente data for overgangs-ID %s',
        'There was an error updating the Transition' => 'Det oppsto en feil under oppdatering av overgangen',
        'Edit Transition "%s"' => 'Rediger overgang "%s"',
        'Transition validation module' => 'Overgangsvalideringsmodul',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Minst én gyldig konfigurasjonsparameter kreves.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Det oppsto en feil under generering av en ny enhets-ID for denne overgangshandlingen',
        'There was an error creating the TransitionAction' => 'Det oppsto en feil under opprettelsen av TransitionAction',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Det oppsto en feil ved innstilling av enhetssynkroniseringsstatus for TransitionAction-enheten: %s',
        'Need TransitionActionID!' => 'Trenger TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Kunne ikke hente data for TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'Det oppsto en feil under oppdatering av TransitionAction',
        'Edit Transition Action "%s"' => 'Rediger overgangshandling «%s»',
        'Error: Not all keys seem to have values or vice versa.' => 'Feil: Ikke alle nøkler ser ut til å ha verdier eller omvendt.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Kø oppdatert!',
        'Don\'t use :: in queue name!' => 'Ikke bruk :: i kønavn!',
        'Click back and change it!' => 'Klikk tilbake og endre det!',
        '-none-' => '-ingen-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Køer (uten autosvar)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Endre kørelasjoner for mal',
        'Change Template Relations for Queue' => 'Endre malrelasjoner for kø',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produksjon',
        'Test' => 'Test',
        'Training' => 'Trening',
        'Development' => 'Utvikling',

        # Perl Module: Kernel/Modules/AdminResponseTemplatesStatePreselection.pm
        'Template updated!' => 'Malen er oppdatert!',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rolle oppdatert!',
        'Role added!' => 'Rollen ble lagt til!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Endre rollens koplinger til grupper',
        'Change Role Relations for Group' => 'Endre gruppens koplinger til roller',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rolle',
        'Change Role Relations for Agent' => 'Endre saksbehandlerens kopling til roller',
        'Change Agent Relations for Role' => 'Endre rollens kopling til saksbehandlere',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Vennligst aktiver %s først!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME-miljøet fungerer ikke. Vennligst sjekk loggen for mer informasjon!',
        'Need param Filename to delete!' => 'Trenger param filnavn for å slette!',
        'Need param Filename to download!' => 'Trenger param filnavn for å laste ned!',
        'Needed CertFingerprint and CAFingerprint!' => 'Trengs CertFingerprint og CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint må være annerledes enn CertFingerprint',
        'Relation exists!' => 'Forholdet eksisterer!',
        'Relation added!' => 'Relasjon lagt til!',
        'Impossible to add relation!' => 'Umulig å legge til relasjon!',
        'Relation doesn\'t exists' => 'Forholdet eksisterer ikke',
        'Relation deleted!' => 'Forholdet er slettet!',
        'Impossible to delete relation!' => 'Umulig å slette relasjon!',
        'Certificate %s could not be read!' => 'Sertifikatet %s kunne ikke leses!',
        'Needed Fingerprint' => 'Nødvendig fingeravtrykk',
        'Handle Private Certificate Relations' => 'Håndtere private sertifikatrelasjoner',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Hilsen lagt til!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Signatur oppdatert!',
        'Signature added!' => 'Signatur lagt til!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Status lagt til!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Filen %s kunne ikke leses!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'System e-postadresse lagt til!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Ugyldige innstillinger',
        'There are no invalid settings active at this time.' => 'Det er ingen ugyldige innstillinger aktive for øyeblikket.',
        'You currently don\'t have any favourite settings.' => 'Du har for øyeblikket ingen favorittinnstillinger.',
        'The following settings could not be found: %s' => 'Følgende innstillinger ble ikke funnet: %s',
        'Import not allowed!' => 'Import ikke tillatt!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'Systemkonfigurasjonen kunne ikke importeres på grunn av en ukjent feil, vennligst sjekk OTOBO-loggene for mer informasjon.',
        'Category Search' => 'Kategorisøk',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Noen importerte innstillinger er ikke til stede i den nåværende tilstanden til konfigurasjonen, eller det var ikke mulig å oppdatere dem. Vennligst sjekk OTOBO-loggen for mer informasjon.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            'Denne distribusjonen inneholder ikke endringer i innstillingsverdiene!',
        'No DeploymentID received!' => 'Ingen distribusjons-ID mottatt!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'System was unable to update setting!' => 'Systemet kunne ikke oppdatere innstillingen!',
        'You need to enable the setting before locking!' => 'Du må aktivere innstillingen før du låser!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Du kan ikke jobbe med denne innstillingen fordi %s (%s) jobber med den.',
        'Missing setting name!' => 'Mangler innstillingsnavn!',
        'Missing ResetOptions!' => 'Mangler tilbakestillingsalternativer!',
        'System was not able to lock the setting!' => 'Systemet kunne ikke låse innstillingen!',
        'Missing setting name.' => 'Mangler innstillingsnavn.',
        'Setting not found.' => 'Finner ikke innstillingen.',
        'Missing Settings!' => 'Mangler innstillinger!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => 'Ingen innstillingsnavn mottatt!',
        'Modified Version' => 'Modifisert versjon',
        'Reset To Default' => 'Tilbakestill til standard',
        'Default Version' => 'Standardversjon',
        'No setting name or modified version id received!' => 'Ingen innstillingsnavn eller modifisert versjons-ID mottatt!',
        'Was not possible to revert the historical value!' => 'Var ikke mulig å tilbakeføre den historiske verdien!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => 'Mangler innstillingsnavn eller endret ID!',
        'System was not able to delete the user setting values!' => 'Systemet var ikke i stand til å slette brukerinnstillingsverdiene!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'There was an error creating the System Maintenance' => 'Det oppsto en feil ved opprettelse av systemvedlikehold',
        'Need SystemMaintenanceID!' => 'Trenger systemvedlikeholds-ID!',
        'Could not get data for SystemMaintenanceID %s' => 'Kunne ikke hente data for SystemMaintenance ID %s',
        'System Maintenance was added successfully!' => 'Systemvedlikehold ble lagt til!',
        'System Maintenance was updated successfully!' => 'Systemvedlikehold ble oppdatert!',
        'There was an error updating the System Maintenance' => 'Det oppsto en feil under oppdatering av systemvedlikehold',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Var ikke mulig å slette SystemMaintenance-oppføringen: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'No permission to edit this template.' => '',
        'Template added!' => 'Mal lagt til!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Endre vedleggsrelasjoner for mal',
        'Change Template Relations for Attachment' => 'Endre malrelasjoner for vedlegg',

        # Perl Module: Kernel/Modules/AdminTranslations.pm
        'Translation unmarked for deletion!' => '',
        'Error trying unmark translation for delete!' => '',
        'Translations changed!' => '',
        'No translations were changed!' => '',
        'Errors trying to change translations!' => '',
        'Translations added!' => '',
        'No translations were given to add!' => '',
        'Translation already exists!' => '',
        'Translations deployed successfuly!' => '',
        'Nothing to do!' => '',
        'Errors ocurred when trying to deploy translation. Please check system logs!' =>
            '',
        'All Items' => '',
        'Deployment Results' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Trenger type!',
        'Type added!' => 'Type lagt til!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Saksbehandler oppdatert!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Endre gruppekoplinger for saksbehandler',
        'Change Agent Relations for Group' => 'Endre saksbehandlerkoplinger for gruppe',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Måned',
        'Week' => 'Uke',
        'Day' => 'Dag',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Alle avtaler',
        'Appointments assigned to me' => 'Avtaler tildelt meg',
        'Showing only appointments assigned to you! Change settings' => 'Viser kun avtaler som er tildelt deg! Endre innstillinger',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Finner ikke avtale!',
        'Never' => 'Aldri',
        'Every Day' => 'Hver dag',
        'Every Week' => 'Hver uke',
        'Every Month' => 'Hver måned',
        'Every Year' => 'Hvert år',
        'Custom' => 'Tilpasset',
        'Daily' => 'Daglig',
        'Weekly' => 'Ukentlig',
        'Monthly' => 'Månedlig',
        'Yearly' => 'Årlig',
        'every' => 'hver',
        'for %s time(s)' => '%s gang(er)',
        'until ...' => 'til...',
        'for ... time(s)' => '... gang(er)',
        'until %s' => 'til %s',
        'No notification' => 'Ingen varsling',
        '%s minute(s) before' => '%s minutt(er) før',
        '%s hour(s) before' => '%s time(r) før',
        '%s day(s) before' => '%s dag(er) før',
        '%s week before' => '%s uke(r) før',
        'before the appointment starts' => 'før avtalen begynner',
        'after the appointment has been started' => 'etter at avtalen har begynt',
        'before the appointment ends' => 'før avtalen slutter',
        'after the appointment has been ended' => 'etter at avtalen er slutt',
        'No permission!' => 'Ingen tillatelse!',
        'Cannot delete ticket appointment!' => 'Kan ikke slette saksavtale!',
        'No permissions!' => 'Ingen tillatelser!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s mer\'',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Kundehistorikk',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'Ingen mottakerfelt er gitt!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Ingen slik konfigurasjon for %s',
        'Statistic' => 'Statistikk',
        'No preferences for %s!' => 'Ingen preferanser for %s!',
        'Can\'t get element data of %s!' => 'Kan ikke hente elementdata for %s!',
        'Can\'t get filter content data of %s!' => 'Kan ikke hente filterinnholdsdata for %s!',
        'Customer Name' => 'Kundenavn',
        'Customer User Name' => 'Kundens brukernavn',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Trenger SourceObject og SourceKey!',
        'You need ro permission!' => 'Du trenger ro tillatelse!',
        'Can not delete link with %s!' => 'Kan ikke slette sammenkoblingen med %s!',
        '%s Link(s) deleted successfully.' => '%s kobling(er) ble slettet.',
        'Can not create link with %s! Object already linked as %s.' => 'Kan ikke opprette link med %s! Objektet er allerede koblet som %s.',
        'Can not create link with %s!' => 'Kan ikke opprette sammenkobling med %s!',
        '%s links added successfully.' => '%s lenker ble lagt til.',
        'The object %s cannot link with other object!' => 'Objektet %s kan ikke koble til et annet objekt!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param Group er påkrevd!',
        'This feature is not available.' => 'Denne funksjonen er ikke tilgjengelig.',
        'Updated user preferences' => 'Oppdaterte brukerpreferanser',
        'System was unable to deploy your changes.' => 'Systemet kunne ikke distribuere endringene dine.',
        'Setting not found!' => 'Finner ikke innstillingen!',
        'System was unable to reset the setting!' => 'Systemet kunne ikke tilbakestille innstillingen!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Behandle sak',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parameter %s mangler.',
        'Invalid Subaction.' => 'Ugyldig underhandling.',
        'Statistic could not be imported.' => 'Statistikk kunne ikke bli importert.',
        'Please upload a valid statistic file.' => 'Vennligst last opp en gyldig statistikk fil.',
        'Export: Need StatID!' => 'Eksporter: Trenger StatID!',
        'Delete: Get no StatID!' => 'Slett: Få ingen StatID!',
        'Need StatID!' => 'Trenger StatID!',
        'Could not load stat.' => 'Kunne ikke laste inn statistikk.',
        'Add New Statistic' => 'Legg til ny statistikk',
        'Could not create statistic.' => 'Kunne ikke lage statistikk.',
        'Run: Get no %s!' => 'Kjør: Få ingen %s!',

        # Perl Module: Kernel/Modules/AgentStatisticsReports.pm
        'Got no %s!' => 'Har ingen %s!',
        'Add New Statistics Report' => 'Legg til ny statistikkrapport',
        'This name is already in use, please choose a different one.' => 'Dette navnet er allerede i bruk, velg et annet.',
        'Could not create report.' => 'Kunne ikke opprette rapport.',
        'Need StatsReportID!' => 'Trenger StatsReportID!',
        'Edit Statistics Report' => 'Rediger statistikkrapport',
        'Could not find report.' => 'Kunne ikke finne rapporten.',
        'Please provide a valid cron entry.' => 'Vennligst oppgi en gyldig cron-oppføring.',
        'Could not update report.' => 'Kunne ikke oppdatere rapporten.',
        'View Statistics Report' => 'Se statistikkrapport',
        'Delete: Got no StatsReportID!' => 'Slett: Fikk ingen StatsReportID!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Ingen saks-ID er gitt!',
        'Loading draft failed!' => 'Kunne ikke laste inn utkastet!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Beklager, du må være eier av saken for å utføre denne handlingen.',
        'Please change the owner first.' => 'Vennligst sett eier først.',
        'FormDraft functionality disabled!' => 'FormDraft-funksjonalitet deaktivert!',
        'Draft name is required!' => 'Utkast til navn kreves!',
        'FormDraft name %s is already in use!' => 'FormDraft-navnet %s er allerede i bruk!',
        'Could not perform validation on field %s!' => 'Kunne ikke utføre validering på feltet %s!',
        'No subject' => 'Tomt emne-felt',
        'Could not delete draft!' => 'Kunne ikke slette utkast!',
        'Previous Owner' => 'Forrige eier',
        'wrote' => 'skrev',
        'Message from' => 'Melding fra',
        'End message' => 'Sluttmelding',

        # Perl Module: Kernel/Modules/AgentTicketArticleEdit.pm
        'No ArticleID is given!' => 'Ingen artikkel-ID er gitt!',

        # Perl Module: Kernel/Modules/AgentTicketArticleStatus.pm
        'Can\'t set this Ticket option, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s er nødvendig!',
        'Plain article not found for article %s!' => 'Finner ikke vanlig artikkel for artikkelen %s!',
        'Article does not belong to ticket %s!' => 'Artikkelen tilhører ikke saken %s!',
        'Can\'t bounce email!' => 'Kan ikke returnere e-post!',
        'Can\'t send email!' => 'Kan ikke sende e-post!',
        'Wrong Subaction!' => 'Feil subaksjon!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Kan ikke låse saker, ingen saks-ID er gitt!',
        'Ticket (%s) is not unlocked!' => 'Saken (%s) er ikke låst opp!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Følgende saker ble ignorert fordi de er låst av en annen agent eller du ikke har skrivetilgang til saker: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'Følgende saker ble ignorert fordi den er låst av en annen agent eller du ikke har skrivetilgang til saken: %s.',
        'You need to select at least one ticket.' => 'Du må velge minst én sak.',
        'Bulk feature is not enabled!' => 'Bulk-funksjonen er ikke aktivert!',
        'No selectable TicketID is given!' => 'Ingen valgbar TicketID er gitt!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Du valgte enten ingen saker eller bare saker som er låst av andre agenter.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Følgende saker ble ignorert fordi de er låst av en annen agent eller du ikke har skrivetilgang til disse sakene: %s.',
        'The following tickets were locked: %s.' => 'Følgende saker ble låst: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'Artikkelemnet vil være tomt hvis emnet kun inneholder sakskroken!',
        'Address %s replaced with registered customer address.' => 'Adressen %s er byttet ut med adressen som er registrert på kunde.',
        'Customer user automatically added in Cc.' => 'Kundebrukeren ble automatisk lagt til Kopi-feltet.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Sak «%s» opprettet!',
        'No Subaction!' => 'Ingen subaksjon!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Har ikke saks-ID!',
        'System Error!' => 'Systemfeil!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Neste uke',
        'Ticket Escalation View' => 'Eskaleringsvisning',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Artikkelen %s ble ikke funnet!',
        'Forwarded message from' => 'Videresend meldingen fra',
        'End forwarded message' => 'Avslutt videresendt melding',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Kan ikke vise historikk, ingen TicketID er gitt!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Kan ikke låse sak, ingen saks-ID er gitt!',
        'Sorry, the current owner is %s!' => 'Beklager, den nåværende eieren er %s!',
        'Please become the owner first.' => 'Vennligst bli eier først.',
        'Ticket (ID=%s) is locked by %s!' => 'Sak (ID=%s) er låst av %s!',
        'Change the owner!' => 'Bytt eier!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nytt innlegg',
        'Pending' => 'Satt på vent',
        'Reminder Reached' => 'Påminnelse nådd',
        'My Locked Tickets' => 'Mine låste saker',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Kan ikke slå sammen sak med seg selv!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Du trenger flyttetillatelser!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat er ikke aktiv.',
        'No permission.' => 'Ingen tillatelse.',
        '%s has left the chat.' => '%s har gått ut av chatten.',
        'This chat has been closed and will be removed in %s hours.' => 'Denne chatten er stengt og vil bli fjernet om %s timer.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Saken er låst.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Ingen artikkel-ID!',
        'This is not an email article.' => 'Dette er ikke en e-postartikkel.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Kan ikke lese vanlig artikkel! Kanskje det ikke er noen vanlig e-post i backend! Les backend-meldingen.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Trenger saks-ID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Kunne ikke hente ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'Ingen prosess konfigurert!',
        'The selected process is invalid!' => 'Valgt prosess er ikke gyldig!',
        'Process %s is invalid!' => 'Prosessen %s er ugyldig!',
        'Subaction is invalid!' => 'Subaksjonen er ugyldig!',
        'Parameter %s is missing in %s.' => 'Parameter %s mangler i %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Ingen ActivityDialog konfigurert for %s i _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Fikk ingen Start ActivityEntityID eller Start ActivityDialogEntityID for prosess: %s i _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Kunne ikke få sak for TicketID: %s i _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Kunne ikke fastslå ActivityEntityID. DynamicField eller Config er ikke riktig satt!',
        'Process::Default%s Config Value missing!' => 'Process::Standard%s konfigurasjonsverdi mangler!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Fikk ingen ProcessEntityID eller TicketID og ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Kan ikke hente StartActivityDialog og StartActivityDialog for ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Kan ikke få sak "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Kan ikke få ProcessEntityID eller ActivityEntityID for saken "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Kan ikke hente aktivitetskonfigurasjon for ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Kan ikke få ActivityDialog-konfigurasjon for ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Kan ikke hente data for feltet "%s" i ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime kan bare brukes hvis State eller StateID er konfigurert for samme ActivityDialog. ActivityDialog: %s!',
        'Pending Date' => 'Utsatt til',
        'for pending* states' => 'for vente-tilstander',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID mangler!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Kunne ikke hente Config for ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => 'Kunne ikke bruke kunde-ID som et usynlig felt.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Mangler ProcessEntityID, sjekk ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Ingen StartActivityDialog eller StartActivityDialog for prosess "%s" er konfigurert!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Kunne ikke opprette sak for prosess med ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Kunne ikke angi ProcessEntityID "%s" på TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Kunne ikke angi ActivityEntityID "%s" på TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Kunne ikke lagre ActivityDialog, ugyldig saks-ID: %s!',
        'Invalid TicketID: %s!' => 'Ugyldig saks-ID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Mangler ActivityEntityID i sak %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Dette trinnet tilhører ikke lenger den gjeldende aktiviteten som er i gang for saken \'%s%s%s\'! En annen bruker endret denne saken i mellomtiden. Lukk dette vinduet og last inn saken på nytt.',
        'Missing ProcessEntityID in Ticket %s!' => 'Mangler ProcessEntityID i sak %s!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Kunne ikke angi PendingTime for sak med ID "%s" i ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Feil ActivityDialog Feltkonfigurasjon: %s kan ikke være Vis => 1 / Vis felt (Vennligst endre konfigurasjonen til å være Vis => 0 / Ikke vis felt eller Vis => 2 / Vis felt som obligatorisk)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Kunne ikke angi %s for sak med ID "%s" i ActivityDialog "%s"!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Kunne ikke angi DynamicField-verdi for %s av sak med ID "%s" i ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Standardkonfigurasjon for Process::Standard%s mangler!',
        'Default Config for Process::Default%s invalid!' => 'Standardkonfigurasjon for Process::Default%s ugyldig!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Tilgjengelige saker',
        'including subqueues' => 'Inkluderer underkøer',
        'excluding subqueues' => 'Ekskluderer underkøer',
        'QueueView' => 'Køer',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Saker jeg er ansvarlig for',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'siste søk',
        'Untitled' => 'Uten navn',
        'Ticket Number' => 'Saksnummer',
        'Ticket' => 'Sak',
        'printed by' => 'skrevet ut av',
        'CustomerID (complex search)' => 'Kunde-ID (komplekst søk)',
        'CustomerID (exact match)' => 'Kunde-ID (eksakt samsvar)',
        'Invalid Users' => 'Ugyldige brukere',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'i mer enn ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Funksjonen er ikke aktivert!',
        'Service View' => 'Visning av Tjenester',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Statusvisning',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mine overvåkede saker',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Funksjonen er ikke aktiv',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Link slettet',
        'Ticket Locked' => 'Saken er låst',
        'Pending Time Set' => 'Ventende tid satt',
        'Dynamic Field Updated' => 'Dynamisk felt oppdatert',
        'Outgoing Email (internal)' => 'Utgående epost (intern)',
        'Ticket Created' => 'Sak opprettet',
        'Type Updated' => 'Type Oppdatert',
        'Escalation Update Time In Effect' => 'Tidspunkt for eskalering oppdatering',
        'Escalation Update Time Stopped' => 'Eskalering Oppdateringstid stoppet',
        'Escalation First Response Time Stopped' => 'Eskalering Første responstid stoppet',
        'Customer Updated' => 'Kunde oppdatert',
        'Internal Chat' => 'Intern chat',
        'Automatic Follow-Up Sent' => 'Automatisk oppfølging sendt',
        'Note Added' => 'Merknad lagt til',
        'Note Added (Customer)' => 'Merknad lagt til (kunde)',
        'SMS Added' => 'SMS lagt til',
        'SMS Added (Customer)' => 'SMS lagt til (kunde)',
        'State Updated' => 'Status oppdatert',
        'Outgoing Answer' => 'Utgående svar',
        'Service Updated' => 'Tjenesten er oppdatert',
        'Link Added' => 'Link lagt til',
        'Incoming Customer Email' => 'Innkommende kunde-epost',
        'Incoming Web Request' => 'Innkommende webhenvendelse',
        'Priority Updated' => 'Prioritet oppdatert',
        'Ticket Unlocked' => 'Saken er ulåst',
        'Outgoing Email' => 'Utgående epost',
        'Title Updated' => 'Tittel oppdatert',
        'Ticket Merged' => 'Sak slått sammen',
        'Outgoing Phone Call' => 'Utgående telefonsamtale',
        'Forwarded Message' => 'Videresendt melding',
        'Removed User Subscription' => 'Fjernet brukerabonnement',
        'Time Accounted' => 'Tidsregning',
        'Incoming Phone Call' => 'Innkommende telefonsamtale',
        'System Request.' => 'Systemforespørsel.',
        'Incoming Follow-Up' => 'Innkommende oppfølging',
        'Automatic Reply Sent' => 'Automatisk svar sendt',
        'Automatic Reject Sent' => 'Automatisk avvisning sendt',
        'Escalation Solution Time In Effect' => 'Eskaleringsløsning Tid i kraft',
        'Escalation Solution Time Stopped' => 'Eskalering Løsning Tid stoppet',
        'Escalation Response Time In Effect' => 'Eskaleringsresponstid i kraft',
        'Escalation Response Time Stopped' => 'Eskalering Responstid stoppet',
        'SLA Updated' => 'SLA oppdatert',
        'External Chat' => 'Ekstern chat',
        'Queue Changed' => 'Kø endret',
        'Notification Was Sent' => 'Varsel ble sendt',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Denne saken eksisterer ikke, eller du har ikke tillatelse til å få tilgang til den i gjeldende tilstand.',
        'Missing FormDraftID!' => 'Mangler FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'Kan ikke få ArtikkelID %s!',
        'Article filter settings were saved.' => 'Innstillinger for artikkelfilter ble lagret.',
        'Event type filter settings were saved.' => 'Filterinnstillinger for hendelsestype ble lagret.',
        'Forward article via mail' => 'Videresend artikkelen via e-post',
        'Forward' => 'Videresend',
        'Fields with no group' => 'Felter uten gruppe',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Artikkelen kunne ikke åpnes! Kanskje det er på en annen artikkelside?',
        'Show one article' => 'Vis ett innlegg',
        'Show all articles' => 'Vis alle innlegg',
        'Show Ticket Timeline View' => 'Vis sakstidslinjevisning',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'Har ingen FormID.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Feil: filen kunne ikke slettes på riktig måte. Ta kontakt med administratoren din (mangler fil-ID).',

        # Perl Module: Kernel/Modules/CustomerDashboardCommon.pm
        'Registration for tile %s of CustomerDashboard is invalid! Either Module or Template needed.' =>
            'Registrering for flis %s av CustomerDashboard er ugyldig! Enten modul eller mal er nødvendig.',
        'Registration for tile %s of CustomerDashboard is invalid! Order needs to be a unique number.' =>
            'Registrering for flis %s av CustomerDashboard er ugyldig! Bestillingen må være et unikt nummer.',

        # Perl Module: Kernel/Modules/CustomerGenericContent.pm
        'Need Key!' => 'Trenger nøkkel!',
        'Invalid Key!' => 'Ugyldig nøkkel!',
        'Failed to load Content!' => 'Kunne ikke laste inn innhold!',
        'Destination unknown.' => 'Ukjent destinasjon.',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'ArtikkelID er nødvendig!',
        'No TicketID for ArticleID (%s)!' => 'Ingen TicketID for ArticleID (%s)!',
        'HTML body attachment is missing!' => 'HTML-tekstvedlegg mangler!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID og ArticleID er nødvendig!',
        'No such attachment (%s)!' => 'Ikke noe slikt vedlegg (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Sjekk SysConfig-innstillingen for %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Sjekk SysConfig-innstillingen for %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'Du har ikke tilstrekkelige tillatelser for å opprette sak i standardkøen.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Trenger kundeID!',
        'My Tickets' => 'Mine saker',
        'Company Tickets' => 'Bedriftsaker',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Kundens navn',
        'Created within the last' => 'Opprettet i løpet av de siste',
        'Created more than ... ago' => 'Opprettet mer enn ... siden',
        'Please remove the following words because they cannot be used for the search:' =>
            'Vennligst fjern følgende ord fordi de ikke kan brukes for søket:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Could not load process module.' => 'Kunne ikke laste inn prosessmodulen.',
        'Can\'t reopen ticket, not possible in this queue!' => 'Kan ikke gjenåpne sak, ikke mulig i denne køen!',
        'Create a new ticket!' => 'Opprett en ny sak!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode aktiv!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Hvis du vil kjøre installasjonsprogrammet på nytt, deaktiver SecureMode i SysConfig.',
        'Directory "%s" doesn\'t exist!' => 'Katalog "%s" eksisterer ikke!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Konfigurer "Hjem" i Kernel/Config.pm først!',
        'File "%s/Kernel/Config.pm" not found!' => 'Filen "%s/Kernel/Config.pm" ble ikke funnet!',
        'Directory "%s" not found!' => 'Katalog "%s" ikke funnet!',
        'Install OTOBO' => 'Installer OTOBO',
        'Intro' => 'Introduksjon',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm er ikke skrivbar!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Hvis du ønsker å bruke installasjonsprogrammet, sett inn Kernel/Config.pm skrivbar for nettserverbrukeren!',
        'Database Selection' => 'Databasevalg',
        'Unknown Check!' => 'Ukjent sjekk!',
        'The check "%s" doesn\'t exist!' => 'Sjekken "%s" eksisterer ikke!',
        'Enter the password for the database user.' => 'Skriv inn passordet for databasebrukeren.',
        'Configure MySQL' => 'Konfigurer MySQL',
        'Database %s' => 'Database %s',
        'Enter the password for the administrative database user.' => 'Skriv inn passordet for administrator-databasebrukeren.',
        'Configure PostgreSQL' => 'Konfigurer PostgreSQL',
        'Configure Oracle' => 'Konfigurer Oracle',
        'Unknown database type "%s".' => 'Ukjent databasetype "%s".',
        'Please go back.' => 'Vennligst gå tilbake.',
        'Create Database' => 'Opprett database',
        'Install OTOBO - Error' => 'Installer OTOBO - Feil',
        'File "%s/%s.xml" not found!' => 'Filen "%s/%s.xml" ble ikke funnet!',
        'Contact your Admin!' => 'Kontakt din administrator!',
        'Execution of SQL statement failed: ' => 'Utførelse av SQL-setning mislyktes: ',
        'https' => 'https',
        'http' => 'http',
        'System Settings' => 'Systeminnstillinger',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'Konfigurer e-post',
        'Mail Configuration' => 'E-postoppsett',
        'Unknown Subaction %s!' => 'Ukjent subaksjon %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Kan ikke koble til databasen, Perl-modul DBD::%s er ikke installert!',
        'Can\'t connect to database, read comment!' => 'Kan ikke koble til databasen, les kommentar!',
        'Database already contains data - it should be empty!' => 'Databasen inneholder allerede data - den må være tom!',
        'Error: database version requirement not satisfied. Have version: %s Want version: %s' =>
            '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Feil: Sørg for at databasen din aksepterer pakker over %s MB i størrelse (den godtar for øyeblikket bare pakker opptil %s MB). Vennligst tilpass max_allowed_packet-innstillingen for databasen for å unngå feil.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Feil: Sett verdien for innodb_log_file_size på databasen din til minst %s MB (gjeldende: %s MB, anbefalt: %s MB). For mer informasjon, vennligst ta en titt på %s.',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            'Hvis du vil kjøre MigrateFromOTRS-verktøyet på nytt, deaktiverer du SecureMode i SysConfig.',
        'OTRS to OTOBO migration' => 'OTRS til OTOBO migrering',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Ingen %s!',
        'No such user!' => 'Ingen slik bruker!',
        'Invalid calendar!' => 'Ugyldig kalender!',
        'Invalid URL!' => 'Ugyldig URL!',
        'There was an error exporting the calendar!' => 'Det oppsto en feil ved eksport av kalenderen!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Trenger config Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Autentisering mislyktes fra %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleDelete.pm
        'Delete this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleEdit.pm
        'Edit this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleRestore.pm
        'Restore this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Send artikkelen tilbake til en annen e-postadresse',
        'Bounce' => 'Oversend',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Svar Alle',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Send denne artikkelen på nytt',
        'Resend' => 'Send på nytt',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Se meldingsloggdetaljer for denne artikkelen',
        'Message Log' => 'Meldingslogg',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Besvar notis',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Skill ut denne artikkelen',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Se kilden til denne artikkelen',
        'Plain Format' => 'Kildetekst',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Skriv ut denne artikkelen',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at hello@otobo.io' => 'Kontakt oss på hello@otobo.io',
        'Get Help' => 'Få hjelp',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkArticleSeenUnseen.pm
        'Mark article as unseen' => '',
        'Mark as unseen' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Merk',
        'Unmark' => 'Fjern merking',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Installer pakken på nytt',
        'Re-install' => 'Installer på nytt',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Kryptert',
        'Sent message encrypted to recipient!' => 'Sendt melding kryptert til mottaker!',
        'Signed' => 'Signert',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" header funnet, men ugyldig!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        'Internal error during verification!' => 'Intern feil under verifisering!',
        'Impossible to decrypt: private key not found!' => 'Umulig å dekryptere: privat nøkkel ikke funnet!',
        'Impossible to decrypt: private key for email was not found!' => 'Umulig å dekryptere: privat nøkkel for e-post ble ikke funnet!',
        'Successful decryption' => 'Vellykket dekryptering',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Det er ingen krypteringsnøkler tilgjengelig for adressene: \'%s\'. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Det er ingen valgte krypteringsnøkler for adressene: \'%s\'. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Kan ikke bruke utløpte krypteringsnøkler for adressene: \'%s\'. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Kan ikke bruke tilbakekalte krypteringsnøkler for adressene: \'%s\'. ',
        'Encrypt' => 'Krypter',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Nøkler/sertifikater vil kun vises for mottakere med mer enn én nøkkel/sertifikat. Den først funnet nøkkelen/sertifikatet vil bli forhåndsvalgt. Sørg for å velge riktig.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'E-postsikkerhet',
        'PGP sign' => 'PGP-tegn',
        'PGP sign and encrypt' => 'PGP signere og kryptere',
        'PGP encrypt' => 'PGP-kryptering',
        'SMIME sign' => 'SMIME-skilt',
        'SMIME sign and encrypt' => 'SMIME signer og krypter',
        'SMIME encrypt' => 'SMIME krypter',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Kan ikke bruke utløpt signeringsnøkkel: \'%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'Kan ikke bruke tilbakekalt signeringsnøkkel: \'%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Det er ingen signeringsnøkler tilgjengelig for adressene \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Det er ingen valgte signeringsnøkler for adressene \'%s\'.',
        'Sign' => 'Signer',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Nøkler/sertifikater vil kun vises for en avsender med mer enn én nøkkel/sertifikat. Den først funnet nøkkelen/sertifikatet vil bli forhåndsvalgt. Sørg for å velge riktig.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Vist',
        'Refresh (minutes)' => 'Oppfrisk (minutter)',
        'off' => 'av',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Vist kunde-ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Vis kunde-bruker',
        'Offline' => 'Frakoblet',
        'User is currently offline.' => 'Brukeren er for øyeblikket frakoblet.',
        'User is currently active.' => 'Brukeren er aktiv for øyeblikket.',
        'Away' => 'Borte',
        'User was inactive for a while.' => 'Brukeren var inaktiv en stund.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Starttidspunktet for en sak er satt etter slutttiden!',

        # Perl Module: Kernel/Output/HTML/Dashboard/MyLastChangedTickets.pm
        'Shown Tickets' => 'Viste saker',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Kan ikke koble til OTOBO News server!',
        'Can\'t get OTOBO News from server!' => 'Kan ikke hente OTOBO News fra serveren!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Kan ikke koble til produktnyhetsserveren!',
        'Can\'t get Product News from server!' => 'Kan ikke få produktnyheter fra serveren!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Kan ikke koble til %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Columns' => 'Vis kolonner',
        'filter not active' => 'filter ikke aktivt',
        'filter active' => 'filter aktivt',
        'This ticket has no title or subject' => 'Denne saken har ingen tittel eller emne',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7-dagers statistikk',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Brukeren satte statusen sin til utilgjengelig.',
        'Unavailable' => 'Utilgjengelig',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => 'Følgende saker er ikke oppdatert: %s.',
        'h' => 't',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Denne saken eksisterer ikke, eller du har ikke tillatelse til å få tilgang til den i gjeldende tilstand. Du kan utføre en av følgende handlinger:',
        'Year' => 'År',
        'Hours' => 'Timer',
        'Minutes' => 'Minutter',
        'Check to activate this date' => 'Kryss av for å aktivere denne datoen',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Ingen rettigheter!',
        'No Permission' => 'Ingen tillatelse',
        'Show Tree Selection' => 'Vis Trestruktur',
        'Split Quote' => 'Split sitat',
        'Remove Quote' => 'Fjern sitat',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Sammenkoblet som',
        'Search Result' => 'Søkeresultat',
        'Linked' => 'Koblet',
        'Bulk' => 'Masseendring',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Enkel',
        'Unread article(s) available' => 'Uleste artikler tilgjengelig',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Avtale',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Arkivsøk',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Pålogget agent: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Det er flere eskalerte saker!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Velg en tidssone i innstillingene dine og bekreft den ved å klikke på lagre-knappen.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Pålogget kunde: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Systemvedlikehold er aktivt!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'En systemvedlikeholdsperiode starter på: %s og forventes å stoppe på: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO tjenesten kjører ikke.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Du har fraværassistenten aktivert, vil du så den av?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Du har %s ugyldig(e) innstilling(er) distribuert. Klikk her for å vise ugyldige innstillinger.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Du har ikke-distribuerte innstillinger, vil du distribuere dem?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Konfigurasjonen oppdateres, vær tålmodig...',
        'There is an error updating the system configuration!' => 'Det er en feil under oppdatering av systemkonfigurasjonen!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Ikke bruk Superbruker-kontoen til å jobbe med %s! Opprett nye agenter og arbeid med disse kontoene i stedet.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Sørg for at du har valgt minst én transportmetode for obligatoriske varsler.',
        'Preferences updated successfully!' => 'Innstillinger lagret!',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Vennligst spesifiser en sluttdato som er etter startdatoen.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Gjenta passord',
        'The current password is not correct. Please try again!' => 'Nåværende passord er ikke korrekt. Prøv igjen!',
        'Please supply your new password!' => 'Vennligst oppgi ditt nye passord!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            'Kan ikke oppdatere passordet, det nye passordet og det gjentatte passordet stemmer ikke overens.',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Dette passordet er forbudt av gjeldende systemkonfigurasjon. Ta kontakt med administratoren hvis du har flere spørsmål.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan ikke oppdatere passordet, det må være minst %s tegn langt!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Kan ikke oppdatere passordet, det må inneholde minst 2 små og 2 store bokstaver!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan ikke oppdatere passordet, det må inneholde minst ett tall!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Kan ikke oppdatere passordet, det må inneholde minst 2 bokstaver!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            'Kan ikke oppdatere passord, det må inneholde minst 3 av 4 (nedre tegn, øvre tegn, siffer, spesialtegn)!',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Tidssonen ble oppdatert!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'ugyldig',
        'valid' => 'gyldig',
        'No (not supported)' => 'Ingen (Ikke støttet)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Ingen tidligere fullført eller gjeldende+kommende fullstendig relativ tidsverdi er valgt.',
        'The selected time period is larger than the allowed time period.' =>
            'Den valgte tidsperioden er større enn den tillatte tidsperioden.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Ingen tidsskalaverdi tilgjengelig for gjeldende valgte tidsskalaverdi på X-aksen.',
        'The selected date is not valid.' => 'Den valgte datoen er ikke gyldig.',
        'The selected end time is before the start time.' => 'Den valgte slutt tidspunktet er før start tidspunktet.',
        'There is something wrong with your time selection.' => 'Det er noe galt med dine valg av tid.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Vennligst velg bare ett element eller tillat endring ved statistikkgenerering.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Vennligst velg minst én verdi i dette feltet eller tillat endring ved statistikkgenerering.',
        'Please select one element for the X-axis.' => 'Vennligst ett element for X-aksen.',
        'You can only use one time element for the Y axis.' => 'Du kan bare bruke et tidselement for Y-aksen.',
        'You can only use one or two elements for the Y axis.' => 'Du kan bare bruke en eller to elementer for Y-aksen.',
        'Please select at least one value of this field.' => 'Vennligst velg minst en verdi for dette feltet.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Oppgi en verdi eller tillat endring ved statistikkgenerering.',
        'Please select a time scale.' => 'Vennligst velg en tidsskala.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Rapporteringstidsintervallet ditt er for lite. Bruk en større tidsskala.',
        'second(s)' => 'sekund(er)',
        'quarter(s)' => 'kvartal(er)',
        'half-year(s)' => 'halvår(lig)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Vennligst fjern følgende ord fordi de ikke kan brukes for saksrestriksjonene: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Avbryt redigering og lås opp denne innstillingen',
        'Reset this setting to its default value.' => 'Tilbakestill denne innstillingen til standardverdien.',
        'Unable to load %s!' => 'Kan ikke laste %s!',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Frigi sak til køen',
        'Lock it to work on it' => 'Lås sak for å arbeide med den',

        # Perl Module: Kernel/Output/HTML/TicketMenu/ShowHideDeletedArticles.pm
        'Hide deleted articles' => '',
        'Click to hide deleted articles' => '',
        'Show deleted articles' => '',
        'Click to show deleted articles' => '',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Ikke overvåk',
        'Remove from list of watched tickets' => 'Fjern fra listen over overvåkede saker',
        'Watch' => 'Overvåk',
        'Add to list of watched tickets' => 'Legg til i listen over overvåkede saker',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sorter etter',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nye saker under behandling',
        'Locked Tickets Reminder Reached' => 'Antall saker med påminnelser',
        'Locked Tickets Total' => 'Totalt antall saker under behandling',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nye saker du er ansvarlig for',
        'Responsible Tickets Reminder Reached' => 'Saker du er ansvarlig for med påminnelser',
        'Responsible Tickets Total' => 'Totalt antall saker du er ansvarlig for',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Nye overvåkede saker',
        'Watched Tickets Reminder Reached' => 'Overvåkede saker med påminnelser',
        'Watched Tickets Total' => 'Totalt antall overvåkede saker',

        # Perl Module: Kernel/Output/PDF/StatisticsReports.pm
        '%s Report' => '%s rapport',
        'Error: this graph could not be generated: %s.' => 'Feil: denne grafen kunne ikke genereres: %s.',
        'Table of Contents' => 'Innholdsfortegnelse',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Dynamiske felt for saker',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Kunne ikke lese ACL-konfigurasjonsfilen. Kontroller at filen er gyldig.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Det er for tiden ikke mulig å logge inn på grunn et planlagt vedlikehold.',

        # Perl Module: Kernel/System/Auth/OpenIDConnect.pm
        'Authentication error. Please contact the administrator.' => 'Feil med autentisering. Vennligst kontakt administrator.',
        'Authentication error.' => 'Feil med autentisering.',
        'Invalid response from the authentication server. Maybe the process took too long. Please retry once.' =>
            'Ugyldig svar fra autentiseringsserveren. Kanskje prosessen tok for lang tid. Prøv igjen én gang.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Please note that the session limit is almost reached.' => 'Vær oppmerksom på at øktgrensen er nesten nådd.',
        'Session limit reached! Please try again later.' => 'Grensen for total antall sesjoner er nådd. Vennligst prøv igjen senere.',
        'Session per user limit reached!' => 'Økt per brukergrense nådd!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sesjonen er ugyldig. Vennligst logg inn igjen.',
        'Session has timed out. Please log in again.' => 'Sesjonen har gått ut på tid. Vennligst logg inn igjen.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Kun PGP-tegn',
        'PGP encrypt only' => 'PGP-kryptering kun',
        'SMIME sign only' => 'Kun SMIME-skilt',
        'SMIME encrypt only' => 'SMIME krypter bare',
        'PGP and SMIME not enabled.' => 'PGP og SMIME er ikke aktivert.',
        'Skip notification delivery' => 'Hopp over levering av varsler',
        'Send unsigned notification' => 'Send usignert varsel',
        'Send unencrypted notification' => 'Send ukryptert varsling',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referanse for konfigurasjonsalternativer',
        'This setting can not be changed.' => 'Denne innstillingen kan ikke endres.',
        'This setting is not active by default.' => 'Denne innstillingen er ikke aktiv som standard.',
        'This setting can not be deactivated.' => 'Denne innstillingen kan ikke deaktiveres.',
        'This setting is not visible.' => 'Denne innstillingen er ikke synlig.',
        'This setting can be overridden in the user preferences.' => 'Denne innstillingen kan overstyres i brukerinnstillingene.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Denne innstillingen kan overstyres i brukerpreferansene, men er ikke aktiv som standard.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Kundebruker "%s" eksisterer allerede.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Denne e-postadressen er allerede i bruk for en annen kundebruker.',

        # Perl Module: Kernel/System/DynamicField/Driver/Agent.pm
        'Group of the agents' => '',
        'Select the group of the agents' => '',
        'External-source key' => '',
        'When set via an external source (e.g. web service or import / export), the value will be interpreted as this attribute.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'før/etter',
        'between' => 'mellom',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseReference.pm
        'e.g. Text or Te*t' => 'f.eks. Tekst eller Te*t',
        'Referenced object type' => '',
        'Select the type of the referenced object' => '',
        'Input mode of edit field' => '',
        'Select the input mode for the edit field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Ignorer dette feltet.',

        # Perl Module: Kernel/System/DynamicField/Driver/CustomerCompany.pm
        'Attribute which will be searched on autocomplete' => '',
        'Select the attribute which customer companies will be searched by' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/RichText.pm
        'This field is required or' => 'Dette feltet er obligatorisk eller',
        'The field content is too long!' => 'Innholdet i feltet er for langt!',
        'Maximum size is %s characters.' => 'Maksimal lengde er %s tegn.',
        'Full %s Text' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Ticket.pm
        'Queue of the ticket' => '',
        'Select the queue of the ticket' => '',
        'Type of the ticket' => '',
        'Select the type of the ticket' => '',
        'Select the attribute which tickets will be searched by' => '',
        'Attribute which is displayed for values' => '',
        'Select the type of display' => '',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
        'Column Separator' => 'Kolonneseparator',
        'Tabulator (TAB)' => 'Tabulator (TAB)',
        'Semicolon (;)' => 'Semikolon (;)',
        'Colon (:)' => 'Kolon (:)',
        'Dot (.)' => 'Punktum (.)',
        'Comma (,)' => '',
        'Charset' => 'Tegnsett',
        'Include Column Headers' => 'Inkluder kolonneoverskrifter',
        'Column' => 'Kolonne',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/JSON.pm
        'Pretty print the exported concatenated JSON' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/CloneDB/Backend.pm
        'Sanity checks for database.' => 'Sanitetssjekker for database.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => 'Distribuer ACL-konfigurasjonen.',
        'Deployment completed, perfect!' => 'Utrullingen fullført, perfekt!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => 'Migrer databasetabell auto_responses.',
        'Migration failed.' => 'Migrering mislyktes.',
        'Migrate database table auto_response.' => 'Migrer databasetabell auto_response.',
        'Migration completed, perfect!' => 'Migrering fullført, perfekt!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => 'OTOBO Cache-opprydding.',
        'Completed.' => 'Fullført.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Need OTRSData->%s!' => 'Trenger OTRSData->%s!',
        'Can\'t access OTRS Home: %s!' => 'Får ikke tilgang til OTRS-hjemmesiden: %s!',
        'All needed files copied and migrated, perfect!' => 'Alle nødvendige filer kopiert og migrert, perfekt!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Copy database.' => 'Kopier database.',
        'Skipped...' => 'Hoppet over...',
        'System was unable to connect to OTRS database.' => 'Systemet kunne ikke koble til OTRS-databasen.',
        'System was unable to complete data transfer.' => 'Systemet kunne ikke fullføre dataoverføringen.',
        'Data transfer completed.' => 'Dataoverføring fullført.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO version is correct.' => 'Sjekk om OTOBO-versjonen er riktig.',
        'Check if OTOBO and OTRS connect is possible.' => 'Sjekk om OTOBO og OTRS-tilkobling er mulig.',
        'Can\'t open RELEASE file from OTRSHome: %s!' => 'Kan ikke åpne RELEASE-filen fra OTRSHome: %s!',
        'Check if OTOBO and OTRS version is correct.' => 'Sjekk om OTOBO- og OTRS-versjonen er riktig.',
        '%s does not exist!' => '%s eksisterer ikke!',
        'No OTOBO system found!' => 'Ingen OTOBO-system funnet!',
        'You are trying to run this script on the wrong framework version %s!' =>
            'Du prøver å kjøre dette skriptet på feil rammeversjon %s!',
        'OTOBO Version is correct: %s.' => 'OTOBO-versjonen er riktig: %s.',
        'Check if OTRS version is correct.' => 'Sjekk om OTRS-versjonen er riktig.',
        'OTRS RELEASE file %s does not exist!' => 'OTRS RELEASE-filen %s eksisterer ikke!',
        'Can\'t read OTRS RELEASE file: %s' => 'Kan ikke lese OTRS RELEASE-fil: %s',
        'No OTRS system found!' => 'Ingen OTRS-system funnet!',
        'Unknown PRODUCT found in OTRS RELASE file: %s. Expected values are %s.' =>
            'Ukjent PRODUKT funnet i OTRS RELASE-fil: %s. Forventede verdier er %s.',
        'OTRS Version is correct: %s.' => 'OTRS-versjonen er riktig: %s.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOItsmTablesMigrate.pm
        'Migrate ITSM database tables.' => 'Migrer ITSM-databasetabeller.',
        'Nothing to do, as the the table \'%s\' does not exist.' => 'Ingenting å gjøre, siden tabellen \'%s\' ikke eksisterer.',
        'UPDATE of the table \'%s\' failed.' => 'OPPDATERING av tabellen \'%s\' mislyktes.',
        'Migration completed.' => 'Migrering fullført.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => 'Migrer konfigurasjonsinnstillinger.',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            'Det oppstod en feil under SysConfig-datamigrering eller ingen konfigurasjon eksisterer.',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            'Det oppstod en feil under SysConfig-migrering ved skriving av XML til DB.',
        'SysConfig data migration completed.' => 'SysConfig-datamigrering fullført.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => 'Migrer nettjenestekonfigurasjon.',
        'Failed - see the log!' => 'Mislyktes - se loggen!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => 'Varsling om migrering av databasetabell.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => 'Kan ikke åpne Kernel/Config.pm-filen fra OTRSHome: %s!',
        'Check if Kernel/Config.pm exists in OTOBO home.' => 'Sjekk om Kernel/Config.pm finnes i OTOBO home.',
        'Kernel/Config.pm exists in OTOBO home' => 'Kernel/Config.pm finnes i OTOBO-hjemmet',
        'Check if we are able to connect to OTRS Home.' => 'Sjekk om vi er i stand til å koble til OTRS Home.',
        'Can\'t connect to OTRS file directory.' => 'Kan ikke koble til OTRS-filkatalogen.',
        'Connect to OTRS file directory is possible.' => 'Koble til OTRS filkatalog er mulig.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => 'Prøv databasetilkobling og tilregnelighetssjekker.',
        'Could not create database object.' => 'Kunne ikke opprette databaseobjekt.',
        'Database connect and sanity checks completed.' => 'Databasetilkobling og tilregnelighetskontroller fullført.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => 'Sjekk om alle nødvendige pakker er installert.',
        'The following packages are only installed in OTRS:' => 'Følgende pakker er kun installert i OTRS:',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            'Installer (eller avinstaller) pakkene før migrering. Hvis en pakke ikke eksisterer for OTOBO så langt, vennligst kontakt OTOBO-teamet på bugs\@otobo.org. Vi finner en løsning.',
        'The same packages are installed on both systems, perfect!' => 'De samme pakkene er installert på begge systemene, perfekt!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPackageSpecifics.pm
        'Package specific tasks' => 'Pakkespesifikke oppgaver',
        'Done -' => 'Ferdig -',
        'Failed at -' => 'Mislyktes på -',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => 'Sjekk om alle nødvendige Perl-moduler er installert.',
        '%s script does not exist.' => '%s-skriptet finnes ikke.',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            'En eller flere nødvendige Perl-moduler mangler. Installer dem som anbefalt, og kjør migreringsskriptet på nytt.',
        'All required Perl modules have been installed, perfect!' => 'Alle nødvendige Perl-moduler er installert, perfekt!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => 'Migrer postmaster-filter.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => 'Distribuer prosessadministrasjonskonfigurasjonen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => 'Migrer databasetabell responsmal.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => 'Migrer databasetabellhilsen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => 'Migrer databasetabellsignatur.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => 'Migrer statistikk.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Kunne ikke lese konfigurasjonsfilen for varsling. Kontroller at filen er gyldig.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Importert varsling har brødtekst med mer enn 4000 tegn.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'ikke installert',
        'installed' => 'installert',
        'Unable to parse repository index document.' => 'Kunne ikke lese fjernarkivets indeks.',
        'File is not installed!' => 'Filen er ikke installert!',
        'File is different!' => 'Filen er annerledes!',
        'Can\'t read file!' => 'Kan ikke lese filen!',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '<p>Ytterligere pakker kan forbedre OTOBO med mange nyttige funksjoner. Sørg imidlertid for at opprinnelsen til denne pakken er pålitelig, siden den kan endre OTOBO på alle mulige måter.</p>',
        'Package not verified by the OTOBO community!' => 'Pakken er ikke bekreftet av OTOBO-fellesskapet!',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "Package::AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>Installasjonen av pakker som ikke er bekreftet er deaktivert. Du kan aktivere installasjonen av ikke-verifiserte pakker via systemkonfigurasjonsinnstillingen "Package::AllowNotVerifiedPackages".</p>',
        'Verification not possible (e.g. no internet connection)!' => 'Verifisering ikke mulig (f.eks. ingen internettforbindelse)!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'Prosessen "%s" og alle dens data har blitt importert.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inaktiv',
        'FadeAway' => 'Svinne hen',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Kan ikke kontakte registreringsserver. Prøv igjen senere.',
        'No content received from registration server. Please try again later.' =>
            'Fikk ikke noe innhold fra registreringsserver. Prøv igjen senere.',
        'Can\'t get Token from sever' => 'Kan ikke hente Token fra serveren',
        'Username and password do not match. Please try again.' => 'Brukernavn og passord stemmer ikke overens. Prøv igjen.',
        'Problems processing server result. Please try again later.' => 'Problemer med å prosessere serverresultat. Prøv igjen senere.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Sum',
        'week' => 'uke',
        'quarter' => 'kvartal',
        'half-year' => 'halvår',

        # Perl Module: Kernel/System/Stats/Dynamic/ArticleList.pm
        'unlimited' => 'ubegrenset',
        'Attributes to be printed' => 'Attributter som skal printes',
        'Sort sequence' => 'Sorteringssekvens',
        'State Historic' => 'Tilstandshistorikk',
        'State Type' => 'Statustype',
        'State Type Historic' => 'Statstype Historisk',
        'Created Priority' => 'Opprettet Prioritet',
        'Created State' => 'Opprettet Status',
        'Create Time' => 'Tid',
        'Article Create Time' => '',
        'Pending until time' => 'Venter til tid',
        'Close Time' => 'Avsluttet Tidspunkt',
        'Historic Time Range' => 'Historisk tidsrom',
        'Escalation' => 'Eskalering',
        'Escalation - First Response Time' => 'Eskalering - første responstid',
        'Escalation - Update Time' => 'Eskalering - oppdateringtidspunkt',
        'Escalation - Solution Time' => 'Eskalering - løsningstid',
        'Agent/Owner' => 'Saksbehandler/Eier',
        'Created by Agent/Owner' => 'Opprettet av Saksbehandler/Eier',
        'Assigned to Customer User Login' => 'Tilordnet til kundebrukerpålogging',
        'Last Changed' => 'Sist endret',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluering av',
        'Ticket/Article Accounted Time' => 'Sak/Innlegg Utgjort Tid',
        'Ticket Create Time' => 'Sak Opprettelsestidspunkt',
        'Ticket Close Time' => 'Sak Avsluttingstidspunkt',
        'Accounted time by Agent' => 'Utgjort tid av Saksbehandler',
        'Total Time' => 'Total Tid',
        'Ticket Average' => 'Saksgjennomsnitt',
        'Ticket Min Time' => 'Sak Min Tid',
        'Ticket Max Time' => 'Sak Max Tid',
        'Number of Tickets' => 'Antall Saker',
        'Article Average' => 'Innlegg Gjennomsnitt',
        'Article Min Time' => 'Innlegg Min Tid',
        'Article Max Time' => 'Innlegg Max Tid',
        'Number of Articles' => 'Antall Innlegg',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Løsningsgjennomsnitt',
        'Solution Min Time' => 'Løsning Min tid',
        'Solution Max Time' => 'Løsning Maks tid',
        'Solution Average (affected by escalation configuration)' => 'Løsningsgjennomsnitt (påvirket av eskaleringskonfigurasjon)',
        'Solution Min Time (affected by escalation configuration)' => 'Løsning min tid (påvirket av eskaleringskonfigurasjon)',
        'Solution Max Time (affected by escalation configuration)' => 'Løsning Maks tid (påvirket av eskaleringskonfigurasjon)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Løsning Gjennomsnittlig arbeidstid (påvirket av eskaleringskonfigurasjon)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Løsning Min arbeidstid (påvirket av eskaleringskonfigurasjon)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Løsning Maks arbeidstid (påvirket av eskaleringskonfigurasjon)',
        'First Response Average (affected by escalation configuration)' =>
            'Gjennomsnitt for første respons (påvirket av eskaleringskonfigurasjon)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Min tid for første respons (påvirket av eskaleringskonfigurasjon)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Maks tid for første respons (påvirket av eskaleringskonfigurasjon)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Gjennomsnittlig arbeidstid for første respons (påvirket av eskaleringskonfigurasjon)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Første respons min arbeidstid (påvirket av eskaleringskonfigurasjon)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Første respons maksimal arbeidstid (påvirket av eskaleringskonfigurasjon)',
        'Number of Tickets (affected by escalation configuration)' => 'Antall saker (påvirket av eskaleringskonfigurasjon)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Dager',
        'Queues / Tickets' => 'Køer / saker',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Utdaterte tabeller',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'Utdaterte tabeller ble funnet i databasen. Disse kan fjernes hvis de er tomme.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabell tilstedeværelse',
        'Internal Error: Could not open file.' => 'Intern feil: Kan ikke åpne fil.',
        'Table Check' => 'Tabell sjekk',
        'Internal Error: Could not read file.' => 'Intern feil: Kan ikke lese filen.',
        'Tables found which are not present in the database.' => 'Tabeller funnet som ikke er tilgjengelig i databasen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Databasestørrelse',
        'Could not determine database size.' => 'Kunne ikke bestemme størrelsen på databasen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Databaseversjon',
        'Could not determine database version.' => 'Kunne ikke bestemme databaseversjon.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Tegnsett for klienttilkobling',
        'Setting character_set_client needs to be utf8.' => 'Innstillingen character_set_client må være utf8.',
        'Server Database Charset' => 'Tjener databasetegnsett',
        'Please convert your database to the character set \'utf8mb4\'.' =>
            'Vennligst konverter databasen til tegnsettet \'utf8mb4\'.',
        'Table Charset' => 'Tabel tegnsett',
        'There were tables found which do not have \'utf8mb4\' as charset.' =>
            'Det ble funnet tabeller som ikke har \'utf8mb4\' som tegnsett.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB logfilstørrelse',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Innstillingen \'innodb_log_file_size\' må minst være 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Ugyldige standardverdier',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Tabeller med ugyldige standardverdier ble funnet. For å fikse det automatisk, vennligst kjør: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maksimum størrelse på spørring',
        'The setting \'max_allowed_packet\' must be 64 MB or higher.' => 'Innstillingen \'max_allowed_packet\' må være 64 MB eller høyere.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Spørring mellomlagringsstørrelse',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Innstillingen \'query_cache_size\' bør brukes (over 10MB, men ikke større enn 512MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Standard lagringsmotor',
        'Table Storage Engine' => 'Tabellagringsmotor',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tabeller med en annen lagringsmotor enn standardmotoren ble funnet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x eller høyere er nødvendig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG innstilling',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG må bli satt til (f.eks. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT innstilling',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT må bli satt til \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT innstilling for SQL sjekk',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Primære nøkkelsekvenser og utløsere',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'Følgende sekvenser og/eller utløsere med mulige feil navn er funnet. Gi dem nytt navn manuelt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Innstillingene \'client_encoding\' må være satt til UNICODE eller UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Innstilling \'server_encoding\' må være satt til UNIDOCE eller UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datoformat',
        'Setting DateStyle needs to be ISO.' => 'Innstilling DateStyle må være satt til ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Primære nøkkelsekvenser',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'Følgende sekvenser med mulig feil navn er funnet. Gi dem nytt navn manuelt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 eller høyere kreves.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Certificates.pm
        'Certificate check' => 'Sertifikatkontroll',
        'Found obsolete cryptographic function.' => 'Fant foreldet kryptografisk funksjon.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO diskpartisjon',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Bruk av diskpartisjoner',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribusjon',
        'Could not determine distribution.' => 'Kunne ikke bestemme distribusjon.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel versjon',
        'Could not determine kernel version.' => 'Kunne ikke bestemme kjerneversjonen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Systembelastning',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Systembelastningen bør maksimalt være antallet CPUer systemet har (f.eks. er en belastning på 8 eller mindre på et system med 8 CPUer OK).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl moduler',
        'Not all required Perl modules are correctly installed.' => 'Ikke alle påkrevde Perl moduler er riktig installert.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Perl Modules Audit',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit rapporterte at en eller flere installerte Perl-moduler har kjente sårbarheter. Vær oppmerksom på at det kan være falske positiver for distribusjoner som patcher Perl-moduler uten å endre versjonsnummeret.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::Audit rapporterte ikke noen kjente sårbarheter i de installerte Perl-modulene.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Ledig swap diskplass (%)',
        'No swap enabled.' => 'Ingen swap tilgjengelig.',
        'Used Swap Space (MB)' => 'Brukt swap diskplass (MB)',
        'There should be more than 60% free swap space.' => 'Det bør være mer enn 60% ledig swap diskplass.',
        'There should be no more than 200 MB swap space used.' => 'Det bær vær ikke være mer enn 200 MB brukt diskplass til swap.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Artikkelsøkeindeksstatus',
        'Indexed Articles' => 'Indekserte artikler',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Artikler per kommunikasjonskanal',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Innkommende kommunikasjon',
        'Outgoing communications' => 'Utgående kommunikasjon',
        'Failed communications' => 'Mislykket kommunikasjon',
        'Average processing time of communications (s)' => 'Gjennomsnittlig behandlingstid for kommunikasjon(er)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Kommunikasjonsloggkontostatus (siste 24 timer)',
        'No connections found.' => 'Ingen tilkoblinger funnet.',
        'ok' => 'ok',
        'permanent connection errors' => 'permanente tilkoblingsfeil',
        'intermittent connection errors' => 'periodiske tilkoblingsfeil',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Konfigurasjonsinnstillinger',
        'Could not determine value.' => 'Kunne ikke bestemme verdien.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Agent',
        'Daemon is running.' => 'Daemon kjører.',
        'Daemon is not running.' => 'Agenten kjører ikke.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Databaseposter',
        'Ticket History Entries' => 'Sakshistorikkoppføringer',
        'Articles' => 'Innlegg',
        'Attachments (DB, Without HTML)' => 'Vedlegg (DB, uten HTML)',
        'Customers With At Least One Ticket' => 'Kunder med minst én sak',
        'Dynamic Field Values' => 'Dynamiske felt verdier',
        'Invalid Dynamic Fields' => 'Ugyldige dynamiske felt',
        'Invalid Dynamic Field Values' => 'Ugyldige dynamiske felt verdier',
        'GenericInterface Webservices' => 'GenericInterface Web Services',
        'Process Tickets' => 'Behandle saker',
        'Months Between First And Last Ticket' => 'Måneder mellom første og siste sak',
        'Tickets Per Month (avg)' => 'Saker per måned (gjennomsnittlig)',
        'Open Tickets' => 'Åpne saker',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Standard administrator passord',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Sikkerhetsrisiko: agentkontoen root@localhost har fortsatt standardpassordet. Vennligst endre den eller ugyldiggjøre kontoen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Sendingskø for e-post',
        'Emails queued for sending' => 'E-poster i kø for sending',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (fult domenenavn)',
        'Please configure your FQDN setting.' => 'Vennligst konfigurer din FQDN innstilling.',
        'Domain Name' => 'Domenenavn',
        'Your FQDN setting is invalid.' => 'Din FQDN innstilling er ugyldig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Filsystem Skrivbar',
        'The file system on your OTOBO partition is not writable.' => 'Filsystemet for din OTOBO partisjon er ikke mulig å skrive til.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Eldre konfigurasjonssikkerhetskopier',
        'No legacy configuration backup files found.' => 'Finner ingen sikkerhetskopifiler for eldre konfigurasjoner.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Eldre konfigurasjonssikkerhetskopieringsfiler funnet i mappen Kernel/Config/Backups, men de kan fortsatt kreves av enkelte pakker.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Sikkerhetskopieringsfiler for eldre konfigurasjoner er ikke lenger nødvendig for de installerte pakkene. Fjern dem fra mappen Kernel/Config/Backups.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Installasjonsstatus for pakker',
        'Some packages have locally modified files.' => 'Noen pakker har lokalt modifiserte filer.',
        'Some packages are not correctly installed.' => 'Noen pakker er ikke riktig installert.',
        'Package Verification Status' => 'Pakkebekreftelsesstatus',
        'Some packages are not verified by the OTOBO Team.' => 'Noen pakker er ikke verifisert av OTOBO-teamet.',
        'Package Framework Version Status' => 'Pakkerammeversjonsstatus',
        'Some packages are not allowed for the current framework version.' =>
            'Noen pakker er ikke tillatt for gjeldende rammeversjon.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Pakkeliste',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Innstillinger for øktkonfigurasjon',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'Spoolte e-poster',
        'There are emails in var/spool that OTOBO could not process.' => 'Det er e-poster i var/spool som OTOBO ikke kunne behandle.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Din SystemID innstilling er ugyldig, den kan bare inneholde tall.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Standard sakstype',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'Den konfigurerte standard sakstypen er ugyldig eller mangler. Vennligst endre innstillingen Ticket::Type::Standard og velg en gyldig sakstype.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Saksindeksmodul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Du har mer enn 60 000 saker og bør bruke StaticDB-backend. Se admin manual (Performance Tuning) for mer informasjon.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Ugyldige brukere med låste saker',
        'There are invalid users with locked tickets.' => 'Det er ugyldige brukere med låste saker.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Du bør ikke ha mer enn 8000 åpne saker i systemet ditt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Modul for sakssøkindeks',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Indekseringsprosessen tvinger lagring av den opprinnelige artikkelteksten i artikkelsøkeindeksen, uten å utføre filtre eller bruke stoppordlister. Dette vil øke størrelsen på søkeindeksen og kan dermed redusere fulltekstsøk.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Foreldreløse poster i ticket_lock_index-tabell',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Tabell ticket_lock_index inneholder foreldreløse poster. Vennligst kjør bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" for å rense StaticDB-indeksen.',
        'Orphaned Records In ticket_index Table' => 'Foreldreløse poster i ticket_index-tabell',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Tabell ticket_index inneholder foreldreløse poster. Vennligst kjør bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" for å rense StaticDB-indeksen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Tidsinnstillinger',
        'Server time zone' => 'Tjener tidssone',
        'OTOBO time zone' => 'OTOBO-tidssone',
        'OTOBO time zone is not set.' => 'OTOBO-tidssone er ikke innstilt.',
        'User default time zone' => 'Bruker standard tidssone',
        'User default time zone is not set.' => 'Brukerens standard tidssone er ikke angitt.',
        'Calendar time zone is not set.' => 'Kalenderens tidssone er ikke angitt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - Agents designbruk',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI – Agentdesignbruk',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - Spesialstatistikk',
        'Agents using custom main menu ordering' => 'Agenter bruker tilpasset hovedmenybestilling',
        'Agents using favourites for the admin overview' => 'Agenter som bruker favoritter for adminoversikten',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webtjener',
        'Loaded Apache Modules' => 'Lastede Apache-moduler',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM modell',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO krever Apache for å kunne kjøre \'prefork\' MPM modellen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator status',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Du bør benytte FastCGI eller mod_perl for å forbedre ytelsen.',
        'mod_deflate Usage' => 'mod_deflate status',
        'Please install mod_deflate to improve GUI speed.' => 'Vennligst installer mod_deflate for å forbedre hastigheten på GUI.',
        'mod_filter Usage' => 'mod_filter status',
        'Please install mod_filter if mod_deflate is used.' => 'Vennligst installer mod_filer dersom mod_deflate ikke brukes.',
        'mod_headers Usage' => 'mod_headers status',
        'Please install mod_headers to improve GUI speed.' => 'Vennligst installer mod_headers for å forbedre hastigheten på GUI.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Miljøvariabler',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Støtte datainnsamling',
        'Support data could not be collected from the web server.' => 'Støttedata kunne ikke samles inn fra webserveren.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/PSGIEnv.pm
        'PSGI Environment' => 'PSGI miljø',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/RunsUnderPSGI.pm
        'Runs under PSGI' => 'Kjører under PSGI',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webtjener versjon',
        'Could not determine webserver version.' => 'Kunne ikke bestemme webtjenerversjon.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Detaljer om samtidige brukere',
        'Concurrent Users' => 'Samtidige brukere',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Innstillingen %s eksisterer ikke!',
        'Setting %s is not locked to this user!' => 'Innstillingen %s er ikke låst til denne brukeren!',
        'Setting value is not valid!' => 'Innstillingsverdi er ikke gyldig!',
        'Could not add modified setting!' => 'Kunne ikke legge til endret innstilling!',
        'Could not update modified setting!' => 'Kunne ikke oppdatere endret innstilling!',
        'Setting could not be unlocked!' => 'Innstillingen kunne ikke låses opp!',
        'Missing key %s!' => 'Mangler nøkkel %s!',
        'Invalid setting: %s' => 'Ugyldig innstilling: %s',
        'Could not combine settings values into a perl hash.' => 'Kunne ikke kombinere innstillingsverdier til en perl-hash.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Kan ikke låse distribusjonen for bruker-ID \'%s\'!',
        'All Settings' => 'Alle innstillinger',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Standard',
        'Value is not correct! Please, consider updating this field.' => 'Verdien er ikke riktig! Vennligst vurder å oppdatere dette feltet.',
        'Value doesn\'t satisfy regex (%s).' => 'Verdien tilfredsstiller ikke regulært uttrykk (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Aktiv',
        'Disabled' => 'Inaktiv',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'Systemet var ikke i stand til å beregne brukerdato i OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'Systemet var ikke i stand til å beregne brukerens DateTime i OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Verdien er ikke riktig! Vennligst vurder å oppdatere denne modulen.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Verdien er ikke riktig! Vurder å oppdatere denne innstillingen.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Tilbakestilling av opplåsingstid.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Chat-deltaker',
        'Chat Message Text' => 'Chatmeldingstekst',

        # Perl Module: Kernel/System/Ticket/Mask.pm
        'Base structure is not valid. Please provide an array with data in YAML format.' =>
            '',
        'Error parsing dynamic fields.' => '',
        'No dynamic field "%s".' => '',
        'Dynamic field "%s" not valid.' => '',
        'Dynamic field "%s" already in use in a Set.' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => 'For mange mislykkede påloggingsforsøk, prøv igjen om %s s.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Innlogging feilet! Brukernavn eller passord ble skrevet inn feil.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Autentiseringen lyktes, men ingen brukerdatapost ble funnet i databasen. Vennligst kontakt administratoren.',
        'Can`t remove SessionID.' => 'Kan ikke fjerne SessionID.',
        'Logout successful.' => 'Vellykket avlogging.',
        'Feature not active!' => 'Funksjon ikke aktivert!',
        'Sent password reset instructions. Please check your email.' => 'Instrukser for nullstilling av passord har blitt sendt til din e-postadresse.',
        'Invalid Token!' => 'Ugyldig bevis!',
        'Sent new password to %s. Please check your email.' => 'Nytt passord ble sendt til %s. Sjekk e-posten din.',
        'Error: invalid session.' => 'Feil: ugyldig økt.',
        'No Permission to use this frontend module!' => 'Ingen tillatelse til å bruke denne frontend-modulen!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Autentiseringen lyktes, men ingen kundeoppføring ble funnet i kundestøtten. Vennligst kontakt administratoren.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Tilbakestilling av passord mislyktes. Vennligst kontakt administratoren.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Epostadressen finnes allerede. Vennligst logg inn eller nullstill passordet ditt.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Denne epostadressen er ikke tillatt å registrere. Kontakt brukerstøtten.',
        'Added via Customer Panel (%s)' => 'Lagt til via kundepanel (%s)',
        'Customer user can\'t be added!' => 'Kundebruker kan ikke legges til!',
        'Can\'t send account info!' => 'Kan ikke sende kontoinformasjon!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'En ny konto har blitt opprettet. Brukernavn og passord er sendt til %s. Vennligst sjekk e-posten din.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.' =>
            'Hvis du vil kjøre installer.pl på nytt, deaktiverer du SecureMode i SysConfig.',
        'Action "%s" not found!' => 'Handlingen "%s" ble ikke funnet!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.' =>
            'Hvis du vil kjøre migration.pl på nytt, deaktiverer du SecureMode i SysConfig.',

        # Perl Module: Kernel/System/Web/InterfacePublic.pm
        'Could not connect to the database.' => 'Kunne ikke koble til databasen.',

        # Database XML / SOPM Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'midlertidig ugyldig',
        'Group for default access.' => 'Gruppe for standardtilgang.',
        'Group of all administrators.' => 'Gruppe av alle administratorer.',
        'Group for statistics access.' => 'Gruppe for statistikktilgang.',
        'new' => 'ny',
        'All new state types (default: viewable).' => 'Alle nye tilstandstyper (standard: synlig).',
        'open' => 'åpen',
        'All open state types (default: viewable).' => 'Alle åpne tilstandstyper (standard: synlig).',
        'closed' => 'lukket',
        'All closed state types (default: not viewable).' => 'Alle lukkede tilstandstyper (standard: ikke synlig).',
        'pending reminder' => 'venter på påminnelse',
        'All \'pending reminder\' state types (default: viewable).' => 'Alle tilstandstyper «ventende påminnelse» (standard: synlig).',
        'pending auto' => 'venter på automatisk endring',
        'All \'pending auto *\' state types (default: viewable).' => 'Alle "ventende auto *" tilstandstyper (standard: synlig).',
        'removed' => 'fjernet',
        'All \'removed\' state types (default: not viewable).' => 'Alle "fjernede" tilstandstyper (standard: ikke synlig).',
        'merged' => 'flettet',
        'State type for merged tickets (default: not viewable).' => 'Tilstandstype for sammenslåtte saker (standard: ikke synlig).',
        'New ticket created by customer.' => 'Ny sak opprettet av kunden.',
        'closed successful' => 'løst og lukket',
        'Ticket is closed successful.' => 'Sak ble løst og lukket.',
        'closed unsuccessful' => 'lukket uløst',
        'Ticket is closed unsuccessful.' => 'Sak ble lukket uløst.',
        'Open tickets.' => 'Åpne saker.',
        'Customer removed ticket.' => 'Kunden fjernet saken.',
        'Ticket is pending for agent reminder.' => 'Sak venter på agentpåminnelse.',
        'pending auto close+' => 'auto-avslutning (løst)',
        'Ticket is pending for automatic close.' => 'Sak venter for automatisk lukking.',
        'pending auto close-' => 'auto-avslutning (uløst)',
        'State for merged tickets.' => 'Oppgi for sammenslåtte saker.',
        'system standard salutation (en)' => 'system standard hilsen (en)',
        'Standard Salutation.' => 'Standard hilsning.',
        'system standard signature (en)' => 'system standard signatur (en)',
        'Standard Signature.' => 'Standard signatur.',
        'Standard Address.' => 'Standard adresse.',
        'possible' => 'mulig',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Oppfølging av lukkede saker er mulig. Saken vil bli gjenåpnet.',
        'reject' => 'forkast',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Oppfølging av lukkede saker er ikke mulig. Ingen ny sak vil bli opprettet.',
        'new ticket' => 'ny sak',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Oppfølging av lukkede saker er ikke mulig. En ny sak vil bli opprettet.',
        'Postmaster queue.' => 'Postmesterkø.',
        'All default incoming tickets.' => 'Alle innkommende saker som standard.',
        'All junk tickets.' => 'Alle søppel saker.',
        'All misc tickets.' => 'Alle diverse saker.',
        'auto reply' => 'Svar automatisk',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatisk svar som sendes ut etter at ny sak er opprettet.',
        'auto reject' => 'Avslå automatisk',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatisk avslag som sendes ut etter at en oppfølging er avvist (i tilfelle køoppfølgingsalternativet er "avvis").',
        'auto follow up' => 'Automatisk oppfølging',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatisk bekreftelse som sendes ut etter at det er mottatt oppfølging på sak (i tilfelle køoppfølgingsmulighet er "mulig").',
        'auto reply/new ticket' => 'Svar/ny sak automatisk',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatisk svar som sendes ut etter at en oppfølging er avvist og ny sak er opprettet (i tilfelle køoppfølgingsalternativet er "ny sak").',
        'auto remove' => 'Fjern automatisk',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Automatisk fjerning vil bli sendt ut etter at en kunde har fjernet forespørselen.',
        'default reply (after new ticket has been created)' => 'standardsvar (etter at ny sak er opprettet)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'standard avvisning (etter oppfølging og avvisning av en lukket sak)',
        'default follow-up (after a ticket follow-up has been added)' => 'standard oppfølging (etter at en saksoppfølging er lagt til)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'standard avvisning/ny sak opprettet (etter lukket oppfølging med opprettelse av ny sak)',
        'Unclassified' => 'Uklassifisert',
        '1 very low' => '1 svært lav',
        '2 low' => '2 lav',
        '3 normal' => '3 normal',
        '4 high' => '4 høy',
        '5 very high' => '5 svært høy',
        'unlock' => 'tilgjengelig',
        'lock' => 'lås',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'saksbehandler',
        'system' => 'system',
        'customer' => 'kunde',
        'Ticket create notification' => 'Melding om opprettelse av sak',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Du vil motta et varsel hver gang en ny sak opprettes i en av dine "Mine køer" eller "Mine tjenester".',
        'Ticket follow-up notification (unlocked)' => 'Saksoppfølgingsvarsling (ulåst)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Du vil motta et varsel om en kunde sender en oppfølging til en ulåst sak i "mine køer" eller "mine tjenester".',
        'Ticket follow-up notification (locked)' => 'Saksoppfølgingsvarsling (låst)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Du vil motta et varsel dersom en kunde sender en oppfølging av en låst sak som du er sak eier eller ansvarlig for.',
        'Ticket lock timeout notification' => 'Varsling ved overskridelse av tidsfrist for avslutting av sak',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Du vil motta et varsel så snart en sak som eies av deg låses opp automatisk.',
        'Ticket owner update notification' => 'Melding om oppdatering av sakseier',
        'Ticket responsible update notification' => 'Melding om oppdatering av saksansvarlig',
        'Ticket new note notification' => 'Melding om ny sak',
        'Ticket queue update notification' => 'Varsling om oppdatering av sakskø',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Du vil motta et varsel hvis en sak flyttes inn i en av dine "Mine køer".',
        'Ticket pending reminder notification (locked)' => 'Sak venter påminnelsesvarsling (låst)',
        'Ticket pending reminder notification (unlocked)' => 'Sak venter påminnelsesvarsling (ulåst)',
        'Ticket escalation notification' => 'Varsling om saksopptrapping',
        'Ticket escalation warning notification' => 'Varsel om saksopptrapping',
        'Ticket service update notification' => 'Melding om oppdatering av saksservice',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Du vil motta et varsel hvis en saks tjeneste endres til en av dine "Mine tjenester".',
        'Appointment reminder notification' => 'Varsel med påminnelse om avtale',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Du vil motta en varsel hver gang påminnelsestidspunktet nåes for en av dine avtaler.',
        'Ticket email delivery failure notification' => 'Melding om leveringsfeil på e-post',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Feil under AJAX-kommunikasjon. Status: %s, feil: %s',
        'This window must be called from compose window.' => 'Dette vinduet må kalles opp fra skrivevinduet.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Legg til alle',
        'An item with this name is already present.' => 'Et objekt med dette navnet eksisterer allerede.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dette elementet inneholder fortsatt underelementer. Er du sikker på at du vil fjerne dette elementet inkludert underelementene?',

        # JS File: Core.Agent.Admin.About
        'Do you really want to delete this language?' => 'Vil du virkelig slette dette språket?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Flere',
        'Less' => 'Færre',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Trykk Ctrl+C (Cmd+C) for å kopiere til utklippstavlen',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Slett dette vedlegget',
        'Deleting attachment...' => 'Sletter vedlegg ...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Det oppsto en feil under sletting av vedlegget. Vennligst sjekk loggene for mer informasjon.',
        'Attachment was deleted successfully.' => 'Vedlegget ble slettet.',

        # JS File: Core.Agent.Admin.CustomerDashboardInfoTile
        'Do you really want to delete this customer dashboard info tile entry?' =>
            '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vil du virkelig fjerne dette dynamiske feltet? ALLE tilknyttede data vil bli BORTE!',
        'Delete field' => 'Fjern felt',
        'Deleting the field and its data. This may take a while...' => 'Sletting av feltet og dets data. Dette kan ta en stund...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Fjern dette dynamiske feltet',
        'Remove selection' => 'Fjern markering',
        'Do you really want to delete this generic agent job?' => 'Vil du virkelig slette denne generiske agentjobben?',
        'Delete this Event Trigger' => 'Fjern denne Hendelses Utløseren',
        'Duplicate event.' => 'Klone hendelsen.',
        'This event is already attached to the job, Please use a different one.' =>
            'Denne hendelsen er allerede knyttet til jobben. Bruk en annen.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'En feil oppstod under kommunikasjonen.',
        'Request Details' => 'Be om detaljer',
        'Request Details for Communication ID' => 'Be om detaljer for kommunikasjons-ID',
        'Show or hide the content.' => 'Vis eller skjul innhold.',
        'Clear debug log' => 'Tøm feilsøker loggen',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Slett feilhåndteringsmodul',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Det er ikke mulig å legge til en ny hendelsestrigger fordi hendelsen ikke er angitt.',
        'Delete this Invoker' => 'Fjern denne Anroperen',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Beklager, den eneste eksisterende tilstanden kan ikke fjernes.',
        'Sorry, the only existing field can\'t be removed.' => 'Beklager, det eneste eksisterende feltet kan ikke fjernes.',
        'Delete conditions' => 'Slett betingelser',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Kartlegging for nøkkel %s',
        'Mapping for Key' => 'Kartlegging for Nøkkel',
        'Delete this Key Mapping' => 'Slett denne nøkkelen for mapping',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Fjern denne handlingen',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Dupliser webtjeneste',
        'Delete operation' => 'Fjern handlingen',
        'Delete invoker' => 'Slett anroperen',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ADVARSEL: Om du endrer navnet til gruppen \'admin\' før du gjør de nødvendige endringer i SysConfig, vil du bli utestengt fra administrator panelet! Om dette skjer, vennligst endre navnet på gruppen tilbake til admin via SQL statement.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Slett denne e-postkontoen',
        'Deleting the mail account and its data. This may take a while...' =>
            'Sletting av e-postkontoen og dens data. Dette kan ta en stund...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Vil du virkelig slette dette varslingsspråket?',
        'Do you really want to delete this notification?' => 'Vil du virkelig slette dette varslet?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Vil du virkelig slette denne nøkkelen?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Det er en pakkeoppgraderingsprosess som kjører, klikk her for å se statusinformasjon om oppgraderingsfremdriften.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'En pakkeoppgradering ble nylig fullført. Klikk her for å se resultatene.',
        'No response from get package upgrade result.' => 'Ingen svar fra get-pakkeoppgraderingsresultatet.',
        'Update all packages' => 'Oppdater alle pakker',
        'Dismiss' => 'Forkast',
        'Update All Packages' => 'Oppdater alle pakker',
        'No response from package upgrade all.' => 'Ingen svar fra pakkeoppgradering av alle.',
        'Currently not possible' => 'Foreløpig ikke mulig',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Dette er for øyeblikket deaktivert på grunn av en pågående pakkeoppgradering.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Dette alternativet er for øyeblikket deaktivert fordi OTOBO Daemon ikke kjører.',
        'Are you sure you want to update all installed packages?' => 'Er du sikker på at du vil oppdatere alle installerte pakker?',
        'No response from get package upgrade run status.' => 'Ingen svar fra kjøringsstatus for get-pakkeoppgradering.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Slett dette PostMasterFilter',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Sletter postmaster-filteret og dets data. Dette kan ta en stund...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Fjern entitet fra lerretet',
        'No TransitionActions assigned.' => 'Ingen overgangshandlinger tilordnet.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Ingen dialogbokser er tildelt ennå. Bare velg en aktivitetsdialog fra listen til venstre og dra den hit.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Denne aktiviteten kan ikke slettes fordi det er startaktiviteten.',
        'Remove the Transition from this Process' => 'Fjern overgangen fra denne prosessen',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Så snart du bruker denne knappen eller lenken, vil du forlate denne skjermen og dens nåværende tilstand lagres automatisk. Vil du fortsette?',
        'Delete Entity' => 'Slett entitet',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Denne aktiviteten er allerede i bruk i denne prosessen. Du kan ikke leggen den til for andre gang!',
        'Error during AJAX communication' => 'Feil under AJAX-kommunikasjon',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'En usammenhengende overgang er allerede plassert på lerretet. Koble til denne overgangen først før du plasserer en ny overgang.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Denne overgangen er allerede i bruk i denne aktiviteten. Du kan ikke leggen den til for andre gang!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Denne overgangshandlingen er allerede i bruk i denne addressen. Du kan ikke leggen den til for andre gang!',
        'Hide EntityIDs' => 'Skjul enhets-ID-er',
        'Edit Field Details' => 'Endre feltdetaljer',
        'Customer interface does not support articles not visible for customers.' =>
            'Kundegrensesnittet støtter ikke artikler som ikke er synlige for kunder.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Beklager, den eneste eksisterende parameteren kan ikke fjernes.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Vil du virkelig slette dette sertifikatet?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Sender oppdatering...',
        'Support Data information was successfully sent.' => 'Informasjon om støttedata ble sendt.',
        'Was not possible to send Support Data information.' => 'Var ikke mulig å sende støttedatainformasjon.',
        'Update Result' => 'Oppdateringsresultat',
        'Generating...' => 'Genererer....',
        'It was not possible to generate the Support Bundle.' => 'Det var ikke mulig å generere støttepakken.',
        'Generate Result' => 'Generer resultat',
        'Support Bundle' => 'Støttepakke',
        'The mail could not be sent' => 'Posten kunne ikke sendes',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Det er ikke mulig å sette denne oppføringen til ugyldig. Alle berørte konfigurasjonsinnstillinger må endres på forhånd.',
        'Cannot proceed' => 'Kan ikke fortsette',
        'Update manually' => 'Oppdater manuelt',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Du kan enten oppdatere de berørte innstillingene automatisk for å gjenspeile endringene du nettopp har gjort, eller gjøre det på egen hånd ved å trykke "oppdater manuelt".',
        'Save and update automatically' => 'Lagre og oppdater automatisk',
        'Don\'t save, update manually' => 'Ikke lagre, oppdater manuelt',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'Elementet du ser på for øyeblikket er en del av en konfigurasjonsinnstilling som ennå ikke er distribuert, noe som gjør det umulig å redigere det i gjeldende tilstand. Vent til innstillingen er implementert. Hvis du er usikker på hva du skal gjøre videre, vennligst kontakt systemadministratoren din.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Laster...',
        'Search the System Configuration' => 'Søk i systemkonfigurasjonen',
        'Please enter at least one search word to find anything.' => 'Skriv inn minst ett søkeord for å finne noe.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Dessverre er distribusjon for øyeblikket ikke mulig, kanskje fordi en annen agent allerede distribuerer. Prøv igjen senere.',
        'Deploy' => 'Utplassere',
        'The deployment is already running.' => 'Utrullingen kjører allerede.',
        'Deployment successful. You\'re being redirected...' => 'Implementeringen var vellykket. Du blir omdirigert...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Det var en feil. Vennligst lagre alle innstillingene du redigerer og sjekk loggene for mer informasjon.',
        'Reset option is required!' => 'Tilbakestillingsalternativ er nødvendig!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Ved å gjenopprette denne distribusjonen vil alle innstillinger bli tilbakestilt til verdien de hadde på tidspunktet for distribusjonen. Vil du virkelig fortsette?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Nøkler med verdier kan ikke gis nytt navn. Vennligst fjern dette nøkkel/verdi-paret i stedet og legg det til på nytt etterpå.',
        'Unlock setting.' => 'Lås opp innstilling.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => 'Er du sikker på at du vil fjerne alle brukerverdier?',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Vil du virkelig slette dette planlagte systemvedlikeholdet?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Slett denne malen',
        'Deleting the template and its data. This may take a while...' =>
            'Sletting av malen og dens data. Dette kan ta en stund...',

        # JS File: Core.Agent.Admin.Translations
        'Missing Translations' => '',
        'At least one translation must be filled!' => '',
        'All translations must be filled!' => '',
        'Close' => 'Avslutt sak',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Hopp',
        'Timeline Month' => 'Tidslinjemåned',
        'Timeline Week' => 'Tidslinje uke',
        'Timeline Day' => 'Tidslinjedag',
        'Previous' => 'Forrige',
        'Resources' => 'Ressurser',
        'Su' => 'sø',
        'Mo' => 'ma',
        'Tu' => 'ti',
        'We' => 'on',
        'Th' => 'to',
        'Fr' => 'fr',
        'Sa' => 'lø',
        'This is a repeating appointment' => 'Dette er en gjentagende avtale',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Ønsker du kun å redigere denne avtalen eller alle forekomstene?',
        'All occurrences' => 'Alle forekomster',
        'Just this occurrence' => 'Bare denne avtalen',
        'Too many active calendars' => 'For mange aktive kalendere',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Slå enten av noen først eller øk grensen i konfigurasjonen.',
        'Restore default settings' => 'Gjenopprett standardinnstillinger',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Er du sikker på at du vil slette denne avtalen? Denne operasjonen kan ikke angres.',

        # JS File: Core.Agent.ArticleFeatures
        'Article Delete' => '',
        'Are you sure you want to delete this article?' => '',
        'Article deleted successfully!' => '',
        'Article already marked as deleted.' => '',
        'Article Restore' => '',
        'Are you sure you want to restore this article?' => '',
        'Article restored successfully!' => '',
        'Article not available for restoring.' => '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Velg først en kundebruker, og velg deretter en kunde-ID som skal tilordnes denne saken.',
        'Duplicated entry' => 'Doble innlegg',
        'It is going to be deleted from the field, please try again.' => 'Den kommer til å bli slettet fra feltet, prøv igjen.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Vennligst oppgi minst en søkeverdi eller * for å finne noe.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informasjon om OTOBO Agenten',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Vennligst sjekk feltene merket som røde for gyldige inndata.',
        'month' => 'måned',
        'Remove active filters for this widget.' => 'Fjern aktive filtre for denne widgeten.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => 'Denne dynamiske feltdatabaseverdien er allerede valgt.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Vennligst vent...',
        'Searching for linkable objects. This may take a while...' => 'Søker etter koblingsbare objekter. Dette kan ta en stund...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Vil du virkelig slette denne linken?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Bruker du en nettleserplugin som AdBlock eller AdBlockPlus? Dette kan forårsake flere problemer, og vi anbefaler deg på det sterkeste å legge til et unntak for dette domenet.',
        'Do not show this warning again.' => 'Ikke vis denne advarselen igjen.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Beklager, men du kan ikke deaktivere alle metoder for varsler merket som obligatoriske.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Beklager, men du kan ikke deaktivere alle metodene for dette varselet.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Vær oppmerksom på at minst én av innstillingene du har endret krever at siden lastes på nytt. Klikk her for å laste den gjeldende skjermen på nytt.',
        'An unknown error occurred. Please contact the administrator.' =>
            'En ukjent feil oppstod. Vennligst kontakt administratoren.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Bytt til skrivebordsmodus',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Vennligst fjern følgende ord fra søket ettersom de ikke kan søkes etter:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'generere',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Dette elementet har underordnede elementer og kan for øyeblikket ikke fjernes.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Vil du virkelig slette denne statistikken?',

        # JS File: Core.Agent.StatisticsReports
        'Do you really want to delete this report?' => 'Vil du virkelig slette denne rapporten?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Velg en kunde-ID som skal tilordnes denne saken',
        'Do you really want to continue?' => 'Vil du virkelig fortsette?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...og %s til',
        ' ...show less' => ' ...Vis mindre',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Legg til nytt utkast',
        'Delete draft' => 'Slett utkast',
        'There are no more drafts available.' => 'Det er ikke flere utkast tilgjengelig.',
        'It was not possible to delete this draft.' => 'Det var ikke mulig å slette dette utkastet.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Innleggsfilter',
        'Apply' => 'Lagre',
        'Event Type Filter' => 'Hendelsestypefilter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Skyv navigasjonslinjen',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Slå av kompatibilitetsmodus i Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Bytt til mobilmodus',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Feil: Nettlesersjekk mislyktes!',
        'Reload page' => 'Last inn siden på nytt',
        'Reload page (%ss)' => 'Last inn siden på nytt (%ss)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Navneområdet %s kunne ikke initialiseres, fordi %s ikke ble funnet.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'En feil oppstod! Vennligst sjekk nettleserens feillogg for mer informasjon!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'En eller flere feil har oppstått!',

        # JS File: Core.Installer
        'Mail check successful.' => 'E-postsjekk fullført.',
        'Error in the mail settings. Please correct and try again.' => 'Feil i e-postoppsettet. Korriger og prøv igjen.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'Åpne denne noden i et nytt vindu',
        'Please add values for all keys before saving the setting.' => 'Legg til verdier for alle nøkler før du lagrer innstillingen.',
        'The key must not be empty.' => 'Nøkkelen må ikke være tom.',
        'A key with this name (\'%s\') already exists.' => 'En nøkkel med dette navnet (\'%s\') finnes allerede.',
        'Do you really want to revert this setting to its historical value?' =>
            'Vil du virkelig tilbakestille denne innstillingen til dens historiske verdi?',

        # JS File: Core.UI.CodeMirrorEditor
        'Error trying to create CodeMirror instance, please check configuration!' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Åpne datovelger',
        'Invalid date (need a future date)!' => 'Ugyldig dato (må være i fremtiden)!',
        'Invalid date (need a past date)!' => 'Ugyldig dato (må være tilbake i tid)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Ikke tilgjengelig',
        'and %s more...' => 'og %s til...',
        'Show current selection' => 'Vis gjeldende utvalg',
        'Current selection' => 'Gjeldende utvalg',
        'Clear all' => 'Tøm alle',
        'Filters' => 'Filtre',
        'Clear search' => 'Tilbakestil søk',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Hvis du forlater denne siden vil også alle åpne sprettopp-vinduer bli lukket!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'En sprettoppvindu med denne skjermen er allerede åpen. Vil du stenge vinduet og laste det inn her i stedet?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kunne ikke åpne sprettoppvindu. Vennligst slå av eventuelle blokkefunksjoner i nettleseren for dette nettstedet.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Stigende sortering brukt, ',
        'Descending sort applied, ' => 'Synkende sortering er brukt, ',
        'No sort applied, ' => 'Ingen sortering brukt, ',
        'sorting is disabled' => 'sortering er deaktivert',
        'activate to apply an ascending sort' => 'aktiver for å bruke en stigende sortering',
        'activate to apply a descending sort' => 'aktiver for å bruke en synkende sortering',
        'activate to remove the sort' => 'aktiver for å fjerne sorteringen',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Fjern filteret',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Det er for øyeblikket ingen tilgjengelige elementer å velge mellom.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Velg kun én fil for opplasting.',
        'Sorry, you can only upload one file here.' => 'Beklager, du kan bare laste opp én fil her.',
        'Sorry, you can only upload %s files.' => 'Beklager, du kan bare laste opp %s filer.',
        'Please only select at most %s files for upload.' => 'Velg maksimalt %s filer for opplasting.',
        'The following files are not allowed to be uploaded: %s' => 'Følgende filer er ikke tillatt å lastes opp: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Følgende filer overskrider den maksimalt tillatte størrelsen per fil på %s og ble ikke lastet opp: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Følgende filer er allerede lastet opp og har ikke blitt lastet opp igjen: %s',
        'No space left for the following files: %s' => 'Ingen plass igjen for følgende filer: %s',
        'Available space %s of %s.' => 'Tilgjengelig plass %s av %s.',
        'Upload information' => 'Last opp informasjon',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Det oppstod en ukjent feil ved sletting av vedlegget. Vær så snill, prøv på nytt. Hvis feilen vedvarer, vennligst kontakt systemadministratoren.',

        # JS File: ITSM.Admin.ImportExport
        'Deleting template...' => '',
        'There was an error deleting the template. Please check the logs for more information.' =>
            '',
        'Template was deleted successfully.' => '',

        # JS File: Core.Language.UnitTest
        'yes' => 'ja',
        'no' => 'no',
        'This is %s' => 'Dette er %s',
        'Complex %s with %s arguments' => 'Kompleks %s med %s argumenter',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'Ingen data tilgjengelig.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Gruppert',
        'Stacked' => 'Stablet',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Strøm',
        'Expanded' => 'Utvidet',

        # SysConfig
        '
            Show optional parameters in parameter list, too. If disabled, the optional parameters are only shown
            in an extra table
        ' => '
            Vis valgfrie parametere i parameterlisten også. Hvis deaktivert,
            vises kun de valgfrie parameterne i en ekstra tabell
        ',
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Kjære kunde,

Vi kunne dessverre ikke finne et gyldig saksnummer
i emnet ditt, så denne e-posten kan ikke behandles.

Vennligst opprett en ny sak via kundepanelet.

Takk for hjelpen!

Ditt Helpdesk-team
',
        ' (work units)' => ' (arbeidsenheter)',
        ' 2 minutes' => ' 2 minutter',
        ' 5 minutes' => ' 5 minutter',
        ' 7 minutes' => ' 7 minutter',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Slankt" tema som prøver å spare skjermplass for superbrukere.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Brukernavn) Fornavn Etternavn',
        '(UserLogin) Lastname Firstname' => '(Brukernavn) Etternavn Fornavn',
        '(UserLogin) Lastname, Firstname' => '(Brukernavn) Etternavn, Fornavn',
        '*** out of office until %s (%s d left) ***' => '*** ikke på kontoret til %s (%s d igjen) ***',
        '0 - Disabled' => '0 - Deaktivert',
        '1 - Available' => '1 - Tilgjengelig',
        '1 - Enabled' => '1 - Aktivert',
        '10 Minutes' => '10 minutter',
        '100 (Expert)' => '100 (ekspert)',
        '15 Minutes' => '15 minutter',
        '2 - Enabled and required' => '2 - Aktivert og nødvendig',
        '2 - Enabled and shown by default' => '2 - Aktivert og vist som standard',
        '2 - Enabled by default' => '2 - Aktivert som standard',
        '2 Minutes' => '2 minutter',
        '200 (Advanced)' => '200 (avansert)',
        '30 Minutes' => '30 minutter',
        '300 (Beginner)' => '300 (nybegynner)',
        '5 Minutes' => '5 minutter',
        'A TicketWatcher Module.' => 'En TicketWatcher-modul.',
        'A Website' => 'En hjemmeside',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'En liste over dynamiske felt som er slått sammen til hovedsaken under en fletteoperasjon. Kun dynamiske felt som er tomme i hovedsaken vil bli satt.',
        'A picture' => 'Et bilde',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL-modul som lar en stenge overordnede saker kun hvis alle undersakene deres har blitt stengte ("Status" viser hvilke statuser som ikke er tilgjengelige inntil alle undersaker er stengte).',
        'Access Control Lists (ACL)' => 'Tilgangskontrolllister (ACL)',
        'AccountedTime' => 'Ført tid',
        'Activate Elasticsearch.' => 'Aktiver Elasticsearch.',
        'Activate the customer frontend.' => 'Aktiver kundegrensesnittet.',
        'Activate the public frontend.' => 'Aktiver den offentlige frontend.',
        'Activates Rendering of DynamicFields outside of the DynamicField block.' =>
            'Aktiverer gjengivelse av DynamicFields utenfor DynamicField-blokken.',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Slår på en blinke-mekanisme for den køen som har den eldste saken.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Slår på glemt-passord-funksjonalitet for saksbehandlere.',
        'Activates lost password feature for customers.' => 'Slår på glemt-passord-funksjonalitet for kundebrukere.',
        'Activates support for customer and customer user groups.' => 'Aktiverer støtte for kunde- og kundebrukergrupper.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Slår på innleggsfilteret i zoom-visningen for å spesifisere hvilke innlegg som skal vises.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Slår på de tilgjengelige temaene i systemet. Verdien 1 betyr aktivert, mens 0 betyr inaktivert.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Slår på arkivsøk i kundegrensesnittet.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Slår på arkiveringssystemet for saker. Dette øker hastigheten på systemet ved å fjerne noen av sakene ut av den daglige bruken. For å søke etter slike saker må man søke etter arkiverte saker.',
        'Activates time accounting.' => 'Slår på tids-kontering.',
        'ActivityID' => 'Aktivitets-ID',
        'Add a note to this ticket' => 'Legg til et notis på denne saken',
        'Add an inbound phone call to this ticket' => 'Legg til en innkommende telefonsamtale til denne saken',
        'Add an outbound phone call to this ticket' => 'Legg til en utgående telefonsamtale til denne saken',
        'Added %s time unit(s), for a total of %s time unit(s).' => 'Lagt til %s tidsenhet(er), for totalt %s tidsenhet(er).',
        'Added email. %s' => 'Lagt e-post til sak. %s',
        'Added follow-up to ticket [%s]. %s' => 'Lagt til oppfølging til sak [%s]. %s',
        'Added link to ticket "%s".' => 'La til link til sak «%s».',
        'Added note (%s).' => 'Lagt til notat (%s).',
        'Added phone call from customer.' => 'Lagt til telefon fra kunde.',
        'Added phone call to customer.' => 'Lagt til telefon til kunde.',
        'Added subscription for user "%s".' => 'La til abonnement for brukeren «%s».',
        'Added system request (%s).' => 'Lagt til systemforespørsel (%s).',
        'Added web request from customer.' => 'Lagt til nettforespørsel fra kunde.',
        'Adds a suffix with the actual year and month to the OTOBO log file. A logfile for every month will be created.' =>
            'Legger til år og måned på loggfilens navn. Dette gjør at man får én logg-fil per måned.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Legger til kundenes e-postadresser til mottakere i saksskrivingsskjermen i agentgrensesnittet. Kundens e-postadresse vil ikke bli lagt til hvis artikkeltypen er e-postintern.',
        'Adds the one time vacation days for the indicated calendar.' => 'Legger til engangsferiedagene for den angitte kalenderen.',
        'Adds the one time vacation days.' => 'Legger til engangsferiedagene.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            'Legger til de permanente feriedagene for den angitte kalenderen.',
        'Adds the permanent vacation days.' => 'Legger til de permanente feriedagene.',
        'Admin' => 'Administrator',
        'Admin Area.' => 'Adminområde.',
        'Admin Contact With Data' => 'Administratorkontakt med data',
        'Admin Notification' => 'Administratorvarsling',
        'Admin area navigation for the agent interface.' => 'Administratorområdenavigasjon for agentgrensesnittet.',
        'Admin contact with data.' => 'Administratorkontakt med data.',
        'Admin modules overview.' => 'Oversikt over administratormoduler.',
        'Admin.' => 'Admin.',
        'Administration' => 'Administrasjon',
        'Agent Contact With Data Search' => 'Agentkontakt med datasøk',
        'Agent Customer Search' => 'Agentkundesøk',
        'Agent Customer Search.' => 'Agentkundesøk.',
        'Agent Dynamic Field Database Detailed Search' => 'Agent Dynamic Field Database Detaljert søk',
        'Agent Dynamic Field Database Details' => 'Agent Dynamic Field Database Detaljer',
        'Agent Dynamic Field Database Search' => 'Agent Dynamic Field Database Søk',
        'Agent Name' => 'Agentnavn',
        'Agent Name + FromSeparator + System Address Display Name' => 'Agentnavn + FraSeparator + Visningsnavn for systemadresse',
        'Agent Preferences.' => 'Agentinnstillinger.',
        'Agent Reference Dynamic Field With Data Search' => '',
        'Agent Statistics.' => 'Agentstatistikk.',
        'Agent User Search' => 'Agentbrukersøk',
        'Agent User Search.' => 'Agentbrukersøk.',
        'Agent contact with data search.' => 'Agentkontakt med datasøk.',
        'Agent dynamic field database detailed search.' => 'Agent dynamisk feltdatabase detaljert søk.',
        'Agent dynamic field database details.' => 'Agent dynamisk feltdatabasedetaljer.',
        'Agent dynamic field database search.' => 'Agent dynamisk feltdatabasesøk.',
        'Agent frontend module registration (disable \'Edit contacts with data\' link if if there is no source field configured).' =>
            'Registrering av agentgrensesnittmodul (deaktiver koblingen "Rediger kontakter med data" hvis det ikke er konfigurert noe kildefelt).',
        'Agent interface article notification module to check PGP.' => 'Varslingsmodul for å sjekke PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Varslingsmodul for å sjekke S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittmodul for å få tilgang til CIC-søk via navigasjonslinjen. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittmodul for å få tilgang til fulltekstsøk via navigasjonslinjen. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittmodul for å få tilgang til søkeprofiler via navigasjonslinjen. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Saksbehandlermodul som sjekker innkommende e-post i Zoom-visning dersom S/MIME-nøkkelen er tilgjengelig og korrekt.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittvarslingsmodul for å se antall låste saker. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittvarslingsmodul for å se antall saker en agent er ansvarlig for. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittvarslingsmodul for å se antall saker i Mine tjenester. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agentgrensesnittvarslingsmodul for å se antall overvåkede saker. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Agent reference dynamic field with data search.' => '',
        'AgentTicketZoom widget that displays Contact with data dynamic field in the side bar.' =>
            'AgentTicketZoom-widget som viser kontakt med data dynamisk felt i sidelinjen.',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'AgentTicketZoom-widget som viser en tabell over objekter knyttet til saken.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'AgentTicketZoom-widget som viser kundeinformasjon for saken i sidelinjen.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'AgentTicketZoom-widget som viser saksdata i sidelinjen.',
        'Agents ↔ Groups' => 'Agenter ↔ Grupper',
        'Agents ↔ Roles' => 'Agenter ↔ Roller',
        'All CustomerIDs of a customer user.' => 'Alle kunde-ID-er til en kundebruker.',
        'All closed tickets.' => 'Alle lukkede saker.',
        'All customer users of a CustomerID' => 'Alle kunder-brukere av et KundeID',
        'All escalated tickets' => 'Alle eskalerte saker',
        'All new tickets, these tickets have not been worked on yet' => 'Alle nye saker som ikke har blitt sett på enda',
        'All open tickets, these tickets have already been worked on.' =>
            'Alle åpne saker, disse sakene er allerede jobbet med.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle saker med påminnelse satt der påminnelsen har slått til',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Gjør det mulig å legge til notater i skjermbildet for lukkesaks i agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Tillater å legge til notater i saksfritekstskjermen til agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Gjør det mulig å legge til notater i saksseddelskjermen til agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Tillater å legge til notater på sakseierskjermen for en zoomet sak i agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Tillater å legge til notater i skjermbildet for ventende sak til en zoomet sak i agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Tillater å legge til notater i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Tillater å legge til notater i den saksansvarlige skjermen til agentgrensesnittet. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Tillater saksbehandlere å bytte akse for statistikk de selv oppretter.',
        'Allows agents to generate individual-related stats.' => 'Lar saksbehandlere opprette statistikk relatert til individer.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Tillater å velge mellom å vise vedlegg til saker i nettleseren (inline) eller gjøre dem nedlastbare (vedlegg).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Tillater å velge status ved opprettelse av kundesaker i kundeportalen.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Lar kunder endre sakens prioritet i kundeportalen.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Lar kunder sette sakens SLA i kundeportalen.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Lar kunder sette sakens prioritet i kundeportalen.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            'Lar kundene sette sakskøen i kundegrensesnittet. Hvis dette ikke er aktivert, bør QueueDefault konfigureres.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Lar kunder velge sakens tjeneste i kundeportalen.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            'Lar kunder angi sakstypen i kundegrensesnittet. Hvis dette ikke er aktivert, bør TicketTypeDefault konfigureres.',
        'Allows default services to be selected also for non existing customers.' =>
            'Lar standardtjenester velges også for ikke-eksisterende kunder.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Tillater å opprette tjenester og SLAer for saker (f.eks. e-post, skrivebord, nettverk, ...) og eskaleringsattributter for SLAer (dersom tjenester/SLA er slått på).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Tillater utvidede søkebetingelser i sakssøk i agentgrensesnittet. Med denne funksjonen kan du søke f.eks. g. sakstittel med denne typen betingelser som "(*key1*&&*key2*)" eller "(*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Tillater utvidede søkebetingelser i sakssøk i kundegrensesnittet. Med denne funksjonen kan du søke f.eks. g. sakstittel med denne typen betingelser som "(*key1*&&*key2*)" eller "(*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Tillater utvidede søkebetingelser i sakssøk i det generiske agentgrensesnittet. Med denne funksjonen kan du søke f.eks. g. sakstittel med denne typen betingelser som "(*key1*&&*key2*)" eller "(*key1*||*key2*)".',
        'Allows generic agent to execute custom modules.' => 'Lar generisk agent kjøre tilpassede moduler.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Tillater å bruke medium saksoversikt (KundeInfo => 1 - viser også kundeinformasjon).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Tillater å bruke liten saksoversikt (Kunde-info => 1 - vis også kundeinformasjon).',
        'Allows invalid agents to generate individual-related stats.' => 'Lar ugyldige agenter generere individrelatert statistikk.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Lar administratorer logge inn som andre kunder, via kundeadministrasjonspanelet.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Tillater administratorer å logge seg inn som andre brukere, via brukeradministrasjonspanelet.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i skjermbildet for lukk sak i agentgrensesnittet.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i e-postutgående skjermbilde i agentgrensesnittet.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i saksskrivingsskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i skjermbildet for videresending av sak i agentgrensesnittet.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i saksfritekstskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i saksflyttingsskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i saksnotatskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i sakseierskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i skjermbildet for ventende sak i agentgrensesnittet.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i sakstelefonens utgående skjerm i agentgrensesnittet.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i saksprioritetsskjermen til agentgrensesnittet.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            'Gjør det mulig å lagre gjeldende arbeid som utkast i den saksansvarlige skjermen til agentgrensesnittet.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Tillater å endre sakens status når den skal flyttes.',
        'Always show RichText if available' => 'Vis alltid RichText hvis tilgjengelig',
        'Answer' => 'Svar',
        'Appointment Calendar overview page.' => 'Oversiktsside for avtalekalender.',
        'Appointment Notifications' => 'Varsler om avtale',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'Avtalekalenderhendelsesmodul som forbereder varslingsoppføringer for avtaler.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'Avtalekalender arrangementsmodul som oppdaterer saken med data fra saksavtale.',
        'Appointment edit screen.' => 'Side for avtaleregistrering.',
        'Appointment list' => 'Avtaleliste',
        'Appointment list.' => 'Avtaleliste.',
        'Appointment notifications' => 'Varsler om avtale',
        'Appointments' => 'Avtaler',
        'Arabic (Saudi Arabia)' => 'Arabisk (Saudi Arabia)',
        'Article ID: %s was deleted by "%s" (%s)' => '',
        'Article ID: %s was edited by "%s" (%s)' => '',
        'Article ID: %s was restored by "%s" (%s)' => '',
        'Article Version View' => '',
        'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            'Artikkelattributter som skal være tilgjengelige i saksopprettelse-konfigurasjonsfrontend (0 = synlig/valgbar, 1 = standard/forhåndsvalgt).',
        'ArticleTree' => 'Artikkeltre',
        'As soon as the move queue option dropdown is enabled for example in the AgentTicketZoom dialogue, it is possible to move tickets locked to other agents to another queue by activating this option.' =>
            '',
        'Attachment Name' => 'Vedleggsnavn',
        'Automated line break in text messages after x number of chars.' =>
            'Automatisk linjeskift i tekstmeldinger etter # antall tegn.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            'Endre automatisk tilstanden til en sak med en ugyldig eier når den er låst opp. Kart fra en tilstandstype til en ny sakstilstand.',
        'Automatically generate statistics reports and email them to the specified recipients.' =>
            'Generer statistikkrapporter automatisk og send med e-post til de angitte mottakerne.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Lås og sett eieren til gjeldende agent automatisk etter å ha åpnet skjermbildet for flytting av sak i agentgrensesnittet.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatisk lås og sett eier til nåværende agent etter å ha blitt valgt i en masseredigeringshandling.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Angir automatisk eieren av en sak som ansvarlig for den (hvis saksansvarlig funksjon er aktivert). Dette vil kun fungere ved manuelle handlinger av den påloggede brukeren. Det fungerer ikke for automatiserte handlinger f.eks. GenericAgent, Postmaster og GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Sett automatisk ansvarlig for en sak (hvis ikke satt) etter første eieroppdatering.',
        'Avatar' => 'Avatar',
        'Balanced white skin by Felix Niklas (slim version).' => 'Balansert hvitt tema av Felix Niklas (slank versjon).',
        'Balanced white skin by Felix Niklas.' => 'Balansert hvitt tema av Felix Niklas.',
        'Based on global RichText setting' => 'Basert på global RichText-innstilling',
        'Basic fulltext index settings. Execute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            'Grunnleggende fulltekstindeksinnstillinger. Kjør "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" for å generere en ny indeks.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blokkerer all innkommende e-post som ikke har et gyldig saksnummer i emnefeltet som er sendt fra @example.com-adresser.',
        'Bounced to "%s".' => 'Avslått til «%s».',
        'Bulgarian' => 'Bulgarsk',
        'Bulk Action' => 'Masseredigering',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD - eksempel på oppsett. Ignorerer e-post hvor ekstern CMD returnerer noe som helst til STDOUT (e-posten vil bli "pipet" til kommandoen STDIN).',
        'CSV Separator' => 'CSV-separator',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Buffertid i sekunder for agentautentisering i GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Buffertid i sekunder for kundeautentisering i GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Buffertid i sekunder for DB ACL-backend.',
        'Cache time in seconds for the DB process backend.' => 'Buffertid i sekunder for DB-prosessens backend.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Buffertid i sekunder for SSL-sertifikatattributtene.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Hurtigbuffertid i sekunder for utdatamodulen for saksprosessens navigasjonslinje.',
        'Cache time in seconds for the web service config backend.' => 'Buffertid i sekunder for nettjenestens konfigurasjonsbackend.',
        'Calendar manage screen.' => 'Side for kalenderadministrasjon.',
        'Cancel whole escalation if ticket is in configured suspend state (EscalationSuspendStates). Ticket will not escalate at all in configured suspend state. No escalation times are shown. Ticket will not be shown in escalation view.' =>
            'Avbryt hele eskaleringen hvis saken er i konfigurert suspenderingstilstand (EscalationSuspendStates). Saken vil ikke eskalere i det hele tatt i konfigurert suspenderingstilstand. Ingen eskaleringstider vises. Saken vil ikke vises i eskaleringsvisning.',
        'Catalan' => 'Katalansk',
        'Categories used in ticket presentation. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'Kategorier brukt i sakspresentasjon. Hvis ingen standardfarge er gitt, vil ikke elementet vises hvis valget ikke er definert i fargehashen. Eventuelt kan attributtet Text legges til for å overstyre feltverdien, malmetoder kan brukes (f.eks. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link kan brukes på samme måte.',
        'Categories used in ticket presentation. Order is only used to determine the starting position before size arrangement. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'Kategorier brukt i sakspresentasjon. Ordren brukes kun til å bestemme startposisjon før størrelsesarrangement. Hvis ingen standardfarge er gitt, vil ikke elementet vises hvis valget ikke er definert i fargehashen. Eventuelt kan attributtet Text legges til for å overstyre feltverdien, malmetoder kan brukes (f.eks. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link kan brukes på samme måte.',
        'Change Ticket' => 'Bytt sak',
        'Change Ticket information' => 'Endre saksinformasjon',
        'Change queue!' => 'Endre kø!',
        'Change the customer for this ticket' => 'Bytt kunde for denne saken',
        'Change the owner for this ticket' => 'Bytt eier av denne saken',
        'Change the priority for this ticket' => 'Bytt prioriteten på denne saken',
        'Change the responsible for this ticket' => 'Endre ansvarlig for denne saken',
        'Change your avatar image.' => 'Endre avatarbildet ditt.',
        'Change your password and more.' => 'Endre passordet ditt og mer.',
        'Changed SLA to "%s" (%s).' => 'Endret SLA til "%s" (%s).',
        'Changed archive state to "%s".' => 'Endret arkivstatus til "%s".',
        'Changed customer to "%s".' => 'Endret kunde til "%s".',
        'Changed dynamic field %s from "%s" to "%s".' => 'Endret dynamisk felt %s fra "%s" til "%s".',
        'Changed owner to "%s" (%s).' => 'Endret eier til "%s" (%s).',
        'Changed pending time to "%s".' => 'Endret ventetid til "%s".',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Endret prioritet fra «%s» (%s) til «%s» (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => 'Endret kø til "%s" (%s) fra "%s" (%s).',
        'Changed responsible to "%s" (%s).' => 'Endret ansvarlig til "%s" (%s).',
        'Changed service to "%s" (%s).' => 'Endret tjeneste til "%s" (%s).',
        'Changed state from "%s" to "%s".' => 'Endret tilstand fra "%s" til "%s".',
        'Changed title from "%s" to "%s".' => 'Endret tittel fra "%s" til "%s".',
        'Changed type from "%s" (%s) to "%s" (%s).' => 'Endret type fra "%s" (%s) til "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Endrer eier på saker til "alle" (brukbart for ASP). Normalt vil kun saksbehandlere med Les/skriv-tilgang til køen bli vist.',
        'Chat communication channel.' => 'Chat kommunikasjonskanal.',
        'Checkbox' => 'Avkryssningsfelt',
        'Checks for articles that needs to be updated in the article search index.' =>
            'Sjekker etter artikler som må oppdateres i artikkelsøkeindeksen.',
        'Checks for communication log entries to be deleted.' => 'Sjekker for kommunikasjonsloggoppføringer som skal slettes.',
        'Checks for queued outgoing emails to be sent.' => 'Sjekker for utgående e-post i kø som skal sendes.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Sjekker om en e-post er en oppfølging av en eksisterende sak ved å søke i emnet etter et gyldig saksnummer.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            'Sjekker om en e-post er en oppfølging av en eksisterende sak med eksternt saksnummer som kan finnes av ExternalTicketNumberRecognition filtermodul.',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            'Sjekker SystemID i saksnummerdeteksjon for oppfølging. Hvis den ikke er aktivert, vil SystemID endres etter bruk av systemet.',
        'Child' => 'Barn',
        'Chinese (Simplified)' => 'Kinesisk (Forenklet)',
        'Chinese (Traditional)' => 'Kinesisk (Tradisjonell)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Velg hvilke typer avtaler som du vil motta varsler om.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Velg hvilken type saksendringer du ønsker å motta varsler om. Vær oppmerksom på at du ikke kan deaktivere varsler merket som obligatoriske fullstendig.',
        'Choose which notifications you\'d like to receive.' => 'Velg hvilke varsler du vil motta.',
        'Christmas Eve' => 'Julaften',
        'Close this ticket' => 'Lukk denne saken',
        'Closed Tickets' => 'Stengte saker',
        'Closed tickets (customer user)' => 'Lukkede saker (kundebruker)',
        'Closed tickets (customer)' => 'Avsluttede saker (kunde)',
        'Cloud Services' => 'Skytjenester',
        'Cloud service admin module registration for the transport layer.' =>
            'Cloud service admin modul registrering for transportlaget.',
        'Collect support data for asynchronous plug-in modules.' => 'Samle støttedata for asynkrone plug-in-moduler.',
        'Color definitions for Agent interface highcontrast skin.' => '',
        'Color definitions for Customer Interface highcontrast skin.' => '',
        'Color definitions for the agent interface (default skin). MainDark, -Light and Hover are the navigation background, buttons and some other main elements. Highlight are e.g. icons and selected elements in the navbar. BG- and Text colors are various background, and text colors. Hover colors are used in selections and tables. Notify colors are the background of notifications.' =>
            '',
        'Color definitions for the customer interface.' => 'Fargedefinisjoner for kundegrensesnittet.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Kolonnesaksfiltre for saksoversikter type "Liten".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i eskaleringsvisningen til agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i den låste visningen av agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i køvisningen til agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i den ansvarlige visningen av agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i tjenestevisningen til agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i statusvisningen til agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i sakssøkeresultatvisningen i agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Kolonner som kan filtreres i vaktvisningen til agentgrensesnittet. Merk: Bare saksattributter, dynamiske felt (DynamicField_NameX) og kundeattributter (f.eks. CustomerUserPhone, CustomerCompanyName, ...) er tillatt.',
        'Comment for new history entries in the customer interface.' => 'Kommentar for nye historiske innlegg i kundeportalen.',
        'Comment2' => 'Kommentar2',
        'Communication' => 'Kommunikasjon',
        'Communication & Notifications' => 'Kommunikasjon og varsler',
        'Communication Log GUI' => 'Kommunikasjonslogg GUI',
        'Communication log limit per page for Communication Log Overview.' =>
            'Kommunikasjonslogggrense per side for kommunikasjonsloggoversikt.',
        'CommunicationLog Overview Limit' => 'Kommunikasjonslogg Oversiktsgrense',
        'Company Status' => 'Bedriftstatus',
        'Company Tickets.' => 'Firmasaker.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Firmanavn som vil bli inkludert i utgående e-poster som en X-Header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Kompat modul for AgentZoom til AgentTicketZoom.',
        'Complex' => 'Kompleks',
        'Compose' => 'Forfatt',
        'Configure Processes.' => 'Konfigurer prosesser.',
        'Configure and manage ACLs.' => 'Konfigurer og administrere ACLer.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Konfigurer eventuelle ekstra skrivebeskyttede speildatabaser du vil bruke.',
        'Configure sending of support data to OTOBO Team for improved support.' =>
            'Konfigurer sending av støttedata til OTOBO Team for forbedret støtte.',
        'Configure the About information.' => 'Konfigurer Om-informasjonen.',
        'Configure the privacy policy.' => 'Konfigurer personvernreglene.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Konfigurer hvilken skjerm som skal vises etter at en ny sak er opprettet.',
        'Configure your own log text for PGP.' => 'Sett opp din egen loggtekst for PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otobo.org/), chapter "Ticket Event Module".' =>
            'Konfigurerer en standard TicketDynamicField-innstilling. "Navn" definerer det dynamiske feltet som skal brukes, "Verdi" er dataene som skal settes, og "Hendelse" definerer utløserhendelsen. Vennligst sjekk utviklerhåndboken (https://doc.otobo.org/), kapittel "Sakshendelsesmodul".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Styrer hvordan sakshistorikkoppføringene skal vises som lesbare verdier.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'Kontrollerer om KundeID automatisk kopieres fra avsenderadressen for ukjente kunder.',
        'Controls if CustomerID is read-only in the agent interface.' => 'Kontrollerer om CustomerID er skrivebeskyttet i agentgrensesnittet.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Gir kunder mulighet til å sortere sakene sine.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontrollerer om mer enn én fra oppføring kan settes i den nye telefonsaken i agentgrensesnittet.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Kontrollerer om administratoren har tillatelse til å importere en lagret systemkonfigurasjon i SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Kontrollerer om admin har lov til å gjøre endringer i databasen via AdminSelectBox.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            'Kontrollerer om autofullføringsfeltet skal brukes for valg av kunde-ID i AdminCustomerUser-grensesnittet.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontrollerer om flaggene for saken og artikkelen skal fjernes når en sak arkiveres.',
        'Converts HTML mails into text messages.' => 'Konverter HTML e-poster til tekstmeldinger.',
        'Create New process ticket.' => 'Opprett ny prosesssak.',
        'Create Templates for AdminDynamicFieldTitle.' => 'Lag maler for AdminDynamicFieldTitle.',
        'Create Ticket' => 'Lag sak',
        'Create a new calendar appointment linked to this ticket' => 'Opprett en avtale somer koblet til denne saken',
        'Create and manage Service Level Agreements (SLAs).' => 'Administrasjon av Tjenestenivåavtaler (SLAer).',
        'Create and manage advanced definitions for ticket masks.' => '',
        'Create and manage agents.' => 'Administrasjon av saksbehandlere.',
        'Create and manage appointment notifications.' => 'Administrasjon av avtalevarslinger.',
        'Create and manage attachments.' => 'Administrasjon av vedlegg.',
        'Create and manage calendars.' => 'Opprett og administrer kalendere.',
        'Create and manage custom translations.' => '',
        'Create and manage customer users.' => 'Administrasjon av kundebrukere.',
        'Create and manage customers.' => 'Administrasjon av kunder.',
        'Create and manage dynamic fields.' => 'Administrasjon av dynamiske felter.',
        'Create and manage groups.' => 'Administrasjon av grupper.',
        'Create and manage queues.' => 'Administrasjon av køer.',
        'Create and manage responses that are automatically sent.' => 'Administrasjon av autosvar.',
        'Create and manage roles.' => 'Administrasjon av roller.',
        'Create and manage salutations.' => 'Administrasjon av hilsener.',
        'Create and manage services.' => 'Administrasjon av tjenester.',
        'Create and manage signatures.' => 'Administrasjon av signaturer.',
        'Create and manage templates.' => 'Lag og administrer maler.',
        'Create and manage ticket notifications.' => 'Opprett og administrer saksvarsler.',
        'Create and manage ticket priorities.' => 'Administrasjon av sakprioriteringer.',
        'Create and manage ticket states.' => 'Administrasjon av status på saker.',
        'Create and manage ticket types.' => 'Administrasjon av sakstyper.',
        'Create and manage web services.' => 'Administrasjon av web tjenester.',
        'Create new Ticket.' => 'Opprett ny sak.',
        'Create new appointment.' => 'Opprett en ny avtale.',
        'Create new email ticket and send this out (outbound).' => 'Opprett ny e-postsak og send denne ut (utgående).',
        'Create new email ticket.' => 'Opprett ny e-postsak.',
        'Create new phone ticket (inbound).' => 'Opprett ny telefonsak (inngående).',
        'Create new phone ticket.' => 'Opprett ny telefonsak.',
        'Create new process ticket.' => 'Opprett ny prosesssak.',
        'Create tickets.' => 'Lag saker.',
        'Create your first ticket' => 'Opprett din første sak',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            'Opprettet sak [%s] i "%s" med prioritet "%s" og tilstanden "%s".',
        'Croatian' => 'Kroatisk',
        'Custom RSS Feed' => 'Egendefinert RSS Feed',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Egendefinert tekst for siden som vises til kunder som ikke har saker ennå (hvis du trenger teksten oversatt, legg dem til i en tilpasset oversettelsesmodul).',
        'Customer Administration' => 'Kundeadministrasjon',
        'Customer Companies' => 'Kundefirma',
        'Customer Dashboard' => 'Kunde Dashboard',
        'Customer Dynamic Field Database Detailed Search' => 'Kundens dynamiske feltdatabase detaljert søk',
        'Customer Dynamic Field Database Details' => 'Kundens dynamiske feltdatabasedetaljer',
        'Customer Dynamic Field Database Search' => 'Kundens dynamiske feltdatabasesøk',
        'Customer IDs' => 'Kunde-IDer',
        'Customer Information Center Search.' => 'Søk etter kundeinformasjonssenter.',
        'Customer Information Center search.' => 'Søk i kundeinformasjonssenter.',
        'Customer Information Center.' => 'Kundeinformasjonssenter.',
        'Customer Password.' => 'Kundepassord.',
        'Customer Reference Dynamic Field With Data Search' => '',
        'Customer Ticket Print Module.' => 'Kundesaksutskriftsmodul.',
        'Customer User Administration' => 'Kundebrukeradministrasjon',
        'Customer User Information' => 'Kundebrukerinformasjon',
        'Customer User Information Center Search.' => 'Søk etter kundeinformasjonssenter.',
        'Customer User Information Center search.' => 'Søk etter kundeinformasjonssenter.',
        'Customer User Information Center.' => 'Kundebrukerinformasjonssenter.',
        'Customer Users ↔ Customers' => 'Kundebrukere ↔ Kunder',
        'Customer Users ↔ Groups' => 'Kundebrukere ↔ Grupper',
        'Customer Users ↔ Services' => 'Kundebrukere ↔ Tjenester',
        'Customer dynamic field database detailed search.' => 'Kunde dynamisk feltdatabase detaljert søk.',
        'Customer dynamic field database details.' => 'Kundens dynamiske feltdatabasedetaljer.',
        'Customer dynamic field database search.' => 'Kunde dynamisk feltdatabasesøk.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kundeelement (ikon) som viser de lukkede sakene til denne kunden som infoblokk. Sette CustomerUserLogin til 1 søk etter saker basert på påloggingsnavn i stedet for kunde-ID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kundeelement (ikon) som viser de åpne sakene til denne kunden som infoblokk. Sette CustomerUserLogin til 1 søk etter saker basert på påloggingsnavn i stedet for kunde-ID.',
        'Customer preferences.' => 'Kundens preferanser.',
        'Customer reference dynamic field with data search.' => '',
        'Customer ticket overview' => 'Kundesaksoversikt',
        'Customer ticket search.' => 'Kundesakssøk.',
        'Customer ticket zoom' => 'Kundesakszoom',
        'Customer user search' => 'Kundebrukersøk',
        'CustomerCompany' => '',
        'CustomerDashboard Info Tile' => '',
        'CustomerID search' => 'Kunde-ID-søk',
        'CustomerName' => 'Kundenavn',
        'CustomerUser' => 'KundeBruker',
        'Customers ↔ Groups' => 'Kunder ↔ Grupper',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'Tilpassbare stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Czech' => 'Tjekkisk',
        'Danish' => 'Dansk',
        'Dashboard overview.' => 'Oversikt over dashbord.',
        'Data used to export the search result in CSV format.' => 'Data brukt for å eksportere søkeresultatet i CSV-format.',
        'Date / Time' => 'Dato / Tid',
        'Default (Slim)' => 'Standard (slank)',
        'Default ACL values for ticket actions.' => 'Standard ACL-verdier for sakshendelser.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Standard ProcessManagement-enhetsprefikser for enhets-ID-er som genereres automatisk.',
        'Default agent name' => 'Standard agentnavn',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Standarddata som skal brukes på attributt for sakssøkeskjermen. Eksempel: "TicketCreateTimePointFormat=år;TicketCreateTimePointStart=Siste;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Standarddata som skal brukes på attributt for sakssøkeskjermen. Eksempel: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Standard visningstype for mottakernavn (Til, Kopi) i AgentTicketZoom og CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Standard visningstype for avsendernavn (Fra) i AgentTicketZoom og CustomerTicketZoom.',
        'Default loop protection module.' => 'Standard loop-beskyttelsesmodul.',
        'Default queue ID used by the system in the agent interface.' => 'Standard køID brukt av systemet for saksbehandlere.',
        'Default skin for the agent interface (slim version).' => 'Standard tema for agentgrensesnittet (slank versjon).',
        'Default skin for the agent interface.' => 'Standard tema for agentgrensesnittet.',
        'Default skin for the customer interface.' => 'Standard tema for kundegrensesnittet.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Standard Saksnr brukt av systemet i saksbehandler-delen.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Standard Saksnr brukt av systemet i kundeportalen.',
        'Default value for NameX' => 'Standardverdi for NavnX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Definer handlinger der en innstillingsknapp er tilgjengelig i widgeten for koblede objekter (LinkObject::ViewMode = "complex"). Vær oppmerksom på at disse handlingene må ha registrert følgende JS- og CSS-filer: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Sett et filter for HTML-visning som legger til lenker bak en gitt tekst. Bildeelementet tillater to typer inn-data. For det første navnet på et bilde (f.eks. bilde01.png). I det tilfellet vil OTOBO sin bilde-sti brukes. Den andre muligheten er å skrive inn URL til bildet.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            'Definer en tilordning mellom variabler av kundens brukerdata (nøkler) og dynamiske felt for en sak (verdier). Formålet er å lagre kundebrukerdata i saksdynamiske felt. De dynamiske feltene må være tilstede i systemet og bør være aktivert for AgentTicketFreeText, slik at de kan settes/oppdateres manuelt av agenten. De må ikke være aktivert for AgentTicketPhone, AgentTicketEmail og AgentTicketCustomer. Hvis de var det, ville de ha forrang over de automatisk innstilte verdiene. For å bruke denne tilordningen må du også aktivere Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser-innstillingen.',
        'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).' =>
            'Definer et resultatfelt for TicketID for invoker-svaret per webtjeneste (WebserviceID => DynamicFieldName).',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definer dynamisk feltnavn for sluttid. Dette feltet må manuelt legges til systemet som sak: "Dato / klokkeslett" og må aktiveres i saksopprettingsskjermer og/eller i andre sakshandlingsskjermer.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definer dynamisk feltnavn for starttid. Dette feltet må manuelt legges til systemet som sak: "Dato / klokkeslett" og må aktiveres i saksopprettingsskjermer og/eller i andre sakshandlingsskjermer.',
        'Define possible namespaces for dynamic fields. Must only contain alphanumeric characters.' =>
            '',
        'Define the max depth of queues.' => 'Definer maksimal dybde på køer.',
        'Define the queue comment 2.' => 'Definer køkommentaren 2.',
        'Define the service comment 2.' => 'Definer tjenestekommentaren 2.',
        'Define the sla comment 2.' => 'Definer sla-kommentaren 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Definer startdagen i uken for datovelgeren for den angitte kalenderen.',
        'Define the start day of the week for the date picker.' => 'Setter dag for ukestart i datovelgeren.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Definer hvilket avatar-standardbilde som skal brukes for artikkelvisningen hvis ingen gravatar er tilordnet e-postadressen. Sjekk https://gravatar.com/site/implement/images/ for mer informasjon.',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Definer hvilket avatar-standardbilde som skal brukes for gjeldende agent hvis ingen gravatar er tilordnet e-postadressen til agenten. Sjekk https://gravatar.com/site/implement/images/ for mer informasjon.',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            'Definer hvilken avatarmotor som skal brukes for agentavataren på overskriften og avsenderbildene i AgentTicketZoom. Hvis \'Ingen\' er valgt, vil initialer vises i stedet. Vær oppmerksom på at hvis du velger noe annet enn "Ingen", overføres den krypterte e-postadressen til den aktuelle brukeren til en ekstern tjeneste.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Definer hvilke kolonner som skal vises i den koblede avtalewidgeten (LinkObject::ViewMode = "complex"). Mulige innstillinger: 0 = Deaktivert, 1 = Tilgjengelig, 2 = Aktivert som standard.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Definer hvilke kolonner som vises i den koblede sak-widgeten (LinkObject::ViewMode = "complex"). Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et LinkedIn-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et XING-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et Google-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definferer et kundeelement som lager et Google Maps-symbol på slutten av kunde-info-blokken.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning for å legge til lenker bak CVE-nummer. Bilde-elementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTOBO vil gå utfra at bildet ligger i OTOBO sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter i HTML-visningen for å legge til lenker bak MSBulletin-nummer. Bildeelementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTOBO vil gå utfra at bildet ligger i OTOBO sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning som legger til lenker bak en definert tekst. Bilde-elementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTOBO vil gå utfra at bildet ligger i OTOBO sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning som legger til lenker bak BugTraq-numre. Bilde-elementet tillater to typer inn-data. Enten navnet på en bildefil (f.eks. bilde01.png), der OTOBO vil gå utfra at bildet ligger i OTOBO sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Definerer et filter for å samle inn CVE-nummer fra artikkeltekster i AgentTicketZoom. Resultatene vil vises i en metaboks ved siden av artikkelen. Fyll inn URLPreview hvis du vil se en forhåndsvisning når du flytter musepekeren over lenkeelementet. Dette kan være samme URL som i URL, men også en alternativ. Vær oppmerksom på at enkelte nettsteder nekter å bli vist innenfor en iframe (f.eks. Google) og vil derfor ikke fungere med forhåndsvisningsmodus.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definerer et filter som prosesserer teksten i innlegg for å markere predefinerte nøkkelord.',
        'Defines a permission context for customer to group assignment.' =>
            'Definerer en tillatelseskontekst for kunde til gruppetildeling.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definerer en Regulær-uttrykk-setning som ekskluderer adresser fra syntaks-sjekken (hvis "sjekk e-postadresser" er satt til Ja). Skriv inn en Regulær-uttrykk-setning for e-postadresser som ikke er syntaktisk korrekte, men som er viktige for systemet (f.eks. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definerer en Regulær-uttrykk -setning som filtrerer ut alle e-postadresser som ikke skal brukes i systemet.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Definerer en søvntid i mikrosekunder mellom saker mens de blir behandlet av en jobb.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definerer en modul for å laste spesifikke brukerinnstillinger eller for å vise nyheter.',
        'Defines all the X-headers that should be scanned.' => 'Definerer at alle X-hode-feltene som skal skannes.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Definerer alle språkene som er tilgjengelige for applikasjonen. Spesifiser kun engelske navn på språk her.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Definerer alle språkene som er tilgjengelige for applikasjonen. Spesifiser kun innfødte navn på språk her.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definerer alle parametre for gjenoppfriskning i kundeportalen.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definerer alle parametre for viste saker i kundeportalen.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definerer alle parametre for dette objektet i kunde-oppsettet.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Definerer alle parametere for denne varen i kundepreferansene. \'PasswordRegExp\' lar deg matche passord mot et regulært uttrykk. Definer minimum antall tegn ved å bruke \'PasswordMinSize\'. Definer om minst 2 små og 2 store bokstaver trengs ved å sette det aktuelle alternativet til \'1\'. \'PasswordMin2Characters\' definerer om passordet må inneholde minst 2 bokstaver (sett til 0 eller 1). \'PasswordNeedDigit\' kontrollerer behovet for minst 1 siffer (sett til 0 eller 1 for å kontrollere).',
        'Defines all the parameters for this notification transport.' => 'Definerer alle parametere for denne varslingstransporten.',
        'Defines all the possible stats output formats.' => 'Definerer alle mulige formater for statistikk.',
        'Defines an alternate URL, where the login link refers to.' => 'Definerer en alternativ URL som Innloggingslenken skal peke til.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definerer en alternativ URL som skal logge ut brukeren.',
        'Defines an alternate login URL for the customer panel.' => '',
        'Defines an alternate logout URL for the customer panel.' => 'Alternativ URL for ut-logging av kunder.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Definerer en ekstern lenke til databasen til kunden (f.eks. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' eller \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'Definerer et ikon med lenke til Google-kartsiden for gjeldende plassering i avtaleredigeringsskjermen.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'Definerer en oversiktsmodul for å vise adressebokvisningen til en kundebrukerliste.',
        'Defines available article actions for Chat articles.' => 'Definerer tilgjengelige artikkelhandlinger for Chat-artikler.',
        'Defines available article actions for Email articles.' => 'Definerer tilgjengelige artikkelhandlinger for e-postartikler.',
        'Defines available article actions for Internal articles.' => 'Definerer tilgjengelige artikkelhandlinger for interne artikler.',
        'Defines available article actions for Phone articles.' => 'Definerer tilgjengelige artikkelhandlinger for telefonartikler.',
        'Defines available article actions for invalid articles.' => 'Definerer tilgjengelige artikkelhandlinger for ugyldige artikler.',
        'Defines available groups for the admin overview screen.' => 'Definerer tilgjengelige grupper for administrasjonsoversiktsskjermen.',
        'Defines chat communication channel.' => 'Definerer chat kommunikasjonskanal.',
        'Defines default headers for outgoing emails.' => 'Definerer standard overskrifter for utgående e-post.',
        'Defines email communication channel.' => 'Definerer e-postkommunikasjonskanal.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definerer fra hvilke saksattributter agenten kan velge resultatrekkefølgen.',
        'Defines groups for preferences items.' => 'Definerer grupper for preferanseelementer.',
        'Defines how many deployments the system should keep.' => 'Definerer hvor mange distribusjoner systemet skal beholde.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definerer hvordan Fra-feltet på e-poster (sendt som svar eller e-post-saker) skal se ut.',
        'Defines if CSV-mappings are re-created on next package reinstallation or upgrade if already existent.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Definerer om en forhåndssortering etter prioritet skal gjøres i køvisningen.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Definerer om en forhåndssortering etter prioritet skal gjøres i tjenestevisningen.',
        'Defines if a ticket lock is required for the quick close.' => 'Definerer om en sakslås er nødvendig for hurtiglukkingen.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en saks-lås er nødvendig for å få stenge en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent vil bli satt som eier.',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definerer om det kreves en sakslås i utgående e-postskjerm i agentgrensesnittet (hvis saken ikke er låst ennå, blir saken låst og gjeldende agent vil automatisk bli satt som eier).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definerer om en sakslås kreves i skjermbildet for e-postsending på nytt i agentgrensesnittet (hvis saken ikke er låst ennå, blir saken låst og gjeldende agent blir automatisk satt som eier).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en saks-lås er nødvendig for å oversende en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å opprette en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å videresende en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i fritekstvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for saksfletting. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i notisvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i sakseier-vinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i "På vent"-vinduet. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definerer om det kreves en sakslås på sakstelefonens inngående skjerm i agentgrensesnittet (hvis saken ikke er låst ennå, blir saken låst og gjeldende agent blir automatisk satt som eier).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i "Utgående Telefon"-skjermen til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i prioritetsvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i ansvarlig-vinduet. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å endre kunden på en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Definerer om agenter skal ha tillatelse til å logge på hvis de ikke har noen delt hemmelighet lagret i sine preferanser og derfor ikke bruker tofaktorautentisering.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Definerer om kunder skal få lov til å logge på hvis de ikke har noen delt hemmelighet lagret i preferansene sine og derfor ikke bruker tofaktorautentisering.',
        'Defines if the communication between this system and the servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as support data sending, Package Verify™ and product News dashboard widgets, among others.' =>
            'Definerer om kommunikasjonen mellom dette systemet og serverne som leverer skytjenester er mulig. Hvis satt til \'Deaktiver skytjenester\', vil noe funksjonalitet gå tapt, for eksempel støttedatasending, Package Verify™ og produktnyheter-dashboard-widgeter, blant annet.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'Definerer om den forbedrede modusen skal brukes (muliggjør bruk av tabell, erstat, subscript, hevet skrift, lim inn fra word, etc.) i kundegrensesnittet.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Definerer om den forbedrede modusen skal brukes (muliggjør bruk av tabell, erstatt, senket, hevet skrift, lim inn fra word, etc.).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            'Definerer om den første artikkelen skal vises som utvidet, som er synlig for den relaterte kunden. Hvis ingenting er definert, vil siste artikkel bli utvidet.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            'Definerer om meldingen i skjermbildet for utgående e-post i agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            'Definerer om meldingen i skjermbildet for e-postsending på nytt i agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            'Definerer om meldingen i saksskrivingsskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            'Definerer om meldingen i saksvideresendingsskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i skjermbildet for lukke sak i agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i saksmasseskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i saksfritekstskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i sakslappskjermbildet til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i sakseierskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i skjermbildet for ventende sak i agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i saksprioritetsskjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            'Definerer om notatet i saksansvarlig-skjermen til agentgrensesnittet er synlig for kunden som standard.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Definerer om det tidligere gyldige tokenet skal aksepteres for autentisering. Dette er litt mindre sikkert, men gir brukerne 30 sekunder mer tid til å skrive inn engangspassordet sitt.',
        'Defines if the ticket info widget is displayed permanently on the left below the article list or is available via click on the \'Information\' button.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'Definerer om verdiene for filtre skal hentes fra alle tilgjengelige saker. Hvis aktivert, vil bare verdier som faktisk brukes i en sak være tilgjengelig for filtrering. Merk: Listen over kunder vil alltid bli hentet slik.',
        'Defines if time accounting is mandatory in the agent interface, if a note is entered.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Definerer om tidsregnskap må settes til alle saker i bulkhandling.',
        'Defines if user can modify all possible values/labels of dynamic fields in one data table.' =>
            '',
        'Defines internal communication channel.' => 'Definerer intern kommunikasjonskanal.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Definerer fraværsmeldingsmal. To strengparametere (%s) tilgjengelig: sluttdato og antall dager igjen.',
        'Defines phone communication channel.' => 'Definerer telefonkommunikasjonskanal.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Definerer køer som saker brukes for visning som kalenderhendelser.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Definerer HTTP-vertsnavnet for støttedatainnsamlingen med den offentlige modulen \'PublicSupportDataCollector\' (f.eks. brukt fra OTOBO-demonen).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Spesifiserer Regulær-uttrykk for IPen til lokalt pakkelager. Du må slå dette på for å ha tilgang til ditt lokale pakkelager. I tillegg er package::RepositoryList påkrevd på andre tjenere.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'Definerer PostMaster-overskriften som skal brukes på filteret for å beholde gjeldende status for saken.',
        'Defines the URL CSS path.' => 'Definerer URL til CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definerer URL som basesti for icons, CSS og JavaScript.',
        'Defines the URL image path of icons for navigation.' => 'Definerer URL for bildesti til navigasjons-icons.',
        'Defines the URL java script path.' => 'Definerer URL til JavaScript-filer.',
        'Defines the URL rich text editor path.' => 'Definerer URL til Rik Tekst-redigereren.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definerer en dedikert DNS-tjener å bruke, hvis nødvendig, for å gjøre MX-sjekk på e-postadresser.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Definerer nøkkelen for agentpreferanser der den delte hemmelige nøkkelen er lagret.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            'Definerer de tilgjengelige trinnene i tidsvalg. Velg "Minutt" for å kunne velge alle minuttene på en time fra 1-59. Velg "30 minutter" for kun å gjøre hele og halve timer tilgjengelig.',
        'Defines the body for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Definerer kroppen for den raske lukkehandlingen, som blir brukt til sakshistorikk i agentgrensesnittet.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            'Definerer brødteksten for varslingsposter sendt til agenter om nytt passord.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            'Definerer brødteksten for varslingsposter sendt til agenter, med token om nytt forespurt passord.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definerer meldingsteksten sent til nye kunder når kontoen blir opprettet.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            'Definerer brødteksten for varslingsposter sendt til kunder, om nytt passord.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            'Definerer brødteksten for varslingsposter sendt til kunder, med token om nytt forespurt passord.',
        'Defines the body text for rejected emails.' => 'Meldingstekst for avviste e-poster.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definerer kalenderbredden i prosent. Standard er 95 %.',
        'Defines the close state for quick close.' => 'Definerer lukketilstanden for hurtiglukking.',
        'Defines the column to store the keys for the preferences table.' =>
            'Definerer hvilken kolonne som skal brukes for å lagre nøkler til valgtabellen.',
        'Defines the communication chanel for the quick close article action.' =>
            'Definerer kommunikasjonskanalen for rask lukking av artikkelhandlingen.',
        'Defines the config options for the autocompletion feature.' => 'Definerer konfigurasjonsalternativene for autofullføringsfunksjonen.',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketSeenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketUnseenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definerer parametrene som skal vises i Innstillinger for dette objektet.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definerer konfigurasjonsparametrene for dette elementet, som skal vises i preferansevisningen. \'PasswordRegExp\' lar deg matche passord mot et regulært uttrykk. Definer minimum antall tegn ved å bruke \'PasswordMinSize\'. Definer om minst 2 små og 2 store bokstaver trengs ved å sette det aktuelle alternativet til \'1\'. \'PasswordMin2Characters\' definerer om passordet må inneholde minst 2 bokstaver (sett til 0 eller 1). \'PasswordNeedDigit\' kontrollerer behovet for minst 1 siffer (sett til 0 eller 1 for å kontrollere). \'PasswordMaxLoginFailed\' tillater å sette en agent til ugyldig-midlertidig hvis maksimalt antall mislykkede pålogginger nås. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definerer konfigurasjonsparametrene for dette elementet, som skal vises i preferansevisningen. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Defines the connections for http/ftp, via a proxy.' => 'Spesifiserer proxy-oppsett for http/ftp.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Definerer kundepreferansenøkkelen der den delte hemmelige nøkkelen er lagret.',
        'Defines the data objects avaliable to be translated.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            'Spesifiserer datoformat på skjema (valg- eller tekstfelter).',
        'Defines the default CSS for creating CKEditor articles.' => '',
        'Defines the default CSS used for displaying articles.' => '',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            'Definerer standard agentnavn i sakszoomvisningen i kundegrensesnittet.',
        'Defines the default auto response type of the article for this operation.' =>
            'Definerer standard autoresponstype for artikkelen for denne operasjonen.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Spesifiserer standardinnholdet for notiser i sakens fritekstdel for saksbehandlere.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            'Definerer standard filterfelt i kundebrukeradresseboksøket (CustomerUser eller CustomerCompany). For CustomerCompany-feltene må et prefiks \'CustomerCompany_\' legges til.',
        'Defines the default frontend (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otobo.org/.' =>
            'Definerer standard frontend (HTML)-temaet som skal brukes av agenter og kunder. Hvis ønskelig, kan du legge til ditt eget tema. Vennligst se administratormanualen som ligger på https://doc.otobo.org/.',
        'Defines the default frontend language. All the possible values are determined by the available language files on the system. These values are listed as the keys in the setting \'DefaultUsedLanguages\'.' =>
            'Definerer standard frontend-språket. Alle mulige verdier bestemmes av de tilgjengelige språkfilene på systemet. Disse verdiene er oppført som nøklene i innstillingen \'DefaultUsedLanguages\'.',
        'Defines the default history type in the customer interface.' => 'Spesifiserer standard historikkvisning i kundeportalen.',
        'Defines the default interface. Unknown pathes below the script alias are redirected to the selected interface.' =>
            'Definerer standardgrensesnittet. Ukjente stier under skriptaliaset blir omdirigert til det valgte grensesnittet.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Setter standardverdi for maks. antall atributter på X-aksen for tidsskalaen.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Definerer standard maksimalt antall statistikk per side på oversiktsskjermen.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Definerer standard neste tilstand for en sak etter kundeoppfølging i kundegrensesnittet.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Setter standardverdi for neste status etter å ha lagt til en notis når man stenger en sak i agentdelen.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Setter standardverdi for neste status etter å ha lagt til en notis i sakens fritekstside i agentdelen.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Setter standardverdi for neste status når agent legger til en notis under interne notater.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste saksstatus når agent legger til en notis i eier-delen.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste status for en sak etter å ha lagt til en notis i avventingsdelen av agents saksvisning.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis og endret prioritet på en sak.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis under saksansvar.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis for en sak som blir avvist.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Definerer standard for neste saksstatus når agent videresender en sak.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Definerer standard neste tilstand for en sak etter at meldingen er sendt, i skjermbildet for utgående e-post i agentgrensesnittet.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Setter standard for neste saksstatus når den blir opprettet/besvart av agent.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Definerer standard neste tilstand for en sak, i sak-bulkskjermen til agentgrensesnittet.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definerer standard notatbrødtekst for telefonsaker på sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definerer standard notistekst for utgående telefon-saker i agentdelen.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Definerer standardprioritet for oppfølging av kundesaker i sakszoomskjermen i kundegrensesnittet.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Setter standard prioritet på nye saker opprettet i kundeportalen.',
        'Defines the default priority of new tickets.' => 'Setter standard prioritet på nye saker.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Setter standardkø for nye saker opprettet i kundeportalen.',
        'Defines the default queue for new tickets in the agent interface.' =>
            'Definerer standardkøen for nye saker i agentgrensesnittet.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definerer standard forvalg i menyen for dynamiske objekter (Form: Common Specification).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Definerer standard forvalg i menyen for tilgangsrettigheter (Form: Common Specification).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Definerer standard forvalg i menyen for statistikkformat (Form: Common Specification). Vennligst skriv inn formatnøkkelen (se Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definerer standard avsendertype for telefonsaker i sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Setter standard sendertype for utgående telefonsaker i agentdelen.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Setter standard sendertype for saker i saksvisningen i kundeportalen.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Definerer standard vist sakssøkeattributt for sakssøkskjermen (AllTickets/ArchivedTickets/NotArchivedTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Definerer standard vist sakssøkeattributt for sakssøkskjermen.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Definerer standard vist sakssøkeattributt for sakssøkskjermen. Eksempel: "Nøkkel" må ha navnet på det dynamiske feltet i dette tilfellet \'X\', "Innhold" må ha verdien av det dynamiske feltet avhengig av typen dynamisk felt, tekst: \'en tekst\', rullegardin: \'1\' , Dato/klokkeslett: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' og eller \'Search_DynamicField_XTimePointFormat=uke; Search_DynamicField_XTimePointStart=Før; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Definerer standard sorteringskriterier for alle køer som vises i køvisningen.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Definerer standard sorteringskriterier for alle tjenester som vises i tjenestevisningen.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Definerer standard sorteringsrekkefølge for alle køer i køvisningen, etter at de er blitt sortert etter prioritet.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Definerer standard sorteringsrekkefølge for alle tjenester i tjenestevisningen, etter prioritert sortering.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definerer standard status for nye kundesaker opprettet i kundeportalen.',
        'Defines the default state of new tickets.' => 'Definerer standard status for nye saker.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definerer standardemnet for telefonsaker på sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definerer standardverdi for emnefeltet i skjermbildet for utgående telefonsak i agentbildet.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Definerer standardemnet for et notat i saksfritekstskjermen i agentgrensesnittet.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Definerer standard antall sekunder (fra gjeldende tidspunkt) for å omplanlegge en generisk grensesnitt mislykket oppgave.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Definerer standard saksattributt for sakssortering i et sakssøk i kundegrensesnittet.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering i eskaleringsvisningen til agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering i den låste saksvisningen i agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering i ansvarlig visning av agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering i statusvisningen til agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering i vaktvisningen til agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Definerer standard saksattributt for sakssortering av sakssøkeresultatet til agentgrensesnittet.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Definerer standard saksattributt for sakssortering av sakssøkeresultatet for denne operasjonen.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Definerer standard varsling for retur av sak for kunde/sender i skjermbildet for retur av sak i agentgrensesnittet.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Definerer standard saks neste tilstand etter å ha lagt til et telefonnotat i sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Definerer standard saks neste tilstand etter å ha lagt til en telefonnotat i sakstelefonens utgående skjerm i agentgrensesnittet.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge (etter de er sortert etter prioritet) i eskaleringsvisningen. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge (etter de er sortert etter prioritet) i statusvisningen. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i ansvarlig visning av agentgrensesnittet. Opp: eldst på toppen. Ned: siste på toppen.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i sakslåst visning av agentgrensesnittet. Opp: eldst på toppen. Ned: siste på toppen.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge for søkeresultater i agentbildet. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i sakssøkeresultatet for denne operasjonen. Opp: eldst på toppen. Ned: siste på toppen.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i vaktvisningen til agentgrensesnittet. Opp: eldst på toppen. Ned: siste på toppen.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i et søkeresultat i kundebildet. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Definerer standard saksprioritet i "avslutt sak"-skjermen i agentbildet.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Definerer standard saksprioritet i massesaksskjermen til agentgrensesnittet.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Definerer standard saksprioritet i saksfritekstskjermen til agentgrensesnittet.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Definerer standard saksprioritet i saksnotatskjermen til agentgrensesnittet.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard saksprioritet i sakseierskjermen for en zoomet sak i agentgrensesnittet.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard saksprioritet i saksventer-skjermen for en zoomet sak i agentgrensesnittet.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard saksprioritet i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Definerer standard saksprioritet i saksansvarlig skjerm i agentgrensesnittet.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Definerer standard sakstype for nye kundesaker i kundegrensesnittet.',
        'Defines the default ticket type.' => 'Definerer standard sakstype.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Definerer standard frontend-modul hvis ingen handlingsparameter er gitt i url-en på agentgrensesnittet.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Definerer standard frontend-modul hvis ingen handlingsparameter er gitt i url-en på kundegrensesnittet.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Definerer standardverdien for handlingsparameteren for den offentlige grensesnittet. Handlingsparameteren brukes i skriptene til systemet.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definerer standard synlige avsendertyper for en sak (standard: kunde).',
        'Defines the default visibility of the article to customer for this operation.' =>
            'Definerer standardsynlighet for artikkelen til kunden for denne operasjonen.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            'Definerer stilen som vises for Fra-feltet i notater som er synlige for kunder. Et standard agentnavn kan defineres i Ticket::Frontend::CustomerTicketZoom###DefaultAgentName-innstillingen.',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definerer de dynamiske feltene som brukes for visning på kalenderhendelser.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'Definerer hendelsesobjekttypene som skal håndteres via AdminAppointmentNotificationEvent.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Definerer reservebanen for å åpne fetchmail binær. Merk: Navnet på binærfilen må være "fetchmail", hvis det er annerledes, bruk en symbolsk lenke.',
        'Defines the filter that processes the HTML templates.' => 'Definerer filteret som behandler HTML-malene.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definerer filteret som behandler teksten i artiklene, for å fremheve URL-er.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Definerer formatet på svarene i saksskrivingsskjermen til agentgrensesnittet ([% Data.OrigFrom | html %] er fra 1:1, [% Data.OrigFromName | html %] er bare ekte navn på From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTOBO_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Definerer det fullt kvalifiserte domenenavnet til systemet. Denne innstillingen brukes som en variabel, OTOBO_CONFIG_FQDN som finnes i alle former for meldinger som brukes av applikasjonen, for å bygge lenker til sakene i systemet ditt.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            'Definerer gruppene hver kundebruker skal være i (hvis CustomerGroupSupport er aktivert og du ikke vil administrere hver kundebruker for disse gruppene).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            'Definerer gruppene hver kunde skal være i (hvis CustomerGroupSupport er aktivert og du ikke vil administrere hver kunde for disse gruppene).',
        'Defines the headers which will be shown to generic content for the requested key.' =>
            'Definerer overskriftene som skal vises til generisk innhold for den forespurte nøkkelen.',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definerer høyden for redigeringskomponenten for rik tekst for denne skjermen. Skriv inn tall (piksler) eller prosentverdi (relativ).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Definerer høyden for redigeringskomponenten for rik tekst. Skriv inn tall (piksler) eller prosentverdi (relativ).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen for lukke saksskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen for e-postsaksskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på telefonsaksskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Definerer historiekommentaren for handlingen på saksfritekstskjermen, som brukes til sakshistorikk.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på saksnotatskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på sakseierens skjerm, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på skjermbildet som venter på sak, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på sakstelefonens innkommende skjerm, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på sakstelefonens utgående skjerm, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på skjermbildet for saksprioritet, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for handlingen på den saksansvarlige skjermen, som brukes til sakshistorikken i agentgrensesnittet.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definerer historiekommentaren for sakszoomhandlingen, som brukes til sakshistorikk i kundegrensesnittet.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Definerer historiekommentaren for denne operasjonen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen for "lukk sak-skjermen", som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen for e-postsaksskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på telefonsaksskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Definerer historikktypen for handlingen for saksfritekstskjermen, som brukes til sakshistorikk.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på saksnotatskjermen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på skjermbildet for sakseier, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på skjermbildet som venter på sak, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på sakstelefonens inngående skjerm, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på sakstelefonens utgående skjerm, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for handlingen på skjermbildet for saksprioritet, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for den saksansvarlige skjermhandlingen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definerer historikktypen for sakszoomhandlingen, som brukes til sakshistorikk i kundegrensesnittet.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Definerer historikktypen for denne operasjonen, som brukes til sakshistorikk i agentgrensesnittet.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Definerer timene og ukedagene i den angitte kalenderen, for å telle arbeidstiden.',
        'Defines the hours and week days to count the working time.' => 'Definerer timer og ukedager som telles som arbeidstid.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Definerer nøkkelen som skal sjekkes med Kernel::Modules::AgentInfo-modulen. Hvis denne brukerpreferansenøkkelen er sann, godtas meldingen av systemet.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Definerer nøkkelen for å sjekke med CustomerAccept. Hvis denne brukerpreferansenøkkelen er sann, godtas meldingen av systemet.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definerer koblingstypen \'Normal\'. Hvis kildenavnet og målnavnet inneholder samme verdi, er den resulterende koblingen en ikke-retningsbestemt en; ellers er resultatet en retningskobling.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definerer koblingstypen \'Foreldrebarn\'. Hvis kildenavnet og målnavnet inneholder samme verdi, er den resulterende koblingen en ikke-retningsbestemt en; ellers er resultatet en retningskobling.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Definerer koblingstypegruppene. Koblingstypene i samme gruppe kansellerer hverandre. Eksempel: Hvis sak A er knyttet til en \'Normal\'-kobling med sak B, kan ikke disse sakene i tillegg knyttes til en kobling til et \'Foreldrebarn\'-forhold.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Definerer listen over online repositories. En annen installasjon kan brukes som arkiv, for eksempel: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" og Content="Some Name".',
        'Defines the list of params that can be passed to ticket search function.' =>
            'Definerer listen over parametere som kan sendes til sakssøkefunksjonen.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Definerer listen over mulige neste handlinger på en feilskjerm, en full bane kreves, så er det mulig å legge til eksterne lenker om nødvendig.',
        'Defines the list of types for templates.' => 'Definerer listen over typer for maler.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Definerer plasseringen for å få online depotliste for tilleggspakker. Det første tilgjengelige resultatet vil bli brukt.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Definerer loggmodulen for systemet. "Fil" skriver alle meldinger i en gitt loggfil, "SysLog" bruker syslog-daemonen til systemet, f.eks. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTOBO instance to stop working (probably any mask which takes input from the user).' =>
            'Definerer maksimal størrelse (i byte) for filopplasting via nettleseren. Advarsel: Hvis du setter dette alternativet til en verdi som er for lav, kan det føre til at mange masker i OTOBO-forekomsten din slutter å fungere (sannsynligvis en hvilken som helst maske som mottar input fra brukeren).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definerer maksimal gyldig tid (i sekunder) for en sesjons-ID.',
        'Defines the maximum number of affected tickets per job.' => 'Definerer maksimalt antall berørte saker per jobb.',
        'Defines the maximum number of pages per PDF file.' => 'Definerer maksimalt antall sider per PDF-fil.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Definerer det maksimale antallet siterte linjer som skal legges til svar.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Definerer maksimalt antall oppgaver som skal utføres på samme tid.',
        'Defines the maximum size (in MB) of the log file.' => 'Definerer maksimal størrelse (i MB) for loggfilen.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Definerer maksimal størrelse i KiloByte av GenericInterface-svar som blir logget til gi_debugger_entry_content-tabellen.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definerer modulen som viser alle innloggede saksbehandlere i saksbehandlergrensesnittet.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'Definerer modulen som viser alle påloggede kunder i agentgrensesnittet.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'Definerer modulen som viser gjeldende påloggede agenter i kundegrensesnittet.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'Definerer modulen som viser gjeldende innloggede kunder i kundegrensesnittet.',
        'Defines the module to authenticate customers.' => 'Definerer modulen for å autentisere kunder.',
        'Defines the module to display a notification in the agent interface if the OTOBO Daemon is not running.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet hvis OTOBO Daemon ikke kjører.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet hvis systemkonfigurasjonen er usynkronisert.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet, hvis agenten ennå ikke har valgt en tidssone.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet, hvis agenten er pålogget mens han ikke er på kontoret.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet, hvis agenten er logget på mens systemvedlikehold er aktivt.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet hvis forhåndsvarselet for agentsesjonsgrensen er nådd.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet, hvis systemet brukes av admin-brukeren (normalt skal du ikke jobbe som admin).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet hvis det er utplassert ugyldige sysconfig-innstillinger.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            'Definerer modulen for å vise et varsel i agentgrensesnittet, hvis det er endrede sysconfig-innstillinger som ikke er distribuert ennå.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            'Definerer modulen for å vise et varsel i kundegrensesnittet, hvis kunden er pålogget mens systemvedlikeholdet er aktivt.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            'Definerer modulen for å vise et varsel i kundegrensesnittet, hvis kundebrukeren ikke har valgt en tidssone ennå.',
        'Defines the module to display a notification in the customer interface. UseMarquee options: 1/0. NotifyPriority options: Notice/Error/Success/Info.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            'Definerer modulen for å generere kode for periodiske sideinnlastinger.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            'Definerer modulen for å sende e-post. "DoNotSendEmail" sender ikke e-post i det hele tatt. Enhver av "SMTP"-mekanismene bruker en spesifisert (ekstern) e-postserver. "Sendmail" bruker direkte sendmail-binæren til operativsystemet ditt. "Test" sender ikke e-poster, men skriver dem til $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testformål.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Definerer modulen som brukes til å lagre øktdataene. Med "DB" kan frontend-serveren splittes fra db-serveren. "FS" er raskere.',
        'Defines the modules in Kernel/Output/HTML/GenericContent/ which provide the inner content to the chosen key.' =>
            'Definerer modulene i Kernel/Output/HTML/GenericContent/ som gir det indre innholdet til den valgte nøkkelen.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Definerer navnet på applikasjonen, som vises i webgrensesnittet, faner, og tittellinjen på nettleseren.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Definerer navnet på kolonnen for å lagre dataene i preferansetabellen.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Definerer navnet på kolonnen for å lagre brukeridentifikatoren i preferansetabellen.',
        'Defines the name of the indicated calendar.' => 'Definerer navnet på den angitte kalenderen.',
        'Defines the name of the key for customer sessions.' => 'Definerer navnet på nøkkelen for kundeøkter.',
        'Defines the name of the session key. E.g. Session, SessionID or OTOBO.' =>
            'Definerer navnet på øktnøkkelen. f.eks. Session, SessionID eller OTOBO.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Definerer navnet på tabellen der brukerpreferansene er lagret.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definerer de neste mulige tilstandene etter å ha skrevet/besvart en sak i saksskrivingsskjermen til agentgrensesnittet.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Definerer de neste mulige tilstandene etter videresending av en sak i saksvideresendingsskjermen til agentgrensesnittet.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Definerer de neste mulige tilstandene etter sending av en melding i skjermbildet for utgående e-post i agentgrensesnittet.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Definerer de neste mulige tilstandene for kundesaker i kundegrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i skjermbildet for lukke sak i agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i saksfritekstskjermen i agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til en note, i saksnotatskjermen til agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i saksventer-skjermen til en zoomet sak i agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definerer neste tilstand for en sak etter å ha lagt til et notat, i saksansvarlig skjerm i agentgrensesnittet.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definerer den neste tilstanden til en sak etter å ha blitt returnert, i sakssprett-skjermen i agentgrensesnittet.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Definerer den neste tilstanden til en sak etter å ha blitt flyttet til en annen kø, i skjermbildet for flytting av sak i agentgrensesnittet.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Definerer neste tilstand for en sak, i massesaksskjermen i agentgrensesnittet.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Definerer antall tegn per linje som brukes i tilfelle en HTML-artikkelforhåndsvisningserstatning på TemplateGenerator for EventNotifications.',
        'Defines the number of days to keep the daemon log files.' => 'Definerer antall dager for å beholde daemon-loggfilene.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Definerer antall overskriftsfelt i frontend-moduler for å legge til og oppdatere postmaster-filtre. Det kan være opptil 99 felt.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            'Definerer antall timer en kommunikasjon skal lagres, avhengig av status.',
        'Defines the number of hours a successful communication will be stored.' =>
            'Definerer antall timer en vellykket kommunikasjon vil bli lagret.',
        'Defines the number of tickets shown in the widget.' => 'Definerer antall saker som vises i widgeten.',
        'Defines the parameters for the customer preferences table.' => 'Definerer parametrene for tabellen med kundepreferanser.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Only works if DashboardBackend::AllowCmdOutput is enabled in Config.pm.' =>
            'Definerer parametrene for dashbordets backend. "Cmd" brukes til å spesifisere kommando med parametere. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" indikerer om plugin-en er aktivert som standard eller om brukeren trenger å aktivere den manuelt. "CacheTTL" indikerer cache-utløpsperioden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter. Fungerer bare hvis DashboardBackend::AllowCmdOutput er aktivert i Config.pm.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Definerer parametrene for dashbordets backend. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" indikerer om plugin-en er aktivert som standard eller om brukeren trenger å aktivere den manuelt. "CacheTTL" indikerer cache-utløpsperioden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Definerer parametrene for dashbordets backend. "Limit" definerer antall oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" indikerer om plugin-en er aktivert som standard eller om brukeren trenger å aktivere den manuelt. "CacheTTL" indikerer cache-utløpsperioden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Definerer parametrene for dashbordets backend. "Limit" definerer antall oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" indikerer om plugin-en er aktivert som standard eller om brukeren trenger å aktivere den manuelt. "CacheTTLLocal" definerer cache-utløpsperioden i minutter for plugin-modulen. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere fet kursiv skrift med monospace i PDF-dokumenter.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere fet kursiv proporsjonal skrift i PDF-dokumenter.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere fet monospace font i PDF-dokumenter.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere fet proporsjonal skrift i PDF-dokumenter.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere kursiv skrift med monospace i PDF-dokumenter.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere proporsjonal skrift i kursiv i PDF-dokumenter.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere monospace font i PDF-dokumenter.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Definerer banen og TTF-filen for å håndtere proporsjonal skrift i PDF-dokumenter.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Definerer banen til den viste infofilen, som ligger under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'Definerer banen til binær PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Definerer banen til openssl-binærfil. Det kan trenge en HOME-env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the path to the Google Chrome or Chromium binary. If set, this binary will be used instead of PhantomJS::Bin.' =>
            'Definerer banen til binærfilen Google Chrome eller Chromium. Hvis den er satt, vil denne binære filen bli brukt i stedet for PhantomJS::Bin.',
        'Defines the path to the PhantomJS binary. You can use a static build from http://phantomjs.org/download.html for an easy installation process.' =>
            'Definerer banen til PhantomJS-binæren. Du kan bruke en statisk build fra http://phantomjs.org/download.html for en enkel installasjonsprosess.',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Definerer tidsperioden (i minutter) før agenten merkes som "borte" på grunn av inaktivitet (f.eks. i "påloggede brukere"-widgeten eller for chatten).',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Definerer tidsperioden (i minutter) før kunden merkes som "borte" på grunn av inaktivitet (f.eks. i "påloggede brukere"-widgeten eller for chatten).',
        'Defines the postmaster default queue.' => 'Definerer postmesterens standardkø.',
        'Defines the priority in which the information is logged and presented.' =>
            'Definerer prioriteten som informasjonen logges og presenteres i.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Definerer mottakermålet for telefonsaken og avsenderen av e-postsaken ("Kø" viser alle køer, "Systemadresse" viser alle systemadresser) i agentgrensesnittet.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Definerer mottakermålet for sakene ("Kø" viser alle køer, "SystemAddress" viser bare køene som er tilordnet systemadresser) i kundegrensesnittet.',
        'Defines the redirect URL for setting a ticket article to \'seen\'.' =>
            '',
        'Defines the redirect URL for setting a ticket article to \'unseen\'.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Definerer den nødvendige tillatelsen til å vise en sak i eskaleringsvisningen til agentgrensesnittet.',
        'Defines the search limit for the stats.' => 'Definerer søkegrensen for statistikken.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'Definerer søkeparametrene for skjermbildet AgentCustomerUserAddressBook. Med innstillingen \'CustomerTicketTextField\' kan verdiene for mottakerfeltet spesifiseres.',
        'Defines the sender for rejected emails.' => 'Definerer avsenderen for avviste e-poster.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Definerer skillet mellom agentens virkelige navn og den oppgitte kø-e-postadressen.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'Definerer de viste kolonnene og plasseringen i resultatskjermbildet AgentCustomerUserAddressBook.',
        'Defines the shown links in the footer area of the customer interface of this OTOBO system. The value in "Key" is the external URL, the value in "Content" is the shown label. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> and <OTOBO_CONFIG_ScriptAlias> will be substituted.' =>
            'Definerer de viste koblingene i bunntekstområdet i kundegrensesnittet til dette OTOBO-systemet. Verdien i "Nøkkel" er den eksterne URL-en, verdien i "Innhold" er den viste etiketten. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> og <OTOBO_CONFIG_ScriptAlias> vil bli erstattet.',
        'Defines the source dynamic field for storing historical data.' =>
            'Definerer kildedynamikkfeltet for lagring av historiske data.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Definerer standardtillatelsene som er tilgjengelige for kunder i applikasjonen. Hvis flere tillatelser er nødvendig, kan du legge dem inn her. Tillatelser må være hardkodet for å være effektive. Sørg for, når du legger til noen av de ovennevnte tillatelsene, at "rw"-tillatelsen forblir den siste oppføringen.',
        'Defines the standard size of PDF pages.' => 'Definerer standardstørrelse på PDF-sider.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definerer status på en sak hvis den får en oppfølging og saken allerede var avsluttet.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definerer status på en sak hvis den får en oppfølging.',
        'Defines the state type of the reminder for pending tickets.' => 'Definerer statustypen for påminnelser om saker på vent.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Definerer emnet for varslingsposter sendt til agenter, om nytt passord.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Definerer emnet for varslingsposter sendt til agenter, med token om nytt forespurt passord.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Definerer emnet for varslingsposter sendt til kunder, om ny konto.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Definerer emnet for varslingsposter sendt til kunder, om nytt passord.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Definerer emnet for varslingsposter sendt til kunder, med token om nytt forespurt passord.',
        'Defines the subject for rejected emails.' => 'Definerer emnet for avviste e-poster.',
        'Defines the subject for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Definerer emnet for den raske lukkehandlingen, som blir brukt til sakshistorikk i agentgrensesnittet.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Definerer systemadministratorens e-postadresse. Det vil vises på feilskjermbildene til applikasjonen.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).' =>
            'Definerer systemidentifikatoren. Hvert saksnummer og http-sesjonsstreng inneholder denne IDen. Dette sikrer at kun saker som tilhører systemet ditt vil bli behandlet som oppfølging (nyttig ved kommunikasjon mellom to forekomster av OTOBO).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Definerer målattributtet i lenken til ekstern kundedatabase. f.eks. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Definerer målattributtet i lenken til ekstern kundedatabase. f.eks. \'target="cdb"\'.',
        'Defines the target dynamic fields for storing historical data.' =>
            'Definerer de dynamiske målfeltene for lagring av historiske data.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            'Definerer saksavtaletypen backend for saksdynamisk felt dato og klokkeslett.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            'Definerer saksavtaletypens backend for saksopptrappingstid.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            'Definerer saksavtaletypens backend for ventetid for sak.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Definerer saksfeltene som skal vises kalenderhendelser. "Nøkkel" definerer feltet eller saksattributtet og "Innhold" definerer visningsnavnet.',
        'Defines the ticket plugin for calendar appointments.' => 'Definerer saksplugin for kalenderavtaler.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Definerer tidssonen til den angitte kalenderen, som senere kan tilordnes en bestemt kø.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Definerer tidsavbruddet (i sekunder, minimum er 20 sekunder) for innsamling av støttedata med den offentlige modulen \'PublicSupportDataCollector\' (f.eks. brukt fra OTOBO Daemon).',
        'Defines the two-factor module to authenticate agents.' => 'Definerer tofaktormodulen for å autentisere agenter.',
        'Defines the two-factor module to authenticate customers.' => 'Definerer tofaktormodulen for å autentisere kunder.',
        'Defines the type of protocol that is used by the web server to serve the application. If the webserver uses HTTP instead of of HTTPS, then \'http\' must be specified here. The setting of \'HttpType\' has no affect on the web server\'s settings or behavior. Specifically, it will not change the method of access to the application. If the setting is wrong, it will not prevent you from logging into the application. This setting is used mainly via the template variable OTOBO_CONFIG_HttpType. This variable is found in all forms of messaging used by the application. It is used to build links to the tickets within your system. Another effect of keeping \'HttpType\' set to \'https\' is that the session management cookie will only be set for secure connections.' =>
            'Definerer typen protokoll som brukes av webserveren for å betjene applikasjonen. Hvis webserveren bruker HTTP i stedet for HTTPS, må \'http\' angis her. Innstillingen for \'HttpType\' har ingen innvirkning på webserverens innstillinger eller oppførsel. Det vil spesifikt ikke endre metoden for tilgang til applikasjonen. Hvis innstillingen er feil, vil det ikke hindre deg i å logge på applikasjonen. Denne innstillingen brukes hovedsakelig via malvariabelen OTOBO_CONFIG_HttpType. Denne variabelen finnes i alle former for meldinger som brukes av applikasjonen. Den brukes til å bygge lenker til sakene i systemet ditt. En annen effekt av å holde \'HttpType\' satt til \'https\' er at øktadministrasjonsinformasjonskapselen kun vil bli satt for sikre tilkoblinger.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Definerer det brukte tegnet for e-postsitater i klartekst i skjermbildet for bestilling av saker i agentgrensesnittet. Hvis dette er tomt eller inaktivt, vil ikke originale e-poster bli sitert, men lagt til svaret.',
        'Defines the user identifier for the customer panel.' => 'Definerer brukeridentifikatoren for kundepanelet.',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definerer brukerens avatar. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            'Definerer gyldige tilstandstyper for en sak. Hvis en sak er i en tilstand som har en hvilken som helst tilstandstype fra denne innstillingen, vil denne saken anses som åpen, ellers som lukket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Definerer gyldige tilstander for ulåste saker. For å låse opp saker kan skriptet "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" brukes.',
        'Defines the value of the SameSite attribute of the OTOBO session cookies. Used in otobo.psgi.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'Definerer de synlige låsene til en sak. MERK: Når du endrer denne innstillingen, sørg for å slette hurtigbufferen for å bruke den nye verdien. Standard: unlock, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definerer bredden for redigeringskomponenten for rik tekst for denne skjermen. Skriv inn tall (piksler) eller prosentverdi (relativ).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Definerer bredden for redigeringskomponenten for rik tekst. Skriv inn tall (piksler) eller prosentverdi (relativ).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            'Definerer tiden i minutter siden siste endring for utkast av spesifisert type før de anses som utløpt.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            'Definerer om arkiverte saker skal indekseres for fulltekstsøk.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Definerer hvilke artikkelavsendertyper som skal vises i forhåndsvisningen av en sak.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Definerer hvilke elementer som er tilgjengelige for \'Handling\' på tredje nivå i ACL-strukturen.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Definerer hvilke elementer som er tilgjengelige på første nivå av ACL-strukturen.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Definerer hvilke elementer som er tilgjengelige på andre nivå av ACL-strukturen.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Definerer hvilke tilstander som skal settes automatisk (Innhold), etter at ventetiden for tilstand (Nøkkel) er nådd.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Definerer hvilke saker av hvilke saksstatustyper som ikke skal vises i koblede sakslister.',
        'Delete expired cache from core modules.' => 'Slett utløpt cache fra kjernemoduler.',
        'Delete expired form cache hourly.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Slett utløpt loader-cache ukentlig (søndag morgen).',
        'Delete expired sessions.' => 'Slett utløpte økter.',
        'Delete expired ticket draft entries.' => 'Slett utløpte saksutkast.',
        'Delete expired upload cache hourly.' => 'Slett utløpt opplastingsbuffer hver time.',
        'Delete this ticket' => 'Fjern denne saken',
        'Deleted link to ticket "%s".' => 'Slettet link til sak «%s».',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Sletter en økt hvis sesjons-IDen brukes med en ugyldig ekstern IP-adresse.',
        'Deletes requested sessions if they have timed out.' => 'Sletter forespurte økter hvis de har tidsavbrutt.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Leverer utvidet feilsøkingsinformasjon i frontend i tilfelle AJAX-feil oppstår, hvis aktivert.',
        'DeploymentHistory' => 'DeploymentHistory',
        'Detached' => 'Frakoblet',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            'Bestemmer om en knapp for å slette en kobling skal vises ved siden av hver lenke i hver zoommaske.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Bestemmer om listen over mulige køer å flytte til sak til skal vises i en nedtrekksliste eller i et nytt vindu i agentgrensesnittet. Hvis "Nytt vindu" er satt kan du legge til en flyttelapp på saken.',
        'Determines if the statistics module may generate article lists.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            'Bestemmer om statistikkmodulen kan generere sakslister.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Bestemmer de neste mulige sakstilstandene, etter opprettelsen av en ny e-postsak i agentgrensesnittet.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Bestemmer de neste mulige sakstilstandene, etter opprettelsen av en ny telefonsak i agentgrensesnittet.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Bestemmer de neste mulige sakstilstandene for prosesssaker i agentgrensesnittet.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'Bestemmer de neste mulige sakstilstandene, for prosesssaker i kundegrensesnittet.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Bestemmer neste skjermbilde etter ny kundesak i kundegrensesnittet.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Bestemmer neste skjermbilde etter oppfølgingsskjermen til en zoomet sak i kundegrensesnittet.',
        'Determines the next screen after the process screen of a zoomed ticket in the customer interface.' =>
            'Bestemmer neste skjermbilde etter prosessskjermbildet for en zoomet sak i kundegrensesnittet.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Bestemmer neste skjermbilde etter at saken er flyttet. LastScreenOverview vil returnere den siste oversiktsskjermen (f.eks. søkeresultater, køvisning, dashbord). TicketZoom kommer tilbake til TicketZoom.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Bestemmer mulige tilstander for ventende saker som endret tilstand etter å ha nådd tidsgrensen.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Bestemmer strengene som skal vises som mottaker (Til:) av telefonsaken og som avsender (Fra:) av e-postsaken i agentgrensesnittet. For Queue as NewQueueSelectionType "<Queue>" viser navnene på køene og for SystemAddress "<Realname> <<Email>>" viser navnet og e-posten til mottakeren.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Bestemmer strengene som skal vises som mottaker (Til:) av saken i kundegrensesnittet. For Queue as CustomerPanelSelectionType viser "<Queue>" navnene på køene, og for SystemAddress viser "<Realname> <<Email>>" navnet og e-posten til mottakeren.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Bestemmer måten de koblede objektene vises på i hver zoommaske.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Bestemmer hvilke alternativer som vil være gyldige for mottakeren (telefonsak) og avsenderen (e-postsak) i agentgrensesnittet.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Bestemmer hvilke køer som skal være gyldige for sakens mottakere i kundegrensesnittet.',
        'Dialog to show after marking a ticket as seen' => '',
        'Dialog to show after marking a ticket as unseen' => '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Deaktiver HTTP-header "Content-Security-Policy" for å tillate lasting av eksternt skriptinnhold. Deaktivering av denne HTTP-headeren kan være et sikkerhetsproblem! Deaktiver den bare hvis du vet hva du gjør!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTOBO to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Deaktiver HTTP-header "X-Frame-Options: SAMEORIGIN" for å tillate OTOBO å bli inkludert som en IFrame på andre nettsteder. Deaktivering av denne HTTP-headeren kan være et sikkerhetsproblem! Deaktiver den bare hvis du vet hva du gjør!',
        'Disable autocomplete in the login screen.' => 'Deaktiver autofullføring på påloggingsskjermen.',
        'Disable cloud services' => 'Deaktiver skytjenester',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'Deaktiverer sending av påminnelsesvarsler til den ansvarlige agenten for en sak (Ticket::Responsible må være aktivert).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            'Deaktiverer omdirigering til siste skjermoversikt / dashbord etter at en sak er stengt.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Vis en advarsel og forhindre søk når du bruker stoppord i fulltekstsøk.',
        'Display communication log entries.' => 'Vis kommunikasjonsloggoppføringer.',
        'Display settings to override defaults for Process Tickets.' => 'Vis innstillinger for å overstyre standardinnstillinger for prosesssaker.',
        'Display settings to override defaults for dynamic field widget for Tickets.' =>
            '',
        'Displayable via click' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Viser regnskapsført tid for en artikkel i sakszoomvisningen.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            'Viser antall saker med samme kunde-ID som gjeldende sak i sakszoomvisningen.',
        'Dropdown' => 'Nedfellsmeny',
        'Dutch' => 'nederlandsk',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'Nederlandsk stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Dynamic Field Contents' => '',
        'Dynamic Field Information' => '',
        'Dynamic Field Labels' => '',
        'Dynamic Field Set' => '',
        'Dynamic Field Set Backend GUI' => '',
        'Dynamic Fields Checkbox Backend GUI' => 'Dynamic Fields Checkbox Backend GUI',
        'Dynamic Fields Contact Data Backend GUI' => 'Dynamiske felt Kontakt Data Backend GUI',
        'Dynamic Fields Database Backend GUI' => 'Dynamic Fields Database Backend GUI',
        'Dynamic Fields Date Time Backend GUI' => 'Dynamiske felt Dato Tid Backend GUI',
        'Dynamic Fields Drop-down Backend GUI' => 'Dynamiske felt rullegardinmeny Backend GUI',
        'Dynamic Fields GUI' => 'Dynamic Fields GUI',
        'Dynamic Fields Lens Backend GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => 'Dynamic Fields Multiselect Backend GUI',
        'Dynamic Fields Overview Limit' => 'Oversiktsgrense for dynamiske felt',
        'Dynamic Fields Reference Backend GUI' => '',
        'Dynamic Fields Text Backend GUI' => 'Dynamiske felt Tekst Backend GUI',
        'Dynamic Fields Web Service Backend GUI' => 'Dynamic Fields Web Service Backend GUI',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dynamiske felt som brukes til å eksportere søkeresultatet i CSV-format.',
        'Dynamic field event module that deletes script field events if a dynamic field of type script gets deleted.' =>
            '',
        'Dynamic field event module that updates PartOfSet attributes of fields which are included in a set.' =>
            '',
        'Dynamic fields groups for dynamic field widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Dynamiske feltgrupper for prosesswidget. Nøkkelen er navnet på gruppen, verdien inneholder feltene som skal vises. Eksempel: \'Nøkkel => Min gruppe\', \'Innhold: Navn_X, NavnY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'Dynamiske feltgrense per side for dynamiske feltoversikt.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Dynamiske feltalternativer vist i saksmeldingsskjermen i kundegrensesnittet. MERK. Hvis du vil vise disse feltene også i sakszoom i kundegrensesnittet, må du aktivere dem i CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            'Dynamiske feltalternativer vist i sakssvarseksjonen i sakszoomskjermen i kundegrensesnittet.',
        'Dynamic fields shown in the dynamic field widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            'Dynamiske felt som vises på skjermen for utgående e-post i agentgrensesnittet.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            'Dynamiske felt vist i prosess-widgeten i sakszoomskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            'Dynamiske felt vist i sidefeltet på sakszoomskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            'Dynamiske felt vist i sakslukkingsskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            'Dynamiske felter vist i saksskrivingsskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            'Dynamiske felt vist i sak-e-postskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            'Dynamiske felt som vises i skjermbildet for videresending av sak i agentgrensesnittet.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            'Dynamiske felt vist i saksfritekstskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            'Dynamiske felt vist i oversiktsskjermbildet for saksmediumformat i agentgrensesnittet.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            'Dynamiske felt vist i saksflyttingsskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            'Dynamiske felter vist i sakslappskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            'Dynamiske felt vist i saksoversiktsskjermen til kundegrensesnittet.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            'Dynamiske felt vist på sakseierskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            'Dynamiske felt vist i skjermbildet for ventende sak i agentgrensesnittet.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            'Dynamiske felt vist på sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            'Dynamiske felt som vises på utgående sakstelefonskjerm i agentgrensesnittet.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            'Dynamiske felt vist på sakstelefonskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            'Dynamiske felt vist i oversiktsskjermbildet for forhåndsvisning av saksformat i agentgrensesnittet.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            'Dynamiske felt vist i saksutskriftsskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            'Dynamiske felt vist i saksutskriftsskjermen til kundegrensesnittet.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            'Dynamiske felt vist i saksprioritetsskjermen til agentgrensesnittet.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            'Dynamiske felt vist i saksansvarlig skjerm i agentgrensesnittet.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            'Dynamiske felt vist i oversiktsresultatskjermbildet for sakssøk i kundegrensesnittet.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            'Dynamiske felt vist i sakssøkeskjermen i agentgrensesnittet.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            'Dynamiske felt vist i sakssøkeskjermen i kundegrensesnittet.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            'Dynamiske felt vist i oversiktsskjermbildet for sak i liten format i agentgrensesnittet.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            'Dynamiske felter vist i sakszoomskjermen til kundegrensesnittet.',
        'DynamicField' => 'Dynamisk felt',
        'DynamicField backend registration.' => 'Dynamisk felt-backend-registrering.',
        'DynamicField object registration.' => 'Dynamisk felt-objektregistrering.',
        'DynamicFieldScreen' => 'DynamicFieldScreen',
        'DynamicField_%s' => 'Dynamisk felt_%s',
        'E-Mail Outbound' => 'Utgående e-post',
        'Edit Customer Companies.' => 'Rediger kundebedrifter.',
        'Edit Customer Users.' => 'Rediger kundebrukere.',
        'Edit appointment' => 'Endre avtale',
        'Edit contacts with data' => 'Rediger kontakter med data',
        'Edit contacts with data.' => 'Rediger kontakter med data.',
        'Edit customer company' => 'Endre kundebedrift',
        'Elasticsearch quick result module.' => 'Elasticsearch rask resultatmodul.',
        'Email Addresses' => 'e-postadresser',
        'Email Outbound' => 'E-post utgående',
        'Email Resend' => 'Send e-post på nytt',
        'Email communication channel.' => 'E-post kommunikasjonskanal.',
        'Enable highlighting queues based on ticket age.' => 'Aktiver utheving av køer basert på saksalderen.',
        'Enable keep-alive connection header for SOAP responses.' => 'Aktiver keep-alive-tilkoblingshode for SOAP-svar.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Aktiver dette hvis du stoler på alle dine offentlige og private pgp-nøkler, selv om de ikke er sertifisert med en klarert signatur.',
        'Enabled filters.' => 'Aktiver filtre.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTOBO user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Aktiverer PGP-støtte. Når PGP-støtte er aktivert for signering og kryptering av e-post, anbefales det STERKT at webserveren kjører som OTOBO-bruker. Ellers vil det være problemer med privilegiene ved tilgang til .gnupg-mappen.',
        'Enables S/MIME support.' => 'Aktiverer støtte for S/MIME.',
        'Enables customers to create their own accounts.' => 'Lar kunder opprette sine egne kontoer.',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'Gjør det mulig å hente S/MIME fra CustomerUser-støttestøtte.',
        'Enables file upload in the package manager frontend.' => 'Aktiverer filopplasting i pakkebehandlingsgrensesnittet.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Aktiverer eller deaktiverer hurtigbufring for maler. ADVARSEL: IKKE deaktiver malbufring for produksjonsmiljøer, for det vil føre til et massivt ytelsesfall! Denne innstillingen bør bare deaktiveres av feilsøkingsårsaker!',
        'Enables or disables the debug mode for translations module.' => '',
        'Enables or disables the debug mode over frontend interface.' => 'Aktiverer eller deaktiverer feilsøkingsmodusen over grensesnittet.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Aktiverer eller deaktiverer saksovervåker-funksjonen, for å holde styr på saker uten å være eier eller ansvarlig.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Aktiverer ytelseslogg (for å logge sidens responstid). Det vil påvirke systemytelsen. Frontend::Module###AdminPerformanceLog må være aktivert.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Aktiverer den minimale sakstellerstørrelsen (hvis "Dato" ble valgt som TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Aktiverer sak-bulkhandlingsfunksjon for agentens grensesnitt for å jobbe med mer enn én sak om gangen.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Aktiverer bulkhandlingsfunksjonen bare for de oppførte gruppene.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Aktiverer saksansvarlig funksjon for å holde styr på en spesifikk sak.',
        'Enables ticket type feature.' => 'Aktiverer sakstypefunksjonen.',
        'Enables ticket watcher feature only for the listed groups.' => 'Aktiverer saksovervåkingsfunksjonen bare for de oppførte gruppene.',
        'Enabling SecureMode disables the web installer (http://yourhost.example.com/otobo/installer.pl) and the migrations. This is done in order to prevent the system from being hijacked. When SecureMode is not enabled the system can be reinstalled. In this case the current basic configuration will be used to pre-populate the questions within the installer script. Enabling SecureMode also enables GenericAgent, PackageManager and SQL Box.' =>
            'Aktivering av SecureMode deaktiverer nettinstallasjonsprogrammet (http://yourhost.example.com/otobo/installer.pl) og migreringene. Dette gjøres for å forhindre at systemet blir kapret. Når SecureMode ikke er aktivert, kan systemet installeres på nytt. I dette tilfellet vil gjeldende grunnleggende konfigurasjon bli brukt til å forhåndsutfylle spørsmålene i installasjonsskriptet. Aktivering av SecureMode aktiverer også GenericAgent, PackageManager og SQL Box.',
        'English (Canada)' => 'Engelsk (Canada)',
        'English (United Kingdom)' => 'Engelsk (Storbritannia)',
        'English (United States)' => 'Engelsk (Amerika)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Engelske stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Enroll process for this ticket' => 'Registreringsprosessen for denne saken',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            'Skriv inn din delte hemmelighet for å aktivere tofaktorautentisering. ADVARSEL: Pass på at du legger til den delte hemmeligheten til generatorapplikasjonen din, og applikasjonen fungerer bra. Ellers vil du ikke kunne logge på lenger uten to-faktor-tokenet.',
        'Escalated Tickets' => 'Eskalerte saker',
        'Escalation view' => 'Eskaleringsvisning',
        'EscalationTime' => 'Eskaleringstid',
        'Estonian' => 'Estisk',
        'Evaluate all script fields.' => '',
        'Event module registration (store historical data in dynamic fields).' =>
            'Registrering av hendelsesmodul (lagre historiske data i dynamiske felt).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Registrering av arrangementsmodul. For mer ytelse kan du definere en triggerbegivenhet (f.eks. Event => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Registrering av arrangementsmodul. For mer ytelse kan du definere en triggerbegivenhet (f.eks. Event => TicketCreate). Dette er kun mulig hvis alle saksdynamiske felt trenger samme arrangement.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Hendelsesmodul som utfører en oppdateringssetning på TicketIndex for å gi nytt navn til kønavnet der om nødvendig og hvis StaticDB faktisk brukes.',
        'Event module that updates customer company object name for dynamic fields.' =>
            'Hendelsesmodul som oppdaterer kundeselskapets objektnavn for dynamiske felt.',
        'Event module that updates customer user object name for dynamic fields.' =>
            'Hendelsesmodul som oppdaterer kundebrukerobjektnavn for dynamiske felt.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Hendelsesmodul som oppdaterer kundebrukersøkeprofiler hvis pålogging endres.',
        'Event module that updates customer user service membership if login changes.' =>
            'Eventmodul som oppdaterer kundebrukerservicemedlemskap hvis pålogging endres.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Eventmodul som oppdaterer kundebrukere etter en oppdatering av Kunden.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Eventmodul som oppdaterer saker etter oppdatering av Kundebruker.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Eventmodul som oppdaterer saker etter oppdatering av Kunden.',
        'Events Ticket Calendar' => 'Eventsakskalender',
        'Example package autoload configuration.' => 'Eksempel på autoload-konfigurasjon for pakke.',
        'Execute SQL statements.' => 'Kjør SQL-spørringer.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Utfører en egendefinert kommando eller modul. Merk: hvis modul brukes, er funksjon nødvendig.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Utfører oppfølgingskontroller på In-Reply-To eller References-hoder for e-poster som ikke har et saksnummer i emnet.',
        'Executes follow-up checks on OTOBO Header \'X-OTOBO-Bounce\'.' =>
            'Utfører oppfølgingskontroller på OTOBO Header \'X-OTOBO-Bounce\'.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Utfører oppfølgingskontroller av vedleggsinnhold for e-poster som ikke har saksnummer i emnet.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Utfører oppfølgingssjekker på e-posttekst for e-poster som ikke har et saksnummer i emnet.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Utfører oppfølgingssjekker av råkilde-e-posten for e-poster som ikke har et saksnummer i emnet.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Eksporterer hele artikkeltreet i søkeresultatet (det kan påvirke systemytelsen).',
        'External' => 'Ekstern',
        'External Link' => 'Ekstern lenke',
        'Fetch emails via fetchmail (using SSL).' => 'Hent e-poster via fetchmail (ved hjelp av SSL).',
        'Fetch emails via fetchmail.' => 'Hent e-poster via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Hent innkommende e-poster fra konfigurerte e-postkontoer.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Henter pakker via proxy. Overskriver "WebUserAgent::Proxy".',
        'Fields of the customer company index, used for the company fulltext search. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Felter i kundebedriftsindeksen, brukt for selskapets fulltekstsøk. Felt lagres også, men er ikke obligatoriske for den generelle funksjonaliteten.',
        'Fields of the ticket index, used for the ticket fulltext search. Fields are also stored, but are not mandatory for the overall functionality. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Felter i saksindeksen, brukt for saksfulltekstsøk. Felt lagres også, men er ikke obligatoriske for den generelle funksjonaliteten. Hvis det legges til felt som kan oppdateres (spesielt DynamicFields), må deres respektive oppdateringshendelse legges til TicketManagement-oppkalleren til Elasticsearch-netttjenesten!',
        'Fields stored in the customer company index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Felt lagret i kundebedriftsindeksen som brukes til andre ting enn fulltekstsøk. For fullstendig funksjonalitet er alle felt obligatoriske.',
        'Fields stored in the customer user index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Felt lagret i kundebrukerindeksen som brukes til andre ting enn fulltekstsøk. For fullstendig funksjonalitet er alle felt obligatoriske.',
        'Fields stored in the ticket index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Felt lagret i saksindeksen som brukes til andre ting enn fulltekstsøk. For fullstendig funksjonalitet er alle felt obligatoriske. Hvis det legges til felt som kan oppdateres (spesielt DynamicFields), må deres respektive oppdateringshendelse legges til TicketManagement-oppkalleren til Elasticsearch-netttjenesten!',
        'Fields to be searched in ticket index. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Felter som skal søkes i saksregisteret. Felt lagres også, men er ikke obligatoriske for den generelle funksjonaliteten.',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Fil som vises i Kernel::Modules::AgentInfo-modulen, hvis den ligger under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filter for feilsøking av ACLer. Merk: Flere saksattributter kan legges til i formatet <OTOBO_TICKET_Attribute>, f.eks. <OTOBO_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filter for feilsøking av overganger. Merk: Flere filtre kan legges til i formatet <OTOBO_TICKET_Attribute>, f.eks. <OTOBO_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filtrering av innkommende e-poster.',
        'Finnish' => 'Finsk',
        'First Christmas Day' => 'Første juledag',
        'First Queue' => 'Første kø',
        'First response time' => 'Første responstid',
        'FirstLock' => 'FørsteLås',
        'FirstResponse' => 'FørsteTilbakemelding',
        'FirstResponseDiffInMin' => 'FørsteTilbakemeldingDiffIMin',
        'FirstResponseInMin' => 'FørsteTilbakemeldingIMin',
        'Firstname Lastname' => 'Fornavn Etternavn',
        'Firstname Lastname (UserLogin)' => 'Firstname Lastname (Brukernavn)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            'For disse tilstandstypene er saksnumrene gjennomstreket i lenketabellen.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Tving lagring av den opprinnelige artikkelteksten i artikkelsøkeindeksen, uten å kjøre filtre eller bruke stoppordlister. Dette vil øke størrelsen på søkeindeksen og kan dermed redusere fulltekstsøk.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Tvinger frem koding av utgående e-poster (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Tvinger til å velge en annen saksstatus (fra gjeldende) etter låsehandling. Definer gjeldende tilstand som nøkkel, og neste tilstand etter låsehandling som innhold.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Tvinger opp-låsing av saker ved flytting til ny kø.',
        'Format of Creation date shown for tickets. As an example \'%Y-%m-%d %H:%M:%S\' would be interpreted as \'2020-01-22 18:07:23\'. Please refer to http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.' =>
            'Format for opprettelsesdato vist for saker. Som et eksempel vil \'%Y-%m-%d %H:%M:%S\' bli tolket som \'2020-01-22 18:07:23\'. Vennligst se http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.',
        'Format to be ingested.' => 'Format som skal inntas.',
        'Forwarded to "%s".' => 'Videresendt til «%s».',
        'French' => 'Fransk',
        'French (Canada)' => 'Fransk (Canada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'Franske stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Frontend' => 'Frontend',
        'Frontend module for dashboard info tile in customer interface.' =>
            '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'Frontend-modulregistrering (deaktiver AgentTicketService-lenken hvis sakstjenestefunksjonen ikke brukes).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Frontend-modulregistrering (deaktiver firmalink hvis ingen firmafunksjon brukes).',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Frontend-modulregistrering (deaktiver skjermbildet for saksprosesser hvis ingen prosess er tilgjengelig).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'Frontend-modulregistrering (vis personlige favoritter som undernavigasjonselementer til \'Admin\').',
        'Frontend module registration for the admin interface.' => 'Frontend-modulregistrering for admin-grensesnittet.',
        'Frontend module registration for the agent interface.' => 'Registrering av websidemodul i agentdelen.',
        'Frontend module registration for the customer interface.' => 'Frontend-modulregistrering for kundegrensesnittet.',
        'Frontend module registration for the public interface.' => 'Modulregistrering for den offentlige delen.',
        'Full value' => 'Full verdi',
        'Fulltext index regex filters to remove parts of the text.' => 'Fulltekstindeksregex-filtre for å fjerne deler av teksten.',
        'Fulltext search' => 'Fulltekst-søk',
        'Fulltext search using Elasticsearch.' => 'Fulltekstsøk med Elasticsearch.',
        'FulltextES' => 'FulltekstES',
        'Galician' => 'Galisisk',
        'General Label' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Generelle saksdata vist i saksoversiktene (fall-back). Merk at TicketNumber ikke kan deaktiveres, fordi det er nødvendig.',
        'Generate HTML comment hooks for the specified blocks so that filters can use them.' =>
            'Generer HTML-kommentarkroker for de angitte blokkene slik at filtre kan bruke dem.',
        'Generate dashboard statistics.' => 'Generer dashbordstatistikk.',
        'Generic Info module.' => 'Generisk infomodul.',
        'GenericAgent' => 'Administrasjon: Generisk Saksbehandler',
        'GenericInterface Debugger GUI' => 'GenericInterface Debugger GUI',
        'GenericInterface ErrorHandling GUI' => 'GenericInterface ErrorHandling GUI',
        'GenericInterface Invoker Event GUI' => 'GenericInterface Invoker Event GUI',
        'GenericInterface Invoker GUI' => 'GenericInterface Invoker GUI',
        'GenericInterface Operation GUI' => 'Generisk grensesnitt operasjon GUI',
        'GenericInterface TransportHTTPREST GUI' => 'Generisk grensesnitt TransportHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'Generisk grensesnitt TransportHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'GenericInterface Web Service GUI',
        'GenericInterface Web Service History GUI' => 'GenericInterface Web Service History GUI',
        'GenericInterface Web Service Mapping GUI' => 'GenericInterface Web Service Mapping GUI',
        'GenericInterface module registration for an error handling module.' =>
            'GenericInterface-modulregistrering for en feilhåndteringsmodul.',
        'GenericInterface module registration for the PassThrough invoker layer.' =>
            'GenericInterface-modulregistrering for PassThrough-invoker-laget.',
        'GenericInterface module registration for the TicketCreate invoker layer.' =>
            'GenericInterface-modulregistrering for TicketCreate-invokerlaget.',
        'GenericInterface module registration for the TicketUpdate invoker layer.' =>
            'GenericInterface-modulregistrering for TicketUpdate-invokerlaget.',
        'GenericInterface module registration for the invoker layer.' => 'GenericInterface-modulregistrering for invoker-laget.',
        'GenericInterface module registration for the mapping layer.' => 'GenericInterface-modulregistrering for kartleggingslaget.',
        'GenericInterface module registration for the operation layer.' =>
            'GenericInterface-modulregistrering for operasjonslaget.',
        'GenericInterface module registration for the transport layer.' =>
            'Generisk grensesnittmodulregistrering for transportlaget.',
        'German' => 'Tysk',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'Tyske stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            'Gir kundebrukere gruppebasert tilgang til saker fra kundebrukere av samme kunde (sak KundeID er en KundeID for kundebruker).',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Gir sluttbrukere muligheten til å overstyre skilletegnet for CSV-filer, definert i oversettelsesfilene. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Global Search Module.' => 'Global søkemodul.',
        'Go to dashboard!' => 'Gå til kontrollpanel!',
        'Good PGP signature.' => 'God PGP-signatur.',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => 'Graf: Søylediagram',
        'Graph: Line Chart' => 'Graf: Linjediagram',
        'Graph: Stacked Area Chart' => 'Graf: Stablet områdediagram',
        'Greek' => 'Gresk',
        'Hebrew' => 'Hebraisk',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            'Hjelper med å utvide artiklenes fulltekstsøk (Fra, Til, Kopi, Emne og Kroppssøk). Den vil fjerne alle artikler og bygge en indeks etter at artikkelen er opprettet, noe som øker fulltekstsøk med omtrent 50 %. For å lage en innledende indeks, bruk "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".',
        'High Contrast' => 'Høy kontrast',
        'High contrast skin for visually impaired users.' => 'Høy kontrast-tema for synshemmede brukere.',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Ungarsk',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule kan man velge databasedriver (normalt brukes et automatisk oppsett).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule kan man sette et passord for å koble til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Hvis "DB" er valgt under som::AuthModule kan man sette et brukernavn for å koble til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man spesifisere en DSN for tilkoplingen til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man skrive inn feltnavnet som skal kobles til CustomerPassword i kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'Hvis "DB" ble valgt for Customer::AuthModule, må krypteringstypen for passord angis.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må feltnavnet som skal kobles til CustomerKey spesifiseres.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man skrive inn navnet på tabellen for lagring av kundedata.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Hvis "DB" er valgt for SessionModule må man spesifisere tabellnavnet for lagring av sesjonsdata.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Hvis "FS" er valgt for SessionModule må man spesifisere en mappe som kan brukes til lagring av sesjonsdata.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Hvis "HTTBPasicAuth" ble valgt for Customer::AuthModule, kan du spesifisere (ved å bruke en RegExp) for å fjerne deler av REMOTE_USER (f.eks. for å fjerne etterfølgende domener). RegExp-Merk, $1 vil være den nye påloggingen.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Hvis "HTTBPasicAuth" ble valgt for Customer::AuthModule, kan du spesifisere å fjerne ledende deler av brukernavn (f.eks. for domener som eksempel_domene\bruker til bruker).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og du vil legge til en tekst til etter brukernavnet (f.eks. endre "brukernavn" til "brukernavn@domene") kan du spesifisere dette her.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og du trenger spesielle parametre for LDAP-modulen Net::LDAP kan du spesifisere dem her. Se "perldoc Net::LDAP" for mer info om parametrene.',
        'If "LDAP" was selected for Customer::AuthModule and you wish to use TLS security to communicate with the LDAP server, the "verify" parameter can be specified here. See Net::LDAP::start_tls for more information about the parameter.' =>
            'Hvis "LDAP" ble valgt for Customer::AuthModule og du ønsker å bruke TLS-sikkerhet for å kommunisere med LDAP-serveren, kan "verify"-parameteren spesifiseres her. Se Net::LDAP::start_tls for mer informasjon om parameteren.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og brukerne kun har anonym tilgang til LDAP-treet kan du spesifisere en egen bruker for søking. Passordet til denne brukeren skrives inn her.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og brukerne kun har anonym tilgang til LDAP-treet kan du spesifisere en egen bruker for søking. Brukernavnet til denne brukeren skrives inn her.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule må Base DN skrives inn her.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du skrive inn LDAP-tjeneren her.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule må brukernes id-felt spesifiseres her (f.eks. uid).',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan brukernes attributter settes opp. For LDAP posixGroups brukes UID, for andre må full bruker-DN brukes.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du spesifisere tilgangsoppsett her.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du velge at systemet vil stoppe opp hvis f.eks. tilkoplingen til en tjener ikke kan gjøres pga. nettverksproblemer.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTOBO. Specify the group, who may access the system.' =>
            'Hvis "LDAP" ble valgt for Customer::Authmodule, kan du sjekke om brukeren har lov til å autentisere fordi han er i en posixGroup, f.eks. brukeren må være i en gruppe xyz for å bruke OTOBO. Spesifiser gruppen som kan få tilgang til systemet.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du sette et filter for alle LDAP-søk. F.eks. (mail=*), (objectclass=user) eller (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule må du skrive inn passordet som autentiserer mot radius-tjeneren.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule må du skrive inn adressen til Radius-tjeneren her.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule kan du velge at systemet vil stoppe opp om Radius-tjeneren ikke lenger er tilgjengelig pga. nettverksproblemer el.l.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Hvis "Sendmail" er valgt som SendmailModule må du sette opp stien til sendmail-programmet, samt evt. nødvendige tilleggsvalg.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Hvis "SysLog" ble valgt for LogModule, kan en spesiell loggfunksjon spesifiseres.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Hvis "SysLog" ble valgt for LogModule, kan tegnsettet som skal brukes for logging spesifiseres.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'Hvis "bcrypt" ble valgt for CryptType, bruk kostnadene som er spesifisert her for bcrypt-hashing. For øyeblikket maks. støttet kostnadsverdi er 31.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Hvis "fil" ble valgt for LogModule, må en loggfil spesifiseres. Hvis filen ikke eksisterer, vil den bli opprettet av systemet.',
        'If activated, a clicked activity button will be hidden in the customer ticket zoom frontend.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Hvis aktiv, kan ingen av de regulære uttrykkene samsvare med brukerens e-postadresse for å tillate registrering.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Hvis det er aktivt, må ett av regulære uttrykk samsvare med brukerens e-postadresse for å tillate registrering.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, og autentisering mot e-post-tjeneren er nødvendig, må et passord spesifiseres.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, og autentisering mot e-post-tjeneren er nødvendig, må et brukernavn spesifiseres.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, må e-post-tjeneren som sender ut e-post spesifiseres.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, må porten der din e-post-tjener lytter på innkommende forbindelser spesifiseres.',
        'If enabled debugging information for ACLs is logged.' => 'Hvis aktivert, logges feilsøkingsinformasjon for tilgangskontrollister.',
        'If enabled debugging information for transitions is logged.' => 'Hvis aktivert, logges feilsøkingsinformasjon for overganger.',
        'If enabled defines the preselected state for customer follow-up in the customer interface.' =>
            'Hvis aktivert definerer forhåndsvalgt tilstand for kundeoppfølging i kundegrensesnittet.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Hvis den er aktivert, vil daemonen omdirigere standard feilstrømmen til en loggfil.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Hvis den er aktivert, vil daemonen omdirigere standard utdatastrømmen til en loggfil.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTOBOHome>/var/run/ can not be used.' =>
            'Hvis den er aktivert, vil daemonen bruke denne katalogen til å lage sine PID-filer. Merk: Stopp daemonen før noen endring og bruk denne innstillingen kun hvis <$OTOBOHome>/var/run/ ikke kan brukes.',
        'If enabled, OTOBO will deliver all CSS files in minified form.' =>
            'Hvis aktivert, vil OTOBO levere alle CSS-filer i forminsket form.',
        'If enabled, OTOBO will deliver all JavaScript files in minified form.' =>
            'Hvis slått på vil OTOBO levere alle JavaScript-filer i minimert form.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Hvis slått på vil telefonsak og e-postsak bli åpnet i nye vinduer.',
        'If enabled, the OTOBO version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'Hvis den er aktivert, vil OTOBO-versjonskoden fjernes fra webgrensesnittet, HTTP-hodene og X-hodene til utgående e-post. MERK: Hvis du endrer dette alternativet, må du sørge for å slette hurtigbufferen.',
        'If enabled, the cache data be held in memory.' => 'Hvis aktivert, lagres hurtigbufferdataene i minnet.',
        'If enabled, the cache data will be stored in cache backend.' => 'Hvis aktivert, vil cache-dataene bli lagret i cache-backend.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Hvis aktivert, kan kunden søke etter saker i alle tjenester (uavhengig av hvilke tjenester som er tildelt kunden).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Hvis slått på vil de forskjellige oversiktene (Kontrollpanel, kø-oversikt, osv.) automatisk oppdateres etter angitt tid.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Hvis aktivert, åpnes det første nivået av hovedmenyen ved musepeking (i stedet for bare klikk).',
        'If enabled, the quick close action will create an article.' => 'Hvis den er aktivert, vil hurtiglukkingen opprette en artikkel.',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTOBOTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            'Hvis aktivert, vil brukere som ikke har valgt en tidssone ennå bli varslet om å gjøre det. Merk: Varsling vil ikke vises hvis (1) bruker ennå ikke har valgt en tidssone og (2) OTOBOTimeZone og UserDefaultTimeZone stemmer overens og (3) ikke er satt til UTC.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'Hvis ingen SendmailNotificationEnvelopeFrom er spesifisert, gjør denne innstillingen det mulig å bruke e-postens fra-adresse i stedet for en tom konvoluttavsender (påkrevd i visse e-postserverkonfigurasjoner).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'Hvis angitt, brukes denne adressen som konvoluttavsenderhode i utgående varsler. Hvis ingen adresse er spesifisert, er konvoluttavsenderoverskriften tom (med mindre SendmailNotificationEnvelopeFrom::FallbackToEmailFrom er angitt).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Hvis angitt, brukes denne adressen som konvoluttavsender i utgående meldinger (ikke varsler - se nedenfor). Hvis ingen adresse er spesifisert, er konvoluttavsenderen lik køens e-postadresse.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            'Hvis dette alternativet er aktivert, vil saker opprettet via nettgrensesnittet, via kunder eller agenter, motta et autosvar hvis de er konfigurert. Hvis dette alternativet ikke er aktivert, sendes ingen autosvar.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Hvis denne Regulær-uttrykk-setningen slår til vil ikke autosvar bli sendt.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTOBO Team. These packages could threaten your whole system!' =>
            'Hvis denne innstillingen er aktivert, er det mulig å installere pakker som ikke er verifisert av OTOBO Team. Disse pakkene kan true hele systemet ditt!',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'Hvis denne innstillingen er aktivert, vil lokale modifikasjoner ikke bli uthevet som feil i pakkebehandlingen og støttedatainnsamleren.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Hvis du skal være borte fra kontoret, kan det være lurt å gi beskjed til andre brukere ved å angi de nøyaktige datoene for fraværet ditt.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'Ignorer artikkeltyper av systemavsender (f.eks. automatiske svar eller e-postvarsler) som skal flagges som "Ulest artikkel" i AgentTicketZoom eller utvides automatisk i skjermer med stor visning.',
        'Ignores not ticket related attributes.' => 'Ignorerer ikke-saksrelaterte attributter.',
        'Import and export object information.' => 'Informasjon for import- og eksport-objekt.',
        'Import appointments screen.' => 'Side for avtaleimport.',
        'Import/Export' => 'Import/Eksport',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Inkluder saker til underkøer som standard når du velger en kø.',
        'Include unknown customers in ticket filter.' => 'Inkluder ukjente kunder i saksfilteret.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inkluder opprettelsestidspunkt i søkedelen av agentdelen.',
        'Incoming Phone Call.' => 'Innkommende telefonsamtale.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: for å velge din backend TicketViewAccelerator-modul. "RuntimeDB" genererer hver køvisning på farten fra saksbordet (ingen ytelsesproblemer opp til ca. 60.000 saker totalt og 6.000 åpne saker i systemet). "StaticDB" er den kraftigste modulen, den bruker en ekstra saksindekstabell som fungerer som en visning (anbefales hvis mer enn 80.000 og 6.000 åpne saker er lagret i systemet). Bruk kommandoen "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for første indeksoppretting.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            'Indikerer om en retur-e-post alltid skal behandles som vanlig oppfølging.',
        'Indonesian' => 'indonesisk',
        'Inline' => 'På linje',
        'Input' => 'Tilføre',
        'Interface language' => 'Språk for grensesnittet',
        'Internal communication channel.' => 'Intern kommunikasjonskanal.',
        'International Workers\' Day' => 'Internasjonale arbeidernes dag',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Det er mulig å konfigurere forskjellige skins, for eksempel for å skille mellom ulike agenter, som skal brukes på en per-domene basis i applikasjonen. Ved å bruke et regulært uttrykk (regex), kan du konfigurere et nøkkel/innhold-par for å matche et domene. Verdien i "Nøkkel" skal samsvare med domenet, og verdien i "Innhold" skal være et gyldig skall på systemet ditt. Se eksempeloppføringene for riktig form for regulært uttrykk.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Det er mulig å konfigurere forskjellige skins, for eksempel for å skille mellom forskjellige kunder, som skal brukes på per-domene basis i applikasjonen. Ved å bruke et regulært uttrykk (regex), kan du konfigurere et nøkkel/innhold-par for å matche et domene. Verdien i "Nøkkel" skal samsvare med domenet, og verdien i "Innhold" skal være et gyldig skall på systemet ditt. Se eksempeloppføringene for riktig form for regulært uttrykk.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Det er mulig å konfigurere ulike temaer, for eksempel for å skille mellom agenter og kunder, som skal brukes på per-domene basis i applikasjonen. Ved å bruke et regulært uttrykk (regex), kan du konfigurere et nøkkel/innhold-par for å matche et domene. Verdien i "Nøkkel" skal samsvare med domenet, og verdien i "Innhold" skal være et gyldig tema på systemet ditt. Se eksempeloppføringene for riktig form for regulært uttrykk.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            'Det var ikke mulig å sjekke PGP-signaturen, dette kan være forårsaket av en manglende offentlig nøkkel eller en ikke-støttet algoritme.',
        'Italian' => 'Italiensk',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'Italienske stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Ivory' => 'Elfenbein',
        'Ivory (Slim)' => 'Elfenben (slank)',
        'Japanese' => 'Japansk',
        'JavaScript function for the search frontend.' => 'JavaScript-funksjon for søkegrensesnittet.',
        'Jump to OTOBO!' => 'Hopp til OTOBO!',
        'Korean' => 'koreansk',
        'Languages' => '',
        'Large' => 'Stor',
        'Last Screen Overview' => 'Siste skjermoversikt',
        'Last customer subject' => 'Siste kundeemne',
        'Lastname Firstname' => 'Etternavn Fornavn',
        'Lastname Firstname (UserLogin)' => 'Etternavn Fornavn (Brukernavn)',
        'Lastname, Firstname' => 'Etternavn, Fornavn',
        'Lastname, Firstname (UserLogin)' => 'Etternavn, Fornavn (Brukernavn)',
        'LastnameFirstname' => 'Etternavn Fornavn',
        'Latvian' => 'Latvisk',
        'Lax' => '',
        'Left' => 'Venstre',
        'Lens' => '',
        'Link Object' => 'Koble objekt',
        'Link Object.' => 'Koble objekt.',
        'Link agents to groups.' => 'Koble saksbehandlere til grupper.',
        'Link agents to roles.' => 'Koble saksbehandlere til roller.',
        'Link customer users to customers.' => 'Koble kundebrukere til kunder.',
        'Link customer users to groups.' => 'Koble kundebrukere til grupper.',
        'Link customer users to services.' => 'Koble kundebrukere til tjenester.',
        'Link customers to groups.' => 'Koble kunder til grupper.',
        'Link queues to auto responses.' => 'Koble køer til autosvar.',
        'Link roles to groups.' => 'Koble roller til grupper.',
        'Link templates to attachments.' => 'Koble maler til vedlegg.',
        'Link templates to queues.' => 'Koble maler til køer.',
        'Link this ticket to other objects' => 'Koble denne saken til andre objekter',
        'Links 2 tickets with a "Normal" type link.' => 'Koble 2 saker med en "normal" lenke.',
        'Links 2 tickets with a "ParentChild" type link.' => 'Koble 2 saker med en hierarkisk lenke.',
        'Links appointments and tickets with a "Normal" type link.' => 'Koble avtaler og saker med en "normal" lenke.',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste med CSS-filer som alltid skal lastes for agentdelen.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste med CSS-filer som alltid skal lastes for kundeportalen.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste over JS-filer som alltid skal lastes for agentdelen.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste over JS-filer som alltid skal lastes for kundeportalen.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Liste over alle CustomerCompany-hendelser som skal vises i GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Liste over alle CustomerUser-hendelser som skal vises i GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Liste over alle DynamicField-hendelser som skal vises i GUI.',
        'List of all LinkObject events to be displayed in the GUI.' => 'Liste over alle LinkObject-hendelser som skal vises i GUI.',
        'List of all Package events to be displayed in the GUI.' => 'Liste over alle pakkehendelser som skal vises i GUI.',
        'List of all appointment events to be displayed in the GUI.' => 'Liste over alle avtalehendelser som skal vises i GUI.',
        'List of all article events to be displayed in the GUI.' => 'Liste over alle artikkelhendelser som skal vises i GUI.',
        'List of all calendar events to be displayed in the GUI.' => 'Liste over alle kalenderhendelser som skal vises i GUI.',
        'List of all queue events to be displayed in the GUI.' => 'Liste over alle køhendelser som skal vises i GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Liste over alle sakshendelser som skal vises i GUI.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            'Liste over farger i heksadesimal RGB som vil være tilgjengelig for valg under opprettelse av kalender. Sørg for at fargene er mørke nok til at hvit tekst kan legges over dem.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Liste over standard standardmaler som automatisk tildeles nye køer ved opprettelse.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Liste over responsive CSS-filer som alltid skal lastes inn for agentgrensesnittet.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'Liste over responsive CSS-filer som alltid skal lastes inn for kundegrensesnittet.',
        'List of states for which escalations should be suspended.' => 'Liste over tilstander som eskaleringer bør suspenderes for.',
        'List of ticket masks which can be altered using AdminTicketMask.' =>
            '',
        'List view' => 'Listevisning',
        'Lithuanian' => 'Litauisk',
        'Loader module for dashboard info tile in customer interface.' =>
            '',
        'Loader module registration for the agent interface.' => 'Lastemodulregistrering for agentgrensesnittet.',
        'Loader module registration for the customer interface.' => 'Lastemodulregistrering for kundegrensesnittet.',
        'Lock / unlock this ticket' => 'Lås / lås opp denne saken',
        'Locked Tickets' => 'Mine personlige saker',
        'Locked Tickets.' => 'Låste saker.',
        'Locked ticket.' => 'Sak satt som privat.',
        'Logged in users.' => 'Påloggede brukere.',
        'Logged-In Users' => 'Påloggede brukere',
        'Logout of customer panel.' => 'Logg ut av kundepanel.',
        'Look into a ticket!' => 'Se på sak!',
        'Loop protection: no auto-response sent to "%s".' => 'Sløyfebeskyttelse: ingen autosvar sendt til "%s".',
        'Macedonian' => 'makedonsk',
        'Mail Accounts' => 'E-postkontoer',
        'MailQueue configuration settings.' => 'MailQueue-konfigurasjonsinnstillinger.',
        'Main menu for the agent interface.' => 'Hovedmeny for agentgrensesnittet.',
        'Main menu item registration.' => 'Hovedmenyelement-registrering.',
        'Main menu registration.' => 'Hovedmeny-registrering.',
        'Makes the application block external content loading.' => 'Får applikasjonen til å blokkere ekstern innholdslasting.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Gjør at systemet sjekker MX-oppføringen for e-postadressen før det sender en e-post eller oppretter en telefonsak eller e-postsak.',
        'Makes the application check the syntax of email addresses.' => 'Gjør at systemet sjekker at en e-postadresse er skrevet på riktig måte.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Gjør at sesjoner bruker informasjonskapsler (cookies). Dersom dette er slått av på klientens nettleser vil systemet legge til sesjons-ID i lenkene.',
        'Malay' => 'malaysisk',
        'Manage Customer Dashboard Info Tile Entries' => '',
        'Manage OTOBO Team cloud services.' => 'Administrer OTOBO Team-skytjenester.',
        'Manage PGP keys for email encryption.' => 'Adminstrasjon av PGP-nøkler for kryptering og signering av e-poster.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Administrasjon av POP3- og IMAP-kontoer for innkommende e-post.',
        'Manage S/MIME certificates for email encryption.' => 'Adminstrasjon av S/MIME-sertifikater for e-postkryptering.',
        'Manage System Configuration Deployments.' => 'Administrer systemkonfigurasjonsdistribusjoner.',
        'Manage different calendars.' => 'Administrere ulike kalendere.',
        'Manage dynamic field in screens.' => 'Administrer dynamisk felt i skjermer.',
        'Manage existing sessions.' => 'Administrasjon av aktive sesjoner.',
        'Manage support data.' => 'Administrer støttedata.',
        'Manage system registration.' => 'Administrer systemregistrering.',
        'Manage tasks triggered by event or time based execution.' => 'Administrer oppgaver utløst av hendelse eller tidsbasert utførelse.',
        'Manage ticket state pre-selections for response templates.' => '',
        'Mark as Spam!' => 'Marker som søppel!',
        'Mark this ticket as junk!' => 'Marker denne saken som søppel!',
        'Mark ticket as seen' => '',
        'Mark ticket as unseen' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maks. størrelse (antall tegn) for kundelisten (telefon og e-post) i opprett-skjermen.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Maksimal størrelse (i rader) på den informerte agentboksen i agentgrensesnittet.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Maksimal størrelse (i rader) for den involverte agentboksen i agentgrensesnittet.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Maks størrelse på emnene i et e-postsvar og i noen oversiktsskjermer.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maksimum antall autosvar til egne e-postadresser per dag (beskyttelse mot e-post-looping).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            'Maksimal automatisk e-postsvar på egen e-postadresse om dagen, konfigurerbar med e-postadresse (Loop-Protection).',
        'Maximal number of results returned by ES per field.' => 'Maksimalt antall resultater returnert av ES per felt.',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maks. størrelse (i kilobytes) på e-post som kan hentes via POP3/IMAP.',
        'Maximum Number of a calendar shown in a dropdown.' => 'Maksimalt antall for en kalender vist i en rullegardin.',
        'Maximum file size for the ingest plugin.' => 'Maksimal filstørrelse for innlest-plugin.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maksimal lengde (i tegn) på det dynamiske feltet i artikkelen i sakszoomvisningen.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maksimal lengde (i tegn) på det dynamiske feltet i sidefeltet i sakszoomvisningen.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            'Maksimalt antall aktive kalendere i oversiktsskjermer. Vær oppmerksom på at et stort antall aktive kalendere kan ha en ytelsespåvirkning på serveren din ved å bruke for mange samtidige kall.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maks. antall viste saker i søkeresultater (agentdelen).',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maks. antall viste saker i søkeresultater (kundeportalen).',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Maksimalt antall saker som skal vises i resultatet av denne operasjonen.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maks. størrelse (antall tegn) i kundeinfo-tabellen i saksdetaljer-visningen.',
        'Medium' => 'Medium',
        'Merge this ticket and all articles into another ticket' => 'Slå sammen denne saken og alle artiklene til en annen sak',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'Sammenslått sak (%s/%s) til (%s/%s).',
        'Merged Ticket <OTOBO_TICKET> to <OTOBO_MERGE_TO_TICKET>.' => 'Sammenslått sak <OTOBO_TICKET> til <OTOBO_MERGE_TO_TICKET>.',
        'Minute' => 'Minutt',
        'Miscellaneous' => 'Diverse',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Modul for valg av mottaker når man oppretter ny sak i kundeportalen.',
        'Module to check if a incoming e-mail message is bounce.' => 'Modul for å sjekke om en innkommende e-postmelding returneres.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            'Modul for å sjekke om ankomne e-poster skal merkes som interne (på grunn av original videresendt intern e-post). IsVisibleForCustomer og SenderType definerer verdiene for den ankomne e-posten/artikkelen.',
        'Module to check the group permissions for customer access to tickets.' =>
            'Modul for å sjekke gruppetillatelsene for kundetilgang til saker.',
        'Module to check the group permissions for the access to tickets.' =>
            'Modul for å sjekke gruppetillatelsene for tilgang til saker.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul for å lage signerte meldinger (PGP eller S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            'Modul for å definere alternativene for e-postsikkerhet som skal brukes (PGP eller S/MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => 'Modul for å kryptere komponerte meldinger (PGP eller S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'Modul for å hente kundebrukere SMIME-sertifikater for innkommende meldinger.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Modul for å filtrere og manipulere innkommende meldinger Blokker/ignorer alle søppel-meldinger med "From: noreply@"-adresser.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Modul for å filtrere og manipulere innkommende meldinger. Få et 4-sifret nummer for å saksfri tekst, bruk regex i Match e. g. Fra => \'(.+?)@.+?\', og bruk () som [***] i Set =>.',
        'Module to filter encrypted bodies of incoming messages.' => 'Modul for å filtrere kryptert innhold av innkommende meldinger.',
        'Module to generate accounted time ticket statistics.' => 'Modul for å generere regnskapsført tidskortstatistikk.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Modul for å generere html OpenSearch-profil for kort sakssøk i agentgrensesnittet.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Modul for å generere html OpenSearch-profil for kort sakssøk i kundegrensesnittet.',
        'Module to generate ticket solution and response time statistics.' =>
            'Modul for å generere saksløsning og responstidsstatistikk.',
        'Module to generate ticket statistics.' => 'Modul for å generere saksstatistikk.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            'Modul for å gi tilgang hvis kunde-IDen til kunden har nødvendige gruppetillatelser.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Modul for å gi tilgang hvis kunde-IDen til saken samsvarer med kundens kunde-ID.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Modul for å gi tilgang hvis CustomerUserID-en til saken samsvarer med CustomerUserID-en til kunden.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Modul for å gi tilgang til enhver agent som har vært involvert i en sak tidligere (basert på oppføringer i sakshistorikk).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Modul for å gi tilgang til agenten som er ansvarlig for en sak.',
        'Module to grant access to the creator of a ticket.' => 'Modul for å gi tilgang til skaperen av en sak.',
        'Module to grant access to the owner of a ticket.' => 'Modul for å gi tilgang til eieren av en sak.',
        'Module to grant access to the watcher agents of a ticket.' => 'Modul for å gi tilgang til overvåkende agenter for en sak.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Modul for å vise varsler og eskaleringer (ShownMax: maks. viste eskaleringer, EscalationInMinutes: Vis sak som vil eskalere inn, CacheTime: Cache for beregnede eskaleringer i sekunder).',
        'Module to use database filter storage.' => 'Modul for å bruke databaselagring av filtre.',
        'Module used to detect if attachments are present.' => 'Modul som brukes til å oppdage om vedlegg er tilstede.',
        'My Queues' => 'Mine køer',
        'My Services' => 'Mine tjenester',
        'My last changed tickets' => 'Mine siste endrete saker',
        'MyLastChangedTickets dashboard widget.' => 'MyLastChangedTickets dashbord-widget.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Navn på egendefinert kø. Den tilpassede køen er et køutvalg av dine foretrukne køer og kan velges i preferanseinnstillingene.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Navn på tilpasset tjeneste. Den tilpassede tjenesten er et tjenesteutvalg av dine foretrukne tjenester og kan velges i preferanseinnstillingene.',
        'NameX' => 'NavnX',
        'New Tickets' => 'Nye saker',
        'New Window' => 'Nytt vindu',
        'New Year\'s Day' => 'Nyttårsdagen',
        'New Year\'s Eve' => 'Nyttårsaften',
        'New process ticket' => 'Ny prosess sak',
        'News about OTOBO.' => 'Nyheter om OTOBO.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Neste mulige sakstilstander etter å ha lagt til et telefonnotat i sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Neste mulige sakstilstander etter å ha lagt til en telefonnotat i utgående sakstelefonskjerm i agentgrensesnittet.',
        'No public key found.' => 'Ingen offentlig nøkkel funnet.',
        'No valid OpenPGP data found.' => 'Ingen gyldige OpenPGP-data funnet.',
        'None' => 'Ingen',
        'Norwegian' => 'Norsk',
        'Notification Settings' => 'Innstillinger for Varsling',
        'Notified about response time escalation.' => 'Varslet om eskalering av responstid.',
        'Notified about solution time escalation.' => 'Varslet om eskalering av løsningstid.',
        'Notified about update time escalation.' => 'Varslet om eskalering av oppdateringstid.',
        'Number of displayed tickets' => 'Antall viste saker',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Antall linjer (per sak) som vises i søkeverktøyet.',
        'Number of shards (NS), replicas (NR) and fields limit for the index \'ticket\'.' =>
            'Antall skår (NS), replikaer (NR) og feltgrense for indeksen \'sak\'.',
        'Number of shards (NS), replicas (NR) and fields limit for the index. Note: \'Elasticsearch::ArticleIndexCreationSettings\' is deprecated. For upwards compatibility use \'Elasticsearch::IndexSettings###Default\' instead.' =>
            'Antall skår (NS), replikaer (NR) og feltgrense for indeksen. Merk: \'Elasticsearch::ArticleIndexCreationSettings\' er utdatert. For kompatibilitet oppover, bruk \'Elasticsearch::IndexSettings###Default\' i stedet.',
        'Number of shards (NS), replicas (NR) and fields limit for the indices. This replaces \'Elasticsearch::ArticleIndexCreationSettings\' in future versions. If both are present and not equal this one has priority. Use \'Elasticsearch::IndexSettings###...\' if you want to define special settings for single indices.\'...\' may be one of \'Customer\', \'CustomerUser\', \'Ticket\' or \'ConfigItem\'.' =>
            'Antall skjær (NS), replikaer (NR) og feltgrense for indeksene. Dette erstatter \'Elasticsearch::ArticleIndexCreationSettings\' i fremtidige versjoner. Hvis begge er tilstede og ikke like, har denne prioritet. Bruk \'Elasticsearch::IndexSettings###...\' hvis du vil definere spesielle innstillinger for enkeltindekser.\'...\' kan være en av \'Customer\', \'CustomerUser\', \'Ticket\' eller \'ConfigItem\'.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Antall saker som vises per side i et søkeresultat.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Antall saker som vises per side i et søkeresultat i kundeportalen.',
        'OTOBO News' => 'OTOBO-nyheter',
        'OTOBO Team Services' => 'OTOBO Team-tjenester',
        'OTOBO can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTOBO kan bruke en eller flere skrivebeskyttede speildatabaser for dyre operasjoner som fulltekstsøk eller statistikkgenerering. Her kan du spesifisere DSN for den første speildatabasen.',
        'OTOBO doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTOBO støtter ikke gjentakende avtaler uten sluttdato eller antall iterasjoner. Under importprosessen kan det hende at ICS-filen inneholder slike avtaler. I stedet oppretter systemet alle tidligere avtaler, pluss avtaler for de neste N månedene (120 måneder/10 år som standard).',
        'Object backend module registration for the import/export module.' =>
            '',
        'Objects to search for, how many entries and which attributs to show.' =>
            'Objekter å søke etter, hvor mange oppføringer og hvilke attributter som skal vises.',
        'Objects to search for, how many entries and which attributs to show. Ticket attributes, except queue, have to explicitely be stored via Elasticsearch.' =>
            'Objekter å søke etter, hvor mange oppføringer og hvilke attributter som skal vises. Saksattributter, unntatt kø, må eksplisitt lagres via Elasticsearch.',
        'Open an external link!' => 'Åpne en ekstern lenke!',
        'Open the OTOBO home page in a new window' => 'Åpne OTOBO-hjemmesiden i et nytt vindu',
        'Open tickets (customer user)' => 'Åpne saker (kunde-bruker)',
        'Open tickets (customer)' => 'Åpne saker (kunder)',
        'Option' => 'Alternativ',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Valgfri købegrensning for CreatorCheck-tillatelsesmodulen. Hvis satt, gis tillatelse kun for saker i de angitte køene.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Valgfri købegrensning for tillatelsesmodulen InvolvedCheck. Hvis satt, gis tillatelse kun for saker i de angitte køene.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Valgfri købegrensning for tillatelsesmodulen OwnerCheck. Hvis satt, gis tillatelse kun for saker i de angitte køene.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Valgfri købegrensning for ResponsibleCheck-tillatelsesmodulen. Hvis satt, gis tillatelse kun for saker i de angitte køene.',
        'Other Customers' => 'Andre kunder',
        'Out Of Office' => 'Ikke på kontoret',
        'Out Of Office Time' => 'Tidspunkt man er ute fra kontoret',
        'Out of Office users.' => 'Ikke på kontoret: brukere.',
        'Outbound request headers not allowed to be used in frontend configuration.' =>
            'Utgående forespørselshoder er ikke tillatt brukt i frontend-konfigurasjon.',
        'Outbound response headers not allowed to be used in frontend configuration.' =>
            'Utgående svarhoder er ikke tillatt å brukes i frontend-konfigurasjon.',
        'Output filter to inject the necessary Dynamic field names in hidden input.' =>
            'Utdatafilter for å injisere de nødvendige dynamiske feltnavnene i skjult inndata.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Overbelaster (redefinerer) eksisterende funksjoner i Kernel::System::Ticket. Brukes for enkelt å legge til tilpasninger.',
        'Overview Escalated Tickets.' => 'Oversikt over eskalerte saker.',
        'Overview Refresh Time' => 'Oppdateringstid',
        'Overview of all Tickets per assigned Queue.' => 'Oversikt over alle saker per tildelt kø.',
        'Overview of all appointments.' => 'Oversikt over alle avtaler.',
        'Overview of all escalated tickets.' => 'Oversikt over alle eskalerte saker.',
        'Overview of all open Tickets.' => 'Oversikt over alle åpne saker.',
        'Overview of all open tickets.' => 'Oversikt over alle åpne saker.',
        'Overview of customer tickets.' => 'Oversikt over kundesaker.',
        'PGP Key' => 'PGP-nøkkel',
        'PGP Key Management' => 'Administrasjon: PGP Nøkkler',
        'PGP Keys' => 'PGP-nøkler',
        'Package event module file a scheduler task for update registration.' =>
            'Pakkehendelsesmodul fil en planleggeroppgave for oppdateringsregistrering.',
        'Package event module trigger package reinstall in containers.' =>
            'Pakkehendelsesmodul utløser pakkeinstallering i containere.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametere for CreateNextMask-objektet i preferansevisningen til agentgrensesnittet. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametere for CustomQueue-objektet i preferansevisningen til agentgrensesnittet. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametere for CustomService-objektet i preferansevisningen til agentgrensesnittet. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametere for RefreshTime-objektet i preferansevisningen til agentgrensesnittet. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametre for kolonnefiltrene til oversikten over små saker. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the dashboard backend of the closed tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av den lukkede saksoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parametere for dashbord-backend av kundebedriftsinformasjonen til agentgrensesnittet. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin.',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parametere for dashboard-backend av kunde-ID-listen oversikt over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parametere for dashbordstøtten til kunde-ID-statuswidgeten til agentgrensesnittet. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parametere for dashbord-backend av kundebrukerinformasjonen til agentgrensesnittet. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parametere for dashbord-backend av kundebrukerlisteoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av den nye saksoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av den nye saksoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av den åpne saksoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av den åpne saksoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parametere for dashbord-backend av køoversiktswidgeten til agentgrensesnittet. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "QueuePermissionGroup" er ikke obligatorisk, køer er kun oppført hvis de tilhører denne tillatelsesgruppen hvis du aktiverer den. "Stater" er en liste over stater, nøkkelen er sorteringsrekkefølgen til staten i widgeten. "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parametere for dashbord-backend av løpende prosesssaker oversikt over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av sak-eskaleringsoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av sak-eskaleringsoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av sak-eskaleringsoversikten over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parametere for dashbord-backend av sakshendelseskalenderen til agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av saken venter påminnelsesoversikt over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av saken venter påminnelsesoversikt over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parametere for dashbord-backend av saken venter påminnelsesoversikt over agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. Merk: Bare saksattributter og dynamiske felt (DynamicField_NameX) er tillatt for standardkolonner.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parametere for dashbord-backend av saksstatistikken til agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parametere for dashbord-backend av widgeten for kommende hendelser til agentgrensesnittet. "Limit" er antallet oppføringer som vises som standard. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" avgjør om plugin-en er aktivert som standard eller om brukeren må aktivere den manuelt. "CacheTTLLocal" er hurtigbuffertiden i minutter for plugin. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            'Parametre for sidene (der kommunikasjonsloggoppføringene vises) i oversikten over kommunikasjonsloggen.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametere for sidene (der de dynamiske feltene vises) i oversikten over dynamiske felt. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametre for sidene (der sakene vises) i oversikten over mellomsaks. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametre for sidene (der sakene vises) i den lille saksoversikten. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parametre for sidene (der sakene vises) i saksforhåndsvisningsoversikten. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Parameters of the example SLA attribute Comment2.' => 'Parametre for eksempel SLA-attributtet Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Parametre for eksempelkøattributtet Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Parametre for eksempeltjenesteattributtet Comment2.',
        'Parent' => 'Forelder',
        'ParentChild' => 'Foreldrebarn',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Bane for loggfilen (den gjelder kun hvis "FS" ble valgt for LoopProtectionModule og det er obligatorisk).',
        'Pending time' => 'Ventetidspunkt',
        'People' => 'Personer',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            'Utfører den konfigurerte handlingen for hver hendelse (som en Invoker) for hver konfigurerte webtjeneste.',
        'Permanent' => '',
        'Permitted width for compose email windows.' => 'Tillatt bredde for "skriv e-post" vinduer.',
        'Permitted width for compose note windows.' => 'Tillatt bredde for "skriv notis" vinduer.',
        'Persian' => 'Persisk',
        'Phone Call Inbound' => 'Innkommende telefonsamtale',
        'Phone Call Outbound' => 'Utgående telefonsamtale',
        'Phone Call.' => 'Telefonsamtale.',
        'Phone call' => 'Telefon-anrop',
        'Phone communication channel.' => 'Telefonkommunikasjonskanal.',
        'Phone-Ticket' => 'Henvendelser',
        'Picture Upload' => 'Last opp bilde',
        'Picture upload module.' => 'Bildeopplastingsmodul.',
        'Picture-Upload' => 'Opplasting av bilde',
        'Please click the button below to create your first ticket.' => 'Vennligst klikk på knappen under for å opprette din første sak.',
        'Plugin search' => 'Plugin-søk',
        'Plugin search module for autocomplete.' => 'Plugin-søkemodul for autofullføring.',
        'Polish' => 'Polsk',
        'Portuguese' => 'Portugisisk',
        'Portuguese (Brasil)' => 'Portugisisk (Brasil)',
        'PostMaster Filters' => 'Postmaster-filtre',
        'PostMaster Mail Accounts' => 'Postmaster e-postkontoer',
        'Print this ticket' => 'Skriv ut denne saken',
        'Priorities' => 'Prioriteter',
        'Process Management Activity Dialog GUI' => 'Grensesnitt for aktivitetsdialog med prosessadministrasjon',
        'Process Management Activity GUI' => 'GUI for prosessstyringsaktivitet',
        'Process Management Path GUI' => 'Prosessstyringsbane GUI',
        'Process Management Transition Action GUI' => 'Prosessstyring Transition Action GUI',
        'Process Management Transition GUI' => 'Prosessstyring Transition GUI',
        'Process pending tickets.' => 'Behandle ventende saker.',
        'ProcessID' => 'ProsessID',
        'Processes & Automation' => 'Prosesser og automatisering',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Beskyttelse mot CSRF (Cross Site Request Forgery) utnyttelser (for mer info se https://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Protection against brute force attacks. MaxAttempt: How many login attempts are allowed before a ban. BanDuration: Duration of the ban. KeepCacheDuration: How long failed attempts are remembered.' =>
            'Beskyttelse mot brute force-angrep. MaxAttempt: Hvor mange påloggingsforsøk er tillatt før et forbud. BanDuration: Forbudets varighet. KeepCacheDuration: Hvor lenge mislykkede forsøk huskes.',
        'Provides a matrix overview of the tickets per state per queue' =>
            'Gir en matriseoversikt over sakene per tilstand per kø',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            'Gir kundebrukere tilgang til saker selv om sakene ikke er tilordnet en kundebruker med samme kunde-ID(er), basert på tillatelsesgrupper.',
        'Public Calendar' => 'Offentlig kalender',
        'Public Interface' => 'Offentlig grensesnitt',
        'Public calendar.' => 'Offentlig kalender.',
        'Queue view' => 'Køvisning',
        'Queues ↔ Auto Responses' => 'Køer ↔ Autosvar',
        'Quick Close' => 'Lukk raskt',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Gjenoppbygg saksindeksen for AgentTicketQueue.',
        'Rebuilds Elasticsearch indices. Can be used for example, if CustomerUsers are authenticated via LDAP. Highly inefficient however, as the whole index is rebuild every time.' =>
            'Gjenoppbygger Elasticsearch-indekser. Kan brukes for eksempel hvis CustomerUsers er autentisert via LDAP. Svært ineffektiv imidlertid, ettersom hele indeksen bygges opp igjen hver gang.',
        'Rebuilds the ACL preselection cache.' => 'Gjenoppbygger ACL-forvalgsbufferen.',
        'Rebuilds the escalation index.' => 'Bygger opp eskaleringsindeksen på nytt.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            'Gjenkjenne om en sak er en oppfølging av en eksisterende sak ved hjelp av et eksternt saksnummer. Merk: den første fangstgruppen fra \'NumberRegExp\'-uttrykket vil bli brukt som saksnummerverdien.',
        'Redis server address. Example: 127.0.0.1:6379.' => 'Redis serveradresse. Eksempel: 127.0.0.1:6379.',
        'Refresh interval' => 'Automatisk innlasting',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as seen.' =>
            '',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as unseen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as seen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as unseen.' =>
            '',
        'Registers a log module, that can be used to log communication related information.' =>
            'Registrerer en loggmodul, som kan brukes til å logge kommunikasjonsrelatert informasjon.',
        'Registration of the CSV format backend module for the ImportExport feature.' =>
            '',
        'Registration of the JSON format backend module for the ImportExport feature.' =>
            '',
        'Reminder Tickets' => 'Saker med påminnelse',
        'Removed subscription for user "%s".' => 'Fjernet abonnement for brukeren «%s».',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            'Fjerner gamle generiske grensesnittfeilsøkingsloggoppføringer opprettet før det angitte antallet dager.',
        'Removes old system configuration deployments (Sunday mornings).' =>
            'Fjerner gamle systemkonfigurasjonsinstallasjoner (søndag morgen).',
        'Removes old ticket number counters (each 10 minutes).' => 'Fjerner gamle saksnummertellere (hvert 10. minutt).',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Fjerner saksovervåkerinformasjonen når en sak er arkivert.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            'Forny eksisterende SMIME-sertifikater fra kundestøtte. Merk: SMIME og SMIME::FetchFromCustomer må være aktivert i SysConfig og kundestøtten må konfigureres for å hente UserSMIMECertificate-attributtet.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Erstatter den opprinnelige avsenderen med gjeldende kundes e-postadresse ved skriv svar i saksskrivingsskjermen i agentgrensesnittet.',
        'Reports' => 'Rapporter',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Behandle e-post fra spool-katalogen på nytt som ikke kunne importeres i utgangspunktet.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Nødvendige rettigheter for å endre kunde på en sak.',
        'Required permissions to use quick close in the agent interface.' =>
            'Nødvendige tillatelser for å bruke hurtiglukking i agentgrensesnittet.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Nødvendige rettigheter for å bruke "Avslutt sak" bildet.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke skjermen for utgående e-post i agentgrensesnittet.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke skjermen for e-postsending på nytt i agentgrensesnittet.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke sakssprettskjermen i agentgrensesnittet.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Nødvendige rettigheter for å bruke "Opprett sak" bildet.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke skjermbildet for videresending av saker i agentgrensesnittet.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke saksfritekstskjermen i agentgrensesnittet.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Nødvendige tillatelser for å bruke sakssammenslåingsskjermen til en zoomet sak i agentgrensesnittet.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke saksnotatskjermen i agentgrensesnittet.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Nødvendige tillatelser for å bruke sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Nødvendige tillatelser for å bruke skjermbildet for ventende sak til en zoomet sak i agentgrensesnittet.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke sakstelefonens inngående skjerm i agentgrensesnittet.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke sakstelefonens utgående skjerm i agentgrensesnittet.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Nødvendige tillatelser for å bruke saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Nødvendige tillatelser for å bruke saksansvarlig-skjermen i agentgrensesnittet.',
        'Resend Ticket Email.' => 'Send e-post om sak på nytt.',
        'Resent email to "%s".' => 'Send e-post på nytt til "%s".',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Tilbakestiller og låser opp eieren av en sak hvis den ble flyttet til en annen kø.',
        'Responsible Tickets' => 'Ansvarlige saker',
        'Responsible Tickets.' => 'Ansvarlige saker.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'Gjenoppretter en sak fra arkivet (bare hvis hendelsen er en tilstandsendring til en åpen tilgjengelig tilstand).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Beholder alle tjenester i oppføringer selv om de er barn av ugyldige elementer.',
        'Richtext' => '',
        'Right' => 'Høyre',
        'Roles ↔ Groups' => 'Roller ↔ Grupper',
        'Romanian' => 'rumensk',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Kjør filbaserte generiske agentjobber (Merk: modulnavnet må spesifiseres i -configuration-module param, f.eks. "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Aktive prosesssaker',
        'Runs an initial wildcard search of the existing contacts with data when accessing the AdminContactWD module.' =>
            'Kjører et innledende jokertegnsøk av eksisterende kontakter med data ved tilgang til AdminContactWD-modulen.',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Kjører et første jokertegnsøk av det eksisterende kundeselskapet når du får tilgang til AdminCustomerCompany-modulen.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Kjører et første jokertegnsøk av eksisterende kundebrukere når de får tilgang til AdminCustomerUser-modulen.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Kjører systemet i "Demo"-modus. Hvis aktivert, kan agenter endre preferanser, for eksempel valg av språk og tema via agentens nettgrensesnitt. Disse endringene er kun gyldige for gjeldende økt. Det vil ikke være mulig for agenter å endre passordene sine.',
        'Russian' => 'Russisk',
        'S/MIME Certificates' => 'S/MIME-sertifikater',
        'SLAs' => '',
        'Salutations' => 'Hilsninger',
        'Sample command output' => 'Eksempel på kommandoresultat',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTOBO user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used. "S3" is experimental.' =>
            'Lagrer vedlegg til artikler. "DB" lagrer alle data i databasen (anbefales ikke for lagring av store vedlegg). "FS" lagrer dataene på filsystemet; dette er raskere, men webserveren skal kjøre under OTOBO-brukeren. Du kan bytte mellom modulene selv på et system som allerede er i produksjon uten tap av data. Merk: Søking etter vedleggsnavn støttes ikke når "FS" brukes. "S3" er eksperimentell.',
        'Schedule a maintenance period.' => 'Planlegg en vedlikeholdsperiode.',
        'Screen after new ticket' => 'Skjermbilde etter innlegging av ny sak',
        'Script (Template Toolkit)' => '',
        'Search Customer' => 'Kunde-søk',
        'Search Ticket.' => 'Søk sak.',
        'Search Tickets.' => 'Søk saker.',
        'Search User' => 'Søk etter bruker',
        'Search backend default router.' => 'Søk backend standard ruter.',
        'Search backend router.' => 'Søk i backend-ruter.',
        'Search.' => 'Søk.',
        'Second Christmas Day' => 'Andre juledag',
        'Second Queue' => 'Andre kø',
        'Select after which period ticket overviews should refresh automatically.' =>
            'Velg etter hvilken periode saksoversikter skal oppdateres automatisk.',
        'Select how many tickets should be shown in overviews by default.' =>
            'Velg hvor mange saker som skal vises i oversikter som standard.',
        'Select the algorithm used for encryption. Fallback is aes256. Try "/usr/bin/openssl enc -ciphers" to get a list of ciphers supported by your system (written without the leading \'-\').' =>
            'Velg algoritmen som brukes for kryptering. Fallback er aes256. Prøv "/usr/bin/openssl enc -ciphers" for å få en liste over chiffer som støttes av systemet ditt (skrevet uten innledende \'-\').',
        'Select the main interface language.' => 'Velg hovedgrensesnittspråket.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Velg et separator-tegn for bruk i CSV-filer (statistikk og søk). Hvis du ikke velger en, vil standardtegnet for språket bli brukt.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            'Velg din personlige tidssone. Alle tider vil vises i forhold til denne tidssonen.',
        'Select your preferred layout for the software.' => 'Velg ønsket layout for programvaren.',
        'Select your preferred theme for OTOBO.' => 'Velg ønsket tema for OTOBO.',
        'Selects the cache backend to use.' => 'Velger bufferens backend som skal brukes.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Velger modulen for å håndtere opplastinger via nettgrensesnittet. "DB" lagrer alle opplastinger i databasen, "FS" bruker filsystemet.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            'Velger saksnummergeneratormodulen. "AutoIncrement" øker saksnummeret, SystemID og telleren brukes med SystemID.counter format (f.eks. 1010138, 1010139). Med "Dato" vil saksnumrene bli generert av gjeldende dato, SystemID og teller. Formatet ser ut som Year.Month.Day.SystemID.counter (f.eks. 200206231010138, 200206231010139). Med "DateChecksum" vil telleren bli lagt til som kontrollsum til strengen med dato og SystemID. Kontrollsummen vil bli rotert på daglig basis. Formatet ser ut som Year.Month.Day.SystemID.Counter.CheckSum (f.eks. 2002070110101520, 2002070110101535).',
        'Send new outgoing mail from this ticket' => 'Send ny utgående post fra denne saken',
        'Send notifications to users.' => 'Send varsling til brukerne.',
        'Sender type for new tickets from the customer inteface.' => 'Sendingstype for nye meldinger på kundeweben.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Send varsling kun til sakens eier dersom en sak låses opp (normalt sendes meldingen til alle saksbehandlere).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Send all utgående e-post via Bcc til spesifisert adresse. Vennligst bruk dette kun for sikkerhetskopiering.',
        'Sends customer notifications just to the mapped customer.' => 'Sender kundevarsler bare til den kartlagte kunden.',
        'Sends registration information to Rother OSS.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Sender en påminnelse om opplåsing av saker etter oppnådd tidsfrist (sendes kun til sakens eier).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Sender varslene som er konfigurert i administrasjonsgrensesnittet under "Saksvarslinger".',
        'Sent "%s" notification to "%s" via "%s".' => 'Sendte "%s"-varsel til "%s" via "%s".',
        'Sent auto follow-up to "%s".' => 'Sendte automatisk oppfølging til "%s".',
        'Sent auto reject to "%s".' => 'Sendt automatisk avvisning til "%s".',
        'Sent auto reply to "%s".' => 'Sendte automatisk svar til "%s".',
        'Sent email to "%s".' => 'Sendte e-post til "%s".',
        'Sent email to customer.' => 'Sendte e-post til kunde.',
        'Sent notification to "%s".' => 'Sendte varsel til "%s".',
        'Serbian Cyrillic' => 'Serbisk (Cyrillic)',
        'Serbian Latin' => 'Serbisk (Latin)',
        'Service Level Agreements' => 'Tjenestenivåavtaler',
        'Service view' => 'Tjeneste visning',
        'ServiceView' => 'Tjenestevisning',
        'Set a new password by filling in your current password and a new one.' =>
            'Angi et nytt passord ved å fylle inn ditt nåværende passord og et nytt.',
        'Set sender email addresses for this system.' => 'Sett opp avsenderadresse for denne installasjonen.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Angi standardhøyden (i piksler) for innebygde HTML-artikler i AgentTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Angi grensen for saker som skal utføres på en enkelt generisk agent-jobbkjøring.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Angi maksimal høyde (i piksler) for innebygde HTML-artikler i AgentTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            'Still inn minimum loggnivå. Hvis du velger \'feil\', logges bare feil. Med \'debug\' får du alle loggmeldinger. Rekkefølgen på loggnivåene er: \'feilsøke\', \'info\', \'merknad\' og \'feil\'.',
        'Set this ticket to pending' => 'Sett sak som venter tilbakemelding',
        'Sets if SLA must be selected by the agent.' => 'Angir om SLA må velges av agenten.',
        'Sets if SLA must be selected by the customer.' => 'Angir om SLA må velges av kunden.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Angir om notat må fylles ut av agenten. Kan overskrives av Ticket::Frontend::NeedAccountedTime.',
        'Sets if queue must be selected by the agent.' => 'Angir om kø må velges av agenten.',
        'Sets if service must be selected by the agent.' => 'Angir om tjenesten må velges av agenten.',
        'Sets if service must be selected by the customer.' => 'Angir om tjenesten må velges av kunden.',
        'Sets if state must be selected by the agent.' => 'Angir om tilstanden må velges av agenten.',
        'Sets if ticket owner must be selected by the agent.' => 'Angir om sakseier må velges av saksbehandleren.',
        'Sets if ticket responsible must be selected by the agent.' => 'Angir om saksansvarlig må velges av agenten.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Setter PendingTime for en sak til 0 hvis tilstanden endres til en ikke-ventende tilstand.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Angir alderen i minutter (første nivå) for utheving av køer som inneholder urørte saker.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Angir alderen i minutter (andre nivå) for utheving av køer som inneholder urørte saker.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Angir konfigurasjonsnivået til administratoren. Avhengig av konfigurasjonsnivået, vil noen sysconfig-alternativer ikke vises. Konfigurasjonsnivåene er i stigende rekkefølge: Ekspert, Avansert, Nybegynner. Jo høyere konfigurasjonsnivået er (f.eks. Nybegynner er høyest), jo mindre sannsynlig er det at brukeren ved et uhell kan konfigurere systemet på en måte som ikke lenger kan brukes.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Angir antall artikler som er synlige i forhåndsvisningsmodus for saksoversikter.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            'Angir standard artikkelkundesynlighet for nye e-postsaker i agentgrensesnittet.',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            'Angir standard artikkelkundesynlighet for nye telefonsaker i agentgrensesnittet.',
        'Sets the default article customer visibility for quick close action in the agent interface.' =>
            'Angir standard artikkelkundesynlighet for rask nærhandling i agentgrensesnittet.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Angir standard brødtekst for notater som er lagt til i skjermbildet for "lukk sak" i agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Angir standard brødtekst for notater lagt til i saksflyttingsskjermen til agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Angir standard brødtekst for notater som er lagt til i saksnotatskjermen til agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Angir standard brødtekst for notater lagt til på sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Angir standard brødtekst for notater som er lagt til i "sak venter"-skjermen til en zoomet sak i agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Angir standard brødtekst for notater som er lagt til i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Angir standard brødtekst for notater lagt til i saksansvarlig skjerm i agentgrensesnittet.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Angir standard feilmelding for påloggingsskjermen på agent- og kundegrensesnittet, den vises når en løpende systemvedlikeholdsperiode er aktiv.',
        'Sets the default link type of split tickets in the agent interface.' =>
            'Angir standard koblingstype for delte saker i agentgrensesnittet.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Angir standard koblingstype for delte saker i agentgrensesnittet.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Angir standardmeldingen for påloggingsskjermen på agent- og kundegrensesnittet, den vises når en løpende systemvedlikeholdsperiode er aktiv.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Angir standardmeldingen for varselet som vises på en løpende systemvedlikeholdsperiode.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Angir standard neste tilstand for nye telefonsaker i agentgrensesnittet.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Angir standard neste saksstatus, etter opprettelsen av en e-postsak i agentgrensesnittet.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Angir standard notattekst for nye telefonsaker. For eksempel \'Ny sak via samtale\' i agentgrensesnittet.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Angir standardprioritet for nye e-postsaker i agentgrensesnittet.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Angir standardprioritet for nye telefonsaker i agentgrensesnittet.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Angir standard avsendertype for nye e-postsaker i agentgrensesnittet.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Angir standard avsendertype for ny telefonsak i agentgrensesnittet.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Angir standardemnet for nye e-postsaker (f.eks. «e-post utgående») i agentgrensesnittet.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Angir standardemnet for nye telefonsaker (f.eks. "Telefonanrop") i agentgrensesnittet.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Angir standardemnet for notater lagt til i skjermbildet for "lukk sak" i agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Angir standardemne for notater lagt til i saksflyttingsskjermen til agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Angir standardemnet for notater som legges til i sakslappskjermen til agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Angir standardemnet for notater som legges til på sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Angir standardemnet for notater som legges til i saksventer-skjermbildet for en zoomet sak i agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Angir standardemnet for notater som legges til i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Angir standardemnet for notater som legges til i saksansvarlig skjerm i agentgrensesnittet.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Angir standardteksten for nye e-postsaker i agentgrensesnittet.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'Angir inaktivitetstiden (i sekunder) som skal gå før en økt blir avsluttet og en bruker logges av.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            'Angir maksimalt antall aktive agenter innenfor tidsrommet definert i SessionActiveTime før en tidligere advarsel vil være synlig for de påloggede agentene.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'Angir maksimalt antall aktive agenter innenfor tidsrommet definert i SessionMaxIdleTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'Angir maksimalt antall aktive kunder innenfor tidsrommet definert i SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'Angir maksimalt antall aktive økter per agent innenfor tidsrommet definert i SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'Angir maksimalt antall aktive økter per kunde innenfor tidsrommet definert i SessionMaxIdleTime.',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            'Angir metoden PGP vil bruke for å synge og kryptere e-poster. Merk Inline-metoden er ikke kompatibel med RichText-meldinger.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Angir den minimale sakstellerstørrelsen hvis "AutoIncrement" ble valgt som TicketNumberGenerator. Standard er 5, dette betyr at telleren starter fra 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Angir minuttene et varsel skal vises for varsel om kommende systemvedlikeholdsperiode.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Angir antall linjer som vises i tekstmeldinger (f.eks. sakslinjer i QueueZoom).',
        'Sets the options for PGP binary.' => 'Angir alternativene for PGP binær.',
        'Sets the password for private PGP key.' => 'Angir passordet for privat PGP-nøkkel.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Stiller inn foretrukne tidsenheter (f.eks. arbeidsenheter, timer, minutter).',
        'Sets the preferred digest to be used for PGP binary.' => 'Angir det foretrukne sammendraget som skal brukes for PGP-binær.',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTOBO_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Setter prefikset til skriptmappen på serveren, slik den er konfigurert på webserveren. Denne innstillingen brukes som en variabel, OTOBO_CONFIG_ScriptAlias som finnes i alle former for meldinger som brukes av applikasjonen, for å bygge lenker til sakene i systemet.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billettlukkingsskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billettfritekstskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billettnotatskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billetteierskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i skjermbildet for ventende billett for en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn køen i billettansvarlig skjerm for en zoomet billett i agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i skjermbildet for lukke billett i agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettmasseskjermen til agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettfritekstskjermen til agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettnotatskjermen til agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billetteierskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettventer-skjermen for en zoomet billett i agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Angir den ansvarlige agenten for billetten i billettansvarlig skjerm i agentgrensesnittet.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Angir tjenesten i skjermbildet for lukkebillett i agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Stiller inn tjenesten i billettfritekstskjermen til agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Angir tjenesten i billettnotatskjermen til agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Stiller inn tjenesten i billetteierskjermen til en zoomet billett i agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Stiller inn tjenesten i skjermbildet for ventende billett for en zoomet billett i agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Angir tjenesten i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Stiller inn tjenesten i billettansvarlig skjerm i agentgrensesnittet (Ticket::Service må være aktivert).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Angir statusen til en billett i skjermbildet for lukke billett i agentgrensesnittet.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Angir tilstanden til en billett på billett-bulkskjermen til agentgrensesnittet.',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Angir tilstanden til en billett i billettfritekstskjermen til agentgrensesnittet.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Angir statusen til en billett i billettnotatskjermen til agentgrensesnittet.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Angir tilstanden til en billett på den billettansvarlige skjermen til agentgrensesnittet.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Angir tilstanden til billetten i billetteierskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Angir tilstanden til billetten i skjermbildet for ventende billett til en zoomet billett i agentgrensesnittet.',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Angir statusen til billetten i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the stats hook.' => 'Setter statistikkroken.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Stiller inn billett eieren i lukke billettskjermen i agentgrensesnittet.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Angir billett eieren i billett bulk-skjermen i agentgrensesnittet.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Stiller inn billetteieren i billettfritekstskjermen til agentgrensesnittet.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Stiller inn billett eieren i billettnotatskjermen til agentgrensesnittet.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn billetteieren i billetteierskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn billetteieren i billettventer-skjermen for en zoomet billett i agentgrensesnittet.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Stiller inn billetteieren i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Stiller inn billett eieren i billettansvarlig skjerm i agentgrensesnittet.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Stiller inn billetttypen i skjermbildet for lukkebillett i agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Angir billetttypen på billett-bulkskjermen til agentgrensesnittet.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i billettfritekstskjermen til agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i billettnotatskjermen til agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i billetteierskjermen til en zoomet billett i agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i skjermbildet for ventende billett for en zoomet billett i agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i billettprioritetsskjermen til en zoomet billett i agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Angir billetttypen i billettansvarlig skjerm i agentgrensesnittet (Ticket::Type må være aktivert).',
        'Sets the time zone being used internally by OTOBO to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            'Setter tidssonen som brukes internt av OTOBO til e. g. lagre datoer og klokkeslett i databasen. ADVARSEL: Denne innstillingen må ikke endres når den er satt og billetter eller andre data som inneholder dato/klokkeslett er opprettet.',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTOBO time zone and the user\'s time zone.' =>
            'Angir tidssonen som skal tildeles nyopprettede brukere og som skal brukes for brukere som ennå ikke har angitt en tidssone. Dette er tidssonen som brukes som standard for å konvertere dato og klokkeslett mellom OTOBO-tidssonen og brukerens tidssone.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Angir tidsavbrudd (i sekunder) for http/ftp-nedlastinger.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Angir tidsavbrudd (i sekunder) for pakkenedlastinger. Overskriver "WebUserAgent::Timeout".',
        'Settings for the customer login screen.' => 'Innstillinger for kundepåloggingsskjermen.',
        'Shared Secret' => 'Delt hemmelighet',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Vis et ansvarlig utvalg i telefon- og e-postbilletter i agentgrensesnittet.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Vis artikkelen som rik tekst selv om rik tekstskriving er deaktivert.',
        'Show command line output.' => 'Vis kommandolinjeutdata.',
        'Show or Hide deleted articles.' => '',
        'Show queues even when only locked tickets are in.' => 'Vis køer selv når kun låste billetter er inne.',
        'Show the current owner in the customer interface.' => 'Vis gjeldende eier i kundegrensesnittet.',
        'Show the current queue in the customer interface.' => 'Vis gjeldende kø i kundegrensesnittet.',
        'Show the history for this ticket' => 'Vis historikken for denne billetten',
        'Show the ticket history' => 'Vis saks-historikk',
        'Show various content.' => 'Vis forskjellig innhold.',
        'ShowHideDeletedArticles' => '',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            'Viser en telling av vedlegg i billettzoom, hvis artikkelen har vedlegg.',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å opprette en kalenderavtale knyttet til billetten direkte fra billettzoomvisningen i agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å abonnere / avslutte abonnement på en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2".For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen som gjør det mulig å koble en billett med et annet objekt i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen som tillater sammenslåing av billetter i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å få tilgang til loggen til en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å legge til et fritekstfelt i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å legge til et notat i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å legge til et notat til en billett i hver billettoversikt over agentgrensesnittet.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en kobling i menyen for å legge til en innkommende telefonsamtale i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å legge til en utgående telefonsamtale i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å endre kunden som ba om billetten i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å endre eieren av en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å endre ansvarlig agent for en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å lukke en billett i hver billettoversikt over agentgrensesnittet.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å lukke en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:gruppe2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Viser en lenke i menyen for å slette en billett i hver billettoversikt over agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:gruppe2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å slette en billett i billettzoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen Gruppe" og innhold som "rw:gruppe1;move_into:gruppe2". For å gruppere menyelementer for nøkkelen "ClusterName" og for innholdet, bruk hvilket som helst navn du vil se i grensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen på en spesifikk gruppe i verktøylinjen.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Viser en lenke i menyen for å registrere en billett i en prosess i billettzoomvisningen til agentgrensesnittet.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å gå tilbake i sakszoomvisningen av agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Viser en lenke i menyen for å låse eller låse opp en sak i saksoversiktene til agentgrensesnittet.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å låse eller låse opp saker i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å flytte en sak i hver saksoversikt over agentgrensesnittet.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å skrive ut en sak eller en artikkel i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to quick close a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å raskt lukke en sak i hver saksoversikt over agentgrensesnittet.',
        'Shows a link in the menu to quick close a ticket in the ticket zoom view of the agent interface.' =>
            'Viser en lenke i menyen for å raskt lukke en sak i sakszoomvisningen til agentgrensesnittet.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å se historien til en sak i hver saksoversikt over agentgrensesnittet.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å se prioriteten til en sak i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å sende en utgående e-post i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Viser en lenke i menyen for å angi en sak som søppelpost i hver saksoversikt over agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke i menyen for å angi en sak som ventende i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Viser en lenke i menyen for å angi prioritet til en sak i hver saksoversikt over agentgrensesnittet.',
        'Shows a link in the menu to show/hide deleted articles in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Viser en lenke i menyen for å zoome inn en sak i saksoversiktene til agentgrensesnittet.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Viser en lenke for å få tilgang til artikkelvedlegg via en html-nettleser i zoomvisningen av artikkelen i agentgrensesnittet.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Viser en lenke for å laste ned artikkelvedlegg i zoomvisningen av artikkelen i agentgrensesnittet.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Viser en kobling for å se en zoomet e-postsak i ren tekst.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Viser en lenke for å angi en sak som søppel i sakszoomvisningen i agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2". For å gruppere menyelementer, bruk for nøkkel "ClusterName" og for innholdet et hvilket som helst navn du vil se i brukergrensesnittet. Bruk "ClusterPriority" for å konfigurere rekkefølgen til en bestemt klynge i verktøylinjen.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i skjermbildet for lukke sak i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i saksfritekstskjermen i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i saksnotatskjermen i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i saksventer-skjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Viser en liste over alle involverte agenter på denne saken, i den saksansvarlige skjermen i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i lukesaksskjermen i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i saksfritekstskjermen i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i saksnotatskjermen til agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i "sak venter"-skjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Viser en liste over alle mulige agenter (alle agenter med notatrettigheter på køen/saken) for å bestemme hvem som skal informeres om dette notatet, i den saksansvarlige skjermen i agentgrensesnittet.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Viser en forhåndsvisning av saksoversikten (CustomerInfo => 1 - viser også Customer-Info, CustomerInfoMaxSize maks. størrelse i tegn av Customer-Info).',
        'Shows all both ro and rw queues in the queue view.' => 'Viser alle både ro- og rw-køer i køvisningen.',
        'Shows all both ro and rw tickets in the service view.' => 'Viser alle både ro- og rw-saker i servicevisningen.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            'Viser alle artiklene i saken (utvidet) i agentzoomvisningen.',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            'Viser alle artiklene til saken (utvidet) i kundezoomvisningen.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Viser alle kunde-identifikatorer i et multivalg-felt (ikke brukbart hvis du har mange identifikatorer).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            'Viser alle kundebrukeridentifikatorer i et flervalgsfelt (ikke nyttig hvis du har mange kundebrukeridentifikatorer).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Viser et eier-valg i telefon- og e-post-saker i agentdelen.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Viser kundehistorikk i agentdelen.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Viser enten emnet til siste kundeartikkel eller sakens emne i "liten" oversikt.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Viser eksisterende foredldre/barn kølister i systemet i form av et tre eller en liste.',
        'Shows information on how to start OTOBO Daemon' => 'Vis informasjon om hvordan starte OTOBO Agenten',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Viser lenke til ekstern side i sakszoomvisningen til agentgrensesnittet. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Shows the article head information in the agent zoom view.' => 'Viser artikkelhodeinformasjonen i agentzoomvisningen.',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Viser artiklene sortert normalt eller reversert i saksvisning i agentdelen.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Viser kundens brukerinformasjon (telefon og e-post) når man komponerer en sak.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Viser de aktiverte saksattributtene i kundegrensesnittet (0 = Deaktivert og 1 = Aktivert).',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Viser dagens melding (MOTD) i agentdashbordet. "Gruppe" brukes til å begrense tilgangen til plugin-modulen (f.eks. Group: admin;group1;group2;). "Standard" indikerer om plugin-en er aktivert som standard eller om brukeren trenger å aktivere den manuelt. "Obligatorisk" avgjør om plugin-en alltid vises og ikke kan fjernes av agenter.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Viser Dagens Melding på innloggingsskjermen til agentdelen.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Viser sakshistorikken (nyeste først) i agentdelen.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å avslutte saker.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å flytte saker.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å masseredigere saker.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for fritekst.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for notiser.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens sakseier-skjerm i saksvisning.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Viser saksprioritetsalternativene i "sak venter"-skjermen for en zoomet sak i agentgrensesnittet.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Viser saksprioritetsalternativene i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Viser saksprioritetsalternativene i saksansvarlig skjerm i agentgrensesnittet.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            'Viser tittelfeltet i skjermbildet for lukke sak i agentgrensesnittet.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'Viser tittelfeltet i saksfritekstskjermen til agentgrensesnittet.',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            'Viser tittelfeltet i saksnotatskjermen til agentgrensesnittet.',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Viser tittelfeltet i sakseierskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Viser tittelfeltet i skjermbildet for ventende sak til en zoomet sak i agentgrensesnittet.',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Viser tittelfeltet i saksprioritetsskjermen til en zoomet sak i agentgrensesnittet.',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            'Viser tittelfeltet i den saksansvarlige skjermen til agentgrensesnittet.',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            'Viser tid i langt format (dager, timer, minutter), hvis aktivert; eller i kort format (dager, timer), hvis ikke aktivert.',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            'Viser fullstendig beskrivelse av tidsbruk (dager, timer, minutter), hvis aktivert; eller bare første bokstav (d, h, m), hvis ikke aktivert.',
        'Signature data.' => 'Signaturdata.',
        'Signatures' => 'Signaturer',
        'Simple' => 'Enkel',
        'Skin' => 'Webtema',
        'Slovak' => 'Slovakisk',
        'Slovenian' => 'Slovensk',
        'Small' => 'Liten',
        'Software Package Manager.' => 'Programvarepakkebehandling.',
        'Solution time' => 'Løsningstid',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => 'Noe beskrivelse!',
        'Some picture description!' => 'Noe bilde beskrivelse!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Sorterer sakene (stigende eller synkende) når en enkelt kø er valgt i køvisningen og etter at sakene er sortert etter prioritet. Verdier: 0 = stigende (eldst på toppen, standard), 1 = synkende (yngst på toppen). Bruk QueueID for nøkkelen og 0 eller 1 for verdi.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Sorterer sakene (stigende eller synkende) når en enkelt kø er valgt i tjenestevisningen og etter at sakene er sortert etter prioritet. Verdier: 0 = stigende (eldst på toppen, standard), 1 = synkende (yngst på toppen). Bruk ServiceID for nøkkelen og 0 eller 1 for verdi.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Eksempeloppsett for SpamAssassin. Ignorerer e-poster som er merket av SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Eksempeloppsett for SpamAssassin. Flytter merkede e-poster til køen for søppelpost.',
        'Spanish' => 'Spansk',
        'Spanish (Colombia)' => 'Spansk (Kolombia)',
        'Spanish (Mexico)' => 'Spansk (Mexico)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'Spanske stoppord for fulltekstindeks. Disse ordene vil bli fjernet fra søkeindeksen.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Angir om en agent skal motta e-postvarsling om sine egne handlinger.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            'Spesifiserer katalogen som dataene skal lagres i, hvis "FS" ble valgt for ArticleStorage.',
        'Specifies the directory where SSL certificates are stored.' => 'Spesifiserer mappen der SSL-sertifikatene lagres.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Spesifiserer mappen der private SSL-sertifikater lagres.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com). You can use the OTOBO_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Angir e-postadressen som skal brukes av programmet når du sender varsler. E-postadressen brukes til å bygge det fullstendige visningsnavnet for varslingsmasteren (dvs. "OTOBO Notifications" otobo@your.example.com). Du kan bruke OTOBO_CONFIG_FQDN-variabelen som angitt i konfigurasjonen, eller velge en annen e-postadresse.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Spesifiserer e-postadressene for å motta varslingsmeldinger fra planleggeroppgaver.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Spesifiserer gruppen der brukeren trenger rw-tillatelser slik at han kan få tilgang til "SwitchToCustomer"-funksjonen.',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            'Angir gruppen der brukeren trenger rw-tillatelser slik at de kan redigere andre brukers preferanser.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com).' =>
            'Angir navnet som skal brukes av applikasjonen når du sender varsler. Avsendernavnet brukes til å bygge det fullstendige visningsnavnet for varslingsmasteren (dvs. "OTOBO Notifications" otobo@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Angir rekkefølgen fornavnet og etternavnet til agenter skal vises i.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Spesifiserer stien til logofilen i toppen av siden (gif|jpg|png, 700x100 piksler).',
        'Specifies the path of the file for the performance log.' => 'Spesifiserer stien til ytelseslogg-filen.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av Microsoft Excel-filer i webvisningen.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av Microsoft Word-filer i webvisningen.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av PDF-filer i webvisningen.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av XML-filer.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Spesifiserer teksten som skal skrives til loggfilen for å markere et innslag fra et CGI-script.',
        'Specifies user id of the postmaster data base.' => 'Spesifiserer bruker-id for postmaster-databasen.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Angir om alle lagringsbackends skal sjekkes når du ser etter vedlegg. Dette er kun nødvendig for installasjoner der noen vedlegg er i filsystemet, og andre i databasen.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            'Angir om (MIMEBase) artikkelvedlegg skal indekseres og søkbare.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Spesifiser hvor mange underkatalognivåer som skal brukes når du oppretter hurtigbufferfiler. Dette bør forhindre at for mange cache-filer er i én katalog.',
        'Specify the password to authenticate for the first mirror database.' =>
            'Angi passordet for autentisering for den første speildatabasen.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Angi brukernavnet som skal autentiseres for den første speildatabasen.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward and bounce. Make sure that "rw" is always the last registered permission, as rw automatically grants all additional permissions.' =>
            'Standard tilgjengelige tillatelser for agenter i applikasjonen. Hvis flere tillatelser er nødvendig, kan de legges inn her. Tillatelser må defineres for å være effektive. Noen andre gode tillatelser har også blitt gitt innebygd: noter, lukk, venter, kunde, fritekst, flytt, komponer, ansvarlig, forover og sprett. Sørg for at "rw" alltid er den siste registrerte tillatelsen, da rw automatisk gir alle tilleggsrettigheter.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Starttall for statistikktelling. Nye statistikker legger til på dette tallet.',
        'Started response time escalation.' => 'Startet eskalering av responstid.',
        'Started solution time escalation.' => 'Startet opptrapping av løsningstid.',
        'Started update time escalation.' => 'Startet eskalering av oppdateringstid.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Starter et jokertegnsøk på det aktive objektet etter at koblingsobjektmasken er startet.',
        'Stat#' => 'Stat#',
        'State pre-selection for Templates' => '',
        'States' => 'Status',
        'Statistics overview.' => 'Statistikkoversikt.',
        'Statistics reports.' => 'Statistikkrapporter.',
        'Status view' => 'Statusvisning',
        'Stopped response time escalation.' => 'Stoppet eskalering av responstid.',
        'Stopped solution time escalation.' => 'Stoppet eskalering av løsningstid.',
        'Stopped update time escalation.' => 'Stoppet eskalering av oppdateringstid.',
        'Stores cookies after the browser has been closed.' => 'Lagrer informasjonskapsler (cookies) etter at nettleseren har blitt stengt.',
        'Strict' => '',
        'Strips empty lines on the ticket preview in the queue view.' => 'Tar vekk tomme linjer i saksvisningen i kølisten.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Fjerner tomme linjer på forhåndsvisningen av saken i tjenestevisningen.',
        'Support Agent' => 'Supportagent',
        'Suspend already escalated tickets.' => 'Suspender allerede eskalerte saker.',
        'Swahili' => 'Swahili',
        'Swedish' => 'Svensk',
        'Switch deleted article status view' => '',
        'Switch deleted article status view.' => '',
        'System Address Display Name' => 'Visningsnavn for systemadresse',
        'System Configuration Deployment' => 'Systemkonfigurasjonsimplementering',
        'System Configuration Group' => 'Systemkonfigurasjonsgruppe',
        'System Configuration Setting History' => 'Innstillingshistorikk for systemkonfigurasjon',
        'System Maintenance' => 'Vedlikehold av systemet',
        'Templates ↔ Attachments' => 'Maler ↔ Vedlegg',
        'Templates ↔ Queues' => 'Maler ↔ Køer',
        'Textarea' => 'Tekstareale',
        'Thai' => 'Tailandsk',
        'The PGP signature is expired.' => 'PGP-signaturen er utløpt.',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            'PGP-signaturen ble laget av en tilbakekalt nøkkel, dette kan bety at signaturen er forfalsket.',
        'The PGP signature was made by an expired key.' => 'PGP-signaturen ble laget av en utløpt nøkkel.',
        'The PGP signature with the keyid has not been verified successfully.' =>
            'PGP-signaturen med nøkkel-id er ikke verifisert.',
        'The PGP signature with the keyid is good.' => 'PGP-signaturen med keyid er god.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Agentskallets interne navn som skal brukes i agentgrensesnittet. Vennligst sjekk tilgjengelige skins i Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Kundens skins interne navn som skal brukes i kundegrensesnittet. Vennligst sjekk tilgjengelige skins i Frontend::Customer::Skins.',
        'The daemon registration for sync with S3.' => 'Daemonregistreringen for synkronisering med S3.',
        'The daemon registration for the scheduler cron task manager.' =>
            'Daemonregistreringen for planleggeren av cron-oppgavebehandling.',
        'The daemon registration for the scheduler future task manager.' =>
            'Daemonregistreringen for den fremtidige oppgavebehandleren for planleggeren.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'Daemonregistreringen for den generiske oppgavebehandleren for planleggeren.',
        'The daemon registration for the scheduler task worker.' => 'Daemonregistreringen for planleggeroppgavearbeideren.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            'Daemonregistreringen for distribusjonssynkroniseringsbehandlingen for systemkonfigurasjon.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Skilletegnet mellom TicketHook og saksnummeret, f.eks. ":".',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Varigheten i minutter etter utsendelse av en hendelse, der varslingen om ny eskalering og starthendelsene undertrykkes.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'Formatet til emnet. \'Venstre\' betyr \'[TicketHook#:12345] Noe emne\', \'Høyre\' betyr \'Noen emne [TicketHook#:12345]\', \'Ingen\' betyr \'Noen emne\' og ikke noe saksnummer. I sistnevnte tilfelle bør du bekrefte at innstillingen PostMaster::CheckFollowUpModule###0200-References er aktivert for å gjenkjenne oppfølginger basert på e-posthoder.',
        'The headline shown in the customer interface.' => 'Overskriften som vises i kundeportalen.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Identifikatoren for en sak, f.eks. Sak#, Ticket#, MinSak#. Standard er Ticket#.',
        'The logo and signet shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server. The signet will be scaled to 32px*32px, the logo to 196px*32px. (In the mobile setup both have a height of 24px with variable length.)' =>
            'Logoen og signet vises i overskriften på kundegrensesnittet. URLen til bildet kan være en relativ URL til temabildekatalogen, eller en fullstendig URL til en ekstern nettserver. Signet skal skaleres til 32px*32px, logoen til 196px*32px. (I mobiloppsettet har begge en høyde på 24px med variabel lengde.)',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'Logoen som vises i overskriften til agentgrensesnittet for temaet "standard". Se "AgentLogo" for ytterligere beskrivelse.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logoen som vises i overskriften til agentgrensesnittet. URLen til bildet kan være en relativ URL til temabildekatalogen, eller en fullstendig URL til en ekstern nettserver.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logoen som vises på toppen av påloggingsboksen til agentgrensesnittet. URLen til bildet kan være en relativ URL til temabildekatalogen, eller en fullstendig URL til en ekstern nettserver.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Maksimalt antall artikler utvidet på en enkelt side i AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Maksimalt antall artikler vist på en enkelt side i AgentTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'Maksimalt antall e-poster hentet på en gang før du kobler til serveren igjen.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            'Hemmeligheten du oppga er ugyldig. Hemmeligheten må kun inneholde bokstaver (A-Z, store bokstaver) og tall (2-7) og må bestå av 16 tegn.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Teksten i begynnelsen av emnet på et e-post-svar, f.eks. RE, SV.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Teksten i begynnelsen av emnet på en e-post som er videresendt, f.eks. VS, FW.',
        'The value of the From field' => 'Verdien i Fra-feltet',
        'Theme' => 'Tema',
        'This configuration defines all possible screens to enable or disable default columns.' =>
            'Denne konfigurasjonen definerer alle mulige skjermbilder for å aktivere eller deaktivere standardkolonner.',
        'This configuration defines all possible screens to enable or disable dynamic fields.' =>
            'Denne konfigurasjonen definerer alle mulige skjermbilder for å aktivere eller deaktivere dynamiske felt.',
        'This configuration defines if only valids or all (invalids) dynamic fields should be shown.' =>
            'Denne konfigurasjonen definerer om bare gyldige eller alle (ugyldige) dynamiske felt skal vises.',
        'This configuration defines the number of iterations that should be performed at max for calculating the WorkingTime for a Ticket. Attention: Setting this configuration to high can lead to performance issues.' =>
            'Denne konfigurasjonen definerer antall iterasjoner som skal utføres ved maks for å beregne arbeidstiden for en sak. OBS: Å sette denne konfigurasjonen til høy kan føre til ytelsesproblemer.',
        'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.' =>
            'Denne konfigurasjonen registrerer en OutputFilter-modul som injiserer javascript-funksjonaliteten for å fjerne PendingTime.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            'Denne hendelsesmodulen lagrer attributter fra CustomerUser som DynamicFields-saker. Se DynamicFieldFromCustomerUser::Mapping-innstillingen for hvordan du konfigurerer tilordningen.',
        'This is a Description for Comment on Framework.' => 'Dette er en beskrivelse for kommentar til rammeverk.',
        'This is a Description for DynamicField on Framework.' => 'Dette er en beskrivelse for dynamiske felt i rammeverket.',
        'This is the default orange - black skin for the customer interface.' =>
            'Dette er standard oransje - svart tema for kundegrensesnittet.',
        'This is the default orange - black skin.' => 'Dette er standard oransje - svart tema.',
        'This key is not certified with a trusted signature!' => 'Denne nøkkelen er ikke sertifisert med en klarert signatur!',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Denne modulen og dens PreRun()-funksjon vil, hvis satt, bli kjørt ved hver forespørsel. Denne modulen er nyttig for å sjekke brukerinnstillinger eller for å vise nyheter om nye programmer el.l.',
        'This module is being used to extend the password policy.' => 'Denne modulen brukes til å utvide passordpolicyen.',
        'This module is part of the admin area of OTOBO.' => 'Denne modulen er en del av administrasjonsområdet til OTOBO.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Dette alternativet definerer det dynamiske feltet der en enhets-ID for prosessadministrasjonsaktivitet er lagret.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Dette alternativet definerer det dynamiske feltet der en prosessstyringsprosessentitets-ID er lagret.',
        'This option defines the process tickets default lock.' => 'Dette alternativet definerer prosessakers standardlås.',
        'This option defines the process tickets default priority.' => 'Dette alternativet definerer prosessakers standardprioritet.',
        'This option defines the process tickets default queue.' => 'Dette alternativet definerer standardkøen for prosessaker.',
        'This option defines the process tickets default state.' => 'Dette alternativet definerer prosessakers standardtilstand.',
        'This option sets additional quick date buttons to pending dates. For ordering purposes one hash entry per array segment has to be set. The key is the button name, value is the value, where a single number n sets the date to n days from now, +n adds n days to the currently set date, and -n subtracts them.' =>
            '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Dette alternativet vil nekte tilgang til kundeselskapssaker, som ikke er opprettet av kundebrukeren.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Denne innstillingen lar deg overstyre den innebygde landlisten med din egen liste over land. Dette er spesielt nyttig hvis du bare vil bruke en liten utvalgt gruppe land.',
        'This setting is deprecated. Set OTOBOTimeZone instead.' => 'Denne innstillingen er utdatert. Sett OTOBOTimeZone i stedet.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            'Denne innstillingen viser sorteringsattributtene i alle oversiktsskjermer, ikke bare i køvisning.',
        'Ticket Close' => 'Lukk sak',
        'Ticket Close.' => 'Lukk sak.',
        'Ticket Compose Bounce Email.' => 'Bounce-epost for opprett sak.',
        'Ticket Compose email Answer.' => 'E-postsvar for opprett sak.',
        'Ticket Customer.' => 'Sakskunde.',
        'Ticket Forward Email.' => 'E-post for videresending av sak.',
        'Ticket FreeText.' => 'Fritekst for sak.',
        'Ticket History.' => 'Sakshistorikk.',
        'Ticket Lock.' => 'Sakslås.',
        'Ticket Masks' => '',
        'Ticket Merge.' => 'Sakssammenslåing.',
        'Ticket Move.' => 'Saksflytting.',
        'Ticket Note.' => 'Saksmerknad.',
        'Ticket Notifications' => 'Saksvarsler',
        'Ticket Outbound Email.' => 'Sak utgående e-post.',
        'Ticket Overview "Medium" Limit' => 'Begrensning for saksvisning "medium"',
        'Ticket Overview "Preview" Limit' => 'Begrensning for saksvisning "forhåndsvisning"',
        'Ticket Overview "Small" Limit' => 'Begrensning for saksvisning "liten"',
        'Ticket Owner.' => 'Sakseier.',
        'Ticket Pending.' => 'Sak venter.',
        'Ticket Print.' => 'Saksutskrift.',
        'Ticket Priority.' => 'Saksprioritet.',
        'Ticket Queue Overview' => 'Sakskøoversikt',
        'Ticket Responsible.' => 'Saksansvarlig.',
        'Ticket States' => '',
        'Ticket Types' => '',
        'Ticket Watcher' => 'Saksovervåker',
        'Ticket Zoom' => 'Sakszoom',
        'Ticket Zoom.' => 'Sakszoom.',
        'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            'Saksattributter som skal være tilgjengelige i ticket invoker-konfigurasjonsgrensesnittet (0 = synlig/valgbar, 1 = standard/forhåndsvalgt).',
        'Ticket bulk module.' => 'Saksbulkmodul.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Saksbegivenhetsmodul som utløser eskaleringsstopphendelsene.',
        'Ticket limit per page for Ticket Overview "Medium".' => 'Saksgrense per side for saksoversikt "Middels".',
        'Ticket limit per page for Ticket Overview "Preview".' => 'Saksgrense per side for saksoversikt "Forhåndsvisning".',
        'Ticket limit per page for Ticket Overview "Small".' => 'Saksgrense per side for saksoversikt "Liten".',
        'Ticket notifications' => 'Sak varslinger',
        'Ticket overview' => 'Saksoversikt',
        'Ticket plain view of an email.' => 'Sak oversikt over en e-post.',
        'Ticket split dialog.' => 'Delt dialogvisning for sak.',
        'Ticket state pre-selection for response templates' => '',
        'Ticket title' => 'Sakstittel',
        'Ticket zoom view.' => 'Sakszoomvisning.',
        'TicketNumber' => 'Ticketnummer',
        'Tickets in the following queues will not be stored on the Elasticsearch server. To apply this to existing tickets, the ticket migration has to be run via console, after changing this option.' =>
            'Saker i følgende køer vil ikke bli lagret på Elasticsearch-serveren. For å bruke dette på eksisterende saker, må saksmigreringen kjøres via konsollen, etter å ha endret dette alternativet.',
        'Tickets.' => 'Saker.',
        'Tile registration for the CustomerDashboard. Module is required.' =>
            'Flisregistrering for CustomerDashboard. Modul er nødvendig.',
        'Tile registration for the CustomerDashboard. Module is required. Optionally, an order for items can be set. The order must have the name of the item as key and the desired position as integer value.' =>
            '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tid i sekunder som legges til den faktiske tiden hvis du angir en ventende tilstand (standard: 86400 = 1 dag).',
        'To accept login information, such as an EULA or license.' => 'For å godta påloggingsinformasjon, for eksempel en EULA eller lisens.',
        'To download attachments.' => 'For å laste ned vedlegg.',
        'To view HTML attachments.' => 'For å se HTML-vedlegg.',
        'Toggles display of OTOBO FeatureAddons list in PackageManager.' =>
            'Bytter visning av OTOBO FeatureAddons-liste i PackageManager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Verktøylinjeelement for en snarvei. Ytterligere tilgangskontroll for å vise eller ikke vise denne koblingen kan gjøres ved å bruke nøkkelen "Gruppe" og innhold som "rw:gruppe1;move_into:group2".',
        'Translate the country names in the country selection. The CLDR country codes will be stored in the database. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Translate the language names in the language selection. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Transportvalg for avtalemeldinger. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Transportvalg for saksvarsler. Vennligst merk: å sette \'Aktiv\' til 0 vil bare forhindre agenter fra å redigere innstillingene for denne gruppen i sine personlige preferanser, men vil fortsatt tillate administratorer å redigere innstillingene til en annen brukers vegne. Bruk \'PreferenceGroup\' for å kontrollere i hvilket område disse innstillingene skal vises i brukergrensesnittet.',
        'Tree view' => 'Trevisning',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            'Utløsere legger til eller oppdatering av automatiske kalenderavtaler basert på bestemte sakstider.',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Utløser sak-eskaleringshendelser og varslingshendelser for eskalering.',
        'Turkish' => 'Tyrkisk',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Slår av SSL-sertifikatvalidering, for eksempel hvis du bruker en gjennomsiktig HTTPS-proxy. Bruk på eget ansvar!',
        'Turns on drag and drop for the main navigation.' => 'Slår på dra og slipp for hovednavigasjonen.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Slår på den eksterne ip-adressekontrollen. Den bør ikke aktiveres hvis applikasjonen brukes, for eksempel via en proxy-farm eller en oppringt tilkobling, fordi den eksterne ip-adressen stort sett er forskjellig for forespørslene.',
        'Tweak the system as you wish.' => 'Juster systemet som du ønsker.',
        'Type of daemon log rotation to use: Choose \'OTOBO\' to let OTOBO system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            'Type daemonloggrotasjon som skal brukes: Velg "OTOBO" for å la OTOBO-systemet håndtere filrotasjonen, eller velg "Ekstern" for å bruke en tredjeparts rotasjonsmekanisme (dvs. logrotere). Merk: Ekstern rotasjonsmekanisme krever sin egen og uavhengige konfigurasjon.',
        'Ukrainian' => 'Ukrainsk',
        'Unlock tickets that are past their unlock timeout.' => 'Lås opp saker som har passert opplåsingstiden.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Lås opp saker hver gang en lapp legges til og eieren ikke er på kontoret.',
        'Unlocked ticket.' => 'Sak gjort tilgjengelig.',
        'Upcoming Events' => 'Kommende hendelser',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Oppdater sak "Sett"-flagget hvis hver artikkel ble sett eller en ny artikkel ble opprettet.',
        'Update time' => 'Oppdateringstid',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Oppdaterer sak-eskaleringsindeksen etter at et saksattributt ble oppdatert.',
        'Updates the ticket index accelerator.' => 'Oppdaterer saksindeksakseleratoren.',
        'Upload your PGP key.' => 'Last opp PGP-nøkkelen din.',
        'Upload your S/MIME certificate.' => 'Last opp S/MIME-sertifikatet ditt.',
        'Use Redis::Fast instead of Redis.' => 'Bruk Redis::Fast i stedet for Redis.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Bruk ny type valg- og autofullfør-felt i agentgrensesnittet, der det er aktuelt (InputFields).',
        'Use specified Redis logical database.' => 'Bruk spesifisert Redis logisk database.',
        'User Profile' => 'Brukerprofil',
        'UserFirstname' => 'Brukers-fornavn',
        'UserLastname' => 'Brukers-etternavn',
        'Users, Groups & Roles' => 'Brukere, grupper og roller',
        'Uses richtext for viewing and editing ticket notification.' => 'Bruker rik tekst for å vise og redigere saksvarsel.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Bruker rik tekst for visning og redigering: artikler, hilsener, signaturer, standardmaler, automatiske svar og varsler.',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'Vis resultater etter ytelsesmålinger.',
        'View stored article version.' => '',
        'Watch this ticket' => 'Overvåk denne saken',
        'Watched Tickets' => 'Overvåkede saker',
        'Watched Tickets.' => 'Overvåkede saker.',
        'We are performing scheduled maintenance.' => 'Vi utfører et planlagt vedlikehold.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Vi utfører et planlagt vedlikehold. Innlogging er for øyeblikket ikke tilgjengelig.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Vi utfører et planlagt vedlikehold. Sidene vil være tilgjengelig om ikke så lat for lenge.',
        'We have changed the default ticket unlock behaviour in OTOBO 10.1. Now, the ticket is not only unlocked, but also handed over to the system user again. Thus, the behaviour is clearer, but it is no longer possible to read out who last edited the ticket. Please deactivate this option to restore the behaviour of OTRS versions 2 to 6 and OTOBO version 10.0.' =>
            '',
        'Web Service' => 'Nettjeneste',
        'Web Services' => 'Webtjenester',
        'Welcome text for the dashboard header. Name will be inserted to %s of the WelcomeText. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" and "UserLogin" will be substituted.' =>
            'Velkomsttekst for dashbordoverskriften. Navn vil bli satt inn i %s av velkomstteksten. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" og "UserLogin" vil bli erstattet.',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            'Når agenten oppretter en sak, om saken automatisk låses til agenten eller ikke.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Når sakene er slått sammen, legges det automatisk til et notat til saken som ikke lenger er aktiv. Her kan du definere teksten til denne notaten (denne teksten kan ikke endres av agenten).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Når sakene er slått sammen, legges det automatisk til et notat til saken som ikke lenger er aktiv. Her kan du definere emnet for dette notatet (dette emnet kan ikke endres av agenten).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Når saker er slått sammen, kan kunden informeres per e-post ved å sette avkrysningsboksen "Informer avsender". I dette tekstområdet kan du definere en forhåndsformatert tekst som senere kan endres av agentene.',
        'Whether extended customer information is shown in the ticket print screen of the customer interface.' =>
            'Om utvidet kundeinformasjon vises i saksutskriftsskjermen i kundegrensesnittet.',
        'Whether fields should be automatically filled (1), and in that case also be hidden from ticket formulars (2).' =>
            'Om felt skal fylles ut automatisk (1), og i så fall også skjules for saksformlene (2).',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Hvorvidt man skal samle inn metainformasjon fra artikler ved hjelp av filtre konfigurert i Ticket::Frontend::ZoomCollectMetaFilters.',
        'Whether the execution of TicketACL can be avoided by checking cached field dependencies. This can improve loading times of ticket formulars, but has to be disabled, if ACLModules are to be used for Ticket- and Form-ReturnTypes.' =>
            'Om kjøringen av TicketACL kan unngås ved å sjekke bufrede feltavhengigheter. Dette kan forbedre lastetidene for saksformlere, men må deaktiveres hvis ACLModules skal brukes for sak- og skjema-returtyper.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            'Om du skal tvinge omdirigering av alle forespørsler fra http til https-protokollen. Kontroller at webserveren din er riktig konfigurert for https-protokollen før du aktiverer dette alternativet.',
        'Yes, but hide archived tickets' => 'Ja, men skjul de arkiverte sakene',
        'Your email with ticket number "<OTOBO_TICKET>" is bounced to "<OTOBO_BOUNCE_TO>". Contact this address for further information.' =>
            'Din e-post med saksnummeret «<OTOBO_TICKET>» blir returnert til «<OTOBO_BOUNCE_TO>». Kontakt denne adressen for mer informasjon.',
        'Your email with ticket number "<OTOBO_TICKET>" is merged to "<OTOBO_MERGE_TO_TICKET>".' =>
            'Din e-postsak med nummer "<OTOBO_TICKET>" er flettet med "<OTOBO_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Ditt køvalg av dine foretrukne køer. Du blir også varslet om disse køene via e-post hvis aktivert.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Ditt tjenestevalg av dine foretrukne tjenester. Du blir også varslet om disse tjenestene via e-post hvis aktivert.',
        'Zoom' => 'Detaljer',
        'attachment' => 'vedlegg',
        'bounce' => 'email!;Kan',
        'compose' => 'komponere',
        'debug' => 'feilsøke',
        'error' => 'feil',
        'forward' => 'framover',
        'info' => 'info',
        'inline' => 'på linje',
        'normal' => 'normal',
        'notice' => 'merknad',
        'pending' => 'reminder',
        'phone' => 'telefon',
        'responsible' => 'ansvarlig',
        'reverse' => 'motsatt',
        'stats' => 'statistikk',

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
        'All translations must be filled!',
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
        'Are you sure you want to delete this article?',
        'Are you sure you want to remove all user values?',
        'Are you sure you want to restore this article?',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article Delete',
        'Article Restore',
        'Article already marked as deleted.',
        'Article deleted successfully!',
        'Article display',
        'Article filter',
        'Article not available for restoring.',
        'Article restored successfully!',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'At least one translation must be filled!',
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
        'Close',
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
        'Delete this template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting template...',
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
        'Do you really want to delete this customer dashboard info tile entry?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this language?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this report?',
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
        'Error trying to create CodeMirror instance, please check configuration!',
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
        'Information',
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
        'Missing Translations',
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
        'Template was deleted successfully.',
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
        'There was an error deleting the template. Please check the logs for more information.',
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
