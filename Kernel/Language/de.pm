# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2010 Thomas Kaltenbrunner <tkaltenbrunner at opc.de>
# Copyright (C) 2019-2020 RotherOSS GmbH, https://otobo.ch/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::de;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.984205330700888;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL-Verwaltung',
        'Actions' => 'Aktionen',
        'Create New ACL' => 'Neue ACL erstellen',
        'Deploy ACLs' => 'ACLs in Betrieb nehmen',
        'Export ACLs' => 'ACLs exportieren',
        'Filter for ACLs' => 'Filter für ACLs',
        'Just start typing to filter...' => 'Beginnen Sie mit der Eingabe, um zu filtern...',
        'Configuration Import' => 'Konfigurationsimport',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hier können Sie über eine Konfigurationsdatei ACLs ins System importieren. Diese Datei muss das vom ACL Editor verwendete .yml Format haben.',
        'This field is required.' => 'Dieses Feld wird benötigt.',
        'Overwrite existing ACLs?' => 'Existierende ACLs überschreiben?',
        'Upload ACL configuration' => 'ACL-Konfiguration hochladen',
        'Import ACL configuration(s)' => 'ACL-Konfiguration(en) importieren',
        'Description' => 'Beschreibung',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Wenn Sie eine ACL erstellen möchten, können Sie sie von einem anderen System importieren oder eine ganz neue erstellen.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Änderungen an den ACLs wirken sich erst aus, wenn Sie die Konfiguration in Betrieb nehmen. Dabei werden die Änderungen in der Konfiguration gespeichert.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Hinweis: Diese Tabelle stellt die Ausführungsreihenfolge der ACLs dar. Wenn Sie die Reihenfolge ändern möchten, ändern Sie bitte die Namen der betroffenen ACLs.',
        'ACL name' => 'ACL-Name',
        'Comment' => 'Kommentar',
        'Validity' => 'Gültigkeit',
        'Export' => 'Export',
        'Copy' => 'Kopieren',
        'No data found.' => 'Keine Daten gefunden.',
        'No matches found.' => 'Keine Treffer gefunden.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL %s bearbeiten',
        'Edit ACL' => 'ACL bearbeiten',
        'Go to overview' => 'Zur Übersicht gehen',
        'Delete ACL' => 'ACL löschen',
        'Delete Invalid ACL' => 'Ungültige ACL löschen',
        'Match settings' => 'Filterbedingungen',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Stellt die Filterbedingungen dieser ACL ein. Verwenden Sie \'Properties\' um den Wert aus dem aktuellen Bildschirm zu prüfen oder \'PropertiesDatabase\' für den Wert des Tickets, wie es in der Datenbank gespeichert ist.',
        'Change settings' => 'Werte ändern',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Stellt die Wertänderungen ein für den Fall, dass die Filterbedingungen zutreffen. Hierbei ist \'Possible\' eine Positivliste und \'PossibleNot\' eine Negativliste.',
        'Check the official %sdocumentation%s.' => 'Überprüfen Sie die offizielle %sdocumentation%s.',
        'Show or hide the content' => 'Inhalt einblenden oder ausblenden',
        'Edit ACL Information' => 'ACL-Information bearbeiten',
        'Name' => 'Name',
        'Stop after match' => 'Stoppen nach Treffer',
        'Edit ACL Structure' => 'ACL-Struktur bearbeiten',
        'Save ACL' => 'ACL speichern',
        'Save' => 'Speichern',
        'or' => 'oder',
        'Save and finish' => 'Speichern und abschließen',
        'Cancel' => 'Abbrechen',
        'Do you really want to delete this ACL?' => 'Wollen Sie diese ACL wirklich löschen?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Neue ACL durch Eingabe der Daten erstellen. Nach Erstellung der ACL ist es möglich, Konfigurationsparameter im Bearbeitungsmodus einzufügen.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Kalenderverwaltung',
        'Add Calendar' => 'Neuen Kalender hinzufügen',
        'Edit Calendar' => 'Kalender bearbeiten',
        'Calendar Overview' => 'Kalenderübersicht',
        'Add new Calendar' => 'Einen neuen Kalender hinzufügen',
        'Import Appointments' => 'Termine importieren',
        'Calendar Import' => 'Kalender importieren',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Hier können Sie eine Konfigurationsdatei hochladen, um einen Kalender in Ihr System zu importieren. Die Datei muss im .yml Format vorliegen, so wie sie in der Kalenderverwaltung exportiert wurde.',
        'Overwrite existing entities' => 'Bestehende Einträge überschreiben',
        'Upload calendar configuration' => 'Kalenderkonfiguration hochladen',
        'Import Calendar' => 'Kalender importieren',
        'Filter for Calendars' => 'Filter für Kalender',
        'Filter for calendars' => 'Filter für Kalender',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Abhängig von der Gruppenzugehörigkeit wird das System Benutzern den Zugriff anhand ihrer Berechtigungen erlauben bzw. verweigern.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Nur lesen: Benutzer können alle Termine im Kalender sehen und exportieren.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Verschieben in: Benutzer können Termine innerhalb eines Kalenders bearbeiten, diese jedoch nicht in andere Kalender verschieben.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Erstellen: Benutzer können Termine im Kalender erstellen und löschen.',
        'Read/write: users can manage the calendar itself.' => 'Lesen/Schreiben: Benutzer können die Kalender an sich verwalten.',
        'Group' => 'Gruppe',
        'Changed' => 'Geändert',
        'Created' => 'Erstellt',
        'Download' => 'Herunterladen',
        'URL' => 'URL',
        'Export calendar' => 'Kalender exportieren',
        'Download calendar' => 'Kalender herunterladen',
        'Copy public calendar URL' => 'Öffentliche Kalender-URL kopieren',
        'Calendar' => 'Kalender',
        'Calendar name' => 'Kalendername',
        'Calendar with same name already exists.' => 'Ein Kalender mit gleichem Namen existiert bereits.',
        'Color' => 'Farbe',
        'Permission group' => 'Berechtigungsgruppe',
        'Ticket Appointments' => 'Ticket-Termine',
        'Rule' => 'Regel',
        'Remove this entry' => 'Diesen Eintrag entfernen',
        'Remove' => 'Entfernen',
        'Start date' => 'Startzeitpunkt',
        'End date' => 'Endzeitpunkt',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Verwenden Sie die folgenden Optionen, um einzugrenzen, welche Ticket-Termine automatisch erstellt werden sollen.',
        'Queues' => 'Queues',
        'Please select a valid queue.' => 'Bitte wählen Sie eine gültige Queue aus.',
        'Search attributes' => 'Suchattribute',
        'Add entry' => 'Eintrag hinzufügen',
        'Add' => 'Hinzufügen',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definieren Sie Regeln, um automatisch Termine in diesem Kalender zu erstellen, welche auf Ticketdaten basieren.',
        'Add Rule' => 'Regel hinzufügen',
        'Submit' => 'Übermitteln',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Termine importieren',
        'Go back' => 'Zurück',
        'Uploaded file must be in valid iCal format (.ics).' => 'Die hochgeladene Datei muss in einem gültigen iCal-Format (.ics) vorliegen.',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Sollte ein gewünschter Kalender hier nicht aufgelistet sein, stellen Sie bitte sicher, dass Sie mindestens die Berechtigung zum Erstellen von Kalendern besitzen.',
        'Upload' => 'Hochladen',
        'Update existing appointments?' => 'Existierende Termine überschreiben?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Alle existierenden Termine mit der selben "UniqueID" im entsprechenden Kalender werden überschrieben.',
        'Upload calendar' => 'Kalender hochladen',
        'Import appointments' => 'Termine importieren',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Verwaltung von Terminbenachrichtigungen',
        'Add Notification' => 'Benachrichtigung hinzufügen',
        'Edit Notification' => 'Benachrichtigung bearbeiten',
        'Export Notifications' => 'Benachrichtigungen exportieren',
        'Filter for Notifications' => 'Filter für Benachrichtigungen',
        'Filter for notifications' => 'Filter für Benachrichtigungen',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Hier können Sie eine Konfigurationsdatei hochladen, mit der Terminbenachrichtigungen in das System importiert werden können. Die Datei muss im .yml-Format vorliegen, so wie sie auch vom Terminbenachrichtigungs-Modul exportiert wird.',
        'Overwrite existing notifications?' => 'Bestehende Benachrichtigungen überschreiben?',
        'Upload Notification configuration' => 'Benachrichtigungs-Konfiguration hochladen',
        'Import Notification configuration' => 'Benachrichtigungs-Konfiguration importieren',
        'List' => 'Liste',
        'Delete' => 'Löschen',
        'Delete this notification' => 'Diese Benachrichtigung löschen',
        'Show in agent preferences' => 'In Agenten-Einstellungen anzeigen',
        'Agent preferences tooltip' => 'Kurzinfo für die persönlichen Agenten-Einstellungen',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Diese Nachricht wird als Kurzinfo für diese Benachrichtigung im Einstellungsbildschirm der Agenten-Einstellungen angezeigt.',
        'Toggle this widget' => 'Dieses Widget umschalten',
        'Events' => 'Ereignisse',
        'Event' => 'Ereignis',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Hier können Sie auswählen, welche Ereignisse diese Benachrichtigung auslösen. Ein zusätzlicher Terminfilter kann weiter unten eingestellt werden, um die Benachrichtigungen nur für Termine mit bestimmten Merkmalen zu versenden.',
        'Appointment Filter' => 'Terminfilter',
        'Type' => 'Typ',
        'Title' => 'Titel',
        'Location' => 'Standort',
        'Team' => 'Team',
        'Resource' => 'Ressource',
        'Recipients' => 'Empfänger',
        'Send to' => 'Senden an',
        'Send to these agents' => 'An diese Agenten senden',
        'Send to all group members (agents only)' => 'An alle Gruppenmitglieder senden (gilt nur für Agenten)',
        'Send to all role members' => 'An alle Rollenmitglieder senden',
        'Send on out of office' => 'Trotz "nicht im Büro" senden',
        'Also send if the user is currently out of office.' => 'Auch senden, wenn der Benutzer nicht am Arbeitsplatz ist.',
        'Once per day' => 'Einmal pro Tag',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Nur einmal am Tag pro Termin und Benachrichtigungs-Transportmethode versenden.',
        'Notification Methods' => 'Benachrichtigungsmethoden',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Dies sind die verfügbaren Methoden für den Versand der Benachrichtigungen an jeden Empfänger. Bitte wählen Sie unten mindestens eine Methode aus.',
        'Enable this notification method' => 'Diese Benachrichtigungsmethode aktivieren',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Mindestens eine Methode ist für jede Benachrichtigung erforderlich.',
        'Active by default in agent preferences' => 'Standardmäßig aktiv in den Agenten-Einstellungen',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Das ist der Standardwert für zugewiesene Empfänger-Agenten, die für diese Benachrichtigung in ihren Einstellungen noch keine Auswahl getroffen haben. Wenn das Feld ausgewählt ist, wird die Benachrichtigung solchen Agenten zugestellt.',
        'This feature is currently not available.' => 'Diese Funktion ist derzeit nicht verfügbar.',
        'Upgrade to %s' => 'Auf %s upgraden',
        'Please activate this transport in order to use it.' => 'Um diesen Transport zu nutzen, müssen Sie ihn zunächst aktivieren.',
        'No data found' => 'Keine Daten gefunden',
        'No notification method found.' => 'Keine Benachrichtigungsmethode gefunden.',
        'Notification Text' => 'Benachrichtigungstext',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Diese Sprache ist im System nicht verfügbar oder deaktiviert. Der Benachrichtigungstext kann gelöscht werden, falls er nicht mehr benötigt wird.',
        'Remove Notification Language' => 'Benachrichtigungssprache entfernen',
        'Subject' => 'Betreff',
        'Text' => 'Text',
        'Message body' => 'Nachrichteninhalt',
        'Add new notification language' => 'Neue Sprache für Benachrichtigungen hinzufügen',
        'Save Changes' => 'Änderungen speichern',
        'Tag Reference' => 'Tag-Referenz',
        'Notifications are sent to an agent.' => 'Benachrichtigungen werden an einen Agenten gesendet.',
        'You can use the following tags' => 'Sie können folgende Tags verwenden',
        'To get the first 20 character of the appointment title.' => 'Die ersten 20 Zeichen des Terminbetreffs.',
        'To get the appointment attribute' => 'Die Termin-Attribute',
        ' e. g.' => ' z. B.',
        'To get the calendar attribute' => 'Die Kalender-Attribute',
        'Attributes of the recipient user for the notification' => 'Attribute der Benutzerdaten des Empfängers der Benachrichtigung',
        'Config options' => 'Konfigurationsoptionen',
        'Example notification' => 'Beispiel-Benachrichtigung',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Zusätzliche Empfänger-E-Mail-Adressen',
        'This field must have less then 200 characters.' => 'Dieses Feld darf nur aus genau oder weniger als 200 Zeichen bestehen.',
        'Article visible for customer' => 'Artikel für Kunde sichtbar',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Ein Artikel wird erstellt, wenn die Benachrichtigung an den Kunden oder an eine zusätzliche E-Mail-Adresse versendet wird.',
        'Email template' => 'E-Mail-Vorlage',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Benutzen Sie diese Vorlage, um die komplette E-Mail zu generieren (nur für HTML-E-Mails).',
        'Enable email security' => 'E-Mail-Sicherheit aktivieren',
        'Email security level' => 'E-Mail-Sicherheitsstufe',
        'If signing key/certificate is missing' => 'Wenn Schlüssel/Zertifikat zum Signieren fehlen',
        'If encryption key/certificate is missing' => 'Wenn Schlüssel/Zertifikat zum Verschlüsseln fehlen',

        # Template: AdminAttachment
        'Attachment Management' => 'Verwaltung von Anhängen',
        'Add Attachment' => 'Anhang hinzufügen',
        'Edit Attachment' => 'Anhang bearbeiten',
        'Filter for Attachments' => 'Filter für Anhänge',
        'Filter for attachments' => 'Filter für Anhänge',
        'Filename' => 'Dateiname',
        'Download file' => 'Datei herunterladen',
        'Delete this attachment' => 'Diesen Anhang entfernen',
        'Do you really want to delete this attachment?' => 'Möchten Sie diesen Anhang wirklich löschen?',
        'Attachment' => 'Anhang',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Verwaltung automatischer Antworten',
        'Add Auto Response' => 'Automatische Antwort hinzufügen',
        'Edit Auto Response' => 'Automatische Antwort bearbeiten',
        'Filter for Auto Responses' => 'Filter für automatische Antworten',
        'Filter for auto responses' => 'Filter für automatische Antworten',
        'Response' => 'Antwort',
        'Auto response from' => 'Automatische Antwort von',
        'Reference' => 'Referenz',
        'To get the first 20 character of the subject.' => 'Die ersten 20 Zeichen des Betreffs.',
        'To get the first 5 lines of the email.' => 'Die ersten fünf Zeilen der Nachricht.',
        'To get the name of the ticket\'s customer user (if given).' => 'Der Namen des Kundenbenutzers (falls vorhanden) eines Tickets.',
        'To get the article attribute' => 'Die Artikel-Attribute',
        'Options of the current customer user data' => 'Attribute des aktuellen Kunden',
        'Ticket owner options' => 'Attribute des Ticketbesitzers',
        'Ticket responsible options' => 'Attribute des Ticket-Verantwortlichen',
        'Options of the current user who requested this action' => 'Attribute des aktuellen Benutzers, der die Aktion angefordert hat',
        'Options of the ticket data' => 'Attribute der Ticketdaten',
        'Options of ticket dynamic fields internal key values' => 'Interne Werte der Dynamischen Feldern von Tickets',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Angezeigte Werte der Dynamischen Felder von Tickets, nutzbar mit Dropdown und Multiselect',
        'Example response' => 'Beispielantwort',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud-Services-Verwaltung',
        'Support Data Collector' => 'Supportdaten-Analyse',
        'Support data collector' => 'Supportdaten-Analyse',
        'Hint' => 'Hinweis',
        'Currently support data is only shown in this system.' => 'Supportdaten werden derzeit nur auf diesem System angezeigt.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Konfiguration',
        'Send support data' => 'Supportdaten senden',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Aktualisieren',
        'System Registration' => 'Systemregistrierung',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Registrieren Sie dieses System',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Die Systemregistrierung ist für Ihr System deaktiviert. Bitte überprüfen Sie die Konfiguration.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Bitte beachten Sie, dass die Verwendung von OTOBO Cloud-Services ein registriertes System voraussetzt.',
        'Register this system' => 'Registrieren Sie dieses System',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Hier können Sie verfügbare Cloud-Services konfigurieren die sicher mit %s kommunizieren.',
        'Available Cloud Services' => 'Verfügbare Cloud-Services',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Kommunikationsprotokoll',
        'Time Range' => 'Zeitbereich',
        'Show only communication logs created in specific time range.' =>
            'Nur Verbindungsprotokolle anzeigen, die in einem bestimmten Zeitraum erfasst wurden.',
        'Filter for Communications' => 'Filter für Kommunikationen',
        'Filter for communications' => 'Filter für Kommunikationen',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Dieser Bereich zeigt eine Übersicht von eingehender und ausgehender Kommunikation.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Sie können die Sortierung und Reihenfolge von Spalten durch Anklicken der Spaltenköpfe verändern.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Wenn Sie einen Eintrag anklicken, erhalten Sie eine Detailansicht der jeweiligen Nachricht.',
        'Status for: %s' => 'Status für: %s',
        'Failing accounts' => 'Fehlschlagende Konten',
        'Some account problems' => 'Einige Kontoprobleme',
        'No account problems' => 'Keine Kontoprobleme',
        'No account activity' => 'Keine Kontoaktivität',
        'Number of accounts with problems: %s' => 'Anzahl der Konten mit Problemen: %s',
        'Number of accounts with warnings: %s' => 'Anzahl der Konten mit Warnungen: %s',
        'Failing communications' => 'Fehlgeschlagene Verbindungen',
        'No communication problems' => 'Keine Verbindungsprobleme',
        'No communication logs' => 'Keine Verbindungsprotokolle',
        'Number of reported problems: %s' => 'Anzahl gemeldeter Probleme: %s',
        'Open communications' => 'Offene Verbindungen',
        'No active communications' => 'Keine aktiven Verbindungen',
        'Number of open communications: %s' => 'Offene Verbindungen: %s',
        'Average processing time' => 'Durchschnittliche Verarbeitungszeit',
        'List of communications (%s)' => 'Kommunikationsliste (%s)',
        'Settings' => 'Einstellungen',
        'Entries per page' => 'Einträge pro Seite',
        'No communications found.' => 'Keine Verbindungen gefunden.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Kontostatus',
        'Back to overview' => 'Zurück zur Übersicht',
        'Filter for Accounts' => 'Filter für Konten',
        'Filter for accounts' => 'Filter für Konten',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Sie können die Sortierung und Reihenfolge dieser Spalten durch Anklicken der Spaltenköpfe verändern.',
        'Account status for: %s' => 'Kontostatus für: %s',
        'Status' => 'Status',
        'Account' => 'Konto',
        'Edit' => 'Bearbeiten',
        'No accounts found.' => 'Keine Konten gefunden.',
        'Communication Log Details (%s)' => 'Details des Kommunikationsprotokolls (%s)',
        'Direction' => 'Richtung',
        'Start Time' => 'Startzeit',
        'End Time' => 'Endzeit',
        'No communication log entries found.' => 'Keine Protokolleinträge gefunden.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Dauer',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Priorität',
        'Module' => 'Modul',
        'Information' => 'Information',
        'No log entries found.' => 'Keine Protokolleinträge gefunden.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Detailansicht für Verbindung %s, gestartet um %s',
        'Filter for Log Entries' => 'Filter für Protokolleinträge',
        'Filter for log entries' => 'Filter für Protokolleinträge',
        'Show only entries with specific priority and higher:' => 'Nur Einträge mit bestimmter Priorität (und höher) anzeigen:',
        'Communication Log Overview (%s)' => 'Kommunikationsprotokoll-Übersicht (%s)',
        'No communication objects found.' => 'Keine Kommunikationsobjekte gefunden.',
        'Communication Log Details' => 'Verbindungsprotokoll-Details',
        'Please select an entry from the list.' => 'Bitte wählen Sie einen Eintrag aus der Liste.',

        # Template: AdminContactWD
        'Contact with data management' => 'Kontaktdaten',
        'Contact with data' => 'Kontaktdaten',
        'Add contact with data' => 'Kontaktdaten hinzufügen',
        'Edit contact with data' => 'Kontaktdaten bearbeiten',
        'Back to search results' => 'Zurück zum Suchergebnis',
        'Select' => 'Auswahl',
        'Search' => 'Suche',
        'Wildcards like \'*\' are allowed.' => 'Platzhalter wie \'*\' sind erlaubt.',
        'Please enter a search term to look for contacts with data.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Kunden zu suchen.',
        'Valid' => 'Gültig',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Kundenverwaltung',
        'Add Customer' => 'Kunde hinzufügen',
        'Edit Customer' => 'Kunde bearbeiten',
        'List (only %s shown - more available)' => 'Liste (nur %s angezeigt - mehr verfügbar)',
        'total' => 'gesamt',
        'Please enter a search term to look for customers.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Kunden zu suchen.',
        'Customer ID' => 'Kundennummer',
        'Please note' => 'Bitte beachten',
        'This customer backend is read only!' => 'Dieses Kunden-Backend kann nicht bearbeitet werden!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Kunden-Gruppen-Zuordnungen verwalten',
        'Notice' => 'Bemerkung',
        'This feature is disabled!' => 'Diese Funktion ist deaktiviert!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Verwenden Sie diese Funktion, wenn Sie Gruppenberechtigungen für Kunden definieren möchten.',
        'Enable it here!' => 'Hier aktivieren!',
        'Edit Customer Default Groups' => 'Standardgruppen für Kunden bearbeiten',
        'These groups are automatically assigned to all customers.' => 'Diese Gruppen werden allen Kunden automatisch zugewiesen.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Sie können diese Gruppen über die Konfigurationseinstellung "CustomerGroupCompanyAlwaysGroups" bearbeiten.',
        'Filter for Groups' => 'Filter für Gruppen',
        'Select the customer:group permissions.' => 'Wählen Sie die Gruppenberechtigungen für Kunden aus.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Wenn nichts ausgewählt ist, hat der Kunde in dieser Gruppe keine Rechte (und kann nicht auf Tickets zugreifen).',
        'Search Results' => 'Suchergebnisse',
        'Customers' => 'Kunden',
        'Groups' => 'Gruppen',
        'Change Group Relations for Customer' => 'Gruppenzuordnungen verwalten für Kunden',
        'Change Customer Relations for Group' => 'Kundenzuordnungen verwalten für Gruppe',
        'Toggle %s Permission for all' => 'Recht %s für alle umschalten',
        'Toggle %s permission for %s' => 'Recht %s für %s umschalten',
        'Customer Default Groups:' => 'Standard-Kundengruppen:',
        'No changes can be made to these groups.' => 'An diesen Gruppen können keine Änderungen vorgenommen werden.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Nur-Lesen-Zugriff auf Tickets in diesen Gruppen/Queues.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Voller Schreib- und Lesezugriff auf Tickets in der Queue/Gruppe.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Kundenbenutzer-Verwaltung',
        'Add Customer User' => 'Kundenbenutzer hinzufügen',
        'Edit Customer User' => 'Kundenbenutzer bearbeiten',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Kundenbenutzer werden für die Bereitstellung einer Kundenhistorie und für die Anmeldung über den Kundenzugang benötigt.',
        'List (%s total)' => 'Liste (%s insgesamt)',
        'Username' => 'Benutzername',
        'Email' => 'E-Mail',
        'Last Login' => 'Letzte Anmeldung',
        'Login as' => 'Anmelden als',
        'Switch to customer' => 'Zum Kunden wechseln',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Dieses Kunden-Backend kann nicht bearbeitet werden, aber die persönlichen Einstellungen der Kundenbenutzer sind editierbar!',
        'This field is required and needs to be a valid email address.' =>
            'Dieses Feld wird benötigt und muss eine gültige E-Mail-Adresse sein.',
        'This email address is not allowed due to the system configuration.' =>
            'Diese E-Mail-Adresse wird von der aktuellen Systemkonfiguration nicht zugelassen.',
        'This email address failed MX check.' => 'Für diese E-Mail-Adresse ist die MX-Prüfung fehlgeschlagen.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS-Problem, bitte prüfen Sie ihre Konfiguration und das Fehlerprotokoll.',
        'The syntax of this email address is incorrect.' => 'Die Syntax dieser E-Mail-Adresse ist fehlerhaft.',
        'This CustomerID is invalid.' => 'Diese Kundennummer ist ungültig.',
        'Effective Permissions for Customer User' => 'Effektive Berechtigungen für Kundenbenutzer',
        'Group Permissions' => 'Gruppenberechtigungen',
        'This customer user has no group permissions.' => 'Dieser Kundenbenutzer hat keine Gruppenberechtigungen.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Die obige Tabelle zeigt die effektiven Gruppenberechtigungen für den Kundenbenutzer. Die Matrix berücksichtigt dabei auch alle vererbten Berechtigungen (z.B. durch Kundengruppen). Hinweis: Die Tabelle zeigt Änderungen in diesem Bildschirm erst nach dem Speichern.',
        'Customer Access' => 'Kundenzugang',
        'Customer' => 'Kunde',
        'This customer user has no customer access.' => 'Dieser Kundenbenutzer hat keinen Kundenzugang.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Die obige Tabelle zeigt den gewährten Kundenzugang für den Kundenbenutzer nach Berechtigungskontext. Die Matrix berücksichtigt dabei auch alle vererbten Berechtigungen (z.B. durch Kundengruppen). Hinweis: Die Tabelle zeigt Änderungen in diesem Bildschirm erst nach dem Speichern.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Beziehungen zwischen Kundenbenutzern und Kunden verwalten',
        'Select the customer user:customer relations.' => 'Beziehung zwischen Kundenbenutzer und Kunde auswählen.',
        'Customer Users' => 'Kundenbenutzer',
        'Change Customer Relations for Customer User' => 'Kundenbeziehungen für Kundenbenutzer ändern',
        'Change Customer User Relations for Customer' => 'Kundenbenutzerbeziehungen für Kunde ändern',
        'Toggle active state for all' => 'Aktiv-Status für alle umschalten',
        'Active' => 'Aktiv',
        'Toggle active state for %s' => 'Aktiv-Status für %s umschalten',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Zuordnungen zwischen Kundenbenutzern und Gruppen verwalten',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Verwenden Sie diese Funktion, wenn Sie Gruppenberechtigungen für Kundenbenutzer definieren möchten.',
        'Edit Customer User Default Groups' => 'Standardgruppen für Kundenbenutzer bearbeiten',
        'These groups are automatically assigned to all customer users.' =>
            'Diese Gruppen werden allen Kundenbenutzern automatisch zugewiesen.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Sie können diese Gruppen mit der Konfigurationseinstellung "CustomerGroupAlwaysGroups" bearbeiten.',
        'Filter for groups' => 'Filter für Gruppen',
        'Select the customer user - group permissions.' => 'Wählen Sie die Gruppenberechtigungen für Kundenbenutzer aus.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Wenn nichts ausgewählt ist, hat der Kunde in dieser Gruppe keine Rechte (und kann nicht auf Tickets zugreifen).',
        'Customer User Default Groups:' => 'Standardgruppen des Kundenbenutzers:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Kundenbenutzer-Service-Zuordnungen verwalten',
        'Edit default services' => 'Standardservices bearbeiten',
        'Filter for Services' => 'Filter für Services',
        'Filter for services' => 'Filter für Services',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Verwaltung Dynamischer Felder',
        'Add new field for object' => 'Neues Feld hinzufügen für Objekt',
        'Filter for Dynamic Fields' => 'Filter für Dynamische Felder',
        'Filter for dynamic fields' => 'Filter für Dynamische Felder',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Datenbank',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Nutzen Sie externe Datenbanken als konfigurierbare Datenquellen für dieses dynamische Feld.',
        'Web service' => 'Web-Service',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Für dieses Feld können externe Web-Services als Datenquelle konfiguriert werden.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Dieses Feature erlaubt es, (mehrere) Kontakte mit Daten zu Tickets hinzuzufügen.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Um ein neues Feld hinzuzufügen, wählen Sie den Typ des Feldes aus der Liste der verfügbaren Typen für das jeweilige Objekt aus. Die Objekt-Auswahl ist bindend und kann nicht nachträglich verändert werden.',
        'Dynamic Fields List' => 'Dynamische Felder - Liste',
        'Dynamic fields per page' => 'Dynamische Felder pro Seite',
        'Label' => 'Beschriftung',
        'Order' => 'Sortierung',
        'Object' => 'Objekt',
        'Delete this field' => 'Dieses Feld löschen',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamische Felder',
        'Go back to overview' => 'Zurück zur Übersicht gehen',
        'General' => 'Allgemein',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dieses Feld wird benötigt, und der Wert darf nur Buchstaben und Zahlen enthalten.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Muss eindeutig sein und darf nur aus Buchstaben und Zahlen bestehen.',
        'Changing this value will require manual changes in the system.' =>
            'Eine Änderung dieses Wertes macht weitere manuelle Änderungen am System erforderlich.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Dieser Name wird auf den Bildschirmen angezeigt, auf denen dieses Feld aktiv ist.',
        'Field order' => 'Feldreihenfolge',
        'This field is required and must be numeric.' => 'Dieses Feld wird benötigt und darf nur Zahlen enthalten.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Die Feldreihenfolge steuert die Ausgabe der Felder auf den Bildschirmen.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Es ist nicht möglich, diesen Eintrag auf ungültig zu setzen, bevor alle betroffenen Konfiguration entsprechend angepasst wurden.',
        'Field type' => 'Feldtyp',
        'Object type' => 'Objekttyp',
        'Internal field' => 'Internes Feld',
        'This field is protected and can\'t be deleted.' => 'Dies ist ein geschütztes internes Feld und kann nicht gelöscht werden.',
        'This dynamic field is used in the following config settings:' =>
            'Dieses Dynamische Feld wird in folgenden Konfigurationseinstellungen verwendet:',
        'Field Settings' => 'Feldeinstellungen',
        'Default value' => 'Standardwert',
        'This is the default value for this field.' => 'Dies ist der Standardwert für dieses Feld.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => 'Kontakte hinzufügen oder bearbeiten',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            'Bitte füllen Sie alle benötigen Informationen aus und speichern Sie diese, um Kontakte zu diesem Feld hinzuzufügen.',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            'Klicken Sie in der Übersicht auf den Feldnamen, um ihn zu bearbeiten und die entsprechendene Aktion in der Seitenleiste oder im Menu \'Tickets\' zu finden.',
        'Name Field' => 'Namensfeld',
        'ValidID Field' => 'ValidID-Feld',
        'Other Fields' => 'Andere Felder',
        'Key' => 'Schlüssel',
        'Value' => 'Wert',
        'Remove value' => 'Wert löschen',
        'Add Field' => 'Feld hinzufügen',
        'Add value' => 'Wert hinzufügen',
        'These are the possible data attributes for contacts.' => 'Die folgenden Attribute sind für Kontakte möglich.',
        'Mandatory fields' => 'Pflichtfelder',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            'Kommaseparierte Pflichtfelderliste (optional). Die Schlüssel \'Name\' und \'ValidID\' sind immer Pflichtfelder und müssen hier nicht aufgeführt werden.',
        'Sorted fields' => 'Sortierte Felder',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            'Kommaseparierte Schlüsselliste in Sortierreihenfolge (optional). Die hier aufgeführten Schlüssel werden zuerst angezeigt, alle weiteren Felder danach und in alphabetischer Reihenfolge.',
        'Searchable fields' => 'Durchsuchbare Felder',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            'Komma getrennte Liste durchsuchbarer Schlüssel (optional). Die Schlüssel \'Name\' ist immer durchsuchbar und muss hier nicht aufgeführt werden.',
        'Translatable values' => 'Wertübersetzung',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Wenn Sie diese Option aktivieren, werden die Werte in die Sprache des Benutzers übersetzt.',
        'Note' => 'Notiz',
        'You need to add the translations manually into the language translation files.' =>
            'Sie müssen die Übersetzungen manuell zu den Übersetzungsdateien hinzufügen.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Mögliche Werte',
        'Datatype' => 'Datentyp',
        'Filter' => 'Filter',
        'Searchfield' => 'Suchfeld',
        'Listfield' => 'Listenfeld',
        'Show link' => 'Link anzeigen',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hier können Sie einen optionalen HTTP-Link für den Feldwert in Übersichten und Ansichtsseiten angeben.',
        'Example' => 'Beispiel',
        'Link for preview' => 'Link für Vorschau',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Diese URL wird (falls vorhanden) für eine Vorschau verwendet, wenn sich die Maus über diesem Link in der Ticketansicht befindet. Hierfür muss das oben stehende URL-Feld ebenso ausgefüllt werden.',
        'SID' => 'SID',
        'Driver' => 'Treiber',
        'Server' => 'Server',
        'Port' => 'Port',
        'Table / View' => 'Tabelle / Ansicht',
        'User' => 'Benutzer',
        'Password' => 'Passwort',
        'Identifier' => 'Identifikator',
        'Must be unique column from the table entered in Table/View.' => 'Muss eine eindeutige Spalte der in Tabelle/Ansicht eingetragenen Tabelle sein. ',
        'Multiselect' => 'Mehrfachauswahl',
        'CacheTTL' => 'CacheTTL',
        'Searchprefix' => 'Suchpräfix',
        'Searchsuffix' => 'Suchsuffix',
        'Result Limit' => 'Ergebnis-Beschränkung',
        'Case Sensitive' => 'Groß-/Kleinschreibung unterscheiden',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standard-Datumsunterschied',
        'This field must be numeric.' => 'Dieses Feld darf nur Zahlen beinhalten.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Der Unterschied zu JETZT in Sekunden, mit dem der Standardwert des Feldes berechnet wird (z. B. 3600 oder -60).',
        'Define years period' => 'Jahresbereich definieren',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktivieren Sie diese Funktion, um für die Datumsauswahl einen festen Jahresbereich zu definieren (Jahre in der Vergangenheit und Zukunft).',
        'Years in the past' => 'Jahre in der Vergangenheit',
        'Years in the past to display (default: 5 years).' => 'Jahre in der Vergangenheit, die angezeigt werden (Standard: 5).',
        'Years in the future' => 'Jahre in der Zukunft',
        'Years in the future to display (default: 5 years).' => 'Jahre in der Zukunft, die angezeigt werden (Standard: 5).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Wenn Sonderzeichen (&, @, :, /, etc.) nicht kodiert werden sollen, verwenden Sie den Filter \'url\' anstelle des Filters \'uri\'.',
        'Restrict entering of dates' => 'Eingabe von Daten einschränken',
        'Here you can restrict the entering of dates of tickets.' => 'Hier können Sie die Eingabe von Daten in dieses Feld einschränken.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Wert hinzufügen',
        'Add empty value' => 'Leeren Wert hinzufügen',
        'Activate this option to create an empty selectable value.' => 'Aktivieren Sie diese Option, um einen leeren Auswahlwert zu erstellen.',
        'Tree View' => 'Baumansicht',
        'Activate this option to display values as a tree.' => 'Aktivieren Sie diese Option um die Werte als Baum anzuzeigen.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Anzahl der Zeilen',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Gibt die Anzahl der Zeilen für dieses Feld im Bearbeitungsmodus an.',
        'Number of cols' => 'Anzahl der Spalten',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Gibt die Breite in Zeichen für dieses Feld im Bearbeitungsmodus an.',
        'Check RegEx' => 'Auf RegEx prüfen',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hier können Sie einen regulären Ausdruck definieren um den Wert zu prüfen. Der RegEx wird mit den Modifikatoren xms ausgeführt.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ungültige RegEx',
        'Error Message' => 'Fehlermeldung',
        'Add RegEx' => 'RegEx hinzufügen',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Vorlage',
        'Style' => 'Stil',
        'bold' => 'fett',
        'italic' => 'kursiv',
        'underline' => 'unterstrich',
        'Font style of the label.' => 'Fontstil der Beschriftung',
        'Size' => 'Größe',
        'Font size of the label.' => 'Fontgröße der Beschriftung',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Dieses Feld wird benötigt',
        'The web service to be executed for possible values.' => 'Der Webservice, der für mögliche Werte ausgeführt werden soll.',
        'Invoker' => 'Invoker',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            'Der Invoker, der genutzt wird, um Anfragen auszuführen (Invoker muss vom Typ \'Generic::PassThrough\' sein).',
        'Activate this option to allow multiselect on results.' => 'Aktivieren Sie diese Option, um Mehrfachauswahl auf den Ergebnissen zu erlauben.',
        'Cache TTL' => 'Cache TTL',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            'Cache TTL (in Minuten), um die gelieferten Werte zu speichern.',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            'Hier können Sie einen optionalen HTTP-Link für den Feldwert in Übersichten und Detailansichten angeben. Der optionale HTTP-Link funktioniert nur bei einfach ausgewählten Feldern.',

        # Template: AdminEmail
        'Admin Message' => 'Administrator-Nachricht',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Mit diesem Modul können Administratoren Nachrichten an Agenten, Gruppen oder Rollenmitglieder senden.',
        'Create Administrative Message' => 'Administrator-Nachricht erstellen',
        'Your message was sent to' => 'Ihre Nachricht wurde gesendet an',
        'From' => 'Von',
        'Send message to users' => 'Nachricht an Benutzer senden',
        'Send message to group members' => 'Nachricht an Gruppenmitglieder senden',
        'Group members need to have permission' => 'Gruppenmitglieder brauchen eine Berechtigung',
        'Send message to role members' => 'Nachricht an Gruppenmitglieder senden',
        'Also send to customers in groups' => 'Auch an Kunden der Gruppe senden',
        'Body' => 'Text',
        'Send' => 'Senden',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Generic Agent-Auftragsverwaltung',
        'Edit Job' => 'Auftrag bearbeiten',
        'Add Job' => 'Auftrag hinzufügen',
        'Run Job' => 'Auftrag ausführen',
        'Filter for Jobs' => 'Aufträge filtern',
        'Filter for jobs' => 'Aufträge filtern',
        'Last run' => 'Letzte Ausführung',
        'Run Now!' => 'Jetzt ausführen!',
        'Delete this task' => 'Diesen Auftrag löschen',
        'Run this task' => 'Diesen Auftrag ausführen',
        'Job Settings' => 'Auftragseinstellungen',
        'Job name' => 'Auftragsname',
        'The name you entered already exists.' => 'Der eingegebene Name existiert bereits.',
        'Automatic Execution (Multiple Tickets)' => 'Automatische Ausführung (mehrere Tickets)',
        'Execution Schedule' => 'Ausführungsplan',
        'Schedule minutes' => 'Ausführen zu Minute(n)',
        'Schedule hours' => 'Ausführen zu Stunde(n)',
        'Schedule days' => 'Ausführen an Tag(en)',
        'Automatic execution values are in the system timezone.' => 'Die Werte für die automatische Ausführung liegen in der Systemzeitzone.',
        'Currently this generic agent job will not run automatically.' =>
            'Derzeit würde dieser GenericAgent-Auftrag nicht automatisch ausgeführt werden.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Um ihn automatisch auszuführen, muss mindestens je ein Wert von Minuten, Stunden und Tagen ausgewählt werden!',
        'Event Based Execution (Single Ticket)' => 'Ereignisbasierte Ausführung (einzelnes Ticket)',
        'Event Triggers' => 'Ereignis-Auslöser',
        'List of all configured events' => 'Liste aller konfigurierten Ereignisse',
        'Delete this event' => 'Dieses Ereignis löschen',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Zusätzlich oder alternativ zur periodischen Ausführung können Sie Ticket-Ereignisse angeben, bei denen dieser Auftrag ausgeführt werden soll.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Wenn ein Ticket-Ereignis ausgelöst wird, wird zunächst der Ticket-Filter angewendet um zu prüfen, ob das Ticket betroffen ist. Erst danach wird der Auftrag ggf. für dieses Ticket ausgeführt.',
        'Do you really want to delete this event trigger?' => 'Wollen Sie diesen Ereignis-Auslöser wirklich löschen?',
        'Add Event Trigger' => 'Ereignis-Auslöser hinzufügen',
        'To add a new event select the event object and event name' => 'Wählen Sie Ereignisobjekt und -Name, um ein neues Ereignis hinzuzufügen',
        'Select Tickets' => 'Tickets selektieren',
        '(e. g. 10*5155 or 105658*)' => '(z .B. 10*5155 oder 105658*)',
        '(e. g. 234321)' => '(z. B. 234321)',
        'Customer user ID' => 'Kundenbenutzer-Nummer',
        '(e. g. U5150)' => '(z. B. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Volltextsuche in Artikeln (z. B. "Mar*in" oder "Baue*").',
        'To' => 'An',
        'Cc' => 'Cc',
        'Service' => 'Service',
        'Service Level Agreement' => 'Service-Level-Vereinbarung',
        'Queue' => 'Queue',
        'State' => 'Status',
        'Agent' => 'Agent',
        'Owner' => 'Besitzer',
        'Responsible' => 'Verantwortlicher',
        'Ticket lock' => 'Ticketsperre',
        'Dynamic fields' => 'Dynamische Felder',
        'Add dynamic field' => 'Dynamisches Feld hinzufügen',
        'Create times' => 'Erstellzeiten',
        'No create time settings.' => 'Keine Erstellzeit-Einstellungen.',
        'Ticket created' => 'Ticket erstellt',
        'Ticket created between' => 'Ticket erstellt zwischen',
        'and' => 'und',
        'Last changed times' => 'Letzte Änderungszeiten',
        'No last changed time settings.' => 'Keine Einstellungen für letzte Änderungszeiten.',
        'Ticket last changed' => 'Ticket zuletzt geändert',
        'Ticket last changed between' => 'Ticket zuletzt geändert zwischen',
        'Change times' => 'Änderungszeiten',
        'No change time settings.' => 'Keine Änderungszeit-Einstellungen.',
        'Ticket changed' => 'Ticket geändert',
        'Ticket changed between' => 'Ticket geändert zwischen',
        'Close times' => 'Schließzeiten',
        'No close time settings.' => 'Keine Schließzeit-Einstellungen.',
        'Ticket closed' => 'Ticket geschlossen',
        'Ticket closed between' => 'Ticket geschlossen zwischen',
        'Pending times' => 'Erinnerungszeiten',
        'No pending time settings.' => 'Keine Erinnerungszeit-Einstellungen.',
        'Ticket pending time reached' => 'Ticket-Erinnerungszeit erreicht',
        'Ticket pending time reached between' => 'Ticket-Erinnerungszeit erreicht zwischen',
        'Escalation times' => 'Eskalationszeiten',
        'No escalation time settings.' => 'Keine Eskalationszeit-Einstellungen.',
        'Ticket escalation time reached' => 'Ticket-Eskalationszeit erreicht',
        'Ticket escalation time reached between' => 'Ticket-Eskalationszeit erreicht zwischen',
        'Escalation - first response time' => 'Eskalation - Zeit für erste Reaktion',
        'Ticket first response time reached' => 'Ticket-Reaktionszeit erreicht',
        'Ticket first response time reached between' => 'Ticket-Reaktionszeit erreicht zwischen',
        'Escalation - update time' => 'Eskalation - Aktualisierungszeit',
        'Ticket update time reached' => 'Ticket-Aktualisierungszeit erreicht',
        'Ticket update time reached between' => 'Ticket-Aktualisierungszeit erreicht zwischen',
        'Escalation - solution time' => 'Eskalation - Lösungszeit',
        'Ticket solution time reached' => 'Ticket-Lösungszeit erreicht',
        'Ticket solution time reached between' => 'Ticket-Lösungszeit erreicht zwischen',
        'Archive search option' => 'Im Archiv suchen',
        'Update/Add Ticket Attributes' => 'Ticket-Attribute aktualisieren/hinzufügen',
        'Set new service' => 'Neuen Service festlegen',
        'Set new Service Level Agreement' => 'Neues Service-Level-Abkommen festlegen',
        'Set new priority' => 'Neue Priorität festlegen',
        'Set new queue' => 'Neue Queue festlegen',
        'Set new state' => 'Neuen Status setzen',
        'Pending date' => 'Warten bis',
        'Set new agent' => 'Neuen Agenten festlegen',
        'new owner' => 'Neuer Besitzer',
        'new responsible' => 'Neuer Verantwortlicher',
        'Set new ticket lock' => 'Neue Ticketsperre festlegen',
        'New customer user ID' => 'Neue Kundenbenutzer-Nummer',
        'New customer ID' => 'Neue Kundennummer',
        'New title' => 'Neuer Titel',
        'New type' => 'Neuer Typ',
        'Archive selected tickets' => 'Ausgewählte Tickets archivieren',
        'Add Note' => 'Notiz hinzufügen',
        'Visible for customer' => 'Sichtbar für Kunde',
        'Time units' => 'Zeiteinheiten',
        'Execute Ticket Commands' => 'Ticket-Befehle ausführen',
        'Send agent/customer notifications on changes' => 'Sende eine Agenten-/Kunden-Benachrichtigung bei Änderungen',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Dieser Befehl wird mit der Ticket-Nummer als erstes und der Ticket-ID als zweites Argument ausgeführt.',
        'Delete tickets' => 'Tickets löschen',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Warnung: Alle betroffenen Tickets werden aus der Datenbank gelöscht und können nicht wiederhergestellt werden!',
        'Execute Custom Module' => 'Benutzerdefiniertes Modul ausführen',
        'Param %s key' => 'Schlüssel für Parameter %s',
        'Param %s value' => 'Wert für Parameter %s',
        'Results' => 'Ergebnisse',
        '%s Tickets affected! What do you want to do?' => '%s Tickets sind betroffen! Was wollen Sie tun?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Warnung: Sie verwenden die Option LÖSCHEN. Alle gelöschten Tickets gehen verloren!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Warnung: %s Tickets sind betroffen, aber nur %s können während der Ausführung eines Auftrages geändert werden!',
        'Affected Tickets' => 'Betroffene Tickets',
        'Age' => 'Alter',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface - Web-Service-Verwaltung',
        'Web Service Management' => 'Web-Service-Verwaltung',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Zurück zum Web-Service',
        'Clear' => 'Leeren',
        'Do you really want to clear the debug log of this web service?' =>
            'Möchten Sie wirklich das Debug-Protokoll dieses Web-Services löschen?',
        'Request List' => 'Anfrageliste',
        'Time' => 'Zeit',
        'Communication ID' => 'Verbindungs-ID',
        'Remote IP' => 'Remote-IP',
        'Loading' => 'Lade',
        'Select a single request to see its details.' => 'Wählen Sie eine Anfrage aus, um die Details zu sehen.',
        'Filter by type' => 'Filtern nach Typ',
        'Filter from' => 'Filter von',
        'Filter to' => 'Filter bis',
        'Filter by remote IP' => 'Filter nach Remote-IP',
        'Limit' => 'Limit',
        'Refresh' => 'Aktualisieren',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Fehlerbehandlung hinzufügen',
        'Edit ErrorHandling' => 'Fehlerbehandlung bearbeiten',
        'Do you really want to delete this error handling module?' => 'Möchten Sie dieses Fehlerbehandlungs-Modul wirklich löschen?',
        'All configuration data will be lost.' => 'Die Konfigurationsdaten gehen verloren.',
        'General options' => 'Allgemeine Optionen',
        'The name can be used to distinguish different error handling configurations.' =>
            'Der Name kann dazu genutzt werden, um unterschiedliche Konfigurationen zur Fehlerbehandlung voneinander zu unterscheiden.',
        'Please provide a unique name for this web service.' => 'Bitte geben Sie einen eindeutigen Namen für diesen Web-Service an.',
        'Error handling module backend' => 'Fehlerbehandlungs-Modul-Backend',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Das OTOBO Fehlerbehandlungs-Modul-Backend wird intern aufgerufen um die Fehlerbehandlung auszuführen.',
        'Processing options' => 'Verarbeitungsoptionen',
        'Configure filters to control error handling module execution.' =>
            'Konfigurieren Sie Filter, um die Ausführung des Fehlerbehandlungs-Moduls zu steuern.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Ausschließlich Anfragen welche allen konfigurierten Filtern entsprechen (sofern vorhanden) bewirken die Ausführung des Moduls.',
        'Operation filter' => 'Operation-Filter',
        'Only execute error handling module for selected operations.' => 'Ausführung des Fehlerbehandlungs-Moduls nur für die ausgewählten Operations.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Hinweis: Für Fehler, welche beim Empfangen der eingehenden Anfragedaten auftreten ist die Operation unbestimmt. Filter für diese Verarbeitungsphase sollten keinen Operation-Filter nutzen.',
        'Invoker filter' => 'Invoker-Filter',
        'Only execute error handling module for selected invokers.' => 'Ausführung des Fehlerbehandlungs-Moduls nur für die ausgewählten Invoker.',
        'Error message content filter' => 'Filter für Inhalte von Fehlermeldungen',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Geben Sie einen regulären Ausdruck an, um die Fehlermeldungen einzuschränken, welche zur Ausführung des Fehlerbehandlungs-Moduls führen.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Titel und Inhalt der Fehlermeldung (wie im entsprechenden Debugger-Eintrag ersichtlich) werden auf Übereinstimmungen geprüft.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Beispiel: Geben Sie \'^.*401 Unauthorized.*\$\'  ein, um ausschließlich authentifizierungsrelevante Fehlermeldungen zu handhaben.',
        'Error stage filter' => 'Filter für Verarbeitungsphasen',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Ausführung des Fehlerbehandlungs-Moduls nur für die ausgewählten Verarbeitungsphasen.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Beispiel: Ausschließlich Fehler behandeln, welche beim Mapping ausgehender Daten auftreten.',
        'Error code' => 'Fehlercode',
        'An error identifier for this error handling module.' => 'Ein Fehleridentifikator für dieses Fehlerbehandlungs-Modul.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Dieser Identifikator wird in der Debugger-Ausgabe angezeigt und im XSLT-Mapping verfügbar gemacht.',
        'Error message' => 'Fehlermeldung',
        'An error explanation for this error handling module.' => 'Eine Fehlerbeschreibung für dieses Fehlerbehandlungs-Modul.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Diese Beschreibung wird in der Debugger-Ausgabe angezeigt und im XSLT-Mapping verfügbar gemacht.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Legt fest, ob die Fehlerbehandlung nach Ausführung dieses Module beendet werden soll. Entweder werden alle verbleibenden Module oder nur die Module des selben Backends übersprungen.',
        'Default behavior is to resume, processing the next module.' => 'Das standardmäßige Verhalten ist die anschließende Ausführung des nächsten Moduls.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Dieses Modul erlaubt die Konfiguration von geplanten Wiederholungen für fehlgeschlagene Anfragen.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Das standardmäßige Verhalten von GenericInterface Web-Services ist es, jede Anfrage nur genau einmal zu versenden und diese nach dem Auftreten von Fehlern nicht neu einzuplanen.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Sofern für eine Anfrage mehr als ein Modul ausgeführt wird, welches die Planung von Wiederholungen ermöglicht,  dann ist das zuletzt ausgeführte Modul maßgeblich für die Entscheidung ob eine Wiederholung eingeplant wird.',
        'Request retry options' => 'Optionen zur Wiederholung von Anfragen',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Wiederholungsoptionen werden angewendet, wenn Anfragen die Ausführung von Fehlerbehandlungs-Modulen verursachen (basierend auf Verarbeitungsoptionen).',
        'Schedule retry' => 'Wiederholung planen',
        'Should requests causing an error be triggered again at a later time?' =>
            'Sollen fehlerhafte Anfragen zu einem späteren Zeitpunkt erneut ausgeführt werden?',
        'Initial retry interval' => 'Initialer Abstand für Wiederholungen',
        'Interval after which to trigger the first retry.' => 'Intervall für die Planung der ersten Wiederholung.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Hinweis: Der Abstand für diese sowie alle weiteren Wiederholungen wird basierend auf der Ausführungszeit des Fehlerbehandlungs-Moduls für die initiale Anfrage berechnet.',
        'Factor for further retries' => 'Faktor für weitere Wiederholungen',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Geben Sie an, ob weitere Wiederholungen mit dem selben Intervall oder in aufsteigenden Abständen geplant werden sollen, sofern eine Anfrage nach der ersten Wiederholung noch fehlerhaft ist.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Beispiel: Wenn eine Anfrage initial um 10:00 Uhr mit dem initialen Abstand \'1 Minute\' und dem Wiederholungsfaktor \'2\' ausgeführt wird, würden Wiederholungen um 10:01 Uhr (1 Minute), 10:03 Uhr (2*1=2 Minuten), 10:07 Uhr (2*2=4 Minuten), 10:15 Uhr (2*4=8 Minuten), ... ausgeführt.',
        'Maximum retry interval' => 'Maximaler Abstand für Wiederholungen',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Falls ein Wiederholungsfaktor von \'1.5\' oder \'2\' ausgewählt wurde, können unerwünscht lange Abstände verhindert werden, indem ein größtmögliches Intervall angegeben wird.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Berechnete Intervalle, die den festgelegten maximalen Abstand überschreiten würden, werden automatisch entsprechend gekürzt.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Beispiel: Wenn eine Anfrage initial um 10:00 Uhr mit dem initialen Abstand  \'1 Minute\', dem Wiederholungsfaktor \'2\' und dem maximalen Intervall von \'5 Minuten\' ausgeführt wird, würden Wiederholungen um 10:01 Uhr (1 Minute), 10:03 Uhr (2 Minuten), 10:07 Uhr (4 Minuten), 10:12 Uhr (8=>5 Minuten), 10:17 Uhr, ... ausgeführt.',
        'Maximum retry count' => 'Maximale Anzahl an Wiederholungen',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Maximale Anzahl an Wiederholungen bevor eine fehlerhafte Anfrage verworfen wird (die initiale Anfrage wird nicht mitgezählt).',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Beispiel: Wenn eine Anfrage inital um 10:00 Uhr mit dem initialen Abstand \'1 Minute\', einem Wiederholungsfaktor \'2\' und der maximalen Anzahl an Wiederholungen von \'2\' ausgeführt wird, würden Wiederholungen ausschließlich um 10:01 Uhr und um 10:02 Uhr ausgeführt.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Hinweis: Die maximale Anzahl an Wiederholungen könnte nicht erreicht werden, sofern auch ein maximaler Zeitraum für Wiederholungen konfiguriert wurde und dieser früher erreicht wird.',
        'This field must be empty or contain a positive number.' => 'Dieses Feld muss entweder eine positive Zahl enthalten oder leer bleiben.',
        'Maximum retry period' => 'Maximaler Zeitraum für Wiederholungen',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Maximaler Zeitraum für Wiederholungen von fehlschlagenden Anfragen bevor diese verworfen werden (basierend auf der Ausführungszeit des Fehlerbehandlungs-Moduls für die initiale Anfrage).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Wiederholungen, die (gemäß der Berechnung des Intervalls) normalerweise ausgeführt würden nachdem der maximale Zeitraum für Wiederholungen abgelaufen ist, werden automatisch genau zum Ablauf dieses Zeitraums geplant.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Beispiel: Wenn eine Anfrage initial um 10:00 Uhr mit dem initialen Abstand \'1 Minute\', einem Wiederholungsfaktor \'2\' und dem maximalen Zeitraum für Wiederholungen \'30 Minuten\' ausgeführt wird, würden Wiederholungen um 10:01 Uhr, 10:03 Uhr, 10:07 Uhr, 10:15 Uhr und zuletzt um 10:31=>10:30 Uhr ausgeführt.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Hinweis: Der maximale Zeitraum für Wiederholungen könnte nicht erreicht werden, sofern auch eine maximale Anzahl an Wiederholungen konfiguriert wurde und diese früher erreicht wird.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Invoker hinzufügen',
        'Edit Invoker' => 'Invoker bearbeiten',
        'Do you really want to delete this invoker?' => 'Wollen Sie diesen Invoker wirklich löschen?',
        'Invoker Details' => 'Invoker-Details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Der Name wird typischerweise genutzt, um eine Operation eines entfernten Web-Services aufzurufen.',
        'Invoker backend' => 'Invoker-Backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Dieses Invoker-Backend-Modul wird aufgerufen, um die Daten zum Versand an das entfernte System sowie die zurückgelieferten Daten aufzubereiten.',
        'Mapping for outgoing request data' => 'Mapping für ausgehende Anfragedaten',
        'Configure' => 'Konfigurieren',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Die Daten des Invokers von OTOBO werden von diesem Mapping verarbeitet, um sie so umzuformen, wie das entfernte System die Daten benötigt.',
        'Mapping for incoming response data' => 'Mapping für eingehende Antwortdaten',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Die Antwort-Daten des entfernten Systems werden von diesem Mapping verarbeitet, um sie so umzuformen, wie der Invoker von OTOBO sie benötigt.',
        'Asynchronous' => 'Asynchron',
        'Condition' => 'Bedingung',
        'Edit this event' => 'Dieses Ereignis bearbeiten',
        'This invoker will be triggered by the configured events.' => 'Dieser Invoker wird von den konfigurierten Ereignissen ausgelöst.',
        'Add Event' => 'Event hinzufügen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Um einen neues Ereignis hinzuzufügen, wählen Sie bitte das Objekt und den Ereignisnamen und klicken Sie auf den "+"-Schaltfläche',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Asynchrone Ereignisauslöser werden vom OTOBO Scheduler Daemon im Hintergrund verarbeitet (empfohlen).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone Ereignisauslöser werden direkt während der laufenden Web-Anfrage verarbeitet.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'GenericInterface Invoker Ereignis-Einstellungen für Web-Service %s',
        'Go back to' => 'Zurück zu',
        'Delete all conditions' => 'Alle Bedingungen löschen',
        'Do you really want to delete all the conditions for this event?' =>
            'Möchten Sie wirklich alle Bedingungen für dieses Ereignis löschen?',
        'General Settings' => 'Generelle Einstellungen',
        'Event type' => 'Ereignistyp',
        'Conditions' => 'Bedingungen',
        'Conditions can only operate on non-empty fields.' => 'Bedingungen können nur Felder prüfen, die nicht leer sind.',
        'Type of Linking between Conditions' => 'Verknüpfungstyp zwischen den Bedingungen',
        'Remove this Condition' => 'Bedingung entfernen',
        'Type of Linking' => 'Verknüpfungstyp',
        'Fields' => 'Felder',
        'Add a new Field' => 'Neues Feld hinzufügen',
        'Remove this Field' => 'Feld entfernen',
        'And can\'t be repeated on the same condition.' => 'Und darf sich nicht innerhalb derselben Bedingung wiederholen.',
        'Add New Condition' => 'Neue Bedingung hinzufügen',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Einfaches Mapping',
        'Default rule for unmapped keys' => 'Standardregel für nicht gemappte Schlüssel',
        'This rule will apply for all keys with no mapping rule.' => 'Diese Regel wird für alle Schlüssel ohne passende Regel angewendet.',
        'Default rule for unmapped values' => 'Standardregel für nicht gemappte Werte',
        'This rule will apply for all values with no mapping rule.' => 'Diese Regel wird für alle Werte ohne passende Regel angewendet.',
        'New key map' => 'Neues Schlüssel-Mapping',
        'Add key mapping' => 'Schlüssel-Mapping hinzufügen',
        'Mapping for Key ' => 'Mapping für Schlüssel ',
        'Remove key mapping' => 'Schlüssel-Mapping entfernen',
        'Key mapping' => 'Schlüssel-Mapping',
        'Map key' => 'Schlüssel',
        'matching the' => 'übereinstimmend mit',
        'to new key' => 'auf neuen Schlüssel mappen',
        'Value mapping' => 'Wert-Mapping',
        'Map value' => 'Wert',
        'to new value' => 'auf neuen Wert mappen',
        'Remove value mapping' => 'Wert-Mapping entfernen',
        'New value map' => 'Neues Wert-Mapping',
        'Add value mapping' => 'Wert-Mapping hinzufügen',
        'Do you really want to delete this key mapping?' => 'Wollen Sie dieses Schlüssel-Mapping wirklich löschen?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Allgemeine Tastaturkürzel',
        'MacOS Shortcuts' => 'MacOS-Tastaturkürzel',
        'Comment code' => 'Code kommentieren',
        'Uncomment code' => 'Code nicht kommentieren',
        'Auto format code' => 'Code automatisch formatieren',
        'Expand/Collapse code block' => 'Code-Block aus-/einklappen',
        'Find' => 'Suchen',
        'Find next' => 'Nächste suchen',
        'Find previous' => 'Vorherige suchen',
        'Find and replace' => 'Suchen und ersetzen',
        'Find and replace all' => 'Suchen und alle ersetzen',
        'XSLT Mapping' => 'XSLT-Mapping',
        'XSLT stylesheet' => 'XSLT-Stylesheet',
        'The entered data is not a valid XSLT style sheet.' => 'Die eingegebenen Daten sind kein gültiges XSLT-Stylesheet.',
        'Here you can add or modify your XSLT mapping code.' => 'Hier können Sie Ihren XSLT-Mapping-Code hinzufügen oder bearbeiten.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'Das Bearbeitungsfeld ermöglicht die Benutzung verschiedener Funktionen wie automatische Formatierung, Veränderung der Fenstergröße sowie Tag- und Klammer-Vervollständigung.',
        'Data includes' => 'Daten-Include',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Wählen Sie einen oder mehrere Datensätze, welche in vorhergehenden Anfrage-/Antwortphasen erstellt wurden, um diese im Mapping zur Verfügung zu stellen.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Diese Datensätze werden in die Datenstruktur unter \'/DataInclude/<DatensatzName>\' dargestellt (in der Ausgabe des Debugger sehen Sie Details der tatsächlichen Struktur).',
        'Data key regex filters (before mapping)' => 'RegEx-Filter für Daten-Schlüssel (vor dem Mapping)',
        'Data key regex filters (after mapping)' => 'RegEx-Filter für Daten-Schlüssel (nach dem Mapping)',
        'Regular expressions' => 'Reguläre Ausdrücke',
        'Replace' => 'Ersetzen',
        'Remove regex' => 'RegEx entfernen',
        'Add regex' => 'RegEx hinzufügen',
        'These filters can be used to transform keys using regular expressions.' =>
            'Diese Filter können genutzt werden, um Schlüssel mittels regulärer Ausdrücke umzuformen.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'Die Datenstruktur wird rekursiv durchlaufen und alle konfigurierten regulären Ausdrücke werden auf alle Schlüssel angewendet.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Anwendungsfälle sind z.B. das Entfernen von unerwünschten Schlüssel-Präfixen oder die Korrektur von Schlüsseln, welche keine gültigen XML-Elementnamen darstellen.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Beispiel 1: Suchen = \'^jira:\' / Ersetzen = \'\' wandelt \'jira:element\' in \'element\' um.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Beispiel 2: Suchen = \'^\' / Ersetzen = \'_\' wandelt \'16x16\' in \'_16x16\' um.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Beispiel 3: Suche = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Informationen zu regulären Ausdrücken in Perl finden Sie hier:',
        'Perl regular expressions tutorial' => 'Perl regular expressions tutorial (Englisch)',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Falls der Einsatz von Modifikatoren gewünscht ist, müssen diese innerhalb der regulären Ausdrücke definiert werden.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Hier definierte reguläre Ausdrücke werden vor dem XSLT-Mapping angewendet.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Hier definierte reguläre Ausdrücke werden nach dem XSLT-Mapping angewendet.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Operation hinzufügen',
        'Edit Operation' => 'Operation bearbeiten',
        'Do you really want to delete this operation?' => 'Wollen Sie diese Operation wirklich löschen?',
        'Operation Details' => 'Operation-Details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Der Name wird typischerweise benutzt, um die Web-Service-Operation von einem entfernten System aus aufzurufen.',
        'Operation backend' => 'Operation-Backend',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Dieses OTOBO-Operation-Backend-Modul wird intern aufgerufen, um die Anforderung zu bearbeiten und Daten für die Antwort zu generieren.',
        'Mapping for incoming request data' => 'Mapping für eingehende Anfragedaten',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Die Daten der eingehenden Anfrage werden von diesem Mapping verarbeitet, um sie so umzuformen, wie die OTOBO-Operation sie benötigt.',
        'Mapping for outgoing response data' => 'Mapping für ausgehende Antwortdaten',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Die Antwortdaten werden von diesem Mapping verarbeitet, um sie so umzuformen, wie das entfernte System die Daten benötigt.',
        'Include Ticket Data' => 'Ticketdaten einbinden',
        'Include ticket data in response.' => 'Ticketdaten in Antwort einbinden.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Netzwerktransport',
        'Properties' => 'Eigenschaften',
        'Route mapping for Operation' => 'Route-Mapping für Operationen',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Definiert die Route, die zu der Operation gemappt werden soll. Variablen, die mit einem \':\' markiert sind, werden zu dem eingegeben Namen gemappt und mit den anderen Variablen an die Funktion übergeben. (z.B.: /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Gültige Anfragemethoden für Operation',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Beschränken Sie diese Operation auf bestimmte Anfragemethoden. Wenn keine Anfragemethode ausgewählt ist, werden alle Anfragen akzeptiert.',
        'Maximum message length' => 'Maximale Nachrichtenlänge',
        'This field should be an integer number.' => 'Dieses Feld sollte eine Ganzzahl beinhalten.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Bestimmen Sie die maximale Größe (in Bytes) für REST-Nachrichten, die OTOBO akzeptieren soll.',
        'Send Keep-Alive' => 'Keep-Alive senden',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Bestimmt, ob eingehende Verbindungen geschlossen oder am Leben erhalten werden sollen.',
        'Additional response headers' => 'Zusätzliche Antwort-Header',
        'Add response header' => 'Antwort-Header hinzufügen',
        'Endpoint' => 'Endpunkt',
        'URI to indicate specific location for accessing a web service.' =>
            'URI zur Angabe eines bestimmten Standorts für den Zugriff auf einen Webdienst.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Timeout',
        'Timeout value for requests.' => 'Timeout-Wert für Anfragen.',
        'Authentication' => 'Authentifizierung',
        'An optional authentication mechanism to access the remote system.' =>
            'Die optionale Authentifizierungsmethode für den Zugriff auf das entfernte System.',
        'BasicAuth User' => 'BasicAuth-Benutzer',
        'The user name to be used to access the remote system.' => 'Der Benutzername für den Zugriff auf das entfernte System.',
        'BasicAuth Password' => 'BasicAuth-Passwort',
        'The password for the privileged user.' => 'Dass Passwort des berechtigten Benutzers.',
        'Use Proxy Options' => 'Proxy-Optionen verwenden',
        'Show or hide Proxy options to connect to the remote system.' => 'Optionen für die Verwendung eines Proxy zum Zugriff auf das entfernte System anzeigen oder verbergen.',
        'Proxy Server' => 'Proxy-Server',
        'URI of a proxy server to be used (if needed).' => 'URI eines Proxy-Servers (optional).',
        'e.g. http://proxy_hostname:8080' => 'z. B. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-Benutzer',
        'The user name to be used to access the proxy server.' => 'Benutzername für den Zugriff auf den Proxy-Server.',
        'Proxy Password' => 'Proxy-Passwort',
        'The password for the proxy user.' => 'Passwort des Proxy-Benutzers.',
        'Skip Proxy' => 'Proxy übergehen',
        'Skip proxy servers that might be configured globally?' => 'Sollen mögliche global konfigurierte Proxy-Server übergangen werden?',
        'Use SSL Options' => 'SSL-Optionen verwenden',
        'Show or hide SSL options to connect to the remote system.' => 'Optionen für die Verwendung von SSL zum Zugriff auf das entfernte System anzeigen oder verbergen.',
        'Client Certificate' => 'Client-Zertifikat',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Der vollständige Pfad und Name der SSL-Client-Zertifikatsdatei (muss im PEM, DER oder PKCS#12-Format vorliegen).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'z.B. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Client-Zertifikatschlüssel',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Der vollständige Pfad und Name der SSL-Client-Zertifikats-Schlüsseldatei (sofern nicht bereits in der Client-Zertifikats-Datei enthalten).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'z.B. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Passwort für Client-Zertifikatschlüssel',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Das Passwort für den Zugriff auf das SSL-Zertifikat falls der Schlüssel verschlüsselt ist.',
        'Certification Authority (CA) Certificate' => 'Zertifikat der Certification Authority (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Voller Pfad und Dateiname der Datei der Certification Authority (CA), welche das Zertifikat signiert hat.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'z. B. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Verzeichnis mit Certification Autorities (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Voller Pfad und Dateiname des CA-Verzeichnisses, in dem CA-Zertifikate gespeichert sind.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'z. B. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Controller-Mapping für Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Der Controller, an den der Invoker Anfragen senden soll. Variablen, die mit einem \':\' markiert sind, werden durch den Datenwert ersetzt und mit der Anfrage übergeben. (z.B.: /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Gültiger Anfragebefehl für Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Ein spezifisches HTTP-Kommando, das für Anfragen mit diesem Invoker zu verwenden ist (optional).',
        'Default command' => 'Standardbefehl',
        'The default HTTP command to use for the requests.' => 'Der Standard-HTTP-Befehl für die Anfragen.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'z.B. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Setzen von SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Auf "Ja" setzen, um einen befüllten SOAPAction-Header zu senden.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Auf "Nein" setzen, um einen leeren SOAPAction-Header zu senden.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Auf "Ja" setzen, um den empfangenen SOAPAction-Header zu prüfen.',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Auf "Nein" setzen, um den empfangenen SOAPAction-Header zu ignorieren.',
        'SOAPAction scheme' => 'SOAPAction-Schema',
        'Select how SOAPAction should be constructed.' => 'Wählen Sie, wie die SOAPAction konstruiert werden soll.',
        'Some web services require a specific construction.' => 'Einige Web-Service benötigen eine spezifische Konstruktion.',
        'Some web services send a specific construction.' => 'Einige Web-Services senden eine spezifische Konstruktion.',
        'SOAPAction separator' => 'SOAPAction-Trenner',
        'Character to use as separator between name space and SOAP operation.' =>
            'Zu nutzendes Trennzeichen zwischen dem Namespace und der SOAP-Operation.',
        'Usually .Net web services use "/" as separator.' => 'Normalerweise verwenden .Net-basierte Web-Services "/" als Trenner.',
        'SOAPAction free text' => 'SOAPAction Freitext',
        'Text to be used to as SOAPAction.' => 'Text welcher als SOAPAction genutzt werden soll.',
        'Namespace' => 'Namensraum',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI, die SOAP-Methoden einen Kontext gibt und damit Mehrdeutigkeiten auflöst.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'z. B. urn:otobo-com:soap:functions oder http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Anfragen-Namensschema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Wählen Sie, wie der SOAP-Funktionsaufruf konstruiert werden soll.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' wird als Beispiel für den tatsächlichen Namen eines Invokers / einer Operation verwendet.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' wird als Beispiel für einen tatsächlich konfigurierten Wert verwendet.',
        'Request name free text' => 'Freitext für Anfragenamen',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Text, der als Anhang oder Ersatz für den Funktionsnamen verwendet werden soll.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Bitte beachten Sie die Beschränkungen von XML-Elementnamen (verwenden Sie z. B. kein \'<\' oder \'&\').',
        'Response name scheme' => 'Antwort-Namensschema',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Wählen Sie, wie die SOAP-Antwort konstruiert werden soll.',
        'Response name free text' => 'Freitext für den Antwortnamen',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Hier können Sie eine Maximalgröße für SOAP-Nachrichten (in Bytes) angeben, die OTOBO verarbeitet.',
        'Encoding' => 'Kodierung',
        'The character encoding for the SOAP message contents.' => 'Die Zeichenkodierung für SOAP-Nachrichteninhalte.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'z. B. utf-8, latin1, iso-8859-1, cp1250, usw.',
        'Sort options' => 'Sortierungsoptionen',
        'Add new first level element' => 'Neues Element auf der obersten Ebene hinzufügen',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Sortierung für ausgehende XML-Felder (Struktur unterhalb des Funktionsaufrufes) - siehe Dokumentation für SOAP-Transport.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Web-Service hinzufügen',
        'Edit Web Service' => 'Web-Service bearbeiten',
        'Clone Web Service' => 'Web-Service klonen',
        'The name must be unique.' => 'Der Name muss eindeutig sein.',
        'Clone' => 'Klonen',
        'Export Web Service' => 'Web-Service exportieren',
        'Import web service' => 'Web-Services importieren',
        'Configuration File' => 'Konfigurationsdatei',
        'The file must be a valid web service configuration YAML file.' =>
            'Die Datei muss eine gültige Web-Service-Konfigurationsdatei im YAML-Format sein.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Hier können Sie einen Namen für den Web-Service angeben. Bleibt dieses Feld leer, wird der Dateiname der Konfigurationsdatei als Name verwendet.',
        'Import' => 'Importieren',
        'Configuration History' => 'Konfigurationshistorie',
        'Delete web service' => 'Web-Service löschen',
        'Do you really want to delete this web service?' => 'Wollen Sie diesen Web-Service wirklich löschen?',
        'Ready2Adopt Web Services' => 'Ready2Adopt-Web-Services',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Hier können Sie Ready2Adopt-Webservices aktivieren, die Teil der %s sind und nach unseren Best-Practices erstellt wurden.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Bitte beachten Sie, dass diese Webservices von anderen Modulen abhängen können, die nur in bestimmten Vertragsstufen der %s verfügbar sind (Ihnen wird beim Importieren ein entsprechender Hinweis angezeigt).',
        'Import Ready2Adopt web service' => 'Ready2Adopt-Web-Services importieren',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            'Möchten Sie von Webservices profitieren, die von Experten erstellt wurden? Dann wechseln Sie auf die %s, um ausgefeilte Ready2Adopt-Webservices importieren zu können.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Nach dem Speichern der Konfiguration werden Sie wieder auf den Bearbeitungsbildschirm geleitet.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Wenn Sie zurück zur Übersicht möchten, verwenden Sie bitte die Schaltfläche "Zurück zur Übersicht".',
        'Remote system' => 'Remote-System',
        'Provider transport' => 'Provider-Transport',
        'Requester transport' => 'Requester-Transport',
        'Debug threshold' => 'Debug-Level',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Im Modus "Provider" bietet OTOBO Web-Services an, die von externen Systemen genutzt werden.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Im Modus "Requester" nutzt OTOBO selbst Web-Services von externen Systemen.',
        'Network transport' => 'Netzwerktransport',
        'Error Handling Modules' => 'Fehlerbehandlungs-Module',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Fehlerbehandlungs-Module werden genutzt, um auf Fehler zu reagieren, die während der Kommunikation auftreten. Diese Module werden in festgelegter Reihenfolge ausgeführt, die Sie durch Verschieben mit der Maus ändern können.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Fehlerbehandlungs-Modul hinzufügen',
        'Operations are individual system functions which remote systems can request.' =>
            'Operations sind einzelne Systemfunktionen, die entfernte Systeme aufrufen können.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invoker bereiten Daten für eine Anfrage an einen externen Web-Service auf und verarbeiten die Antwortdaten.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Eingehendes Mapping',
        'Outbound mapping' => 'Ausgehendes Mapping',
        'Delete this action' => 'Diese Aktion löschen',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Noch mindestens ein %s hat einen Controller, der nicht aktiv oder nicht vorhanden ist, bitte prüfen Sie die Controller-Registrierung oder löschen Sie %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historie',
        'Go back to Web Service' => 'Zurück zum Web-Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hier können Sie ältere Versionen der Konfiguration dieses Web-Services einsehen, exportieren oder wiederherstellen.',
        'Configuration History List' => 'Liste der Konfigurationshistorie',
        'Version' => 'Version',
        'Create time' => 'Erstellzeit',
        'Select a single configuration version to see its details.' => 'Wählen Sie eine Konfigurationsversion aus, um die Details zu sehen.',
        'Export web service configuration' => 'Web-Service-Konfiguration exportieren',
        'Restore web service configuration' => 'Web-Service-Konfiguration wiederherstellen',
        'Do you really want to restore this version of the web service configuration?' =>
            'Wollen Sie diese Version der Web-Service-Konfiguration wirklich wiederherstellen?',
        'Your current web service configuration will be overwritten.' => 'Ihre aktuelle Konfiguration wird überschrieben.',

        # Template: AdminGroup
        'Group Management' => 'Gruppenverwaltung',
        'Add Group' => 'Gruppe hinzufügen',
        'Edit Group' => 'Gruppe bearbeiten',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Die \'admin\'-Gruppe wird für den Admin-Bereich benötigt, die \'stats\'-Gruppe für den Statistik-Bereich.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Erstellen Sie neue Gruppen, um unterschiedliche Berechtigungen für verschiedene Agentengruppen zu realisieren (z. B. Einkauf, Produktion, Verkauf, ...) . ',
        'It\'s useful for ASP solutions. ' => 'Das ist nützlich für ASP-Lösungen. ',

        # Template: AdminLog
        'System Log' => 'Systemprotokoll',
        'Here you will find log information about your system.' => 'Hier finden Sie Informationen zu protokollierten Systemereignissen.',
        'Hide this message' => 'Diesen Hinweis ausblenden',
        'Recent Log Entries' => 'Aktuelle Einträge im Systemprotokoll',
        'Facility' => 'Einrichtung',
        'Message' => 'Nachricht',

        # Template: AdminMailAccount
        'Mail Account Management' => 'E-Mail-Kontenverwaltung',
        'Add Mail Account' => 'E-Mail-Konto hinzufügen',
        'Edit Mail Account for host' => 'E-Mail-Konto für Host bearbeiten',
        'and user account' => 'und Benutzerkonto',
        'Filter for Mail Accounts' => 'Filter für E-Mail-Konten',
        'Filter for mail accounts' => 'Filter für E-Mail-Konten',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Einkommende E-Mails von POP3-Konten werden in die ausgewählte Queue einsortiert.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Wird dem Konto vertraut, bleiben die eingehenden X-OTOBO-Header (für Priorität usw.) erhalten und werden benutzt, zum Beispiel in Postmaster-Filtern.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Ausgehende E-Mails können über die Sendmail-Einstellungen in %s konfiguriert werden.',
        'System Configuration' => 'Systemkonfiguration',
        'Host' => 'Host',
        'Delete account' => 'E-Mail-Konto löschen',
        'Fetch mail' => 'E-Mails abholen',
        'Do you really want to delete this mail account?' => 'Möchten Sie dieses E-Mail-Konto wirklich löschen?',
        'Example: mail.example.com' => 'Beispiel: mail.example.com',
        'IMAP Folder' => 'IMAP-Ordner',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ändern Sie diese Einstellung nur, wenn die E-Mails aus einem anderen Ordner als "INBOX" geholt werden sollen.',
        'Trusted' => 'Vertraut',
        'Dispatching' => 'Verteilung',
        'Edit Mail Account' => 'E-Mail-Konto bearbeiten',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Administrations-Übersicht',
        'Filter for Items' => 'Filter für Einträge',
        'Favorites' => 'Favoriten',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Sie können Favoriten hinzufügen, indem Sie Ihren Mauszeiger über Einträge auf der rechten Seite bewegen und dann das Sternsymbol anklicken.',
        'Links' => 'Verknüpfungen',
        'View the admin manual on Github' => 'Administrator-Handbuch auf Github',
        'No Matches' => 'Keine Treffer',
        'Sorry, your search didn\'t match any items.' => 'Es wurden leider keine passenden Einträge gefunden.',
        'Set as favorite' => 'Als Favorit markieren',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Verwaltung von Ticket-Benachrichtigungen',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Hier können Sie eine Konfigurationsdatei hochladen, mit der Ticket-Benachrichtigungen im System importiert werden können. Die Datei muss im .yml-Format vorliegen, so wie sie auch vom Ticket-Benachrichtigungsmodul exportiert wird.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Hier können Sie auswählen, welche Ereignisse diese Benachrichtigung auslösen. Ein zusätzlicher Ticket-Filter kann weiter unten eingestellt werden, um die Benachrichtigung nur für Tickets mit bestimmten Merkmalen zu versenden.',
        'Ticket Filter' => 'Ticket-Filter',
        'Lock' => 'Sperren',
        'SLA' => 'SLA',
        'Customer User ID' => 'Kundenbenutzer-Nummer',
        'Article Filter' => 'Artikelfilter',
        'Only for ArticleCreate and ArticleSend event' => 'Nur für die Events ArticleCreate und ArticleSend',
        'Article sender type' => 'Sendertyp des Artikels',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Wenn ArticleCreate oder ArticleSend aus auslösendes Ereignis verwendet werden, müssen Sie ebenfalls einen Artikelfilter spezifizieren. Bitte wählen Sie mindestens eins der Artikelfilterfelder aus.',
        'Customer visibility' => 'Sichtbarkeit für Kunden',
        'Communication channel' => 'Kommunikationskanal',
        'Include attachments to notification' => 'Anhänge an Benachrichtigung anfügen',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Nur einmal am Tag pro Ticket und Benachrichtigungs-Transportmethode versenden.',
        'This field is required and must have less than 4000 characters.' =>
            'Dieses Feld wird benötigt und darf nicht mehr als 4000 Zeichen enthalten.',
        'Notifications are sent to an agent or a customer.' => 'Benachrichtigungen werden an Agenten und Kunden gesendet.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Die ersten 20 Zeichen des Betreffs (des letzten Agenten-Artikels).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Die ersten fünf Zeilen der Nachricht (des letzten Agenten-Artikels).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Die ersten 20 Zeichen des Betreffs (des letzten Kunden-Artikels).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Die ersten fünf Zeilen der Nachricht (des letzten Kunden-Artikels).',
        'Attributes of the current customer user data' => 'Attribute des aktuellen Kundenbenutzer-Datensatzes',
        'Attributes of the current ticket owner user data' => 'Attribute der Nutzerdaten des aktuellen Ticket-Besitzers',
        'Attributes of the current ticket responsible user data' => 'Attribute der Nutzerdaten des aktuellen Ticket-Verantwortlichen',
        'Attributes of the current agent user who requested this action' =>
            'Attribute der Benutzerdaten des Agenten, der die Aktion ausgelöst hat',
        'Attributes of the ticket data' => 'Attribute der Ticket-Daten',
        'Ticket dynamic fields internal key values' => 'Interne Schlüssel der Dynamischen Felder des Tickets',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Anzeigewerte der Dynamischen Felder des Tickets, verwendbar für Auswahlfelder',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Verwenden Sie Komma oder Semikolon, um E-Mail-Adressen zu trennen.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Sie können OTOBO-Tags wie <OTOBO_TICKET_DynamicField_...> nutzen, um Werte des aktuellen Tickets einzufügen.',

        # Template: AdminPGP
        'PGP Management' => 'PGP-Verwaltung',
        'Add PGP Key' => 'PGP-Schlüssel hinzufügen',
        'PGP support is disabled' => 'Unterstützung für PGP ist deaktiviert',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Um PGP in OTOBO verwenden zu können, müssen Sie es zuerst aktivieren.',
        'Enable PGP support' => 'PGP-Unterstützung aktivieren',
        'Faulty PGP configuration' => 'Fehlerhafte PGP-Konfiguration',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP-Unterstützung ist aktiviert, aber die Konfiguration ist fehlerhaft. Bitte überprüfen Sie die Konfiguration mit der untenstehenden Schaltfläche.',
        'Configure it here!' => 'Hier konfigurieren!',
        'Check PGP configuration' => 'PGP-Konfiguration überprüfen',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Über diesen Weg kann man den Schlüsselring (konfiguriert in SysConfig) direkt bearbeiten.',
        'Introduction to PGP' => 'Einführung zu PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerabdruck',
        'Expires' => 'Erlischt',
        'Delete this key' => 'Diesen Schlüssel löschen',
        'PGP key' => 'PGP-Schlüssel',

        # Template: AdminPackageManager
        'Package Manager' => 'Paketverwaltung',
        'Uninstall Package' => 'Paket deinstallieren',
        'Uninstall package' => 'Paket deinstallieren',
        'Do you really want to uninstall this package?' => 'Soll das Paket wirklich deinstalliert werden?',
        'Reinstall package' => 'Paket erneut installieren',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Möchten Sie dieses Paket wirklich erneut installieren? Alle manuellen Änderungen gehen verloren.',
        'Go to updating instructions' => 'Gehe zur Update-Anweisung',
        'Go to the OTOBO customer portal' => 'Gehen Sie zum OTOBO-Kundenportal',
        'package information' => 'Paketinformation',
        'Package installation requires a patch level update of OTOBO.' =>
            'Paketinstallation benötigt ein Patchlevel-Update von OTOBO.',
        'Package update requires a patch level update of OTOBO.' => 'Paket-Update benötigt ein Patchlevel-Update von OTOBO.',
        'Please note that your installed OTOBO version is %s.' => 'Bitte beachten Sie, dass Ihre installierte OTOBO-Version %s ist.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'Um dieses Paket zu installieren, müssen Sie zunächst OTOBO auf Version %s oder neuer aktualisieren.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Dieses Paket kann nur mit OTOBO-Version %s oder älter verwendet werden.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Dieses Paket kann nur mit OTOBO-Version %s oder neuer verwendet werden.',
        'Why should I keep OTOBO up to date?' => 'Warum sollte ich OTOBO aktuell halten?',
        'You will receive updates about relevant security issues.' => 'Sie erhalten Updates über relevante Sicherheitsprobleme.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Sie erhalten Updates für alle anderen relevanten Probleme im Zusammenhang mit OTOBO.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Wie kann ich ein Patchlevel-Update durchführen, wenn ich keinen Vertrag habe?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Bitte entnehmen Sie alle relevanten Informationen der Update-Anweisung auf %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Sollten Sie weitere Fragen haben, freuen wir uns, diese zu beantworten.',
        'Please visit our customer portal and file a request.' => 'Bitte besuchen Sie unser Kundenportal und eröffnen Sie eine Anfrage.',
        'Install Package' => 'Paket installieren',
        'Update Package' => 'Paket Aktualisieren',
        'Continue' => 'Weiter',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Stellen Sie sicher, dass Ihre Datenbank Pakete über %s MB akzeptiert (Derzeit werden nur Pakete bis %s MB akzeptiert). Bitte passen Sie die Einstellung max_allowed_packet Ihrer Datenbank-Konfiguration an, um Fehler zu vermeiden.',
        'Install' => 'Installieren',
        'Update repository information' => 'Verzeichnis aktualisieren',
        'Cloud services are currently disabled.' => 'Cloud-Services sind derzeit deaktiviert.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify kann nicht fortgesetzt werden!',
        'Enable cloud services' => 'Cloud-Services aktivieren',
        'Update all installed packages' => 'Alle installierten Pakete aktualisieren',
        'Online Repository' => 'Online-Verzeichnis',
        'Vendor' => 'Anbieter',
        'Action' => 'Aktion',
        'Module documentation' => 'Moduldokumentation',
        'Local Repository' => 'Lokales Verzeichnis',
        'This package is verified by OTOBOverify (tm)' => 'Dieses Paket wurde von OTOBOVerify (tm) geprüft',
        'Uninstall' => 'Deinstallieren',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Paket nicht korrekt installiert. Bitte erneut installieren.',
        'Reinstall' => 'Erneut installieren',
        'Features for %s customers only' => 'Exklusiv: Features für %s Kunden',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Mit %s können Sie von den nachfolgenden optionalen Features profitieren. Bitte kontaktieren Sie %s, wenn Sie weitere Informationen benötigen.',
        'Package Information' => 'Paketinformationen',
        'Download package' => 'Paket herunterladen',
        'Rebuild package' => 'Paket neu aufbauen (rebuild)',
        'Metadata' => 'Metadaten',
        'Change Log' => 'Änderungsprotokoll',
        'Date' => 'Datum',
        'List of Files' => 'Dateiliste',
        'Permission' => 'Berechtigungen',
        'Download file from package!' => 'Datei aus dem Paket herunterladen!',
        'Required' => 'Benötigt',
        'Primary Key' => 'Primärer Schlüssel',
        'Auto Increment' => 'Automatisch erhöhen',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Unterschiede für Datei %s',
        'File differences for file %s' => 'Dateiunterschiede für Datei %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Leistungsprotokoll',
        'Range' => 'Bereich',
        'last' => 'letzten',
        'This feature is enabled!' => 'Dieses Feature ist aktiv!',
        'Just use this feature if you want to log each request.' => 'Nur aktivieren, wenn jede Anfrage protokolliert werden soll.',
        'Activating this feature might affect your system performance!' =>
            'Bitte beachten Sie, dass das Aktivieren dieser Funktion Leistungseinbußen zur Folge haben kann!',
        'Disable it here!' => 'Hier deaktivieren!',
        'Logfile too large!' => 'Logdatei zu groß!',
        'The logfile is too large, you need to reset it' => 'Die Logdatei ist zu groß, sie muss zurückgesetzt werden',
        'Reset' => 'Zurücksetzen',
        'Overview' => 'Übersicht',
        'Interface' => 'Interface',
        'Requests' => 'Anfragen',
        'Min Response' => 'Min. Antwortzeit',
        'Max Response' => 'Max. Antwortzeit',
        'Average Response' => 'Durchschnittliche Antwortzeit',
        'Period' => 'Zeitraum',
        'minutes' => 'Minuten',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Durchschnitt',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Postmaster-Filter-Verwaltung',
        'Add PostMaster Filter' => 'Postmaster-Filter hinzufügen',
        'Edit PostMaster Filter' => 'Postmaster-Filter bearbeiten',
        'Filter for PostMaster Filters' => 'Nach Postmaster Filtern suchen',
        'Filter for PostMaster filters' => 'Nach Postmaster Filtern suchen',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Einkommende E-Mails anhand von E-Mail-Kopfzeilen verteilen oder filtern. Für die Suche können auch reguläre Ausdrücke benutzt werden.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Wenn nur eine E-Mail-Adresse gesucht wird, dann benutzen Sie EMAILADDRESS:info@example.com in From, To oder Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Wenn Sie reguläre Ausdrücke verwenden, können Sie die gefundenen Werte in () auch als [***] in der Aktion "Setzen" verwenden.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Sie können auch benannte Gruppierungen %s und die Namen in der "Setzen"-Aktion verwenden %s (z. B. Regexp: %s, "Setzen"-Aktion: %s). Eine gefundene EMAILADDRESS hat den Namen "%s".',
        'Delete this filter' => 'Diesen Filter löschen',
        'Do you really want to delete this postmaster filter?' => 'Möchten Sie diesen Postmaster-Filter wirklich löschen?',
        'A postmaster filter with this name already exists!' => 'Es existiert bereits ein Postmaster Filter mit diesem Namen!',
        'Filter Condition' => 'Filterbedingung',
        'AND Condition' => 'UND-Bedingung',
        'Search header field' => 'Kopfzeilen-Feld durchsuchen',
        'for value' => 'nach Wert',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dieses Feld sollte einen gültigen regulären Ausdruck oder ein Wort enthalten.',
        'Negate' => 'Negieren',
        'Set Email Headers' => 'E-Mail-Kopfzeilen setzen',
        'Set email header' => 'Setze E-Mail-Kopfzeile',
        'with value' => 'Mit Wert',
        'The field needs to be a literal word.' => 'Dieses Feld sollte ein Wort enthalten.',
        'Header' => 'Überschrift',

        # Template: AdminPriority
        'Priority Management' => 'Prioritäten-Verwaltung',
        'Add Priority' => 'Priorität hinzufügen',
        'Edit Priority' => 'Priorität bearbeiten',
        'Filter for Priorities' => 'Filter für Prioritäten',
        'Filter for priorities' => 'Filter für Prioritäten',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Diese Priorität ist in einer SysConfig-Einstellung vorhanden. Eine Bestätigung für die Aktualisierung der Einstellung auf die neue Priorität ist notwendig!',
        'This priority is used in the following config settings:' => 'Diese Priorität wird in folgenden Konfigurationseinstellungen verwendet:',

        # Template: AdminProcessManagement
        'Process Management' => 'Prozessmanagement',
        'Filter for Processes' => 'Filter für Prozesse',
        'Filter for processes' => 'Filter für Prozesse',
        'Create New Process' => 'Neuen Prozess erstellen',
        'Deploy All Processes' => 'Alle Prozesse in Betrieb nehmen',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier können Sie eine Konfigurationdatei hochladen, um einen Prozess in Ihr System zu importieren. Die Datei muss im YAML-Format vorliegen, so wie sie vom Prozessmanagement auch exportiert wird.',
        'Upload process configuration' => 'Prozesskonfiguration hochladen',
        'Import process configuration' => 'Prozesskonfiguration importieren',
        'Ready2Adopt Processes' => 'Ready2Adopt-Prozesse',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Hier können Sie Ready2Adopt-Prozesse zur Demonstration unserer Best-Practices aktivieren. Bitte beachten Sie, dass eventuell weitere Einstellungen erforderlich sind.',
        'Import Ready2Adopt process' => 'Ready2Adopt-Prozesse importieren',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Um einen neuen Prozess zu erstellen, können Sie entweder einen Prozess aus einem anderen System importieren, oder einen ganz neuen erstellen.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Änderungen an den Prozessen wirken sich erst dann aus, wenn Sie die Prozesskonfiguration synchronisieren. Dabei werden alle Änderungen in die Systemkonfiguration übernommen.',
        'Processes' => 'Prozesse',
        'Process name' => 'Prozessname',
        'Print' => 'Drucken',
        'Export Process Configuration' => 'Prozesskonfiguration exportieren',
        'Copy Process' => 'Prozess kopieren',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Abbrechen und Schließen',
        'Go Back' => 'Zurück',
        'Please note, that changing this activity will affect the following processes' =>
            'Achtung: Änderungen an dieser Aktivität werden sich auf folgende Prozesse auswirken',
        'Activity' => 'Aktivität',
        'Activity Name' => 'Name der Aktivität',
        'Activity Dialogs' => 'Aktivitäts-Dialoge',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Sie können Aktivitäts-Dialoge dieser Aktivität zuweisen, indem Sie die Elemente mit der Maus aus der linken Liste in die rechte Liste verschieben.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Die Elemente können auch durch Verschieben mit der Maus geordnet werden.',
        'Filter available Activity Dialogs' => 'Verfügbare Aktivitäts-Dialoge filtern',
        'Available Activity Dialogs' => 'Verfügbare Aktivitäts-Dialoge',
        'Name: %s, EntityID: %s' => 'Name: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Neuen Aktivitäts-Dialog erstellen',
        'Assigned Activity Dialogs' => 'Zugewiesene Aktivitäts-Dialoge',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Veränderungen an diesem Aktivitäts-Dialog werden sich auf folgende Aktivitäten auswirken',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Bitte beachten Sie, dass Kundenbenutzer die folgenden Felder nicht sehen oder benutzen können: Besitzer (Owner), Verantwortlicher (Responsible), Sperre (Lock), Warten bis (PendingTime) und Kundennummer (CustomerID).',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Das Queue-Feld kann nur von Kunden ausgewählt werden, wenn diese ein neues Ticket erstellen.',
        'Activity Dialog' => 'Aktivitäts-Dialog',
        'Activity dialog Name' => 'Name des Aktivitäts-Dialogs',
        'Available in' => 'Verfügbar in',
        'Description (short)' => 'Beschreibung (kurz)',
        'Description (long)' => 'Beschreibung (lang)',
        'The selected permission does not exist.' => 'Die ausgewählte Berechtigung existiert nicht.',
        'Required Lock' => 'Erforderliche Sperre',
        'The selected required lock does not exist.' => 'Die ausgewählte Sperre existiert nicht.',
        'Submit Advice Text' => 'Hinweistext beim Absenden',
        'Submit Button Text' => 'Hinweistext für die Schaltfläche "Absenden"',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Sie können diesem Aktivitäts-Dialog Felder zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.',
        'Filter available fields' => 'Verfügbare Felder filtern',
        'Available Fields' => 'Verfügbare Felder',
        'Assigned Fields' => 'Zugewiesene Felder',
        'Communication Channel' => 'Kommunikationskanal',
        'Is visible for customer' => 'Ist sichtbar für Kunde',
        'Display' => 'Anzeige',

        # Template: AdminProcessManagementPath
        'Path' => 'Pfad',
        'Edit this transition' => 'Diesen Übergang bearbeiten',
        'Transition Actions' => 'Übergangs-Aktionen',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Die können diesem Übergang Übergangs-Aktionen zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.',
        'Filter available Transition Actions' => 'Verfügbare Übergangs-Aktionen filtern',
        'Available Transition Actions' => 'Verfügbare Übergangs-Aktionen',
        'Create New Transition Action' => 'Neue Übergangs-Aktion erstellen',
        'Assigned Transition Actions' => 'Zugewiesene Übergangs-Aktionen',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktivitäten',
        'Filter Activities...' => 'Aktivitäten filtern...',
        'Create New Activity' => 'Neue Aktivität erstellen',
        'Filter Activity Dialogs...' => 'Aktivitäts-Dialoge filtern...',
        'Transitions' => 'Übergänge',
        'Filter Transitions...' => 'Übergänge filtern...',
        'Create New Transition' => 'Neuen Übergang erstellen',
        'Filter Transition Actions...' => 'Übergangs-Aktionen filtern...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Prozess bearbeiten',
        'Print process information' => 'Prozessinformationen drucken',
        'Delete Process' => 'Prozess löschen',
        'Delete Inactive Process' => 'Inaktiven Prozess löschen',
        'Available Process Elements' => 'Verfügbare Prozesselemente',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Die in der Seitenleiste aufgelisteten Elemente können mit der Maus in den Zeichenbereich gezogen werden.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Sie können Aktivitäten im Zeichenbereich platzieren, um diese Aktivitäten dem Prozess zuzuordnen.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Aktivitäts-Dialoge können Sie einer Aktivität zuweisen, indem Sie diese aus der Seitenleiste über die Aktivität im Zeichenbereich ziehen.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Eine Verbindung zwischen Aktivitäten können Sie erstellen, indem Sie das Übergangselement auf die Start-Aktivität der Verbindung ziehen. Anschließend können Sie das freie Ende des Pfeils zur Ziel-Aktivität ziehen.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Aktionen können einem Übergang zugeweisen werden, indem Sie das Aktionselement auf den Namen des Übergangs ziehen.',
        'Edit Process Information' => 'Prozessinformationen bearbeiten',
        'Process Name' => 'Prozessname',
        'The selected state does not exist.' => 'Der ausgewählte Status existiert nicht.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Aktivitäten, Aktivitäts-Dialoge und Übergänge hinzufügen und bearbeiten',
        'Show EntityIDs' => 'EntityIDs einblenden',
        'Extend the width of the Canvas' => 'Die Breite des Zeichenbereichs vergrößern',
        'Extend the height of the Canvas' => 'Die Höhe des Zeichenbereichs vergrößern',
        'Remove the Activity from this Process' => 'Aktivität aus diesem Prozess entfernen',
        'Edit this Activity' => 'Diese Aktivität bearbeiten',
        'Save Activities, Activity Dialogs and Transitions' => 'Aktivitäten, Aktivitätsdialoge und Übergänge speichern',
        'Do you really want to delete this Process?' => 'Möchten Sie diesen Prozess wirklich löschen?',
        'Do you really want to delete this Activity?' => 'Möchten Sie diese Aktivität wirklich löschen?',
        'Do you really want to delete this Activity Dialog?' => 'Möchten Sie diesen Aktivitäts-Dialog wirklich löschen?',
        'Do you really want to delete this Transition?' => 'Möchten Sie diesen Übergang wirklich löschen?',
        'Do you really want to delete this Transition Action?' => 'Möchten Sie diese Übergangs-Aktion wirklich löschen?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Möchten Sie diese Aktivität wirklich vom Zeichenbereich entfernen? Das kann nur rückgängig gemacht werden, wenn Sie diese Ansicht ohne Speichern verlassen.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Möchten Sie diesen Übergang wirklich von der Zeichenfläche entfernen? Das kann nur rückgängig gemacht werden, wenn Sie dieses Fenster ohne Speichern verlassen.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Hier können Sie einen neuen Prozess erstellen. Um den Prozess für die Benutzer verfügbar zu machen, sollten Sie den Status auf "Aktiv" setzen und als Abschluss Ihrer Arbeit die Synchronisation durchführen.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'Abbrechen und Schließen',
        'Start Activity' => 'Startaktivität',
        'Contains %s dialog(s)' => 'Enthält %s Dialog(e)',
        'Assigned dialogs' => 'Zugewiesene Dialoge',
        'Activities are not being used in this process.' => 'In diesem Prozess werden keine Aktivitäten verwendet.',
        'Assigned fields' => 'Zugewiesene Felder',
        'Activity dialogs are not being used in this process.' => 'In diesem Prozess werden keine Aktivitäts-Dialoge verwendet.',
        'Condition linking' => 'Bedingungsverknüpfungen',
        'Transitions are not being used in this process.' => 'In diesem Prozess werden keine Übergänge verwendet.',
        'Module name' => 'Modulname',
        'Transition actions are not being used in this process.' => 'In diesem Prozess werden keine Übergangs-Aktionen verwendet.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Achtung: Änderungen an diesem Übergang wirken sich auf folgende Prozesse aus',
        'Transition' => 'Übergang',
        'Transition Name' => 'Name des Übergangs',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Achtung: Änderungen an dieser Übergangs-Aktion wirken sich auf folgende Prozesse aus',
        'Transition Action' => 'Übergangs-Aktion',
        'Transition Action Name' => 'Name der Übergangs-Aktion',
        'Transition Action Module' => 'Übergangs-Aktionsmodul',
        'Config Parameters' => 'Konfigurations-Parameter',
        'Add a new Parameter' => 'Neuen Parameter hinzufügen',
        'Remove this Parameter' => 'Parameter entfernen',

        # Template: AdminQueue
        'Queue Management' => 'Queue-Verwaltung',
        'Add Queue' => 'Queue hinzufügen',
        'Edit Queue' => 'Queue bearbeiten',
        'Filter for Queues' => 'Filter für Queues',
        'Filter for queues' => 'Filter für Queues',
        'A queue with this name already exists!' => 'Eine Queue mit diesem Namen ist bereits vorhanden!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Diese Queue ist in einer SysConfig-Einstellung vorhanden. Eine Bestätigung für die Aktualisierung der Einstellung auf die neue Queue ist notwendig!',
        'Sub-queue of' => 'Unter-Queue von',
        'Unlock timeout' => 'Freigabe-Zeitintervall',
        '0 = no unlock' => '0 = keine Freigabe',
        'hours' => 'Stunden',
        'Only business hours are counted.' => 'Nur Geschäftszeiten werden berücksichtigt.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Wenn ein Agent ein Ticket sperrt und es vor der Entsperrzeit nicht schließt, wird es entsperrt und wieder für andere Agenten verfügbar gemacht.',
        'Notify by' => 'Benachrichtigung durch',
        '0 = no escalation' => '0 = keine Eskalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Wenn vor der definierten Zeit keine Kundenreaktion erfolgt (externe E-Mail oder Telefon), eskaliert das Ticket.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Wenn ein Artikel vom Kunden hinzugefügt wird, wird die Eskalationszeit zurückgesetzt. Wenn vor der definierten Zeit keine Kundenreaktion erfolgt, eskaliert das Ticket.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Wenn ein Ticket nicht vor der definierten Zeit geschlossen wird, eskaliert es.',
        'Follow up Option' => 'Nachfrage-Option',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Gibt an, ob eine Rückmeldung zu einem geschlossenen Ticket dieses Ticket erneut öffnet, abgelehnt wird oder zu einem neuen Ticket führt.',
        'Ticket lock after a follow up' => 'Ticket sperren nach einer Rückmeldung',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Wenn ein Ticket geschlossen wird und der Kunde eine Rückmeldung schickt, wird das Ticket für den letzten Besitzer gesperrt.',
        'System address' => 'Systemadresse',
        'Will be the sender address of this queue for email answers.' => 'Absenderadresse für E-Mails aus dieser Queue.',
        'Default sign key' => 'Standard-Signierschlüssel',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Um einen Signierschlüssel zu verwenden, müssen PGP-Schlüssel oder S/MIME-Zertifikate mit Identifikatoren für die ausgewählte Systemadresse der Queue hinzugefügt werden.',
        'Salutation' => 'Anrede',
        'The salutation for email answers.' => 'Die Anrede für E-Mail-Antworten.',
        'Signature' => 'Signatur',
        'The signature for email answers.' => 'Die Signatur für E-Mail-Antworten.',
        'This queue is used in the following config settings:' => 'Diese Queue wird in folgenden Konfigurationseinstellungen verwendet:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Zuordnung von Queues und automatischen Antworten verwalten',
        'Change Auto Response Relations for Queue' => 'Automatische Antwort-Zuordnungen verändern für Queue',
        'This filter allow you to show queues without auto responses' => 'Dieser Filter erlaubt das Anzeigen von Queues ohne Automatische Antworten',
        'Queues without Auto Responses' => 'Queues ohne automatische Antworten',
        'This filter allow you to show all queues' => 'Dieser Filter erlaubt das Anzeigen aller Queues',
        'Show All Queues' => 'Alle Queues anzeigen',
        'Auto Responses' => 'Automatische Antworten',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Zuordnung von Vorlagen zu Queues verwalten',
        'Filter for Templates' => 'Filter für Vorlagen',
        'Filter for templates' => 'Filter für Vorlagen',
        'Templates' => 'Vorlagen',

        # Template: AdminRegistration
        'System Registration Management' => 'Systemregistrierungs-Verwaltung',
        'Edit System Registration' => 'Systemregistrierung bearbeiten',
        'System Registration Overview' => 'Übersicht Systemregistrierung',
        'Register System' => 'System registrieren',
        'Validate OTOBO-ID' => 'OTOBO-ID validieren',
        'Deregister System' => 'System deregistrieren',
        'Edit details' => 'Details bearbeiten',
        'Show transmitted data' => 'Übertragene Daten anzeigen',
        'Deregister system' => 'System deregistrieren',
        'Overview of registered systems' => 'Übersicht der registrieren Systeme',
        'This system is registered with OTOBO Team.' => 'Dieses System ist bei der OTRS Gruppe registriert.',
        'System type' => 'Systemtyp',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'Letzte Kommunikation mit dem Registrierungs-Server',
        'System Registration not Possible' => 'Systemregistrierung nicht möglich',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Bitte beachten Sie, dass Sie ihr System nicht registrieren können, wenn der OTOBO Daemon nicht läuft!',
        'Instructions' => 'Anweisungen',
        'System Deregistration not Possible' => 'Deregistrierung des Systems nicht möglich',
        'OTOBO-ID Login' => 'OTOBO-ID Login',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'Die Systemregistrierung ist ein Service der OTRS Gruppe, der Ihnen viele Vorteile sichert!',
        'Read more' => 'Mehr erfahren',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Um Ihr System zu registrieren, loggen Sie sich bitte mit Ihrer OTOBO-ID ein.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Verwenden Sie dazu die E-Mail-Adresse, mit der Sie sich auf der OTOBO Webseite angemeldet haben.',
        'Data Protection' => 'Datenschutz',
        'What are the advantages of system registration?' => 'Welche Vorteile bietet die Systemregistrierung?',
        'You will receive updates about relevant security releases.' => 'Bei sicherheitsrelevanten Releases werden Sie benachrichtigt.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Die Registrierung Ihres Systems ermöglicht es der OTRS Gruppe, Sie schneller und effizienter zu betreuen, weil uns wichtige Informationen über Ihr System bereits vorliegen, die ein mehrmaliges Nachfragen unnötig machen.',
        'This is only the beginning!' => 'Und das ist erst der Anfang!',
        'We will inform you about our new services and offerings soon.' =>
            'Seien Sie gespannt auf weitere Möglichkeiten, die wir Ihnen vorstellen werden.',
        'Can I use OTOBO without being registered?' => 'Kann ich OTOBO auch ohne Registrierung nutzen?',
        'System registration is optional.' => 'Die Systemregistrierung ist optional.',
        'You can download and use OTOBO without being registered.' => 'Sie können OTOBO auch ohne Registrierung im vollen Umfang downloaden und nutzen.',
        'Is it possible to deregister?' => 'Kann ich meine Registrierung rückgängig machen?',
        'You can deregister at any time.' => 'Sie können Ihr System jederzeit deregistrieren.',
        'Which data is transfered when registering?' => 'Welche Daten werden bei der Registrierung übertragen?',
        'A registered system sends the following data to OTOBO Team:' => 'Ein registriertes System überträgt folgende Daten an die OTRS Gruppe:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTOBO Version, Datenbank, Betriebssystem und Perl Version.',
        'Why do I have to provide a description for my system?' => 'Warum muss das System beschrieben werden?',
        'The description of the system is optional.' => 'Die Beschreibung des Systems ist optional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Der Systemtyp und die Beschreibung hilft Ihnen, Ihre Systeme zu identifizieren und die Systemregistrierung zu verwalten.',
        'How often does my OTOBO system send updates?' => 'Wie oft sendet mein OTOBO Updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ihr System sendet in regelmäßigen Abständen Updates an den Registrierungsserver.',
        'Typically this would be around once every three days.' => 'In der Regel findet eine Übertragung an jedem dritten Tag statt.',
        'If you deregister your system, you will lose these benefits:' =>
            'Wenn Sie Ihr System deregistrieren, verlieren Sie folgende Vorteile:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Um Ihr System zu deregistrieren, loggen Sie sich bitte mit Ihrer OTOBO-ID ein.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Sie haben noch keine OTOBO-ID?',
        'Sign up now' => 'Registrieren Sie sich jetzt',
        'Forgot your password?' => 'Passwort vergessen?',
        'Retrieve a new one' => 'Neues anfordern',
        'Next' => 'Weiter',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Wenn Sie dieses System registrieren, werden folgende Daten in regelmäßigen Abständen an die OTRS Gruppe übertragen.',
        'Attribute' => 'Attribut',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO-Version',
        'Operating System' => 'Betriebssystem',
        'Perl Version' => 'Perl-Version',
        'Optional description of this system.' => 'Optionale Beschreibung für dieses System.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Diese Einstellung aktiviert das Senden zusätzlicher Support-Informationen an die OTRS Gruppe.',
        'Register' => 'Registrieren',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Wenn Sie fortfahren, wird dieses System bei der OTRS Gruppe deregistriert.',
        'Deregister' => 'Deregistrieren',
        'You can modify registration settings here.' => 'Sie können ihre Registrierungseinstellungen hier bearbeiten.',
        'Overview of Transmitted Data' => 'Übersicht der übertragenen Daten',
        'There is no data regularly sent from your system to %s.' => 'Von Ihrem System werden keine Daten regelmäßig an %s übertragen.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Folgende Daten werden mindestens aller 3 Tage von Ihrem System an %s übertragen.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Die Daten werden im JSON-Format über eine sichere https-Verbindung übertragen.',
        'System Registration Data' => 'Daten der Systemregistrierung',
        'Support Data' => 'Supportdaten',

        # Template: AdminRole
        'Role Management' => 'Verwaltung von Rollen',
        'Add Role' => 'Rolle hinzufügen',
        'Edit Role' => 'Rolle bearbeiten',
        'Filter for Roles' => 'Filter für Rollen',
        'Filter for roles' => 'Filter für Rollen',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Erstellen Sie Rollen und weisen Sie Gruppen hinzu. Danach fügen Sie Benutzer zu den Rollen hinzu.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Bislang sind keine Rollen definiert. Bitte verwenden Sie die Schaltfläche "Rolle hinzufügen", um neue Rollen zu erstellen.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Zuordnungen von Rollen zu Gruppen verwalten',
        'Roles' => 'Rollen',
        'Select the role:group permissions.' => 'Wählen Sie die Rolle:Gruppe-Berechtigungen aus.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Wenn nichts ausgewählt ist, hat die Rolle in dieser Gruppe keine Berechtigungen (und kann nicht auf Tickets zugreifen).',
        'Toggle %s permission for all' => 'Berechtigung %s für alle umschalten',
        'move_into' => 'Verschieben in',
        'Permissions to move tickets into this group/queue.' => 'Berechtigungen, um Tickets in eine Gruppe/Queue zu verschieben.',
        'create' => 'Erstellen',
        'Permissions to create tickets in this group/queue.' => 'Berechtigungen, um in einer Gruppe/Queue Tickets zu erstellen.',
        'note' => 'Notiz',
        'Permissions to add notes to tickets in this group/queue.' => 'Berechtigungen zum Hinzufügen von Notizen zu Tickets dieser Gruppe/Queue.',
        'owner' => 'Besitzer',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Berechtigungen zum Ändern des Besitzers von Tickets dieser Gruppe/Queue.',
        'priority' => 'Priorität',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Berechtigungen, um die Priorität eines Tickets in einer Gruppe/Queue zu ändern.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Zuordnungen von Agenten und Rollen verwalten',
        'Add Agent' => 'Agent hinzufügen',
        'Filter for Agents' => 'Filter für Agenten',
        'Filter for agents' => 'Filter für Agenten',
        'Agents' => 'Agenten',
        'Manage Role-Agent Relations' => 'Zuordnungen von Agenten und Rollen verwalten',

        # Template: AdminSLA
        'SLA Management' => 'SLA-Verwaltung',
        'Edit SLA' => 'SLA bearbeiten',
        'Add SLA' => 'SLA hinzufügen',
        'Filter for SLAs' => 'Filter für SLAs',
        'Please write only numbers!' => 'Bitte geben Sie nur Zahlen ein!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME-Verwaltung',
        'Add Certificate' => 'Zertifikat hinzufügen',
        'Add Private Key' => 'Privaten Schlüssel hinzufügen',
        'SMIME support is disabled' => 'S/MIME-Unterstützung ist deaktiviert',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Um S/MIME in OTOBO zu verwenden, müssen Sie es zunächst aktivieren.',
        'Enable SMIME support' => 'S/MIME-Unterstützung aktivieren',
        'Faulty SMIME configuration' => 'Fehlerhafte S/MIME-Konfiguration',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'S/MIME-Unterstützung ist zwar aktiviert, jedoch fehlerhaft konfiguriert. Bitte prüfen Sie die Konfiguration durch Klicken der nachfolgenden Schaltfläche.',
        'Check SMIME configuration' => 'S/MIME-Konfiguration prüfen',
        'Filter for Certificates' => 'Filter für Zertifikate',
        'Filter for certificates' => 'Filter für Zertifikate',
        'To show certificate details click on a certificate icon.' => 'Zertifikatsdetails können Sie mit einem Klick auf das Zertifikats-Icon aufrufen.',
        'To manage private certificate relations click on a private key icon.' =>
            'Um Zertifikatszugehörigkeiten zu verwalten können Sie auf das Icon eines privaten Schlüssels klicken.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hier können Sie Beziehungen zu Ihrem privaten Zertifikat hinzufügen, diese werden jedes Mal zur S/MIME-Signatur hinzugefügt, wenn Sie dieses Zertifikat verwenden um eine E-Mail zu signieren.',
        'See also' => 'Siehe auch',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Über diesen Weg können die Zertifikate und privaten Schlüssel im Dateisystem bearbeitet werden.',
        'Hash' => 'Hash',
        'Create' => 'Erstellen',
        'Handle related certificates' => 'Zugehörige Zertifikate verwalten',
        'Read certificate' => 'Zertifikat lesen',
        'Delete this certificate' => 'Dieses Zertifikat löschen',
        'File' => 'Datei',
        'Secret' => 'Geheimnis',
        'Related Certificates for' => 'Zugehörige Zertifikate für',
        'Delete this relation' => 'Diese Zugehörigkeit löschen',
        'Available Certificates' => 'Verfügbare Zertifikate',
        'Filter for S/MIME certs' => 'Filter für S/MIME Zertifikate',
        'Relate this certificate' => 'Dieses Zertifikat zuordnen',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME-Zertifikat',
        'Certificate Details' => 'Zertifikatsdetails',
        'Close this dialog' => 'Diesen Dialog schließen',

        # Template: AdminSalutation
        'Salutation Management' => 'Verwaltung von Anreden',
        'Add Salutation' => 'Anrede hinzufügen',
        'Edit Salutation' => 'Anrede bearbeiten',
        'Filter for Salutations' => 'Filter für Anreden',
        'Filter for salutations' => 'Filter für Anreden',
        'e. g.' => 'z. B.',
        'Example salutation' => 'Beispiel-Anrede',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'Sicherheitsmodus muss eingeschaltet sein!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Der Sicherheitsmodus wird normalerweise eingeschaltet, nachdem die Installation abgeschlossen ist.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Wenn der Sicherheitsmodus nicht aktiv ist, können Sie ihn mit der SysConfig aktivieren, da Ihr System bereits läuft.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Filter for Results' => 'Filter für Resultate',
        'Filter for results' => 'Filter für Resultate',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Senden Sie SQL-Befehle direkt an die Anwendungsdatenbank. Es ist nicht möglich, den Inhalt der Tabellen zu ändern, es sind nur SELECT-Abfragen erlaubt.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier können Sie SQL eingeben, das an die Datenbank gesendet wird.',
        'Options' => 'Optionen',
        'Only select queries are allowed.' => 'Es sind nur Select-Abfragen erlaubt.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Die Syntax Ihrer SQL-Abfrage ist fehlerhaft. Bitte prüfen.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Es fehlt mindestens ein Parameter für das Binding. Bitte prüfen.',
        'Result format' => 'Ergebnisformat',
        'Run Query' => 'Anfrage ausführen',
        '%s Results' => '%s Ergebnisse',
        'Query is executed.' => 'Anfrage wird ausgeführt.',

        # Template: AdminService
        'Service Management' => 'Service-Verwaltung',
        'Add Service' => 'Service hinzufügen',
        'Edit Service' => 'Service bearbeiten',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Die maximale Länge für einen Service-Name (inklusive Unter-Services) beträgt 200 Zeichen.',
        'Sub-service of' => 'Unterservice von',

        # Template: AdminSession
        'Session Management' => 'Sitzungsverwaltung',
        'Detail Session View for %s (%s)' => 'Detail-Sitzungsansicht für %s (%s)',
        'All sessions' => 'Alle Sitzungen',
        'Agent sessions' => 'Agenten-Sitzungen',
        'Customer sessions' => 'Kunden-Sitzungen',
        'Unique agents' => 'Eindeutige Agenten',
        'Unique customers' => 'Eindeutige Kunden',
        'Kill all sessions' => 'Alle Sitzungen beenden',
        'Kill this session' => 'Diese Sitzung beenden',
        'Filter for Sessions' => 'Filter für Sitzungen',
        'Filter for sessions' => 'Filter für Sitzungen',
        'Session' => 'Sitzung',
        'Kill' => 'Beenden',
        'Detail View for SessionID: %s - %s' => 'Detailansicht für SessionID: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Signaturverwaltung',
        'Add Signature' => 'Signatur hinzufügen',
        'Edit Signature' => 'Signatur bearbeiten',
        'Filter for Signatures' => 'Filter für Signaturen',
        'Filter for signatures' => 'Filter für Signaturen',
        'Example signature' => 'Beispiel-Signatur',

        # Template: AdminState
        'State Management' => 'Statusverwaltung',
        'Add State' => 'Status hinzufügen',
        'Edit State' => 'Status bearbeiten',
        'Filter for States' => 'Filter für Status',
        'Filter for states' => 'Filter für Status',
        'Attention' => 'Achtung',
        'Please also update the states in SysConfig where needed.' => 'Bitte aktualisieren Sie auch die Status in der SysConfig dort, wo es erforderlich ist.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Dieser Status ist in einer SysConfig-Einstellung vorhanden. Eine Bestätigung für die Aktualisierung der Einstellung auf den neuen Status ist notwendig!',
        'State type' => 'Statustyp',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Es ist nicht möglich, diese Eingabe ungültig zu machen, da es keinen anderen Statustyp für "Zusammenfassen" im System gibt!',
        'This state is used in the following config settings:' => 'Dieser Status wird in folgenden SysConfig-Einstellungen verwendet:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'Das Senden von Support-Daten an die OTRS-Gruppe ist nicht möglich!',
        'Enable Cloud Services' => 'Cloud-Services aktivieren',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Diese Daten werden regelmäßig an die OTRS Gruppe gesendet. Falls Sie das Senden der Daten beenden möchten, aktualisieren Sie bitte ihre Systemregistrierung.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Sie können den Versand der Support-Daten manuell auslösen, indem Sie diese Schaltfläche verwenden:',
        'Send Update' => 'Update senden',
        'Currently this data is only shown in this system.' => 'Diese Daten werden derzeit nur in Ihrem System angezeigt.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Es wird empfohlen, diese Daten an die OTRS Gruppe zu senden, um bessere Unterstützung zu erhalten.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Um das Senden der Daten zu aktivieren, registrieren Sie bitte Ihr System bei der OTRS Gruppe oder aktualisieren Sie Ihre Systemregistrierung (aktivieren Sie die Option \'Supportdaten senden\'.)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Ein Support-Paket (einschließlich: Systemregistrierungsdaten, Support-Daten, eine Liste der installierten Pakete und aller lokal geänderten Quellcode-Dateien) kann mit dieser Schaltfläche erstellt werden:',
        'Generate Support Bundle' => 'Support-Paket erstellen',
        'The Support Bundle has been Generated' => 'Das Support-Paket wurde erstellt',
        'Please choose one of the following options.' => 'Bitte wählen Sie eine der nachfolgenden Optionen aus.',
        'Send by Email' => 'Per E-Mail senden',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Das Support-Paket ist zu groß, um es manuell zu versenden. Diese Option wurde deaktiviert.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Die E-Mail-Adresse für diesen Benutzer ist ungültig, Die Auswahl wurde deaktiviert.',
        'Sending' => 'Wird gesendet',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'Das Support-Paket wird automatisch per E-Mail zur OTRS Gruppe gesendet.',
        'Download File' => 'Datei herunterladen',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'Das Support-Paket wird als Datei ins lokale Dateisystem heruntergeladen. Bitte speichern Sie die Datei und senden Sie diese auf anderen Wegen an die OTRS Gruppe.',
        'Error: Support data could not be collected (%s).' => 'Fehler: Support-Daten konnten nicht ermittelt werden (%s).',
        'Details' => 'Details',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Verwaltung von System-E-Mail-Adressen',
        'Add System Email Address' => 'System-E-Mail-Adresse hinzufügen',
        'Edit System Email Address' => 'System-E-Mail-Adresse bearbeiten',
        'Add System Address' => 'Systemadresse hinzufügen',
        'Filter for System Addresses' => 'Filter für Systemadressen',
        'Filter for system addresses' => 'Filter für Systemadressen',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle einkommenden E-Mails mit dieser Adresse in An: oder Cc: werden an die ausgewählte Queue geleitet.',
        'Email address' => 'E-Mail-Adresse',
        'Display name' => 'Anzeigename',
        'This email address is already used as system email address.' => 'Diese E-Mail-Adresse wird bereits als Systemadresse verwendet.',
        'The display name and email address will be shown on mail you send.' =>
            'Der Anzeigename und die E-Mail-Adresse werden für die gesendeten E-Mails verwendet.',
        'This system address cannot be set to invalid.' => 'Die Systemadresse kann nicht auf ungültig gesetzt werden.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Die Systemadresse kann nicht auf ungültig gesetzt werden, da sie in einer oder mehreren Queues oder Automatischen Antworten verwendet wird.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'Online-Administratorhandbuch',
        'System configuration' => 'Systemkonfiguration',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Navigieren Sie mithilfe des Baums auf der linken Seite durch die verfügbaren Einstellungen.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Finden Sie spezielle Einstellungen mithilfe des Suchfelds oder der Lupe in der Hauptnavigation.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Erfahren Sie mehr zur Nutzung der Systemkonfiguration im %s.',
        'Search in all settings...' => 'In allen Einstellungen suchen...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Aktuell sind keine Einstellungen verfügbar. Bitte  führen Sie \'otobo.Console.pl Maint::Config::Rebuild\' aus, bevor Sie die Software nutzen.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Inbetriebnahme von Änderungen',
        'Help' => 'Hilfe',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Hier finden Sie eine Übersicht aller Einstellungen, die in die nächste Inbetriebnahme einfließen würden. Sie können jede Einstellung mit ihrem früheren Stand vergleichen, indem Sie auf das Icon oben rechts klicken.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'Um bestimmte Einstellungen aus der Inbetriebnahme auszuschließen, verwenden Sie die Checkbox im Kopfbereich der Einstellung.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Standardmäßig werden nur Einstellungen in Betrieb genommen, die sie selbst verändert haben. Falls Sie auch Änderungen von anderen Benutzern in Betrieb nehmen möchten, verwenden Sie bitte den Link zur erweiterten Inbetriebnahme.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Eine Inbetriebnahme wurde gerade wiederhergestellt. Das bedeutet, dass alle betroffenen Einstellungen auf den Stand zurückgesetzt wurden, in dem sie sich zum Zeitpunkt der gewählten Inbetriebnahme befanden.',
        'Please review the changed settings and deploy afterwards.' => 'Bitte prüfen Sie die geänderten Einstellungen und nehmen Sie sie anschließend in Betrieb.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Eine leere Änderungsliste bedeutet, dass es keine Unterschiede zwischen dem wiederhergestellten und dem aktuellen Stand der betroffenen Einstellungen gibt.',
        'Changes Overview' => 'Übersicht - Alle Änderungen',
        'There are %s changed settings which will be deployed in this run.' =>
            'In diesem Lauf werden %s geänderte Einstellungen in Betrieb genommen.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Wechseln Sie in den Basismodus, um nur Einstellungen in Betrieb zu nehmen, die Sie selbst geändert haben.',
        'You have %s changed settings which will be deployed in this run.' =>
            'In diesem Lauf werden %s von Ihnen geänderte Einstellungen in Betrieb genommen.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Wechseln Sie in den erweiterten Modus, um auch Einstellungen in Betrieb zu nehmen, die von anderen Agenten geändert wurden.',
        'There are no settings to be deployed.' => 'Derzeit sind keine Einstellungen zur Inbetriebnahme vorhanden.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Wechseln Sie in den erweiterten Modus, um Einstellungen zu sehen, die von anderen Agenten geändert wurden und zur Inbetriebnahme bereit sind.',
        'Deploy selected changes' => 'Ausgewählte Einstellungen in Betrieb nehmen',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => 'Inbetriebnahme-Historie',
        'Filter for Deployments' => 'Filter für Inbetriebnahmen',
        'Recent Deployments' => 'Kürzliche Inbetriebnahmen',
        'Restore' => 'Wiederherstellen',
        'View Details' => 'Details ansehen',
        'Restore this deployment.' => 'Inbetriebnahme wiederherstellen.',
        'Export this deployment.' => 'Inbetriebnahme exportieren',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => 'Inbetriebnahme-Details',
        'by' => 'von',
        'No settings have been deployed in this run.' => 'In diesem Lauf wurden keine Einstellungen in Betrieb genommen.',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Diese Gruppe enthält selbst keine Einstellungen. Versuchen Sie,  in eine der verfügbaren Untergruppen zu navigieren.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Import & Export',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Wählen Sie eine Datei, die in Ihr System importiert werden soll (im von der Systemkonfiguration exportierten .yml-Format).',
        'Upload system configuration' => 'Systemkonfiguration hochladen',
        'Import system configuration' => 'Systemkonfiguration importieren',
        'Download current configuration settings of your system in a .yml file.' =>
            'Laden Sie die aktuellen Einstellungen Ihres Systems als .yml-Datei herunter.',
        'Include user settings' => 'Benutzereinstellungen einschließen',
        'Export current configuration' => 'Aktuelle Konfiguration exportieren',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Suche nach',
        'Search for category' => 'Nach Kategorie suchen',
        'Settings I\'m currently editing' => 'Durch mich in Bearbeitung',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Ihre Suche nach "%s" in der Kategorie "%s" ergab keine Ergebnisse.',
        'Your search for "%s" in category "%s" returned one result.' => 'Ihre Suche nach "%s" in der Kategorie "%s" ergab ein Ergebnis.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Ihre Suche nach "%s" in der Kategorie "%s" ergab %s Ergebnisse.',
        'You\'re currently not editing any settings.' => 'Sie bearbeiten derzeit keine Einstellungen.',
        'You\'re currently editing %s setting(s).' => 'Sie bearbeiten derzeit %s Einstellung(en).',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategorie',
        'Run search' => 'Suche starten',

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
        'View a custom List of Settings' => 'Eine eigene Liste an Einstellungen anzeigen',
        'View single Setting: %s' => 'Einstellung: %s anzeigen',
        'Go back to Deployment Details' => 'Zurück zu den Inbetriebnahme-Details gehen',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systemwartungs-Verwaltung',
        'Schedule New System Maintenance' => 'Neue Systemwartung planen',
        'Filter for System Maintenances' => 'Filter für Systemwartungen',
        'Filter for system maintenances' => 'Filter für Systemwartungen',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Ein Systemwartungs-Zeitfenster planen, um Agenten und Kunden auf die Downtime hinzuweisen.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Einige Zeit vor der Systemwartung werden die Nutzer einen Hinweis auf jedem Bildschirm sehen.',
        'Stop date' => 'Endzeitpunkt',
        'Delete System Maintenance' => 'Systemwartung entfernen',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Systemwartung bearbeiten',
        'Edit System Maintenance Information' => 'Systemwartungs-Information bearbeiten',
        'Date invalid!' => 'Ungültiges Datum!',
        'Login message' => 'Nachricht bei Anmeldung',
        'This field must have less then 250 characters.' => 'Dieses Feld muss weniger als 250 Zeichen lang sein.',
        'Show login message' => 'Nachricht bei Anmeldung anzeigen',
        'Notify message' => 'Hinweistext',
        'Manage Sessions' => 'Sitzungen verwalten',
        'All Sessions' => 'Alle Sitzungen',
        'Agent Sessions' => 'Agenten-Sitzungen',
        'Customer Sessions' => 'Kunden-Sitzungen',
        'Kill all Sessions, except for your own' => 'Alle Sitzungen außer Ihrer eigenen beenden',

        # Template: AdminTemplate
        'Template Management' => 'Vorlagenverwaltung',
        'Add Template' => 'Vorlage hinzufügen',
        'Edit Template' => 'Vorlage bearbeiten',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Eine Vorlage ist ein Standardtext, der Ihren Agenten helfen kann, Tickets schneller zu erstellen, beantworten oder weiterzuleiten.',
        'Don\'t forget to add new templates to queues.' => 'Vergessen Sie nicht, neue Vorlagen den Queues zuzuordnen.',
        'Attachments' => 'Anhänge',
        'Delete this entry' => 'Diesen Eintrag löschen',
        'Do you really want to delete this template?' => 'Möchten Sie diese Vorlage wirklich löschen?',
        'A standard template with this name already exists!' => 'Es existiert bereits eine Standardvorlage mit diesem Namen!',
        'Create type templates only supports this smart tags' => 'Vorlagen für das Erstellen unterstützen nur diese "smart tags"',
        'Example template' => 'Beispielvorlage',
        'The current ticket state is' => 'Der aktuelle Ticket-Status ist',
        'Your email address is' => 'Ihre E-Mail-Adresse ist',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Verwaltung der Zuordnung von Anhängen zu Vorlagen',
        'Toggle active for all' => 'Aktiv umschalten für alle',
        'Link %s to selected %s' => '%s zu %s (markiert) verknüpfen',

        # Template: AdminType
        'Type Management' => 'Typverwaltung',
        'Add Type' => 'Typ hinzufügen',
        'Edit Type' => 'Typ bearbeiten',
        'Filter for Types' => 'Filter für Typen',
        'Filter for types' => 'Filter für Typen',
        'A type with this name already exists!' => 'Ein Typ mit diesem Namen existiert bereits!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Dieser Typ ist in einer SysConfig-Einstellung vorhanden. Eine Bestätigung für die Aktualisierung der Einstellung auf den neuen Typ ist notwendig!',
        'This type is used in the following config settings:' => 'Dieser Typ wird in folgenden Konfigurationseinstellungen verwendet:',

        # Template: AdminUser
        'Agent Management' => 'Agentenverwaltung',
        'Edit Agent' => 'Agent bearbeiten',
        'Edit personal preferences for this agent' => 'Persönliche Einstellungen des Agenten bearbeiten',
        'Agents will be needed to handle tickets.' => 'Agenten werden für die Verarbeitung von Tickets benötigt.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Vergessen Sie nicht, einen neuen Agenten zu Gruppen und/oder Rollen hinzuzufügen!',
        'Please enter a search term to look for agents.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Agenten zu suchen.',
        'Last login' => 'Letzte Anmeldung',
        'Switch to agent' => 'Zu Agent wechseln',
        'Title or salutation' => 'Titel oder Anrede',
        'Firstname' => 'Vorname',
        'Lastname' => 'Nachname',
        'A user with this username already exists!' => 'Es existiert bereits ein Nutzer mit diesem Benutzernamen!',
        'Will be auto-generated if left empty.' => 'Wird für ein leeres Feld automatisch generiert.',
        'Mobile' => 'Mobiltelefon',
        'Effective Permissions for Agent' => 'Effektive Berechtigungen für Agent',
        'This agent has no group permissions.' => 'Dieser Agent besitzt keine Gruppenberechtigungen.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'Die obige Tabelle zeigt die effektiven Gruppenberechtigungen für den Agenten. Die Matrix berücksichtigt dabei auch alle vererbten Berechtigungen (z.B. durch Rollen).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zuordnungen von Agent und Gruppe verwalten',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Agendaübersicht',
        'Manage Calendars' => 'Kalender verwalten',
        'Add Appointment' => 'Termin hinzufügen',
        'Today' => 'Heute',
        'All-day' => 'Ganztägig',
        'Repeat' => 'Wiederholung',
        'Notification' => 'Benachrichtigung',
        'Yes' => 'Ja',
        'No' => 'Nein',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Keine Kalender gefunden. Bitte legen Sie zuerst einen Kalender über die Kalenderverwaltung an.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Einen neuen Termin hinzufügen',
        'Calendars' => 'Kalender',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Grundlegende Informationen',
        'Date/Time' => 'Datum/Zeit',
        'Invalid date!' => 'Ungültige Zeitangabe!',
        'Please set this to value before End date.' => 'Bitte setzen Sie einen Wert vor dem Enddatum.',
        'Please set this to value after Start date.' => 'Bitte setzen Sie einen Wert nach dem Startdatum.',
        'This an occurrence of a repeating appointment.' => 'Dies ist ein Vorkommnis eines sich wiederholenden Termins.',
        'Click here to see the parent appointment.' => 'Klicken Sie hier, um den Eltern-Termin anzuzeigen.',
        'Click here to edit the parent appointment.' => 'Klicken Sie hier, um den Eltern-Termin zu bearbeiten.',
        'Frequency' => 'Frequenz',
        'Every' => 'Alle',
        'day(s)' => 'Tag(e)',
        'week(s)' => 'Woche(n)',
        'month(s)' => 'Monat(e)',
        'year(s)' => 'Jahr(e)',
        'On' => 'An',
        'Monday' => 'Montag',
        'Mon' => 'Mo',
        'Tuesday' => 'Dienstag',
        'Tue' => 'Di',
        'Wednesday' => 'Mittwoch',
        'Wed' => 'Mi',
        'Thursday' => 'Donnerstag',
        'Thu' => 'Do',
        'Friday' => 'Freitag',
        'Fri' => 'Fr',
        'Saturday' => 'Samstag',
        'Sat' => 'Sa',
        'Sunday' => 'Sonntag',
        'Sun' => 'So',
        'January' => 'Januar',
        'Jan' => 'Jan',
        'February' => 'Februar',
        'Feb' => 'Feb',
        'March' => 'März',
        'Mar' => 'Mär',
        'April' => 'April',
        'Apr' => 'Apr',
        'May_long' => 'Mai',
        'May' => 'Mai',
        'June' => 'Juni',
        'Jun' => 'Jun',
        'July' => 'Juli',
        'Jul' => 'Jul',
        'August' => 'August',
        'Aug' => 'Aug',
        'September' => 'September',
        'Sep' => 'Sep',
        'October' => 'Oktober',
        'Oct' => 'Okt',
        'November' => 'November',
        'Nov' => 'Nov',
        'December' => 'Dezember',
        'Dec' => 'Dez',
        'Relative point of time' => 'Relativer Zeitpunkt',
        'Link' => 'Verknüpfen',
        'Remove entry' => 'Eintrag entfernen',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kunden-Informationszentrum',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Kundenbenutzer',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Hinweis: Kunde ist ungültig!',
        'Start chat' => 'Chat starten',
        'Video call' => 'Videoanruf',
        'Audio call' => 'Audioanruf',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Kundenbenutzer-Adressbuch',
        'Search for recipients and add the results as \'%s\'.' => 'Suchen Sie nach Empfängern und fügen Sie die Ergebnisse als \'%s\' hinzu.',
        'Search template' => 'Suchvorlage',
        'Create Template' => 'Vorlage anlegen',
        'Create New' => 'Neue anlegen',
        'Save changes in template' => 'Änderungen in der Vorlage speichern',
        'Filters in use' => 'Verwendete Filter',
        'Additional filters' => 'Zusätzliche Filter',
        'Add another attribute' => 'Ein weiteres Attribut hinzufügen',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Die Attribute mit der Bezeichnung \'(Kunde)\' gehören zum Kunden-Unternehmen.',
        '(e. g. Term* or *Term*)' => '(z. B. Begriff* oder *Begriff*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Alle auswählen',
        'The customer user is already selected in the ticket mask.' => 'Der Kunde wurde bereits in der Ticketmaske ausgewählt.',
        'Select this customer user' => 'Diesen Kundenbenutzer wählen',
        'Add selected customer user to' => 'Ausgewählten Kundenbenutzer hinzufügen zu',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Suchoptionen ändern',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Kundenbenutzer-Informationszentrum',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'Der OTOBO Daemon ist ein Daemon-Prozess, welcher asynchrone Aufgaben übernimmt, z.B. das Auslösen von Ticket-Eskalationen oder das Versenden von E-Mails.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Ein laufender OTOBO Daemon ist für die korrekte Funktion des Systems erforderlich.',
        'Starting the OTOBO Daemon' => 'Den OTOBO Daemon starten',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Stellen Sie sicher, dass die Datei \'%s\' existiert (ohne die Endung .dist). Dieser Cronjob wird alle 5 Minuten prüfen, ob der OTOBO Daemon läuft, und ihn ggf. starten.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Führen Sie \'%s start\' aus um sicherzustellen, dass die Cronjobs des \'otobo\'-Nutzers aktiv sind.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Prüfen Sie nach 5 Minuten, ob der OTOBO Daemon läuft  (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Übersicht',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Neuer Termin',
        'Tomorrow' => 'Morgen',
        'Soon' => 'Demnächst',
        '5 days' => '5 Tage',
        'Start' => 'Start',
        'none' => 'keine',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Save settings' => 'Einstellungen speichern',
        'Close this widget' => 'Dieses Widget schließen',
        'more' => 'mehr',
        'Available Columns' => 'Verfügbare Spalten',
        'Visible Columns (order by drag & drop)' => 'Angezeigte Spalten (Anordnung ändern durch Ziehen)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Zuordnungen für Kunden ändern',
        'Open' => 'Offen',
        'Closed' => 'Geschlossen',
        '%s open ticket(s) of %s' => '%s offene Tickets von %s',
        '%s closed ticket(s) of %s' => '%s geschlossene Tickets von %s',
        'Edit customer ID' => 'Kundennummer bearbeiten',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalierte Tickets',
        'Open tickets' => 'Offene Tickets',
        'Closed tickets' => 'Geschlossene Tickets',
        'All tickets' => 'Alle Tickets',
        'Archived tickets' => 'Archivierte Tickets',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Hinweis: Kundenbenutzer ist ungültig!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Kundenbenutzer-Information',
        'Phone ticket' => 'Telefon-Ticket',
        'Email ticket' => 'E-Mail-Ticket',
        'New phone ticket from %s' => 'Neues Telefon-Ticket von %s',
        'New email ticket to %s' => 'Neues E-Mail-Ticket an %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ist nun verfügbar!',
        'Please update now.' => 'Bitte nun aktualisieren.',
        'Release Note' => 'Versionsbeschreibung',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Veröffentlicht vor %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Die Konfiguration für dieses Statistik-Widget enthält Fehler, bitte prüfen Sie ihre Einstellungen.',
        'Download as SVG file' => 'Als SVG-Datei herunterladen',
        'Download as PNG file' => 'Als PNG-Datei herunterladen',
        'Download as CSV file' => 'Als CSV-Datei herunterladen',
        'Download as Excel file' => 'Als Excel-Datei herunterladen',
        'Download as PDF file' => 'Als PDF-Datei herunterladen',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Bitte wählen Sie eine gültiges Ausgabeformat in der Konfiguration dieses Widgets aus.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Der Inhalt dieser Statistik wird vorbereitet. Bitte haben Sie etwas Geduld.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Diese Statistik kann momentan nicht verwendet werden, weil ihre Konfiguration vom Statistik-Administrator korrigiert werden muss.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Zugewiesen zu Kundenbenutzer',
        'Accessible for customer user' => 'Zugreifbar für Kundenbenutzer',
        'My locked tickets' => 'Meine gesperrten Tickets',
        'My watched tickets' => 'Meine beobachteten Tickets',
        'My responsibilities' => 'Meine Verantwortlichkeiten',
        'Tickets in My Queues' => 'Tickets in "Meine Queues"',
        'Tickets in My Services' => 'Tickets in "Meinen Services"',
        'Service Time' => 'Service-Zeit',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Summe',

        # Template: AgentDashboardUserOnline
        'out of office' => 'abwesend',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'bis',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Zurück',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Neuigkeiten, eine Lizenz oder Änderungen bestätigen.',
        'Yes, accepted.' => 'Ja, akzeptiert.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Verknüpfungen für %s verwalten',
        'Create new links' => 'Neue Verknüpfungen erstellen',
        'Manage existing links' => 'Vorhandene Verknüpfungen verwalten',
        'Link with' => 'Verknüpfen mit',
        'Start search' => 'Suche starten',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Derzeit existieren keine Verknüpfungen. Klicken Sie auf "Neue Verknüpfungen erstellen", um das aktuelle Objekt mit anderen Objekten zu verknüpfen.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Passwort ändern',
        'Current password' => 'Aktuelles Passwort',
        'New password' => 'Neues Passwort',
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
        'Edit your preferences' => 'Persönliche Einstellungen bearbeiten',
        'Personal Preferences' => 'Persönliche Einstellungen',
        'Preferences' => 'Einstellungen',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Bitte beachten: Sie bearbeiten derzeit die Einstellungen von %s.',
        'Go back to editing this agent' => 'Zurück zur Bearbeitung des Agenten',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Legen Sie Ihre persönlichen Einstellungen fest. Speichern Sie Einstellungen, indem Sie das Haken-Symbol auf der rechten Seite anklicken.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Sie können den Navigationsbaum verwenden, um nur Einstellungen aus bestimmten Kategorien anzuzeigen.',
        'Dynamic Actions' => 'Dynamische Aktionen',
        'Filter settings...' => 'Einstellungen filtern...',
        'Filter for settings' => 'Filter für Einstellungen',
        'Save all settings' => 'Alle speichern',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Avatare wurden vom Systemadministrator deaktiviert. Sie sehen stattdessen Ihre Initialen.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Sie können Ihr Avatar-Bild ändern, indem Sie sich mit Ihrer E-Mail-Adresse %s unter %s registrieren. Bitte beachten Sie, dass es einige Zeit dauern kann, bis Änderungen sichtbar werden.',
        'Off' => 'Aus',
        'End' => 'Ende',
        'This setting can currently not be saved.' => 'Diese Einstellung kann derzeit nicht gespeichert werden.',
        'This setting can currently not be saved' => 'Diese Einstellung kann derzeit nicht gespeichert werden',
        'Save this setting' => 'Einstellung speichern',
        'Did you know? You can help translating OTOBO at %s.' => 'Haben Sie gewusst, dass Sie bei der Übersetzung von OTOBO unter %s helfen können?',

        # Template: SettingsList
        'Reset to default' => 'Auf Standard zurücksetzen',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Wählen Sie aus den Gruppen auf der rechten Seite, um die Einstellungen zu finden, die Sie ändern möchten.',
        'Did you know?' => 'Wussten Sie schon?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Sie können Ihren Avatar ändern, indem Sie sich mit Ihrer E-Mail-Adresse %s unter %s registrieren',

        # Template: AgentSplitSelection
        'Target' => 'Ziel',
        'Process' => 'Prozess',
        'Split' => 'Teilen',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Statistikverwaltung',
        'Add Statistics' => 'Statistik hinzufügen',
        'Read more about statistics in OTOBO' => 'Erfahren Sie mehr über Statistiken in OTOBO',
        'Dynamic Matrix' => 'Dynamische Matrix',
        'Each cell contains a singular data point.' => 'Jede Zelle enthält einen einzelnen Datenpunkt.',
        'Dynamic List' => 'Dynamische Liste',
        'Each row contains data of one entity.' => 'Jede Zeile enthält Daten eines Objekts.',
        'Static' => 'Statisch',
        'Non-configurable complex statistics.' => 'Nicht konfigurierbare, komplexe Statistiken.',
        'General Specification' => 'Allgemeine Angabe',
        'Create Statistic' => 'Statistik erstellen',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Statistiken bearbeiten',
        'Run now' => 'Jetzt ausführen',
        'Statistics Preview' => 'Statistikvorschau',
        'Save Statistic' => 'Statistik speichern',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Statistiken importieren',
        'Import Statistics Configuration' => 'Statistikkonfiguration importieren',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiken',
        'Run' => 'Start',
        'Edit statistic "%s".' => 'Statistik "%s" bearbeiten.',
        'Export statistic "%s"' => 'Statistik "%s" exportieren',
        'Export statistic %s' => 'Statistik %s exportieren',
        'Delete statistic "%s"' => 'Statistik "%s" löschen',
        'Delete statistic %s' => 'Statistik %s löschen',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Statistikübersicht',
        'View Statistics' => 'Statistiken anzeigen',
        'Statistics Information' => 'Statistik-Informationen',
        'Created by' => 'Erstellt von',
        'Changed by' => 'Geändert von',
        'Sum rows' => 'Zeilensummierung',
        'Sum columns' => 'Spaltensummierung',
        'Show as dashboard widget' => 'Als Dashboard-Widget anzeigen',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Diese Statistik enthält Konfigurationsfehler und kann momentan nicht verwendet werden.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Den Freitext von %s%s%s ändern',
        'Change Owner of %s%s%s' => 'Besitzer von %s%s%s wechseln',
        'Close %s%s%s' => '%s%s%s schließen',
        'Add Note to %s%s%s' => 'Notiz zu %s%s%s hinzufügen',
        'Set Pending Time for %s%s%s' => 'Wartezeit setzen für %s%s%s',
        'Change Priority of %s%s%s' => 'Priorität von %s%s%s ändern',
        'Change Responsible of %s%s%s' => 'Verantwortlichen von %s%s%s ändern',
        'The ticket has been locked' => 'Das Ticket wurde gesperrt',
        'Undo & close' => 'Rückgängig machen und Beenden',
        'Ticket Settings' => 'Ticket-Einstellungen',
        'Queue invalid.' => 'Queue ungültig.',
        'Service invalid.' => 'Ungültiger Service.',
        'SLA invalid.' => 'SLA ungültig.',
        'New Owner' => 'Neuer Besitzer',
        'Please set a new owner!' => 'Bitte legen Sie einen neuen Besitzer fest!',
        'Owner invalid.' => 'Besitzer ungültig.',
        'New Responsible' => 'Neuer Verantwortlicher',
        'Please set a new responsible!' => 'Bitte legen Sie einen neuen Verantwortlichen fest!',
        'Responsible invalid.' => 'Verantwortlicher ungültig.',
        'Next state' => 'Nächster Status',
        'State invalid.' => 'Status ungültig.',
        'For all pending* states.' => 'Für alle warten* Status.',
        'Add Article' => 'Artikel hinzufügen',
        'Create an Article' => 'Artikel erstellen',
        'Inform agents' => 'Agenten informieren',
        'Inform involved agents' => 'Involvierte Agenten informieren',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hier können Sie zusätzliche Agenten auswählen, die eine Benachrichtigung über den neuen Artikel enthalten sollen.',
        'Text will also be received by' => 'Text wird auch gesendet an',
        'Text Template' => 'Textvorlage',
        'Setting a template will overwrite any text or attachment.' => 'Die Auswahl einer Vorlage wird bereits bestehenden Text oder Anhänge löschen.',
        'Invalid time!' => 'Ungültige Zeitangabe!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '%s%s%s umleiten',
        'Bounce to' => 'Umleiten an',
        'You need a email address.' => 'Sie benötigen eine E-Mail-Adresse.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Benötige eine gültige E-Mail-Adresse, verwenden Sie keine lokale Adresse.',
        'Next ticket state' => 'Nächster Status des Tickets',
        'Inform sender' => 'Sender informieren',
        'Send mail' => 'E-Mail übermitteln',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Sammelaktion',
        'Send Email' => 'E-Mail versenden',
        'Merge' => 'Zusammenfassen',
        'Merge to' => 'Zusammenfassen zu',
        'Invalid ticket identifier!' => 'Ungültiger Ticket-Identifizierer!',
        'Merge to oldest' => 'Zusammenfassen zu Ältestem',
        'Link together' => 'Zusammen verlinken',
        'Link to parent' => 'Mit Eltern verknüpfen',
        'Unlock tickets' => 'Tickets entsperren',
        'Execute Bulk Action' => 'Sammelaktion ausführen',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Antwort für %s%s%s verfassen',
        'This address is registered as system address and cannot be used: %s' =>
            'Diese Adresse ist als Systemadresse registriert und kann daher nicht verwendet werden: %s',
        'Please include at least one recipient' => 'Bitte geben sie mindestens einen Empfänger an',
        'Select one or more recipients from the customer user address book.' =>
            'Wählen Sie einen oder mehrere Empfänger aus dem Kundenbenutzer-Adressbuch.',
        'Customer user address book' => 'Kundenbenutzer-Adressbuch',
        'Remove Ticket Customer' => 'Ticket-Kunden entfernen',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Bitte entfernen Sie diesen Eintrag und geben Sie einen mit einem gültigen Wert an.',
        'This address already exists on the address list.' => 'Dieser Eintrag existiert bereits in der Adressliste.',
        'Remove Cc' => 'Cc entfernen',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Bcc entfernen',
        'Date Invalid!' => 'Ungültiges Datum!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Kunde von %s%s%s ändern',
        'Customer Information' => 'Kundeninformation',
        'Customer user' => 'Kundenbenutzer',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Neues E-Mail-Ticket erstellen',
        'Example Template' => 'Beispielvorlage',
        'From queue' => 'Aus Queue',
        'To customer user' => 'An Kundenbenutzer',
        'Please include at least one customer user for the ticket.' => 'Bitte tragen Sie wenigstens einen Kundenbenutzer für das Ticket ein.',
        'Select this customer as the main customer.' => 'Diesen Kunden als Hauptkunden auswählen.',
        'Remove Ticket Customer User' => 'Kundenbenutzer des Tickets entfernen',
        'Get all' => 'Alles holen',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Ausgehende E-Mail für %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'E-Mail erneut versenden für %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: erste Reaktionszeit ist abgelaufen (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: erste Reaktionszeit wird ablaufen in %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s: Aktualisierungszeit ist abgelaufen (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: Aktualisierungszeit wird ablaufen in %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: Lösungszeit ist abgelaufen (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: Lösungszeit wird ablaufen in %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '%s%s%s weiterleiten',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Verlauf von %s%s%s',
        'Filter for history items' => 'Filter für Historieneinträge',
        'Expand/collapse all' => 'Alle aus-/einklappen',
        'CreateTime' => 'Erstellzeit',
        'Article' => 'Artikel',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '%s%s%s zusammenführen',
        'Merge Settings' => 'Einstellungen für Zusammenführung',
        'You need to use a ticket number!' => 'Bitte eine Ticketnummer benutzen!',
        'A valid ticket number is required.' => 'Eine gültige Ticketnummer ist erforderlich.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Geben Sie einen Teil der Ticketnummer oder des Titels ein, um danach zu suchen.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Suche auf Tickets beschränken, die derselben Kundennummer (%s) zugewiesen sind.',
        'Inform Sender' => 'Sender informieren',
        'Need a valid email address.' => 'Benötige gültige E-Mail-Adresse.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%s verschieben',
        'New Queue' => 'Neue Queue',
        'Move' => 'Verschieben',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Keine Ticket-Daten gefunden.',
        'Open / Close ticket action menu' => 'Ticket-Aktionsmenü öffnen/schließen',
        'Select this ticket' => 'Dieses Ticket auswählen',
        'Sender' => 'Sender',
        'First Response Time' => 'Reaktionszeit',
        'Update Time' => 'Aktualisierungszeit',
        'Solution Time' => 'Lösungszeit',
        'Move ticket to a different queue' => 'Ticket in eine andere Queue verschieben',
        'Change queue' => 'Queue wechseln',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Aktive Filter für diesen Bildschirm entfernen.',
        'Tickets per page' => 'Tickets pro Seite',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Fehlender Kanal',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Übersicht zurücksetzen',
        'Column Filters Form' => 'Spaltenfilter-Formular',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'In ein neues Telefon-Ticket splitten',
        'Save Chat Into New Phone Ticket' => 'Chat als neues Telefon-Ticket erstellen',
        'Create New Phone Ticket' => 'Neues Telefon-Ticket erstellen',
        'Please include at least one customer for the ticket.' => 'Bitte geben Sie mindestens einen Kunden für das Ticket an.',
        'To queue' => 'An Queue',
        'Chat protocol' => 'Chat-Protokoll',
        'The chat will be appended as a separate article.' => 'Der Chat wird als separater Artikel angefügt.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Anruf für %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'E-Mail-Klartext für %s%s%s ansehen',
        'Plain' => 'Unformatiert',
        'Download this email' => 'Diese E-Mail herunterladen',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Neues Prozess-Ticket',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Ticket in einen Prozess überführen',

        # Template: AgentTicketSearch
        'Profile link' => 'Profil-Link',
        'Output' => 'Ausgabe',
        'Fulltext' => 'Volltext',
        'Customer ID (complex search)' => 'Kundennummer (komplexe Suche)',
        '(e. g. 234*)' => '(z. B. 234*)',
        'Customer ID (exact match)' => 'Kundennummer (exakte Suche)',
        'Assigned to Customer User Login (complex search)' => 'Zugewiesen an Kundenbenutzer-Login (komplexe Suche)',
        '(e. g. U51*)' => '(z. B. U51*)',
        'Assigned to Customer User Login (exact match)' => 'Zugewiesen an Kundenbenutzer-Loginname (exakte Treffer)',
        'Accessible to Customer User Login (exact match)' => 'Zugreifbar für Kundenbenutzer-Loginname (exakte Treffer)',
        'Created in Queue' => 'Erstellt in Queue',
        'Lock state' => 'Status Sperre',
        'Watcher' => 'Beobachter',
        'Article Create Time (before/after)' => 'Artikel-Erstellzeit (vor/nach)',
        'Article Create Time (between)' => 'Artikel-Erstellzeit (zwischen)',
        'Please set this to value before end date.' => 'Bitte wählen Sie einen Wert, der vor dem Enddatum liegt.',
        'Please set this to value after start date.' => 'Bitte wählen Sie einen Wert, der nach dem Startdatum liegt.',
        'Ticket Create Time (before/after)' => 'Ticket-Erstellzeit (vor/nach)',
        'Ticket Create Time (between)' => 'Ticket-Erstellzeit (zwischen)',
        'Ticket Change Time (before/after)' => 'Ticket-Änderungszeit (vor/nach)',
        'Ticket Change Time (between)' => 'Ticket-Änderungszeit (zwischen)',
        'Ticket Last Change Time (before/after)' => 'Letzte Ticket-Änderungszeit (vor/nach)',
        'Ticket Last Change Time (between)' => 'Letzte Ticket-Änderungszeit (zwischen)',
        'Ticket Pending Until Time (before/after)' => 'Warten bis-Zeit für Ticket (vor/nach)',
        'Ticket Pending Until Time (between)' => 'Warten bis-Zeit für Ticket (zwischen)',
        'Ticket Close Time (before/after)' => 'Ticket-Schließzeit (vor/nach)',
        'Ticket Close Time (between)' => 'Ticket-Schließzeit (zwischen)',
        'Ticket Escalation Time (before/after)' => 'Ticket-Eskalationszeit (vor/nach)',
        'Ticket Escalation Time (between)' => 'Ticket-Eskalationszeit (zwischen)',
        'Archive Search' => 'Archivsuche',

        # Template: AgentTicketZoom
        'Sender Type' => 'Absendertyp',
        'Save filter settings as default' => 'Filtereinstellungen als Standard speichern',
        'Event Type' => 'Ereignistyp',
        'Save as default' => 'Als Standard speichern',
        'Drafts' => 'Entwürfe',
        'Change Queue' => 'Queue ändern',
        'There are no dialogs available at this point in the process.' =>
            'Für diesen Prozess stehen derzeit keine Dialoge zur Verfügung.',
        'This item has no articles yet.' => 'Dieser Eintrag hat noch keine Artikel.',
        'Ticket Timeline View' => 'Ticket-Verlaufsansicht',
        'Article Overview - %s Article(s)' => 'Artikelübersicht - %s Artikel',
        'Page %s' => 'Seite %s',
        'Add Filter' => 'Filter hinzufügen',
        'Set' => 'Setzen',
        'Reset Filter' => 'Filter zurücksetzen',
        'No.' => 'Nr.',
        'Unread articles' => 'Ungelesene Artikel',
        'Via' => 'Via',
        'Important' => 'Wichtig',
        'Unread Article!' => 'Ungelesene Artikel!',
        'Incoming message' => 'Eingehende Nachricht',
        'Outgoing message' => 'Ausgehende Nachricht',
        'Internal message' => 'Interne Nachricht',
        'Sending of this message has failed.' => 'Senden der Nachricht fehlgeschlagen.',
        'Resize' => 'Größe anpassen',
        'Mark this article as read' => 'Diesen Artikel als gelesen markieren',
        'Show Full Text' => 'Vollständigen Text anzeigen',
        'Full Article Text' => 'Vollständiger Artikeltext',
        'No more events found. Please try changing the filter settings.' =>
            'Keine weiteren Ereignisse gefunden. Versuchen Sie die Filtereinstellungen zu verändern.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'via %s',
        'by %s' => 'von %s',
        'Toggle article details' => 'Artikeldetails ein-/ausblenden',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Diese Nachricht wird gerade verarbeitet. Das Versenden wurde bereits %s mal probiert. Nächster Versuch um %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Um die Links im folgenden Artikel zu öffnen, kann es notwendig sein Strg oder Shift zu drücken, während auf den Link geklickt wird (abhängig vom verwendeten Browser und Betriebssystem).',
        'Close this message' => 'Diese Nachricht schließen',
        'Image' => 'Bild',
        'PDF' => 'PDF',
        'Unknown' => 'Unbekannt',
        'View' => 'Ansehen',

        # Template: LinkTable
        'Linked Objects' => 'Verknüpfte Objekte',

        # Template: TicketInformation
        'Archive' => 'Archiv',
        'This ticket is archived.' => 'Dieses Ticket ist archiviert.',
        'Note: Type is invalid!' => 'Hinweis: Typ ist ungültig!',
        'Pending till' => 'Warten bis',
        'Locked' => 'Sperre',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Erfasste Zeit',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'Vorschau des Artikels nicht möglich, da der Kanal %s nicht (mehr) im System vorhanden ist.',
        'Please re-install %s package in order to display this article.' =>
            'Bitte installieren Sie das Paket %s neu, um diesen Artikel anzuzeigen.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Zum Schutz Ihrer Privatsphäre wurden entfernte Inhalte blockiert.',
        'Load blocked content.' => 'Blockierte Inhalte laden.',

        # Template: Breadcrumb
        'Home' => 'Startseite',
        'Back to admin overview' => 'Zurück zur Übersicht',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Diese Funktion setzt Cloud-Services voraus',
        'You can' => 'Sie können',
        'go back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'Die Kundennummer ist nicht änderbar, eine andere Kundennummer kann dem Ticket nicht zugewiesen werden.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Wählen Sie zunächst einen Kundenbenutzer aus. Anschließend können Sie das Ticket einer Kundennummer zuweisen.',
        'Select a customer ID to assign to this ticket.' => 'Wählen Sie die Kundenummer aus, der das Ticket zugewiesen werden soll.',
        'From all Customer IDs' => 'Aus allen Kundennummern',
        'From assigned Customer IDs' => 'Aus allen zugewiesenen Kundennummern',

        # Template: CustomerDashboard
        'Ticket Search' => 'Ticketsuche',

        # Template: CustomerError
        'An Error Occurred' => 'Ein Fehler ist aufgetreten',
        'Error Details' => 'Fehlerdetails',
        'Traceback' => 'Rückverfolgung',

        # Template: CustomerFooter
        'Powered by %s' => 'Powered by %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s hat mögliche Netzwerkprobleme entdeckt. Sie können entweder versuchen die Seite manuell erneut zu laden oder Sie warten bis ihr Browser die Verbindung wiederhergestellt hat.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Die Verbindung wurde nach einer temporären Unterbrechung wiederhergestellt. Möglicherweise funktionieren deshalb einige Elemente der aktuellen Seite nicht (mehr) korrekt. Um alle Elemente wieder wie gewünscht nutzen zu können, sollten Sie die aktuelle Seite neu laden.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nicht verfügbar',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Um alle Möglichkeiten dieser Software zu nutzen, müssen Sie JavaScript in Ihrem Webbrowser aktivieren.',
        'Browser Warning' => 'Browser-Warnung',
        'The browser you are using is too old.' => 'Sie verwenden leider einen (stark) veralteten Webbrowser.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Diese Software funktioniert mit einer großen Auswahl an Webbrowsern, aus denen Sie wählen können. Bitte installieren Sie einen neueren Webbrowser oder aktualisieren Sie Ihren vorhandenen.',
        'Please see the documentation or ask your admin for further information.' =>
            'Bitte lesen Sie auch die Dokumentation oder fragen Sie Ihren Systemadministrator.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            'Der Webbrowser, den sie nutzen, unterstützt kein css-grid. Er ist vermutlich zu alt.',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            'Zumindest eine mit dem Internet Explorer kompatible Version wird in naher Zukunft dennoch veröffentlicht.',
        'One moment please, you are being redirected...' => 'Einen Moment bitte, Sie werden weitergeleitet...',
        'Login' => 'Anmeldung',
        'Your user name' => 'Ihr Benutzername',
        'User name' => 'Benutzername',
        'Your password' => 'Ihr Passwort',
        'Forgot password?' => 'Passwort vergessen?',
        'Your 2 Factor Token' => 'Ihr 2-Faktor-Token',
        '2 Factor Token' => '2-Faktor-Token',
        'Log In' => 'Anmelden',
        'Request Account' => 'Account anfordern',
        'Request New Password' => 'Neues Passwort anfordern',
        'Your User Name' => 'Ihr Benutzername',
        'A new password will be sent to your email address.' => 'Ein neues Passwort wird an Ihre E-Mail-Adresse gesendet.',
        'Create Account' => 'Konto erstellen',
        'Please fill out this form to receive login credentials.' => 'Bitte füllen Sie dieses Formular aus, um Ihre Anmeldedaten zu erhalten.',
        'How we should address you' => 'Wie sollen wir Sie ansprechen',
        'Your First Name' => 'Ihr Vorname',
        'Your Last Name' => 'Ihr Nachname',
        'Your email address (this will become your username)' => 'Ihre E-Mail-Adresse (das wird Ihr Benutzername)',

        # Template: CustomerNavigationBar
        'Logout' => 'Abmelden',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Willkommen!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            'Es sind noch keine Tickets vorhanden. Klicke hier, um ein neues zu erstellen.',
        'Nothing to show.' => 'Keine Tickets vorhanden.',
        'Click here for an unfiltered list of all your tickets.' => 'Klicke hier, für eine ungefilterte Liste aller deiner Tickets.',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => 'Neues Ticket erstellen',
        'Service level agreement' => 'Service-Level-Vereinbarung',

        # Template: CustomerTicketOverview
        'Your Tickets' => 'Deine Tickets',
        'New Ticket' => 'Neues Ticket',
        'Page' => 'Seite',
        'Tickets' => 'Tickets',
        'Sort' => 'Sortieren',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'z. B. 10*5155 oder 105658*',
        'CustomerID' => 'Kundennummer',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Volltextsuche in Tickets (z. B. "John*n" oder "Will*")',
        'Types' => 'Typen',
        'Time Restrictions' => 'Zeitbeschränkungen',
        'No time settings' => 'Keine Zeiteinstellungen',
        'All' => 'Alle',
        'Specific date' => 'spezifisches Datum',
        'Only tickets created' => 'Nur Tickets, die erstellt wurden',
        'Date range' => 'Datumsbereich',
        'Only tickets created between' => 'Nur Tickets, die erstellt wurden zwischen',
        'Ticket Archive System' => 'Ticket-Archivsystem',
        'Save Search as Template?' => 'Suche als Vorlage speichern?',
        'Save as Template?' => 'Als Vorlage speichern?',
        'Save as Template' => 'Als Vorlage speichern',
        'Template Name' => 'Name der Vorlage',
        'Pick a profile name' => 'Profilnamen auswählen',
        'Output to' => 'Ausgabe nach',

        # Template: CustomerTicketSearchResultShort
        'of' => 'von',
        'Search Results for' => 'Suchergebnisse für',
        'Remove this Search Term.' => 'Diesen Suchbegriff entfernen.',

        # Template: CustomerTicketZoom
        'Reply' => 'Antworten',
        'Discard' => 'Verwerfen',
        'Ticket Information' => 'Ticket-Informationen',
        'Categories' => 'Kategorien',

        # Template: Chat
        'Expand article' => 'Artikel aufklappen',

        # Template: CustomerWarning
        'Warning' => 'Warnung',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => 'Ticket<br/>erstellen',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Ereignisinformation',
        'Ticket fields' => 'Ticket-Felder',

        # Template: Error
        'Send a bugreport' => 'Einen Fehlerbericht senden',
        'Expand' => 'Ausklappen',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Klicken Sie, um diesen Anhang zu löschen.',

        # Template: DraftButtons
        'Update draft' => 'Entwurf aktualisieren',
        'Save as new draft' => 'Als neuen Entwurf speichern',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Sie haben den Entwurf "%s" geladen.',
        'You have loaded the draft "%s". You last changed it %s.' => 'Sie haben den Entwurf "%s" geladen, den Sie zuletzt %s geändert haben.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Sie haben den Entwurf "%s" geladen, der zuletzt %s von %s geändert wurde.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Bitte beachten Sie, dass dieser Entwurf aufgrund zwischenzeitlicher Änderungen am Ticket möglicherweise veraltet ist.',

        # Template: Header
        'Edit personal preferences' => 'Persönliche Einstellungen bearbeiten',
        'Personal preferences' => 'Persönliche Einstellungen',
        'You are logged in as' => 'Sie sind angemeldet als',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nicht verfügbar',
        'Step %s' => 'Schritt %s',
        'License' => 'Lizenz',
        'Database Settings' => 'Datenbankeinstellungen',
        'General Specifications and Mail Settings' => 'Allgemeine Einstellungen und E-Mail-Einstellungen',
        'Finish' => 'Abschließen',
        'Welcome to %s' => 'Willkommen bei %s',
        'Germany' => 'Deutschland',
        'Phone' => 'Telefon',
        'Switzerland' => 'Schweiz',
        'Web site' => 'Website',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Mailversand konfigurieren',
        'Outbound mail type' => 'Typ der ausgehenden E-Mail',
        'Select outbound mail type.' => 'Typ der ausgehenden E-Mail auswählen.',
        'Outbound mail port' => 'Port der ausgehenden E-Mail',
        'Select outbound mail port.' => 'Port der ausgehenden E-Mail auswählen.',
        'SMTP host' => 'SMTP-Host',
        'SMTP host.' => 'SMTP-Host.',
        'SMTP authentication' => 'SMPT-Authentifizierung',
        'Does your SMTP host need authentication?' => 'Benötigt der SMTP-Host eine Authentifizierung?',
        'SMTP auth user' => 'Benutzer für SMTP-Authentifizierung',
        'Username for SMTP auth.' => 'Benutzername für SMTP-Authentifizierung.',
        'SMTP auth password' => 'Passwort für SMTP-Authentifizierung',
        'Password for SMTP auth.' => 'Passwort für SMTP-Authentifizierung.',
        'Configure Inbound Mail' => 'Mailempfang konfigurieren',
        'Inbound mail type' => 'Typ der eingehenden E-Mail',
        'Select inbound mail type.' => 'Typ der eingehenden E-Mail auswählen.',
        'Inbound mail host' => 'Host der eingehenden E-Mail',
        'Inbound mail host.' => 'Host der eingehenden E-Mail.',
        'Inbound mail user' => 'Benutzer der eingehenden E-Mail',
        'User for inbound mail.' => 'Benutzername der eingehenden E-Mail.',
        'Inbound mail password' => 'Passwort der eingehenden E-Mail',
        'Password for inbound mail.' => 'Passwort der eingehenden E-Mail.',
        'Result of mail configuration check' => 'Ergebnis der E-Mail-Konfigurationsprüfung',
        'Check mail configuration' => 'E-Mail-Konfiguration prüfen',
        'Skip this step' => 'Diesen Schritt überspringen',

        # Template: InstallerDBResult
        'Done' => 'Fertig',
        'Error' => 'Fehler',
        'Database setup successful!' => 'Datenbank erfolgreich erstellt!',

        # Template: InstallerDBStart
        'Install Type' => 'Installationstyp',
        'Create a new database for OTOBO' => 'Neue Datenbank für OTOBO erstellen',
        'Use an existing database for OTOBO' => 'Bestehende Datenbank für OTOBO nutzen',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Sollte ein Root-Passwort für die Datenbank gesetzt sein, muss dieses hier angegeben werden. Anderenfalls muss dieses Feld leer bleiben.',
        'Database name' => 'Datenbankname',
        'Check database settings' => 'Datenbankeinstellungen prüfen',
        'Result of database check' => 'Ergebnis der Datenbankprüfung',
        'Database check successful.' => 'Datenbankprüfung erfolgreich.',
        'Database User' => 'Datenbankbenutzer',
        'New' => 'Neu',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Ein neuer Datenbank-Benutzer mit beschränkten Rechten wird für dieses OTOBO-System erstellt.',
        'Repeat Password' => 'Passwort wiederholen',
        'Generated password' => 'Generiertes Passwort',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Passworte stimmen nicht überein',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Um OTOBO nutzen zu können, müssen die die folgenden Zeilen als root in die Befehlszeile (Terminal/Shell) eingeben.',
        'Restart your webserver' => 'Starten Sie ihren Webserver neu',
        'After doing so your OTOBO is up and running.' => 'Danach ist OTOBO startklar.',
        'Start page' => 'Startseite',
        'Your OTOBO Team' => 'Ihr OTOBO-Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Lizenz _nicht_ akzeptieren',
        'Accept license and continue' => 'Lizenz akzeptieren und fortfahren',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Der System-Identifizierer. Jede Ticketnummer und jede HTTP-Sitzungs-ID enthalten diese Nummer.',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'Voll qualifizierter Domainname Ihres Systems.',
        'AdminEmail' => 'E-Mail des Administrators',
        'Email address of the system administrator.' => 'E-Mail-Adresse des Administrators.',
        'Organization' => 'Organisation',
        'Log' => 'Protokoll',
        'LogModule' => 'Protokollmodul',
        'Log backend to use.' => 'Protokoll-Backend, welches verwendet werden soll.',
        'LogFile' => 'Protokolldatei',
        'Webfrontend' => 'Web-Oberfläche',
        'Default language' => 'Standardsprache',
        'Default language.' => 'Standardsprache.',
        'CheckMXRecord' => 'MX-Records prüfen',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-Mail-Adressen, die vom Benutzer angegeben werden, werden gegen die MX-Einträge im DNS geprüft. Verwenden Sie diese Option nicht, wenn Ihr DNS langsam ist oder öffentliche Adressen nicht auflösen kann.',

        # Template: LinkObject
        'Delete link' => 'Verknüpfung löschen',
        'Delete Link' => 'Verknüpfung löschen',
        'Object#' => 'Objektnummer',
        'Add links' => 'Verknüpfungen hinzufügen',
        'Delete links' => 'Verknüpfungen löschen',

        # Template: Login
        'Lost your password?' => 'Haben Sie Ihr Passwort vergessen?',
        'Back to login' => 'Zurück zur Anmeldung',

        # Template: MetaFloater
        'Scale preview content' => 'Vorschauinhalt skalieren',
        'Open URL in new tab' => 'URL in neuem Tab öffnen',
        'Close preview' => 'Vorschau schließen',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Diese Webseite kann nicht als Vorschau angezeigt werden, weil sie keine Einbettung erlaubt.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Funktion nicht verfügbar',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Entschuldigung, aber dieses Feature von OTOBO ist derzeit nicht für Mobilgeräte verfügbar. Bitte wechseln sie in die Desktop-Ansicht oder nutzen sie ein normales Desktop-Gerät, wenn Sie diese Funktion verwenden möchten.',

        # Template: Motd
        'Message of the Day' => 'Nachricht des Tages',
        'This is the message of the day. You can edit this in %s.' => 'Das ist die Nachricht des Tages. Sie können diese in %s bearbeiten.',

        # Template: NoPermission
        'Insufficient Rights' => 'Nicht ausreichende Rechte',
        'Back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # Template: Alert
        'Alert' => 'Warnung',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => 'Erste Seite anzeigen',
        'Show previous pages' => 'Vorige Seiten anzeigen',
        'Show page %s' => 'Seite %s anzeigen',
        'Show next pages' => 'Nächste Seiten anzeigen',
        'Show last page' => 'Letzte Seite anzeigen',

        # Template: PictureUpload
        'Need FormID!' => 'FormID benötigt!',
        'No file found!' => 'Keine Datei gefunden!',
        'The file is not an image that can be shown inline!' => 'Diese Datei ist kein Bild, das inline angezeigt werden kann!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Keine vom Benutzer konfigurierbaren Benachrichtigungen gefunden.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Nachrichten für Benachrichtigung \'%s\' mittels Transportmethode \'%s\' empfangen.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Prozessinformationen',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Agenten informieren',

        # Template: PublicDefault
        'Welcome' => 'Willkommen',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Dies ist die öffentliche Standard-Benutzerschnittstelle von OTOBO. Es wurde kein Action-Parameter übergeben.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Sie könnten (mithilfe des Paketmanagers) ein eigenes Modul für den öffentlichen Bereich von OTRS installieren, beispielsweise das FAQ-Modul.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Berechtigungen',
        'You can select one or more groups to define access for different agents.' =>
            'Sie können eine oder mehrere Gruppen definieren, um Zugriffsrechte für verschiedene Agenten zu vergeben.',
        'Result formats' => 'Ergebnisformate',
        'Time Zone' => 'Zeitzone',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Die ausgewählten Zeitperioden der Statistik sind Zeitzonen-unabhängig.',
        'Create summation row' => 'Summenzeile erstellen',
        'Generate an additional row containing sums for all data rows.' =>
            'Eine zusätzliche Zeile mit Summen für alle Datenzeilen erstellen.',
        'Create summation column' => 'Summenspalte erstellen',
        'Generate an additional column containing sums for all data columns.' =>
            'Eine zusätzliche Spalte mit Summen für alle Datenspalten erstellen.',
        'Cache results' => 'Ergebnisse cachen',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Speichert Statistikergebnisse in einem Cache, der bei späteren Aufrufen mit derselben Konfiguration verwendet wird. (Benötigt mindestens ein ausgewähltes Zeitfeld).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Diese Statistik als Dashboard-Widget anbieten, die Agenten in Ihrem Dashboard aktivieren können.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Bitte beachten Sie, dass das Dashboard-Widget das Caching für diese Statistik aktiviert.',
        'If set to invalid end users can not generate the stat.' => 'Bei "ungültig" können Nutzer die Statistik nicht mehr ausführen.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Es bestehen Probleme in der Konfiguration dieser Statistik:',
        'You may now configure the X-axis of your statistic.' => 'Sie können jetzt die X-Achse Ihrer Statistik konfigurieren.',
        'This statistic does not provide preview data.' => 'Diese Statistik stellt keine Vorschaudaten zur Verfügung.',
        'Preview format' => 'Vorschauformat',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Bitte beachten Sie, dass die Vorschau Zufallsdaten verwendet und keine Datenfilter berücksichtigt.',
        'Configure X-Axis' => 'X-Achse konfigurieren',
        'X-axis' => 'X-Achse',
        'Configure Y-Axis' => 'Y-Achse konfigurieren',
        'Y-axis' => 'Y-Achse',
        'Configure Filter' => 'Filter konfigurieren',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Bitte wählen Sie nur ein Element aus oder entfernen Sie das Häkchen der Checkbox \'Fixiert\'.',
        'Absolute period' => 'Absoluter Zeitraum',
        'Between %s and %s' => 'Zwischen %s und %s',
        'Relative period' => 'Relativer Zeitraum',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Die vergangenen %s und der/die aktuelle+kommenden %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Beim Erstellen der Statistik keine Veränderungen an diesem Element erlauben.',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Achsen vertauschen',
        'Configurable Params of Static Stat' => 'Konfigurierbare Parameter der statischen Statistik',
        'No element selected.' => 'Es wurde kein Element ausgewählt.',
        'Scale' => 'Skalierung',
        'show more' => 'Mehr anzeigen',
        'show less' => 'Weniger anzeigen',

        # Template: D3
        'Download SVG' => 'SVG herunterladen',
        'Download PNG' => 'PNG herunterladen',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Der ausgewählte Zeitabschnitt definiert den (voreingestellten) Zeitraum, aus dem diese Statistik Daten aggregiert.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Definiert die Zeiteinheit, anhand welcher der ausgewählte Zeitraum in Berichts-Datenpunkte aufgeteilt wird.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Bitte beachten Sie, dass die Skalierung der Y-Achse größer sein muss als die Skalierung der X-Achse (z. B. X-Achse => Monat, Y-Achse => Jahr).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Diese Einstellung ist deaktiviert.',
        'This setting is fixed but not deployed yet!' => 'Die Einstellung wurde korrigiert, aber bislang nicht in Betrieb genommen!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Diese Einstellung ist aktuell in %s überschrieben und kann deswegen hier nicht geändert werden!',
        'Changing this setting is only available in a higher config level!' =>
            'Das Ändern dieser Einstellung ist nur in einem höheren Konfigurationslevel verfügbar!',
        '%s (%s) is currently working on this setting.' => '%s (%s) arbeitet derzeit an dieser Einstellung.',
        'Toggle advanced options for this setting' => 'Erweiterte Optionen für diese Einstellung ein-/ausblenden',
        'Disable this setting, so it is no longer effective' => 'Einstellung deaktivieren, so dass sie keine Auswirkungen mehr hat',
        'Disable' => 'Deaktivieren',
        'Enable this setting, so it becomes effective' => 'Einstellung aktivieren, so dass sie Auswirkungen hat',
        'Enable' => 'Aktivieren',
        'Reset this setting to its default state' => 'Einstellung auf Standardwert zurücksetzen',
        'Reset setting' => 'Einstellung zurücksetzen',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Nutzern erlauben, diese Einstellung in ihren persönlichen Einstellungen anzupassen',
        'Allow users to update' => 'Aktualisieren durch Nutzer erlauben',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Nutzern nicht länger erlauben, diese Einstellung in ihren persönlichen Einstellungen anzupassen',
        'Forbid users to update' => 'Aktualisieren durch Nutzer nicht erlauben',
        'Show user specific changes for this setting' => 'Änderungen anzeigen, die Nutzer für diese Einstellung vorgenommen haben',
        'Show user settings' => 'Nutzereinstellungen anzeigen',
        'Copy a direct link to this setting to your clipboard' => 'Direkt-Link zu dieser Einstellung in die Zwischenablage kopieren',
        'Copy direct link' => 'Direkt-Link kopieren',
        'Remove this setting from your favorites setting' => 'Einstellung aus den persönlichen Favoriten entfernen',
        'Remove from favourites' => 'Aus Favoriten entfernen',
        'Add this setting to your favorites' => 'Einstellungen den persönlichen Favoriten hinzufügen',
        'Add to favourites' => 'Zu Favoriten hinzufügen',
        'Cancel editing this setting' => 'Bearbeitung dieser Einstellung abbrechen',
        'Save changes on this setting' => 'Änderungen an dieser Einstellung speichern',
        'Edit this setting' => 'Einstellung bearbeiten',
        'Enable this setting' => 'Einstellung aktivieren',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Diese Gruppe enthält selbst keine Einstellungen. Versuchen Sie,  in eine der verfügbaren Untergruppen oder eine andere Gruppe zu navigieren.',

        # Template: SettingsListCompare
        'Now' => 'Jetzt',
        'User modification' => 'Benutzeränderung',
        'enabled' => 'aktiviert',
        'disabled' => 'deaktiviert',
        'Setting state' => 'Status der Einstellung',

        # Template: Actions
        'Edit search' => 'Suche bearbeiten',
        'Go back to admin: ' => 'Zurück zum Admin-Bereich: ',
        'Deployment' => 'Inbetriebnahme',
        'My favourite settings' => 'Meine Favoriten',
        'Invalid settings' => 'Ungültige Einstellungen',

        # Template: DynamicActions
        'Filter visible settings...' => 'Sichtbare Einstellungen filtern...',
        'Enable edit mode for all settings' => 'Bearbeitungsmodus für alle aktivieren',
        'Save all edited settings' => 'Alle geänderten Einstellungen speichern',
        'Cancel editing for all settings' => 'Bearbeitungsmodus für alle abbrechen',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Alle Aktionen aus diesem Widget betreffen nur die jeweils sichtbaren Einstellungen auf der rechten Seite.',

        # Template: Help
        'Currently edited by me.' => 'Derzeit von mir bearbeitet.',
        'Modified but not yet deployed.' => 'Bearbeitet, aber bislang nicht in Betrieb genommen.',
        'Currently edited by another user.' => 'Derzeit durch einen anderen Benutzer in Bearbeitung.',
        'Different from its default value.' => 'Weicht vom Standardwert ab.',
        'Save current setting.' => 'Aktuelle Einstellung speichern.',
        'Cancel editing current setting.' => 'Bearbeitung der aktuellen Einstellung abbrechen.',

        # Template: Navigation
        'Navigation' => 'Navigation',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO Testseite',
        'Unlock' => 'Entsperren',
        'Welcome %s %s' => '%s %s willkommen',
        'Counter' => 'Zähler',

        # Template: Warning
        'Go back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Anzeigen',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Entwurfstitel',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Artikel-Anzeige',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Möchten Sie "%s" wirklich löschen?',
        'Confirm' => 'Bestätigen',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Lade, bitte warten...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Klicken Sie, um eine Datei fürs Hochladen auszuwählen.',
        'Click to select or drop files here.' => 'Klicken zum Auswählen, oder Dateien hier ablegen.',
        'Click to select files or just drop them here.' => 'Klicken Sie zum Auswählen oder legen Sie die Dateien einfach hier ab.',
        'Click to select a file or just drop it here.' => 'Klicken Sie zum Auswählen oder legen Sie die Dateien einfach hier ab.',
        'Uploading...' => 'Wird hochgeladen...',

        # JS Template: InformationDialog
        'Process state' => 'Prozess-Status',
        'Running' => 'Laufend',
        'Finished' => 'Fertig',
        'No package information available.' => 'Keine Paketinformationen verfügbar.',

        # JS Template: AddButton
        'Add new entry' => 'Eintrag hinzufügen',

        # JS Template: AddHashKey
        'Add key' => 'Schlüssel hinzufügen',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Kommentar zur Inbetriebnahme...',
        'This field can have no more than 250 characters.' => 'Dieses Feld darf nicht mehr als 250 Zeichen lang sein.',
        'Deploying, please wait...' => 'Inbetriebnahme läuft, bitte warten...',
        'Preparing to deploy, please wait...' => 'Inbetriebnahme wird vorbereitet, bitte warten...',
        'Deploy now' => 'Jetzt in Betrieb nehmen',
        'Try again' => 'Nochmals versuchen',

        # JS Template: DialogReset
        'Reset options' => 'Optionen zurücksetzen',
        'Reset setting on global level.' => 'Einstellung global zurücksetzen.',
        'Reset globally' => 'Global zurücksetzen',
        'Remove all user changes.' => 'Alle Benutzereinstellungen entfernen.',
        'Reset locally' => 'Lokal zurücksetzen',
        'user(s) have modified this setting.' => 'Benutzer verwenden modifizierte Versionen dieser Einstellung.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Möchten Sie diese Einstellung wirklich auf ihren Standardwert zurücksetzen?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Sie können die Kategorieauswahl nutzen, um den Navigationsbaum auf Einträge aus der gewählten Kategorie einzuschränken. Sobald Sie einen Eintrag wählen, wird der Baum automatisch neu aufgebaut.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Datenbank-Backend',
        'CustomerIDs' => 'Kundennummern',
        'Fax' => 'Fax',
        'Street' => 'Straße',
        'Zip' => 'PLZ',
        'City' => 'Stadt',
        'Country' => 'Land',
        'Mr.' => 'Herr',
        'Mrs.' => 'Frau',
        'Address' => 'Adresse',
        'View system log messages.' => 'Systemprotokoll-Nachrichten ansehen.',
        'Edit the system configuration settings.' => 'Systemeinstellungen bearbeiten.',
        'Update and extend your system with software packages.' => 'System mit Softwarepaketen aktualisieren und erweitern.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Die ACL-Konfiguration ist laut Datenbank nicht synchron mit der Systemkonfiguration, bitte ACLs in Betrieb nehmen.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACLs konnten aufgrund eines unbekannten Fehlers nicht importiert werden, bitte prüfen Sie das Systemprotokoll für mehr Information',
        'The following ACLs have been added successfully: %s' => 'Die folgenden ACLs wurden erfolgreich hinzugefügt: %s',
        'The following ACLs have been updated successfully: %s' => 'Die folgenden ACLs wurden erfolgreich aktualisiert: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Beim Hinzufügen/Aktualisieren der folgenden ACLs sind Fehler aufgetreten: %s. Bitte prüfen Sie das Systemprotokoll für mehr Informationen.',
        'There was an error creating the ACL' => 'Es gab einen Fehler beim Erstellen der ACL',
        'Need ACLID!' => 'ACL-ID benötigt!',
        'Could not get data for ACLID %s' => 'Konnte keine Daten für ACL-ID %s ermitteln',
        'There was an error updating the ACL' => 'Beim Aktualisieren der ACL ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status.' => 'Beim Setzen des Synchronisations-Status ist ein Fehler aufgetreten.',
        'There was an error synchronizing the ACLs.' => 'Es gab einen Fehler beim Synchronisieren der ACLs.',
        'ACL %s could not be deleted' => 'ACL %s konnte nicht gelöscht werden',
        'There was an error getting data for ACL with ID %s' => 'Es gab einen Fehler beim Holen der Daten für die ACL mit der ID %s',
        '%s (copy) %s' => '%s (Kopie) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Bitte beachten Sie, dass ACL-Restriktionen nicht für den Superuser-Account gelten (UserID 1).',
        'Exact match' => 'Genauer Treffer',
        'Negated exact match' => 'Negierter genauer Treffer',
        'Regular expression' => 'Regulärer Ausdruck',
        'Regular expression (ignore case)' => 'Regulärer Ausdruck (Groß-/Kleinschreibung ignorieren)',
        'Negated regular expression' => 'Negierter Regulärer Ausdruck',
        'Negated regular expression (ignore case)' => 'Negierter regulärer Ausdruck (Groß-/Kleinschreibung ignorieren)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Das System konnten den Kalender nicht erstellen!',
        'Please contact the administrator.' => 'Bitte kontaktieren Sie den Administrator.',
        'No CalendarID!' => 'Keine CalenderID!',
        'You have no access to this calendar!' => 'Sie haben keine Zugriffsberechtigung auf diesen Kalender!',
        'Error updating the calendar!' => 'Fehler beim Aktualisieren des Kalenders!',
        'Couldn\'t read calendar configuration file.' => 'Kalender-Konfigurationsdatei konnte nicht gelesen werden.',
        'Please make sure your file is valid.' => 'Bitte stellen Sie sicher, dass die Datei gültig ist.',
        'Could not import the calendar!' => 'Kalender konnte nicht importiert werden!',
        'Calendar imported!' => 'Kalender wurde importiert!',
        'Need CalendarID!' => 'CalendarID wird benötigt!',
        'Could not retrieve data for given CalendarID' => 'Daten konnten nicht abgerufen werden für CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Es wurde(n) %s Termin(e) erfolgreich in Kalender %s importiert.',
        '+5 minutes' => '+5 Minuten',
        '+15 minutes' => '+15 Minuten',
        '+30 minutes' => '+30 Minuten',
        '+1 hour' => '+1 Stunde',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Keine Berechtigung',
        'System was unable to import file!' => 'Das System konnte die Datei nicht importieren!',
        'Please check the log for more information.' => 'Bitte prüfen Sie das Systemprotokoll für weitere Informationen.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Benachrichtigungsname existiert bereits!',
        'Notification added!' => 'Benachrichtigung hinzugefügt!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Beim Ermitteln der Daten für die Benachrichtigung mit der ID %s ist ein Fehler aufgetreten!',
        'Unknown Notification %s!' => 'Unbekannte Benachrichtigung %s!',
        '%s (copy)' => '%s (Kopie)',
        'There was an error creating the Notification' => 'Beim Erstellen der Benachrichtigung ist ein Fehler aufgetreten',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Benachrichtigungen konnten aufgrund eines unbekannten Fehlers nicht importiert werden. Bitte prüfen Sie das Systemprotokoll für mehr Informationen',
        'The following Notifications have been added successfully: %s' =>
            'Folgende Benachrichtigungen wurden erfolgreich importiert: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Folgende Benachrichtigungen wurden erfolgreich aktualisiert: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Beim Hinzufügen/Aktualisieren der folgenden Benachrichtigungen sind Fehler aufgetreten: %s. Bitte prüfen Sie das Systemprotokoll für mehr Informationen.',
        'Notification updated!' => 'Benachrichtigung aktualisiert!',
        'Agent (resources), who are selected within the appointment' => 'Agenten (Ressourcen), welche innerhalb des Termins ausgewählt wurden',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Alle Agenten mit (mindestens) Leseberechtigung für den Termin(kalender)',
        'All agents with write permission for the appointment (calendar)' =>
            'Alle Agenten mit Schreibberechtigung für den Termin(kalender)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Anhang hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Automatische Antwort hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'Ungültige CommunicationID!',
        'All communications' => 'Gesamte Kommunikation',
        'Last 1 hour' => 'Letzte Stunde',
        'Last 3 hours' => 'Letzte 3 Stunden',
        'Last 6 hours' => 'Letzte 6 Stunden',
        'Last 12 hours' => 'Letzte 12 Stunden',
        'Last 24 hours' => 'Letzte 24 Stunden',
        'Last week' => 'Letzte Woche',
        'Last month' => 'Letzter Monat',
        'Invalid StartTime: %s!' => 'Ungültige Startzeit: %s!',
        'Successful' => 'Erfolgreich',
        'Processing' => 'Wird verarbeitet',
        'Failed' => 'Fehlgeschlagen',
        'Invalid Filter: %s!' => 'Ungültiger Filter: %s!',
        'Less than a second' => 'Weniger als eine Sekunde',
        'sorted descending' => 'absteigend sortiert',
        'sorted ascending' => 'aufsteigend sortiert',
        'Trace' => 'Aufzeichnen',
        'Debug' => 'Fehlersuche',
        'Info' => 'Info',
        'Warn' => 'Warnen',
        'days' => 'Tage',
        'day' => 'Tag',
        'hour' => 'Stunde',
        'minute' => 'Minute',
        'seconds' => 'Sekunden',
        'second' => 'Sekunde',

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
        'Customer company updated!' => 'Kundenunternehmen aktualisiert!',
        'Dynamic field %s not found!' => 'Dynamisches Feld 1%s nicht gefunden!',
        'Unable to set value for dynamic field %s!' => 'Wert für Dynamisches Feld 1%s kann nicht gesetzt werden!',
        'Customer Company %s already exists!' => 'Das Kundenunternehmen %s existiert bereits!',
        'Customer company added!' => 'Kundenunternehmen hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Keine Konfiguration für \'CustomerGroupPermissionContext\' gefunden!',
        'Please check system configuration.' => 'Bitte prüfen Sie die Systemkonfiguration.',
        'Invalid permission context configuration:' => 'Ungültige Berechtigungskontext-Konfiguration:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Kunde aktualisiert!',
        'New phone ticket' => 'Neues Telefon-Ticket',
        'New email ticket' => 'Neues E-Mail-Ticket',
        'Customer %s added' => 'Kunde %s hinzugefügt',
        'Customer user updated!' => 'Kundenbenutzer aktualisiert!',
        'Same Customer' => 'Gleicher Kunde',
        'Direct' => 'Direkt',
        'Indirect' => 'Indirekt',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Kundenbenutzer-Zuordnungen verwalten für Gruppe',
        'Change Group Relations for Customer User' => 'Gruppenzuordnungen verwalten für Kundenbenutzer',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Kundenbenutzer zu Services zuordnen',
        'Allocate Services to Customer User' => 'Services zu Kundenbenutzern zuordnen',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Felderkonfiguration ist nicht gültig',
        'Objects configuration is not valid' => 'Die Objektkonfiguration ist ungültig',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Konnte die Reihenfolge der Dynamischen Felder nicht zurücksetzen, bitte prüfen Sie das Systemprotokoll für mehr Informationen.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Unbestimmte Unteraktion.',
        'Need %s' => '%s benötigt',
        'Add %s field' => '%s Feld hinzufügen',
        'The field does not contain only ASCII letters and numbers.' => 'Dieses Feld enthält nicht nur ASCII-Zeichen.',
        'There is another field with the same name.' => 'Es existiert bereits ein Feld mit demselben Namen.',
        'The field must be numeric.' => 'Das Feld darf nur Zahlen beinhalten.',
        'Need ValidID' => 'Benötige ValidID',
        'Could not create the new field' => 'Konnte das neue Feld nicht anlegen',
        'Need ID' => 'ID benötigt',
        'Could not get data for dynamic field %s' => 'Konnte keine Daten für das Dynamische Feld %s ermitteln',
        'Change %s field' => '%s Feld ändern',
        'The name for this field should not change.' => 'Der Name dieses Feldes sollte sich nicht ändern.',
        'Could not update the field %s' => 'Das Feld %s konnte nicht aktualisiert werden',
        'Currently' => 'Aktuell',
        'Unchecked' => 'Nicht ausgewählt',
        'Checked' => 'Ausgewählt',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Dieser Wert existiert bereits.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Eingabe von zukünftigen Datumswerten verhindern',
        'Prevent entry of dates in the past' => 'Eingabe von vergangenen Datumswerten verhindern',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Wählen Sie mindestens einen Empfänger aus.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'Minute(n)',
        'hour(s)' => 'Stunde(n)',
        'Time unit' => 'Zeiteinheit',
        'within the last ...' => 'innerhalb der letzten ...',
        'within the next ...' => 'innerhalb der kommenden ...',
        'more than ... ago' => 'vor mehr als ...',
        'Unarchived tickets' => 'Nicht archivierte Tickets',
        'archive tickets' => 'Tickets archivieren',
        'restore tickets from archive' => 'Tickets aus dem Archiv wiederherstellen',
        'Need Profile!' => 'Benötige Profile!',
        'Got no values to check.' => 'Keine Werte zum Prüfen empfangen.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Bitte entfernen Sie die folgenden Worte, da sie nicht für die Ticket-Auswahl genutzt werden können:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Benötige Web-Service-ID!',
        'Could not get data for WebserviceID %s' => 'Konnte keine Daten für Web-Service-ID %s ermitteln',
        'ascending' => 'aufsteigend',
        'descending' => 'absteigend',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Kommunikationstyp benötigt!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Kommunikationstyp muss \'Requester\' oder \'Provider\' sein!',
        'Invalid Subaction!' => 'Ungültige Unteraktion!',
        'Need ErrorHandlingType!' => 'Benötige Fehlerbehandlungs-Typ!',
        'ErrorHandlingType %s is not registered' => 'Fehlerbehandlungs-Typ %s nicht registriert',
        'Could not update web service' => 'Web-Service konnte nicht aktualisiert werden',
        'Need ErrorHandling' => 'Benötige Fehlerbehandlung',
        'Could not determine config for error handler %s' => 'Konnte Konfiguration für Fehlerbehandlung %s nicht ermitteln',
        'Invoker processing outgoing request data' => 'Der Invoker verarbeitet ausgehende Request-Daten',
        'Mapping outgoing request data' => 'Ausgehende Request-Daten zuordnen',
        'Transport processing request into response' => 'Transportverarbeitung von Anfrage (Request) zu Antwort (Response)',
        'Mapping incoming response data' => 'Eingehende Response-Daten zuordnen',
        'Invoker processing incoming response data' => 'Invoker verarbeitet eingehende Response-Daten',
        'Transport receiving incoming request data' => 'Transport erhält eingehende Request-Daten',
        'Mapping incoming request data' => 'Eingehende Request-Daten zuordnen',
        'Operation processing incoming request data' => 'Operation verarbeitet eingehende Request-Daten',
        'Mapping outgoing response data' => 'Ausgehende Response-Daten zuordnen',
        'Transport sending outgoing response data' => 'Transport sendet ausgehende Response-Daten',
        'skip same backend modules only' => 'Nur gleiche Backend-Module überspringen',
        'skip all modules' => 'Alle Module überspringen',
        'Operation deleted' => 'Operation gelöscht',
        'Invoker deleted' => 'Invoker gelöscht',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 Sekunden',
        '15 seconds' => '15 Sekunden',
        '30 seconds' => '30 Sekunden',
        '45 seconds' => '45 Sekunden',
        '1 minute' => '1 Minute',
        '2 minutes' => '2 Minuten',
        '3 minutes' => '3 Minuten',
        '4 minutes' => '4 Minuten',
        '5 minutes' => '5 Minuten',
        '10 minutes' => '10 Minuten',
        '15 minutes' => '15 Minuten',
        '30 minutes' => '30 Minuten',
        '1 hour' => '1 Stunde',
        '2 hours' => '2 Stunden',
        '3 hours' => '3 Stunden',
        '4 hours' => '4 Stunden',
        '5 hours' => '5 Stunden',
        '6 hours' => '6 Stunden',
        '12 hours' => '12 Stunden',
        '18 hours' => '18 Stunden',
        '1 day' => '1 Tag',
        '2 days' => '2 Tage',
        '3 days' => '3 Tage',
        '4 days' => '4 Tage',
        '6 days' => '6 Tage',
        '1 week' => '1 Woche',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Konnte Konfiguration für Invoker %s nicht ermitteln',
        'InvokerType %s is not registered' => 'Invoker-Typ %s ist nicht registriert',
        'MappingType %s is not registered' => 'Mapping-Typ %s ist nicht registriert',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Benötige Invoker!',
        'Need Event!' => 'Benötige Ereignis!',
        'Could not get registered modules for Invoker' => 'Es konnten keine registrierten Module für Invoker abgerufen werden',
        'Could not get backend for Invoker %s' => 'Konnte das Backend für Invoker %s nicht aufrufen',
        'The event %s is not valid.' => 'Das Ereignis %s ist nicht gültig.',
        'Could not update configuration data for WebserviceID %s' => 'Konnte Konfigurationsdaten für Web-Service-ID %s nicht aktualisieren',
        'This sub-action is not valid' => 'Diese Unteraktion ist nicht gültig',
        'xor' => 'exklusives oder (xor)',
        'String' => 'Zeichenkette',
        'Regexp' => 'Regexp',
        'Validation Module' => 'Validierungsmodul',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Einfaches Mapping für ausgehende Daten',
        'Simple Mapping for Incoming Data' => 'Einfaches Mapping für eingehende Daten',
        'Could not get registered configuration for action type %s' => 'Konnte keine registrierte Konfiguration für Action Typ %s ermitteln',
        'Could not get backend for %s %s' => 'Konnte Backend für %s %s nicht ermitteln',
        'Keep (leave unchanged)' => 'Behalten (unverändert lassen)',
        'Ignore (drop key/value pair)' => 'Ignorieren (Schlüssel-Wert-Paar entfernen)',
        'Map to (use provided value as default)' => 'Ändern in (verwende angegeben Wert als Standard)',
        'Exact value(s)' => 'Genaue(r) Wert(e)',
        'Ignore (drop Value/value pair)' => 'Ignorieren (Wert-Wert-Paar entfernen)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'XSLT-Mapping für ausgehende Daten',
        'XSLT Mapping for Incoming Data' => 'XSLT-Mapping für eingehende Daten',
        'Could not find required library %s' => 'Konnte benötigte Bibliothek %s nicht finden',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Ausgehende Request-Daten vor der Verarbeitung (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Ausgehende Request-Daten vor dem Mapping (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Ausgehende Request-Daten nach dem Mapping (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Eingehende Response-Daten vor dem Mapping (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Ausgehende Fehlerbehandlungsdaten nach der Fehlerbehandlung (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Daten eingehender Requests vor dem Mapping (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Daten eingehender Requests nach dem Mapping (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Ausgehende Response-Daten vor dem Mapping (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Ausgehende Fehlerbehandlungsdaten nach der Fehlerbehandlung (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Konnte Konfiguration für Operation %s nicht ermitteln',
        'OperationType %s is not registered' => 'Operation-Typ %s ist nicht registriert',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Benötige gültige Unteraktion!',
        'This field should be an integer.' => 'Dieses Feld darf nur Ganzzahlen enthalten.',
        'File or Directory not found.' => 'Datei oder Verzeichnis nicht gefunden.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Es existiert bereits ein Web-Service mit demselben Namen.',
        'There was an error updating the web service.' => 'Beim Aktualisieren des Web-Service ist ein Fehler aufgetreten.',
        'There was an error creating the web service.' => 'Beim Erstellen des Web-Service ist ein Fehler aufgetreten.',
        'Web service "%s" created!' => 'Web-Service "%s" erstellt!',
        'Need Name!' => 'Name benötigt!',
        'Need ExampleWebService!' => 'Benötige Beispiel-Web-Service!',
        'Could not load %s.' => '%s konnte nicht geladen werden.',
        'Could not read %s!' => 'Konnte %s nicht lesen!',
        'Need a file to import!' => 'Benötige eine zu importierende Datei!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Die importierte Datei enthält ungültigen YAML-Inhalt. Bitte prüfen Sie das Systemprotokoll für mehr Informationen',
        'Web service "%s" deleted!' => 'Web-Service "%s" gelöscht!',
        'OTOBO as provider' => 'OTOBO als Provider',
        'Operations' => 'Operationen',
        'OTOBO as requester' => 'OTOBO als Requester',
        'Invokers' => 'Invoker',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Keine WebserviceHistoryID empfangen!',
        'Could not get history data for WebserviceHistoryID %s' => 'Konnte Historie für WebserviceHistoryID %s nicht finden',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Gruppe aktualisiert!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'E-Mail-Konto hinzugefügt!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Der E-Mail-Kontoabruf wurde bereits von einem anderen Prozess aufgerufen. Bitte versuchen Sie es später erneut!',
        'Dispatching by email To: field.' => 'Verteilung nach To: Feld.',
        'Dispatching by selected Queue.' => 'Verteilung nach ausgewählter Queue.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Agent, der das Ticket erstellt hat',
        'Agent who owns the ticket' => 'Agent, der Besitzer des Tickets ist',
        'Agent who is responsible for the ticket' => 'Agent, der Verantwortlicher für das Ticket ist',
        'All agents watching the ticket' => 'Alle Agenten, die Beobachter des Tickets sind',
        'All agents with write permission for the ticket' => 'Alle Agenten mit Schreibberechtigung für das Ticket',
        'All agents subscribed to the ticket\'s queue' => 'Alle Agenten, die die Queue des Tickets abonniert haben',
        'All agents subscribed to the ticket\'s service' => 'Alle Agenten, die den Service des Tickets abonniert haben',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Alle Agenten, die sowohl Queue als auch Service des Tickets abonniert haben',
        'Customer user of the ticket' => 'Kundenbenutzer des Tickets',
        'All recipients of the first article' => 'Alle Empfänger des ersten Artikels',
        'All recipients of the last article' => 'Alle Empfänger des letzten Artikels',
        'Invisible to customer' => 'Unsichtbar für Kunde',
        'Visible to customer' => 'Sichtbar für Kunde',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'Die PGP-Umgebung funktioniert derzeit nicht. Bitte prüfen Sie das Systemprotokoll für mehr Informationen!',
        'Need param Key to delete!' => 'Benötige Parameter "Key" zum Löschen!',
        'Key %s deleted!' => 'Schlüssel %s gelöscht!',
        'Need param Key to download!' => 'Benötige Parameter "Key" zum herunterladen!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Entschuldigung, Apache::Reload wird als Perl-Modul und PerlInitHandler in der Apache-Konfiguration benötigt (siehe auch scripts/apache2-httpd.include.conf). Alternativ können Sie Pakete auch mithilfe des Kommandozeilen-Tools bin/otobo.Console.pl installieren!',
        'No such package!' => 'Kein solches Paket!',
        'No such file %s in package!' => 'Keine solche Datei %s im Paket!',
        'No such file %s in local file system!' => 'Datei %s existiert nicht im Dateisystem!',
        'Can\'t read %s!' => 'Kann %s nicht lesen!',
        'File is OK' => 'Datei ist OK',
        'Package has locally modified files.' => 'Das Paket enthält lokal angepasste Dateien.',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'Paket wurde nicht von der OTRS Gruppe verifiziert! Es wird empfohlen, dieses Paket nicht zu nutzen.',
        'Not Started' => 'Nicht gestartet',
        'Updated' => 'Aktualisiert',
        'Already up-to-date' => 'Bereits aktuell',
        'Installed' => 'Installiert',
        'Not correctly deployed' => 'Nicht korrekt installiert',
        'Package updated correctly' => 'Paket korrekt aktualisiert',
        'Package was already updated' => 'Paket wurde bereits aktualisiert',
        'Dependency installed correctly' => 'Abhängigkeit korrekt installiert',
        'The package needs to be reinstalled' => 'Das Paket muss neu installiert werden',
        'The package contains cyclic dependencies' => 'Das Paket enthält zyklische Abhängigkeiten',
        'Not found in on-line repositories' => 'Nicht im Online-Verzeichnis gefunden',
        'Required version is higher than available' => 'Erforderliche Version höher als verfügbar',
        'Dependencies fail to upgrade or install' => 'Abhängigkeiten können nicht aktualisiert oder installiert werden',
        'Package could not be installed' => 'Paket konnte nicht installiert werden',
        'Package could not be upgraded' => 'Paket konnte nicht aktualisiert werden',
        'Repository List' => 'Verzeichnisliste',
        'No packages found in selected repository. Please check log for more info!' =>
            'Keine Pakte im gewählten Verzeichnis gefunden. Bitte prüfen Sie das Systemprotokoll für mehr Informationen!',
        'Package not verified due a communication issue with verification server!' =>
            'Paket nicht verifiziert aufgrund eines Kommunikationsproblems mit dem Verifikationsserver!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Kann nicht zum OTOBO Feature-Add-on-Listenserver verbinden!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Kann OTOBO Feature-Add-on-Listen nicht vom Server laden!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Kann OTOBO Feature-Add-on nicht vom Server laden!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Kein solcher Filter: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Priorität hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Die Konfiguration des Prozessmanagements in der Datenbank ist nicht synchron mit der Systemkonfiguration, bitte synchronisieren Sie alle Prozesse.',
        'Need ExampleProcesses!' => 'Benötige Beispiel-Prozesse!',
        'Need ProcessID!' => 'Benötige ProcessID!',
        'Yes (mandatory)' => 'Ja (erforderlich)',
        'Unknown Process %s!' => 'Unbekannter Prozess %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Beim Generieren einer neuen EntityID für diesen Prozess ist ein Fehler aufgetreten',
        'The StateEntityID for state Inactive does not exists' => 'Die StateEntityID für den Status "Inaktiv" existiert nicht',
        'There was an error creating the Process' => 'Beim Erstellen des Prozesses ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Beim Setzen des Synchronisations-Status für Prozess %s ist ein Fehler aufgetreten',
        'Could not get data for ProcessID %s' => 'Konnte Daten für ProzessID %s nicht ermitteln',
        'There was an error updating the Process' => 'Beim Aktualisieren des Prozesses ist ein Fehler aufgetreten',
        'Process: %s could not be deleted' => 'Prozess %s konnte nicht gelöscht werden',
        'There was an error synchronizing the processes.' => 'Beim Synchronisieren des Prozesses ist ein Fehler aufgetreten.',
        'The %s:%s is still in use' => 'Der/die/das %s:%s ist noch in Benutzung',
        'The %s:%s has a different EntityID' => 'Der/die/das %s:%s hat eine abweichende EntityID',
        'Could not delete %s:%s' => 'Konnte %s:%s nicht löschen',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Beim Setzen des Synchronisations-Status für %s %s ist ein Fehler aufgetreten',
        'Could not get %s' => 'Konnte %s nicht ermitteln',
        'Need %s!' => 'Benötige %s!',
        'Process: %s is not Inactive' => 'Prozess: %s ist nicht aktiv',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Beim Generieren einer neuen EntityID für diese Aktivität ist ein Fehler aufgetreten',
        'There was an error creating the Activity' => 'Beim Erstellen der Aktivität ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Beim Setzen des Synchronisations-Status für Aktivität %s ist ein Fehler aufgetreten',
        'Need ActivityID!' => 'Benötige ActivityID!',
        'Could not get data for ActivityID %s' => 'Konnte Daten für ActivityID %s nicht ermitteln',
        'There was an error updating the Activity' => 'Beim Aktualisieren der Aktivität ist ein Fehler aufgetreten',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Fehlende Parameter: Benötige Aktivität und Aktivitätsdialog!',
        'Activity not found!' => 'Aktivität nicht gefunden!',
        'ActivityDialog not found!' => 'Aktivitätsdialog nicht gefunden!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Aktivitätsdialog wurde der Aktivität bereits zugeordnet. Sie können denselben Aktivitätsdialog nicht mehrfach zuordnen!',
        'Error while saving the Activity to the database!' => 'Während des Speicherns der Aktivität ist ein Fehler aufgetreten!',
        'This subaction is not valid' => 'Diese Unteraktion ist ungültig',
        'Edit Activity "%s"' => 'Aktivität "%s" bearbeiten',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Beim Generieren einer neuen EntityID für diesen Aktivitätsdialog ist ein Fehler aufgetreten',
        'There was an error creating the ActivityDialog' => 'Beim Erstellen des Aktivitätsdialogs ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Beim Setzen des Synchronisations-Status für Aktivitätsdialog %s ist ein Fehler aufgetreten',
        'Need ActivityDialogID!' => 'Benötige ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Konnte Daten für ActivityDialogID %s nicht ermitteln',
        'There was an error updating the ActivityDialog' => 'Beim Aktualisieren des Aktivitätsdialogs ist ein Fehler aufgetreten',
        'Edit Activity Dialog "%s"' => 'AktivitätsDialog "%s" bearbeiten',
        'Agent Interface' => 'Agenten-Interface',
        'Customer Interface' => 'Kunden-Oberfläche',
        'Agent and Customer Interface' => 'Agenten- und Kunden-Oberfläche',
        'Do not show Field' => 'Feld nicht anzeigen',
        'Show Field' => 'Feld anzeigen',
        'Show Field As Mandatory' => 'Als Pflichtfeld anzeigen',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Pfad bearbeiten',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Beim Generieren einer neuen Entity-ID für diesen Übergang ist ein Fehler aufgetreten',
        'There was an error creating the Transition' => 'Beim Erstellen der Transition ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Beim Setzen des Synchronisations-Status für Übergang %s ist ein Fehler aufgetreten',
        'Need TransitionID!' => 'Benötige TransitionID!',
        'Could not get data for TransitionID %s' => 'Konnte Daten für TransitionID %s nicht ermitteln',
        'There was an error updating the Transition' => 'Beim Aktualisieren des Übergangs ist ein Fehler aufgetreten',
        'Edit Transition "%s"' => 'Bearbeite Transition %s',
        'Transition validation module' => 'Transition-Validierungs-Modul',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Mindestens ein gültiger Konfigurationsparameter wird benötigt.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Beim Generieren einer neuen Entity-ID für diese Übergangsaktion ist ein Fehler aufgetreten',
        'There was an error creating the TransitionAction' => 'Beim Erstellen der Übergangsaktion ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Beim Setzen des Synchronisations-Status der Übergangsaktion %s ist ein Fehler aufgetreten',
        'Need TransitionActionID!' => 'Benötige TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Konnte Daten für TransitionActionID %s nicht ermitteln',
        'There was an error updating the TransitionAction' => 'Beim Aktualisieren der Übergangsaktion ist ein Fehler aufgetreten',
        'Edit Transition Action "%s"' => 'Bearbeite Transition-Aktion %s',
        'Error: Not all keys seem to have values or vice versa.' => 'Fehler: Es scheint, als wären nicht allen Schlüsseln auch Werte zugewiesen (oder umgekehrt).',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Queue aktualisiert!',
        'Don\'t use :: in queue name!' => 'Bitte nutzen Sie innerhalb eines Queue-Namens nicht "::"!',
        'Click back and change it!' => 'Bitte gehen Sie zurück und ändern Sie es!',
        '-none-' => '-keine-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Queues (ohne automatische Antworten)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Zuordnung von Vorlage zu Queue verändern',
        'Change Template Relations for Queue' => 'Vorlagen-Zuordnungen für Queue verändern',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktiv',
        'Test' => 'Test',
        'Training' => 'Training',
        'Development' => 'Entwicklung',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rolle aktualisiert!',
        'Role added!' => 'Rolle hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Gruppen-Zuordnungen für Rolle ändern',
        'Change Role Relations for Group' => 'Rollen-Zuordnungen für Gruppe ändern',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rolle',
        'Change Role Relations for Agent' => 'Rollen-Zuordnungen für Agenten ändern',
        'Change Agent Relations for Role' => 'Agenten-Zuordnungen für Rolle ändern',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Bitte %s zuerst aktivieren!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'Die S/MIME-Umgebung funktioniert derzeit nicht. Bitte prüfen Sie das Systemprotokoll für mehr Informationen!',
        'Need param Filename to delete!' => 'Benötige Parameter "Filename" zum Löschen!',
        'Need param Filename to download!' => 'Benötige Parameter "Filename" zum Herunterladen!',
        'Needed CertFingerprint and CAFingerprint!' => 'Benötige CertFingerprint und CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint und CertFingerprint müssen unterschiedlich sein',
        'Relation exists!' => 'Beziehung existiert!',
        'Relation added!' => 'Beziehung hinzugefügt!',
        'Impossible to add relation!' => 'Beziehung konnte nicht hinzugefügt werden!',
        'Relation doesn\'t exists' => 'Beziehung existiert nicht',
        'Relation deleted!' => 'Beziehung gelöscht!',
        'Impossible to delete relation!' => 'Beziehung konnte nicht gelöscht werden!',
        'Certificate %s could not be read!' => 'Zertifikat %s konnte nicht gelesen werden!',
        'Needed Fingerprint' => 'Benötige Fingerprint',
        'Handle Private Certificate Relations' => 'Zuordnungen von privaten Zertifikaten verwalten',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Begrüßung hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Signatur aktualisiert!',
        'Signature added!' => 'Signatur hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Status hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Datei %s kann nicht gelesen werden!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'System-E-Mail-Adresse hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Ungültige Einstellungen',
        'There are no invalid settings active at this time.' => 'Derzeit sind keine ungültigen Einstellungen aktiv.',
        'You currently don\'t have any favourite settings.' => 'Sie haben derzeit keine Einstellungen als Favorit gespeichert.',
        'The following settings could not be found: %s' => 'Die folgenden Einstellungen wurden nicht gefunden: %s',
        'Import not allowed!' => 'Import nicht erlaubt!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'Systemkonfiguration konnte nicht importiert werden, aufgrund eines unbekannten Fehlers. Bitte überprüfe Sie das Systemprotokoll für weitergehende Informationen.',
        'Category Search' => 'Kategoriesuche',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Einige importierte Einstellungen sind im derzeitigen Stand der Konfiguration entweder nicht vorhanden, oder sie konnten nicht aktualisiert werden. Bitte prüfen Sie das Systemprotokoll für weitere Informationen.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'Sie müssen die Einstellung vor der Bearbeitung aktivieren!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Sie können diese Einstellung nicht bearbeiten, da sie derzeit von %s (%s) bearbeitet wird.',
        'Missing setting name!' => 'Name der Einstellung fehlt!',
        'Missing ResetOptions!' => 'ResetOptions fehlen!',
        'Setting is locked by another user!' => 'Einstellung bereits durch einen anderen Nutzer in Bearbeitung!',
        'System was not able to lock the setting!' => 'Einstellung konnte nicht zur Bearbeitung gesperrt werden!',
        'System was not able to reset the setting!' => 'Einstellung konnte nicht zurückgesetzt werden!',
        'System was unable to update setting!' => 'Einstellung konnte nicht aktualisiert werden!',
        'Missing setting name.' => 'Name der Einstellung fehlt.',
        'Setting not found.' => 'Einstellung nicht gefunden.',
        'Missing Settings!' => 'Fehlende Einstellungen!',

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
        'Start date shouldn\'t be defined after Stop date!' => 'Das Startdatum sollte nicht nach dem Enddatum liegen!',
        'There was an error creating the System Maintenance' => 'Beim Erstellen der Systemwartung ist ein Fehler aufgetreten',
        'Need SystemMaintenanceID!' => 'Benötige SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Konnte Daten für SystemMaintenanceID %s nicht ermitteln',
        'System Maintenance was added successfully!' => 'Systemwartung erfolgreich hinzugefügt!',
        'System Maintenance was updated successfully!' => 'Systemwartung erfolgreich aktualisiert!',
        'Session has been killed!' => 'Sitzung wurde beendet!',
        'All sessions have been killed, except for your own.' => 'Alle Sitzungen wurden beendet, außer Ihrer eigenen.',
        'There was an error updating the System Maintenance' => 'Beim Aktualisieren der Systemwartung ist ein Fehler aufgetreten',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Eintrag %s für Systemwartung konnte nicht gelöscht werden!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Vorlage aktualisiert!',
        'Template added!' => 'Vorlage hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Anhangs-Zuordnungen für Vorlage verändern',
        'Change Template Relations for Attachment' => 'Vorlagen-Zuordnungen für Anhang verändern',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Typ benötigt!',
        'Type added!' => 'Typ hinzugefügt!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agent aktualisiert!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Gruppen-Zuordnungen für Agenten ändern',
        'Change Agent Relations for Group' => 'Agenten-Zuordnungen für Gruppe ändern',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Monat',
        'Week' => 'Woche',
        'Day' => 'Tag',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Alle Termine',
        'Appointments assigned to me' => 'Mir zugewiesene Termine',
        'Showing only appointments assigned to you! Change settings' => 'Es werden nur Termine angezeigt, die Ihnen zugewiesen sind! Einstellungen ändern',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Termin wurde nicht gefunden!',
        'Never' => 'Niemals',
        'Every Day' => 'Jeden Tag',
        'Every Week' => 'Jede Woche',
        'Every Month' => 'Jeden Monat',
        'Every Year' => 'Jedes Jahr',
        'Custom' => 'Benutzerdefiniert',
        'Daily' => 'Täglich',
        'Weekly' => 'Wöchentlich',
        'Monthly' => 'Monatlich',
        'Yearly' => 'Jährlich',
        'every' => 'alle',
        'for %s time(s)' => 'für %s Wiederholungen',
        'until ...' => 'bis ...',
        'for ... time(s)' => 'für ... Wiederholungen',
        'until %s' => 'bis %s',
        'No notification' => 'Keine Benachrichtigung',
        '%s minute(s) before' => '%s Minute(n) vorher',
        '%s hour(s) before' => '%s Stunde(n) vorher',
        '%s day(s) before' => '%s Tag(e) vorher',
        '%s week before' => '%s Woche(n) vorher',
        'before the appointment starts' => 'bevor der Termin beginnt',
        'after the appointment has been started' => 'nachdem der Termin begonnen hat',
        'before the appointment ends' => 'bevor der Termin endet',
        'after the appointment has been ended' => 'nachdem der Termin geendet hat',
        'No permission!' => 'Keine Berechtigung!',
        'Cannot delete ticket appointment!' => 'Ticket-Termin konnte nicht gelöscht werden!',
        'No permissions!' => 'Keine Berechtigung!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '%s weitere',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Kundenhistorie',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'RecipientField fehlt!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Keine solche Konfiguration für %s',
        'Statistic' => 'Statistik',
        'No preferences for %s!' => 'Keine Einstellungen für %s!',
        'Can\'t get element data of %s!' => 'Konnte Daten zu Element %s nicht ermitteln!',
        'Can\'t get filter content data of %s!' => 'Kann Filter-Daten von %s nicht ermitteln!',
        'Customer Name' => 'Kundenname',
        'Customer User Name' => 'Kundenbenutzer-Name',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Benötige SourceObject und SourceKey!',
        'You need ro permission!' => 'Sie benötigen die ro-Berechtigung!',
        'Can not delete link with %s!' => 'Kann Verknüpfung mit %s nicht entfernen!',
        '%s Link(s) deleted successfully.' => '%s Verknüpfung(en) erfolgreich gelöscht.',
        'Can not create link with %s! Object already linked as %s.' => 'Kann Verknüpfung zu %s nicht erstellen! Objekt bereits verknüpft als %s.',
        'Can not create link with %s!' => 'Kann Verknüpfung mit %s nicht erstellen!',
        '%s links added successfully.' => '%s Verknüpfung(en) erfolgreich hinzugefügt.',
        'The object %s cannot link with other object!' => 'Objekt %s kann nicht mit anderen Objekten verknüpft werden!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parameter "Group" wird benötigt!',
        'This feature is not available.' => '',
        'Updated user preferences' => 'Benutzereinstellungen aktualisiert',
        'System was unable to deploy your changes.' => 'Das System konnte Ihre Änderungen nicht in Betrieb nehmen.',
        'Setting not found!' => 'Einstellung nicht gefunden!',
        'System was unable to reset the setting!' => 'Einstellung konnte nicht zurückgesetzt werden!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Prozess-Ticket',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parameter %s fehlt.',
        'Invalid Subaction.' => 'Ungültige Unteraktion.',
        'Statistic could not be imported.' => 'Statistik konnte nicht importiert werden.',
        'Please upload a valid statistic file.' => 'Bitte laden Sie eine gültige Statistikdatei hoch.',
        'Export: Need StatID!' => 'Export: Benötige StatID!',
        'Delete: Get no StatID!' => 'Löschen: Keine StatID empfangen!',
        'Need StatID!' => 'Benötige StatID!',
        'Could not load stat.' => 'Konnte Statistik nicht laden.',
        'Add New Statistic' => 'Neue Statistik hinzufügen',
        'Could not create statistic.' => 'Konnte Statistik nicht erstellen.',
        'Run: Get no %s!' => 'Durchlauf: Kein(e) %s empfangen!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Keine TicketID übermittelt!',
        'You need %s permissions!' => 'Sie benötigen die %s-Berechtigung!',
        'Loading draft failed!' => 'Laden des Entwurfs fehlgeschlagen!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Entschuldigung, Sie müssen Besitzer des Tickets sein, um diese Aktion ausführen zu können.',
        'Please change the owner first.' => 'Bitte ändern Sie zunächst den Besitzer.',
        'FormDraft functionality disabled!' => 'Die Entwurfsfunktion ist nicht aktiviert!',
        'Draft name is required!' => 'Name benötigt!',
        'FormDraft name %s is already in use!' => 'Der Name %s ist bereits vergeben!',
        'Could not perform validation on field %s!' => 'Konnte Validierung auf Feld %s nicht ausführen!',
        'No subject' => 'Kein Betreff',
        'Could not delete draft!' => 'Entwurf konnte nicht gelöscht werden!',
        'Previous Owner' => 'Vorheriger Besitzer',
        'wrote' => 'schrieb',
        'Message from' => 'Nachricht von',
        'End message' => 'Ende der Nachricht',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s wird benötigt!',
        'Plain article not found for article %s!' => 'Nur-Text-Version für Artikel %s nicht gefunden!',
        'Article does not belong to ticket %s!' => 'Artikel gehört nicht zu Ticket %s!',
        'Can\'t bounce email!' => 'Kann E-Mail nicht abweisen!',
        'Can\'t send email!' => 'Kann E-Mail nicht senden!',
        'Wrong Subaction!' => 'Falsche Unteraktion!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Kann Tickets nicht sperren, keine TicketIDs übermittelt!',
        'Ticket (%s) is not unlocked!' => 'Ticket %s ist nicht entsperrt!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Die folgenden Tickets wurden ignoriert, weil sie durch einen anderen Agenten gesperrt sind oder keine Schreibberechtigung für diese Tickets vorliegt: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'Das folgende Ticket wurde ignoriert, weil es durch einen anderen Agenten gesperrt sind oder keine Schreibberechtigung für dieses Ticket vorliegt: %s.',
        'You need to select at least one ticket.' => 'Sie müssen mindestens ein Ticket auswählen.',
        'Bulk feature is not enabled!' => 'Das Stapelverarbeitungs-Feature ist nicht aktiviert!',
        'No selectable TicketID is given!' => 'Keine auswählbare TicketID übermittelt!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Sie haben entweder kein Ticket ausgewählt, oder nur Tickets, die von anderen Agenten gesperrt sind.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Die folgenden Tickets wurden ignoriert, weil sie für einen anderen Agenten gesperrt sind oder keine Schreibberechtigung für diese Tickets vorliegt: %s.',
        'The following tickets were locked: %s.' => 'Die folgenden Tickets wurden gesperrt: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'Der Betreff des Artikels ist leer, wenn der Betreff nur den Ticket-Hook enthält!',
        'Address %s replaced with registered customer address.' => 'Adresse %s wurde durch die Adresse des eingetragenen Kunden ersetzt.',
        'Customer user automatically added in Cc.' => 'Kundenbenutzer wurde automatisch ins Cc eingetragen.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Ticket "%s" erstellt!',
        'No Subaction!' => 'Keine Unteraktion!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Keine TicketID empfangen!',
        'System Error!' => 'Systemfehler!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'Keine ArticleID vorhanden!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Nächste Woche',
        'Ticket Escalation View' => 'Ansicht nach Ticket-Eskalationen',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Artikel %s nicht gefunden!',
        'Forwarded message from' => 'Weitergeleitete Nachricht von',
        'End forwarded message' => 'Ende der weitergeleiteten Nachricht',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Kann Historie nicht anzeigen, keine TicketID empfangen!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Kann Ticket nicht sperren, keine TicketID empfangen!',
        'Sorry, the current owner is %s!' => 'Entschuldigung, der aktuelle Besitzer ist %s!',
        'Please become the owner first.' => 'Bitte werden Sie zuerst der Besitzer.',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket (ID=%s) ist durch %s gesperrt!',
        'Change the owner!' => 'Ändern Sie den Besitzer!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Neuer Artikel',
        'Pending' => 'Warten',
        'Reminder Reached' => 'Erinnerung erreicht',
        'My Locked Tickets' => 'Meine gesperrten Tickets',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Kann Ticket nicht mit sich selbst zusammenführen!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Sie benötigen die "Verschieben"-Berechtigung!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Der Chat ist nicht aktiv.',
        'No permission.' => 'Keine Berechtigung.',
        '%s has left the chat.' => '%s hat den Chat verlassen.',
        'This chat has been closed and will be removed in %s hours.' => 'Dieser Chat wurde geschlossen und wird in %s Stunden entfernt.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket gesperrt.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Keine ArticleID!!',
        'This is not an email article.' => 'Dies ist kein E-Mail-Artikel.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Konnte Nur-Text-Artikel nicht lesen. Möglicherweise existiert die Nur-Text-Version nicht. Bitte lesen Sie die Backend-Nachricht.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID benötigt!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Konnte ActivityDialogEntityID %s nicht ermitteln!',
        'No Process configured!' => 'Kein Prozess konfiguriert!',
        'The selected process is invalid!' => 'Der ausgewählte Prozess ist ungültig!',
        'Process %s is invalid!' => 'Prozess %s ist ungültig!',
        'Subaction is invalid!' => 'Unteraktion ist ungültig!',
        'Parameter %s is missing in %s.' => 'Parameter %s fehlt in %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Kein Aktivitätsdialog für %s in _RenderAjax definiert!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Keine Start-ActivityEntityID oder Start-ActivityDialogEntityID für Process %s in _GetParam empfangen!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Konnte Ticket für TicketID %s in _GetParam nicht ermitteln!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Konnte ActivityEntityID nicht ermitteln. Dynamisches Feld oder Konfiguration nicht korrekt!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Konfigurationswert fehlt!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Weder ProcessEntityID, noch TicketID und ActivityDialogEntityID empfangen!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Kann StartActivityDialog für ProcessEntityID "%s" nicht ermitteln!',
        'Can\'t get Ticket "%s"!' => 'Kann Ticket "%s" nicht ermitteln!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Kann ProcessEntityID oder ActivityEntityID für Ticket "%s" nicht ermitteln!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Kann Aktivitäts-Konfiguration für ActivityEntityID "%s" nicht ermitteln!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Kann Aktivitätsdialog-Konfiguration für ActivityDialogEntityID "%s" nicht ermitteln!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Kann Daten für Feld "%s" von Aktivitätsdialog "%s" nicht ermitteln!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Wartezeit kann nur verwendet werden, wenn Status oder StatusID für den Aktivitätsdialog konfiguriert sind. Aktivitätsdialog: %s!',
        'Pending Date' => 'Warten bis',
        'for pending* states' => 'für warten* Status',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID wird benötigt!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Konnte Konfiguration für ActivityDialogEntityID "%s" nicht ermitteln!',
        'Couldn\'t use CustomerID as an invisible field.' => 'CustomerID konnte nicht als unsichtbares Feld verwendet werden.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID fehlt, bitte prüfen Sie Ihre ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Kein StartActivityDialog für Prozess "%s" konfiguriert!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Konnte für den Prozess mit der ProcessEntityID "%s" kein Ticket erstellen!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Konnte ProcessEntityID "%s" nicht für Ticket "%s" setzen!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Konnte ActivityEntityID "%s" nicht für Ticket "%s" setzen!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Konnte Aktivitätsdialog nicht speichern, ungültige TicketID: %s!',
        'Invalid TicketID: %s!' => 'Ungültige TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID fehlt für Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Dieser Schritt gehört nicht mehr der aktuellen Prozess-Aktivität von Ticket \'%s%s%s\'! Ein anderer Anwender hat das Ticket inzwischen verändert. Bitte schließen Sie dieses Fenster und laden Sie das Ticket erneut.',
        'Missing ProcessEntityID in Ticket %s!' => 'ProcessEntityID fehlt für Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Konnte Wert des Dynamischen Feldes %s für TicketID %s im Aktivitätsdialog "%s" nicht speichern!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Konnte Wartezeit %s für TicketID %s im Aktivitätsdialog "%s" nicht speichern!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Falsche Feldkonfiguration im Aktivitätsdialog: %s kann für Anzeige nicht den Wert 1 (= Feld anzeigen) haben. Bitte ändern Sie die Konfiguration auf Anzeige => 0 (Feld nicht anzeigen) oder Anzeige => 2 (als Pflichtfeld anzeigen)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Konnte %s für TicketID "%s" im Aktivitätsdialog "%s" nicht setzen!',
        'Default Config for Process::Default%s missing!' => 'Standardkonfiguration für Process::Default%s fehlt!',
        'Default Config for Process::Default%s invalid!' => 'Standardkonfiguration für Process::Default%s ungültig!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Verfügbare Tickets',
        'including subqueues' => 'untergeordnete Queues miteinbeziehen',
        'excluding subqueues' => 'untergeordnete Queues ausschließen',
        'QueueView' => 'Queue-Ansicht',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Meine verantwortlichen Tickets',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'Letzte Suche',
        'Untitled' => 'Unbenannt',
        'Ticket Number' => 'Ticket-Nummer',
        'Ticket' => 'Ticket',
        'printed by' => 'gedruckt von',
        'CustomerID (complex search)' => 'Kundennummer (komplexe Suche)',
        'CustomerID (exact match)' => 'Kundennummer (genaue Übereinstimmung)',
        'Invalid Users' => 'Ungültige Benutzer',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'in mehr als ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Funktion nicht aktiviert!',
        'Service View' => 'Ansicht nach Services',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Ansicht nach Status',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Meine beobachteten Tickets',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Funktion ist nicht aktiv',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Verknüpfung gelöscht',
        'Ticket Locked' => 'Ticket gesperrt',
        'Pending Time Set' => 'Wartezeit gesetzt',
        'Dynamic Field Updated' => 'Dynamisches Feld aktualisiert',
        'Outgoing Email (internal)' => 'Ausgehende E-Mail (intern)',
        'Ticket Created' => 'Ticket erstellt',
        'Type Updated' => 'Typ aktualisiert',
        'Escalation Update Time In Effect' => 'Eskalation "Aktualisierungszeit" aktiv',
        'Escalation Update Time Stopped' => 'Aktualisierungszeit-Eskalation angehalten',
        'Escalation First Response Time Stopped' => 'Erstreaktionszeit-Eskalation angehalten',
        'Customer Updated' => 'Kunde aktualisiert',
        'Internal Chat' => 'Chat (intern)',
        'Automatic Follow-Up Sent' => 'Automatische Rückfrage gesendet',
        'Note Added' => 'Notiz hinzugefügt',
        'Note Added (Customer)' => 'Notiz hinzugefügt (Kunde)',
        'SMS Added' => 'SMS hinzugefügt',
        'SMS Added (Customer)' => 'SMS hinzugefügt (Kunde)',
        'State Updated' => 'Status aktualisiert',
        'Outgoing Answer' => 'Ausgehende Antwort',
        'Service Updated' => 'Service aktualisiert',
        'Link Added' => 'Verknüpfung hinzugefügt',
        'Incoming Customer Email' => 'Eingehende E-Mail (Kunde)',
        'Incoming Web Request' => 'Eingehende Webanfrage',
        'Priority Updated' => 'Priorität aktualisiert',
        'Ticket Unlocked' => 'Ticket entsperrt',
        'Outgoing Email' => 'Ausgehende E-Mail',
        'Title Updated' => 'Titel aktualisiert',
        'Ticket Merged' => 'Ticket zusammengefasst',
        'Outgoing Phone Call' => 'Ausgehender Telefonanruf',
        'Forwarded Message' => 'Weitergeleitete Nachricht',
        'Removed User Subscription' => 'Benutzer-Abonnement entfernt',
        'Time Accounted' => 'Zeit erfasst',
        'Incoming Phone Call' => 'Eingehender Telefonanruf',
        'System Request.' => 'Systemanfrage.',
        'Incoming Follow-Up' => 'Eingehende Rückfrage',
        'Automatic Reply Sent' => 'Automatische Antwort gesendet',
        'Automatic Reject Sent' => 'Automatische Ablehnung gesendet',
        'Escalation Solution Time In Effect' => 'Eskalation "Lösungszeit" aktiv',
        'Escalation Solution Time Stopped' => 'Lösungszeit-Eskalation angehalten',
        'Escalation Response Time In Effect' => 'Eskalation "Antwortzeit" aktiv',
        'Escalation Response Time Stopped' => 'Antwortzeit-Eskalation angehalten',
        'SLA Updated' => 'SLA aktualisiert',
        'External Chat' => 'Chat (extern)',
        'Queue Changed' => 'Queue gewechselt',
        'Notification Was Sent' => 'Benachrichtigung wurde gesendet',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Dieses Ticket existiert nicht oder Sie haben keine Berechtigung, auf dieses Ticket in seinem aktuellen Status zuzugreifen.',
        'Missing FormDraftID!' => 'Fehlende FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'Konnte Artikel-ID %s nicht ermitteln!',
        'Article filter settings were saved.' => 'Artikelfilter-Einstellungen wurden gespeichert.',
        'Event type filter settings were saved.' => 'Event-Typ-Filtereinstellungen wurden gespeichert.',
        'Need ArticleID!' => 'Benötige ArticleID!',
        'Invalid ArticleID!' => 'Ungültige ArticleID!',
        'Forward article via mail' => 'Artikel per E-Mail weiterleiten',
        'Forward' => 'Weiterleiten',
        'Fields with no group' => 'Felder ohne Gruppe',
        'Invisible only' => 'Nur unsichtbar',
        'Visible only' => 'Nur sichtbar',
        'Visible and invisible' => 'Sichtbar und unsichtbar',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Artikel konnte nicht geöffnet werden. Befindet er sich vielleicht auf einer anderen Artikelseite?',
        'Show one article' => 'Einen Artikel anzeigen',
        'Show all articles' => 'Alle Artikel anzeigen',
        'Show Ticket Timeline View' => 'Ticket-Verlaufsansicht anzeigen',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'FormID fehlt.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Fehler: die Datei konnte nicht korrekt gelöscht werden. Bitte kontaktieren Sie Ihren Administrator (fehlende FileID).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'ArticleID wird benötigt!',
        'No TicketID for ArticleID (%s)!' => 'Keine TicketID für ArticleID (%s)!',
        'HTML body attachment is missing!' => 'HTML-Body-Anhang fehlt!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID und ArticleID werden benötigt!',
        'No such attachment (%s)!' => 'Anlage nicht gefunden (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Prüfen Sie die Sysconfig-Einstellungen für %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Prüfen Sie die Sysconfig-Einstellungen für %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'Sie haben keine ausreichenden Rechte zur Ticket-Anlage in der Default-Queue',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Benötige CustomerID!',
        'My Tickets' => 'Meine Tickets',
        'Company Tickets' => 'Firmen-Tickets',
        'Untitled!' => 'Unbenannt!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Kundenname',
        'Created within the last' => 'Erstellt innerhalb der letzten',
        'Created more than ... ago' => 'Erstellt vor mehr als ...',
        'Please remove the following words because they cannot be used for the search:' =>
            'Bitte entfernen Sie die folgenden Suchworte, da sie nicht für die Suche verwendet werden können:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Konnte Ticket nicht wieder eröffnen. In dieser Queue nicht möglich!',
        'Create a new ticket!' => 'Neues Ticket erstellen!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode ist aktiv!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Wenn Sie den Installer erneut ausführen wollen, schalten Sie "SecureMode" in der SysConfig ab.',
        'Directory "%s" doesn\'t exist!' => 'Verzeichnis "%s" existiert nicht!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Konfigurieren Sie zuerst "Home" in Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => 'Datei "%s/Kernel/Config.pm" wurde nicht gefunden!',
        'Directory "%s" not found!' => 'Verzeichnis "%s" nicht gefunden!',
        'Install OTOBO' => 'OTOBO installieren',
        'Intro' => 'Einführung',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm ist nicht schreibbar!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Wenn Sie den Installer verwenden möchten, stellen Sie sicher, dass Kernel/Config.pm durch den Webserver-Benutzer schreibbar ist!',
        'Database Selection' => 'Datenbank-Auswahl',
        'Unknown Check!' => 'Unbekannte Prüfung!',
        'The check "%s" doesn\'t exist!' => 'Die Prüfung "%s" existiert nicht!',
        'Enter the password for the database user.' => 'Geben Sie das Passwort für den Datenbankbenutzer ein.',
        'Database %s' => 'Datenbank %s',
        'Configure MySQL' => 'MySQL konfigurieren',
        'Enter the password for the administrative database user.' => 'Geben Sie das Passwort für den Administrationsbenutzer der Datenbank ein.',
        'Configure PostgreSQL' => 'PostgreSQL konfigurieren',
        'Configure Oracle' => 'Oracle konfigurieren',
        'Unknown database type "%s".' => 'Unbekannter Datenbank-Typ "%s".',
        'Please go back.' => 'Bitte gehen Sie zurück.',
        'Create Database' => 'Datenbank erstellen',
        'Install OTOBO - Error' => 'OTOBO-Installation - Fehler',
        'File "%s/%s.xml" not found!' => 'Datei "%s/%s.xml" nicht gefunden!',
        'Contact your Admin!' => 'Kontaktieren Sie Ihren Administrator!',
        'System Settings' => 'System-Einstellungen',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'E-Mail konfigurieren',
        'Mail Configuration' => 'Mail-Konfiguration',
        'Can\'t write Config file!' => 'Kann Konfigurationsdatei nicht schreiben!',
        'Unknown Subaction %s!' => 'Unbekannte Subaktion %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Kann nicht zur Datenbank verbinden, Perl-Modul DBD::%s nicht installiert!',
        'Can\'t connect to database, read comment!' => 'Kann nicht zur Datenbank verbinden, bitte Hinweis lesen!',
        'Database already contains data - it should be empty!' => 'Die Datenbank enthält bereits Daten, obwohl sie leer sein sollte!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Fehler: Bitte stellen Sie sicher, dass Ihre Datenbank Pakete größer als %s MB akzeptiert (derzeit werden nur Pakete bis zu einer Größe von %s MB akzeptiert). Bitte passen Sie die Einstellung max_allowed_packet Ihrer Datenbank an, um Fehler zu vermeiden.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Fehler: Bitte erhöhen Sie den Wert für innodb_log_file_size in Ihrer Datenbank-Konfiguration auf mindestens %s MB (aktuell: %s MB, empfohlen: %s MB). Mehr Informationen finden Sie unter %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            'Falsche Datenbank-Sortierfolge (%s ist %s, muss aber utf8 sein).',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Kein %s!',
        'No such user!' => 'Kein Benutzer gefunden!',
        'Invalid calendar!' => 'Ungültiger Kalender!',
        'Invalid URL!' => 'Ungültige URL!',
        'There was an error exporting the calendar!' => 'Es ist ein Fehler beim Exportieren des Kalenders aufgetreten!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Benötige Konfiguration Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Authentifizierung von %s fehlgeschlagen!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Artikel per E-Mail umleiten',
        'Bounce' => 'Umleiten',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Allen antworten',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Diesen Artikel erneut senden',
        'Resend' => 'Erneut senden',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Das Nachrichtenprotokoll für diesen Artikel anzeigen',
        'Message Log' => 'Nachrichtenprotokoll',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Auf Notiz antworten',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Diesen Artikel teilen',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Den Quelltext dieses Artikels anzeigen',
        'Plain Format' => 'Unformatierte Ansicht',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Diesen Artikel drucken',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'Kontaktieren Sie uns unter sales@otrs.com',
        'Get Help' => 'Hilfe',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Markieren',
        'Unmark' => 'Markierung entfernen',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Paket erneut installieren',
        'Re-install' => 'Erneut installieren',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Verschlüsselt',
        'Sent message encrypted to recipient!' => 'Nachricht verschlüsselt an Empfänger senden!',
        'Signed' => 'Signiert',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE"-Header gefunden, aber ungültig!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE"-Header gefunden, aber ungültig!',
        'Ticket decrypted before' => 'Ticket wurde bereits entschlüsselt',
        'Impossible to decrypt: private key for email was not found!' => 'Entschlüsseln nicht möglich: Private Key für E-Mail nicht gefunden!',
        'Successful decryption' => 'Entschlüsseln erfolgreich',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Es stehen keine Schlüssel zur Verfügung für die Adressen: \'%s\'. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Es sind keine Schlüssel ausgewählt für die Adressen: \'%s\'. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Kann abgelaufene Schlüssel für folgende Adressen nicht nutzen \'%s\'. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Kann widerrufene Schlüssel für folgende Adressen nicht nutzen \'%s\'. ',
        'Encrypt' => 'Verschlüsseln',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Schlüssel/Zertifikate werden nur für Empfänger mit mehr als einem Schlüssel/Zertifikat angezeigt. Die erste gefundene Schlüssel/Zertifikat-Kombination wird vorausgewählt. Bitte stellen Sie sicher, die korrekte Kombination auszuwählen.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'E-Mail-Sicherheit',
        'PGP sign' => 'PGP-Signierung',
        'PGP sign and encrypt' => 'PGP-Signierung und -Verschlüsselung',
        'PGP encrypt' => 'PGP-Verschlüsselung',
        'SMIME sign' => 'S/MIME-Signierung',
        'SMIME sign and encrypt' => 'S/MIME-Signierung und -Verschlüsselung',
        'SMIME encrypt' => 'S/MIME-Verschlüsselung',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Kann abgelaufenen Signierungsschlüssel nicht nutzen: \'%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'Kann widerrufenen Signierungsschlüssel nicht nutzen: \'%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Es stehen keine Signierungsschlüssel zur Verfügung für die Adressen: \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Es sind keine Signierungsschlüssel ausgewählt für die Adressen: \'%s\'.',
        'Sign' => 'Signieren',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Schlüssel/Zertifikate werden nur für Absender mit mehr als einem Schlüssel/Zertifikat angezeigt. Die erste gefundene Schlüssel/Zertifikat-Kombination wird vorausgewählt. Bitte stellen Sie sicher, die korrekte Kombination auszuwählen.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Angezeigt',
        'Refresh (minutes)' => 'Aktualisierung (Minuten)',
        'off' => 'aus',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Angezeigte Kundennummern',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Angezeigte Kundenbenutzer',
        'Offline' => 'Offline',
        'User is currently offline.' => 'Benutzer ist derzeit offline.',
        'User is currently active.' => 'Benutzer ist gerade aktiv.',
        'Away' => 'Abwesend',
        'User was inactive for a while.' => 'Benutzer war für eine Weile inaktiv.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Die Startzeit eines Tickets wurde auf einen Zeitpunkt nach der Endzeit gesetzt!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Kein Verbindungsaufbau zum Server mit den OTOBO Neuigkeiten möglich!',
        'Can\'t get OTOBO News from server!' => 'OTOBO Neuigkeiten können nicht vom Server abgerufen werden!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Kein Verbindungsaufbau zum Server mit den Produktneuigkeiten möglich!',
        'Can\'t get Product News from server!' => 'Produktneuigkeiten können nicht vom Server abgerufen werden!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Kein Verbindungsaufbau zu %s möglich!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Gezeigte Tickets',
        'Shown Columns' => 'Gezeigte Spalten',
        'filter not active' => 'Filter nicht aktiv',
        'filter active' => 'Filter aktiv',
        'This ticket has no title or subject' => 'Dieses Ticket hat keinen Titel oder Betreff',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7-Tage-Statistik',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Benutzer hat seinen Status auf "nicht verfügbar" gesetzt.',
        'Unavailable' => 'Nicht verfügbar',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => 'Die folgenden Tickets werden nicht aktualisiert: %s.',
        'h' => 'h',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Dieses Ticket existiert nicht oder Sie haben keine Berechtigung, auf dieses Ticket in seinem aktuellen Status zuzugreifen. Sie können eine der folgenden Optionen wählen:',
        'This is a' => 'Dies ist eine',
        'email' => 'E-Mail',
        'click here' => 'hier klicken',
        'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen.',
        'Year' => 'Jahr',
        'Hours' => 'Stunden',
        'Minutes' => 'Minuten',
        'Check to activate this date' => 'Auswählen, um dieses Datum zu aktivieren',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Keine Zugriffsrechte!',
        'No Permission' => 'Keine Berechtigung',
        'Show Tree Selection' => 'Baumauswahl anzeigen',
        'Split Quote' => 'Zitat aufteilen',
        'Remove Quote' => 'Zitat entfernen',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Verknüpft als',
        'Search Result' => 'Suchergebnis',
        'Linked' => 'Verknüpft',
        'Bulk' => 'Sammelaktion',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Einfach',
        'Unread article(s) available' => 'Ungelesene Artikel verfügbar',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Termin',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Archivsuche',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Online-Agent: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Mehrere eskalierte Tickets vorhanden!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Bitte wählen Sie eine Zeitzone in Ihren Einstellungen aus und bestätigen Sie dies durch Klicken der Speichern-Schaltfläche.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Online-Kunde: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Systemwartung ist aktiv!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Eine Systemwartung beginnt um: %s und endet voraussichtlich um: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'Der OTOBO Daemon läuft nicht.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Sie haben die Abwesenheitszeit eingeschaltet, möchten Sie diese deaktivieren?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Es wurden %s ungültige Einstellung(en) in Betrieb genommen. Klicken Sie hier, um die Einstellungen anzuzeigen.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Es sind Einstellungen vorhanden, die bislang nicht in Betrieb genommen wurden. Möchten Sie jetzt eine Inbetriebnahme starten?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Die Systemkonfiguration wird aktualisiert. Bitte haben Sie etwas Geduld.',
        'There is an error updating the system configuration!' => 'Beim Aktualisieren der Systemkonfiguration ist ein Fehler aufgetreten!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Bitte nicht mit dem Superuser-Account in %s arbeiten! Bitte legen Sie neue Agenten an und nutzen Sie diese.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Bitte stellen Sie sicher, dass Sie für erforderliche Benachrichtigungen mindestens eine Benachrichtigungsmethode ausgewählt haben.',
        'Preferences updated successfully!' => 'Einstellungen erfolgreich aktualisiert!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(in Arbeit)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Bitte geben Sie ein Enddatum an, das nach dem Startdatum liegt.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Passwort verifizieren',
        'The current password is not correct. Please try again!' => 'Das eingegebene Passwort ist nicht korrekt. Bitte versuchen Sie es erneut!',
        'Please supply your new password!' => 'Bitte bestätigen Sie ihr neues Passwort!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Das Passwort ist aufgrund der aktuellen Systemkonfiguration nicht erlaubt. Bitte kontaktieren Sie den Administrator, wenn Sie weitere Fragen haben.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens %s Zeichen lang sein!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens 2 Groß- und 2 Kleinbuchstaben enthalten!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Das Passwort kann nicht aktualisiert werden. Es muss mindestens eine Ziffer enthalten!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens 2 Zeichen enthalten!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Zeitzone erfolgreich aktualisiert!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'ungültig',
        'valid' => 'gültig',
        'No (not supported)' => 'Nein (nicht unterstützt)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Kein relativer Zeitraum ausgewählt.',
        'The selected time period is larger than the allowed time period.' =>
            'Der ausgewählte Zeitraum ist größer als der erlaubte Zeitraum.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Keine Zeitskalierung für den aktuell ausgewählten Zeitskalierungswert der X-Achse verfügbar.',
        'The selected date is not valid.' => 'Das ausgewählte Datum ist ungültig.',
        'The selected end time is before the start time.' => 'Die ausgewählte Endzeit ist vor der Startzeit.',
        'There is something wrong with your time selection.' => 'Bitte überprüfen Sie Ihre Zeitauswahl.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Bitte wählen Sie nur ein Element oder erlauben Sie die Bearbeitung zur Erstellzeit der Statistik.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Bitte wählen Sie nur ein Element oder erlauben Sie die Bearbeitung zur Erstellzeit der Statistik.',
        'Please select one element for the X-axis.' => 'Bitte wählen Sie ein Element für die X-Achse aus.',
        'You can only use one time element for the Y axis.' => 'Sie können nur ein Zeitelement für die Y-Achse verwenden.',
        'You can only use one or two elements for the Y axis.' => 'Sie können nur ein oder zwei Elemente für die Y-Achse verwenden.',
        'Please select at least one value of this field.' => 'Bitte wählen Sie mindestens einen Wert in diesem Feld aus.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Bitte geben Sie einen Wert an oder erlauben Sie die Bearbeitung zur Erstellzeit der Statistik.',
        'Please select a time scale.' => 'Bitte wählen Sie eine Zeitskala aus.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Der ausgewählte Zeitraum ist zu klein, bitte nutzen Sie einen größeren Zeitmaßstab.',
        'second(s)' => 'Sekunde(n)',
        'quarter(s)' => 'Quartal(e)',
        'half-year(s)' => 'Halbjahr(e)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Bitte entfernen Sie die folgenden Worte, da sie nicht für die Ticket-Einschränkung verwendet werden können: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Bearbeitung abbrechen und diese Einstellung freigeben',
        'Reset this setting to its default value.' => 'Einstellung auf Standardwert zurücksetzen.',
        'Unable to load %s!' => 'Kann %s nicht laden!',
        'Content' => 'Inhalt',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Zur Rückgabe an die Queue entsperren',
        'Lock it to work on it' => 'Zur Bearbeitung sperren',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Nicht beobachten',
        'Remove from list of watched tickets' => 'Von der Liste der beobachteten Tickets entfernen',
        'Watch' => 'Beobachten',
        'Add to list of watched tickets' => 'Zur Liste der beobachteten Tickets hinzufügen',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sortieren nach',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Neue gesperrte Tickets',
        'Locked Tickets Reminder Reached' => 'Gesperrte Tickets, Erinnerungszeit erreicht',
        'Locked Tickets Total' => 'Gesperrte Tickets insgesamt',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Neue verantwortliche Tickets',
        'Responsible Tickets Reminder Reached' => 'Verantwortliche Tickets, Erinnerungszeit erreicht',
        'Responsible Tickets Total' => 'Verantwortliche Tickets insgesamt',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Neue beobachtete Tickets',
        'Watched Tickets Reminder Reached' => 'Beobachtete Tickets, Erinnerungszeit erreicht',
        'Watched Tickets Total' => 'Beobachtete Tickets insgesamt',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Dynamische Felder für Tickets',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Die ACL-Konfigurationsdatei konnte nicht gelesen werden. Bitte prüfen Sie, dass es sich um eine gültige Datei handelt.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Die Anmeldung ist derzeit aufgrund einer geplanten Systemwartung nicht verfügbar.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sitzung ungültig. Bitte neu anmelden.',
        'Session has timed out. Please log in again.' => 'Sitzung abgelaufen. Bitte neu anmelden.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Nur PGP-Signierung',
        'PGP encrypt only' => 'Nur PGP-Verschlüsselung',
        'SMIME sign only' => 'Nur S/MIME-Signierung',
        'SMIME encrypt only' => 'Nur S/MIME-Verschlüsselung',
        'PGP and SMIME not enabled.' => 'PGP und S/MIME sind nicht aktiviert.',
        'Skip notification delivery' => 'Zustellung der Benachrichtigung überspringen',
        'Send unsigned notification' => 'Unsignierte Benachrichtigung senden',
        'Send unencrypted notification' => 'Unverschlüsselte Benachrichtigung senden',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referenz der Konfigurationsoptionen',
        'This setting can not be changed.' => 'Diese Einstellung kann nicht geändert werden.',
        'This setting is not active by default.' => 'Diese Einstellung ist standardmäßig nicht aktiv.',
        'This setting can not be deactivated.' => 'Diese Einstellung kann nicht deaktiviert werden.',
        'This setting is not visible.' => 'Diese Einstellung ist nicht sichtbar.',
        'This setting can be overridden in the user preferences.' => 'Diese Einstellung kann in den Benutzereinstellungen überschrieben werden.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Diese Einstellung kann in den Benutzereinstellungen überschrieben werden, ist aber standardmäßig nicht aktiv.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Kundenbenutzer "%s" existiert bereits.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Diese E-Mail-Adresse wird bereits für einen anderen Kundenbenutzer verwendet.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'vor/nach',
        'between' => 'zwischen',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'z.B. Text oder Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Dieses Feld ignorieren.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Dieses Feld ist ein Pflichtfeld oder',
        'The field content is too long!' => 'Der Feldinhalt ist zu lang!',
        'Maximum size is %s characters.' => 'Die Maximallänge beträgt %s Zeichen.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Die Benachrichtigungs-Konfigurationsdatei konnte nicht gelesen werden. Bitte prüfen Sie, dass es sich um eine gültige Datei handelt.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Importierte Benachrichtigung hat einen Text mit mehr als 4000 Zeichen.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'nicht installiert',
        'installed' => 'installiert',
        'Unable to parse repository index document.' => 'Das Indexdokument des Verzeichnisses kann nicht gelesen werden.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Keine Pakete für Ihre Framework-Version in diesem Verzeichnis gefunden, es enthält nur Pakete für andere Framework-Versionen.',
        'File is not installed!' => 'Datei ist nicht installiert!',
        'File is different!' => 'Datei unterschiedlich!',
        'Can\'t read file!' => 'Datei kann nicht gelesen werden!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '<p>Falls Sie dieses Paket installieren, können folgende Probleme auftreten:</p><ul><li>Sicherheitsprobleme</li><li>Stabilitätsprobleme</li><li>Leistungsprobleme</li></ul><p>Bitte beachten Sie, dass von diesem Paket verursachte Probleme nicht durch OTOBO-Serviceverträge abgedeckt sind.</p>',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>Die Installation von Paketen, die nicht von der OTRS Gruppe verifiziert worden sind, ist standardmäßig nicht möglich. Sie können die Installation nicht-verfizierter Pakete über die Systemkonfiguration "AllowNotVerifiedPackages" aktivieren.</p>',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'Der Prozess "%s" und alle zugehörigen Daten wurden erfolgreich importiert.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inaktiv',
        'FadeAway' => 'Ausblendend',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Registrierungs-Server konnte nicht erreicht werden. Bitte versuchen Sie es später noch einmal.',
        'No content received from registration server. Please try again later.' =>
            'Registrierungs-Server lieferte keinen Inhalt. Bitte versuchen Sie es später noch einmal.',
        'Can\'t get Token from sever' => 'Kann Token nicht vom Server ermitteln',
        'Username and password do not match. Please try again.' => 'Benutzername und Passwort stimmen nicht überein. Bitte versuchen Sie es noch einmal.',
        'Problems processing server result. Please try again later.' => 'Beim Verarbeiten der Server-Antwort ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Summe',
        'week' => 'Woche',
        'quarter' => 'Quartal',
        'half-year' => 'Halbjahr',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Statustyp',
        'Created Priority' => 'Erstellt mit der Priorität',
        'Created State' => 'Erstellt mit dem Status',
        'Create Time' => 'Erstellzeit',
        'Pending until time' => 'Wartezeit',
        'Close Time' => 'Schließzeit',
        'Escalation' => 'Eskalation',
        'Escalation - First Response Time' => 'Eskalation - Zeit für die erste Reaktion',
        'Escalation - Update Time' => 'Eskalation - Aktualisierungszeit',
        'Escalation - Solution Time' => 'Eskalation - Lösungszeit',
        'Agent/Owner' => 'Agent/Besitzer',
        'Created by Agent/Owner' => 'Erstellt von Agent/Besitzer',
        'Assigned to Customer User Login' => 'Zugewiesen zum Kundenbenutzer-Login',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Auswertung nach',
        'Ticket/Article Accounted Time' => 'Ticket/Artikel - Gebuchte Zeit',
        'Ticket Create Time' => 'Ticket-Erstellzeit',
        'Ticket Close Time' => 'Ticket-Schließzeit',
        'Accounted time by Agent' => 'Zeit zugewiesen von Agent',
        'Total Time' => 'Gesamtzeit',
        'Ticket Average' => 'Durchschnittszeit pro Ticket',
        'Ticket Min Time' => 'Ticket-Minimalzeit',
        'Ticket Max Time' => 'Ticket-Maximalzeit',
        'Number of Tickets' => 'Anzahl der Tickets',
        'Article Average' => 'Durchschnittszeit pro Artikel',
        'Article Min Time' => 'Artikel-Minimalzeit',
        'Article Max Time' => 'Artikel Maximalzeit',
        'Number of Articles' => 'Anzahl der Artikel',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'unbeschränkt',
        'Attributes to be printed' => 'Auszugebene Attribute',
        'Sort sequence' => 'Sortierreihenfolge',
        'State Historic' => 'Statuschronik',
        'State Type Historic' => 'Statustypen-Historie',
        'Historic Time Range' => 'Historischer Zeitbereich',
        'Number' => 'Nummer',
        'Last Changed' => 'Zuletzt geändert',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Durchschnittliche Lösungszeit',
        'Solution Min Time' => 'Minimale Lösungszeit',
        'Solution Max Time' => 'Maximale Lösungszeit',
        'Solution Average (affected by escalation configuration)' => 'Durchschnitts-Lösungszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'Solution Min Time (affected by escalation configuration)' => 'Minimale Lösungszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'Solution Max Time (affected by escalation configuration)' => 'Maximale Lösungszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Durchschnittliche Lösungs-Arbeitszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Minimale Lösungs-Arbeitszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Maximale Lösungs-Arbeitszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Average (affected by escalation configuration)' =>
            'Erstreaktions-Durchschnittszeit (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Minimale Zeit für Erstreaktion (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Maximale Zeit für Erstreaktion (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Durchschnittliche Arbeitszeit für Erstreaktion (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Minimale Arbeitszeit für Erstreaktion (wird durch Eskalationskonfiguration beeinflusst)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Maximale Arbeitszeit für Erstreaktion (wird durch Eskalationskonfiguration beeinflusst)',
        'Number of Tickets (affected by escalation configuration)' => 'Ticket-Anzahl (wird durch Eskalationskonfiguration beeinflusst)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Tage',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Veraltete Tabellen',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'In der Datenbank wurden veraltete Tabellen gefunden. Diese können, falls leer, gelöscht werden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Prüfung Tabellenexistenz',
        'Internal Error: Could not open file.' => 'Interner Fehler: Konnte datei nicht öffnen.',
        'Table Check' => 'Prüfung Tabellenstatus',
        'Internal Error: Could not read file.' => 'Interner Fehler: Konnte Datei nicht lesen.',
        'Tables found which are not present in the database.' => 'In der Datenbank fehlen Tabellen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Datenbank-Größe',
        'Could not determine database size.' => 'Konnte Datenbank-Größe nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Datenbank-Version',
        'Could not determine database version.' => 'Konnte Datenbank-Version nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Zeichensatz der Client-Verbindung',
        'Setting character_set_client needs to be utf8.' => 'Einstellung character_set_client muss \'utf8\' sein.',
        'Server Database Charset' => 'Zeichensatz des Datenbank-Servers',
        'The setting character_set_database needs to be \'utf8\'.' => 'Die Einstellung character_set_database muss \'utf8\' sein.',
        'Table Charset' => 'Zeichensatz der Tabellen',
        'There were tables found which do not have \'utf8\' as charset.' =>
            'Es wurden Tabellen gefunden, die nicht \'utf8\' als Zeichensatz haben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Größe der InnoDB-Log-Datei',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Die Einstellung innodb_log_file_size muss mindestens 256 MB betragen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Ungültige Standardwerte',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Tabellen mit ungültigen Standardwerten wurden gefunden. Um diese automatisch zu reparieren, bitte folgendes Kommando ausführen: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximale Anfragegröße',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'Die Einstellung \'max_allowed_packet\' muss größer als 64 MB sein.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Größe Abfrage-Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Die Einstellung query_cache_size sollte genutzt werden (mehr als 10 MB aber nicht mehr als 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Standard-Storage-Engine',
        'Table Storage Engine' => 'Tabellen Speicher-Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Es wurden Tabellen gefunden, die nicht die Standard-Engine nutzen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x oder höher wird benötigt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Einstellung NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG muss auf al32utf8 festgelegt sein (z.B. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Einstellung NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT muss auf \'YYYY-MM-DD HH24:MI:SS\' gesetzt sein.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL-Prüfung NLS_DATE_FORMAT',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Primärschlüssel-Sequenzen und Auslöser',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'Die folgenden Sequenzen und/oder Auslöser mit potentiell falschen Namen wurden gefunden. Bitte passen Sie die Namen manuell an.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Einstellung client_encoding muss UNICODE oder UTF8 sein.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Einstellung server_encoding muss UNICODE oder UTF8 sein.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datumsformat',
        'Setting DateStyle needs to be ISO.' => 'Einstellung DateStyle muss ISO sein.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Primärschlüssel-Sequenzen',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'Es wurden die folgenden Sequenzen mit möglicherweise falschen Namen gefunden. Bitte ändern Sie die Namen manuell.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 oder höher wird benötigt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO-Festplattenpartition',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Festplatten-Verwendung',
        'The partition where OTOBO is located is almost full.' => 'Die Partition, auf der OTOBO sich befindet, ist fast voll.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Die Partition, auf der OTOBO sich befindet, hat keine Platzprobleme.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Belegung der Festplatten-Partitionen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Konnte Distribution nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel-Version',
        'Could not determine kernel version.' => 'Konnte Kernelversion nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Systemlast (load)',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Die Systemlast sollte die Zahl der Systemprozessoren nicht übersteigen (bspw. wäre eine Last von 8 oder weniger auf einem 8-Core-System in Ordnung).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perlmodule',
        'Not all required Perl modules are correctly installed.' => 'Es sind nicht alle benötigten Perl-Module installiert.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Perl Module Audit',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit hat berichtet, dass ein oder mehrere installierte Perl-Module bekannte Schwachstellen aufweisen. Bitte beachten Sie, dass es möglicherweise falsche Positivmeldungen für Distributionen gibt, die Perl-Module patchen, ohne ihre Versionsnummer zu ändern.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::Audit hat keine bekannten Schwachstellen in den installierten Perl-Modulen gemeldet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Freier Auslagerungsspeicher (%)',
        'No swap enabled.' => 'Kein Auslagerungsspeicher aktiviert.',
        'Used Swap Space (MB)' => 'Verwendeter Auslagerungsspeicher (MB)',
        'There should be more than 60% free swap space.' => 'Es sollten mehr als 60% Auslagerungsspeicher verfügbar sein.',
        'There should be no more than 200 MB swap space used.' => 'Es sollten nicht mehr als 200 MB Auslagerungsspeicher verwendet werden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Ticket-Suchindex-Status',
        'Indexed Articles' => 'Indexierte Artikel',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Artikel pro Kommunikationskanal',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Eingehende Kommunikation',
        'Outgoing communications' => 'Ausgehende Kommunikation',
        'Failed communications' => 'Fehlgeschlagene Kommunikation',
        'Average processing time of communications (s)' => 'Durchschnittliche Verarbeitungszeit für Kommunikation (s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Kontostatus des Kommunikationsprotokoll (vergangene 24 Stunden)',
        'No connections found.' => 'Keine Verbindungen gefunden.',
        'ok' => 'OK',
        'permanent connection errors' => 'Dauerhafte Verbindungsfehler',
        'intermittent connection errors' => 'Unregelmäßige Verbindungsfehler',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Konfigurationseinstellungen',
        'Could not determine value.' => 'Konnte Wert nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => 'Daemon läuft.',
        'Daemon is not running.' => 'Daemon läuft nicht.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Datenbankeinträge',
        'Ticket History Entries' => 'Ticket-Historieneinträge',
        'Articles' => 'Artikel',
        'Attachments (DB, Without HTML)' => 'Anhänge (in der Datenbank, ohne HTML)',
        'Customers With At Least One Ticket' => 'Kunden mit wenigstens einem Ticket',
        'Dynamic Field Values' => 'Werte in Dynamischen Feldern',
        'Invalid Dynamic Fields' => 'Ungültige Dynamische Felder',
        'Invalid Dynamic Field Values' => 'Werte in ungültigen Dynamischen Feldern',
        'GenericInterface Webservices' => 'GenericInterface-Web-Services',
        'Process Tickets' => 'Prozess-Tickets',
        'Months Between First And Last Ticket' => 'Monate zwischen erstem und letztem Ticket',
        'Tickets Per Month (avg)' => 'Tickets pro Monat (Durchschnitt)',
        'Open Tickets' => 'Offene Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Standard-Benutzername und -Passwort für SOAP',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Sicherheitsrisiko: Sie verwenden den Standard-SOAP-Benutzernamen und das Standardpasswort. Bitte ändern Sie diese Einstellungen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Standard-Admin-Passwort',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Sicherheitsrisiko: Das Agentenpasswort für root@localhost ist das Standardpasswort. Bitte ändern Sie es oder deaktivieren Sie diesen Nutzer.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Queue für E-Mail-Versand',
        'Emails queued for sending' => 'E-Mails, die zum Senden eingereiht sind',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (Domainname)',
        'Please configure your FQDN setting.' => 'Bitte konfigurieren Sie ihre FQDN-Einstellungen.',
        'Domain Name' => 'Domainname',
        'Your FQDN setting is invalid.' => 'Ihre FQDN-Einstellung ist ungültig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Dateisystem-Schreibbarkeit',
        'The file system on your OTOBO partition is not writable.' => 'Das Dateisystem auf Ihrer OTOBO-Partition ist nicht schreibbar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Alte Konfigurations-Backups',
        'No legacy configuration backup files found.' => 'Keine alten Konfigurations-Backup-Dateien gefunden.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Alte Konfigurations-Backup-Dateien gefunden im Verzeichnis Kernel/Config/Backups, aber diese werden möglicherweise noch von Paketen benötigt.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Alte Konfigurations-Backup-Dateien werden nicht mehr für die installierten Pakete benötigt. Bitte entfernen Sie diese aus dem Verzeichnis Kernel/Config/Backups.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Paketinstallations-Status',
        'Some packages have locally modified files.' => 'Einige Pakete enthalten lokal angepasste Dateien.',
        'Some packages are not correctly installed.' => 'Es wurden Pakete gefunden, die nicht korrekt installiert sind.',
        'Package Verification Status' => 'Paketverifizierung-Status',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            'Einige Pakete wurden nicht von der OTRS Gruppe verifiziert! Es wird empfohlen, diese Pakete nicht zu nutzen.',
        'Package Framework Version Status' => 'Status der Paket-Framework-Version',
        'Some packages are not allowed for the current framework version.' =>
            'Einige Pakete sind für die aktuelle Framework-Version nicht geeignet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Paketliste',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Sitzungskonfigurations-Einstellungen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'Zum Senden anstehende E-Mails',
        'There are emails in var/spool that OTOBO could not process.' => 'In var/spool befinden sich Emails, die OTOBO nicht verarbeiten konnte.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Ihre SystemID-Einstellung ist ungültig, sie sollte nur Ziffern enthalten.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Standard Ticket-Typ',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'Der konfigurierte Standard Ticket-Typ fehlt oder ist ungültig. Bitte ändern Sie die Einstellung Ticket::Type::Default und wählen Sie einen gültigen Ticket-Typ.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Ticket-Indexmodul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Sie haben mehr als 60.000 Tickets und sollten das StaticDB-Backend verwenden. Bitte schauen Sie im Administratorhandbuch (Leistungsverbesserung) nach.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Ungültige Benutzer mit gesperrten Tickets',
        'There are invalid users with locked tickets.' => 'Es existierten ungültige Benutzer mit gesperrten Tickets.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Sie sollten nicht mehr als 8.000 offene Tickets im System haben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket-Suchindexmodul',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Der Indizierungsprozess erzwingt die Speicherung der originalen Artikelinhalte im Artikel-Suchindex, ohne dabei Filter und Stopp-Worte anzuwenden. Dadurch wird die Größe des Suchindex erhöht, was Volltextsuchen verlangsamen kann.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Verwaiste Einträge in der Tabelle ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Die Tabelle ticket_lock_index enthält verwaiste Einträge. Bitte führen Sie bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" aus, um den StaticDB-Index zu bereinigen.',
        'Orphaned Records In ticket_index Table' => 'Verwaiste Einträge in der Tabelle ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Die Tabelle ticket_index enthält verwaiste Einträge. Bitte führen Sie "Maint::Ticket::QueueIndexCleanup" aus, um sie zu entfernen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Zeiteinstellungen',
        'Server time zone' => 'Server-Zeitzone',
        'OTOBO time zone' => 'OTOBO-Zeitzone',
        'OTOBO time zone is not set.' => 'OTOBO-Zeitzone ist nicht gesetzt.',
        'User default time zone' => 'Benutzer-Standard-Zeitzone',
        'User default time zone is not set.' => 'Benutzer-Standard-Zeitzone ist nicht gesetzt.',
        'Calendar time zone is not set.' => 'Kalender-Zeitzone ist nicht gesetzt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - Nutzung Agenten-Skins',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - Nutzung Agenten-Themes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - Spezielle Statistiken',
        'Agents using custom main menu ordering' => 'Agenten mit eigener Hauptmenüsortierung',
        'Agents using favourites for the admin overview' => 'Agenten, die Favoriten für die Administrator-Übersicht nutzen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => 'Geladene Apache-Module',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM-Modell',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO benötigt das Apache \'prefork\' MPM Modul.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Verwendung CGI-Beschleuniger',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Sie sollten FastCGI oder mod_perl verwenden, um die Geschwindigkeit zu steigern.',
        'mod_deflate Usage' => 'Verwendung mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Bitte installieren Sie mod_deflate, um die Geschwindigkeit zu steigern.',
        'mod_filter Usage' => 'Verwendung mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Bitte installieren Sie mod_filter falls mod_deflate verwendet wird.',
        'mod_headers Usage' => 'Verwendung mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Bitte installieren Sie mod_headers, um die Geschwindigkeit zu steigern.',
        'Apache::Reload Usage' => 'Verwendung Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload oder Apache2::Reload sollten als PerlModule und PerlInitHandler verwendet werden, um Webserver-Neustarts nach Paketinstallation oder -upgrade zu vermeiden.',
        'Apache2::DBI Usage' => 'Verwendung Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Nutzen Sie Apache2::DBI, um eine höhere Leistung im Zusammenhang mit persistenten Datenbankverbindungen zu erreichen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Umgebungsvariablen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Supportdate-Sammlung',
        'Support data could not be collected from the web server.' => 'Supportdaten vom Web-Server konnten nicht ermittelt werden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver-Version',
        'Could not determine webserver version.' => 'Konnte Webserver-Version nicht ermitteln.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Details der gleichzeitigen Benutzer',
        'Concurrent Users' => 'Gleichzeitige Benutzer',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Einstellung %s existiert nicht!',
        'Setting %s is not locked to this user!' => 'Einstellung %s ist nicht in Bearbeitung durch diesen Benutzer!',
        'Setting value is not valid!' => 'Der Einstellungswert ist ungültig!',
        'Could not add modified setting!' => 'Konnte geänderte Einstellung nicht hinzufügen!',
        'Could not update modified setting!' => 'Konnte geänderte Einstellung nicht aktualisieren!',
        'Setting could not be unlocked!' => 'Einstellung konnte nicht freigegeben werden!',
        'Missing key %s!' => 'Fehlender Schlüssel %s!',
        'Invalid setting: %s' => 'Ungültige Einstellung: %s',
        'Could not combine settings values into a perl hash.' => 'Konnte Einstellungswerte nicht zu einem Perl-Hash kombinieren.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Das Deployment für UserID \'%s\' konnte nicht gesperrt werden!',
        'All Settings' => 'Alle Einstellungen',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Standard',
        'Value is not correct! Please, consider updating this field.' => 'Wert ist nicht korrekt! Bitte überprüfen Sie das Feld.',
        'Value doesn\'t satisfy regex (%s).' => 'Wert entspricht nicht dem regulären Ausdruck (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Aktiviert',
        'Disabled' => 'Deaktiviert',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'Das Datum des Benutzers konnte in der OTOBO-Zeitzone nicht berechnet werden!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'Das Datum und die Uhrzeit des Benutzers konnte in der OTOBO-Zeitzone nicht berechnet werden!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Wert ist nicht korrekt! Bitte überprüfen Sie das Modul.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Wert ist nicht korrekt! Bitte überprüfen Sie diese Einstellung.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Zurücksetzen des Freigabe-Zeitintervalls.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Chat-Teilnehmer',
        'Chat Message Text' => 'Chat-Nachrichtentext',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => 'Zu viele Fehlversuche, bitte probieren Sie es später wieder',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Anmeldung fehlgeschlagen! Benutzername oder Passwort wurden falsch eingegeben.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Authentifizierung erfolgreich, aber in der Datenbank wurde kein Eintrag für den Benutzer gefunden. Bitte kontaktieren Sie Ihren Administrator.',
        'Can`t remove SessionID.' => 'Kann SessionID nicht entfernen.',
        'Logout successful.' => 'Abmeldung erfolgreich.',
        'Feature not active!' => 'Funktion nicht aktiviert!',
        'Sent password reset instructions. Please check your email.' => 'Anweisungen zum Zurücksetzen des Passworts wurden gesendet. Bitte prüfen Sie ihre E-Mail.',
        'Invalid Token!' => 'Ungültiger Token!',
        'Sent new password to %s. Please check your email.' => 'Neues Passwort an %s gesendet. Bitte prüfen Sie Ihre E-Mail.',
        'Error: invalid session.' => 'Fehler: Ungültige Sitzung.',
        'No Permission to use this frontend module!' => 'Sie haben keine Berechtigung, dieses Modul zu nutzen!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Authentifizierung erfolgreich, aber im Kunden Backend wurde kein Kunden Eintrag gefunden. Bitte kontaktieren Sie Ihren Administrator.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Zurücksetzen des Passwort war nicht erfolgreich. Bitte kontaktieren Sie den Administrator.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Diese E-Mail-Adresse existiert bereits. Bitte melden Sie sich an oder setzen Ihr Passwort zurück.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Diese E-Mail-Adresse darf nicht registriert werden. Bitte wenden Sie sich an die Supportabteilung.',
        'Added via Customer Panel (%s)' => 'Mittels Kundenbereich hinzugefügt (%s)',
        'Customer user can\'t be added!' => 'Kundenbenutzer kann nicht angelegt werden!',
        'Can\'t send account info!' => 'Kann Zugangsinformation nicht senden!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Neues Konto angelegt. Anmeldedaten wurden an %s gesendet. Bitte prüfen Sie Ihre E-Mail.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Aktion "%s" nicht gefunden!',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'ungültig-temporär',
        'Group for default access.' => 'Gruppe für den Standardzugriff.',
        'Group of all administrators.' => 'Gruppe aller Administratoren.',
        'Group for statistics access.' => 'Gruppe für den Statistikzugriff.',
        'new' => 'neu',
        'All new state types (default: viewable).' => 'Alle neuen Statustypen (Standard: sichtbar).',
        'open' => 'offen',
        'All open state types (default: viewable).' => 'Alle offenen Statustypen (Standard: sichtbar).',
        'closed' => 'geschlossen',
        'All closed state types (default: not viewable).' => 'Alle geschlossenen Statustypen (Standard: nicht sichtbar).',
        'pending reminder' => 'warten zur Erinnerung',
        'All \'pending reminder\' state types (default: viewable).' => 'Alle \'warten auf\'-Statustypen (Standard: sichtbar).',
        'pending auto' => 'warten auf',
        'All \'pending auto *\' state types (default: viewable).' => 'Alle \'warten auf automatisch *\'-Statustypen (Standard: sichtbar).',
        'removed' => 'entfernt',
        'All \'removed\' state types (default: not viewable).' => 'Alle \'entfernt\'-Statustypen (Standard: nicht sichtbar).',
        'merged' => 'zusammengefasst',
        'State type for merged tickets (default: not viewable).' => 'Statustyp für zusammengefasste Tickets (Standard: nicht sichtbar).',
        'New ticket created by customer.' => 'Neues Ticket von Kunden erstellt.',
        'closed successful' => 'erfolgreich geschlossen',
        'Ticket is closed successful.' => 'Ticket erfolgreich geschlossen.',
        'closed unsuccessful' => 'erfolglos geschlossen',
        'Ticket is closed unsuccessful.' => 'Das Ticket ist erfolglos geschlossen.',
        'Open tickets.' => 'Offene Tickets.',
        'Customer removed ticket.' => 'Kunde hat Ticket entfernt.',
        'Ticket is pending for agent reminder.' => 'Das Ticket wartet auf Erinnerung für Agenten.',
        'pending auto close+' => 'warten auf erfolgreich schließen',
        'Ticket is pending for automatic close.' => 'Das Ticket wartet auf automatisches schließen.',
        'pending auto close-' => 'warten auf erfolglos schließen',
        'State for merged tickets.' => 'Status für zusammengefasste Tickets.',
        'system standard salutation (en)' => 'Systemstandardanrede (en)',
        'Standard Salutation.' => 'Standardanrede.',
        'system standard signature (en)' => 'Systemstandardsignatur (en)',
        'Standard Signature.' => 'Standard Signatur.',
        'Standard Address.' => 'Standard Adresse.',
        'possible' => 'möglich',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Rückfragen für geschlossene Tickets sind möglich. Tickets werden wieder geöffnet.',
        'reject' => 'ablehnen',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Rückfragen für geschlossene Tickets sind nicht möglich. Neue Tickets werden nicht erstellt.',
        'new ticket' => 'neues Ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Rückfragen für geschlossene Tickets sind nicht möglich. Ein neues Ticket wird erstellt.',
        'Postmaster queue.' => 'Postmaster-Queue.',
        'All default incoming tickets.' => 'Alle eingehenden Tickets.',
        'All junk tickets.' => 'Alle Junk-Tickets.',
        'All misc tickets.' => 'Alle Misc-Tickets.',
        'auto reply' => 'automatische Antwort',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Eine automatische Antwort wird versandt, nachdem ein neues Ticket erstellt wurde.',
        'auto reject' => 'automatische Ablehnung',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatische Ablehnung, die gesendet wird, nachdem eine Rückantwort abgelehnt wurde (falls die Queue-Einstellung für Rückantworten auf "Ablehnen" gesetzt ist).',
        'auto follow up' => 'automatische Rückfrage',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatische Bestätigung, die gesendet wird, nachdem eine Rückantwort für ein Ticket empfangen wurde (falls die Queue-Einstellung für Rückantworten auf "Möglich" gesetzt ist).',
        'auto reply/new ticket' => 'automatische Antwort / neues Ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatische Antwort, die gesendet wird, nachdem eine Rückantwort abgelehnt und ein neues Ticket erstellt wurde (falls die Queue-Einstellung für Rückantworten auf "Neues Ticket" gesetzt ist.',
        'auto remove' => 'automatisches Entfernen',
        'Auto remove will be sent out after a customer removed the request.' =>
            '"Automatisches Entfernen" wird versendet, nachdem der Kundenbenutzer die Anfrage entfernt hat.',
        'default reply (after new ticket has been created)' => 'Standardantwort (nachdem ein neues Ticket erstellt wurde)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'Standardablehnung (nachdem eine Antwort auf ein geschlossenes Ticket eingegangen und diese abgelehnt wurde)',
        'default follow-up (after a ticket follow-up has been added)' => 'Standardantwort (nachdem eine Antwort auf ein Ticket eingegangen ist)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'Standardablehnung/Neues Ticket erstellt (nachdem eine Antwort auf ein geschlossenes Ticket eingegangen ist und ein neues Ticket erstellt wurde)',
        'Unclassified' => 'Unklassifiziert',
        '1 very low' => '1 sehr niedrig',
        '2 low' => '2 niedrig',
        '3 normal' => '3 normal',
        '4 high' => '4 hoch',
        '5 very high' => '5 sehr hoch',
        'unlock' => 'frei',
        'lock' => 'gesperrt',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'Agent',
        'system' => 'System',
        'customer' => 'Kunde',
        'Ticket create notification' => 'Benachrichtigung über neues Ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Sie erhalten eine Benachrichtigung, wenn ein Ticket in Ihren unter "Meine Queues" oder "Meine Services" ausgewählten Queues oder Services erstellt wird.',
        'Ticket follow-up notification (unlocked)' => 'Benachrichtigung über Folgeaktionen (entsperrtes Ticket)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Sie erhalten eine Benachrichtigung, wenn ein Kunde eine Rückmeldung zu einem Ticket sendet, das in Ihren unter "Meine Queues" oder "Meine Services" ausgewählten Queues oder Services erstellt wurde.',
        'Ticket follow-up notification (locked)' => 'Benachrichtigung über Folgeaktionen (gesperrtes Ticket)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Sie erhalten eine Benachrichtigung, wenn ein Kunde eine Rückmeldung zu einem Ticket sendet, dessen Besitzer oder Verantwortlicher Sie sind.',
        'Ticket lock timeout notification' => 'Mitteilung bei Überschreiten der Ticket-Sperrzeit',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Sie erhalten eine Benachrichtigung, wenn ein Ticket, dessen Besitzer Sie sind, automatisch entsperrt wurde.',
        'Ticket owner update notification' => 'Benachrichtigung über Änderung des  Ticket-Besitzers',
        'Ticket responsible update notification' => 'Benachrichtigung über Änderung des  Ticket-Verantwortlichen',
        'Ticket new note notification' => 'Benachrichtigung über neue Notiz',
        'Ticket queue update notification' => 'Benachrichtigung über Änderung der Queue',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Sie erhalten eine Benachrichtigung, wenn ein Ticket in eine der Queues verschoben wurde, die Sie unter "Meine Queues" ausgewählt haben.',
        'Ticket pending reminder notification (locked)' => 'Benachrichtigung über Erreichen der Erinnerungszeit (gesperrtes Ticket)',
        'Ticket pending reminder notification (unlocked)' => 'Benachrichtigung über Erreichen der Erinnerungszeit (entsperrtes Ticket)',
        'Ticket escalation notification' => 'Benachrichtigung über erfolgte Ticket-Eskalation',
        'Ticket escalation warning notification' => 'Benachrichtigung über baldige Ticket Eskalation',
        'Ticket service update notification' => 'Benachrichtigung über Änderung des Services',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Sie erhalten eine Benachrichtigung, wenn für ein Ticket einer der Services ausgewählt wurde, die Sie unter "Meine Services" ausgewählt haben.',
        'Appointment reminder notification' => 'Benachrichtigung über Erreichen der Erinnerungszeit von Terminen',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Sie erhalten immer dann eine Benachrichtigung, wenn der Benachrichtigungszeitpunkt für einen Ihrer Termine erreicht wurde.',
        'Ticket email delivery failure notification' => 'Benachrichtigung über Fehler beim Versand von E-Mail-Tickets',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Fehler während AJAX-Kommunikation. Status: %s, Fehler: %s',
        'This window must be called from compose window.' => 'Dieses Fenster muss aus dem Fenster zum Verfassen von Tickets aufgerufen werden.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Alle hinzufügen',
        'An item with this name is already present.' => 'Ein Eintrag mit diesem Namen existiert bereits.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dieser Eintrag enthält Untereinträge. Wollen Sie den Eintrag und alle Untereinträge wirklich löschen?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Mehr',
        'Less' => 'Weniger',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'In die Zwischenablage legen mit Strg+C (Cmd+C)',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Diesen Anhang entfernen',
        'Deleting attachment...' => 'Anhang wird entfernt...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Es ist ein Fehler beim Entfernen des Anhangs aufgetreten. Bitte prüfen Sie die Protokolle für mehr Informationen.',
        'Attachment was deleted successfully.' => 'Anhang erfolgreich entfernt.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wollen Sie dieses Dynamische Feld wirklich löschen? Alle darin enthaltenen Daten werden GELÖSCHT!',
        'Delete field' => 'Feld löschen',
        'Deleting the field and its data. This may take a while...' => 'Lösche das Feld und die zugehörigen Daten. Dies kann etwas dauern...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Dieses dynamische Feld entfernen',
        'Remove selection' => 'Auswahl entfernen',
        'Do you really want to delete this generic agent job?' => 'Wollen Sie diesen GenericAgent-Job wirklich löschen?',
        'Delete this Event Trigger' => 'Diesen Event-Trigger löschen',
        'Duplicate event.' => 'Ereignis duplizieren.',
        'This event is already attached to the job, Please use a different one.' =>
            'Dieses Event ist dem Job bereits zugeordnet. Bitte wählen Sie ein anderes aus.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Während der Kommunikation ist ein Fehler aufgetreten.',
        'Request Details' => 'Anfragedetails',
        'Request Details for Communication ID' => 'Anfragedetails für Verbindungs-ID',
        'Show or hide the content.' => 'Inhalt anzeigen oder verbergen.',
        'Clear debug log' => 'Debug-Protokoll leeren',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Fehlerbehandlungs-Modul entfernen',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Es ist nicht möglich einen neuen Event-Trigger hinzuzufügen, da das Event noch nicht angelegt ist.',
        'Delete this Invoker' => 'Diesen Invoker löschen',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Die einzig existierende Bedingung kann nicht entfernt werden.',
        'Sorry, the only existing field can\'t be removed.' => 'Das einzig existierende Feld kann nicht entfernt werden.',
        'Delete conditions' => 'Bedingungen löschen',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Mapping für Schlüssel %s',
        'Mapping for Key' => 'Mapping für Schlüssel',
        'Delete this Key Mapping' => 'Schlüssel-Mapping löschen',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Diese Operation löschen',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Web-Service klonen',
        'Delete operation' => 'Operation löschen',
        'Delete invoker' => 'Invoker löschen',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'VORSICHT: Wenn Sie den Namen der \'admin\'-Gruppe ändern ohne zuvor die entsprechenden Anpassungen in der SysConfig getätigt haben, verlieren Sie den Zugang zum Adminbereich! In diesem Fall sollten Sie den Gruppennamen in der Datenbank zurücksetzen.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'E-Mail-Konto löschen',
        'Deleting the mail account and its data. This may take a while...' =>
            'E-Mail-Konto und Daten werden gelöscht. Dies kann einige Zeit dauern...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Möchten Sie diese Benachrichtigungssprache wirklich löschen?',
        'Do you really want to delete this notification?' => 'Möchten Sie diese Benachrichtigung wirklich löschen?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Möchten Sie diesen Schlüssel wirklich löschen?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Derzeit läuft ein Prozess zur Paketaktualisierung. Klicken Sie hier, um Statusinformationen zu erhalten.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'Eine Paketaktualisierung wurde kürzlich beendet. Klicken Sie hier, um die Ergebnisse zu betrachten.',
        'No response from get package upgrade result.' => 'Keine Antwort von get package upgrade result.',
        'Update all packages' => 'Alle Pakete aktualisieren',
        'Dismiss' => 'Verwerfen',
        'Update All Packages' => 'Alle Pakete aktualisieren',
        'No response from package upgrade all.' => 'Keine Antwort von upgrade all.',
        'Currently not possible' => 'Derzeit nicht möglich',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Dies ist derzeit nicht möglich, da eine Paketaktualisierung läuft.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Diese Option ist derzeit deaktiviert, weil der OTOBO Daemon nicht läuft.',
        'Are you sure you want to update all installed packages?' => 'Sind Sie sicher, dass Sie alle installierten Pakete aktualisieren möchten?',
        'No response from get package upgrade run status.' => 'Keine Antwort von package upgrade run status.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Diesen Postmaster-Filter löschen',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Lösche den Postmaster-Filter und die zugehörigen Daten. Dies kann etwas dauern...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Eintrag entfernen',
        'No TransitionActions assigned.' => 'Keine Übergangsaktionen zugewiesen.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Es sind noch keine Dialoge zugewiesen. Wählen Sie einfach einen Aktivitäts-Dialog in der linken Liste aus und ziehen Sie ihn in die rechte Liste.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Diese Aktivität kann nicht gelöscht werden, weil sie die Start-Aktivität ist.',
        'Remove the Transition from this Process' => 'Diesen Übergang aus dem Prozess entfernen',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Sobald sie die Schaltfäche oder den Link verwenden, verlassen Sie dieses Fenster, und der aktuelle Stand wird automatisch gespeichert. Möchten Sie fortfahren?',
        'Delete Entity' => 'Eintrag löschen',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Diese Aktivität wird bereits im Prozess verwendet. Sie können sie nicht erneut hinzufügen!',
        'Error during AJAX communication' => 'Fehler während AJAX-Kommunikation',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Auf der Zeichenfläche ist ein nicht verbundener Übergang vorhanden. Bitte verbinden Sie diesen Übergang zuerst, bevor Sie einen weiteren Übergang platzieren.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Dieser Übergang wird bereits für diese Aktiviät verwendet. Sie können ihn nicht erneut hinzufügen!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Diese Übergangsaktion wird bereits in diesem Pfad verwendet. Sie können sie nicht erneut hinzufügen!',
        'Hide EntityIDs' => 'EntityIDs ausblenden',
        'Edit Field Details' => 'Felddetails bearbeiten',
        'Customer interface does not support articles not visible for customers.' =>
            'Das Kunden-Interface unterstützt keine internen Artikeltypen.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Der einzig existierende Parameter kann nicht entfernt werden.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Möchten Sie dieses Zertifikat wirklich löschen?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Update wird gesendet...',
        'Support Data information was successfully sent.' => 'Support-Daten wurden erfolgreich gesendet.',
        'Was not possible to send Support Data information.' => 'Es war nicht möglich, die Support-Daten zu versenden.',
        'Update Result' => 'Update-Ergebnis',
        'Generating...' => 'Wird erstellt...',
        'It was not possible to generate the Support Bundle.' => 'Das Support-Paket konnte nicht erzeugt werden.',
        'Generate Result' => 'Ergebnis der Generierung',
        'Support Bundle' => 'Support-Paket',
        'The mail could not be sent' => 'Die E-Mail konnte nicht versendet werden',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Es ist nicht möglich, diesen Eintrag auf ungültig zu setzen, bevor alle betroffenen Konfiguration entsprechend angepasst wurden.',
        'Cannot proceed' => 'Kann nicht fortfahren',
        'Update manually' => 'Manuell aktualisieren',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Sie können die betroffenen Einstellungen automatisch entsprechend der vorgenommen Änderungen aktualisieren lassen oder die Änderungen durch Klicken von "manuell anpassen" selbst vornehmen.',
        'Save and update automatically' => 'Speichern und automatisch aktualisieren',
        'Don\'t save, update manually' => 'Nicht speichern, manuell aktualisieren',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'Der Eintrag, den Sie gerade betrachten, ist Teil einer Konfigurationseinstellung, die bislang nicht in Betrieb genommen wurde und deshalb derzeit nicht änderbar ist. Bitte warten Sie, bis die Einstellung in Betrieb genommen wurde. Wenn Sie unsicher sind, was als nächstes zu tun ist, kontaktieren Sie bitte Ihren Systemadministrator.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Laden...',
        'Search the System Configuration' => 'Systemkonfiguration durchsuchen',
        'Please enter at least one search word to find anything.' => 'Bitte geben Sie mindestens einen Suchbegriff ein.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Inbetriebnahme derzeit nicht möglich. Möglicherweise läuft bereits eine durch einen anderen Agenten angestoßene Inbetriebnahme. Bitte versuchen Sie es später noch einmal.',
        'Deploy' => 'In Betrieb nehmen',
        'The deployment is already running.' => 'Inbetriebnahme läuft bereits.',
        'Deployment successful. You\'re being redirected...' => 'Inbetriebnahme erfolgreich, sie werden weitergeleitet...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Es sind Fehler aufgetreten. Bitte speichern Sie alle Einstellungen, die Sie derzeit bearbeiten und prüfen Sie die Protokolle für mehr Informationen.',
        'Reset option is required!' => 'Reset-Option wird benötigt!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Bei Wiederherstellung dieser Version werden alle Einstellungen auf den Stand zurückgesetzt, den sie zum Zeitpunkt der jeweiligen Inbetriebnahme hatten. Möchten Sie fortfahren?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Schlüssel mit Werten können nicht umbenannt werden. Bitte entfernen Sie dieses Schlüssel/Wert-Paar und fügen Sie es anschließend erneut hinzu.',
        'Unlock setting.' => 'Einstellung entsperren.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Wollen Sie diese geplante Systemwartung wirklich löschen?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Diese Vorlage löschen',
        'Deleting the template and its data. This may take a while...' =>
            'Lösche das Template und die zugehörigen Daten. Dies kann etwas dauern...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Springen',
        'Timeline Month' => 'Zeitstrahl Monat',
        'Timeline Week' => 'Zeitstrahl Woche',
        'Timeline Day' => 'Zeitstrahl Tag',
        'Previous' => 'Zurück',
        'Resources' => 'Ressourcen',
        'Su' => 'So',
        'Mo' => 'Mo',
        'Tu' => 'Di',
        'We' => 'Mi',
        'Th' => 'Do',
        'Fr' => 'Fr',
        'Sa' => 'Sa',
        'This is a repeating appointment' => 'Dieser Termin wiederholt sich',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Möchten Sie nur diesen Termin oder alle Vorkommnisse bearbeiten?',
        'All occurrences' => 'Alle Vorkommnisse',
        'Just this occurrence' => 'Nur diesen Termin',
        'Too many active calendars' => 'Zuviele aktive Kalender',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Bitte deaktivieren Sie zuerst einige oder erhöhen Sie das Limit in der Konfiguration.',
        'Restore default settings' => 'Standard-Einstellungen wiederherstellen',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Möchten Sie diesen Termin wirklich löschen? Diese Änderung kann nicht rückgängig gemacht werden.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Wählen Sie zunächst einen Kundenbenutzer aus. Anschließend können Sie das Ticket einer Kundennummer zuweisen.',
        'Duplicated entry' => 'Doppelter Eintrag',
        'It is going to be deleted from the field, please try again.' => 'Er wird aus dem Feld entfernt, bitte versuchen Sie es erneut.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Bitte geben Sie zumindest einen Suchbegriff ein oder * um nach Allem zu suchen.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informationen über den OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Bitte prüfen Sie die rot markierten Felder auf gültige Eingaben.',
        'month' => 'Monat',
        'Remove active filters for this widget.' => 'Aktive Filter für dieses Widget entfernen.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Bitte warten...',
        'Searching for linkable objects. This may take a while...' => 'Suche nach verknüpfbaren Objekten. Dies kann etwas dauern...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Möchten Sie diese Verknüpfung wirklich löschen?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Nutzen Sie ein Browser-Plugin wie AdBlock oder AdBlockPlus? Dies kann Probleme bei der Nutzung der Software verursachen. Es wird daher empfohlen, eine Ausnahme für diese Domain hinzuzufügen.',
        'Do not show this warning again.' => 'Warnung nicht mehr anzeigen.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Entschuldigung, Sie können für eine erforderliche Benachrichtigungen nicht alle Benachrichtigungsmethoden abschalten.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Entschuldigung, Sie können für diese Benachrichtigung nicht alle Benachrichtigungsmethoden abschalten.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Bitte beachten Sie, dass mindestens eine geänderte Einstellung ein Neuladen benötigt. Klicken Sie hier, um den Bildschirm neu zu laden.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Ein unbekannter Fehler ist aufgetreten. Bitte kontaktieren Sie den Administrator.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Zur Desktop-Ansicht wechseln',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Bitte entfernen Sie die folgenden Wörter aus Ihrer Suche, da nach ihnen nicht gesucht werden kann:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Generieren',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Dieses Element besitzt Kindelemente und kann derzeit nicht entfernt werden.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Möchten Sie diese Statistik wirklich löschen?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Wählen Sie eine Kundennummer aus, die Sie diesem Ticket zuordnen möchten',
        'Do you really want to continue?' => 'Möchten Sie wirklich fortfahren?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...und %s weitere(s)',
        ' ...show less' => ' ...weniger zeigen',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Als Entwurf speichern',
        'Delete draft' => 'Entwurf löschen',
        'There are no more drafts available.' => 'Derzeit sind keine weiteren Entwürfe verfügbar.',
        'It was not possible to delete this draft.' => 'Es war nicht möglich, den Entwurf zu löschen.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Artikelfilter',
        'Apply' => 'Anwenden',
        'Event Type Filter' => 'Ereignistyp-Filter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Verschieben Sie die Navigationsleiste',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Bitte schalten Sie den Kompatibilitätsmodus im Internet Explorer aus!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Zur mobilen Ansicht wechseln',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Fehler: Webbrowser-Überprüfung fehlgeschlagen!',
        'Reload page' => 'Seite aktualisieren',
        'Reload page (%ss)' => 'Seite aktualisieren (%ss)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Der Namensraum %s konnte nicht initialisiert werden, weil %s nicht gefunden wurde.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'Ein Fehler ist aufgetreten! Bitte prüfen Sie das Protokoll Ihres Webbrowsers für mehr Details!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Ein oder mehrere Fehler sind aufgetreten!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Konfigurationsprüfung erfolgreich.',
        'Error in the mail settings. Please correct and try again.' => 'Fehler in der Mail-Konfiguration. Bitte korrigieren und nochmals probieren.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'Diesen Knoten in einem neuen Fenster öffnen',
        'Please add values for all keys before saving the setting.' => 'Bitte tragen Sie Werte für alle Schlüssel ein, bevor Sie die Einstellung speichern.',
        'The key must not be empty.' => 'Der Schlüssel darf nicht leer sein.',
        'A key with this name (\'%s\') already exists.' => 'Ein Schlüssel mit diesem Namen (\'%s\') existiert bereits.',
        'Do you really want to revert this setting to its historical value?' =>
            'Möchten Sie diese Einstellung wirklich auf ihren ursprünglichen Wert zurücksetzen?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Datumsauswahl öffnen',
        'Invalid date (need a future date)!' => 'Ungültiges Datum (Benötige Datum in der Zukunft)!',
        'Invalid date (need a past date)!' => 'Ungültiges Datum (Benötige Datum in der Vergangenheit)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Nicht verfügbar',
        'and %s more...' => 'und %s weitere...',
        'Show current selection' => 'Aktuelle Auswahl anzeigen',
        'Current selection' => 'Aktuelle Auwahl',
        'Clear all' => 'Alles löschen',
        'Filters' => 'Filter',
        'Clear search' => 'Suche löschen',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Wenn Sie diese Seite verlassen, werden auch alle geöffneten Dialoge geschlossen!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Auf diesem Bildschirm ist bereits ein Popup-Fenster geöffnet. Möchten Sie dieses schließen und dieses stattdessen öffnen?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Konnte Popup-Fenster nicht öffnen. Bitte deaktivieren Sie alle Popup-Blocker für diese Anwendung.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Aufsteigende Sortierung angewandt, ',
        'Descending sort applied, ' => 'Absteigende Sortierung angewandt, ',
        'No sort applied, ' => 'Keine Sortierung angewandt, ',
        'sorting is disabled' => 'Sortierung deaktiviert',
        'activate to apply an ascending sort' => 'Aktivieren, um eine aufsteigende Sortierung anzuwenden',
        'activate to apply a descending sort' => 'Aktivieren, um eine absteigende Sortierung anzuwenden',
        'activate to remove the sort' => 'Aktivieren, um die Sortierung zu entfernen',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Filter entfernen',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Derzeit sind keine Elemente für die Auswahl vorhanden.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Bitte wählen Sie nur eine Datei zum Hochladen aus.',
        'Sorry, you can only upload one file here.' => 'Sie können hier nur eine Datei hochladen.',
        'Sorry, you can only upload %s files.' => 'Sie können nur %s Datei(en) hochladen.',
        'Please only select at most %s files for upload.' => 'Bitte wählen Sie höchstens %s Datei(en) zum Hochladen aus.',
        'The following files are not allowed to be uploaded: %s' => 'Die folgenden Dateien dürfen nicht geändert werden: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Folgende Dateien überschreiten die Maximalgröße pro Datei (%s) und wurden nicht aktualisiert: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Folgende Dateien waren bereits hochgeladen und wurden nicht erneut verarbeitet: %s',
        'No space left for the following files: %s' => 'Kein Speicherplatz verfügbar für folgende Dateien: %s',
        'Available space %s of %s.' => 'Verfügbarer Platz %s von %s.',
        'Upload information' => 'Upload-Information',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Beim Löschen des Anhangs ist ein unbekannter Fehler aufgetreten. Bitte versuchen Sie es erneut. Wenn der Fehler weiterhin auftritt, kontaktieren Sie bitte Ihren Systemadministrator.',

        # JS File: Core.Language.UnitTest
        'yes' => 'ja',
        'no' => 'nein',
        'This is %s' => 'Dies ist %s',
        'Complex %s with %s arguments' => 'Komplex %s mit %s Argumenten',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'Keine Daten verfügbar.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Gruppiert',
        'Stacked' => 'Gestapelt',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Fließend',
        'Expanded' => 'Ausgedehnt',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
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
        'Show current selection',
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
