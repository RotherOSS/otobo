# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2010 Thomas Kaltenbrunner <tkaltenbrunner at opc.de>
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
    $Self->{Completeness}        = 0.999682892024734;

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
            'Hier können Sie über eine Konfigurationsdatei ACLs ins System importieren. Diese Datei muss das vom ACL-Editor verwendete .yml-Format haben.',
        'This field is required.' => 'Dieses Feld ist ein Pflichtfeld.',
        'Overwrite existing ACLs?' => 'Existierende ACLs überschreiben?',
        'Upload ACL configuration' => 'ACL-Konfiguration hochladen',
        'Import ACL configuration(s)' => 'ACL-Konfiguration(en) importieren',
        'Description' => 'Beschreibung',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Wenn Sie eine ACL erstellen möchten, können Sie diese aus einem anderen System importieren oder eine ganz neue erstellen.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Änderungen an den ACLs wirken sich erst aus, wenn Sie die Konfiguration in Betrieb nehmen. Dabei werden die Änderungen in der Konfiguration gespeichert.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Hinweis: Diese Tabelle stellt die Ausführungsreihenfolge der ACLs dar. Wenn Sie die Reihenfolge ändern möchten, ändern Sie bitte die Namen der jeweiligen ACLs.',
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
            'Stellt die Filterbedingungen dieser ACL ein. Verwenden Sie \'Properties\', um den Wert aus dem aktuellen Bildschirm zu prüfen oder \'PropertiesDatabase\' für den Wert des Tickets, wie es in der Datenbank gespeichert ist.',
        'Change settings' => 'Wertänderungen',
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
            'Neue ACL auf Basis der eingegebenen Daten erstellen. Nach Erstellen der ACL können Konfigurationsparameter im Bearbeitungsmodus eingefügt werden.',

        # Template: AdminAbout
        'About' => 'Impressum',
        'Toggle this widget' => 'Dieses Widget umschalten',
        'This language is not present or enabled on the system. This text could be deleted if it is not needed anymore.' =>
            'Diese Sprache ist nicht vorhanden oder auf dem System aktiviert. Dieser Text könnte gelöscht werden, sofern dieser nicht mehr benötigt wird.',
        'Remove Language' => 'Sprache entfernen',
        'Text' => 'Text',
        'Message body' => 'Nachrichteninhalt',
        'This field is required and must have less than 4000 characters.' =>
            'Dieses Feld wird benötigt und darf nicht mehr als 4000 Zeichen enthalten.',
        'Remove About Language' => 'Sprache für Impressum/About löschen',
        'Add new language' => 'Neue Sprache hinzufügen',
        'Save Changes' => 'Änderungen speichern',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Kalenderverwaltung',
        'Add Calendar' => 'Kalender hinzufügen',
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
        'Add new notification language' => 'Neue Sprache für Benachrichtigungen hinzufügen',
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
            'In manchen Fällen ist es empfehlenswert, diese Daten an das OTOBO Team zu senden, um bessere Unterstützung zu erhalten.',
        'Configuration' => 'Konfiguration',
        'Send support data' => 'Supportdaten senden',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            'Diese Einstellung aktiviert das Senden zusätzlicher Support-Informationen an das OTOBO-Team.',
        'Update' => 'Aktualisieren',
        'System Registration' => 'Systemregistrierung',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Um das Senden der Daten zu aktivieren, registrieren Sie bitte Ihr System beim OTOBO-Team oder aktualisieren Sie Ihre Systemregistrierung (aktivieren Sie die Option \'Supportdaten senden\'.)',
        'Register this System' => 'Registrieren Sie dieses System',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Die Systemregistrierung ist für Ihr System deaktiviert. Bitte überprüfen Sie die Konfiguration.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            'Die Systemregistrierung ist ein Service von Team OTOBO, der Ihnen viele Vorteile sichert!',
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

        # Template: AdminCustomerAccept
        'Privacy Policy Management' => 'Datenschutzhinweise verwalten',
        'Privacy Policy' => 'Datenschutz',
        'Remove PrivacyPolicy Language' => 'Sprache für Datenschutzhinweise entfernen',

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
        'Notice' => 'Hinweis',
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
            'DNS-Problem, bitte prüfen Sie Ihre Konfiguration und das Fehlerprotokoll.',
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
        'New Dynamic Fields' => 'Neue Dynamische Felder',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            'Möchten Sie die Vorteile weiterer dynamischer Felder nutzen? Sie haben vollen Zugriff auf folgende Feldtypen:',
        'Database' => 'Datenbank',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Nutzen Sie externe Datenbanken als konfigurierbare Datenquellen für dieses dynamische Feld.',
        'Web service' => 'Webservice',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Für dieses Feld können externe Webservices als Datenquelle konfiguriert werden.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Dieses Feature erlaubt es, (mehrere) Kontakte mit Daten zu Tickets hinzuzufügen.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Um ein neues Feld hinzuzufügen, wählen Sie den Typ des Feldes aus der Liste der verfügbaren Typen für das jeweilige Objekt aus. Die Objekt-Auswahl ist bindend und kann nicht nachträglich verändert werden.',
        'Dynamic Fields List' => 'Dynamische Felder - Liste',
        'Dynamic fields per page' => 'Dynamische Felder pro Seite',
        'Label' => 'Beschriftung',
        'Order' => 'Position',
        'Object' => 'Objekt',
        'Delete this field' => 'Dieses Feld löschen',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => 'Import / Export',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            'Hier können Sie eine Konfigurationsdatei hochladen, um dynamische Felder auf Ihr System zu importieren. Die Datei muss im .yml-Format vorliegen, wie es von dem dynamischen Feld Verwaltungsmodul exportiert wird.',
        'DynamicFields Import' => 'Dynamische Felder importieren',
        'DynamicFields Export' => 'Dynamische Felder exportieren',
        'Dynamic Fields Screens' => 'Dynamische Felder Oberflächen',
        'Here you can manage the dynamic fields in the respective screens.' =>
            'Hier können Sie die dynamischen Felder in den jeweiligen Oberflächen verwalten.',

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
        'Tooltip message:' => 'Tooltip-Text:',
        'This is the tooltip message shown inside the customer interface.' =>
            'Dieser Text wird als Tooltip im Kundenbereich eingeblendet.',
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
        'You can reference the field with its own field name. You can also refer to other fields, e.g. with \'DynamicField_OtherFieldName\'.' =>
            'Sie können den Feldnamen verwenden, um auf ein Feld zu verweisen, oder auch auf andere Felder referenzieren – z. B. mit \'DynamicField_OtherFieldName\'.',
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
        'Must be unique column from the table entered in Table/View.' => 'Muss eine eindeutige Spalte der in Tabelle/Ansicht eingetragenen Tabelle sein.',
        'Multiselect' => 'Mehrfachauswahl',
        'CacheTTL' => 'CacheTTL',
        'Searchprefix' => 'Suchpräfix',
        'Searchsuffix' => 'Suchsuffix',
        'Result Limit' => 'Anzahl angezeigter Ergebnisse',
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

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '%s - %s',
        'Select the items you want to ' => 'Wählen Sie die Elemente aus, um sie zu ',
        'Select the desired elements and confirm the import with \'import\'.' =>
            'Selektieren Sie die gewünschten Elemente und bestätigen Sie den Import mit \'importieren\'.',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            'Hier können Sie eine Konfigurationsdatei von dynamischen Feldern und dynamischen Felder Oberflächen exportieren, um diese auf einem anderen System zu importieren. Die Konfigurationsdatei wird im yml Format exportiert.',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            'Die folgenden dynamischen Felder können aufgrund eines ungültigen Backends nicht importiert werden.',
        'Toggle all available elements' => 'Alle verfügbare Elemente umschalten',
        'Fields' => 'Felder',
        'Screens' => 'Oberflächen',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => 'Verwaltung von Dynamische Feldern <-> Oberflächen',
        'Overview' => 'Übersicht',
        'Default Columns Screens' => 'DefaultColumns Oberflächen',
        'Add DynamicField' => 'Dynamisches Feld hinzufügen',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            'Sie können diese Elemente den Oberflächen/Feldern zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Die Elemente können auch durch Verschieben mit der Maus geordnet werden.',
        'Filter available elements' => 'Verfügbare Elemente filtern',
        'selected to available elements' => 'Selektierte zu verfügbare Elemente',
        'Available Elements' => 'Verfügbare Elemente',
        'Filter disabled elements' => 'Deaktivierte Elemente filtern',
        'selected to disabled elements' => 'Selektierte zu deaktivierte Elemente',
        'Toggle all disabled elements' => 'Alle deaktivierte Elemente umschalten',
        'Disabled Elements' => 'Deaktivierte Elemente',
        'Filter assigned elements' => 'Zugewiesene Elemente filtern',
        'selected to assigned elements' => 'Selektierte zu zugewiesene Elemente',
        'Toggle all assigned elements' => 'Alle zugewiesene Elemente umschalten',
        'Assigned Elements' => 'Zugewiesene Elemente',
        'Filter assigned required elements' => 'Zugewiesene Pflichtelemente filtern',
        'selected to assigned required elements' => 'Selektierte zu zugewiesene Pflichtelemente',
        'Toggle all assigned required elements' => 'Alle zugewiesene Pflichtelemente umschalten',
        'Assigned Required Elements' => 'Zugewiesene Pflichtelemente',
        'Reset' => 'Zurücksetzen',

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
        'underline' => 'unterstrichen',
        'Font style of the label.' => 'Fontstil der Beschriftung.',
        'Size' => 'Größe',
        'Font size of the label.' => 'Fontgröße der Beschriftung.',
        'Color in hex.' => 'Farbe als HEX-Wert.',

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
            'Mit diesem Modul können Administratoren Nachrichten an Agenten, Gruppen- oder Rollenmitglieder senden.',
        'Create Administrative Message' => 'Administrator-Nachricht erstellen',
        'Your message was sent to' => 'Ihre Nachricht wurde gesendet an',
        'From' => 'Von',
        'Send message to users' => 'Nachricht an Benutzer senden',
        'Send message to group members' => 'Nachricht an Gruppenmitglieder senden',
        'Group members need to have permission' => 'Gruppenmitglieder brauchen eine Berechtigung',
        'Send message to role members' => 'Nachricht an Rollenmitglieder senden',
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
            'Wird ein Ticket-Ereignis ausgelöst, prüft zunächst der Ticket-Filter, ob das jeweilige Ticket betroffen ist. Erst dann wird der Auftrag ggf. für dieses Ticket ausgeführt.',
        'Do you really want to delete this event trigger?' => 'Wollen Sie diesen Ereignis-Auslöser wirklich löschen?',
        'Add Event Trigger' => 'Ereignis-Auslöser hinzufügen',
        'To add a new event select the event object and event name' => 'Wählen Sie Ereignisobjekt und -Name, um ein neues Ereignis hinzuzufügen',
        'Select Tickets' => 'Tickets selektieren',
        '(e. g. 10*5155 or 105658*)' => '(z .B. 10*5155 oder 105658*)',
        '(e. g. 234321)' => '(z. B. 234321)',
        'Customer user ID' => 'Kundenbenutzer Benutzername',
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
        'Last close times' => 'Letzte Schließzeiten',
        'No last close time settings.' => 'Keine Einstellungen für letzte Schließzeit.',
        'Ticket last close' => 'Ticket zuletzt geschlossen',
        'Ticket last close between' => 'Ticket zuletzt geschlossen zwischen',
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
        'GenericInterface Web Service Management' => 'GenericInterface - Webservice-Verwaltung',
        'Web Service Management' => 'Webservice-Verwaltung',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Zurück zum Webservice',
        'Clear' => 'Leeren',
        'Do you really want to clear the debug log of this web service?' =>
            'Möchten Sie wirklich das Debug-Protokoll dieses Webservices löschen?',
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
            'Der Name kann verwendet werden, um unterschiedliche Konfigurationen zur Fehlerbehandlung voneinander zu unterscheiden.',
        'Please provide a unique name for this web service.' => 'Bitte geben Sie einen eindeutigen Namen für diesen Webservice an.',
        'Error handling module backend' => 'Fehlerbehandlungs-Backend',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Das OTOBO Fehlerbehandlungs-Backend wird intern aufgerufen, um die Fehlerbehandlung auszuführen.',
        'Processing options' => 'Verarbeitungsoptionen',
        'Configure filters to control error handling module execution.' =>
            'Konfigurieren Sie Filter, um die Ausführung des Fehlerbehandlungs-Moduls zu steuern.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Ausschließlich Anfragen welche allen konfigurierten Filtern entsprechen (sofern vorhanden) bewirken die Ausführung des Moduls.',
        'Operation filter' => 'Operation-Filter',
        'Only execute error handling module for selected operations.' => 'Ausführung des Fehlerbehandlungs-Moduls nur für die ausgewählten Operationen.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Hinweis: Für Fehler, welche beim Empfangen der eingehenden Anfragedaten auftreten, ist die Operation unbestimmt. Filter für diese Verarbeitungsphase sollten keinen Operation-Filter nutzen.',
        'Invoker filter' => 'Invoker-Filter',
        'Only execute error handling module for selected invokers.' => 'Ausführung des Fehlerbehandlungs-Moduls nur für die ausgewählten Invoker.',
        'Error message content filter' => 'Filter für Inhalte von Fehlermeldungen',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Geben Sie einen regulären Ausdruck an, um die Fehlermeldungen einzuschränken, welche zur Ausführung des Fehlerbehandlungs-Moduls führen.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Titel und Inhalt der Fehlermeldung (wie im entsprechenden Debugger-Fehler-Eintrag ersichtlich) werden auf Übereinstimmungen geprüft.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Beispiel: Geben Sie \'^.*401 Unauthorized.*\$\'  ein, um ausschließlich authentifizierungsrelevante Fehlermeldungen zu handhaben.',
        'Error stage filter' => 'Filter für Fehler-Verarbeitungsphasen',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Ausführen des Fehlerbehandlungs-Moduls nur für die ausgewählten Verarbeitungsphasen.',
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
            'Standardmäßig versenden GenericInterface Webservices jede Anfrage nur genau einmal und planen diese nach dem Auftreten von Fehlern nicht erneut ein.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Sofern für eine Anfrage mehr als ein Modul ausgeführt wird, welches die Planung von Wiederholungen ermöglicht, ist das zuletzt ausgeführte Modul maßgeblich für die Entscheidung ob eine Wiederholung eingeplant wird.',
        'Request retry options' => 'Optionen zur Wiederholung von Anfragen',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Wiederholungsoptionen werden angewendet, wenn Anfragen zur Ausführung des Fehlerbehandlungs-Moduls führen (basiert auf Verarbeitungsoptionen).',
        'Schedule retry' => 'Wiederholung planen',
        'Should requests causing an error be triggered again at a later time?' =>
            'Sollen fehlerhafte Anfragen zu einem späteren Zeitpunkt erneut ausgeführt werden?',
        'Initial retry interval' => 'Initialer Abstand für Wiederholungen',
        'Interval after which to trigger the first retry.' => 'Intervall für die Planung der ersten Wiederholung.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Hinweis: Das Intervall für diese sowie alle weiteren Wiederholungen wird auf Basis der Ausführungszeit des Fehlerbehandlungs-Moduls für die initiale Anfrage berechnet.',
        'Factor for further retries' => 'Faktor für weitere Wiederholungen',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Geben Sie an, ob weitere Wiederholungen mit demselben Intervall oder in wachsenden Abständen geplant werden sollen, sofern eine Anfrage bei der ersten Wiederholung noch fehlerhaft ist.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Beispiel: Wenn eine Anfrage initial um 10:00 Uhr mit dem initialen Abstand \'1 Minute\' und dem Wiederholungsfaktor \'2\' ausgeführt wird, würden Wiederholungen um 10:01 Uhr (1 Minute), 10:03 Uhr (2*1=2 Minuten), 10:07 Uhr (2*2=4 Minuten), 10:15 Uhr (2*4=8 Minuten), ... ausgeführt.',
        'Maximum retry interval' => 'Maximaler Abstand für Wiederholungen',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Falls ein Wiederholungsfaktor von \'1.5\' oder \'2\' ausgewählt wurde, können unerwünscht lange Abstände verhindert werden, indem ein größtmögliches Intervall angegeben wird.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Berechnete Intervalle, die den festgelegten maximalen Abstand überschreiten würden, werden automatisch entsprechend gekürzt.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Beispiel: Wenn eine Anfrage initial um 10:00 Uhr mit dem initialen Abstand \'1 Minute\', dem Wiederholungsfaktor \'2\' und dem maximalen Intervall von \'5 Minuten\' ausgeführt wird, würden Wiederholungen um 10:01 Uhr (1 Minute), 10:03 Uhr (2 Minuten), 10:07 Uhr (4 Minuten), 10:12 Uhr (8=>5 Minuten), 10:17 Uhr, ... ausgeführt.',
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
            'Maximaler Zeitraum für die Wiederholung fehlschlagener Anfragen bevor diese verworfen werden (basierend auf der Ausführungszeit des Fehlerbehandlungs-Moduls für die initiale Anfrage).',
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
            'Der Name wird typischerweise genutzt, um eine Operation eines entfernten Webservice aufzurufen.',
        'Invoker backend' => 'Invoker-Backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Dieses Invoker-Backend-Modul wird aufgerufen, um die Daten zum Versand an das entfernte System sowie die zurückgelieferten Daten aufzubereiten.',
        'Mapping for outgoing request data' => 'Mapping für ausgehende Anfragedaten',
        'Configure' => 'Konfigurieren',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Die Daten des OTOBO-Invokers werden von diesem Mapping verarbeitet, um sie so umzuformen, wie das entfernte System die Daten benötigt.',
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
        'GenericInterface Invoker Event Settings for Web Service %s' => 'GenericInterface Invoker Ereignis-Einstellungen für Webservice %s',
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
        'Add a new Field' => 'Neues Feld hinzufügen',
        'Remove this Field' => 'Feld entfernen',
        'And can\'t be repeated on the same condition.' => 'Und darf sich nicht innerhalb derselben Bedingung wiederholen.',
        'Add New Condition' => 'Neue Bedingung hinzufügen',

        # Template: AdminGenericInterfaceInvokerTicket
        'General invoker data' => 'Allgemeine Invoker-Daten',
        'Settings for outgoing request data' => 'Einstellungen für ausgehende Request-Daten',
        'Ticket fields' => 'Ticket-Felder',
        'Only the selected ticket fields will be considered for the request data.' =>
            'Nur die ausgewählten Ticketfelder werden für die Request-Daten berücksichtigt.',
        'Article fields' => 'Artikelfelder',
        'Only the selected article fields will be considered for the request data.' =>
            'Nur die ausgewählten Artikelfelder werden für die Request-Daten berücksichtigt.',
        'Ticket dynamic fields' => 'Dynamische Felder Ticket',
        'Only the selected ticket dynamic fields will be considered for the request data.' =>
            'Nur die ausgewählten dynamischen Felder zum Ticket werden für die Request-Daten berücksichtigt.',
        'Article dynamic fields' => 'Dynamische Felder Artikel',
        'Only the selected article dynamic fields will be considered for the request data.' =>
            'Nur die ausgewählten dynamischen Felder zum Artikel werden für die Request-Daten berücksichtigt.',
        'Number of articles' => 'Anzahl der Artikel',
        'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.' =>
            'Ausgehende Anfragedaten enthalten nur die konfigurierte Artikelanzahl. Ohne Auswahl wird exakt ein Artikel versandt.',
        'Communication channels' => 'Kommunikationskanäle',
        'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.' =>
            'In ausgehenden Anfragedaten werden nur Artikel aus den ausgewählten Kommunikationskanälen berücksichtigt. Ohne Auswahl werden Artikel aus allen Kommunikationskanälen versandt.',
        'Customer visibility' => 'Sichtbarkeit für Kunden',
        'The outgoing request data will only consider articles created with the selected customer visibility.' =>
            'Ausgehende Anfragedaten berücksichtigen nur Artikel, die mit der ausgewählten Kundensichtbarkeit erstellt wurden.',
        'Sender Types' => 'Sendertypen',
        'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.' =>
            'Die ausgehenden Request-Daten werden nur Artikel der ausgewählten Sendertypen berücksichtigen. Ohne Auswahl werden alle Sendertypen verwendet.',
        'Mapping' => 'Mapping',
        'Settings for incoming response data' => 'Einstellungen für eingehende Antwortdaten',
        'Remote TicketID dynamic field' => 'Dynamisches Feld mit der Remote TicketID',
        'The selected ticket dynamic field is being used to store the remote TicketID.' =>
            'Das ausgewählte dynamische Feld am Ticket wird verwendet, um die Remote TicketID zu hinterlegen.',
        'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.' =>
            'Bleibt es leer, wird keine Remote TicketID hinterlegt, sofern nicht in der Systemkonfiguration ein Wert für diesen Webservice definiert ist.',
        'The selected field is already in use by the Ticket dynamic fields option.' =>
            'Das ausgewählte Feld wird bereits in der Option Dynamische Felder Ticket verwendet.',
        'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.' =>
            'Bei der Verarbeitung eingehender Response-Daten werden nur die ausgewählten dynamischen Felder zum Ticket berücksichtigt. Ohne Auswahl werden keine dynamischen Felder verarbeitet.',
        'Event data' => 'Ereignisdaten',

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
            'Diese Datensätze werden in die Datenstruktur unter \'/DataInclude/<DatensatzName>\' dargestellt (Details in der Debugger-Ausgabe zu tatsächlichen Anfragen).',
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
            'Der Name wird typischerweise benutzt, um die Webservice-Operation von einem entfernten System aus aufzurufen.',
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
            'URI zur Angabe eines bestimmten Standorts für den Zugriff auf einen Webservice.',
        'e.g. https://www.otobo.de:10745/api/v1.0 (without trailing backslash)' =>
            'z. B. https://www.otobo.de:10745/api/v1.0 (ohne Trailing Slash)',
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
        'SSL hostname verification.' => 'Verifiziert den SSL-Hostnamen.',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            'Abbrechen der Anfrage, wenn der Hostname nicht verifiziert werden kann. Achtung! Nicht unbedacht deaktivieren. Der Verzicht auf eine Überprüfung stellt ein Sicherheitsrisiko dar! Möglichkeit der Deaktivierung vorwiegend für Tests mit selbstsignierten Zertifikaten oder wenn Sie genau wissen, was Sie tun.',
        'Controller mapping for Invoker' => 'Controller-Mapping für Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Der Controller, an den der Invoker Anfragen senden soll. Variablen, die mit einem \':\' markiert sind, werden durch den Datenwert ersetzt und mit der Anfrage übergeben. (z.B.: /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Gültiger Anfragebefehl für Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Ein spezifisches HTTP-Kommando, das für Anfragen mit diesem Invoker zu verwenden ist (optional).',
        'Default command' => 'Standardbefehl',
        'The default HTTP command to use for the requests.' => 'Der Standard-HTTP-Befehl für die Anfragen.',
        'Additional request headers (all invokers)' => 'Zusätzliche Request Header (alle Invoker)',
        'Additional request headers (invoker specific)' => 'Zusätzliche Request Header (ausgewählte Invoker)',
        'Remove all headers for this invoker' => 'Alle Header für diesen Invoker entfernen',
        'Headers for invoker' => 'Header für den Invoker',
        'Additional response headers (all operations)' => 'Zusätzliche Response Header (alle Operations)',
        'Additional response headers (operation specific)' => 'Zusätzliche Response Header (ausgewählte Operations)',
        'Remove all headers for this operation' => 'Alle Header für diese Operation entfernen',
        'Headers for operation' => 'Header für die Operation',
        'Common headers' => 'Gemeinsame Header',
        'Header Name' => 'Header-Name',
        'Remove header' => 'Header entfernen',
        'Add header' => 'Header hinzufügen',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otobo.de:8000/Webservice/Example' => 'z. B. https://local.otobo.de:8000/Webservice/Beispiel',
        'Set SOAPAction' => 'Setzen von SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Auf "Ja" setzen, um einen befüllten SOAPAction-Header zu senden.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Auf "Nein" setzen, um einen leeren SOAPAction-Header zu senden.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Auf "Ja" setzen, um den empfangenen SOAPAction-Header zu prüfen.',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Auf "Nein" setzen, um den empfangenen SOAPAction-Header zu ignorieren.',
        'SOAPAction scheme' => 'SOAPAction-Schema',
        'Select how SOAPAction should be constructed.' => 'Wählen Sie, wie die SOAPAction konstruiert werden soll.',
        'Some web services require a specific construction.' => 'Einige Webservices benötigen eine spezifische Konstruktion.',
        'Some web services send a specific construction.' => 'Einige Webservices senden eine spezifische Konstruktion.',
        'SOAPAction separator' => 'SOAPAction-Trenner',
        'Character to use as separator between name space and SOAP operation.' =>
            'Zu nutzendes Trennzeichen zwischen dem Namespace und der SOAP-Operation.',
        'Usually .Net web services use "/" as separator.' => 'Normalerweise verwenden .Net-basierte Webservices "/" als Trenner.',
        'SOAPAction free text' => 'SOAPAction Freitext',
        'Text to be used to as SOAPAction.' => 'Text welcher als SOAPAction genutzt werden soll.',
        'Namespace' => 'Namensraum',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI, die SOAP-Methoden einen Kontext gibt und damit Mehrdeutigkeiten auflöst.',
        'e.g. urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions' =>
            'z. B. urn:otobo-com:soap:functions oder http://www.otobo.de/GenericInterface/actions',
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
        'e.g. utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'z. B. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => 'Sortierungsoptionen',
        'Add new first level element' => 'Neues Element auf der obersten Ebene hinzufügen',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Sortierung für ausgehende XML-Felder (Struktur unterhalb des Funktionsaufrufes) - siehe Dokumentation für SOAP-Transport.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webservice hinzufügen',
        'Edit Web Service' => 'Webservice bearbeiten',
        'Clone Web Service' => 'Webservice klonen',
        'The name must be unique.' => 'Der Name muss eindeutig sein.',
        'Clone' => 'Klonen',
        'Export Web Service' => 'Webservice exportieren',
        'Import web service' => 'Webservices importieren',
        'Configuration File' => 'Konfigurationsdatei',
        'The file must be a valid web service configuration YAML file.' =>
            'Die Datei muss eine gültige Webservice-Konfigurationsdatei im YAML-Format sein.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Hier können Sie einen Namen für den Webservice angeben. Bleibt dieses Feld leer, wird der Dateiname der Konfigurationsdatei als Name verwendet.',
        'Import' => 'Importieren',
        'Configuration History' => 'Konfigurationshistorie',
        'Delete web service' => 'Webservice löschen',
        'Do you really want to delete this web service?' => 'Wollen Sie diesen Webservice wirklich löschen?',
        'Ready2Adopt Web Services' => 'Ready2Adopt-Webservices',
        'Here you can activate Ready2Adopt web services showcasing our best practices.' =>
            'Hier können Sie Ready2Adopt-Webservices aktivieren, die nach unseren Best-Practices erstellt wurden.',
        'Import Ready2Adopt web service' => 'Ready2Adopt-Webservices importieren',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Nach dem Speichern der Konfiguration werden Sie wieder auf den Bearbeitungsbildschirm geleitet.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Wenn Sie zurück zur Übersicht möchten, verwenden Sie bitte die Schaltfläche "Zurück zur Übersicht".',
        'Remote system' => 'Remote-System',
        'Provider transport' => 'Provider-Transport',
        'Requester transport' => 'Requester-Transport',
        'Debug threshold' => 'Debug-Level',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Im Modus "Provider" bietet OTOBO Webdervices an, die von externen Systemen genutzt werden.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Im Modus "Requester" nutzt OTOBO selbst Webservices von externen Systemen.',
        'Network transport' => 'Netzwerktransport',
        'Error Handling Modules' => 'Fehlerbehandlungs-Module',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Fehlerbehandlungs-Module werden genutzt, um auf Fehler zu reagieren, die während der Kommunikation auftreten. Diese Module werden in festgelegter Reihenfolge ausgeführt, die Sie durch Verschieben mit der Maus ändern können.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Fehlerbehandlungs-Modul hinzufügen',
        'Operations are individual system functions which remote systems can request.' =>
            'Operations sind einzelne Systemfunktionen, die entfernte Systeme aufrufen können.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invoker bereiten Daten für eine Anfrage an einen externen Webservice auf und verarbeiten die Antwortdaten.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Eingehendes Mapping',
        'Outbound mapping' => 'Ausgehendes Mapping',
        'Delete this action' => 'Diese Aktion löschen',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Noch mindestens ein %s hat einen Controller, der nicht aktiv oder nicht vorhanden ist, bitte prüfen Sie die Controller-Registrierung oder löschen Sie %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historie',
        'Go back to Web Service' => 'Zurück zum Webservice',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hier können Sie ältere Versionen der Konfiguration dieses Webservice einsehen, exportieren oder wiederherstellen.',
        'Configuration History List' => 'Liste der Konfigurationshistorie',
        'Version' => 'Version',
        'Create time' => 'Erstellzeit',
        'Select a single configuration version to see its details.' => 'Wählen Sie eine Konfigurationsversion aus, um die Details zu sehen.',
        'Export web service configuration' => 'Webservice-Konfiguration exportieren',
        'Restore web service configuration' => 'Webservice-Konfiguration wiederherstellen',
        'Do you really want to restore this version of the web service configuration?' =>
            'Wollen Sie diese Version der Webservice-Konfiguration wirklich wiederherstellen?',
        'Your current web service configuration will be overwritten.' => 'Ihre aktuelle Webservice-Konfiguration wird überschrieben.',

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
        'View the admin manual' => 'Admin-Handbuch ansehen',
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
        'Communication channel' => 'Kommunikationskanal',
        'Include attachments to notification' => 'Anhänge an Benachrichtigung anfügen',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Nur einmal am Tag pro Ticket und Benachrichtigungs-Transportmethode versenden.',
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
            'PGP-Unterstützung ist aktiviert, aber die Konfiguration ist fehlerhaft. Bitte überprüfen Sie die Konfiguration mit einem Klick auf die Schaltfläche unten.',
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
            'Passen Sie Ihre Datenbank so an, dass Pakete über %s MB akzeptiert werden (aktuell: Pakete bis %s MB). Bitte passen Sie die Einstellung "max_allowed_packet" Ihrer Datenbank-Konfiguration an, um Fehler zu vermeiden.',
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
            'Immer wenn vom Kunden ein Artikel hinzugefügt wird – z. B. per E-Mail oder im Kundenbereich – wird die Eskalationszeit zurückgesetzt. Wird der Kunde bis zum definierten Zeitpunkt nicht erneut kontaktiert, eskaliert das Ticket.',
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
        'This system is registered with OTOBO Team.' => 'Dieses System ist bei der OTOBO Gruppe registriert.',
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
            'Die Systemregistrierung ist ein Service der OTOBO Gruppe, der Ihnen viele Vorteile sichert!',
        'Read more' => 'Mehr erfahren',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Um Ihr System zu registrieren, loggen Sie sich bitte mit Ihrer OTOBO-ID ein.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Verwenden Sie dazu die E-Mail-Adresse, mit der Sie sich auf der OTOBO Webseite angemeldet haben.',
        'Data Protection' => 'Datenschutz',
        'What are the advantages of system registration?' => 'Welche Vorteile bietet die Systemregistrierung?',
        'You will receive updates about relevant security releases.' => 'Bei sicherheitsrelevanten Releases werden Sie benachrichtigt.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Die Registrierung Ihres Systems ermöglicht es der OTOBO Gruppe, Sie schneller und effizienter zu betreuen, weil uns wichtige Informationen über Ihr System bereits vorliegen, die ein mehrmaliges Nachfragen unnötig machen.',
        'This is only the beginning!' => 'Und das ist erst der Anfang!',
        'We will inform you about our new services and offerings soon.' =>
            'Seien Sie gespannt auf weitere Möglichkeiten, die wir Ihnen vorstellen werden.',
        'Can I use OTOBO without being registered?' => 'Kann ich OTOBO auch ohne Registrierung nutzen?',
        'System registration is optional.' => 'Die Systemregistrierung ist optional.',
        'You can download and use OTOBO without being registered.' => 'Sie können OTOBO auch ohne Registrierung im vollen Umfang downloaden und nutzen.',
        'Is it possible to deregister?' => 'Kann ich meine Registrierung rückgängig machen?',
        'You can deregister at any time.' => 'Sie können Ihr System jederzeit deregistrieren.',
        'Which data is transfered when registering?' => 'Welche Daten werden bei der Registrierung übertragen?',
        'A registered system sends the following data to OTOBO Team:' => 'Ein registriertes System überträgt folgende Daten an die OTOBO Gruppe:',
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
            'Wenn Sie dieses System registrieren, werden folgende Daten in regelmäßigen Abständen an die OTOBO Gruppe übertragen.',
        'Attribute' => 'Attribut',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO-Version',
        'Operating System' => 'Betriebssystem',
        'Perl Version' => 'Perl-Version',
        'Optional description of this system.' => 'Optionale Beschreibung für dieses System.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Diese Einstellung aktiviert das Senden zusätzlicher Support-Informationen an die OTOBO Gruppe.',
        'Register' => 'Registrieren',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Wenn Sie fortfahren, wird dieses System bei der OTOBO Gruppe deregistriert.',
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
            'S/MIME-Unterstützung ist zwar aktiviert, jedoch fehlerhaft konfiguriert. Bitte überprüfen Sie die Konfiguration mit einem Klick auf die Schaltfläche unten.',
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
        'Sending support data to OTOBO Team is not possible!' => 'Das Senden von Support-Daten an die OTOBO-Gruppe ist nicht möglich!',
        'Enable Cloud Services' => 'Cloud-Services aktivieren',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Diese Daten werden regelmäßig an die OTOBO Gruppe gesendet. Falls Sie das Senden der Daten beenden möchten, aktualisieren Sie bitte ihre Systemregistrierung.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Sie können den Versand der Support-Daten manuell auslösen, indem Sie diese Schaltfläche verwenden:',
        'Send Update' => 'Update senden',
        'Currently this data is only shown in this system.' => 'Diese Daten werden derzeit nur in Ihrem System angezeigt.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Es wird empfohlen, diese Daten an die OTOBO Gruppe zu senden, um bessere Unterstützung zu erhalten.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Um das Senden der Daten zu aktivieren, registrieren Sie bitte Ihr System bei der OTOBO Gruppe oder aktualisieren Sie Ihre Systemregistrierung (aktivieren Sie die Option \'Supportdaten senden\'.)',
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
            'Das Support-Paket wird automatisch per E-Mail zur OTOBO Gruppe gesendet.',
        'Download File' => 'Datei herunterladen',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'Das Support-Paket wird als Datei ins lokale Dateisystem heruntergeladen. Bitte speichern Sie die Datei und senden Sie diese auf anderen Wegen an die OTOBO Gruppe.',
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
            'Aktuell sind keine Einstellungen verfügbar. Bitte führen Sie \'otobo.Console.pl Maint::Config::Rebuild\' aus, bevor Sie die Software nutzen.',

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
        'Export this deployment.' => 'Inbetriebnahme exportieren.',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => 'Inbetriebnahme-Details',
        'by' => 'von',
        'No settings have been deployed in this run.' => 'In diesem Lauf wurden keine Einstellungen in Betrieb genommen.',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Diese Gruppe enthält selbst keine Einstellungen. Versuchen Sie, in eine der verfügbaren Untergruppen zu navigieren.',

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
        'Change History' => 'Inbetriebnahme-Historie',
        'Change History of %s' => 'Inbetriebnahme-Historie von %s',
        'No modified values for this setting, the default value is used.' =>
            'Keine Änderungen für diese Einstellung, der Standardwert wird verwendet.',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => 'Benutzeränderungen prüfen',
        'Users Value' => 'Benutzeränderung',
        'For' => 'für',
        'Delete all user values.' => 'Alle Benutzeränderungen verwerfen.',
        'No user value for this setting.' => 'Keine Benutzeränderung für diese Einstellung.',

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
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Ruft die ersten 20 Buchstaben des Betreffs des aktuellen/letzten Agenten-Artikels ab (des aktuellen für die Vorlagen-Typen Antwort und Weiterleiten, des letzten für Notizen). Für andere Vorlagen-Typen wird der Tag nicht unterstützt.',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Ruft die ersten 5 Zeilen des Bodys des aktuellen/letzten Agenten-Artikels ab (des aktuellen für die Vorlagen-Typen Antwort und Weiterleiten, des letzten für Notizen). Für andere Vorlagen-Typen wird der Tag nicht unterstützt.',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Ruft die ersten 20 Buchstaben des Betreffs des aktuellen/letzten Artikels ab (des aktuellen für die Vorlagen-Typen Antwort und Weiterleiten, des letzten für Notizen). Für andere Vorlagen-Typen wird der Tag nicht unterstützt.',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Ruft die ersten 5 Zeilen des Bodys des aktuellen/letzten Artikels ab (des aktuellen für die Vorlagen-Typen Antwort und Weiterleiten, des letzten für Notizen). Für andere Vorlagen-Typen wird der Tag nicht unterstützt.',
        'Create type templates only supports this smart tags' => 'Vorlagen für das Erstellen unterstützen nur diese "Smart Tags"',
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
        'Edit personal preferences for this agent' => 'Persönliche Einstellungen dieses Agenten bearbeiten',
        'Agents will be needed to handle tickets.' => 'Agenten werden für die Bearbeitung von Tickets benötigt.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Vergessen Sie nicht, einen neuen Agenten zu Gruppen und/oder Rollen hinzuzufügen!',
        'Please enter a search term to look for agents.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Agenten zu suchen.',
        'Last login' => 'Letzte Anmeldung',
        'Switch to agent' => 'Zu Agent wechseln',
        'Title or salutation' => 'Titel oder Anrede',
        'Firstname' => 'Vorname',
        'Lastname' => 'Nachname',
        'A user with this username already exists!' => 'Es existiert bereits ein Nutzer mit diesem Benutzernamen!',
        'Will be auto-generated if left empty.' => 'Wird für ein leeres Feld automatisch generiert.',
        'Mobile' => 'Mobil',
        'Effective Permissions for Agent' => 'Gültige Berechtigungen für den Agenten',
        'This agent has no group permissions.' => 'Dieser Agent besitzt keine Gruppenberechtigungen.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'Die obige Tabelle zeigt alle gültigen Gruppenberechtigungen für den Agenten. Die Matrix berücksichtigt dabei auch alle vererbten Berechtigungen (z.B. durch Rollen).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zuordnungen von Agenten und Gruppe verwalten',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Agenda-Übersicht',
        'Manage Calendars' => 'Kalender verwalten',
        'Add Appointment' => 'Termin hinzufügen',
        'Today' => 'Heute',
        'All-day' => 'Ganztägig',
        'Repeat' => 'Wiederholen',
        'Notification' => 'Benachrichtigung',
        'Yes' => 'Ja',
        'No' => 'Nein',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Keine Kalender gefunden. Bitte legen Sie zuerst einen Kalender über die Kalenderverwaltung an.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Neuen Termin hinzufügen',
        'Calendars' => 'Kalender',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Grundlegende Informationen',
        'Date/Time' => 'Datum/Zeit',
        'Invalid date!' => 'Ungültige Zeitangabe!',
        'Please set this to value before End date.' => 'Bitte setzen Sie einen Wert vor dem Enddatum.',
        'Please set this to value after Start date.' => 'Bitte setzen Sie einen Wert nach dem Startdatum.',
        'This an occurrence of a repeating appointment.' => 'Dies ist ein Element eines sich wiederholenden Termins.',
        'Click here to see the parent appointment.' => 'Klicken Sie hier, um den übergeordneten Termin anzuzeigen.',
        'Click here to edit the parent appointment.' => 'Klicken Sie hier, um den übergeordneten Termin zu bearbeiten.',
        'Frequency' => 'Häufigkeit',
        'Every' => 'Alle',
        'day(s)' => 'Tag(e)',
        'week(s)' => 'Woche(n)',
        'month(s)' => 'Monat(e)',
        'year(s)' => 'Jahr(e)',
        'On' => 'am',
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
            'Prüfen Sie nach 5 Minuten, ob der OTOBO Daemon läuft (\'bin/otobo.Daemon.pl status\').',

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

        # Template: AgentDashboardMyLastChangedTickets
        'No tickets found.' => 'Keine Tickets gefunden.',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ist nun verfügbar!',
        'Please update now.' => 'Bitte nun aktualisieren.',
        'Release Note' => 'Versionsbeschreibung',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Veröffentlicht vor %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Die Konfiguration für dieses Statistik-Widget enthält Fehler, bitte überprüfen Sie Ihre Einstellungen.',
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
        'Tickets in My Services' => 'Tickets in "Meine Services"',
        'Service Time' => 'Service-Zeit',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Summe',

        # Template: AgentDashboardUserOnline
        'out of office' => 'abwesend',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'bis',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Zurück',
        'Detailed search' => 'Detailsuche',
        'Add an additional attribute' => 'Weiteres Attribut hinzufügen',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => 'Detailansicht',

        # Template: AgentElasticsearchQuickResult
        'Tickets' => 'Tickets',
        'ConfigItems' => 'ConfigItems',

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
        'Password Policy' => 'Passwort-Richtlinie',
        'Your current password is older than %s days. You need to set a new one.' =>
            'Ihr Passwort ist älter als %s Tage. Bitte vergeben Sie ein neues.',
        'Change password' => 'Passwort ändern',
        'Current password' => 'Aktuelles Passwort',
        'New password' => 'Neues Passwort',
        'Repeat new password' => 'Neues Passwort wiederholen',
        'Password needs to be renewed every %s days.' => 'Passwort muss alle %s Tage neu vergeben werden.',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            'Die Passwort-Historie ist aktiv. Sie können keines der %s letzten Passwörter erneut verwenden.',
        'Password length must be at least %s characters.' => 'Passwort muss mindestens %s Zeichen lang sein.',
        'Password requires at least two lower- and two uppercase characters.' =>
            'Passwort muss mindestens zwei Groß- und zwei Kleinbuchstaben enthalten.',
        'Password requires at least two characters.' => 'Passwort muss mindestens zwei Zeichen lang sein.',
        'Password requires at least one digit.' => 'Passwort muss mindestens eine Ziffer enthalten.',
        'Change config options' => 'Config-Optionen anpassen',
        'Admin permissions are required!' => 'Admin-Rechte erforderlich!',

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
        'End' => 'Ende',
        'This setting can currently not be saved.' => 'Diese Einstellung kann derzeit nicht gespeichert werden.',
        'This setting can currently not be saved' => 'Diese Einstellung kann derzeit nicht gespeichert werden',
        'Save this setting' => 'Einstellung speichern',
        'Did you know? You can help translating OTOBO at %s.' => 'Schon gewusst? Unter %s können Sie zur Übersetzung von OTOBO beitragen.',

        # Template: SettingsList
        'Reset to default' => 'Auf Standard zurücksetzen',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Wählen Sie in den Kacheln rechts aus, welche Einstellungen Sie ändern möchten.',
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

        # Template: AgentStatisticsReportsAdd
        'Report Management' => 'Berichteverwaltung',
        'Add Report' => 'Bericht hinzufügen',

        # Template: AgentStatisticsReportsEdit
        'Edit Report' => 'Bericht bearbeiten',
        'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.' =>
            'Hier können Sie mehrere Statistiken zu einem Bericht zusammenfassen und daraus manuell oder automatisch zu voreingestellten Zeitpunkten eine PDF erstellen.',
        'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.' =>
            'Hinweis: Sie können nur dann Diagramme als Ausgabeformat für Statistiken auswählen, wenn Sie eine der Renderdateien auf Ihrem System konfiguriert haben.',
        'Configure PhantomJS' => 'PhantomJS konfigurieren',
        'Configure GoogleChrome' => 'GoogleChrome konfigurieren',
        'General settings' => 'Allgemeine Einstellungen',
        'Automatic generation settings' => 'Einstellungen für die automatische Erstellung',
        'Automatic generation times (cron)' => 'Zeiten für die automatische Erstellung (cron)',
        'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.' =>
            'Im Cron-Format spezifizieren, wann ein Bericht automatisch generiert werden soll, bspw. "10 1 * * *" für jeden Tag um 01:10 Uhr.',
        'Times are in the system timezone.' => 'Zeiten entsprechen der Systemzeitzone.',
        'Last automatic generation time' => 'Letzte automatische Erstellzeit',
        'Next planned automatic generation time' => 'Nächste geplante automatische Erstellzeit',
        'Automatic generation language' => 'Automatische Erstellsprache',
        'The language to be used when the report is automatically generated.' =>
            'Die Sprache, die verwendet werden soll, wenn der Bericht automatisch erstellt wird.',
        'Email subject' => 'E-Mail-Betreff',
        'Specify the subject for the automatically generated email.' => 'Bitte geben Sie einen Betreff für die automatisch erstellte Mail ein.',
        'Email body' => 'E-Mail-Body',
        'Specify the text for the automatically generated email.' => 'Bitte geben Sie den Text für die automatisch erstellte E-Mail ein.',
        'Email recipients' => 'E-Mail-Empfänger',
        'Specify recipient email addresses (comma separated).' => 'Geben Sie die E-Mail-Adressen der Empfänger ein (mit Komma getrennt).',
        'Output settings' => 'Ausgabeeinstellungen',
        'Headline' => 'Überschrift',
        'Caption for preamble' => 'Überschrift für das Vorwort',
        'Preamble' => 'Vorwort',
        'Caption for epilogue' => 'Überschrift für das Schlusswort',
        'Epilogue' => 'Schlusswort',
        'Add statistic to report' => 'Statistik dem Bericht hinzufügen',

        # Template: AgentStatisticsReportsOverview
        'Statistics Reports' => 'Statistik-Berichte',
        'Edit statistics report "%s".' => 'Bericht "%s" bearbeiten.',
        'Delete statistics report "%s"' => 'Bericht "%s" löschen',

        # Template: AgentStatisticsReportsView
        'View Report' => 'Bericht ansehen',
        'This statistics report contains configuration errors and can currently not be used.' =>
            'Dieser Statistik-Bericht enthält Konfigurationsfehler und kann nicht gespeichert werden.',

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
        'Move to Cc' => 'In Cc verschieben',
        'Move to Bcc' => 'In Bcc verschieben',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Bitte entfernen Sie diesen Eintrag und geben Sie einen mit einem gültigen Wert an.',
        'This address already exists on the address list.' => 'Dieser Eintrag existiert bereits in der Adressliste.',
        'Remove Cc' => 'Cc entfernen',
        'Move to To' => 'In An verschieben',
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
        'To customer user' => 'An Kundenbenutzer',
        'Please include at least one customer user for the ticket.' => 'Bitte tragen Sie wenigstens einen Kundenbenutzer für das Ticket ein.',
        'Select this customer as the main customer.' => 'Diesen Kunden als Hauptkunden auswählen.',
        'Remove Ticket Customer User' => 'Kundenbenutzer des Tickets entfernen',
        'From queue' => 'Aus Queue',
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
        'Sender' => 'Absender',
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
        'Via' => 'via',
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
        'Click to accept' => 'Mit einem Klick erkläre ich meine Zustimmung',

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
        'New Ticket' => 'Neues Ticket',

        # Template: CustomerError
        'An Error Occurred' => 'Ein Fehler ist aufgetreten',
        'Error Details' => 'Fehlerdetails',
        'Traceback' => 'Rückverfolgung',

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
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            'Der Internetexplorer wird von OTOBO nur in Hinblick auf grundlegende Funktionalität unterstützt. Bitte ziehen Sie in Betracht, zu einem modernen Web-Browser zu wechseln.',
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
        'Change Password' => 'Passwort ändern',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            'Passwort muss mindestes 3 der folgenden Zeichenklassen enthalten: Kleinbuchstaben, Großbuchstaben, Ziffern, Sonderzeichen.',

        # Template: CustomerTicketList
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
        'Page' => 'Seite',
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
        'Further actions' => 'Weitere Aktionen',

        # Template: Chat
        'Expand article' => 'Artikel aufklappen',

        # Template: MIMEBase
        'Article Information' => 'Artikel-Informationen',

        # Template: CustomerWarning
        'Warning' => 'Warnung',

        # Template: TileNewTicket
        'Issue%sa ticket' => 'Ticket%serstellen',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Ereignisinformation',

        # Template: Error
        'Send a bugreport' => 'Einen Fehlerbericht senden',
        'Expand' => 'Ausklappen',

        # Template: Footer
        'Powered by %s' => 'Powered by %s',

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
        'Web site' => 'Website',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Mailversand konfigurieren',
        'Outbound mail type' => 'Typ der ausgehenden E-Mail',
        'Select outbound mail type.' => 'Typ der ausgehenden E-Mail auswählen.',
        'Outbound mail port' => 'Port der ausgehenden E-Mail',
        'Select outbound mail port.' => 'Port der ausgehenden E-Mail auswählen.',
        'SMTP host' => 'SMTP-Host',
        'SMTP host.' => 'SMTP-Host.',
        'SMTP authentication' => 'SMTP-Authentifizierung',
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
        'Generated password' => 'Generiertes Passwort',
        'Repeat Password' => 'Passwort wiederholen',
        'Passwords do not match' => 'Passworte stimmen nicht überein',

        # Template: InstallerFinish
        'Start page' => 'Startseite',
        'Your OTOBO Team' => 'Ihr OTOBO-Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Lizenz nicht akzeptieren',
        'Accept license and continue' => 'Lizenz akzeptieren und fortfahren',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Der System-Identifikator. Jede Ticketnummer und jede HTTP-Sitzungs-ID enthalten diese Nummer.',
        'HTTP Type' => 'HTTP-Typ',
        'Set the request scheme used for cookies and various links. For production purposes always use https.' =>
            'Definiert das für den Abruf von Cookies und verschiedenen Links verwendete Schema. In Produktivumgebungen immer HTTPS verwenden.',
        'System FQDN' => 'System-FQDN',
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
            'Vom Benutzer angegebene E-Mail-Adressen werden gegen die MX-Einträge im DNS geprüft. Nutzen Sie diese Option nicht, wenn Ihr DNS langsam ist oder öffentliche Adressen nicht auflösen kann.',
        'Elasticsearch' => 'Elasticsearch',
        'Initialize Elasticsearch' => 'Initialisiert Elasticsearch',
        'Elasticsearch server was found, and it has been activated automatically for OTOBO.' =>
            'Elasticsearch-Server gefunden und automatisch für OTOBO aktiviert.',
        'Seemingly either no clean Elasticsearch server is running, or it is not using the standard configuration. To activate Elasticsearch manually, please edit the web service in the admin interface if necessary, activate \'Elasticsearch::Active\' and \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in the SysConfig and run the otobo.Console command \'Maint::Elasticsearch::Migration\'.' =>
            'Scheinbar läuft entweder kein sauberer Elasticsearch-Server oder es wird keine Standardkonfiguration verwendet. Um Elasticsearch manuell zu aktivieren, bearbeiten Sie bitte ggf. den Webserver im Admin-Bereich. Aktivieren Sie \'Elasticsearch::Active\' und \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in der Systemkonfiguration und führen Sie den otobo.Console-Befehl \'Maint::Elasticsearch::Migration\' aus.',

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

        # Template: Copy
        'Start migration' => 'Migration starten',
        'Result of data migration' => 'Ergebnis der Datenmigration',
        'Last successful task:' => 'Zuletzt erfolgreich ausgeführt:',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            'Die Migration wird nach dem letzten erfolgreich durchgeführten Schritt wiederaufgenommen. Bitte gehen Sie zurück zum Anfang, wenn es inzwischen Änderungen an Ihrem System gegeben hat.',
        'Clean up and finish' => 'Bereinigen und Abschließen',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            'Die Migration ist abgeschlossen. Danke, dass Sie OTOBO verwenden – wir hoffen, Sie mögen es!',
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Um OTOBO nutzen zu können, müssen Sie die folgenden Zeilen als root in die Befehlszeile (Terminal/Shell) eingeben.',
        'Restart your webserver' => 'Starten Sie ihren Webserver neu',
        'After doing so your OTOBO is up and running.' => 'Danach ist OTOBO startklar.',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            'Dieses Migrationstool führt Sie Schritt für Schritt durch die Migration Ihres Ticketsystems von OTRS oder der ((OTRS)) Community Edition Version 6 zu OTOBO 10.',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            'Es besteht keinerlei Risiko für Ihr Ausgangssystem: Dort wird nichts geändert.',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            'Eine Migrationsanleitung sowie Details zu den Migrationsvoraussetzungen finden Sie im Migrationshandbuch. Wir empfehlen dringend, dieses zu lesen, bevor Sie die Migration starten.',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            'Falls Sie die Migration unterbrechen müssen, können Sie diese jederzeit an der gleichen Stelle wiederaufnehmen, solange der Cache nicht gelöscht wurde.',
        'All entered passwords are cached until the migration is finished.' =>
            'Alle eingegebenen Passwörter werden bis zum Ende der Migration zwischengespeichert.',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            ' Sie können von jeder Person mit Zugang zu dieser Seite oder Leseberechtigung im OTOBO Home-Verzeichnis gelesen werden. Wenn Sie deshalb den Cache nach Abbrechen der Migration löschen möchten, rufen Sie einfach diese Seite erneut auf.',
        'If you need support, just ask our experts – either at' => 'Wenn Sie Unterstützung benötigen, fragen Sie einfach unsere Experten – entweder im',
        'OTOBO forum' => 'OTOBO Forum',
        'or directly via mail to' => 'oder direkt per Mail an',
        'Cached data found' => 'Daten im Cache gefunden',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            'Ihre Migration wird dort wieder aufgenommen, wo sie unterbrochen wurde. Möchten Sie die Migration erneut bei Null starten, verwerfen Sie alle bisherigen Änderungen.',
        'An error occured.' => 'Ein Fehler ist aufgetreten.',
        'Discard previous progress' => 'Bisherige Änderungen verwerfen',
        'Insecure HTTP connection' => 'Unsichere HTTP-Verbindung',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            'Sie führen das Migrations-Tool über http aus. Das ist ausgesprochen unsicher! Während der Migration geben Sie verschiedene Passwörter ein, die dann unverschlüsselt übertragen werden. Jede Person, die sich zwischen Sie und den OTOBO Server schaltet, kann diese Passwörter abfangen. Bitte erwägen Sie, stattdessen https zu nutzen.',
        'Continue anyways :(' => 'Dennoch fortfahren :(',
        ' Continue anyways :(' => ' Dennoch fortfahren :(',

        # Template: OTRSDBSettings
        'DSN' => 'DSN',
        'Skip DB migration' => 'Datenbankmigration überspringen',
        'Expert option! Only works if the migration has already been done by hand.' =>
            'Achtung – Expertenoption! Nur ausführen, wenn die Migration bereits von Hand vorgenommen wurde.',
        'Skipped.' => 'Übersprungen.',

        # Template: OTRSFileSettings
        'OTRS server' => 'OTRS Server',
        'SSH User' => 'SSH-Benutzer',
        'OTRS home directory' => 'OTRS-Home-Verzeichnis',
        'Check settings' => 'Überprüft die Einstellungen',
        'Result of settings check' => 'Ergebnis der Überprüfung',
        'Settings check successful.' => 'Prüfung der Einstellungen erfolgreich.',

        # Template: PreChecks
        'Execute migration pre-checks' => 'Vorprüfungen zur Migration',

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
            'Sie könnten (mithilfe des Paketmanagers) ein eigenes Modul für den öffentlichen Bereich von OTOBO installieren, beispielsweise das FAQ-Modul.',

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

        # Template: StatsWidget
        'Remove statistic' => 'Statistik entfernen',
        'If you don\'t specify a title here, the title of the statistic will be used.' =>
            'Wenn Sie hier keinen Titel angeben, wird der Titel der Statistik verwendet.',
        'Preface' => 'Einleitung',
        'Postface' => 'Nachwort',

        # Template: SettingHistoryListCompare
        'On ' => 'zu ',
        'Reset to this value' => 'Auf diesen Wert zurücksetzen',

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
            'Diese Gruppe enthält selbst keine Einstellungen. Versuchen Sie, in eine der verfügbaren Untergruppen oder eine andere Gruppe zu navigieren.',

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
        'Delete user\'s value.' => 'Benutzeränderung verwerfen.',

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

        # JS Template: ToggleMoreLessCustomer
        'Show all' => 'Alle anzeigen',
        'Show less' => 'Weniger anzeigen',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Klicken Sie, um eine Datei fürs Hochladen auszuwählen.',
        'Click to select or drop files here.' => 'Klicken und Dateien auswählen oder hier ablegen.',
        'Click to select files or just drop them here.' => 'Klicken Sie zum Auswählen oder legen Sie die Dateien einfach hier ab.',
        'Click to select a file or just drop it here.' => 'Klicken Sie zum Auswählen oder legen Sie die Dateien einfach hier ab.',
        'Uploading...' => 'Wird hochgeladen...',

        # JS Template: MigrationState
        'Time needed' => 'Dauer',

        # JS Template: PackageResolve
        'Package' => 'Paket',
        'Uninstall from OTOBO' => 'Deinstallieren',
        'Ignore' => 'Ignorieren',
        'Migrate' => 'Migrieren',

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
            'Die ACLs konnten wegen eines unbekannten Fehlers nicht importiert werden. Weitere Informationen finden Sie in den OTOBO Logdateien',
        'The following ACLs have been added successfully: %s' => 'Die folgenden ACLs wurden erfolgreich hinzugefügt: %s',
        'The following ACLs have been updated successfully: %s' => 'Die folgenden ACLs wurden erfolgreich aktualisiert: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Beim Hinzufügen/Aktualisieren der folgenden ACLs sind Fehler aufgetreten: %s. Weitere Informationen finden Sie in der Protokolldatei.',
        'There was an error creating the ACL' => 'Beim Erstellen der ACL ist ein Fehler aufgetreten',
        'Need ACLID!' => 'ACL-ID benötigt!',
        'Could not get data for ACLID %s' => 'Konnte keine Daten für ACL-ID %s ermitteln',
        'There was an error updating the ACL' => 'Beim Aktualisieren der ACL ist ein Fehler aufgetreten',
        'There was an error setting the entity sync status.' => 'Beim Setzen des Synchronisations-Status ist ein Fehler aufgetreten.',
        'There was an error synchronizing the ACLs.' => 'Beim Synchronisieren der ACLs ist ein Fehler aufgetreten.',
        'ACL %s could not be deleted' => 'ACL %s konnte nicht gelöscht werden',
        'There was an error getting data for ACL with ID %s' => 'Beim Ermitteln der Daten für die ACL mit der ID %s ist ein Fehler aufgetreten',
        '%s (copy) %s' => '%s (Kopie) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Bitte beachten Sie, dass ACL-Restriktionen nicht für den Superuser-Account gelten (UserID 1).',
        'Exact match' => 'Genauer Treffer',
        'Negated exact match' => 'Negierter genauer Treffer',
        'Regular expression' => 'Regulärer Ausdruck',
        'Regular expression (ignore case)' => 'Regulärer Ausdruck (Groß-/Kleinschreibung ignorieren)',
        'Negated regular expression' => 'Negierter Regulärer Ausdruck',
        'Negated regular expression (ignore case)' => 'Negierter regulärer Ausdruck (Groß-/Kleinschreibung ignorieren)',

        # Perl Module: Kernel/Modules/AdminAbout.pm
        'Could not update About message!' => 'Konnte das Impressum nicht aktualisieren!',
        'About message updated!' => 'Impressum aktualisiert!',

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
            'Benachrichtigungen konnten wegen eines unbekannten Fehlers nicht importiert werden. Weitere Informationen in den OTOBO Logdateien',
        'The following Notifications have been added successfully: %s' =>
            'Folgende Benachrichtigungen wurden erfolgreich importiert: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Folgende Benachrichtigungen wurden erfolgreich aktualisiert: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Beim Hinzufügen/Aktualisieren der folgenden Benachrichtigungen sind Fehler aufgetreten: %s. Weitere Informationen finden Sie in der Log-Datei.',
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
        'Debug' => 'Debug',
        'Info' => 'Info',
        'Warn' => 'Warnen',
        'days' => 'Tage',
        'day' => 'Tag',
        'hour' => 'Stunde',
        'minute' => 'Minute',
        'seconds' => 'Sekunden',
        'second' => 'Sekunde',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => 'Keine Kontaktdaten!',
        'No data found for given contact in given source!' => 'Konnte keine Daten zum Kontakt in der angegebenen Quelle finden!',
        'Contact updated!' => 'Kontakt aktualisiert!',
        'No field data found!' => 'Keine Felddaten gefunden!',
        'Contact created!' => 'Kontakt angelegt!',
        'Error creating contact!' => 'Fehler beim Anlegen des Kontakts!',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            'Keine Quellen gefunden. Bitte fügen Sie dem System mindestens ein dynamisches Feld "Kontaktdaten" hinzu!',
        'No data found for given source!' => 'Keine Daten in der angegebenen Quelle gefunden!',

        # Perl Module: Kernel/Modules/AdminCustomerAccept.pm
        'Could not update Privacy Policy!' => 'Datenschutzhinweise konnten nicht aktualisiert werden!',
        'Privacy Policy updated!' => 'Datenschutzhinweise aktualisiert!',

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
            'Konnte die Reihenfolge der Dynamischen Felder nicht zurücksetzen. Weitere Informationen im Fehlerprotokoll.',

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
        'This field key is duplicated.' => 'Dieser Feldschlüssel existiert bereits.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Dieser Wert existiert bereits.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Eingabe von zukünftigen Datumswerten verhindern',
        'Prevent entry of dates in the past' => 'Eingabe von vergangenen Datumswerten verhindern',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'Syntax is incorrect. Please provide a parent element name in front of the double colon.' =>
            'Inkorrekte Syntax. Bitte geben Sie vor dem Doppelpunkt den Namen eines Elternelements ein.',
        'An element is used as parent element, but not included itself. Please include it.' =>
            'Ein Element wird als Elternelement verwendet, ist aber selbst nicht enthalten. Bitte nehmen Sie es auf.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => 'Einstellungen wurden gespeichert.',
        'System was not able to save the setting!' => 'Das System konnte die Einstellung nicht speichern!',
        'Setting is locked by another user!' => 'Einstellung bereits durch einen anderen Nutzer in Bearbeitung!',
        'System was not able to reset the setting!' => 'Einstellung konnte nicht zurückgesetzt werden!',
        'Settings were reset.' => 'Einstellungen wurden zurückgesetzt.',

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
        'Need WebserviceID!' => 'Benötige Webdervice-ID!',
        'Could not get data for WebserviceID %s' => 'Konnte keine Daten für Webservice-ID %s ermitteln',
        'ascending' => 'aufsteigend',
        'descending' => 'absteigend',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Kommunikationstyp benötigt!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Kommunikationstyp muss \'Requester\' oder \'Provider\' sein!',
        'Invalid Subaction!' => 'Ungültige Unteraktion!',
        'Need ErrorHandlingType!' => 'Benötige Fehlerbehandlungs-Typ!',
        'ErrorHandlingType %s is not registered' => 'Fehlerbehandlungs-Typ %s nicht registriert',
        'Could not update web service' => 'Webservice konnte nicht aktualisiert werden',
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
        'Could not update configuration data for WebserviceID %s' => 'Konnte Konfigurationsdaten für Webservice-ID %s nicht aktualisieren',
        'This sub-action is not valid' => 'Diese Unteraktion ist nicht gültig',
        'xor' => 'exklusives oder (xor)',
        'String' => 'Zeichenkette',
        'Regexp' => 'Regexp',
        'Validation Module' => 'Validierungsmodul',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerTicket.pm
        'Invisible only' => 'Nur unsichtbar',
        'Visible only' => 'Nur sichtbar',
        'Visible and invisible' => 'Sichtbar und unsichtbar',

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
        'There is another web service with the same name.' => 'Es existiert bereits ein Webservice mit demselben Namen.',
        'There was an error updating the web service.' => 'Beim Aktualisieren des Webservice ist ein Fehler aufgetreten.',
        'There was an error creating the web service.' => 'Beim Erstellen des Webservice ist ein Fehler aufgetreten.',
        'Web service "%s" created!' => 'Webservice "%s" erstellt!',
        'Need Name!' => 'Name benötigt!',
        'Need ExampleWebService!' => 'Benötige Beispiel-Webservice!',
        'Could not load %s.' => '%s konnte nicht geladen werden.',
        'Could not read %s!' => 'Konnte %s nicht lesen!',
        'Need a file to import!' => 'Benötige eine zu importierende Datei!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Die importierte Datei enthält ungültigen YAML-Inhalt. Bitte prüfen Sie das Systemprotokoll für mehr Informationen',
        'Web service "%s" deleted!' => 'Webservice "%s" gelöscht!',
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
        'All agents subscribed to the ticket\'s queue' => 'Alle Agenten, welche die Queue des Tickets abonniert haben',
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
        'No such package!' => 'Kein solches Paket!',
        'No such file %s in package!' => 'Keine solche Datei %s im Paket!',
        'No such file %s in local file system!' => 'Datei %s existiert nicht im Dateisystem!',
        'Can\'t read %s!' => 'Kann %s nicht lesen!',
        'File is OK' => 'Datei ist OK',
        'Package has locally modified files.' => 'Das Paket enthält lokal angepasste Dateien.',
        'Package not verified by the OTOBO Team!' => 'Paket wurde nicht vom OTOBO Team verifiziert!',
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
            'Beim Setzen des Synchronisations-Status für Prozess-Eintrag %s ist ein Fehler aufgetreten',
        'Could not get data for ProcessID %s' => 'Konnte Daten für ProzessID %s nicht ermitteln',
        'There was an error updating the Process' => 'Beim Aktualisieren des Prozesses ist ein Fehler aufgetreten',
        'Process: %s could not be deleted' => 'Prozess %s konnte nicht gelöscht werden',
        'There was an error synchronizing the processes.' => 'Beim Synchronisieren der Prozesse ist ein Fehler aufgetreten.',
        'The %s:%s is still in use' => 'Der/die/das %s:%s ist noch in Benutzung',
        'The %s:%s has a different EntityID' => 'Der/die/das %s:%s hat eine abweichende EntityID',
        'Could not delete %s:%s' => 'Konnte %s:%s nicht löschen',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Beim Setzen des Synchronisations-Status für %s Einheit %s ist ein Fehler aufgetreten',
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
        'Error while saving the Activity to the database!' => 'Während des Speicherns der Aktivität in der Datenbank ist ein Fehler aufgetreten!',
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
        'Agent and Customer Interface' => 'Agenten- und Kunden-Interface',
        'Do not show Field' => 'Feld nicht anzeigen',
        'Show Field' => 'Feld anzeigen',
        'Show Field As Mandatory' => 'Als Pflichtfeld anzeigen',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Pfad bearbeiten',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Beim Generieren einer neuen Entity-ID für diesen Übergang ist ein Fehler aufgetreten',
        'There was an error creating the Transition' => 'Beim Erstellen des Übergangs ist ein Fehler aufgetreten',
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
            'Systemkonfiguration konnte wegen eines unbekannten Fehlers nicht importiert werden. Weitere Informationen finden Sie in den OTOBO Log-Dateien.',
        'Category Search' => 'Kategoriesuche',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Einige importierte Einstellungen sind im derzeitigen Stand der Konfiguration entweder nicht vorhanden, oder sie konnten nicht aktualisiert werden. Bitte prüfen Sie das Systemprotokoll für weitere Informationen.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            'Diese Inbetriebnahme enthält keine Einstellungsänderungen!',
        'No DeploymentID received!' => 'Keine InbetriebnahmeID empfangen!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'System was unable to update setting!' => 'Einstellung konnte nicht aktualisiert werden!',
        'You need to enable the setting before locking!' => 'Sie müssen die Einstellung vor der Bearbeitung aktivieren!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Sie können diese Einstellung nicht bearbeiten, da sie derzeit von %s (%s) bearbeitet wird.',
        'Missing setting name!' => 'Name der Einstellung fehlt!',
        'Missing ResetOptions!' => 'ResetOptions fehlen!',
        'System was not able to lock the setting!' => 'Einstellung konnte nicht zur Bearbeitung gesperrt werden!',
        'Missing setting name.' => 'Name der Einstellung fehlt.',
        'Setting not found.' => 'Einstellung nicht gefunden.',
        'Missing Settings!' => 'Fehlende Einstellungen!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => 'Keinen Einstellungsnamen empfangen!',
        'Modified Version' => 'Geänderte Version',
        'Reset To Default' => 'Auf den Standard zurückgesetzt',
        'Default Version' => 'Standardversion',
        'No setting name or modified version id received!' => 'Keinen Einstellungsnamen oder ID einer geänderten Version erhalten!',
        'Was not possible to revert the historical value!' => 'Zurücksetzen auf den historischen Wert war nicht möglich!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => 'Fehlender Einstellungsname oder geänderte ID!',
        'System was not able to delete the user setting values!' => 'Das System konnte die Benutzeränderungen nicht verwerfen!',

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
        'Customer User Name' => 'Kundenbenutzer Name',

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
        'This feature is not available.' => 'Diese Funktion ist nicht verfügbar.',
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

        # Perl Module: Kernel/Modules/AgentStatisticsReports.pm
        'Got no %s!' => '%s nicht vorhanden!',
        'Add New Statistics Report' => 'Neuen Bericht hinzufügen',
        'This name is already in use, please choose a different one.' => 'Dieser Name wird bereits verwendet. Bitte wählen Sie einen anderen.',
        'Could not create report.' => 'Bericht konnte nicht erstellt werden.',
        'Need StatsReportID!' => 'StatsReportID wird benötigt!',
        'Edit Statistics Report' => 'Bericht bearbeiten',
        'Could not find report.' => 'Bericht konnte nicht gefunden werden.',
        'Please provide a valid cron entry.' => 'Bitte einen gültigen Cron-Eintrag angeben.',
        'Could not update report.' => 'Bericht konnte nicht aktualisiert werden.',
        'View Statistics Report' => 'Bericht ansehen',
        'Delete: Got no StatsReportID!' => 'Löschen: Keine StatsReportID vorhanden!',

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
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Artikel konnte nicht geöffnet werden. Befindet er sich vielleicht auf einer anderen Artikelseite?',
        'Show one article' => 'Einen Artikel anzeigen',
        'Show all articles' => 'Alle Artikel anzeigen',
        'Show Ticket Timeline View' => 'Ticket-Verlaufsansicht anzeigen',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'FormID fehlt.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Fehler: Die Datei konnte nicht korrekt gelöscht werden. Bitte kontaktieren Sie Ihren Administrator (fehlende FileID).',

        # Perl Module: Kernel/Modules/CustomerDashboardCommon.pm
        'Registration for tile %s of CustomerDashboard is invalid! Either Module or Template needed.' =>
            'Registrierung der Kachel %s im Kunden-Dashboard nicht möglich! Modul oder Vorlage fehlen.',
        'Registration for tile %s of CustomerDashboard is invalid! Order needs to be a unique number.' =>
            'Registrierung für Kachel %s des Kundendashboards ist ungültig! Position muss einmalig sein.',

        # Perl Module: Kernel/Modules/CustomerGenericContent.pm
        'Need Key!' => 'Wert erforderlich!',
        'Invalid Key!' => 'Wert ungültig!',
        'Failed to load Content!' => 'Inhalt konnte nicht geladen werden!',
        'Destination unknown.' => 'Ziel unbekannt.',

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
            'Sie sind nicht berechtigt, Tickets in der Standard-Queue anzulegen.',

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
        'Could not load process module.' => 'Prozessmodul konnte nicht geladen werden.',
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
        'Configure MySQL' => 'MySQL konfigurieren',
        'Database %s' => 'Datenbank %s',
        'Enter the password for the administrative database user.' => 'Geben Sie das Passwort für den Administrationsbenutzer der Datenbank ein.',
        'Configure PostgreSQL' => 'PostgreSQL konfigurieren',
        'Configure Oracle' => 'Oracle konfigurieren',
        'Unknown database type "%s".' => 'Unbekannter Datenbank-Typ "%s".',
        'Please go back.' => 'Bitte gehen Sie zurück.',
        'Create Database' => 'Datenbank erstellen',
        'Install OTOBO - Error' => 'OTOBO-Installation – Fehler',
        'File "%s/%s.xml" not found!' => 'Datei "%s/%s.xml" nicht gefunden!',
        'Contact your Admin!' => 'Kontaktieren Sie Ihren Administrator!',
        'Execution of SQL statement failed: ' => 'SQL Statement konnte nicht ausgeführt werden: ',
        'https' => 'https',
        'http' => 'http',
        'System Settings' => 'System-Einstellungen',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'E-Mail konfigurieren',
        'Mail Configuration' => 'Mail-Konfiguration',
        'Unknown Subaction %s!' => 'Unbekannte Subaktion %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Kann nicht zur Datenbank verbinden, Perl-Modul DBD::%s nicht installiert!',
        'Can\'t connect to database, read comment!' => 'Kann nicht zur Datenbank verbinden, bitte Hinweis lesen!',
        'Database already contains data - it should be empty!' => 'Die Datenbank enthält bereits Daten, obwohl sie leer sein sollte!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Fehler: Bitte stellen Sie sicher, dass Ihre Datenbank Pakete größer als %s MB akzeptiert (aktuell: Pakete bis zu einer Größe von %s MB). Bitte passen Sie die Einstellung max_allowed_packet Ihrer Datenbank an, um Fehler zu vermeiden.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Fehler: Bitte setzen Sie den Wert für innodb_log_file_size in Ihrer Datenbank-Konfiguration auf mindestens %s MB (aktuell: %s MB, empfohlen: %s MB). Mehr Informationen finden Sie unter %s.',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            'Wenn Sie das Migrationstool MigrateFromOTRS erneut ausführen möchten, deaktivieren Sie "SecureMode" in der SysConfig.',
        'OTRS to OTOBO migration' => 'Migration von OTRS zu OTOBO',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Kein %s!',
        'No such user!' => 'Kein Benutzer gefunden!',
        'Invalid calendar!' => 'Ungültiger Kalender!',
        'Invalid URL!' => 'Ungültige URL!',
        'There was an error exporting the calendar!' => 'Beim Exportieren des Kalenders ist ein Fehler aufgetreten!',

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
        'Contact us at hello@otobo.io' => 'Schreiben Sie uns an hello@otobo.io',
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
        'Internal error during verification!' => 'Interner Fehler bei der Überprüfung!',
        'Impossible to decrypt: private key not found!' => 'Entschlüsselung fehlgeschlagen: Keinen privaten Schlüssel gefunden!',
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

        # Perl Module: Kernel/Output/HTML/Dashboard/MyLastChangedTickets.pm
        'Shown Tickets' => 'Gezeigte Tickets',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Kein Verbindungsaufbau zum Server mit den OTOBO Neuigkeiten möglich!',
        'Can\'t get OTOBO News from server!' => 'OTOBO Neuigkeiten können nicht vom Server abgerufen werden!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Kein Verbindungsaufbau zum Server mit den Produkt-Neuigkeiten möglich!',
        'Can\'t get Product News from server!' => 'Produkt-Neuigkeiten können nicht vom Server abgerufen werden!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Kein Verbindungsaufbau zu %s möglich!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
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
            'Passwort kann nicht aktualisiert werden! Die eingegebenen Passwörter sind unterschiedlich.',
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
            'Passwort kann nicht aktualisiert werden. Es muss mindestens 3 von 4 Zeichenklassen (Kleinbuchstaben, Großbuchstaben, Ziffern, Sonderzeichen) enthalten!',

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

        # Perl Module: Kernel/Output/PDF/StatisticsReports.pm
        '%s Report' => '%s Bericht',
        'Error: this graph could not be generated: %s.' => 'Fehler: Dieses Diagramm konnte nicht erstellt werden: %s.',
        'Table of Contents' => 'Inhaltverzeichnis',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Dynamische Felder für Tickets',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Die ACL-Konfigurationsdatei konnte nicht gelesen werden. Bitte prüfen Sie, dass es sich um eine gültige Datei handelt.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Die Anmeldung ist derzeit aufgrund einer geplanten Systemwartung nicht verfügbar.',

        # Perl Module: Kernel/System/Auth/OpenIDConnect.pm
        'Authentication error. Please contact the administrator.' => 'Authentifizierungsfehler. Bitte wenden Sie sich an Ihren Administrator.',
        'Authentication error.' => 'Authentifizierungsfehler.',
        'Invalid response from the authentication server. Maybe the process took too long. Please retry once.' =>
            'Ungültige Antwort vom Authentifizierungsserver. Möglicherweise kam es zum Timeout. Bitte versuchen Sie es noch einmal.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Please note that the session limit is almost reached.' => 'Bitte beachten Sie, dass das Sitzungslimit fast erreicht ist.',
        'Session limit reached! Please try again later.' => 'Maximale Anzahl an Sitzungen erreicht. Bitte versuchen Sie es später noch einmal.',
        'Session per user limit reached!' => 'Das Limit für Sitzungen pro Benutzer wurde erreicht!',

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

        # Perl Module: Kernel/System/MigrateFromOTRS/CloneDB/Backend.pm
        'Sanity checks for database.' => 'Plausibilitätsprüfungen der Datenbank.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => 'ACL-Konfiguration in Betrieb nehmen.',
        'Deployment completed, perfect!' => 'Inbetriebnahme abgeschlossen. Glückwunsch!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => 'Migrieren der Datenbanktabelle "auto_responses".',
        'Migration failed.' => 'Migration fehlgeschlagen.',
        'Migrate database table auto_response.' => 'Migrieren der Datenbanktabelle "auto_response".',
        'Migration completed, perfect!' => 'Migration abgeschlossen. Glückwunsch!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => 'OTOBO Cache leeren.',
        'Completed.' => 'Abgeschlossen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Need OTRSData->%s!' => 'OTRSData->%s benötigt!',
        'Can\'t access OTRS Home: %s!' => 'Kann nicht auf OTRS Home: %s zugreifen!',
        'All needed files copied and migrated, perfect!' => 'Alle Dateien wurden kopiert und migriert. Glückwunsch!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Copy database.' => 'Kopiert die Datenbank.',
        'Skipped...' => 'Übersprungen ...',
        'System was unable to connect to OTRS database.' => 'System konnte keine Verbindung zur OTRS-Datenbank herstellen.',
        'System was unable to complete data transfer.' => 'System konnte den Datentransfer nicht abschließen.',
        'Data transfer completed.' => 'Datentransfer abgeschlossen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO version is correct.' => 'Überprüft, ob die OTOBO Version korrekt ist.',
        'Check if OTOBO and OTRS connect is possible.' => 'Überprüft, ob eine Verbindung zwischen OTRS und OTOBO hergestellt werden kann.',
        'Can\'t open RELEASE file from OTRSHome: %s!' => 'Kann das RELEASE File in OTRSHome: %s nicht öffnen!',
        'Check if OTOBO and OTRS version is correct.' => 'Überprüft, ob die verwendeten OTOBO- und OTRS-Versionen korrekt sind.',
        '%s does not exist!' => '%s nicht vorhanden!',
        'No OTOBO system found!' => 'Kein OTOBO-System gefunden!',
        'You are trying to run this script on the wrong framework version %s!' =>
            'Sie versuchen das Skript in der falschen Framework-Version %s auszuführen!',
        'OTOBO Version is correct: %s.' => 'OTOBO-Version ist korrekt: %s.',
        'Check if OTRS version is correct.' => 'Überprüft, ob die OTRS Version korrekt ist.',
        'OTRS RELEASE file %s does not exist!' => 'OTRS RELEASE Datei %s ist nicht vorhanden!',
        'Can\'t read OTRS RELEASE file: %s' => 'Kann OTRS RELEASE Datei: %s nicht lesen',
        'No OTRS system found!' => 'Kein OTRS-System gefunden!',
        'Unknown PRODUCT found in OTRS RELASE file: %s. Expected values are %s.' =>
            'Unbekanntes PRODUKT in OTRS RELEASE-Datei gefunden: %s. Erwartete Werte: %s.',
        'OTRS Version is correct: %s.' => 'OTRS-Version ist korrekt: %s.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOItsmTablesMigrate.pm
        'Migrate ITSM database tables.' => 'Migration von ITSM Datenbanktabellen.',
        'Nothing to do, as the the table \'%s\' does not exist.' => 'Nichts zu tun: Tabelle \'%s\' nicht vorhanden.',
        'UPDATE of the table \'%s\' failed.' => 'AKTUALISIERUNG der Tabelle \'%s\' fehlgeschlagen.',
        'Migration completed.' => 'Migration abgeschlossen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => 'Migriert die Konfigurationseinstellungen.',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            'Bei der Migration der SysConfig-Daten ist ein Fehler aufgetreten oder es ist keine Konfiguration vorhanden.',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            'Beim Migrieren der SysConfig-Daten ist ein Fehler beim Schreiben der XML-Werte in die DB aufgetreten.',
        'SysConfig data migration completed.' => 'Migration der SysConfig-Daten abgeschlossen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => 'Migration der Webservice-Konfiguration.',
        'Failed - see the log!' => 'Fehlgeschlagen – bitte Protokoll prüfen!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => 'Migrieren der Datenbanktabelle "notification".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => 'Kann die Datei Kernel/Config.pm aus OTRSHome: %s nicht öffnen!',
        'Check if Kernel/Config.pm exists in OTOBO home.' => 'Überprüfen Sie, ob in OTOBO Home eine Datei Kernel/Config.pm vorhanden ist.',
        'Kernel/Config.pm exists in OTOBO home' => 'Kernel/Config.pm ist in OTOBO verfügbar',
        'Check if we are able to connect to OTRS Home.' => 'Überprüft, ob eine Verbindung zu OTRS Home hergestellt werden kann.',
        'Can\'t connect to OTRS file directory.' => 'Kann keine Verbindung zum OTRS-Dateiverzeichnis herstellen.',
        'Connect to OTRS file directory is possible.' => 'Verbindung zum OTRS-Dateiverzeichnis ist möglich.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => 'Versucht eine Verbindung zur Datenbank herzustellen und Plausibilitätsprüfungen durchzuführen.',
        'Could not create database object.' => 'Konnte kein Datenbankobjekt erstellen.',
        'Database connect and sanity checks completed.' => 'Verbindung zur Datenbank hergestellt und Plausibilitätsprüfungen abgeschlossen.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => 'Prüft, ob alle benötigten Pakete installiert wurden.',
        'The following packages are only installed in OTRS:' => 'Folgende Pakete sind nur in OTRS installiert:',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            'Bitte installieren (oder deinstallieren) Sie die Pakete vor der Migration. Ist ein Paket bisher nicht für OTOBO verfügbar, wenden Sie sich bitte via bugs\@otobo.org an das OTOBO Team. Wir finden eine Lösung.',
        'The same packages are installed on both systems, perfect!' => 'Auf beiden Systemen sind die gleichen Pakete installiert, sehr gut!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPackageSpecifics.pm
        'Package specific tasks' => 'Paketsbezogene Aufgaben',
        'Done -' => 'Erledigt -',
        'Failed at -' => 'Gescheitert an -',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => 'Prüft, ob alle erforderlichen Perl-Module installiert wurden.',
        '%s script does not exist.' => '%s Skript nicht vorhanden.',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            'Eines oder mehrere der benötigten Perl-Module fehlen. Bitte installieren Sie diese wie empfohlen und führen Sie das Migrationstool erneut aus.',
        'All required Perl modules have been installed, perfect!' => 'Alle erforderlichen Perl-Module wurden installiert. Bestens!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => 'Migration der Postmaster-Filter.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => 'Inbetriebnahme der Prozessmanagement-Konfiguration.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => 'Migrieren der Datenbanktabelle "response_template".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => 'Migrieren der Datenbanktabelle "salutation".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => 'Migrieren der Datenbanktabelle "signature".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => 'Migration der Statistiken.',

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
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '<p>Zusatzpakete können OTOBO um viele nützliche Features erweitern. Stellen Sie jedoch unbedingt sicher, dass dieses Paket aus einer vertrauenswürdigen Quelle stammt, da es OTOBO uneingeschränkt modifizieren kann.</p>',
        'Package not verified by the OTOBO community!' => 'Paket wurde nicht von der OTOBO Community verifiziert!',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "Package::AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>Die Installation nicht verifizierter Pakete ist standardmäßig deaktiviert. Sie können diese über die Einstellung "Package::AllowNotVerifiedPackages" in der Systemkonfiguration aktivieren.</p>',
        'Verification not possible (e.g. no internet connection)!' => 'Verifizierung nicht möglich (z. B. keine Internetverbindung)!',

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
        'Queues / Tickets' => 'Queues / Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Veraltete Tabellen',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'In der Datenbank wurden veraltete Tabellen gefunden. Diese können, falls leer, gelöscht werden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Prüfung Tabellenexistenz',
        'Internal Error: Could not open file.' => 'Interner Fehler: Konnte Datei nicht öffnen.',
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
        'Please convert your database to the character set \'utf8mb4\'.' =>
            'Bitte konvertieren Sie Ihre Datenbank zum Zeichensatz \'utf8mb4\'.',
        'Table Charset' => 'Zeichensatz der Tabellen',
        'There were tables found which do not have \'utf8mb4\' as charset.' =>
            'Es wurden Tabellen gefunden, in denen ein anderer Zeichensatz als \'utf8mb4\' verwendet wird.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Größe der InnoDB-Log-Datei',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Die Einstellung innodb_log_file_size muss mindestens 256 MB betragen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Ungültige Standardwerte',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Tabellen mit ungültigen Standardwerten wurden gefunden. Um diese automatisch zu reparieren, bitte folgendes Kommando ausführen: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximale Anfragegröße',
        'The setting \'max_allowed_packet\' must be 64 MB or higher.' => 'Setzen Sie \'max_allowed_packet\' auf 64 MB oder mehr.',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Certificates.pm
        'Certificate check' => 'Zertifikatsprüfung',
        'Found obsolete cryptographic function.' => 'Veraltete kryptographische Funktion gefunden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO-Festplattenpartition',

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
        'intermittent connection errors' => 'Vorübergehende Verbindungsfehler',

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
        'GenericInterface Webservices' => 'GenericInterface-Webservices',
        'Process Tickets' => 'Prozess-Tickets',
        'Months Between First And Last Ticket' => 'Monate zwischen erstem und letztem Ticket',
        'Tickets Per Month (avg)' => 'Tickets pro Monat (Durchschnitt)',
        'Open Tickets' => 'Offene Tickets',

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
        'Some packages are not verified by the OTOBO Team.' => 'Einige Pakete wurden nicht von Team OTOBO verifiziert.',
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Umgebungsvariablen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Supportdate-Sammlung',
        'Support data could not be collected from the web server.' => 'Supportdaten vom Web-Server konnten nicht ermittelt werden.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/PSGIEnv.pm
        'PSGI Environment' => 'PSGI-Umgebung',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/RunsUnderPSGI.pm
        'Runs under PSGI' => 'Läuft unter PSGI',

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
        'Too many failed login attempts, please retry in %s s.' => 'Zu viele fehlgeschlagene Anmeldungen, bitte versuchen Sie es in %s s noch einmal.',
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
        'If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.' =>
            'Deaktivieren Sie in der SysConfig den SecureMode, bevor Sie installer.pl erneut ausführen.',
        'Action "%s" not found!' => 'Aktion "%s" nicht gefunden!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.' =>
            'Wenn Sie migration.pl erneut ausführen möchten, deaktivieren Sie vorher den SecureMode in der SysConfig.',

        # Perl Module: Kernel/System/Web/InterfacePublic.pm
        'Could not connect to the database.' => 'Konnte keine Verbindung zur Datenbank herstellen.',

        # Database XML / SOPM Definition: scripts/database/otobo-initial_insert.xml
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
            'Standardablehnung (nachdem eine Antwort auf ein geschlossenes Ticket eingegangen ist und diese abgelehnt wurde)',
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
        'Ticket owner update notification' => 'Benachrichtigung über Änderung des Ticket-Besitzers',
        'Ticket responsible update notification' => 'Benachrichtigung über Änderung des Ticket-Verantwortlichen',
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

        # JS File: Core.Agent.Admin.About
        'Do you really want to delete this language?' => 'Möchten Sie diese Sprache wirklich löschen?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Mehr',
        'Less' => 'Weniger',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'In die Zwischenablage legen mit Strg+C (Cmd+C)',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Diesen Anhang entfernen',
        'Deleting attachment...' => 'Anhang wird entfernt...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Beim Löschen des Anhangs ist ein Fehler aufgetreten. Weitere Informationen in den Log-Dateien.',
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
        'Clone web service' => 'Webservice klonen',
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
        'Error during AJAX communication' => 'Fehler während der AJAX-Kommunikation',
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
            'Ein Fehler ist aufgetreten. Bitte speichern Sie alle Einstellungen, die Sie derzeit bearbeiten und prüfen Sie die Log-Dateien auf weitere Informationen.',
        'Reset option is required!' => 'Reset-Option wird benötigt!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Bei Wiederherstellung dieser Version werden alle Einstellungen auf den Stand zurückgesetzt, den sie zum Zeitpunkt der jeweiligen Inbetriebnahme hatten. Möchten Sie fortfahren?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Schlüssel mit Werten können nicht umbenannt werden. Bitte entfernen Sie dieses Schlüssel/Wert-Paar und fügen Sie es anschließend erneut hinzu.',
        'Unlock setting.' => 'Einstellung entsperren.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => 'Möchten Sie wirklich alle Benutzeränderungen verwerfen?',

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
        'This dynamic field database value is already selected.' => 'Dieses dynamische Feld vom Typ Datenbank ist bereits ausgewählt.',

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

        # JS File: Core.Agent.StatisticsReports
        'Do you really want to delete this report?' => 'Möchten Sie diesen Bericht wirklich löschen?',

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
            'Ein Fehler ist aufgetreten! Weitere Details entnehmen Sie bitte dem Fehlerprotokoll Ihres Webbrowsers!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Einer oder mehrere Fehler sind aufgetreten!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Konfigurationsprüfung erfolgreich.',
        'Error in the mail settings. Please correct and try again.' => 'Fehler in der E-Mail-Konfiguration. Bitte korrigieren Sie diese und versuchen Sie es erneut.',

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
        'Current selection' => 'Aktuelle Auswahl',
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

        # SysConfig
        '
            Show optional parameters in parameter list, too. If disabled, the optional parameters are only shown
            in an extra table
        ' => '
            Zeigt auch optionale Parameter in der Parameterliste an. Ist die Option deaktiviert, werden optionale
            Parameter in einer separaten Tabelle angezeigt.
        ',
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Sehr geehrter Kunde,

leider enthält der von Ihnen verwendete Betreff keine gültige Ticketnummer,
so dass diese E-Mail nicht automatisch verarbeitet werden kann.

Bitte erstellen Sie ein neues Ticket im Kundenbereich.

Vielen Dank für Ihr Verständnis!

Ihr Helpdesk-Team
',
        ' (work units)' => ' (Arbeitseinheiten)',
        ' 2 minutes' => ' 2 Minuten',
        ' 5 minutes' => ' 5 Minuten',
        ' 7 minutes' => ' 7 Minuten',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Slim"-Skin, der weniger Bildschirmfläche zum Darstellen von Informationen benötigt.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(BenutzerLogin) Vorname Nachname',
        '(UserLogin) Lastname Firstname' => '(BenutzerLogin) Nachname Vorname',
        '(UserLogin) Lastname, Firstname' => '(BenutzerLogin) Nachname, Vorname',
        '*** out of office until %s (%s d left) ***' => '*** nicht im Büro bis %s (%s Tage übrig) ***',
        '0 - Disabled' => '0 - Deaktiviert',
        '1 - Available' => '1 - Verfügbar',
        '1 - Enabled' => '1 - Aktiviert',
        '10 Minutes' => '10 Minuten',
        '100 (Expert)' => '100 (Experte)',
        '15 Minutes' => '15 Minuten',
        '2 - Enabled and required' => '2 - Aktiviert und verpflichtend',
        '2 - Enabled and shown by default' => '2 - Aktiviert und standardmäßig angezeigt',
        '2 - Enabled by default' => '2 - standardmäßig aktiviert',
        '2 Minutes' => '2 Minuten',
        '200 (Advanced)' => '200 (Fortgeschritten)',
        '30 Minutes' => '30 Minuten',
        '300 (Beginner)' => '300 (Anfänger)',
        '5 Minutes' => '5 Minuten',
        'A TicketWatcher Module.' => 'Ein Ticket-Beobachten-Modul.',
        'A Website' => 'Eine Webseite',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Eine Liste der Dynamischen Felder, die während einer Zusammenführung in das Haupt-Ticket ebenfalls zusammengeführt werden. Es werden nur leere Dynamische Felder im Haupt-Ticket geändert.',
        'A picture' => 'Ein Bild',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL Modul das erlaubt Eltern-Tickets nur dann zu schließen, wenn alle seine Kinder-Tickets geschlossen wurden. ("Status" zeigt welche Status für das Eltern-Ticket nicht verfügbar sind, bis alle Kinder-Tickets geschlossen sind).',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'Erfasste Zeit',
        'Activate Elasticsearch.' => 'Aktiviert Elasticsearch.',
        'Activate the customer frontend.' => 'Kundenfrontend aktivieren.',
        'Activate the public frontend.' => 'Public Interface aktivieren.',
        'Activates Rendering of DynamicFields outside of the DynamicField block.' =>
            'Aktiviert das Rendern dynamischer Felder außerhalb des Blocks für dynamische Felder.',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktiviert einen Blinkmechanismus der Queue, die das älteste Ticket enthält.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktiviert die "Passwort vergessen"-Funktion für Agenten im Agenten-Interface.',
        'Activates lost password feature for customers.' => 'Aktiviert die "Passwort vergessen" Funktion für Kunden.',
        'Activates support for customer and customer user groups.' => 'Aktiviert Unterstützung für Kunden- und Kundenbenutzergruppen.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktiviert verschiedene Artikelfilter in der Zoomansicht, um festzulegen, welche Artikel angezeigt werden sollen.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktiviert die verfügbaren Skins auf dem System. Wert 1 bedeutet aktiv, 0 bedeutet inaktiv.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Aktiviert die Suche im Ticket-Archiv für das Kunden-Interface.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktiviert das Ticket Archivsystem, um ein schnelleres System zu haben, indem einige Tickets aus dem täglichen Anwendungsbereich verschoben werden. Um diese Tickets in der Suche zu finden, muss das Archiv-Flag in der Ticketsuche aktiviert werden.',
        'Activates time accounting.' => 'Aktiviert die Zeitabrechnung.',
        'ActivityID' => 'ActivityID',
        'Add a note to this ticket' => 'Eine Notiz zu diesem Ticket hinzufügen',
        'Add an inbound phone call to this ticket' => 'Einen eingehenden Anruf zu diesem Ticket hinzufügen',
        'Add an outbound phone call to this ticket' => 'Einen ausgehenden Telefonanruf zu diesem Ticket hinzufügen',
        'Added %s time unit(s), for a total of %s time unit(s).' => '%s Zeiteinheit(en) hinzugefügt, %s Einheit(en) insgesamt.',
        'Added email. %s' => 'E-Mail hinzugefügt. %s',
        'Added follow-up to ticket [%s]. %s' => 'Follow-Up hinzugefügt zu Ticket [%s]. %s',
        'Added link to ticket "%s".' => 'Verknüpfung zu "%s" hergestellt.',
        'Added note (%s).' => 'Notiz hinzugefügt (%s).',
        'Added phone call from customer.' => 'Anruf des Kunden hinzugefügt.',
        'Added phone call to customer.' => 'Anruf beim Kunden hinzugefügt.',
        'Added subscription for user "%s".' => 'Abo für Benutzer "%s" eingetragen.',
        'Added system request (%s).' => 'Systemanfrage (%s) hinzugefügt.',
        'Added web request from customer.' => 'Anfrage des Kunden über Webinterface hinzugefügt.',
        'Adds a suffix with the actual year and month to the OTOBO log file. A logfile for every month will be created.' =>
            'Fügt einen Suffix mit dem aktuellen Jahr und Monat in die OTOBO-Protokolldatei hinzu. Für jeden Monat wird eine eigene Log-Datei erstellt.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Fügt die Kunden E-Mailadresse zu den Empfängern hinzu in der "TicketCompose"-Oberfläche des Agenten-Interface hinzu. Die Kunden E-Mailadresse wird nicht hinzugefügt, wenn der Artikel-Typ \'E-Mail an intern\' ist.',
        'Adds the one time vacation days for the indicated calendar.' => 'Fügt die einmaligen Urlaubstage für den angegebenen Kalender hinzu.',
        'Adds the one time vacation days.' => 'Fügt die einmaligen Urlaubstage hinzu.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            'Fügt die dauerhaften Urlaubstage für den angegebenen Kalender hinzu.',
        'Adds the permanent vacation days.' => 'Fügt die dauerhaften Urlaubstage hinzu.',
        'Admin' => 'Admin',
        'Admin Area.' => 'Administratorbereich.',
        'Admin Contact With Data' => 'Admin Contact With Data',
        'Admin Notification' => 'Admin-Benachrichtigung',
        'Admin area navigation for the agent interface.' => 'Navigation der Adminoberfläche für das Agenten-Interface.',
        'Admin contact with data.' => 'Admin-Bereich Kontaktdaten.',
        'Admin modules overview.' => 'Admin Modul Übersicht.',
        'Admin.' => 'Admin.',
        'Administration' => 'Administration',
        'Agent Contact With Data Search' => 'Agent Contact With Data Search',
        'Agent Customer Search' => 'Kundensuche Agentenbereich',
        'Agent Customer Search.' => 'Kundensuche Agentenbereich.',
        'Agent Dynamic Field Database Detailed Search' => 'Agent Dynamic Field Database Detailed Search',
        'Agent Dynamic Field Database Details' => 'Agent Dynamic Field Database Details',
        'Agent Dynamic Field Database Search' => 'Agent Dynamic Field Database Search',
        'Agent Name' => 'Agentenname',
        'Agent Name + FromSeparator + System Address Display Name' => 'Agenten-Name + From-Trennzeichen + Anzeigename der System-Adresse',
        'Agent Preferences.' => 'Agenten-Einstellungen.',
        'Agent Statistics.' => 'Agenten-Statistiken.',
        'Agent User Search' => 'Nutzersuche Agentenbereich',
        'Agent User Search.' => 'Nutzersuche Agentenbereich.',
        'Agent contact with data search.' => 'Suche Kontaktdaten Agentenbereich.',
        'Agent dynamic field database detailed search.' => 'Detailsuche dynamisches Feld Datenbank im Agentenbereich.',
        'Agent dynamic field database details.' => 'Agent dynamic field database details.',
        'Agent dynamic field database search.' => 'Suche dynamisches Feld Datenbank im Agentenbereich.',
        'Agent frontend module registration (disable \'Edit contacts with data\' link if if there is no source field configured).' =>
            'Frontend-Modulregistrierung im Agenten-Interface (deaktivieren Sie den Link \'Kontaktdaten bearbeiten\', wenn kein entsprechendes Quellfeld konfiguriert wurde).',
        'Agent interface article notification module to check PGP.' => 'Artikel-Benachrichtigungsmodul, das die PGP-Überprüfung im Agenten-Interface durchführt.',
        'Agent interface article notification module to check S/MIME.' =>
            'Artikel-Benachrichtigungsmodul, das die S/MIME-Prüfung im Agenten-Interface durchführt.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Modul, das den Zugriff auf die CIC-Suche über die Navigationsleiste im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Modul, das den Zugriff auf die Volltextsuche über die Navigationsleiste im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Modul, das den Zugriff auf Suchprofile über die Navigationsleiste im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modul, das im Agenten-Interface eingehende E-Mails in TicketZoom auf vorhandene und gültige S/MIME-Schlüssel überprüft.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Benachrichtigungsmodul, das die Anzeige der Anzahl gesperrter Tickets im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Benachrichtigungsmodul, das die Anzeige der Anzahl der Tickets im Agenten-Interface regelt, für die ein Agent verantwortlich ist. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Benachrichtigungsmodul, das die Anzeige der Anzahl der Tickets in "Meine Services" im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Benachrichtigungsmodul, das die Anzeige der Anzahl beobachteter Tickets im Agenten-Interface regelt. Eine ergänzende Zugriffssteuerung (Anzeige oder Verbergen des Links) kann durch Nutzung des Schlüssels "Group" und Inhalte wie "rw:group1;move_into:group2" realisiert werden.',
        'AgentTicketZoom widget that displays Contact with data dynamic field in the side bar.' =>
            'AgentTicketZoom-Widget, welches das dynamsiche Feld \'Kontaktdaten\' in der Seitenleiste anzeigt.',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'Widget für AgentTicketZoom, das eine Tabelle von Objekten anzeigt, die mit dem aktuellen Ticket verknüpft sind.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'Widget für AgentTicketZoom, das Kundeninformationen des Kunden anzeigt, dem das aktuelle Ticket zugewiesen ist.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'Widget für AgentTicketZoom, das weitere Daten des aktuellen Tickets anzeigt.',
        'Agents ↔ Groups' => 'Agenten ↔ Gruppen',
        'Agents ↔ Roles' => 'Agenten ↔ Rollen',
        'All CustomerIDs of a customer user.' => 'Alle Kundennummern eines Kundenbenutzers.',
        'All closed tickets.' => 'Alle geschlossenen Tickets.',
        'All customer users of a CustomerID' => 'Alle Kundenbenutzer einer Kundennummer',
        'All escalated tickets' => 'Alle eskalierten Tickets',
        'All new tickets, these tickets have not been worked on yet' => 'Alle neuen Tickets; an diesen Tickets wurde noch nicht gearbeitet',
        'All open tickets, these tickets have already been worked on.' =>
            'Alle offenen Tickets, an denen bereits gearbeitet wurde.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle Tickets, deren Erinnerungszeit erreicht ist',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen in der \'Ticket schließen\'-Maske im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen in der \'Ticket kategorisieren\'-Maske im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen in der \'Notiz\'-Maske im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen durch den Ticketbesitzer in der TicketZoom-Ansicht im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen in der \'Warten auf...\'-Maske in TicketZoom im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen in der \'Priorität\'-Maske in TicketZoom im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt das Hinzufügen von Notizen durch den Ticketverantwortlichen im Agenten-Interface. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Erlaubt Agenten die Achsen einer Statistik zu tauschen, wenn sie eine Statistik generieren.',
        'Allows agents to generate individual-related stats.' => 'Erlaubt Agenten eine individuelle Statistik zu generieren.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Ermöglicht die Wahl zwischen der Anzeige der Anhänge eines Tickets im Browser (Inline) oder einfach nur als Download anbieten (Anhang).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Ermöglicht die Wahl des nächsten Verfassen-Status für Kundenticket im Kunden-Interface.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Erlaubt Kunden die Ticketpriorität im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Erlaubt Kunden das setzen von SLAst im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Erlaubt Kunden das Setzen der Ticketpriorität im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            'Ermöglicht es Kunden, die Ticket-Queue in der Kunden-Oberfläche zu setzen. Wenn dies nicht aktiviert ist, so sollte die QueueDefault konfiguriert sein.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Ermöglicht es Kunden den Ticket-Service im Kunden-Interface einzustellen.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            'Allows customers to set the ticket type in the customer interface. Wenn dies nicht aktiviert ist, so sollte TicketTypeDefault konfiguriert sein.',
        'Allows default services to be selected also for non existing customers.' =>
            'Ermöglicht das Standard-Services auch für nicht angelegte Kunden ausgewählt werden können.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Erlaubt die Definition von Services und SLAs für Tickets (zum Beispiel: E-Mail, Desktop, Network, ...) und Eskalationsattributen für SLAs (wenn die Ticket Service/SLA Einstellung aktiviert ist).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Erlaubt erweiterte Suchbedingungen in der Ticket-Suche im Agenten-Interface. Mit dieser Funktion können Sie z. B. Ticket-Titel mit Bedingungen wie "(*key1*&&*key2*)" oder "(*key1*||*key2*)" durchsuchen.',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Erlaubt erweiterte Suchbedingungen in der Ticketsuche im Kundenbereich. Mit dieser Funktion können Sie z.B. Ticket-Titel mit Bedingungen wie "(key1&&key2)" oder "(key1||key2)" suchen.',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Erlaubt erweiterte Suchbedingungen in der Ticketsuche in der "Generic Agent"-Maske. Mit diesem Feature kann man z.B. Ticket-Titel mit Bedingungen wie "(*key1*&&*key2*)" oder "(*key1*||*key2*)" durchsuchen.',
        'Allows generic agent to execute custom modules.' => 'Ermöglicht es dem GenericAgent, benutzerdefinierte Module auszuführen.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Ermöglicht eine Ticket-Übersicht mit einigen Ticketinformationen (Customer => 1 - zeigt auch die Kundeninformation).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Ermöglicht die Benutzung der kleinenTicketübersicht (CustomerInfo => 1 - zeigt auch die Kundeninformation ).',
        'Allows invalid agents to generate individual-related stats.' => 'Erlaubt Agenten, die ungültig sind, individuelle Statistiken zu generieren.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Erlaubt Administratoren sich als Kunde über die Customer-User-Administrationsoberfläche anzumelden.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Erlaubt Administratoren sich als anderer Agent über die Agenten-Administrationsoberfläche anzumelden.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands in der "Schließen"-Maske im Agenten-Interface.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands in EMailOutbound im Agenten-Interface.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands in TicketCompose im Agenten-Interface.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands in der "Weiterleiten"-Maske im Agenten-Interface.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands im "Ticket kategorisieren"-Dialog im Agenten-Interface.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Bearbeitungsstands im "Verschieben"-Dialog im Agenten-Interface.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Notiz-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Besitzer-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Warten-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Eingehender-Anruf-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Ausgehender-Anruf-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Priorität-Bildschirm des Agentenbereichs.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            'Erlaubt das Speichern des aktuellen Stands als Entwurf im Verantwortlicher-Bildschirm des Agentenbereichs.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Erlaubt das Setzen eines neuen Ticket-Status im Verschieben-Bildschirm im Agenten-Interface.',
        'Always show RichText if available' => 'RichText immer verwenden, wenn verfügbar',
        'Answer' => 'Beantworten',
        'Appointment Calendar overview page.' => 'Terminkalender-Übersichtsseite.',
        'Appointment Notifications' => 'Terminbenachrichtigungen',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'Terminkalender Event-Modul, welches Benachrichtigungseinträge für Termine vorbereitet.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'Termin-Kalender Event-Modul, welches Tickets mit Daten aus Ticket-Terminen aktualisiert.',
        'Appointment edit screen.' => 'Terminbearbeitungsansicht.',
        'Appointment list' => 'Terminliste',
        'Appointment list.' => 'Terminliste.',
        'Appointment notifications' => 'Terminbenachrichtigungen',
        'Appointments' => 'Termine',
        'Arabic (Saudi Arabia)' => 'Arabisch (Saudi-Arabien)',
        'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            'Auswahl der Artikelattribute, die in der Maske für die Ticketinvoker-Konfiguration angezeigt werden sollen (0 = angezeigt/wählbar, 1 = Standard/vorausgewählt).',
        'ArticleTree' => 'Artikelbaum',
        'Attachment Name' => 'Name des Anhangs',
        'Autoloading of Znuny4OTOBOPasswordPolicy extensions.' => 'Automatisches Laden der \'Znuny4OTOBOPasswordPolicy\'-Erweiterungen.',
        'Automated line break in text messages after x number of chars.' =>
            'Automatischer Zeilenumbruch in Textnachrichten nach x-Zeichen.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            'Status eines Tickets mit ungültigem Besitzer bei Entsperren automatisch ändern. Bildet den neuen Ticketstatus entsprechend des Statustyps.',
        'Automatically generate statistics reports and email them to the specified recipients.' =>
            'Automatisch Statistikberichte erstellen und diese an definierte Empfänger versenden.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automatisches Sperren und setzen des aktuellen Agenten als Besitzer nachdem der Verschieben-Bildschirm im Agenten-Interface geöffnet wurde.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatisches Sperren und setzen des aktuellen Agenten als Besitzer nachdem der Sammelaktion-Bildschirm gewählt wurde.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Setzt den Besitzer eines Tickets automatisch auch als Verantwortlichen (wenn das Verantwortlicher-Feature aktiviert ist). Dies wird nur durch manuelle Aktionen des eingeloggten Benutzers ausgelöst, nicht durch automatische wie GenericAgent, Postmaster oder GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automatisches setzen eines Ticket-Verantwortlichen (wenn er noch nicht gesetzt wurde) nach dem ersten Besitzer-Update.',
        'Avatar' => 'Avatar',
        'Balanced white skin by Felix Niklas (slim version).' => 'Balanced White-Skin von Felix Niklas (slim version).',
        'Balanced white skin by Felix Niklas.' => 'Balanced White Skin von Felix Niklas.',
        'Based on global RichText setting' => 'Basierend auf der globalen Richtext-Einstellung',
        'Basic fulltext index settings. Execute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            'Basis-Einstellungen für den Volltext-Index. Führen Sie "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" aus, um den Index neu zu erstellen.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blockiert alle eingehenden E-Mails, die keine gültige Ticketnummer im Betreff mit Absenderadresse: @ example.com besitzen.',
        'Bounced to "%s".' => 'Bounced an "%s".',
        'Bulgarian' => 'Bulgarisch',
        'Bulk Action' => 'Sammel-Aktion',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD Beispiel-Setup. Ignoriert E-Mails, in denen ein externer CMD eine Ausgabe auf STDOUT liefert (E-Mail von some.bin wird in STDIN geleitet).',
        'CSV Separator' => 'Trennzeichen für CSV-Daten',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Cache-Zeit in Sekunden für Agent-Authentifizierungen im GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Cache-Zeit in Sekunden für Kunden-Authentifizierungen im GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Cache-Zeit in Sekunden für Datenbank ACL-Backends.',
        'Cache time in seconds for the DB process backend.' => 'Cache-Zeit in Sekunden für Datenbank Prozess-Backends.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Cache-Zeit in Sekunden für SSL-Zertifikatsattribute.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Cache-Zeit in Sekunden für das Ticket-Prozess-Navigationsleisten-Ausgabemodul.',
        'Cache time in seconds for the web service config backend.' => 'Cache-Zeit in Sekunden für das Webservice-Konfigurations-Backend.',
        'Calendar manage screen.' => 'Kalenderverwaltungsansicht.',
        'Cancel whole escalation if ticket is in configured suspend state (EscalationSuspendStates). Ticket will not escalate at all in configured suspend state. No escalation times are shown. Ticket will not be shown in escalation view.' =>
            'Vollständiges Unterbinden der Eskalation, solange sich das Ticket in einem zum Aussetzen der Eskalation konfigurierten Status (EscalationSuspendStates) befindet. In all diesen Status wird die Ticketeskalation vollständig unterbrochen. Es werden keine Eskalationszeiten angezeigt und das Ticket wird nicht in der Übersicht eskalierter Tickets aufgeführt.',
        'Catalan' => 'Katalanisch',
        'Categories used in ticket presentation. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'Kategorien für die Ticketdarstellung. Ist hier keine Standardfarbe angegeben, wird der Artikel nicht angezeigt, sofern im Color Hash keine Auswahl getroffen wurde. Optional kann das Attribut Text ergänzt werden, um den Feldwert zu überschreiben. Außerdem können Vorlagenmethoden verwendet werden (z.B. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Analog kann das Attribut Link auf die gleiche Weise verwendet werden.',
        'Categories used in ticket presentation. Order is only used to determine the starting position before size arrangement. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'In der Ticketdarstellung verwendete Kategorien. Die Reihenfolge hier bestimmt nur die Ausgangsposition vor der Größenanordnung. Ist keine Standardfarbe angegeben, wird das Element nicht angezeigt, sofern die Auswahl nicht im Farb-Hash definiert wurde. Optional kann das Attribut Text hinzugefügt werden, um den Feldwert zu überschreiben. Hierzu können Template-Methoden eingesetzt werden (z. B. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Das Attribut Link kann auf die gleiche Weise verwendet werden.',
        'Change Ticket' => 'Ticket kategorisieren',
        'Change Ticket information' => 'Ticketinformationen ändern',
        'Change queue!' => 'Queue ändern!',
        'Change the customer for this ticket' => 'Ticket-Kunden ändern',
        'Change the owner for this ticket' => 'Besitzer dieses Tickets ändern',
        'Change the priority for this ticket' => 'Priorität des Tickets ändern',
        'Change the responsible for this ticket' => 'Verantwortlichen für dieses Tickets ändern',
        'Change your avatar image.' => 'Avatar-Bild ändern.',
        'Change your password and more.' => 'Passwort und Weiteres ändern.',
        'Changed SLA to "%s" (%s).' => 'SLA geändert auf "%s" (%s).',
        'Changed archive state to "%s".' => 'Archivstatus geändert auf "%s".',
        'Changed customer to "%s".' => 'Kunde geändert auf "%s".',
        'Changed dynamic field %s from "%s" to "%s".' => 'Dynamisches Feld %s geändert von "%s" auf "%s".',
        'Changed owner to "%s" (%s).' => 'Besitzer geändert auf "%s" (%s).',
        'Changed pending time to "%s".' => 'Wartezeit geändert auf "%s".',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Priorität aktualisiert von "%s" (%s) nach "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => 'Queue geändert zu "%s" (%s) von "%s" (%s).',
        'Changed responsible to "%s" (%s).' => 'Verantwortlicher geändert auf "%s" (%s).',
        'Changed service to "%s" (%s).' => 'Service geändert auf "%s" (%s).',
        'Changed state from "%s" to "%s".' => 'Status geändert von "%s" auf "%s".',
        'Changed title from "%s" to "%s".' => 'Titel geändert von "%s" auf "%s".',
        'Changed type from "%s" (%s) to "%s" (%s).' => 'Typ geändert von "%s" (%s) auf "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Ändert den Besitzer der Tickets auf Alle (nützlich für ASP). In der Regel werden nur Agenten mit rw-Berechtigungen auf die Queue angezeigt.',
        'Chat communication channel.' => 'Kommunikationskanal Chat.',
        'Checkbox' => 'Kontrollkästchen',
        'Checks for articles that needs to be updated in the article search index.' =>
            'Prüft auf Artikel, die im Artikel-Suchindex aktualisiert werden müssen.',
        'Checks for communication log entries to be deleted.' => 'Prüft auf zu löschende Einträge im Kommunikationsprotokoll.',
        'Checks for queued outgoing emails to be sent.' => 'Prüft auf zu sendende ausgehende E-Mails.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Prüft, ob eine E-Mail ein Follow-Up zu einem bestehenden Ticket ist, indem der Betreff nach einer gültigen Ticketnummer durchsucht wird.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            'Prüft, ob eine E-Mail ein Follow-up zu einem bestehenden Ticket mit externer Ticketnummer ist, welches mit dem ExternalTicketNumberRecognition Filter gefunden werden kann.',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            'Ändert die SystemID in der Ticket-Nummernerkennung bei Rückfragen. Wenn nicht aktiviert, so wird die SystemID nach der Nutzung des Systems geändert.',
        'Child' => 'Kinder',
        'Chinese (Simplified)' => 'Chinesisch (vereinfacht)',
        'Chinese (Traditional)' => 'Chinesisch (traditionell)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Wählen Sie, für welche Art von Terminänderungen Sie Benachrichtigungen erhalten möchten.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Legen Sie fest, bei welchen Ticketänderungen Sie benachrichtigt werden möchten. Bitte beachten Sie, dass Sie Benachrichtigungen, die als verpflichtend markiert sind, nicht vollständig abschalten können.',
        'Choose which notifications you\'d like to receive.' => 'Legen Sie fest, welche Benachrichtigungen Sie erhalten möchten.',
        'Christmas Eve' => 'Heiligabend',
        'Close' => 'Schließen',
        'Close this ticket' => 'Dieses Ticket schließen',
        'Closed Tickets' => 'Geschlossene Tickets',
        'Closed tickets (customer user)' => 'Geschlossene Tickets (Kundenbenutzer)',
        'Closed tickets (customer)' => 'Geschlossene Tickets (Kunden)',
        'Cloud Services' => 'Cloud-Service',
        'Cloud service admin module registration for the transport layer.' =>
            'Cloud-Service-Admin-Modulregistrierung für den Transport-Layer.',
        'Collect support data for asynchronous plug-in modules.' => 'Sammelt Support Daten für asynchrone Erweiterungen.',
        'Color definitions for the customer interface.' => 'Farbdefinitionen für den Kundenbereich.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Ticket-Filter-Spalte für Ticketübersichten vom Typ "Klein".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, Dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Filterbare Spalten in der betreffenden Ansicht des Agentenbereichs. Hinweis: Nur Ticket-Attribute, dynamische Felder (DynamicField_NameX) und Kundenattribute (z. B. CustomerUserPhone, CustomerCompanyName) sind zulässig.',
        'Comment for new history entries in the customer interface.' => 'Kommentar für neue Historieneinträge im Kunden-Interface.',
        'Comment2' => 'Kommentar2',
        'Communication' => 'Kommunikation',
        'Communication & Notifications' => 'Kommunikation & Benachrichtigungen',
        'Communication Log GUI' => 'Kommunikationsprotokoll Benutzeroberfläche',
        'Communication log limit per page for Communication Log Overview.' =>
            'Limit für Protokolleinträge pro Seite in der Übersicht aller Verbindungsprotokolle.',
        'CommunicationLog Overview Limit' => 'Limit Verbindungsprotokoll-Übersicht',
        'Company Status' => 'Firmenstatus',
        'Company Tickets.' => 'Firmen-Tickets.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Firmenname, welcher in ausgehenden E-Mails als X-Header gesetzt werden soll.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Übergangsmodul für AgentZoom zu AgentTicketZoom.',
        'Complex' => 'Komplex',
        'Compose' => 'Verfassen',
        'Configure Processes.' => 'Prozesse verwalten.',
        'Configure and manage ACLs.' => 'ACLs konfigurieren und verwalten.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Konfigurieren Sie alle weiteren Readonly-Spiegeldatenbanken, die Sie verwenden möchten.',
        'Configure sending of support data to OTOBO Team for improved support.' =>
            'Konfigurieren Sie das Senden von Supportdaten an das OTOBO-Team für besseren Support.',
        'Configure the About information.' => 'About-Text / Impressum eingeben.',
        'Configure the privacy policy.' => 'Datenschutzhinweise bearbeiten.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Konfigurieren Sie, welche Oberfläche angezeigt werden soll, nachdem ein neues Ticket erstellt wurde.',
        'Configure your own log text for PGP.' => 'Konfigurieren Sie Ihren eigenen Log-Text für PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otobo.org/), chapter "Ticket Event Module".' =>
            'Konfiguriert eine TicketDynamicField-Standardeinstellung. "Name" definiert, welches dynamische Feld genutzt werden soll, "Value" die zu setzenden Daten, und "Event" das auslösende Ereignis. Mehr dazu im Kapitel "Ticket Event Module" des Developer Manuals (https://doc.otobo.org/).',
        'Controls how to display the ticket history entries as readable values.' =>
            'Kontrolliert wie die Ticket-Historie in lesbaren Werten dargestellt wird.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'Legt fest, ob die Absenderadresse bei unbekannten Kunden automatisch als Kundennummer gesetzt wird.',
        'Controls if CustomerID is read-only in the agent interface.' => 'Legt fest, ob die Kundennummer im Agentenbereich als nur lesend angezeigt wird.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Legt fest, ob Kunden die Möglichkeit haben ihre Tickets zu sortieren.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontrolliert, ob mehr als ein Eintrag in einem neuen Telefon-Ticket festgelegt werden kann.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Kontrolliert, ob es dem Admin erlaubt ist, eine gespeicherte Systemkonfiguration in SysConfig zu importieren.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Überprüft ob der Administrator die Berechtigung besitzt Änderungen in der Datenbank über die AdminSelectBox zu tätigen.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            'Legt fest, ob das Autovervollständigen-Feld in der Kundennummerauswahl des AdminCustomerUser-Bereichs genutzt werden soll.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontrolliert ob die Ticket- und Artikel "Gesehen"-Fähnchen entfernt werden, wenn ein Ticket archiviert wird.',
        'Converts HTML mails into text messages.' => 'Konvertiert HTML E-Mails in Textnachrichten.',
        'Create New process ticket.' => 'Neues Prozess-Ticket erstellen.',
        'Create Templates for AdminDynamicFieldTitle.' => 'Erstellt Vorlagen für AdminDynamicFieldTitle.',
        'Create Ticket' => 'Ticket erstellen',
        'Create a new calendar appointment linked to this ticket' => 'Erstellt einen neuen Termin in einem Kalender, welcher direkt mit diesem Ticket verknüpft ist',
        'Create and manage Service Level Agreements (SLAs).' => 'Service-Level-Vereinbarungen (SLAs) erstellen und verwalten.',
        'Create and manage agents.' => 'Agenten erstellen und verwalten.',
        'Create and manage appointment notifications.' => 'Terminbenachrichtigungen erstellen und verwalten.',
        'Create and manage attachments.' => 'Anhänge erstellen und verwalten.',
        'Create and manage calendars.' => 'Kalender erstellen und verwalten.',
        'Create and manage customer users.' => 'Kundenbenutzer erstellen und verwalten.',
        'Create and manage customers.' => 'Kunden erstellen und verwalten.',
        'Create and manage dynamic fields.' => 'Dynamische Felder erstellen und verwalten.',
        'Create and manage groups.' => 'Gruppen erstellen und verwalten.',
        'Create and manage queues.' => 'Queues erstellen und verwalten.',
        'Create and manage responses that are automatically sent.' => 'Vorlagen für automatische Antworten erstellen und verwalten.',
        'Create and manage roles.' => 'Rollen erstellen und verwalten.',
        'Create and manage salutations.' => 'Anreden erstellen und verwalten.',
        'Create and manage services.' => 'Services erstellen und verwalten.',
        'Create and manage signatures.' => 'Signaturen erstellen und verwalten.',
        'Create and manage templates.' => 'Vorlagen erstellen und verwalten.',
        'Create and manage ticket notifications.' => 'Ticket-Benachrichtigungen erstellen und verwalten.',
        'Create and manage ticket priorities.' => 'Ticket-Prioritäten erstellen und verwalten.',
        'Create and manage ticket states.' => 'Ticket-Status erstellen und verwalten.',
        'Create and manage ticket types.' => 'Ticket-Typen erstellen und verwalten.',
        'Create and manage web services.' => 'Webservices erstellen und verwalten.',
        'Create new Ticket.' => 'Neues Ticket erstellen.',
        'Create new appointment.' => 'Einen neuen Termin erstellen.',
        'Create new email ticket and send this out (outbound).' => 'Neues E-Mail-Ticket erstellen und versenden (ausgehend).',
        'Create new email ticket.' => 'Neues E-Mail-Ticket erstellen.',
        'Create new phone ticket (inbound).' => 'Neues Telefon-Ticket erstellen (eingehend).',
        'Create new phone ticket.' => 'Neues Telefon-Ticket erstellen.',
        'Create new process ticket.' => 'Neues Prozess-Ticket erstellen.',
        'Create tickets.' => 'Tickets erstellen.',
        'Create your first ticket' => 'Ihr erstes Ticket erstellen',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            'Ticket erstellt [%s] in "%s" mit Priorität "%s" und Status "%s".',
        'Croatian' => 'Kroatisch',
        'Custom RSS Feed' => 'Benutzerspezifischer RSS Feed',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Benutzerdefinierter Text für Kunden, die noch keine Tickets haben (wenn Sie für diesen Text eine Übersetzung wünschen, fügen Sie die Übersetzung in einem eigenen Übersetzungsmodul hinzu).',
        'Customer Administration' => 'Kundenverwaltung',
        'Customer Companies' => 'Kunden',
        'Customer Dashboard' => 'Kunden-Dashboard',
        'Customer Dynamic Field Database Detailed Search' => 'Customer Dynamic Field Database Detailed Search',
        'Customer Dynamic Field Database Details' => 'Customer Dynamic Field Database Details',
        'Customer Dynamic Field Database Search' => 'Customer Dynamic Field Database Search',
        'Customer IDs' => 'Kundennummern',
        'Customer Information Center Search.' => 'Kunden-Informationszentrum-Suche.',
        'Customer Information Center search.' => 'Kunden-Informationszentrum-Suche.',
        'Customer Information Center.' => 'Kunden-Informationszentrum.',
        'Customer Password.' => 'Kunden-Passwort.',
        'Customer Ticket Print Module.' => 'Kunden-Ticketdruck-Modul.',
        'Customer User Administration' => 'Kundenbenutzer-Verwaltung',
        'Customer User Information' => 'Kundenbenutzerinformation',
        'Customer User Information Center Search.' => 'Suche Kundenbenutzer-Informationszentrum.',
        'Customer User Information Center search.' => 'Kundenbenutzer-Informationszentrum-Suche.',
        'Customer User Information Center.' => 'Kundenbenutzer-Informationszentrum.',
        'Customer Users ↔ Customers' => 'Kundenbenutzer ↔ Kunden',
        'Customer Users ↔ Groups' => 'Kundenbenutzer ↔ Gruppen',
        'Customer Users ↔ Services' => 'Kundenbenutzer ↔ Services',
        'Customer dynamic field database detailed search.' => 'Detailsuche dynamisches Feld Datenbank im Kundenbereich.',
        'Customer dynamic field database details.' => 'Details zum dynamischen Feld Datenbank im Kundenbereich.',
        'Customer dynamic field database search.' => 'Suche im dynamischen Feld Datenbank im Kundenbereich.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kunden-Element (Symbol), das die geschlossenen Tickets dieses Kunden als Infoblock anzeigt. Setzen Sie die Einstellung "CustomerUserLogin" auf 1, um Tickets auf Basis des Login-Namens statt der CustomerID zu suchen.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kunden-Elememt (Symbol), das die offenen Tickets dieses Kunden als Infoblock anzeigt. Setzen Sie die Einstellung "CustomerUserLogin" auf 1, um Tickets auf Basis des Login-Namens statt der CustomerID zu suchen.',
        'Customer preferences.' => 'Kunden-Einstellungen.',
        'Customer ticket overview' => 'Kunden-Ticket-Übersicht',
        'Customer ticket search.' => 'Kunden-Ticketsuche.',
        'Customer ticket zoom' => 'Ticketansicht für Kunden',
        'Customer user search' => 'Kundenbenutzersuche',
        'CustomerID search' => 'Kundennummern-Suche',
        'CustomerName' => 'Kundenname',
        'CustomerUser' => 'Kundenbenutzer',
        'Customers ↔ Groups' => 'Kunden ↔ Gruppen',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'Anpassbare Stopworte für den Volltext-Index. Diese Worte werden aus dem Suchindex entfernt.',
        'Czech' => 'Tschechisch',
        'Danish' => 'Dänisch',
        'Dashboard overview.' => 'Dashboardübersicht.',
        'Data used to export the search result in CSV format.' => 'Daten die verwendet werden um das Suchergebnis im CSV-Format zu exportieren.',
        'Date / Time' => 'Datum / Zeit',
        'Default (Slim)' => 'Standard (Schlank)',
        'Default ACL values for ticket actions.' => 'Standard ACL-Werte für Ticketaktionen.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Standard Entitäts-Präfixe des Prozessmanagements für Entitäts-IDs, die automatisch generiert werden.',
        'Default agent name' => 'Standard-Agentenname',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Standarddaten, die als Attribute für die für die Ticket-Suchmaske verwendet werden. Beispiel: "TicketCreateTimePointFormat = Jahr; TicketCreateTimePointStart = Letzter; TicketCreateTimePoint = 2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Standarddaten, die als Attribute für die für die Ticket-Suchmaske verwendet werden. Beispiel: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Standard Anzeigetyp für Empfängernamen(To, Cc) in AgentTicketZoom und CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Standard-Anzeigetyp für Absender-Namen (Von) in AgentTicketZoom und CustomerTicketZoom.',
        'Default loop protection module.' => 'Standard "Loop Protection"-Modul.',
        'Default queue ID used by the system in the agent interface.' => 'Standard-Queue-ID welche von OTOBO in der Agentenoberfläche verwendet wird.',
        'Default skin for the agent interface (slim version).' => 'Standard-Skin für die Agentenoberfläche (Slim version).',
        'Default skin for the agent interface.' => 'Standard-Skin für das Agenten-Interface.',
        'Default skin for the customer interface.' => 'Standard-Skin für das Kunden Interface.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Standard-Ticket-ID welche von OTOBO in der Agentenoberfläche verwendet wird.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Standard-Ticket-ID welche von OTOBO in der Kundenoberfläche verwendet wird.',
        'Default value for NameX' => 'Standardwert für NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Definieren Sie Actions, in denen im Verknüpfte-Objekte-Widget ein Einstellungen-Knopf verfügbar sein soll (LinkObject::ViewMode = "complex"). Bitte beachten Sie, dass für diese Actions die folgenden JS- und CSS-Dateien registriert sein müssen: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer bestimmten Zeichenfolge hinzufügen. Dieses Element erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTOBO-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            'Definiert eine Zuordnung zwischen den Variablen zu Kundenbenutzerdaten (Schlüssel) und dynamischen Feldern eines Tickets (Werte). Somit können Sie die Kundenbenutzerdaten eines Tickets in dynamische Felder speichern. Diese dynamischen Felder müssen im System vorhanden sein und sollten für AgentTicketFreeText aktiviert werden, damit sie definiert / manuell durch den Agenten aktualisiert werden können. Sie dürfen nicht für AgentTicketPhone, AgentTicketEmail und AgentTicketCustomer aktiviert werden. Werden sie dies, so haben sie Vorrang gegenüber den automatisch gesetzten Werten. Um dieses Mapping zu verwenden, müssen Sie auch die Ticket-Einstellung Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser aktivieren.',
        'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).' =>
            'Definieren Sie ein Ergebnisfeld für die TicketID des Invoker Response per Webservice (WebserviceID => DynamicFieldName).',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiert dynamische Feldnamen für die Endzeit. Dieses Feld muss manuell im System als Ticket: "Datum / Uhrzeit" hinzugefügt werden und muss in Ticketerstellungsoberflächen und / oder in anderen Ticket-Aktionsoberflächen aktiviert werden.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiert dynamische Feldnamen für die Startzeit. Dieses Feld muss manuell im System als Ticket: "Datum / Uhrzeit" hinzugefügt werden und muss in Ticketerstellungsoberflächen und / oder in anderen Ticket-Aktionsoberflächen aktiviert werden.',
        'Define the max depth of queues.' => 'Definiert die maximale Tiefe von Queues.',
        'Define the queue comment 2.' => 'Definiert den 2. Queue-Kommentar.',
        'Define the service comment 2.' => 'Lege den Servicekommentar 2 fest.',
        'Define the sla comment 2.' => 'Lege den SLA-Kommentar 2 fest.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Definiert den Wochentag, mit dem die Woche im angegebenen Kalender beginnt.',
        'Define the start day of the week for the date picker.' => 'Definiert den Beginn einer Woche für den Datumswähler.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Definiert welches Avatar-Standardbild in der Artikel-Ansicht verwendet werden soll, wenn kein Gravatar für die Mailadresse des Agents zugeordnet ist. Siehe https://gravatar.com/site/implement/images/ für weitere Informationen.',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Definiert welches Avatar Standardbild für den aktuellen Agent verwendet werden soll, wenn kein Gravatar für die Mailadresse des Agents zugeordnet ist. Siehe https://gravatar.com/site/implement/images/ für weitere Informationen.',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            'Legt fest, welche Avatar-Engine für die Avatare im Kopf der Software und die Absenderbilder in AgentTicketZoom genutzt werden soll. Wenn \'Keine\' ausgewählt ist, werden stattdessen die Initialen des jeweiligen Nutzers angezeigt. Bitte beachten Sie, dass jede Auswahl außer \'Keine\' dazu führt, dass die verschlüsselte E-Mail-Adresse des jeweiligen Nutzers an einen externen Dienst übertragen wird.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Legt fest welche Spalten im Terminverknüpfungs-Widget angezeigt werden (LinkObject::ViewMode = "complex"). Mögliche Einstellungen: 0 = Deaktiviert, 1 = Verfügbar, 2 = Standardmäßig aktiviert.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Definieren Sie, welche Spalten im verlinkte Tickets-Widget sichtbar sein sollen (LinkObject::ViewMode = "complex"). Hinweis: Nur Ticket-Attribute und dynamische Felder (DynamicField_NameX) sind als Standard-Spalten erlaubt.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definiert ein Kunden-Element, welches ein LinkedIn-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definiert ein Kunden-Element, welches ein XING-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definiert ein Kunden-Element, welches ein Google-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definiert ein Kunden-Element, welches ein Google-Maps-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter CVE-Nummern hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTOBO-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer MSBulletin-Nummer hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTOBO-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer bestimmten Zeichenfolge hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTOBO-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter Bugtraq-Nummern hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTOBO-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Definiert einen Filter zum Sammeln von CVE-Nummern von Artikel-Texten im AgentTicketZoom. Das Ergebnis wird in einer Meta-Box neben dem Artikel angezeigt. Füllen Sie URLPreview aus, wenn Sie beim halten des Cursors über dem Linkelement eine Vorschau sehen möchten. Das kann dieselbe URL wie in "URL", aber auch eine andere. Bitte beachten Sie, dass einige Webseiten es verbieten in einem iframe (z.B. Google) angezeigt zu werden. Diese würden mit dem Vorschau-Modus nicht funktionieren.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definiert einen Filter, um den Text in den Artikel zu verarbeiten, um vordefinierte Schlüsselwörter zu markieren.',
        'Defines a permission context for customer to group assignment.' =>
            'Bestimmt einen Berechtigungskontext für die Kunden-Gruppen-Zuweisung.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definiert Regular-Expressions die einige Adressen von der Syntaxprüfung ausschließt (wenn "CheckEmailAddresses" auf \'"Ja" gesetzt ist). Bitte geben Sie in diesem Feld eine Regex für E-Mail-Adressen an, die syntaktisch nicht gültig, aber für das System (z.B.: "root@localhost") notwendig sind.',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definiert einen regulären Ausdruck, der alle E-Mail-Adressen filtert, die in der Anwendung nicht verwendet werden sollen.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Definiert einen Zeitraum in Mikrosekunden, der zwischen der Verarbeitung von Tickets abgewartet werden soll.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definiert ein nützliches Modul um bestimmte User-Optionen zu laden oder um Neuigkeiten anzuzeigen.',
        'Defines all the X-headers that should be scanned.' => 'Definiert alle X-Headers, die überprüft werden sollen.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Definiert alle Sprachen, die der Applikation zur Verfügung stehen. Geben Sie nur Englische Sprachnamen an.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Definiert alle Sprachen, die der Applikation zur Verfügung stehen. Geben Sie nur die einheimischen Sprachnamen an.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definiert alle Parameter für das Objekt RefreshTime in den Kundeneinstellungen des Kunden-Interface.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definiert alle Parameter für das Objekt ShownTickets in den Kundeneinstellungen des Kunden-Interface.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definiert alle Parameter für dieses Element in den Kunden-Einstellungen.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Legt alle Parameter für dieses Element in den Kunden-Einstellungen fest. Mit \'PasswordRegExp\' können Passwörter gegen einen regulären Ausdruck geprüft werden. Mit \'PasswordMinSize\' definieren Sie die Mindestlänge von Passwörtern. Bestimmen Sie, ob das Passwort mindestens zwei Kleinbuchstaben und zwei Großbuchstaben enthalten muss, indem Sie die entsprechende Option auf \'1\' setzen. \'PasswordMin2Characters\' legt fest, dass mindestens zwei Buchstaben-Zeichen erforderlich sind. \'PasswordNeedDigit\' legt fest, dass das Passwort mindestens eine Ziffer enthalten muss.',
        'Defines all the parameters for this notification transport.' => 'Steuert alle Parameter für diesen Benachrichtigungs-Transport.',
        'Defines all the possible stats output formats.' => 'Definiert alle möglichen Statistikausgabeformate.',
        'Defines an alternate URL, where the login link refers to.' => 'Definiert eine alternative URL, auf die der Login-Link verweist.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definiert eine alternative URL, auf die der Logout-Link verweist.',
        'Defines an alternate login URL for the customer panel..' => 'Definiert für die Kundenoberfläche eine alternative Anmelde-URL, auf die der Login-Link verweist.',
        'Defines an alternate logout URL for the customer panel.' => 'Definiert für die Kundenoberfläche eine alternative Abmelde-URL, auf die der Logout-Link verweist.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Definiert eine externen Verbindung zu einer Kundendatenbank (z.B.: \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'Beschreibt ein Symbol mit Verknüpfung zur Google Maps Webseite mit dem aktuellen Standort als entsprechendes Ziel in der Terminbearbeitungs-Oberfläche.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'Definiert ein Übersichtsmodul, dass eine Adressbuchansicht der Kundenbenutzerliste anzeigt.',
        'Defines available article actions for Chat articles.' => 'Legt verfügbare Artikel-Aktionen für Chat-Artikel fest.',
        'Defines available article actions for Email articles.' => 'Legt verfügbare Artikel-Aktionen für E-Mail-Artikel fest.',
        'Defines available article actions for Internal articles.' => 'Legt verfügbare Artikel-Aktionen für interne Artikel fest.',
        'Defines available article actions for Phone articles.' => 'Legt verfügbare Artikel-Aktionen für Telefon-Artikel fest.',
        'Defines available article actions for invalid articles.' => 'Legt verfügbare Artikel-Aktionen für ungültige Artikel fest.',
        'Defines available groups for the admin overview screen.' => 'Legt verfügbare Gruppen für die Administrator-Übersicht fest.',
        'Defines chat communication channel.' => 'Legt den Chat-Kommunikationskanal fest.',
        'Defines default headers for outgoing emails.' => 'Legt die Standard-Header für ausgehende E-Mails fest.',
        'Defines email communication channel.' => 'Legt den E-Mail-Kommunikationskanal fest.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definiert aus welchen Ticket-Attributen der Agent die Ergebnissortierung wählen kann.',
        'Defines groups for preferences items.' => 'Legt die Gruppen für die persönlichen Einstellungen fest.',
        'Defines how many deployments the system should keep.' => 'Legt fest, wieviele Versionen von Inbetriebnahmen im System behalten werden sollen.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definiert, wie das "Von:"-Feld in den E-Mails (gesendet von Antworten und E-Mail-Tickets) aussehen soll.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Definiert ob in der Queue-Ansicht eine Vorsortierung anhand der Priorität vorgenommen werden soll.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Bestimmt, ob in der Service-Ansicht eine Vorsortierung anhand der Priorität vorgenommen werden soll.',
        'Defines if a ticket lock is required for the quick close.' => 'Definiert, ob ein Ticket gesperrt werden muss, um sofort geschlossen werden zu können.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Steuert, ob Agenten, die kein gemeinsames Geheimnis in ihren Einstellungen hinterlegt haben und folglich die Zweifaktor-Authentifizierung nicht nutzen, sich im System einloggen dürfen.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Steuert, ob Kunden, die kein gemeinsames Geheimnis in ihren Einstellungen hinterlegt haben und folglich die Zweifaktor-Authentifizierung nicht nutzen, sich im System einloggen dürfen.',
        'Defines if the communication between this system and the servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as support data sending, Package Verify™ and product News dashboard widgets, among others.' =>
            'Legt fest, ob eine Kommunikation zwischen diesem System und den Servern, über die Cloud Services angeboten werden, möglich ist. Deaktivieren Sie hier die Cloud Services, geht ein Teil der Funktionalität wie der Versand von Supportdaten, Package Verify™ und das "Produkt-Neuigkeiten"-Dashboard-Widget verloren.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'Legt fest, ob im Kundenbereich der erweiterte Modus genutzt werden soll (erlaubt die Nutzung von Tabellen, Ersetzen, Hochstellen, Tiefstellen, Einfügen aus Word, usw.).',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Bestimmt, ob der erweiterte Modus genutzt werden soll (schaltet die Benutzung von Tabellen, Suchen & Ersetzen, Tiefstellen, Hochstellen, aus Word einfügen, etc. frei).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            'Gibt an, ob der erste für den Kunden sichtbare Artikel beim Öffnen der Übersichtsansicht aufgeklappt dargestellt werden soll. Wenn nichts angegeben ist, wird der neueste Artikel aufgeklappt dargestellt.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Nachricht im Bildschirm für ausgehende E-Mails des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Nachricht im Bildschirm für neu zu sendende E-Mails des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Nachricht im Verfassen-Bildschirm des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Nachricht im Weiterleiten-Bildschirm des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zum Schließen von Tickets des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zur Stapelverarbeitung von Tickets des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm für Freitextfelder des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zum Erfassen von Notizen des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Besitzer-Bildschirm des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zum Setzen von Wartezeiten des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zum Setzen einer Priorität des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            'Gibt an, ob die Notiz im Bildschirm zum Setzen eines Verantwortlichen des Agentenbereichs standardmäßig für den Kunden sichtbar sein soll.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Steuert, ob das vorherige, gültige Token für die Authentifizierung akzeptiert werden soll. Dies ist etwas weniger sicher, gibt Nutzern aber 30 Sekunden mehr Zeit, Ihre Einmal-Passwort einzugeben.',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'Definiert, ob die Werte für Filter von allen verfügbaren Tickets abgerufen werden sollen. Wenn aktiviert, stehen für die Filterung nur Werte zur Verfügung, die aktuell in irgendeinem Ticket verwendet werden. Bitte beachten Sie: Die Liste der Kunden wird immer auf diesem Wege abgerufen.',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Definiert ob die Zeiterfassung verpflichtend im Agenten-Interface ist. Wenn diese Funktion aktiviert ist, muss eine Notiz für alle Ticketaktionen (egal ob die Notiz als aktiv konfiguriert ist oder ursprünglich zwingend für die individuellen Ticket-Aktionen konfiguert wurde).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Bestimmt, ob das Zeiterfassungs-Feld für alle Tickets im Stapelverarbeitungs-Bildschirm gesetzt werden soll.',
        'Defines internal communication channel.' => 'Legt den internen Kommunikationskanal fest.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Definiert "Nicht im Büro"-Nachrichten-Templates. Zwei String-Parameter (%s) stehen zur Verfügung: Enddatum und Anzahl der übrigen Tage.',
        'Defines phone communication channel.' => 'Legt den Telefon-Kommunikationskanal fest.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Bestimmt die Queues, deren Tickets für die Anzeige als Kalender-Ereignisse berücksichtigt werden sollen.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Legt den HTTP-Hostnamen fest, der für die Sammlung von Supportdaten über das freie Modul \'PublicSupportDataCollector\' genutzt wird (z. B. durch den OTOBO-Daemon).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Definiert die Regular Expressions für IPs für den Zugriff auf das lokale Repository. Sie müssen diese Einstellungen aktivieren um Zugang zu Ihrem lokalen Repository zu haben, ebenfalls muss das Paket package::RepositoryList auf dem Remote-Host installiert sein.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'Bestimmt den Postmaster-Header im Filter, um den aktuellen Ticketstatus beizubehalten.',
        'Defines the URL CSS path.' => 'Definiert den URL-CSS-Pfad.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definiert den URL-Basispfad von Symbolen, CSS und JavaScript.',
        'Defines the URL image path of icons for navigation.' => 'Definiert den URL des Bildpfads von Symbolen für die Navigation.',
        'Defines the URL java script path.' => 'Definiert den URL des JavaScript-Pfads.',
        'Defines the URL rich text editor path.' => 'Definiert den URL-RichTextEditor-Pfad.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definiert die Adresse eines dedizierten DNS-Server, wenn nötig, für "CheckMXRecord" Auflösungen.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Defininiert das Einstellungsfeld für Agenten, in dem der Share Secret-Key gespeichert wird.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            'Legt die verfügbaren Schritte in Zeitauswahlfeldern fest. Wähle Sie "Minuten", um alle Minuten einer Stunde von 1-59 auswählen zu können. Wählen Sie "30 Minuten", um nur ganze und halbe Stunden auswählbar zu machen.',
        'Defines the body for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Body für die Aktion "Sofort Schließen", die in der Ticket-Historie im Agentenbereich verwendet wird.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails an Agenten betreffend dem neuen Passwort.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            'Legt den Fließtext der Benachrichtigungs-E-Mail fest, die bei einer Passwortanfrage an Agenten verschickt wird.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails, die wegen eines neuen Accounts an Kunden geschickt wird.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails an Kunden betreffend dem neuen Passwort.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            'Definiert den Text für Benachrichtigungs-E-Mails mit dem Token für neu generierte Passwörter, die an Kunden geschickt wird.',
        'Defines the body text for rejected emails.' => 'Definiert den Body-Text für abgelehnte E-Mails.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definiert die Kalenderbreite in Prozent. Standard ist 95%.',
        'Defines the close state for quick close.' => 'Definiert den Schließen-Status für "Sofort Schließen".',
        'Defines the column to store the keys for the preferences table.' =>
            'Definiert die Spalte, in der die Schlüssel für die Tabelle mit den Einstellungen gespeichert werden sollen.',
        'Defines the communication chanel for the quick close article action.' =>
            'Definiert den Kommunikationskanal für die Artikelaktion "Sofort schließen".',
        'Defines the config options for the autocompletion feature.' => 'Definiert die Konfigurationsoptionen für die Autovervollständigung.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definiert die Konfigurationsparamenter des Eintrages, der in der Benutzereinstellung angezeigt wird.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definiert die Konfigurationsparamenter des Items, die in der Benutzereinstellung angezeigt wird. PasswordRegExp\' erlaubt das Prüfen von Passwörtern gegen einen regulären Ausdruck. Legen Sie die Mindestlänge für Passwörter mit \'PasswordMinSize\' fest. Legen Sie fest, ob das Passwort mindestens zwei Kleinbuchstaben und zwei Großbuchstaben enthalten muss, indem Sie die entsprechende Option auf \'1\' setzen. \'PasswordMin2Characters\' legt fest, dass mindestens zwei Buchstaben-Zeichen erforderlich sind (mögliche Werte sind \'0\' oder \'1\'). \'PasswordNeedDigit\' legt fest, ob das Passwort mindestens eine Zahl enthalten muss (mögliche Werte sind \'0\' oder \'1\'). \'PasswordMaxLoginFailed\' erlaubt es einen Agenten auf temporär ungültig wenn die maximale Anzahl fehlerhafter Logins erreicht ist. Bitte beachte: Wenn \'Active\' auf 0 eingestellt ist, so verhindert dies nur, dass Agenten die Einstellung dieser Gruppe in ihren persönlichen Einstellungen verändern können. Der Administrator kann weiterhin diese Einstellungen im Name von Benutzern verändern. Benutze \'PreferenceGroup\', um zu steuern, in welchem Bereich diese Einstellungen in der Benutzer-Oberfläche angezeigt werden.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definiert die Konfigurationsparamenter des Items, die in der Benutzereinstellung angezeigt wird. Bitte beachte: Wenn \'Active\' auf 0 eingestellt ist, so verhindert dies nur, dass Agenten die Einstellung dieser Gruppe in ihren persönlichen Einstellungen verändern können. Der Administrator kann weiterhin diese Einstellungen im Name von Benutzern verändern. Benutze \'PreferenceGroup\', um zu steuern, in welchem Bereich diese Einstellungen in der Benutzer-Oberfläche angezeigt werden.',
        'Defines the connections for http/ftp, via a proxy.' => 'Definiert Verbindungen für HTTP/FTP über einen Proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Defininiert das Einstellungsfeld für Kunden, in dem der Share Secret-Key gespeichert wird.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Definiert das benutzte Datumseingabeformat in Formularen (Option für Eingabefelder).',
        'Defines the default CSS used in rich text editors.' => 'Definiert die genutzte Standard-CSS in RichText-Editoren.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            'Definiert den Standard-Agentennamen in der Ticket-Detailansicht des Kunden-Interface.',
        'Defines the default auto response type of the article for this operation.' =>
            'Definiert den Standard-Auto-Antwort-Typ des Artikels für diese Operation.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Definiert den Standard-Inhalt einer Notiz in der TicketFreeText-Oberfläche im Agenten-Interface.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            'Definiert die Standard-Filterfelder in der Kundenbenutzer-Adressbuch-Suche (Kundenbenutzer oder Kundenunternehmen). Für Kundenunternehmen-Felder muss ein Präfix \'CustomerCompany_\' hinzugefügt werden.',
        'Defines the default frontend (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otobo.org/.' =>
            '',
        'Defines the default frontend language. All the possible values are determined by the available language files on the system. These values are listed as the keys in the setting \'DefaultUsedLanguages\'.' =>
            '',
        'Defines the default history type in the customer interface.' => 'Definiert den Standard-Historientyp im Kunden-Interface.',
        'Defines the default interface. Unknown pathes below the script alias are redirected to the selected interface.' =>
            'Definieren der Standardschnittstelle. Unbekannte Pfade unter dem Skript-Alias werden auf die ausgewählte Schnittstelle weitergeleitet.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Definiert die standardmäßig eingestellte maximale Anzahl von Attributen für die x-Achse für die Zeitachse.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Steuert die maximale Anzahl angezeigter Statistiken pro Seite in der Übersicht.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Steuert den Folgestatus für Tickets, für die im Kundenbereich eine Kundennachfrage eingegangen ist.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Schließen-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Freitextfelder-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Notiz-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Besitzer-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Warten bis-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Prioritäts-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Verantwortlicher-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Umleiten-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Weiterleiten-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, nachdem eine ausgehende E-Mail versendet wurde.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, auf die ein Agent im Antworten-Bildschirm im Agenten-Interface geantwortet hat.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Definiert den standardmäßigen Folgestatus für ein Ticket in der Stapelverarbeitungs-Ansicht im Agenten-Interface.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt die Vorbelegung des Textfeldes für Telefon-Tickets im Bildschirm für eingehende Anrufe im Agenten-Interface.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt die Vorbelegung des Textfeldes für Telefon-Tickets im Bildschirm für ausgehende Anrufe im Agenten-Interface.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Steuert die Folgepriorität für Tickets, für die im Kundenbereich eine Kundennachfrage eingegangen ist.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Definiert die Standard-Prioriät von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default priority of new tickets.' => 'Definiert die Standard-Priorität von neuen Tickets.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Definiert die Standard-Queue von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default queue for new tickets in the agent interface.' =>
            'Definiert die Standard-Queue für neue Tickets im Agentenbereich fest.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definiert die Standardauswahl in der Einfachauswahl für dynamische Objekte (Formular: genauere Spezifikation).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Definiert die Standardauswahl im Dropdown-Menü für Berechtigungen (Formular: Allgemeine Angaben).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Legt die Standardauswahl im Dropdown-Menü für das Statistik-Format (Form: Gemeinsame Spezifikation) fest. Bitte legen Sie die Formattaste fest (siehe Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt den Standard-Absendertyp für Telefon-Tickets in der Eingehende-Telefon-Tickets-Anzeige im Agenten-Interface.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt den Standard-Absendertp für Telefon-Tickets in der Ausgehende-Telefon-Tickets-Anzeige in der Agenten-Oberfläche.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Bestimmt den Standard-Absendertp für Telefon-Tickets in der TicketZoom-Anzeige in der Agenten-Oberfläche.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Definiert das standardmäßig angezeigte Ticket-Such-Attribut für die Ticket-Suchmaske (AlleTickets/ArchivierteTickets/NichtArchivierteTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Definiert die standardmäßig angezeigten Ticketsuchattribute für die Ticketsuche.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Definiert die Standard Suchattribute für die Ticketsuche Beispiel: "Key" muss den Namen des dynamischen Feldes haben, in diesem Fall \'X\', "Content" muss den Wert des dynamischen Feldes, abhängig vom Feldtyp, haben, Text: \'ein Text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Queue-Ansicht angezeigten Queues.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Service-Ansicht angezeigten Services.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Queue-Ansicht angezeigten Queues, nachdem nach Priorität sortiert wurde.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Service-Ansicht angezeigten Services, nachdem nach Priorität sortiert wurde.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definiert den Standard-Status von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default state of new tickets.' => 'Definiert den Standard-Status von neuen Tickets.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Telefon-Tickets in der Eingehende-Telefon-Tickets-Anzeige in der Agent-Oberfläche.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Telefon-Tickets in der Ausgehende-Telefon-Tickets-Anzeige in der Agent-Oberfläche.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff einer Notiz im Ticket-Freitext-Bildschirm des Agenten-Interfaces.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Definiert die Anzahl an Sekunden (ausgehend vom aktuellen Zeitpunkt), nach denen ein fehlgeschlagener Generic Interface-Task neu geplant werden soll.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in einer Ticket-Suche im Kunden-Interface.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Eskalations-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Gesperrte-Tickets-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Verantwortlicher-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Status-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Beobachten-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets des Ticket-Suchergebnis im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets im Ticket-Suchergebnis von dieser Operation.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Definiert die Standardbenachrichtigung für umgeleitete Tickets für Kunden/Absender im Umleiten-Bildschirm des Agentenbereichs.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Steuert den Ticketstatus, nachdem eine Notiz über den "Ausgehender Anruf"-Bildschirm im Agentenbereich hinzugefügt wurde.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Steuert den Ticketstatus, nachdem eine Notiz über den "Ausgehender Anruf"-Bildschirm im Agentenbereich hinzugefügt wurde.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung (nach der Sortierung nach Priorität) für die Eskalations-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung (nach der Sortierung nach Priorität) für die Status-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Verantwortlicher-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Gesperrt-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Suchergebnis-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Suchergebnis-Ansicht dieser Operation. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Beobachten-Ansicht des Agentenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Steuert die Ticket-Sortierung für die Suchergebnis-Ansicht des Kundenbereichs. Auf: Älteste oben. Ab: Neuste oben.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Schließen\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Sammelaktion\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Freie Felder\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Notiz\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Besitzer\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Warten\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Priorität\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Verantwortlicher\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Definiert den Standard-Ticket-Typ für neue Kundentickets in der Kundenoberfläche.',
        'Defines the default ticket type.' => 'Definiert den Standardtyp für ein Ticket.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Definiert das standardmäßig genutzte Frontend-Modul im Agenten-Interface, wenn kein Action-Paramenter in der URL übergeben wurde.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Definiert das standardmäßig genutzte Frontend-Modul im Kunden-Interface, wenn kein Action-Paramenter in der URL übergeben wurde.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Definiert den Standard-Wert für den Action-Paramenter im Public-Frontend. Der Action-Paramter wird in System-Skripten vewendet.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definiert die standardmäßigen sichtbaren Sendertypen eines Tickets (Standard: Kunde).',
        'Defines the default visibility of the article to customer for this operation.' =>
            'Legt die Standardsichtbarkeit des Artikels für Kunden für diese Operation fest.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            'Definiert den angezeigten Stil des Feldes "Von" in Notizen, die für Kunden sichtbar sind. Ein Standard-Agentenname kann in der Einstellung Ticket::Frontend::CustomerTicketZoom####DefaultAgentName definiert werden.',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definiert die dynamischen Felder, die benutzt werden um Kalender-Events anzuzeigen.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'Legt die Event-Objekttypen fest, welche via AdminAppointmentNotificationEvent verarbeitet werden.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Steuert den Fallback-Pfad zum Öffnen des fetchmail-Binaries. Hinweis: Der Name des Binaries muss "fetchmail" sein. Bitte nutzen Sie einen symbolischen Link, wenn der Name anders lautet.',
        'Defines the filter that processes the HTML templates.' => 'Definiert den zum Verarbeiten der HTML-Vorlagen verwendeten Filter.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definiert den Filter, der Text in Artikeln verarbeitet, um URLs zu highlighten.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Steuert das Format von Antworten im Ticket erstellen-Bildschirm im Agentenbereich ([% Data.OrigFrom | html %] entspricht genau dem Absender, [% Data.OrigFromName | html %] enthält nur den realen Namen des Absenders).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTOBO_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Definiert den Full Qualified Domain Name des OTOBO Systems. Diese Einstellung wird als Variable OTOBO_CONFIG_FQDN genutzt, welche in allen Nachrichten-Formularen zu finden ist oder um Links zu Tickets in Ihrem OTOBO System zu generieren.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            'Steuert die Gruppen, in denen sich ein Kundenbenutzer standardmäßig befinden soll (wenn CustomerGroupSupport aktiviert ist und Sie nicht jede Gruppenbeziehung für die Nutzer einzeln steuern möchten).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            'Steuert die Gruppen, in denen sich ein Kunde standardmäßig befinden soll (wenn CustomerGroupSupport aktiviert ist und Sie nicht jede Gruppenbeziehung für die Kunden einzeln steuern möchten).',
        'Defines the headers which will be shown to generic content for the requested key.' =>
            'Definiert die Header, die für allgemeine Inhalte für den angefragten Wert angezeigt werden.',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Höhe der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Steuert die Höhe der Richtext-Editor-Komponente. Geben Sie eine Zahl (für die Höhe in Pixeln) oder einen prozentualen Wert (für eine relative Höhe) an.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Steuert den Historien-Kommentar für die Ticket schließen-Aktion im Agentenbereich.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Steuert den Historien-Kommentar für Emailtickets im Agentenbereich.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Steuert den Historien-Kommentar für Telefon-Ticket im Agentenbereich.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Steuert den Historien-Kommentar für die Freitext-Aktion im Agentenbereich.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Steuert den Historien-Kommentar für die Ticketnotiz-Aktion im Agentenbereich.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Ticket-Besitzer" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Warten auf Erinnerung" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Eingehender Telefonanruf" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Ausgehender Telefonanruf" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Ticket Priorität" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Ticket-Verantwortlicher" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiert den Historien-Kommentar für die Aktion "Warten auf Erinnerung" welcher in der Ticket-Historie in der Agenten-Oberfläche angezeigt wird.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiert den Verlauf-Kommentar für diese Operation, der für den Ticket-Verlauf in der Agenten-Schnittstelle verwendet wird.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket Schließen" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Neues Email Ticket" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Neues Telefon Ticket" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket FreiText" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket Notiz" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket Besitzer" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Warten auf Erinnerung" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Eingehender Telefonanruf" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ausgehender Telefonanruf" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket Priorität" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Historien-Typ für die Aktion "Ticket Verantwortlicher" welcher für die Ticket-Historie in der Agenten-Oberfläche benutzt wird.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiert den Verlaufstyp für die Ticket-Zoom-Aktion, der für den Ticket-Verlauf in der Kundenschnittstelle verwendet wird.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiert den Verlaufstyp für diese Operation, der für den Ticket-Verlauf in der Agenten-Schnittstelle verwendet wird.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Definiert die Stunden und Wochentage des angegebenen Kalenders um die Arbeitszeit zu messen.',
        'Defines the hours and week days to count the working time.' => 'Definiert den Zeitraum und die Wochentage welche als Arbeitszeit zählen.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Definiert den Schlüssel, der mit dem Modul Kernel::Modules::AgentInfo geprüft wird. Wenn dieser Nutzer-Einstellungs-Schlüssel "wahr" ist, wird die Nachricht vom System akzeptiert.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Definiert den Schlüssel, der mit CustomerAccept geprüft wird. Wenn dieser Nutzer-Einstellungs-Schlüssel "wahr" ist, wird die Nachricht vom System akzeptiert.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definiert den Link-Typ \'Normal\'. Wenn der Name der Quelle dem des Ziels entspricht, ist der resultierende Link ein nicht-direktionaler Link; Ansonsten ist das Resultat ein direktionaler Link.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definiert den Link-Typ \'ParentChild\'. Wenn der Quell- und der Zielname den selben Wert beinhalten, ist der Link nicht-direktional. Ansonsten ist das Ergebnis ein direktionaler Link.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Definition der verschiedenen Verknüpfungsmöglichkeiten. Verknüpfungstpyen der selben Gruppe schließen sich gegenseitig aus. Beispiel: Wenn Ticket A mit dem Typ \'Normal\' mit Ticket B verlinkt wird, dann können diese beiden Tickets nicht noch zusätzlich mit dem Typ \'ElternKind\' miteinander verlinkt werden.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Definiert eine Liste von Online-Quellen. Andere Installationen können als Quelle genutzt werden z.B. Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Irgendein Name".',
        'Defines the list of params that can be passed to ticket search function.' =>
            'Legt die Liste der Parameter fest, welche mit der Ticketsuchfunktion verwendet werden kann.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Definiert die Liste der möglichen Folgeaktionen in einer Fehleranzeige. Mit einem vollständigen Pfad kann man bei Bedarf externe Links einfügen.',
        'Defines the list of types for templates.' => 'Definiert die Typenliste für Templates.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Definiert die Adresse der Online-Repository-Liste für zusätzliche Pakete. Das erste verfügbare Ergebnis wird genutzt.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Definiert das Log Module für das System. "Datei" schreibt alle Meldungen in das angegebene Logfile, "SysLog" nutzt den Syslog Daemon des Systems, z.B. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTOBO instance to stop working (probably any mask which takes input from the user).' =>
            'Definiert die maximale Größe (in Bytes) für das Hochladen von Dateien mit dem Browser. Achtung: Wenn man die Größe zu klein wählt können viele Eingabemasken in ihrer OTOBO-Instanz nicht mehr funktionieren (vermutlich jede Maske die Benutzereingaben erwartet).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definiert die maximale Gültigkeitsdauer (in Sekunden) für eine Sitzungs-ID.',
        'Defines the maximum number of affected tickets per job.' => 'Definiert die maximale Anzahl der betroffenen Tickets pro Job.',
        'Defines the maximum number of pages per PDF file.' => 'Bestimmt die maximale Anzahl an Seiten pro PDF-Datei.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Legt die maximale Anzahl an zitierten Zeilen fest, die zu Antworten hinzugefügt werden.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Definiert die maximale Anzahl gleichzeitig ausgeführter Tasks.',
        'Defines the maximum size (in MB) of the log file.' => 'Bestimmt die Maximalgröße (in MB) der Protokolldatei.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Legt die maximale Größe von Antworten des GenericInterfaces fest, die in der „gi_debugger_entry_content“-Tabelle gespeichert werden (in Kilobyte).',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definiert das Modul das alle zur Zeit angemeldeten Agenten im Agenten-Interface anzeigt.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'Definiert das Modul, das alle zur Zeit angemeldeten Kunden im Agentenbereich anzeigt.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'Definiert das Modul, das alle zur Zeit angemeldeten Agenten im Kundenbereich anzeigt.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'Definiert das Modul, das alle zur Zeit angemeldeten Kunden im Kundenbereich anzeigt.',
        'Defines the module to authenticate customers.' => 'Definiert das Modul um Kunden zu authentifizieren.',
        'Defines the module to display a notification in the agent interface if the OTOBO Daemon is not running.' =>
            'Definiert das Modul, dass eine Benachrichtigung im Agentenbereich anzeigt, wenn der OTOBO Daemon nicht läuft.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            'Definiert das Modul, das eine Benachrichtigung im Agentenbereich anzeigt, wenn die Systemkonfiguration nicht synchronisiert ist.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            'Definiert das Modul, das eine Benachrichtigung im Agentenbereich anzeigt, wenn ein Agent noch keine Zeitzone festgelegt hat.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definiert das Modul das eine Benachrichtigung im Agenten-Interface anzeigt, wenn ein Agent angemeldet ist, während er die "Out of Office"-Funktion aktiviert hat.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Definiert das Modul das eine Benachrichtigung im Agenten-Interface anzeigt, wenn ein Agent angemeldet ist, während die Systemwartung aktiv ist.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'Definiert das Modul, das eine Benachrichtigung im Agentenbereich anzeigt, wenn das Limit für Agentensitzungen erreicht wurde.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Legt das Modul fest, das eine Benachrichtigung im Agenten-Bereich anzeigt, wenn das System mit einem Admin-Benutzer genutzt wird (normalerweise sollte im System nicht als Admin-Benutzer gearbeitet werden).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            'Definiert das Modul, das eine Benachrichtigung im Agentenbereich anzeigt, wenn ungültige Konfigurationseinstellungen in Betrieb genommen wurden.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            'Definiert das Modul, das eine Benachrichtigung im Agentenbereich anzeigt, wenn Konfigurationseinstellungen angepasst, aber noch nicht in Betrieb genommen wurden.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            'Definiert das Modul, das eine Benachrichtigung im Kundenbereich anzeigt, wenn ein Kunde während einer Systemwartung eingeloggt ist.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            'Definiert das Modul, das eine Benachrichtigung im Kundenbereich anzeigt, wenn ein Kunde noch keine Zeitzone festgelegt hat.',
        'Defines the module to generate code for periodic page reloads.' =>
            'Definiert das Modul für die Code-Generierung beim periodischen Neuladen von Seiten.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            'Definiert das Modul zum Versenden von E-Mails. "DoNotSendEmail" sendet überhaupt keine E-Mails. Jeder der "SMTP"-Mechanismen verwendet einen bestimmten (externen) Mailserver. "Sendmail" verwendet direkt die sendmail-Binärdatei Ihres Betriebssystems. "Test" sendet keine E-Mails, sondern schreibt sie zu Testzwecken in $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Definiert, welches Modul für das Speichern der Sitzungsdaten verwendet werden soll. Mit "DB" kann der Anzeige Server getrennt vom DB-Server betrieben werden. "FS" ist schneller.',
        'Defines the modules in Kernel/Output/HTML/GenericContent/ which provide the inner content to the chosen key.' =>
            'Definiert die Module in Kernel/Output/HTML/GenericContent/, die den untergeordneten Inhalt für den ausgewählten Wert bereitstellen.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Definiert den Namen der Anwendung, die in der Weboberfläche, in Tabs und in der Titelleiste des Webbrowser angezeigt wird.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Definiert den Namen der Spalte, unter der Daten in der Eigenschaften-Tabelle gespeichert werden.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Definiert den Namen der Spalte, unter der die Benutzer-Identifier in der Eigenschaften-Tabelle gespeichert werden.',
        'Defines the name of the indicated calendar.' => 'Definiert den Namen des angezeigten Kalenders.',
        'Defines the name of the key for customer sessions.' => 'Definiert den Namen des Schlüssels für die Kunden-Sessions.',
        'Defines the name of the session key. E.g. Session, SessionID or OTOBO.' =>
            'Definiert den Namen des Session-Schlüssels. Zum Beispiel: Session, SessionID oder OTOBO.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Legt den Namen der Tabelle fest, in der Benutzereinstellungen gespeichert werden.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definiert den nächsten möglichen Status nach Erstellen eines / Antworten auf ein Ticket im Verfassen-Bildschirm im Agenten-Interface.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Legt die möglichen Folgestatus fest, die nach dem Weiterleiten eines Tickets im Weiterleiten-Bildschirm des Agenten-Bereichs gewählt werden können.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Definiert die nächsten, auswählbaren Status, nachdem eine ausgehende Email versendet wurde.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Definiert die nächsten möglichen Status für Tickets von Kunden in der Kunden-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz im "Ticket Schließen" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz im "Ticket FreiText" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz im "Ticket Notiz" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz im "Ticket Besitzer" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz in der "Warten auf Erinnerung" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz in der "Ticket Priorität" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem hinzufügen einer Notiz in der "Ticket Verantwortlicher" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Legt den Folgestatus eines über den Umleiten-Bildschirm des Agenten-Bereichs umgeleiteten Tickets fest.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Definiert den nächsten Ticket Status nach dem verschieben in eine andere Queue in der "Ticket Queue" Ansicht der Agenten-Oberfläche.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Definiert den Folgestatus für ein Ticket, im Stapelverarbeitungs-Bildschirm im Agenten-Interface.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Legt die Anzahl von Zeichen pro Zeile für die Artikel-Vorschau-Ersetzung im TemplateGenerator für EventNotifications fest.',
        'Defines the number of days to keep the daemon log files.' => 'Definiert die Aufbewahrungszeit für die Daemon Log-Dateien in Tagen.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Legt die Anzahl von Header-Feldern in Frontend-Modulen für das Hinzufügen/Aktualisieren von Postmaster-Filtern fest. Bis zu 99 Felder möglich.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            'Legt fest, wie viele Stunden eine Verbindung unabhängig von ihrem Status gespeichert werden soll.',
        'Defines the number of hours a successful communication will be stored.' =>
            'Legt fest, wie viele Stunden eine erfolgreiche Verbindung gespeichert werden soll.',
        'Defines the number of tickets shown in the widget.' => 'Definiert die Anzahl der im Widget dargestellten Tickets.',
        'Defines the parameters for the customer preferences table.' => 'Definiert die Parameter der Tabelle mit den Kunden-Einstellungen.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Only works if DashboardBackend::AllowCmdOutput is enabled in Config.pm.' =>
            'Definiert die Parameter für die Übersicht. "Cmd" wird verwendet um einen Befehl mit Parametern zu spezifizieren. "Group" wird verwendet um den Zugriff auf das Plugin einzuschränken (z.B. Group: admin;group1;group2;). "Default" zeigt an, ob das Plugin standardmäßig aktiviert ist oder ob der Anwender es manuell aktivieren muss. "CacheTTL" zeigt die Ablaufzeit für den Plugin-Cache in Minuten an. "Mandatory" bestimmt, ob das Plugin immer angezeigt und nicht von Agenten entfernt werden kann. Es funktioniert nur, wenn DashboardBackend::AllowCmdOutput in der Datei Config.pm aktiviert wurde.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTL" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTL" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von fett und kursiv gedruckter nichtproportionaler Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von fett und kursiv gedruckter proportionaler Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von fett gedruckter nichtproportionaler (monospace) Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von fett gedruckter proportionaler Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von kursiv gedruckter nichtproportionaler (monospace) Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von kursiv gedruckter proportionaler Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung von nichtproportionaler (monospace) Schrift in PDF Dokumenten.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Definiert den Pfad und die TTF Datei für die Handhabung proportionaler Schrift in PDF Dokumenten.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Legt den Pfad der angezeigten Info-Datei fest, die in Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt liegt.',
        'Defines the path to PGP binary.' => 'Bestimmt den Pfad zur PGP-Binärdatei.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Legt den Pfad zum OpenSSL-Binary fest. Es benötigt möglicherweise ein HOME-Env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the path to the Google Chrome or Chromium binary. If set, this binary will be used instead of PhantomJS::Bin.' =>
            'Definiert den Pfad zum Google Chrome oder Chromium Binary. Bei Auswahl wird statt PhantomJS::Bin dieses Binary verwendet.',
        'Defines the path to the PhantomJS binary. You can use a static build from http://phantomjs.org/download.html for an easy installation process.' =>
            'Definiert den Pfad zum PhantomJS Binary. Für eine einfach Installation können Sie einen Static Build von http://phantomjs.org/download.html verwenden.',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Legt den Zeitraum in Minuten fest, bevor ein Agent aufgrund von Inaktivität als "abwesend" markiert wird (z. B. im "Angemeldete Nutzer"-Dashlet oder im Chat).',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Legt den Zeitraum in Minuten fest, bevor ein Kunde aufgrund von Inaktivität als "abwesend" markiert wird (z. B. im "Angemeldete Nutzer"-Dashlet oder im Chat).',
        'Defines the postmaster default queue.' => 'Definiert die Postmaster-Queue.',
        'Defines the priority in which the information is logged and presented.' =>
            'Definiert die Priorität in welcher die Information aufgezeichnet und präsentiert wird.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Legt die Art des Empfängers für Telefon-Tickets und des Absenders für E-Mail-Tickets im Agenten-Bereich fest ("Queue" zeigt alle Queues, "System address" alle System-Adressen).',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Legt die Art des Empfängers für Tickets im Kunden-Bereich fest ("Queue" zeigt alle Queues, "System address" nur die Queues, die System-Adressen zugewiesen sind).',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Definiert die benötigten Rechte, um ein Ticket in der Eskalationsansicht der Agenten-Oberfläche anzuzeigen.',
        'Defines the search limit for the stats.' => 'Definiert die maximalen Suchergebnisse für Statistiken.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'Bestimmt die Suchparameter für den Bildschirm AgentCustomerUserAddressBook. Mit der Einstellung \'CustomerTicketTextField\' können Werte für das Empfängerfeld vorgegeben werden.',
        'Defines the sender for rejected emails.' => 'Definiert die Absendeadresse für abgelehnte E-Mails.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Definiert das Trennzeichen zwischen dem wirklichen Namen des Agenten und der angegebenen E-Mail-Adresse der Queue.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'Legt die angezeigten Spalten und ihre Position für den Ergebnisbildschirm von AgentCustomerUserAddressBook fest.',
        'Defines the shown links in the footer area of the customer interface of this OTOBO system. The value in "Key" is the external URL, the value in "Content" is the shown label. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> and <OTOBO_CONFIG_ScriptAlias> will be substituted.' =>
            'Definiert die im Footer-Bereich des OTOBO Kundenportals angezeigten Links. Im Feld "Schlüssel" ist die externe URL, als "Inhalt" der anzuzeigende Linktext einzugeben. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> und <OTOBO_CONFIG_ScriptAlias> werden ersetzt.',
        'Defines the source dynamic field for storing historical data.' =>
            'Definiert das dynamische Quell-Feld zum Speichern historischer Daten.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Legt die verfügbaren Standardberechtigungen für Kunden innerhalb der Applikation fest. Werden mehr Berechtigungen benötigt, können sie hier eingegeben werden. Berechtigungen müssen hart-kodiert sein, um Auswirkungen zu haben. Bitte stellen Sie beim Anlegen neuer Berechtigungen sicher, dass "rw" immer der letzte Eintrag bleibt.',
        'Defines the standard size of PDF pages.' => 'Bestimmt die Standardgröße von PDF-Seiten.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definiert den Status eines geschlossenen Tickets, wenn ein Follow-Up eingeht.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definiert den Status eines Tickets, wenn ein Follow-Up eingeht.',
        'Defines the state type of the reminder for pending tickets.' => 'Definiert den Statusttyp des Reminders für Tickets die auf "Warten" gesetzt sind.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Definiert den Betreff für Benachrichtigungs-Emails, die wegen eines neuen Passworts an Agenten geschickt werden.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Legt den Betreff der Benachrichtigungs-E-Mail fest, die bei einer Passwortanfrage an Agenten verschickt wird.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Definiert den Betreff für Benachrichtigungs-Emails, die wegen eines neuen Accounts an Kunden geschickt wird.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Definiert den Betreff für Benachrichtigungs-Emails, die wegen eines neuen Passworts an Kunden geschickt wird.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Legt den Betreff der Benachrichtigungs-E-Mail fest, die bei einer Passwortanfrage an Kunden verschickt wird.',
        'Defines the subject for rejected emails.' => 'Bestimmt den Betreff von abgelehnten E-Mails.',
        'Defines the subject for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Definiert den Betreff für die Aktion "Sofort Schließen", die in der Ticket-Historie im Agentenbereich verwendet wird.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Definiert die E-Mail-Adresse des System-Administrators. Sie wird in den Fehlermeldungen angezeigt.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).' =>
            'Definiert die System ID. Jede Ticketnummer und HTTP Sitzung enthält diese ID. Das stellt sicher, dass nur Tickets in das Ticketsystem aufgenommen werden, welche zum eigenen Ticketsystem gehören (nützlich, wenn zwischen zwei Instanzen von OTOBO kommuniziert wird).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Definiert das \'target\'-Attribut eines Links zu einer externen Kunden-Datenbank. Z.B. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Definiert das \'target\'-Attribut eines Links zu einer externen Kunden-Datenbank. Z.B. \'target="cdb"\'.',
        'Defines the target dynamic fields for storing historical data.' =>
            'Definiert die dynamischen Ziel-Felder zum Speichern historischer Daten.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            'Beschreibt den Ticket-Termin-Backend Typ für Datum/Uhrzeit durch dynamische Felder.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            'Beschreibt den Ticket-Termin-Backend Typ für Ticketeskalationen.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            'Beschreibt den Ticket-Termin-Backend Typ für Ticketpendingzeiten.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Legt die Ticket-Attribute fest, die in Kalender-Ereignissen angezeigt werden sollen. "Key" bestimmt das Feld oder Ticket-Attribut, "Content" legt den anzuzeigenden Namen fest.',
        'Defines the ticket plugin for calendar appointments.' => 'Legt das Ticket-Plugin für Termine fest.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Spezifiziert die Zeitzone des angezeigten Kalenders, welcher später einer bestimmten Queue zugewiesen werden kann.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Legt den Timeout in Sekunden für die Sammlung von Supportdaten des öffentlichen Moduls \'PublicSupportDataCollector\' fest, das z. B. vom OTOBO Daemon genutzt wird (min. 20 Sekunden).',
        'Defines the two-factor module to authenticate agents.' => 'Definiert das Modul für die Zwei-Faktor-Authentifizierung von Agenten.',
        'Defines the two-factor module to authenticate customers.' => 'Definiert das Modul für die Zwei-Faktor-Authentifizierung von Kunden.',
        'Defines the type of protocol that is used by the web server to serve the application. If the webserver uses HTTP instead of of HTTPS, then \'http\' must be specified here. The setting of \'HttpType\' has no affect on the web server\'s settings or behavior. Specifically, it will not change the method of access to the application. If the setting is wrong, it will not prevent you from logging into the application. This setting is used mainly via the template variable OTOBO_CONFIG_HttpType. This variable is found in all forms of messaging used by the application. It is used to build links to the tickets within your system. Another effect of keeping \'HttpType\' set to \'https\' is that the session management cookie will only be set for secure connections.' =>
            'Definiert, welches Protokoll der Webserver zum Austausch mit der Applikation verwendet. Nutzt der Webserver HTTP statt HTTPS, muss hier \'http\' angegeben werden. Die Einstellung \'HttpType\' hat keine Auswirkung auf Einstellungen oder Verhalten des Webservers. Sie wird insbesondere nicht verändern, wie auf die Anwendung zugegriffen wird. Ist die Einstellung falsch, wird dies nicht dazu führen, dass Sie nicht auf die Anwendung zugreifen können. Die Einstellung wird vorwiegend über die Template-Variable OTOBO_CONFIG_HttpType verwendet. Diese Variable kann in allen Benachrichtigungsformen der Anwendung gefunden werden. Sie wird verwendet, um Links zu Tickets in Ihrem System aufzubauen. Eine weitere Auswirkung dessen, den \'HttpType\' auf \'https\' zu belassen ist , dass nur für sichere Verbindungen ein Session Cookie gesetzt wird.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Legt das genutzte Zeichen für Zitate in Plaintext-E-Mails im Verfassen-Bildschirm des Agentenbereichs fest. Bleibt das Feld leer oder ist die Einstellung nicht aktiviert, wird die ursprüngliche E-Mail nicht zitiert, sondern an die Antwort angehängt.',
        'Defines the user identifier for the customer panel.' => 'Definiert den Benutzer-Identifier für das Kunden-Interface.',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Definiert den Avatar des Benutzers. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            'Definiert die gültigen Statustypen für ein Ticket. Wenn sich ein Ticket in einem Status befindet, der einen Statustyp aus dieser Einstellung hat, gilt dieses Ticket als offen, ansonsten als geschlossen.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Bestimmt gültige Status für entsperrte Tickets. Um Tickets zu entsperren, kann das Script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" genutzt werden.',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'Bestimmt die sichtbaren Sperrtypen eines Tickets. Hinweis: Bitte stellen Sie sicher, dass Sie bei Veränderung dieser Einstellung den Cache leeren.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Breite der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Breite der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            'Legt die Zeit in Minuten seit der letzten Änderung von Entwürfen des gewählten Typs fest, bis diese als veraltet gelten.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            'Legt fest, ob archivierte Tickets im Index für Volltextsuchen berücksichtigt werden sollen.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Gibt an, welche Artikel-Sendertypen in der Vorschau eines Tickets angezeigt werden sollen.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Definiert welche Begriffe für eine \'Aktion\' in der dritten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Definiert welche Begriffe in der ersten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Definiert welche Begriffe in der zweiten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Definiert welcher Status automatisch gesetzt wird (Inhalt), nachdem die Wartenzeit eines Status (Schlüssel) erreicht wurde.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Definiert, dass Tickets mit den ausgewählten Tickets Status nicht bei den verknüpften Tickets angezeigt werden sollen.',
        'Delete expired cache from core modules.' => 'Löscht den abgelaufenen Cache der Kern-Module.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Löscht wöchentlich den abgelaufenen Loader-Cache (Sonntag Morgen).',
        'Delete expired sessions.' => 'Löscht abgelaufene Benutzersitzungen.',
        'Delete expired ticket draft entries.' => 'Veraltete Ticket-Entwürfe löschen.',
        'Delete expired upload cache hourly.' => 'Veraltete Upload-Caches stündlich löschen.',
        'Delete this ticket' => 'Dieses Ticket löschen',
        'Deleted link to ticket "%s".' => 'Verknüpfung zu "%s" gelöscht.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Löscht die Sitzung, wenn die Sitzungs-ID mit einer ungültigen IP-Adresse benutzt wird.',
        'Deletes requested sessions if they have timed out.' => 'Löscht die angefragte Sitzung, wenn ein Timeout vorliegt.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Liefert im Frontend erweiterte Debugging-Informationen zu AJAX-Fehlern, wenn aktiviert.',
        'DeploymentHistory' => 'DeploymentHistory',
        'Detached' => 'Losgelöst',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            'Legt fest, ob ein Knopf zum Löschen neben jedem Link im TicketZoom-Bildschirm angezeigt werden soll.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Bestimmt ob die Liste möglicher Queues in die ein Ticket verschoben werden kann als eine DropDown-Liste angezeigt wird oder in einem neuen Fenster. Wenn "Neues Fenster" eingestellt ist, können Sie ein Verschiebe-Notiz zum Ticket hinzufügen.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Definiert, ob das Statistik-Modul Ticket-Listen generieren kann.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticketstatus, nachdem ein neues E-Mailticket im Agenten-interface erstellt wurde.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticketstatus, nachdem ein neues Telefon-Ticket im Agenten-Interface erstellt wurde.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticket-Status für Prozess-Tickets im Agenten-Interface.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'Bestimmt die möglichen Folge-Ticket-Status für Prozesstickets im Kundenbereich.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Definiert den nächsten Bildschirm nach einem Kundenticket im Kunden-Interface.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Legt den Bildschirm fest, der nach einem Follow-Up aus der Ticket-Detailansicht im Kundenbereich aufgerufen werden soll.',
        'Determines the next screen after the process screen of a zoomed ticket in the customer interface.' =>
            'Bestimmt, welcher Bildschirm nach der Prozessmaske eines Tickets in der Kundenoberfläche angezeigt wird.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Bestimmt das nächste Fenster nach dem das Ticket verschoben ist. LastScreenOverview wechselt zur letzten Übersichtsseite. TicketZoom wechselt zur Ticket-Detailansicht.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Bestimmt die möglichen Status eines unerledigten Tickets, das den Status verändert hat nachdem die Zeitbegrenzung erreicht wurde.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Bestimmt die Zeichenfolgen, die als Empfänger (An:) eines Telefon-Tickets und als Absender (Von:) eines E-Mail-Tickets im Agenten-Interface angezeigt werden. Für Queue als NewQueueSelectionType zeigt "<Queue>" den Namen der Queue und für SystemAddress zeigt "<Realname> <<Email>>" den Namen und E-Mail-Adresse des Empfängers.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Bestimmt die Zeichenfolgen, die als Empfänger (An:) eines Tickets im Kunden-Interface angezeigt werden. Für Queue als CustomerPanelSelectionType zeigt "<Queue>" den Namen der Queues und für SystemAddress zeigt "<Realname> <<Email>>" den Namen und E-Mail-Adresse des Empfängers.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Definiert wie Verlinkte-Objekte angezeigt werden in TicketZoom-Masken.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Definiert, welche Optionen für den Empfänger (Telefon-Ticket) und den Absender (E-Mail-Ticket) im Agenten-Interface gültig sind.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Definiert, welche Queues für Ticket-Empfänger im Kunden-Interface gültig sind.',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Wenn HTTP-Header "Content-Security-Policy" ausgeschaltet ist, können externe Scripts geladen werden. Dies stellt eine Sicherheitslücke dar! Daher sollte diese Einstellung nur deaktivieren werden, wenn Sie sich über die Konsequenzen im Klaren sind!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTOBO to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Wenn der HTTP-Header "X-Frame-Options: SAMEORIGIN" ausgeschaltet ist, kann OTOBO als IFrame in andere Websites integriert werden. Dies stellt eine Sicherheitslücke dar! Daher sollte diese Einstellung nur deaktivieren werden, wenn Sie sich über die Konsequenzen im Klaren sind!',
        'Disable autocomplete in the login screen.' => 'Autovervollständigen in der Anmeldemaske deaktivieren.',
        'Disable cloud services' => 'Cloud-Services deaktivieren',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'Verhindert das Versenden von Erinnerungen an den Verantwortlichen eines Tickets. (Ticket::Responsible muss aktiviert sein).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            'Deaktiviert die Umleitung auf die letzte Übersicht / das Dashboard, nachdem ein Ticket geschlossen wurde.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Zeigt eine Warnung an und verhindert die Suche, wenn Stop-Wörter in der Volltextsuche eingegeben werden.',
        'Display communication log entries.' => 'Einträge des Verbindungsprotokolls anzeigen.',
        'Display settings to override defaults for Process Tickets.' => 'Einstellungen zum Überschreiben der Standardwerte für Prozess-Tickets anzeigen.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Zeigt die bisher benötigte Zeit für einen Artikel in der TicketZoomView an.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            'Zeigt die Anzahl aller Tickets mit derselben Kundennummer wie das aktuelle Ticket in der Ticket-Zoom-Ansicht an.',
        'Down' => 'Ab',
        'Dropdown' => 'Einfachauswahl',
        'Dutch' => 'Niederländisch',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'Niederländische Stoppwörter für den Volltext-Index. Diese Wörter werden vom Suchindex entfernt.',
        'Dynamic Fields Checkbox Backend GUI' => 'Dynamic Fields-Oberfläche für Checkboxen',
        'Dynamic Fields Contact Data Backend GUI' => 'Dynamic Fields-Oberfläche für Kontaktdaten-Felder',
        'Dynamic Fields Database Backend GUI' => 'Dynamic Fields-Oberfläche für Datenbank-Felder',
        'Dynamic Fields Date Time Backend GUI' => 'Dynamic Fields-Oberfläche für DatumZeit-Felder',
        'Dynamic Fields Drop-down Backend GUI' => 'Dynamic Fields-Oberfläche für Auswahlboxen',
        'Dynamic Fields GUI' => 'Dynamic Fields-Oberfläche',
        'Dynamic Fields Multiselect Backend GUI' => 'Dynamic Fields-Oberfläche für Mehrfachauswahlboxen',
        'Dynamic Fields Overview Limit' => 'Übersichtsbegrenzung der dynamischen Felder',
        'Dynamic Fields Text Backend GUI' => 'Dynamic Fields-Oberfläche für Textfelder',
        'Dynamic Fields Web Service Backend GUI' => 'Dynamic Fields-Oberfläche für Webservice-Felder',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dynamic Fields welche beim Export des Suchergebnisses im CSV-Format auszugeben sind.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Dynamische Feldergruppen für das Prozess-Widget. Der Schlüssel ist der Name der Gruppe, der Wert enthält die Felder, die angezeigt werden sollen. Beispiel: \'Key => Meine Gruppe\', \'Content: NameX, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'Maximale Anzahl dynamischer Felder pro Seite in Übersichtsseite der dynamischen Felder.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Dynamische Felder zur Eingabe im Ticket erstellen-Bildschirm des Kundenbereichs. Hinweis: Wenn Sie diese Felder ebenfalls in der Ticket-Detailansicht anzeigen möchten, können Sie sie bitte in der Einstellung CustomerTicketZoom###DynamicField einschalten.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            'Dynamische Felder zur Eingabe bei der Ticket-Beantwortung im Kundenbereich.',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im ausgehende E-Mail-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            'Angezeigte Dynamische Felder im Prozess-Widget in der Ticket-Detailansicht des Agentenbereichs.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            'Angezeigte Dynamische Felder in der Seitenleiste in der Ticket-Detailansicht des Agentenbereichs.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Ticket schließen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Ticket verfassen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im E-Mail Ticket-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Ticket weiterleiten-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Freitextfelder-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            'Angezeigte Dynamische Felder in der Medium-Ansicht von Ticket-Listen im Agentenbereich.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Ticket verschieben-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Notiz erstellen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            'Angezeigte dynamische Felder in der Ticketübersicht des Kundenbereichs.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Besitzer wechseln-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Wartezeit setzen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im eingehender Anruf-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im ausgehender Anruf-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Telefon-Ticket-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            'Angezeigte Dynamische Felder in der Großansicht von Ticket-Listen im Agentenbereich.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            'Angezeigte Dynamische Felder in der Ticket drucken-Ansicht im Agentenbereich.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            'Angezeigte dynamische Felder in der Ticket drucken-Ansicht im Kundenbereich.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Priorität setzen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            'Dynamische Felder zur Eingabe im Verantwortlicher setzen-Bildschirm des Agentenbereichs.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            'Angezeigte dynamische Felder in der Anzeige von Suchergebnissen der Ticketsuche im Kundenbereich.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            'Angezeigte dynamische Felder im Suchergebnis von Ticket-Suchen im Agentenbereich.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            'Angezeigte dynamische Felder im Suchergebnis von Ticket-Suchen im Kundenbereich.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            'Angezeigte dynamische Felder in der Kleinansicht von Ticket-Listen im Agentenbereich.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            'Angezeigte dynamische Felder in der Ticket-Detailansicht im Kundenbereich.',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'Backend-Registrierung für Dynamische Felder.',
        'DynamicField object registration.' => 'DynamischesFeld Objektregistrierung.',
        'DynamicFieldScreen' => 'DynamicFieldScreen',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => 'Ausgehende E-Mail',
        'Edit Customer Companies.' => 'Kundenfirmen bearbeiten.',
        'Edit Customer Users.' => 'Kundenbenutzer bearbeiten.',
        'Edit appointment' => 'Termin bearbeiten',
        'Edit contacts with data' => 'Kontaktdaten bearbeiten',
        'Edit contacts with data.' => 'Kontaktdaten bearbeiten.',
        'Edit customer company' => 'Kundenunternehmen bearbeiten',
        'Elasticsearch quick result module.' => 'Dynamische Voranzeige der Elasticsearch-Suchergebnisse.',
        'Email Addresses' => 'E-Mail-Adressen',
        'Email Outbound' => 'Ausgehende E-Mail',
        'Email Resend' => 'E-Mail erneut senden',
        'Email communication channel.' => 'Kommunikationskanal E-Mail.',
        'Enable highlighting queues based on ticket age.' => 'Hervorheben von Queues nach Ticketalter aktivieren.',
        'Enable keep-alive connection header for SOAP responses.' => 'Keep-Alive-Verbindungsheader für SOAP-Responses aktivieren.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Aktivieren Sie diese Einstellung, wenn Sie allen öffentlichen und privaten PGP-Schlüsseln vertrauen, selbst wenn diese nicht mit einer vertrauten Signatur signiert wurden.',
        'Enabled filters.' => 'Filter aktiviert.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTOBO user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Aktiviert PGP-Support. Wenn PGP-Support für das signieren und verschlüsseln von Mails eingeschaltet ist, wird dringend empfohlen, den Webserver unter dem OTOBO-Benutzer zu betreiben. Andernfalls werden Probleme mit den Berechtigungen auftreten, wenn auf das .gnupg-Verzeichnis zugegriffen wird.',
        'Enables S/MIME support.' => 'Aktiviert unterstützung für S/MIME.',
        'Enables customers to create their own accounts.' => 'Erlaubt Kunden, eigene Konten anzulegen.',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'Schaltet S/MIME-Unterstützung für das Anfragen von Kundenbenutzer-Backends ein.',
        'Enables file upload in the package manager frontend.' => 'Erlaubt den Datei-Upload im Paket-Manager.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Schaltet das Caching von Vorlagen an oder aus. Warnung: Schalten Sie das Vorlagen-Caching auf Produktivsystemen nicht ab, da dies massive Performance-Beeinträchtigungen auslösen würde. Diese Einstellung sollte nur zur Fehlerbehebung abgeschaltet werden!',
        'Enables or disables the debug mode over frontend interface.' => 'Aktiviert oder deaktiviert den Debug-Modus für das Frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Aktiviert oder deaktiviert das "Ticket beobachten"-Feature, das ein Beobachten von Tickets erlaubt, ohne deren Besitzer oder Verantwortlicher zu sein.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Aktiviert das Leistungsprotokoll zum Erfassen der Seiten-Antwortzeiten. Diese Einstellung beeinflusst die Gesamtleistung des Systems. Frontend::Module###AdminPerformanceLog muss aktiviert sein.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Aktiviert die Minimalgröße für Ticketzähler (wenn "Datum" als TicketNumberGenerator ausgewählt ist).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Aktiviert das Stapelverarbeitungs-Feature im Agentenbereich, das ein gleichzeitiges Bearbeiten mehrerer Tickets erlaubt.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Aktiviert das Stapelverarbeitungs-Feature nur für die eingetragenen Gruppen.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Aktiviert das "Verantwortlicher"-Feature, das ein Verfolgen relevanter Tickets erlaubt.',
        'Enables ticket type feature.' => 'Aktiviert Ticket-Typen.',
        'Enables ticket watcher feature only for the listed groups.' => 'Aktiviert das Ticket beobachten-Feature nur für die eingetragenen Gruppen.',
        'Enabling SecureMode disables the web installer (http://yourhost.example.com/otobo/installer.pl) and the migrations. This is done in order to prevent the system from being hijacked. When SecureMode is not enabled the system can be reinstalled. In this case the current basic configuration will be used to pre-populate the questions within the installer script. Enabling SecureMode also enables GenericAgent, PackageManager and SQL Box.' =>
            'Aktivieren des SecureMode deaktiviert den Web-Installer (http://yourhost.example.com/otobo/installer.pl) und die Migration. Dies geschieht, um zu verhindern, dass das System gehijackt werden kann. Ist der SecureMode nicht aktiviert, kann das System jederzeit neu aufgesetzt werden. In diesem Fall wird die aktuelle Grundkonfiguration verwendet, um das Installer-Skript vorzubefüllen. Mit der Aktivierung des SecureMode werden außerdem GenericAgent, PackageManager und SQL Box aktiviert.',
        'English (Canada)' => 'Englisch (Kanada)',
        'English (United Kingdom)' => 'Englisch (Vereinigtes Königreich)',
        'English (United States)' => 'Englisch (Vereinigte Staaten)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Englische Stopworte für den Volltext-Index. Diese Worte werden aus dem Index entfernt.',
        'Enroll process for this ticket' => 'Startet einen Prozess für dieses Ticket',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            'Geben Sie Ihr "gemeinsames Geheimnis" ein, um die Zwei-Faktor-Authentifizierung zu aktivieren. WARNUNG: Stellen Sie sicher, dass Sie das "gemeinsames Geheimnis" zu Ihrer Generatoranwendung hinzufügen und die Anwendung gut funktioniert. Andernfalls können Sie sich ohne das Zwei-Faktor-Token nicht mehr anmelden.',
        'Escalated Tickets' => 'Eskalierte Tickets',
        'Escalation view' => 'Ansicht nach Eskalationen',
        'EscalationTime' => 'Eskalationszeit',
        'Estonian' => 'Estnisch',
        'Event module registration (store historical data in dynamic fields).' =>
            'Registrierung des Event-Moduls (Speichern historischer Daten in dynamischen Feldern).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Eventmodul-Registierung. Für höhere Performancen können Sie ein Trigger-Event definieren (z.B. Event => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Eventmodul-Registierung. Für höhere Performancen können Sie ein Trigger-Event definieren (z.B. Event => TicketCreate). Dies ist nur möglich, wenn alle dynamischen Ticketfelder das gleiche Event benötigen.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Ereignismodul, das ein Update-Statement auf TicketIndex ausführt, um die Queue umzubenennen (wenn nötig und wenn StaticDB genutzt wird).',
        'Event module that updates customer company object name for dynamic fields.' =>
            'Eventmodul, das den Kundenunternehmen-Objektnamen für Dynamische Felder aktualisiert.',
        'Event module that updates customer user object name for dynamic fields.' =>
            'Eventmodul, das den Kundenbenutzer-Objektnamen für Dynamische Felder aktualisiert.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Eventmodul, das Suchprofile von Kunden aktualisiert, wenn sich Loginnamen ändern.',
        'Event module that updates customer user service membership if login changes.' =>
            'Eventmodul, das Service-Zuordnungen von Kunden aktualisiert, wenn sich Loginnamen ändern.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Ereignis-Modul, das Kundenbenutzer aktualisiert nach einem Update des Kunden.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Ereignis-Modul, das ein Ticket aktualisiert nach einem Update des Kundenbenutzers.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Ereignis-Modul, das ein Ticket aktualisiert nach einem Update des Kunden.',
        'Events Ticket Calendar' => 'Ticket-Ereigniskalender',
        'Example package autoload configuration.' => 'Beispielhafte Autoload-Konfiguration für Pakete.',
        'Execute SQL statements.' => 'SQL-Befehle ausführen.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Führt ein benutzerdefiniertes Kommando oder Modul aus. Hinweis: Wird ein Modul benutzt, muss eine Funktion vorhanden sein.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Führt Follow-Up-Checks auf In-Reply-To- oder References-Headern von E-Mails aus, deren Betreff keine Ticketnummer enthält.',
        'Executes follow-up checks on OTOBO Header \'X-OTOBO-Bounce\'.' =>
            'Führt Follow-Up-Checks auf dem OTOBO-Header \'X-OTOBO-Bounce\' aus.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Führt Follow-Up-Checks auf Anhänge von E-Mails aus, deren Betreff keine Ticketnummer enthält.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Führt Follow-Up-Checks auf Texten von E-Mails aus, deren Betreff keine Ticketnummer enthält.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Führt Follow-Up-Checks auf Quelltexten von E-Mails aus, deren Betreff keine Ticketnummer enthält.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exportiert den vollständigen Artikelbaum im Suchergebnis (kann die System-Performance beeinträchtigen).',
        'External' => 'Extern',
        'External Link' => 'Externer Link',
        'Fetch emails via fetchmail (using SSL).' => 'Empfängt Emails durch Fetchmail (mit SSL).',
        'Fetch emails via fetchmail.' => 'Empfängt Emails durch Fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Eingehende E-Mails von konfigurierten Mailkonten abrufen.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Lädt Pakete über einen Proxy herunter. Überschreibt "WebUserAgent::Proxy".',
        'Fields of the customer company index, used for the company fulltext search. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Felder des Kundenindex, die für die Firmen-Volltextsuche verwendet werden. Auch die Felder werden gespeichert, sind aber für die Gesamtfunktionalität nicht erforderlich.',
        'Fields of the ticket index, used for the ticket fulltext search. Fields are also stored, but are not mandatory for the overall functionality. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Felder des Ticket-Index, die für die Ticket-Volltextsuche verwendet werden. Auch die Felder werden gespeichert, sind aber für die Gesamtfunktionalität nicht erforderlich. Werden Felder ergänzt, die aktualisiert werden können (insbesondere dynamische Felder), muss das entsprechende Update-Event zum TicketManagement-Invoker des Elasticsearch-Webservice hinzugefügt werden!',
        'Fields stored in the customer company index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Felder, die im Kundenindex gespeichert werden und für andere Belange neben der Volltextsuche genutzt werden. Alle Felder sind für die Gesamtfunktionalität erforderlich.',
        'Fields stored in the customer user index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Felder, die im Kundenbenutzerindex gespeichert werden und für andere Belange neben der Volltextsuche genutzt werden. Alle Felder sind für die Gesamtfunktionalität erforderlich.',
        'Fields stored in the ticket index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Felder des Ticket-Index, die für andere Zwecke als die Volltextsuche verwendet werden. Alle Felder sind für die Gesamtfunktionalität erforderlich. Werden Felder ergänzt, die aktualisiert werden können (insbesondere dynamische Felder), muss das entsprechende Update-Event zum TicketManagement-Invoker des Elasticsearch-Webservice hinzugefügt werden!',
        'Fields to be searched in ticket index. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Zu durchsuchende Felder im Ticketindex. Auch die Felder werden gespeichert, sind für die Gesamtfunktionalität aber nicht erforderlich.',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Datei, die im Modul Kernel::Modules::AgentInfo genutzt wird, wenn sie in Kernel/Output/HTML/Templates/Standard liegt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filter zum Debuggen von ACLs. Hinweis: Weitere Ticket-Attribute können im Format <OTOBO_TICKET_Attribute> (z. B. <OTOBO_TICKET_Priority>) hinzugefügt werden.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filter zum Debuggen von Übergängen. Hinweis: Weitere Filter können im Format <OTOBO_TICKET_Attribute> (z. B. <OTOBO_TICKET_Priority>) hinzugefügt werden.',
        'Filter incoming emails.' => 'Eingehende E-Mails filtern.',
        'Finnish' => 'Finnisch',
        'First Christmas Day' => '1. Weihnachtstag',
        'First Queue' => 'Erste Queue',
        'First response time' => 'Zeit für erste Reaktion',
        'FirstLock' => 'Erstsperrzeit',
        'FirstResponse' => 'Erstantwortzeit',
        'FirstResponseDiffInMin' => 'Erstantwortzeitdifferenz in Minuten',
        'FirstResponseInMin' => 'Erstantwortzeit in Minuten',
        'Firstname Lastname' => 'Vorname Nachname',
        'Firstname Lastname (UserLogin)' => 'Vorname Nachname (BenutzerLogin)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            'Tickets mit den hier angegebenen Typen werden in der Tabelle verknüpfter Objekte durchgestrichen dargestellt.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Erzwingt die Speicherung der originalen Artikelinhalte im Artikel-Suchindex, ohne dabei Filter und Stopp-Worte anzuwenden. Dadurch wird die Größe des Suchindex erhöht, was Volltextsuchen verlangsamen kann.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Erzwingt die Kodierung von ausgehenden E-Mails (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Erzwingt das Setzen eines (vom aktuellen Status) abweichenden Ticket-Status nach dem Sperren eines Tickets. Legen Sie den aktuellen Status als Schlüssel und den neuen Status als Inhalt fest.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Tickets werden nach dem Verschieben in eine andere Queue entsperrt.',
        'Format of Creation date shown for tickets. As an example \'%Y-%m-%d %H:%M:%S\' would be interpreted as \'2020-01-22 18:07:23\'. Please refer to http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.' =>
            'Format des zu Tickets angegebenen Erstellungsdatums. Beispiel: \'%Y-%m-%d %H:%M:%S\' wird als \'2020-01-22 18:07:23\' angezeigt. Weitere Informationen unter http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.',
        'Format to be ingested.' => 'Einzulesendes Format.',
        'Forwarded to "%s".' => 'Weitergeleitet an "%s".',
        'French' => 'Französisch',
        'French (Canada)' => 'Französisch (Kanada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'Französische Stoppwörter für den Volltext-Index. Diese Wörter werden vom Suchindex entfernt.',
        'Frontend' => 'Oberfläche',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'Frontend-Modulregistrierung (AgentTicketService-Link entfernen wenn das Service-Feature nicht aktiv ist).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Frontend-Modulregistrierung (Firmen-Link entfernen wenn das Firmen-Feature nicht aktiv ist).',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Frontend-Modulregistrierung (verberge Ticket-Prozesse, falls kein Prozess verfügbar ist).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'Frontend-Modulregistrierung (persönliche Favoriten als Untermenü des Punktes "Admin" anzeigen).',
        'Frontend module registration for the admin interface.' => 'Frontend-Modulregistrierung im Agentenbereich.',
        'Frontend module registration for the agent interface.' => 'Frontend-Modulregistrierung im Agent-Interface.',
        'Frontend module registration for the customer interface.' => 'Frontend-Modulregistrierung für den Kundenbereich.',
        'Frontend module registration for the public interface.' => 'Frontendmodul-Registrierung für das Public-Interface.',
        'Full value' => 'Vollständiger Wert',
        'Fulltext index regex filters to remove parts of the text.' => 'Volltextindex-Regex-Filter, um Textteile zu entfernen.',
        'Fulltext search' => 'Volltextsuche',
        'Fulltext search using Elasticsearch.' => 'Volltextsuche mit Elasticsearch.',
        'FulltextES' => 'FulltextES',
        'Galician' => 'Galizisch',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Anzeige von allgemeinen Ticket-Daten in Ticket-Übersichten (Fallback). Beachten Sie, dass die Ticket-Nummer nicht abgeschaltet werden kann.',
        'Generate HTML comment hooks for the specified blocks so that filters can use them.' =>
            'Generiert HTML-Kommentar-Anker für die angegebenen Blöcke, damit Filter diese nutzen können.',
        'Generate dashboard statistics.' => 'Übersichtsseitenstatistiken erstellen.',
        'Generic Info module.' => 'Generisches Informationsmodul.',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GenericInterface Debugger Benutzeroberfläche',
        'GenericInterface ErrorHandling GUI' => 'GenericInterface Fehlerbehandlungs-Benutzeroberfläche',
        'GenericInterface Invoker Event GUI' => 'GenericInterface Invoker Ereignis Benutzeroberfläche',
        'GenericInterface Invoker GUI' => 'GenericInterface Invoker Benutzeroberfläche',
        'GenericInterface Operation GUI' => 'GenericInterface Operation Benutzeroberfläche',
        'GenericInterface TransportHTTPREST GUI' => 'GenericInterface TransportHTTPREST Benutzeroberfläche',
        'GenericInterface TransportHTTPSOAP GUI' => 'GenericInterface TransportHTTPSOAP Benutzeroberfläche',
        'GenericInterface Web Service GUI' => 'GenericInterface Webservices-Benutzeroberfläche',
        'GenericInterface Web Service History GUI' => 'GenericInterface Webservice-Historie-Benutzeroberfläche',
        'GenericInterface Web Service Mapping GUI' => 'GenericInterface Webservice-Mapping-Benutzeroberfläche',
        'GenericInterface module registration for an error handling module.' =>
            'GenericInterface Modulregistrierung für ein Fehlerbehandlungs-Modul.',
        'GenericInterface module registration for the PassThrough invoker layer.' =>
            'Modulregistrierung für den PassThrough Invoker-Layer des GenericInterface.',
        'GenericInterface module registration for the TicketCreate invoker layer.' =>
            'GenericInterface-Modulregistrierung für den TicketCreate-Invoker Layer.',
        'GenericInterface module registration for the TicketUpdate invoker layer.' =>
            'GenericInterface-Modulregistrierung für den TicketUpdate-Invoker Layer.',
        'GenericInterface module registration for the invoker layer.' => 'Modulregistrierung für Invoker-Layer des GenericInterface.',
        'GenericInterface module registration for the mapping layer.' => 'Modulregistrierung für Mapping-Layer des GenericInterface.',
        'GenericInterface module registration for the operation layer.' =>
            'Modulregistrierung für Operation-Layer des GenericInterface.',
        'GenericInterface module registration for the transport layer.' =>
            'Modulregistrierung für Transport-Layer des GenericInterface.',
        'German' => 'Deutsch',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'Deutsche Stoppwörter für den Volltext-Index. Diese Wörter werden von Suchindex entfernt.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            'Gibt Kundenbenutzern gruppenbasierten Zugriff auf Tickets von Kundenbenutzern desselben Kunden (Kundennummer des Tickets ist eine Kundennummer des Kundenbenutzers).',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Gibt dem Endnutzer die Möglichkeit, das Separatorenzeichen von CSV-Dateien in der Übersetzungsdatei zu definieren. Bitte beachte: Wenn \'Active\' auf 0 eingestellt ist, so verhindert dies nur, dass Agenten die Einstellung dieser Gruppe in ihren persönlichen Einstellungen verändern können. Der Administrator kann weiterhin diese Einstellungen im Name von Benutzern verändern. Benutze \'PreferenceGroup\', um zu steuern, in welchem Bereich diese Einstellungen in der Benutzer-Oberfläche angezeigt werden.',
        'Global Search Module.' => 'Globales Suchmodul.',
        'Go to dashboard!' => 'Zur Übersicht gehen!',
        'Good PGP signature.' => 'Gültige PGP-Signatur.',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => 'Diagramm: Balken',
        'Graph: Line Chart' => 'Diagramm: Linien',
        'Graph: Stacked Area Chart' => 'Diagramm: Gestapelte Ebenen',
        'Greek' => 'Griechisch',
        'Hebrew' => 'Hebräisch',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            'Hilft beim Erweitern Ihres Artikel-Volltext-Suchindexes (Von-, An-, Cc-, Betreffs- und Text-Suche). Es erstellt einen Index nach Artikelerstellung, wodurch die Geschwindigkeit von Volltextsuchen um rund 50% steigt. Nutzen Sie "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild", um einen initialen Index zu erstellen.',
        'High Contrast' => 'Hoher Kontrast',
        'High contrast skin for visually impaired users.' => 'Skin mit hohem Kontrast für Nutzer mit Sehschwäche.',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Ungarisch',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, kann hier ein Datenbanktreiber definiert werden. Ansonsten wird der benötigte Treiber automatisch ermittelt.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, kann hier ein Passwort zum Verbinden zur Datenbank hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, kann hier ein Benutzername zum Verbinden zur Datenbank hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, muss hier der DSN zum Verbinden zur Datenbank hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, muss hier der Name der Spalte, die das Kundenpasswort enthält, hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, muss hier der Verschlüsselungstyp für Passwörter hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, muss hier der Name der Spalte, die CustomerKey enthält, hinterlegt werden.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Wenn "DB" als Customer::AuthModule ausgewählt ist, muss hier der Name der Tabelle, in der Kundendaten gespeichert werden sollen, hinterlegt werden.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Wenn "DB" als SessionModule ausgewählt ist, muss hier der Name der Tabelle, in der Sitzungsdaten gespeichert werden sollen, hinterlegt werden.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Wenn "FS" als SessionModule ausgewählt ist, muss hier der Name des Verzeichnisses, in dem Sitzungsdaten gespeichert werden sollen, hinterlegt werden.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Wenn "HTTPBasicAuth" als Customer::AuthModule ausgewählt ist, kann hier ein regulärer Ausdruck definiert werden, um Teile von REMOTE_USER zu entfernen (z.B. für anhängende Domänen). Hinweis: $1 enthält den neuen Login-Namen.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Wenn "HTTPBasicAuth" als Customer::AuthModule festgelegt wurde, können Sie festlegen, ob Teile am Anfang des Benutzernamens entfernt werden sollen (z. B. um die Domain aus Nutzernamen wie example_domain\user zu entfernen).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist und Sie einen Suffix zu jedem Kunden-Loginnamen hinzufügen möchten, können Sie dies hier festlegen (z.B. wenn "benutzername" im LDAP als "benutzername@domain" existiert).',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist und spezielle Parameter für das Perl-Modul Net::LDAP benötigt werden, können Sie diese hier angeben. Nutzen Sie "perldoc Net::LDAP" für weitere Informationen zu den Parametern.',
        'If "LDAP" was selected for Customer::AuthModule and you wish to use TLS security to communicate with the LDAP server, the "verify" parameter can be specified here. See Net::LDAP::start_tls for more information about the parameter.' =>
            'Wurde "LDAP" für das Customer::AuthModule ausgewählt und soll TLS zur sicheren Kommunikation mit dem LDAP-Server verwendet werden, können Sie hier den "Verify"-Parameter definieren. Weitere Informationen dazu finden Sie unter Net::LDAP::start_tls.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist und Ihre Nutzer nur anonymen Zugriff auf den LDAP-Baum haben, Sie die Daten aber durchsuchen möchten, können Sie dies mithilfe eines speziellen Users tun, dessen Passwort Sie hier angeben können.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist und Ihre Nutzer nur anonymen Zugriff auf den LDAP-Baum haben, Sie die Daten aber durchsuchen möchten, können Sie dies mithilfe eines speziellen Users tun, dessen Benutzernamen Sie hier angeben können.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, muss das BaseDN hier angegeben werden.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, kann der LDAP-Host hier angegeben werden.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, muss der User-Identifier hier angegeben werden.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, können hier Benutzer-Attribute spezifiziert werden. Nutzen Sie UID für LDAP-posixGroups, den vollen Benutzer-DN für nicht-LDAP-posixGroups.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, können hier Zugangs-Attribute bestimmt werden.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, können Sie hier festlegen, ob Anwendungen stoppen sollen, wenn z.B. die Verbindung zum Server aufgrund von Netzwerkproblemen nicht hergestellt werden kann.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTOBO. Specify the group, who may access the system.' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, können Sie prüfen, ob der Benutzer aufgrund seiner Mitgliedschaft in einer posixGroup Authentifizierungsberechtigt (z.B. wenn ein Nutzer Mitglied der Gruppe xyz sein muss, um OTOBO nutzen zu dürfen). Legen Sie diese Gruppe hier fest.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Wenn "LDAP" als Customer::AuthModule ausgewählt ist, können Sie hier Filter für jede LDAP-Anfrage festlegen, z.B. (mail=*), (objectclass=user) oder (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Wenn "Radius" als Customer::AuthModule ausgewählt ist, muss hier das Passwort zur Authentifizierung beim Radius-Host hinterlegt werden.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Wenn "Radius" als Customer::AuthModule ausgewählt ist, muss hier der Radius-Host hinterlegt werden.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Wenn "Radius" als Customer::AuthModule ausgewählt ist, können Sie hier festlegen, ob Anwendungen stoppen sollen, wenn z.B. die Verbindung zum Server aufgrund von Netzwerkproblemen nicht hergestellt werden kann.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Wenn "Sendmail" als SendmailModule konfiguriert wurde, müssen hier der Pfad zum Sendmail-binary und die benötigten Optionen hinterlegt werden.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Wenn "SysLog" als LogModule konfiguriert wurde, kann hier eine eigene Kategorie (facility) festgelegt werden.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Wenn "SysLog" als LogModule konfiguriert wurde, kann hier der Zeichensatz, der für das Logging verwendet werden soll, festgelegt werden.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'Wenn "bcrypt" als CryptType gewählt wurde, wird der hier eingetragene Cost-Parameter zur Berechnung verwendet. Derzeit wird als Wert maximal 31 unterstützt.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Wenn "Datei" als LogModule konfiguriert wurde, muss hier eine Log-Datei hinterlegt werden. Existiert die Datei nicht, wird sie automatisch vom System erstellt.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Wenn aktiviert, darf keiner der hier definierten regulären Ausdrücke auf die E-Mail-Adresse des Benutzers, der sich registrieren möchte, matchen.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Wenn aktiviert, muss mindestens einer der hier definierten regulären Ausdrücke auf die E-Mail-Adresse des Benutzers, der sich registrieren möchte, matchen.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Wenn einer der SMTP-Mechanismen als SendmailModule ausgewählt wurde und der Server eine Authentifizierung benötigt, muss hier ein Passwort angegeben werden.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Wenn einer der SMTP-Mechanismen als SendmailModule ausgewählt wurde und der Server eine Authentifizierung benötigt, muss hier ein Benutzername angegeben werden.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Wenn einer der SMTP-Mechanismen als SendmailModule ausgewählt wurde, muss hier der Mailhost, der die Mails versendet, angegeben werden.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Wenn einer der SMTP-Mechanismen als SendmailModule ausgewählt wurde, muss hier der Port, auf dem Ihr Mailserver auf eingehende Verbindungen lauscht, angegeben werden.',
        'If enabled debugging information for ACLs is logged.' => 'Wenn aktiviert, werden Debugging-Informationen für ACLs geloggt.',
        'If enabled debugging information for transitions is logged.' => 'Wenn aktiviert, werden Debugging-Informationen für Übergänge in Prozesstickets geloggt.',
        'If enabled defines the preselected state for customer follow-up in the customer interface.' =>
            'Definiert, wenn aktiviert, den vorausgewählten Status für das Kunden-Follow-up im Kundenbereich.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Aktivieren, um die Fehler-Ausgabe des Daemons in eine Log-Datei umzuleiten.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Aktivieren um die Standard-Ausgabe des Daemons in eine Log-Datei umzuleiten.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTOBOHome>/var/run/ can not be used.' =>
            'Wenn aktiviert, verwendet der Daemon dieses Verzeichnis, um seine PID-Dateien zu erstellen. Hinweis: Bitte stoppen Sie den Daemon vor der Änderung und nutzen Sie diese Einstellung nur, wenn <$OTOBOHome>/var/run/ nicht benutzt werden kann.',
        'If enabled, OTOBO will deliver all CSS files in minified form.' =>
            'Wenn aktiviert, liefert OTOBO CSS-Dateien in minifizierter Form aus.',
        'If enabled, OTOBO will deliver all JavaScript files in minified form.' =>
            'Wenn aktiviert, liefert OTOBO JavaScript-Dateien in minifizierter Form aus.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Wenn aktiviert, werden TicketPhone und TicketEmail in neuen Fenstern geöffnet.',
        'If enabled, the OTOBO version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'Wenn aktiviert, werden OTOBO-Versionsinformationen aus der Oberfläche und HTTP-Headern und X-Headern entfernt. Hinweis: Nach Änderung dieser Option muss der Cache gelöscht werden.',
        'If enabled, the cache data be held in memory.' => 'Wenn aktiviert, werden Cache-Daten im Speicher gehalten.',
        'If enabled, the cache data will be stored in cache backend.' => 'Wenn aktiviert, werden Cache-Daten im Cache Backend gespeichert.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Wenn aktiviert, können Kunden nach Tickets mit allen Services suchen (unabhängig davon, welche Services dem jeweiligen Kunden zugewiesen sind).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Wenn diese Option aktiviert ist, werden die verschiedenen Übersichtsseiten (Dashboard, LockedView, Queue-Ansicht) automatisch nach der angegebenen Zeit aktualisiert.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Wenn aktiviert, öffnet sich die erste Ebene des Hauptmenüs beim schon beim Überfahren der Maus (anstelle nur beim Klick).',
        'If enabled, the quick close action will create an article.' => 'Bei aktiviertem Parameter wird durch die Aktion "Sofort Schließen" ein Artikel angelegt.',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTOBOTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            'Wenn aktiviert, werden Benutzer, die bislang noch keine Zeitzone ausgewählt haben, benachrichtigt dies zu tun. Hinweis: Die Benachrichtigung wird nicht angezeigt, wenn (1) der Benutzer noch keine Zeitzone ausgewählt hat und (2) OTOBOTimeZone und UserDefaultTimeZone identisch sind und (3) nicht auf UTC gesetzt sind.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'Wenn SendmailNotificationEnvelopeFrom nicht definiert ist, ermöglicht es diese Einstellung, die Absenderadresse der E-Mail zu nutzen anstatt eines leeren Envelope-Absenders (bei einigen Mail-Server-Konfigurationen erforderlich).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'Wenn gesetzt, wird diese Adresse als Envelope-Sender-Header in ausgehenden Benachrichtigungen genutzt. Ist keine Adresse angegeben, bleibt der Header leer (außer SendmailNotificationEnvelopeFrom::FallbackToEmailFrom ist gesetzt).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Wenn gesetzt, wird diese Adresse als Envelope-Sender-Header in ausgehenden Nachrichten (nicht Benachrichtigungen, siehe unten) genutzt. Ist keine Adresse angegeben, entspricht der Envelope-Sender der an der Queue hinterlegten E-Mail-Adresse.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            'Wenn diese Option aktiviert ist, werden für Tickets, welche über das externe Interface oder das Agenten-Interface erstellt wurden, eine Automatische Antwort versendet, sofern dies in der Konfiguration der Queue so eingestellt ist. Wenn diese Option nicht aktiviert ist, werden keine Automatischen Antworten versendet.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Wenn dieser reguläre Ausdruck zutrifft, wird durch den Autoresponder keine Nachricht versendet.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTOBO Team. These packages could threaten your whole system!' =>
            'Wenn diese Einstellung aktiviert ist, können auch Pakete installiert werden, die nicht vom OTOBO Team verifiziert wurden. Diese Pakete können Ihr gesamtes System gefährden!',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'Wenn die Einstellung aktiv ist, werden lokale Änderungen in der Paketverwaltung und Supportdaten-Analyse nicht als Fehler angezeigt.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Informiert andere Benutzer über den genauen Zeitraum ihrer Abwesenheit.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'System-Artikeltypen (z. B. Auto-Antworten oder E-Mail-Benachrichtigungen) werden in AgentTicketZoom nicht als ungelesene Artikel markiert oder in Large-Übersichten nicht automatisch aufgeklappt.',
        'Ignores not ticket related attributes.' => 'Ignoriert Attribute ohne Ticket-Zusammenhang.',
        'Import appointments screen.' => 'Termin-Import Oberfläche.',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Tickets von Unterqueues automatisch mit einschließen, wenn eine Queue ausgewählt wird.',
        'Include unknown customers in ticket filter.' => 'Unbekannte Kunden in Ticketfiltern mit einschließen.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Schließt Artikel-Erstellzeiten in die Ticketsuche im Agentenbereich mit ein.',
        'Incoming Phone Call.' => 'Eingehender Telefonanruf.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: Auswahl des Backend-Moduls für das „TicketViewAccelerator“-Modul. „RuntimeDB“ generiert jede Queue-Ansicht dynamisch aus der Tickettabelle (keine Performance-Probleme bis etwa 60.000 Tickets insgesamt und 6.000 offene Tickets im System). „StaticDB“ ist das stärkste Modul, es nutzt eine zusätzliche Tabelle für den Ticket-Index, die wie eine Übersicht funktioniert (empfohlen ab mehr als 80.000 Tickets insgesamt und 6.000 offenen Tickets im System). Verwenden Sie das Kommando „bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild“ für den initialen Indexaufbau.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            'Legt fest, ob eine Bounce-E-Mail immer wie ein normales Follow-Up behandelt werden soll.',
        'Indonesian' => 'Indonesisch',
        'Inline' => 'Inline',
        'Input' => 'Eingabe',
        'Interface language' => 'Sprache Benutzeroberfläche',
        'Internal communication channel.' => 'Interner Kommunikationskanal.',
        'International Workers\' Day' => 'Tag der Arbeit',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es ist möglich, verschiedene Skins zu konfigurieren, zum Beispiel um zwischen verschiedenen Agenten auf Basis der jeweiligen Domain zu unterscheiden. Sie können durch Nutzung von regulären Ausdrücken mithilfe von Schlüssel-/Wert-Paaren auf Domains prüfen. Der Inhalt von "Schlüssel" sollte die Prüfung auf die Domain beinhalten, der Inhalt von "Wert" den Namen des zu selektierenden Skins für diese Domain. Bitte beachten Sie die Einträge mit Beispielen für korrekte reguläre Ausdrücke.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es ist möglich, verschiedene Skins zu konfigurieren, zum Beispiel um zwischen verschiedenen Kunden auf Basis der jeweiligen Domain zu unterscheiden. Sie können durch Nutzung von regulären Ausdrücken mithilfe von Schlüssel-/Wert-Paaren auf Domains prüfen. Der Inhalt von "Schlüssel" sollte die Prüfung auf die Domain beinhalten, der Inhalt von "Wert" den Namen des zu selektierenden Skins für diese Domain. Bitte beachten Sie die Einträge mit Beispielen für korrekte reguläre Ausdrücke.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Es ist möglich, verschiedene Themes zu konfigurieren, zum Beispiel um zwischen verschiedenen Agenten und Kunden auf Basis der jeweiligen Domain zu unterscheiden. Sie können durch Nutzung von regulären Ausdrücken mithilfe von Schlüssel-/Wert-Paaren auf Domains prüfen. Der Inhalt von "Schlüssel" sollte die Prüfung auf die Domain beinhalten, der Inhalt von "Wert" den Namen des zu selektierenden Themes für diese Domain. Bitte beachten Sie die Einträge mit Beispielen für korrekte reguläre Ausdrücke.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            'Die PGP-Signatur konnte nicht geprüft werden. Mögliche Ursachen sind ein fehlender öffentlicher Schlüssel oder ein nicht unterstützter Algorythmus.',
        'Italian' => 'Italienisch',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'Italienische Stoppwörter für den Volltext-Index. Diese Wörter werden von Suchindex entfernt.',
        'Ivory' => 'Elfenbein',
        'Ivory (Slim)' => 'Elfenbein (Schlank)',
        'Japanese' => 'Japanisch',
        'JavaScript function for the search frontend.' => 'JavaScript-Funktion für das Suche-Frontend.',
        'Jump to OTOBO!' => 'Link zu OTOBO!',
        'Korean' => 'Koreanisch',
        'Language' => 'Sprache',
        'Large' => 'Groß',
        'Last Screen Overview' => 'Letzte Masken-Übersicht',
        'Last customer subject' => 'Letzter Kunden-Betreff',
        'Lastname Firstname' => 'Nachname Vorname',
        'Lastname Firstname (UserLogin)' => 'Nachname Vorname (BenutzerAnmeldung)',
        'Lastname, Firstname' => 'Nachname, Vorname',
        'Lastname, Firstname (UserLogin)' => 'Nachname, Vorname (BenutzerLogin)',
        'LastnameFirstname' => 'NachnameVorname',
        'Latvian' => 'Lettisch',
        'Left' => 'Links',
        'Link Object' => 'Verknüpfe Objekt',
        'Link Object.' => 'Link-Objekt.',
        'Link agents to groups.' => 'Agenten zu Gruppen zuordnen.',
        'Link agents to roles.' => 'Agenten zu Rollen zuordnen.',
        'Link customer users to customers.' => 'Kundenbenutzer zu Kunden zuordnen.',
        'Link customer users to groups.' => 'Kundenbenutzer zu Gruppen zuordnen.',
        'Link customer users to services.' => 'Kundenbenutzer zu Services zuordnen.',
        'Link customers to groups.' => 'Kunden zu Gruppen zuordnen.',
        'Link queues to auto responses.' => 'Automatische Antworten zu Queues zuordnen.',
        'Link roles to groups.' => 'Rollen zu Gruppen zuordnen.',
        'Link templates to attachments.' => 'Vorlagen mit Anhängen verknüpfen.',
        'Link templates to queues.' => 'Vorlagen zu Queues zuordnen.',
        'Link this ticket to other objects' => 'Dieses Ticket mit anderen Objekten verknüpfen',
        'Links 2 tickets with a "Normal" type link.' => 'Verknüpft 2 Tickets mit dem Linktyp "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Verknüpft 2 Tickets mit dem Linktyp "Eltern-Kind".',
        'Links appointments and tickets with a "Normal" type link.' => 'Verknüpft Termine und Tickets mit einem Link vom Typ "Normal".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste der CSS-Dateien, die immer im Agenten-Interface geladen werden sollen.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste der CSS-Dateien, die immer im Kunden-Interface geladen werden sollen.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste der JavaScript-Dateien, die immer im Agenten-Interface geladen werden sollen.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste der JavaScript-Dateien, die immer im Kunden-Interface geladen werden sollen.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Liste aller Kundenereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Liste aller Kundenbenutzerereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Liste aller DynamischesFeld-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all LinkObject events to be displayed in the GUI.' => 'Liste aller LinkObject-Ereignisse die in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all Package events to be displayed in the GUI.' => 'Liste aller Paket-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all appointment events to be displayed in the GUI.' => 'Liste aller Termin-Events, welche in der Benutzeroberfläche angezeigt werden.',
        'List of all article events to be displayed in the GUI.' => 'Liste aller Artikel-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all calendar events to be displayed in the GUI.' => 'Liste aller Kalenderereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all queue events to be displayed in the GUI.' => 'Liste alle Queue-Ereignisse, die in der Benutzeroberfläche angezeigt werden.',
        'List of all ticket events to be displayed in the GUI.' => 'Liste aller Ticket-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            'Liste an Farben in Hexadezimal RGB, welche verschiedenen Benutzerkalendern zugewiesen werden. Stellen Sie sicher, dass die Farben dunkel genug sind, um weißen Text darauf darzustellen. Sofern die Anzahl der Kalender die Anzahl der verfügbaren Farben überschreitet, wird diese Liste erneut von Anfang an genutzt.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Liste der Standardvorlagen, welche neuen Queues nach Erstellung automatisch zugeordnet werden.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Liste von Responsive-CSS-Dateien, die im Agenten-Bereich immer geladen werden sollen.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'Liste von Responsive-CSS-Dateien, die im Kunden-Bereich immer geladen werden sollen.',
        'List of states for which escalations should be suspended.' => 'Liste aller Status, für die eine Eskalation ausgesetzt werden soll.',
        'List view' => 'Listenansicht',
        'Lithuanian' => 'Litauisch',
        'Loader module registration for the agent interface.' => 'Loader-Modulregistrierung für die Agentenoberfläche.',
        'Loader module registration for the customer interface.' => 'Loader-Modulregistrierung für das Kunden-Interface.',
        'Lock / unlock this ticket' => 'Dieses Ticket sperren / entsperren',
        'Locked Tickets' => 'Gesperrte Tickets',
        'Locked Tickets.' => 'Gesperrte Tickets.',
        'Locked ticket.' => 'Ticket gesperrt.',
        'Logged in users.' => 'Angemeldete Benutzer.',
        'Logged-In Users' => 'Angemeldete Nutzer',
        'Logout of customer panel.' => 'Abmelden vom Kunden-Bereich.',
        'Look into a ticket!' => 'Ticket genauer ansehen!',
        'Loop protection: no auto-response sent to "%s".' => 'Loop-Protection! Keine Auto-Antwort versandt an "%s".',
        'Macedonian' => 'Mazedonisch',
        'Mail Accounts' => 'E-Mailkonten',
        'MailQueue configuration settings.' => 'MailQueue Konfigurationseinstellungen.',
        'Main menu for the agent interface.' => 'Hauptmenü im Agentenbereich.',
        'Main menu item registration.' => 'Hauptmenü-Objektregistrierung.',
        'Main menu registration.' => 'Hauptmenü-Registrierung.',
        'Makes the application block external content loading.' => 'Lässt die Anwendung das Laden externer Inhalte blockieren.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Überprüft vor dem Senden einer E-Mail oder vor dem übermitteln eines Telefon-Tickets, den MX-Eintrag der E-Mailadresse.',
        'Makes the application check the syntax of email addresses.' => 'Überprüft die Syntax der E-Mailadressen.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Benutzt für das Session-Management HTML-Cookies. Wenn HTML-Cookies deaktiviert sind oder im Browser HTML-Cookies deaktiviert sind, arbeitet das System wie immer und fügt die Session-ID and Links an.',
        'Malay' => 'Malaysisch',
        'Manage OTOBO Team cloud services.' => 'Cloud Services des OTOBO Team managen.',
        'Manage PGP keys for email encryption.' => 'PGP-Schlüssel für E-Mail-Verschlüsselung verwalten.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'POP3- oder IMAP-Konten für das Abholen von E-Mail verwalten.',
        'Manage S/MIME certificates for email encryption.' => 'S/MIME-Zertifikate für E-Mail-Verschlüsselung verwalten.',
        'Manage System Configuration Deployments.' => 'Inbetriebnahmen von Systemkonfigurationen verwalten.',
        'Manage different calendars.' => 'Verschiedene Kalender verwalten.',
        'Manage dynamic field in screens.' => 'Dynamische Felder in Oberflächen verwalten.',
        'Manage existing sessions.' => 'Sitzungen verwalten.',
        'Manage support data.' => 'Supportdaten verwalten.',
        'Manage system registration.' => 'Systemregistrierung verwalten.',
        'Manage tasks triggered by event or time based execution.' => 'Verwaltung von event- oder zeitbasierten Aufgaben.',
        'Mark as Spam!' => 'Als Spam makieren!',
        'Mark this ticket as junk!' => 'Dieses Ticket als Junk markieren!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maximale Größe (Buchstaben) der Kundeninformationen (Telefon und E-Mail) in der Erfassungs-Oberfläche.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Maximale Größe (in Reihen) des "Informiere Agenten" Kästchen im Agenten-Interface.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Maximale Größe (in Reihen) des "Beteiligte Agenten" Kästchen im Agenten-Interface.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Maximale Länge des Betreffs in einer E-Mail-Antwort und in einigen Übersichts-Bildschirmen.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maximale Anzahl von automatischen E-Mailantworten zur eigenen E-Mail-Adresse pro Tag (Loop-Protection).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            'Maximale Anzahl automatischer E-Mail-Antworten zur eigenen E-Mail-Adresse pro Tag (Loop-Protection).',
        'Maximal number of results returned by ES per field.' => 'Maximale Anzahl von ES pro Feld ausgegebener Ergebnisse.',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maximale Größe in KBytes für E-Mails die via POP3/POP3S/IMAP/IMAPS empfangen werden (in KBytes).',
        'Maximum Number of a calendar shown in a dropdown.' => 'Maximale Anzahl an Kalendern, die in Auswahlmenüs angezeigt werden.',
        'Maximum file size for the ingest plugin.' => 'Maximale Dateigröße für das Ingest Plugin.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maximale Länge (Buchstaben) von Dynamischen Felder von Artikeln in der TicketZoom-Übersicht.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maximale Länge (Buchstaben) von Dynamischen Feldern in der Seitenleiste in der TicketZoom-Übersicht.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            'Maximale Anzahl an aktiven Kalendern in der Kalenderübersicht oder Resourcenübersicht. Bitte beachten Sie, dass sich zuviele gleichzeitig aktive Kalender aufgrund vieler gleichzeitiger Anfragen auf die Performance des Systems auswirken kann.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maximale Anzahl von Tickets, die im Suchergebnis des Agenten-Interfaces angezeigt werden sollen.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maximale Anzahl von Tickets, die im Suchergebnis des Kunden-Interfaces angezeigt werden sollen.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Maximale Anzahl von Tickets, die als Ergebnis dieser Aktion angezeigt werden sollen.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maximale Zeichenanzahl für die Tabelle mit Kundeninformationen in der TicketZoom-Ansicht.',
        'Medium' => 'Mittel',
        'Merge this ticket and all articles into another ticket' => 'Dieses Ticket und alle Artikel in ein anderes Ticket zusammenfassen',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'Ticket (%s/%s) zusammengeführt mit (%s/%s).',
        'Merged Ticket <OTOBO_TICKET> to <OTOBO_MERGE_TO_TICKET>.' => 'Ticket <OTOBO_TICKET> wurde mit <OTOBO_MERGE_TO_TICKET> zusammengefasst.',
        'Minute' => 'Minute',
        'Miscellaneous' => 'Verschiedenes',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Modul für die "An"-Auswahl im Ticket Erstellen-Bildschirm im Kundenbereich.',
        'Module to check if a incoming e-mail message is bounce.' => 'Prüfmodul zum Erkennen, ob es sich bei einer eingehenden E-Mail um eine abgelehnte E-Mail handelt.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            'Modul zur Prüfung, ob eingegangene E-Mails aufgrund einer vorher weitergeleiteten internen E-Mail als internal gekennzeichnet werden sollen. Über IsVisibleForCustomer und SenderType werden die Werte für die eingegangene E-Mail/den eingegangenen Artikel festgelegt.',
        'Module to check the group permissions for customer access to tickets.' =>
            'Modul zur Prüfung von Gruppen-Berechtigungen für den Zugriff von Kunden auf Tickets.',
        'Module to check the group permissions for the access to tickets.' =>
            'Modul zur Prüfung von Gruppen-Berechtigungen für den Zugriff auf Tickets.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul um signierte Nachrichten zu verfassen (PGP oder S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            'Modul um die genutzte E-Mail-Sicherheitsoption festzulegen (PGP oder S/MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => 'Modul um verschlüsselte Nachrichten zu verfassen (PGP oder S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'Modul zum Ermitteln von SMIME-Zertifikaten des Kundenbenutzers bei eingehenden Nachrichten.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Modul zum filtern und bearbeiten von eingehenden Nachrichten. Blockiere/Ignoriere alle Nachrichten mit einer noreply@ Absender-Adresse.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Modul zum Filtern und Verändern eingehender Nachrichten. Extrahieren Sie beispielsweise eine vierstellige Zahl aus dem Betreff (SomeNumber:1234) und speichern Sie sie in einem Dynamischen Feld, indem Sie in "Match" einen Schlüssel "Subject" mit dem regulären Ausdruck "SomeNumber:(\d\d\d\d)" und in "Set" einen Schlüssel "X-OTOBO-DynamicField-Name" mit dem Wert "[***]" anlegen.',
        'Module to filter encrypted bodies of incoming messages.' => 'Modul zum Filtern von verschlüsselten Texten bei eingehenden Nachrichten.',
        'Module to generate accounted time ticket statistics.' => 'Modul zur Generierung von Statistiken für die benötigte Bearbeitungszeit.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Modul zum Generieren eines HTML-OpenSearch-Profils für die Ticket-Schnellsuche im Agentenbereich.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Modul zum Generieren eines HTML-OpenSearch-Profils für die Ticket-Schnellsuche im Kundenbereich.',
        'Module to generate ticket solution and response time statistics.' =>
            'Modul zur Generierung von Lösungs- und Antwortzeitstatistiken.',
        'Module to generate ticket statistics.' => 'Modul zur Generierung von Ticket-Statistiken.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            'Modul zum Gestatten des Zugriffs, wenn die Kundennummer eines Kunden die notwendigen Gruppenrechte hat.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Modul zum Gestatten des Zugriffs, wenn die CustomerID eines Tickets der CustomerID des Kunden entspricht.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Modul zum Gestatten des Zugriffs, wenn die CustomerUserID eines Tickets der CustomerUserID des Kunden entspricht.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Modul zum Gestatten des Zugriffs für jeden Agenten, der einmal in ein Ticket involviert war (basierend auf den Einträgen in der Ticket-Historie).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Modul zum Gestatten des Zugriffs auf ein Ticket durch den verantwortlichen Agenten.',
        'Module to grant access to the creator of a ticket.' => 'Modul zum Gestatten des Zugriffs auf ein Ticket durch den Agenten, der das Ticket ursprünglich erstellt hat.',
        'Module to grant access to the owner of a ticket.' => 'Modul zum Gestatten des Zugriffs auf ein Ticket durch den Agenten, der Besitzer des Tickets ist.',
        'Module to grant access to the watcher agents of a ticket.' => 'Modul zum Gestatten des Zugriffs auf ein Ticket durch Agenten, die das Ticket beobachten.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Modul für die Anzeige von Benachrichtigungen und Eskalationen (ShownMax: max. angezeigte Eskalationen, EscalationInMinutes: Tickets, die in x Minuten eskalieren, CacheTime: Cache der kalkulierten Eskalationen in Minuten).',
        'Module to use database filter storage.' => 'Modul zur Nutzung des Datenbank Filter Storage.',
        'Module used to detect if attachments are present.' => 'Modul um das Vorhandensein von Anhängen zu prüfen.',
        'My Queues' => 'Meine Queues',
        'My Services' => 'Meine Services',
        'My last changed tickets' => 'Zuletzt geänderte Tickets',
        'MyLastChangedTickets dashboard widget.' => 'Dashboard-Widget "Zuletzt geänderte Tickets".',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Bezeichnung Ihrer persönlichen Queuekollektion. "Meine Queues" ist eine Zusammenstellung Ihrer bevorzugten Queues, die in den persönlichen Einstellungen konfiguriert werden kann.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Bezeichnung Ihrer persönlichen Servicekollektion. "Meine Services" ist eine Zusammenstellung von bevorzugten Services, die in den persönlichen Einstellungen konfiguriert werden kann.',
        'NameX' => 'NameX',
        'New Tickets' => 'Neue Tickets',
        'New Window' => 'Neues Fenster',
        'New Year\'s Day' => 'Neujahr',
        'New Year\'s Eve' => 'Silvester',
        'New process ticket' => 'Neues Prozess-Ticket',
        'News about OTOBO.' => 'Neuigkeiten über OTOBO.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Mögliche Folgestatus für Tickets, nachdem über den Eingehender Anruf-Bildschirm im Agentenbereich eine Telefonnotiz hinzugefügt wurde.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Mögliche Folgestatus für Tickets, nachdem über den Ausgehender Anruf-Bildschirm im Agentenbereich eine Telefonnotiz hinzugefügt wurde.',
        'No public key found.' => 'Kein öffentlicher Schlüssel gefunden.',
        'No valid OpenPGP data found.' => 'Keine gültigen OpenPGP-Daten gefunden.',
        'None' => 'Keine',
        'Norwegian' => 'Norwegisch',
        'Notification Settings' => 'Benachrichtigungseinstellungen',
        'Notified about response time escalation.' => 'Über Antwortzeit-Eskalation benachrichtigt.',
        'Notified about solution time escalation.' => 'Über Lösungszeit-Eskalation benachrichtigt.',
        'Notified about update time escalation.' => 'Über Aktualisierungszeit-Eskalation benachrichtigt.',
        'Number of displayed tickets' => 'Anzahl der angezeigten Tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Anzahl von Zeilen (pro Ticket), die über das Such-Tool im Agentenbereich angezeigt werden.',
        'Number of shards (NS), replicas (NR) and fields limit for the index \'ticket\'.' =>
            'Anzahl der Shards (NS), Replicas (NR) und Felderlimit für den Index "Ticket".',
        'Number of shards (NS), replicas (NR) and fields limit for the index. Note: \'Elasticsearch::ArticleIndexCreationSettings\' is deprecated. For upwards compatibility use \'Elasticsearch::IndexSettings###Default\' instead.' =>
            'Anzahl der Shards (NS), Replicas (NR) und Felderlimit für den Index. Hinweis: \'Elasticsearch::ArticleIndexCreationSettings\' wird nicht mehr genutzt. Verwenden Sie stattdessen \'Elasticsearch::IndexSettings###Default\', um die Kompatibilität mit neueren Versionen sicherzustellen.',
        'Number of shards (NS), replicas (NR) and fields limit for the indices. This replaces \'Elasticsearch::ArticleIndexCreationSettings\' in future versions. If both are present and not equal this one has priority. Use \'Elasticsearch::IndexSettings###...\' if you want to define special settings for single indices.\'...\' may be one of \'Customer\', \'CustomerUser\', \'Ticket\' or \'ConfigItem\'.' =>
            'Anzahl der Shards (NS), Replicas (NR) und Felderlimit für die Indizes. Diese Einstellung ersetzt \'Elasticsearch::ArticleIndexCreationSettings\' in neueren Versionen. Sind beide Einstellungen vorhanden und unterscheiden sie sich, wird diese priorisiert behandelt. Verwenden Sie \'Elasticsearch::IndexSettings###...\', um spezifische Einstellungen für einzelne Indizes zu definieren. \'...\' kann einer der folgenden Werte sein: \'Customer\', \'CustomerUser\', \'Ticket\' oder \'ConfigItem\'.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Anzahl von Tickets pro Seite in Suchergebnissen im Agentenbereich.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Anzahl der anzuzeigenen Tickets pro Seite in einem Suchergebnis in der Kundenoberfläche.',
        'OTOBO News' => 'Neues von OTOBO',
        'OTOBO Team Services' => 'Services von Team OTOBO',
        'OTOBO can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTOBO kann eine oder mehrere Spiegeldatenbanken für aufwändige Operationen wie Volltextsuchen oder Statistikgenerierungen nutzen. Hier können Sie die DSN für die erste Spiegeldatenbank hinterlegen.',
        'OTOBO doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTOBO unterstützt keine wiederholenden Termine ohne Enddatum oder Anzahl der Durchläufe. Während des Importierungsprozesses kann es vorkommen, dass die entsprechende ICS-Datei solche Termin enthält. Stattdessen wird das System alle vergangenen Termine erstellen, sowie zusätzlich Termine für die kommenden n Monate (120 Monate / 10 Jahre standardmäßig).',
        'Objects to search for, how many entries and which attributs to show.' =>
            'Definiert, nach welchen Objekten gesucht, wie viele Einträge und welche Attribute angezeigt werden sollen.',
        'Objects to search for, how many entries and which attributs to show. Ticket attributes, except queue, have to explicitely be stored via Elasticsearch.' =>
            'Definiert, nach welchen Objekten gesucht wird, wie viele Einträge und welche Attribute angezeigt werden sollen. Alle Ticket-Attribute außer der Queue müssen explizit in Elasticsearch gespeichert werden.',
        'Open an external link!' => 'Externen Link öffnen!',
        'Open the OTOBO home page in a new window' => 'Öffnet die OTOBO Homepage in einem neuen Fenster',
        'Open tickets (customer user)' => 'Offene Tickets (Kundenbenutzer)',
        'Open tickets (customer)' => 'Offene Tickets (Kunde)',
        'Option' => 'Option',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optionale Einschränkung auf Queues für das CreatorCheck Permission-Modul. Wenn gesetzt, wird die Erlaubnis nur für Tickets in den hier angegebenen Queues erteilt.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optionale Einschränkung auf Queues für das InvolvedCheck Permission-Modul. Wenn gesetzt, wird die Erlaubnis nur für Tickets in den hier angegebenen Queues erteilt.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optionale Einschränkung auf Queues für das OwnerCheck Permission-Modul. Wenn gesetzt, wird die Erlaubnis nur für Tickets in den hier angegebenen Queues erteilt.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optionale Einschränkung auf Queues für das ResponsibleCheck Permission-Modul. Wenn gesetzt, wird die Erlaubnis nur für Tickets in den hier angegebenen Queues erteilt.',
        'Other Customers' => 'Andere Kunden',
        'Out Of Office' => 'Derzeit nicht im Büro',
        'Out Of Office Time' => 'Abwesenheitszeit',
        'Out of Office users.' => 'Abwesende Benutzer.',
        'Outbound request headers not allowed to be used in frontend configuration.' =>
            'Header für ausgehende Anfragen, die in der Frontendkonfiguration nicht verwendet werden dürfen.',
        'Outbound response headers not allowed to be used in frontend configuration.' =>
            'Header für ausgehende Antworten, die in der Frontendkonfiguration nicht verwendet werden dürfen.',
        'Output filter to inject the necessary Dynamic field names in hidden input.' =>
            'Output-Filter zum verdeckten Einlesen der erforderlichen Dynamic Field-Namen.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Überlädt existierende Funktionen in Kernel::System::Ticket (redefining). Kann genutzt werden, um möglichst einfach Anpassungen vorzunehmen.',
        'Overview Escalated Tickets.' => 'Übersicht eskalierter Tickets.',
        'Overview Refresh Time' => 'Aktualisierungszeiten der Übersichten',
        'Overview of all Tickets per assigned Queue.' => 'Übersicht aller Tickets pro zugewiesener Queue.',
        'Overview of all appointments.' => 'Übersicht aller Termine.',
        'Overview of all escalated tickets.' => 'Übersicht aller eskalierter Tickets.',
        'Overview of all open Tickets.' => 'Übersicht über alle offenen Tickets.',
        'Overview of all open tickets.' => 'Übersicht aller offenen Tickets.',
        'Overview of customer tickets.' => 'Übersicht von Kunden-Tickets.',
        'PGP Key' => 'PGP-Schlüssel',
        'PGP Key Management' => 'PGP-Schlüssel-Verwaltung',
        'PGP Keys' => 'PGP-Schlüssel',
        'Package event module file a scheduler task for update registration.' =>
            'Modul zum automatischen Planen der Aktualisierung der System-Registrierung.',
        'Package event module trigger package reinstall in containers.' =>
            'Modul zum automatischen Triggern der Paketneuinstallation in Containern.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter des CreateNextMask-Objekts in den Benutzereinstellungen der Agenten-Oberfläche. Bitte beachte: Wenn \'Active\' auf 0 eingestellt ist, so verhindert dies nur, dass Agenten die Einstellung dieser Gruppe in ihren persönlichen Einstellungen verändern können. Der Administrator kann weiterhin diese Einstellungen im Name von Benutzern verändern. Benutze \'PreferenceGroup\', um zu steuern, in welchem Bereich diese Einstellungen in der Benutzer-Oberfläche angezeigt werden.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter des CustomQueue-Objekts in den Benutzereinstellungen der Agenten-Oberfläche. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter des CustomService-Objekts in der Einstellungsansicht der Agenten-Oberfläche. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter des RefreshTime-Objekts in der Einstellungsansicht der Agenten-Oberfläche. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter der Spalten-Filter des Small-Ticket-Übersicht. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the dashboard backend of the closed tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parameter für das Dashboard-Backend der Übersicht geschlossener Tickets in der Agentenoberfläche. "Limit" ist die Anzahl der im Standard angezeigten Einträge. "Group" wird verwendet, um den Zugriff auf das Plugin einzuschränken (z. B. Group: admin;group1;group2;). "Default" let fest, ob das Plugin standardmäßig aktiviert sein oder vom Benutzer manuell zu aktivieren sein soll. "CacheTTLLocal" ist die Cache-Zeit in Minuten für das Plugin. Hinweis: Nur Ticketattribute und dynamische Felder (DynamicField_NameX) sind als Standardspalten (DefaultColumns) zulässig.',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten.',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter für das Dashboard-Backend des Kundennummer-Status-Widgets im Agentenbereich. Über "Group" kann der Zugriff auf das Plugin beschränkt werden (z. B. Group: admin;group1;group2;). "Default" gibt an, ob das Plugin standardmäßig aktiviert sein soll oder ob der Nutzer es manuell aktivieren muss. "CacheTTLLocal" bestimmt die Laufzeit des Plugin-Caches in Minuten.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter für das Dashboard-Backend des Kundenlisten-Widgets im Agentenbereich. "Limit" bestimmt die Anzahl der standardmäßig angezeigten Einträge. Über "Group" kann der Zugriff auf das Plugin beschränkt werden (z. B. Group: admin;group1;group2;). "Default" gibt an, ob das Plugin standardmäßig aktiviert sein soll oder ob der Nutzer es manuell aktivieren muss. "CacheTTLLocal" bestimmt die Laufzeit des Plugin-Caches in Minuten.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Hinweis: Für DefaultColumns sind nur Ticketattribute und Dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "QueuePermissionGroup" legt fest (wenn aktiviert), dass nur Queues gelistet werden, die zur entsprechenden Rechtegruppe gehören. "States" ist eine Liste von Status, der Schlüssel ist die Sortierreihenfolge des Status im Widget. "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parameter für das Dashboard-Backend der Ticket-Eskalationsübersicht des Agenten-Interface. "Limit" ist die Anzahl der standardmäßig angezeigten Einträge. "Gruppe" wird verwendet, um den Zugriff auf das Plugin einzuschränken (z. B. Gruppe: admin;group1;group2;). "Standard" bestimmt, ob das Plugin standardmäßig aktiviert ist oder ob der Benutzer es manuell aktivieren muss. "CacheTTLLocal" ist die Cache-Zeit in Minuten für das Plugin. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) erlaubt.',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) möglich.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parameter für das Dashboard-Backend für die Ticketübersicht ausstehender Erinnerung im Agenten-Interface. "Limit" ist die Anzahl der standardmäßig angezeigten Einträge. "Gruppe" wird verwendet, um den Zugriff auf das Plugin einzuschränken (z. B. Gruppe: admin;group1;group2;). "Standard" bestimmt, ob das Plugin standardmäßig aktiviert ist oder ob der Benutzer es manuell aktivieren muss. "CacheTTLLocal" ist die Cache-Zeit in Minuten für das Plugin. Hinweis: Für DefaultColumns sind nur Ticketattribute und dynamische Felder (DynamicField_NameX) erlaubt.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Legt die Parameter für das Dashboard-Backend fest. "Limit" legt die Anzahl an Einträgen fest, die standardmäßig angezeigt werden. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. "CacheTTLLocal" bestimmt die Cachingdauer für das Dashlet in Minuten. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            'Parameter für die einzelnen Seiten der Verbindungsprotokoll-Übersicht (auf denen Einträge des Verbindungsprotokoll angezeigt werden).',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter der Seiten (in der die dynamischen Felder angezeigt werden) der dynamischen-Felder-Übersicht. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter der Seiten (in der die Tickets angezeigt werden) der Medium-Ticket-Übersicht. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter der Seiten (in der die Tickets angezeigt werden) der Small-Ticket-Übersicht. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parameter der Seiten (in der die Tickets angezeigt werden) der Ticket-Vorschau-Übersicht. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Parameters of the example SLA attribute Comment2.' => 'Parameter für das Beispiel-SLA-Attribut Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Parameter für das Beispiel-Queue-Attribut Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Parameter für das Beispiel-Service-Attribut Comment2.',
        'Parent' => 'Eltern',
        'ParentChild' => 'Eltern-Kind',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Pfad zur Log-Datei (wird nur angewandt und ist dann verpflichtend, wenn "FS" als LoopProtectionModule ausgewählt wurde).',
        'Pending time' => 'Warten bis',
        'People' => 'Personen',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            'Führt die konfigurierte Aktion für jedes Ereignis für jeden konfigurierten Webservice aus (als Invoker).',
        'Permitted width for compose email windows.' => 'Erlaubte Breite für E-Mail erstellen-Fenster.',
        'Permitted width for compose note windows.' => 'Erlaubte Breite für Notiz erstellen-Fenster.',
        'Persian' => 'Persisch',
        'Phone Call Inbound' => 'Eingehender Telefonanruf',
        'Phone Call Outbound' => 'Ausgehender Telefonanruf',
        'Phone Call.' => 'Telefonanruf.',
        'Phone call' => 'Telefonanruf',
        'Phone communication channel.' => 'Telefon-Kommunikationskanal.',
        'Phone-Ticket' => 'Telefon-Ticket',
        'Picture Upload' => 'Bild-Upload',
        'Picture upload module.' => 'Bild-Upload-Modul.',
        'Picture-Upload' => 'Bild-Hochladen',
        'Please click the button below to create your first ticket.' => 'Bitte verwenden Sie den Knopf unten zur Erstellung Ihres ersten Tickets.',
        'Plugin search' => 'Pluginsuche',
        'Plugin search module for autocomplete.' => 'Module zur Pluginsuche für die Autovervollständigung.',
        'Polish' => 'Polnisch',
        'Portuguese' => 'Portugiesisch',
        'Portuguese (Brasil)' => 'Portugiesisch (Brasilien)',
        'PostMaster Filters' => 'Postmaster-Filter',
        'PostMaster Mail Accounts' => 'Postmaster-E-Mail-Konten',
        'Print this ticket' => 'Dieses Ticket drucken',
        'Priorities' => 'Prioritäten',
        'Process Management Activity Dialog GUI' => 'Prozess-Management Aktivität-Dialog Benutzeroberfläche',
        'Process Management Activity GUI' => 'Prozess-Management-Aktivitäten Benutzeroberfläche',
        'Process Management Path GUI' => 'Prozess-Management-Pfad Benutzeroberfläche',
        'Process Management Transition Action GUI' => 'Prozess-Management Übergangs-Aktionen Benutzeroberfläche',
        'Process Management Transition GUI' => 'Prozess-Management-Übergangs Benutzeroberfläche',
        'Process pending tickets.' => 'Abarbeitung wartender Tickets.',
        'ProcessID' => 'ProcessID',
        'Processes & Automation' => 'Prozesse & Automatisierung',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Schutz gegen CSRF-Lücken (Cross Site Request Forgery). Besuchen Sie https://de.wikipedia.org/wiki/Cross-Site-Request-Forgery für mehr Informationen.',
        'Protection against brute force attacks. MaxAttempt: How many login attempts are allowed before a ban. BanDuration: Duration of the ban. KeepCacheDuration: How long failed attempts are remembered.' =>
            'Schutz vor Brute-Force-Angriffen. MaxAttempt: Wie viele Anmeldeversuche zugelassen werden, bevor ein Anwender gesperrt wird. BanDuration: Dauer der Sperre. KeepCacheDuration: Wie lange fehlgeschlagene Anmeldeversuche gespeichert werden.',
        'Provides a matrix overview of the tickets per state per queue' =>
            'Stellt eine Matrix-Übersicht von Tickets pro Status in Queues zur Verfügung',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            'Gibt Kundenbenutzern Zugriff auf Tickets, auch wenn diese nicht einem Kundenbenutzer derselben Kundennummer zugewiesen sind, basierend auf Gruppenrechten.',
        'Public Calendar' => 'Öffentlicher Kalender',
        'Public Interface' => 'Public Interface',
        'Public calendar.' => 'Öffentlicher Kalender.',
        'Queue view' => 'Ansicht nach Queues',
        'Queues ↔ Auto Responses' => 'Queues ↔ Automatische Antworten',
        'Quick Close' => 'Sofort Schließen',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Ticket-Index für AgentTicketQueue neu aufbauen.',
        'Rebuilds Elasticsearch indices. Can be used for example, if CustomerUsers are authenticated via LDAP. Highly inefficient however, as the whole index is rebuild every time.' =>
            'Erstellt die Elasticsearch-Indizes neu. Kann etwa verwendet werden, wenn Kundenbenutzer sich via LDAP authentifizieren. Jedoch höchst ineffizient, da jedes Mal, da der gesamte Index immer komplett neu generiert wird.',
        'Rebuilds the ACL preselection cache.' => 'Baut den Cache mit der ACL-Vorauswahl neu auf.',
        'Rebuilds the escalation index.' => 'Baut den Eskalationsindex neu auf.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            'Erkennen Sie, ob ein Ticket eine Folgemaßnahme zu einem bestehenden Ticket ist, indem Sie eine externe Ticket-Nummer verwenden. Hinweis: Die erste erfasste Gruppe aus dem Ausdruck \'NumberRegExp\' wird als Wert für die Ticket-Nummer verwendet.',
        'Redis server address. Example: 127.0.0.1:6379.' => 'Adresse des Redis-Servers. Beispiel: 127.0.0.1:6379.',
        'Refresh interval' => 'Aktualisierungsintervall',
        'Registers a log module, that can be used to log communication related information.' =>
            'Registriert ein Protokoll-Modul, um Informationen zu Verbindungen zu protokollieren.',
        'Reminder Tickets' => 'Erinnerungs-Tickets',
        'Removed subscription for user "%s".' => 'Abo für Benutzer "%s" ausgetragen.',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            'Entfernt alte Generic Interface Debug Log-Einträge, die vor der angegebenen Anzahl von Tagen erstellt wurden.',
        'Removes old system configuration deployments (Sunday mornings).' =>
            'Entfernt veraltete Inbetriebnahmen der Systemkonfiguration (Sonntagmorgens).',
        'Removes old ticket number counters (each 10 minutes).' => 'Entfernt veraltete Ticketnummern-Zähler (alle 10 Minuten).',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Entfernt die Ticket-Beobachter-Information, wenn ein Ticket archiviert wird.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            'Existierende SMIME-Zertifikate aus dem Kundenbereich erneuern. Hinweis: SMIME und SMIME::FetchFromCustomer müssen aktiv und das Kunden-Backend so konfiguriert sein, dass UserSMIMECertificate-Attribute ermittelt werden.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Ersetzt den ursprünglichen Absender durch die E-Mail-Adresse des aktuellen Kunden beim Verfassen einer Antwort im Ticket verfassen-Bildschirm des Agentenbereichs.',
        'Reports' => 'Berichte',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Wiederhole die Verarbeitung von E-Mails aus dem Spool-Verzeichnis, die im ersten Durchlauf nicht importiert werden konnten.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Zum Ändern des Kunden eines Tickets im Agentenbereich erforderliche Rechte.',
        'Required permissions to use quick close in the agent interface.' =>
            'Zum Aufrufen des "Sofort schließen"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Zum Aufrufen des "Schließen"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Zum Anlegen eines neuen E-Mail-Tickets im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            'Zum erneuten Senden von E-Mails im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Zum Aufrufen des "Umleiten"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Zum Verfassen von Tickets im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Zum Aufrufen des "Weiterleiten"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Zum Aufrufen des "Freitext"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Zum Aufrufen des "Zusammenfassen"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Zum Aufrufen des "Notiz"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Zum Aufrufen des "Besitzer"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Zum Aufrufen des "Warten"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Zum Aufrufen des "Neues Telefonticket (eingehend)"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Zum Aufrufen des "Neues Telefonticket (ausgehend)"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Zum Aufrufen des "Priorität"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Zum Aufrufen des "Verantwortlicher"-Dialogs im Agentenbereich erforderliche Rechte.',
        'Resend Ticket Email.' => 'Ticket-E-Mail erneut senden.',
        'Resent email to "%s".' => 'E-Mail erneut senden an "%s".',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Setzt den Besitzer eines TIckets zurück und entsperrt es, wenn das Ticket in eine andere Queue verschoben wird.',
        'Responsible Tickets' => 'Verantwortliche Tickets',
        'Responsible Tickets.' => 'Verantwortliche Tickets.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'Stellt ein Ticket aus dem Archiv wieder her (nur, wenn der Status auf einen der verfügbaren offen-Status geändert wird).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Behält alle Services in Auflistungen bei, auch, wenn sie Kind-Services von ungültigen Elementen sind.',
        'Right' => 'Rechts',
        'Roles ↔ Groups' => 'Rollen ↔ Gruppen',
        'Romanian' => 'Rumänisch',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Dateibasierte Generic-Agent-Jobs ausführen (Hinweis: Der Modulname muss im Parameter -configuration-module angegeben sein, z. B. "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Aktive Prozess-Tickets',
        'Runs an initial wildcard search of the existing contacts with data when accessing the AdminContactWD module.' =>
            'Führt eine initiale Wildcard-Suche nach bestehenden Kontaktdaten aus, sobald auf das AdminContactWD-Modul zugegriffen wird.',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Führt eine initiale Wildcard-Suche für bestehende Kundenfirmen aus, wenn auf AdminCustomerCompany zugegriffen wird.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Führt eine initiale Wildcard-Suche für bestehende Kundenbenutzer aus, wenn auf AdminCustomerUser zugegriffen wird.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Führt das System im "Demo" Modus aus. Wenn die Einstellung aktivier ist, können Agenten Einstellungen, wie die Sprachauswahl oder das Design über die Agenten Weboberfläche ändern. Diese Einstellungen sind nur für die aktuelle Sitzung gültig. Agenten können ihr Passwort nicht ändern.',
        'Russian' => 'Russisch',
        'S/MIME Certificates' => 'S/MIME-Zertifikate',
        'Salutations' => 'Anreden',
        'Sample command output' => 'Beispielhafte Kommando-Ausgabe',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTOBO user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used. "S3" is experimental.' =>
            'Speichert die Anhänge von Artikeln. "DB" speichert alle Daten in der Datenbank (nicht geeignet zur Speicherung großer Anhänge!). "FS" speichert die Daten im Filesystem; das ist schneller, der Webserver sollte aber vom OTOBO Nutzer ausgeführt werden. Ein Wechsel zwischen den beiden Speicheroptionen ist auch auf Produktivsystemen ohne Datenverlust möglich. Hinweis: Wird "FS" verwendet, kann nicht nach Namen von Anhängen gesucht werden. "S3" ist noch experimentell.',
        'Schedule a maintenance period.' => 'Eine Wartungsperiode planen.',
        'Screen after new ticket' => 'Ansicht nach Ticket-Erstellung',
        'Search Customer' => 'Kunden suchen',
        'Search Ticket.' => 'Ticket suchen.',
        'Search Tickets.' => 'Tickets suchen.',
        'Search User' => 'Benutzer suchen',
        'Search backend default router.' => 'Standard-Router für Such-Backend.',
        'Search backend router.' => 'Router für Such-Backend.',
        'Search.' => 'Suche.',
        'Second Christmas Day' => '2. Weihachtstag',
        'Second Queue' => 'Zweite Queue',
        'Select after which period ticket overviews should refresh automatically.' =>
            'Definiert, in welchen Zeitabständen die Ticket-Zusammenfassung automatisch aktualisiert wird.',
        'Select how many tickets should be shown in overviews by default.' =>
            'Definiert, wieviele Tickets in der Übersicht standardmäßig angezeigt werden.',
        'Select the algorithm used for encryption. Fallback is aes256. Try "/usr/bin/openssl enc -ciphers" to get a list of ciphers supported by your system (written without the leading \'-\').' =>
            'Wählen Sie den zur Verschlüsselung verwendeten Algorithmus aus. Als Fallback wird aes256 verwendet. Geben Sie "/usr/bin/openssl enc -ciphers" ein, um eine Liste der von Ihrem System unterstützten Ciphers zu erhalten (Eingabe ohne vorangestelltes \'-\').',
        'Select the main interface language.' => 'Wählen Sie die Sprache der Hauptoberfläche.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Wählen Sie das Trennzeichen, dass in CSV-Dateien (Statistiken und Suchenergebnisse) benutzt werden soll. Wenn Sie hier kein Zeichen wählen, dann wird das Standard-Trennzeichen gemäß der eingestellten Sprache benutzt.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            'Wählen Sie Ihre persönliche Zeitzone aus. Alle Zeiten werden relativ zur eingestellten Zeitzone angezeigt.',
        'Select your preferred layout for the software.' => 'Wählen Sie Ihr bevorzugtes Layout aus.',
        'Select your preferred theme for OTOBO.' => 'Wählen Sie Ihr bevorzugtes Design für OTOBO.',
        'Selects the cache backend to use.' => 'Gibt das zu verwendende Cache Backend an.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Auswahl wie Uploads über die Web-Oberfläche gehandhabt werden sollen. "DB" speichert alle Uploads in der Datenbank, "FS" nutzt das Dateisystem.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            'Definiert das Modul zur Generierung von Ticketnummern. "AutoIncrement" erhöht den Zähler fortlaufend, dazu werden System-ID und Zähler im Format "System-ID.Zähler" dargestellt. "Datum" generiert Ticketnummern basierend auf dem jeweiligen Datum, der System-ID und dem Zähler im Format "Jahr.Monat.Tag.System-ID.Zähler" (z. B. "200206231010138", "200206231010139"). "DateChecksum" fügt den Zähler als Checksumme nach Datum und System-ID ein. Die Checksumme ändert sich dabei täglich. Format: "Jahr.Monat.Tag.System-ID.Zähler.Checksumme" (z. B. "2002070110101520", "2002070110101535").',
        'Send new outgoing mail from this ticket' => 'Neue ausgehende E-Mail aus diesem Ticket heraus senden',
        'Send notifications to users.' => 'Benachrichtigungen an Agenten verschicken.',
        'Sender type for new tickets from the customer inteface.' => 'Absender Typ für neue Tickets aus der Kunden-Oberfläche.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Sendet Rückfrage Benachrichtigungen für Agenten nur an den Ticket Besitzer wenn das Ticket entsperrt ist (standardmäßig werden die Benachrichtigungen an alle Agenten gesendet).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Versendet alle ausgehenden E-Mails via BCC zu der angegebenen Adresse. Bitte nutzen Sie dies ausschließlich für Backups.',
        'Sends customer notifications just to the mapped customer.' => 'Versendet Kundenbenachrichtigungen nur für den gemappten Kunden.',
        'Sends registration information to OTOBO group.' => 'Übermitteln der Registrierungsinformationen an die Rother OSS GmbH.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Sendet eine Erinnerung eines Entsperrten Tickets nachdem das Erinnerungsdatum erreicht wurde. (Nur zum Besitzer des Tickets gesendet).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Sendet eine Benachrichtigung, welche im Admin-Interface unter "Ticket-Benachrichtigen" eingestellt ist.',
        'Sent "%s" notification to "%s" via "%s".' => 'Benachrichtigung "%s" versandt an "%s" via "%s".',
        'Sent auto follow-up to "%s".' => 'Automatische Rückfrage versandt an "%s".',
        'Sent auto reject to "%s".' => 'Automatische Ablehnung versandt an "%s".',
        'Sent auto reply to "%s".' => 'Automatische Antwort versandt an "%s".',
        'Sent email to "%s".' => 'E-Mail versandt an "%s".',
        'Sent email to customer.' => 'E-Mail an Kunden versandt.',
        'Sent notification to "%s".' => 'Benachrichtigung versandt an "%s".',
        'Serbian Cyrillic' => 'Kyrillisches Serbisch',
        'Serbian Latin' => 'Lateinisches Serbisch',
        'Service Level Agreements' => 'Service-Level-Vereinbarungen',
        'Service view' => 'Ansicht nach Services',
        'ServiceView' => 'DienstAnsicht',
        'Set a new password by filling in your current password and a new one.' =>
            'Setzen Sie ein neues Passwort, indem Sie Ihr derzeitiges und ein neues Passwort eintragen.',
        'Set sender email addresses for this system.' => 'Absendeadressen für dieses System verwalten.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Definiert Standardhöhe (in Pixel) für Inline_HTML-Feldern in AgentTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Legt die maximale Anzahl an Tickets fest, die pro GenericAgent-Job-Ausführung bearbeitet werden.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Definiert maximale Höhe (in Pixel) für Inline_HTML-Feldern in AgentTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            'Legt die minimale Protokoll-Ebene fest. Wählen Sie „Fehler“ aus, werden nur Fehler protokolliert. Mit „Debug“ erhalten Sie alle Log-Einträge. Die Reihenfolge der Ebenen ist Debug, Info, Hinweis und Fehler.',
        'Set this ticket to pending' => 'Ticket auf "warten" setzen',
        'Sets if SLA must be selected by the agent.' => 'Gibt an, ob ein SLA durch einen Agenten ausgewählt sein muss.',
        'Sets if SLA must be selected by the customer.' => 'Gibt an, ob ein SLA durch einen Kundenbenutzer ausgewählt sein muss.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Setzt ob eine Notiz vom Agenten ausgefüllt werden muss. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Sets if queue must be selected by the agent.' => 'Legt fest, ob Agenten eine Queue wählen müssen.',
        'Sets if service must be selected by the agent.' => 'Gibt an, ob ein Service durch einen Agenten ausgewählt sein muss.',
        'Sets if service must be selected by the customer.' => 'Gibt an, ob ein Service durch einen Kundenbenutzer ausgewählt sein muss.',
        'Sets if state must be selected by the agent.' => 'Legt fest, ob Agenten einen Status wählen müssen.',
        'Sets if ticket owner must be selected by the agent.' => 'Gibt an, ob ein Ticket-Besitzer durch einen Agenten ausgewählt sein muss.',
        'Sets if ticket responsible must be selected by the agent.' => 'Legt fest, ob Agenten einen Verantwortlichen wählen müssen.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Setzt die Wartezeit eines Tickets auf 0, wenn der Status auf einen nicht warten-Status gesetzt wird.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Definiert das Ticket Alter in Minuten bevor die Queues mit unbearbeiteten Tickets hervorgehoben werden (erstes Level).',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Definiert das Ticket Alter in Minuten bevor die Queues mit unbearbeiteten Tickets hervorgehoben werden (zweites Level).',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Bestimmt das Konfigurationslevel des Administrators. Abhängig von diesem Level werden einige Optionen der Sysconfig nicht angezeigt. Die verfügbaren Level sind in absteigender Reihenfolge: Experte, Fortgeschrittener, Anfänger. Je höher das Level ist (wobei Anfänger das höchste Level ist), desto niedriger ist die Wahrscheinlichkeit, dass der Nutzer das System versehentlich so konfiguriert, dass es nicht mehr nutzbar ist.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Legt die Anzahl von Artikeln fest, die im Vorschau-Modus von Ticketübersichten sichtbar sein soll.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            'Bestimmt die voreingestellte Sichtbarkeit von Artikeln für Kunden in E-Mail-Tickets im Agentenbereich.',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            'Bestimmt die voreingestellte Sichtbarkeit von Artikeln für Kunden in Telefon-Tickets im Agentenbereich.',
        'Sets the default article customer visibility for quick close action in the agent interface.' =>
            'Bestimmt die voreingestellte Sichtbarkeit von "Sofort schließen"-Artikeln für Kunden im Agentenbereich.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Schließen" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Verschieben" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Notiz" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Besitzer" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Warten auf Erinnerung" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Priorität" Ansicht in der Agenten-Oberfläche.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Definiert den Standard Body-Text für Notizen in der "Ticket Verantwortlicher" Ansicht in der Agenten-Oberfläche.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Legt die Standard-Fehlermeldung fest, die auf der Anmeldemaske des Agenten- und Kundenbereichs angezeigt wird, wenn sich das System gerade im Wartungsmodus befindet.',
        'Sets the default link type of split tickets in the agent interface.' =>
            'Bestimmt den voreingestellten Link-Typ für geteilte Tickets im Agentenbereich.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Bestimmt den Standard-Linktyp für geteilte Tickets im Agentenbereich.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Setzt die Standard Nachricht für den Hinweis, der auf der Agenten- und Kunden-Oberfläche angezeigt wird, wenn sich das System im Wartungsmodus befindet.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Setzt die Standard Nachricht für den Hinweis, der angezeigt wird, wenn das System im Wartungsmodus läuft.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Setzt den Standard Ticket-Status für neue Telefon-Tickets in der Agenten-Oberfläche.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Setzt den Standard Ticket-Status für neue E-Mail-Tickets im Agenten-Interface.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Setzt die Standard Notiz für neue Telefon-Tickets. z.B. "Neues Ticket durch Anruf" im Agenten-Interface.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Setzt die Standard Priorität für neue E-Mail-Tickets in der Agenten-Oberfläche.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Setzt die Standard Priorität für neue Telefon-Tickets in der Agenten-Oberfläche.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Bestimmt den Standard-Sendertyp für neue E-Mail-Tickets im Agentenbereich.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Bestimmt den Standard-Sendertyp für neue Telefon-Tickets im Agentenbereich.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Bestimmt den Standard-Betreff für neue E-Mail-Tickets (z.B. "Ausgehende E-Mail") im Agentenbereich.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Bestimmt den Standard-Betreff für neue Telefon-Tickets (z.B. "Telefonanruf") im Agentenbereich.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticket schließen-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticket verschieben-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticketnotiz-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticketbesitzer-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Wartezeit für Ticket setzen-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticketprioriät-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Notizen, die im Ticketverantwortlicher-Bildschirm im Agentenbereich hinzugefügt werden.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Bestimmt den Standardtext für neue E-Mail-Tickets im Agentenbereich.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'Legt die Zeit in Sekunden fest, in der ein Nutzer untätig sein darf, bevor seine Sitzung automatisch beendet und der Nutzer ausgeloggt wird.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            'Definiert die maximale Anzahl aktiver Agenten innerhalb der in SessionActiveTime definierten Zeitspanne, bevor eine Warnung für die eingeloggten Agenten angezeigt wird.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'Legt die maximale Anzahl an aktiven Agenten innerhalb der in SessionMaxIdleTime festgelegten Zeitspanne fest.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'Legt die maximale Anzahl an aktiven Kundenbenutzern innerhalb der in SessionMaxIdleTime festgelegten Zeitspanne fest.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'Legt die maximale Anzahl an aktiven Sitzungen pro Agent innerhalb der in SessionMaxIdleTime festgelegten Zeitspanne fest.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'Legt die maximale Anzahl an aktiven Sitzungen pro Kundenbenutzer innerhalb der in SessionMaxIdleTime festgelegten Zeitspanne fest.',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            'Legt die Methode fest, mit der PGP E-Mails signieren und verschlüsseln soll. Bitte beachten Sie, dass die Methode "Inline" nicht für Richtext-Nachrichten verwendet werden kann.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Legt die minimale Größe für den Ticketzähler fest, wenn "AutoIncrement" als TicketNumberGenerator gewählt wurde. Die Standardeinstellung ist 5, was bedeutet, dass der Zähler bei 10000 startet.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Steuert, wie lange (in Minuten) die Benachrichtigung über eine bevorstehende Wartungsphase angezeigt werden soll.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Legt die Anzahl an Zeilen fest, die von Textnachrichten angezeigt werden sollen (z. B. von Tickets in der Queue-Ansicht).',
        'Sets the options for PGP binary.' => 'Legt die Optionen für die PGP-Binärdatei fest.',
        'Sets the password for private PGP key.' => 'Legt das Passwort für den privaten PGP-Schlüssel fest.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Legt die bevorzugten Zeiteinheiten fest (z.B. Arbeitseinheiten, Stunden, Minuten).',
        'Sets the preferred digest to be used for PGP binary.' => 'Legt den bevorzugten Digest für die PGP-Binärdatei fest.',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTOBO_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Legt den Prefix zum Skripte-Verzeichnis auf dem Server fest, analog zur Konfiguration des Webservers. Diese Einstellung wird als Variable OTOBO_CONFIG_ScriptAlias in allen Nachrichten-Formularen innerhalb der Applikation genutzt, um Links zu Tickets in Ihrem System zu generieren.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Schließen-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Freitext-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Notiz-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Besitzer-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Wartezeit setzen-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Priorität-Bildschirm von Tickets im Agentenbereich.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Setzt die Queue im Verantwortlicher-Bildschirm von Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Schließen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Stapelverarbeitungs-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Freitext-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Notiz-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Besitzer-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Wartezeit setzen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Priorität-Bildschirm für Tickets im Agentenbereich.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Setzt den verantwortlichen Agenten im Verantwortlicher-Bildschirm für Tickets im Agentenbereich.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Schließen-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Freitext-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Notiz-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Besitzer-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Wartezeit-Setzen-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Ticket-Prioriäten-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Setzt den Service im Verantwortlicher-Bildschirm für Tickets im Agentenbereich (Ticket::Service muss aktiviert sein).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Setzt den Status im Schließen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Setzt den Status im Stapelverarbeitungs-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Setzt den Status im Freitext-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Setzt den Status im Notiz-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Setzt den Status im Verantwortlicher-Bildschirm von Tickets im Agentenbereich.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Status im Besitzer-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Status im Wartezeit setzen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Status im Priorität-Bildschirm für Tickets im Agentenbereich.',
        'Sets the stats hook.' => 'Steuert den Hook für Statistiken.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Setzt den Besitzer im Schließen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Setzt den Besitzer im Stapelverarbeitungs-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Setzt den Besitzer im Freitext-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Setzt den Besitzer im Notiz-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Besitzer im Besitzer-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Besitzer im Wartezeit setzen-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Setzt den Besitzer im Priorität-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Setzt den Besitzer im Verantwortlicher-Bildschirm für Tickets im Agentenbereich.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Schließen-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Setzt den Ticket-Typ im Stapelverarbeitungs-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Freitext-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Ticket-Notiz-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Besitzer-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Wartezeit setzen-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Ticket-Prioritäts-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Setzt den Ticket-Typ im Verantwortlicher-Bildschirm für Tickets im Agentenbereich (Ticket::Type muss aktiviert sein).',
        'Sets the time zone being used internally by OTOBO to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            'Legt die Zeitzone fest, die intern von OTOBO genutzt werden soll (z. B. um Datumsangaben und Zeiten in der Datenbank zu speichern). ACHTUNG: Diese Einstellung darf nicht mehr geändert werden, sobald Tickets und/oder andere Objekte erstellt wurden, die Datumsangaben enthalten.',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTOBO time zone and the user\'s time zone.' =>
            'Legt die Zeitzone fest, die als Voreinstellung für neu angelegte Nutzer gelten soll. Diese Zeitzone wird dazu verwendet, um Datumsangaben und Uhrzeiten zwischen der OTOBO-Zeitzone und der Nutzer-Zeitzone korrekt zu konvertieren.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Steuert den Timeout (in Sekunden) für HTTP/FTP-Downloads.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Steuert den Timeout (in Sekunden) für Paket-Downloads. Überschreibt "WebUserAgent::Timeout".',
        'Settings for the customer login screen.' => 'Einstellungen für die Kunden-Loginoberfläche.',
        'Shared Secret' => 'Gemeinsames Geheimnis',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Steuert, ob in Telefon- und E-Mail-Tickets eine Auswahl für den verantwortlichen Agenten angezeigt werden soll (Agentenbereich).',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Steuert, ob der Artikel als Richtext angezeigt werden soll, auch wenn das Schreiben von Richtext abgeschaltet ist.',
        'Show command line output.' => 'Zeige Befehlszeilenausgabe.',
        'Show queues even when only locked tickets are in.' => 'Queues auch dann anzeigen, wenn sich darin nur gesperrte Tickets befinden.',
        'Show the current owner in the customer interface.' => 'Steuert, ob der aktuelle Besitzer im Kundenbereich angezeigt werden soll.',
        'Show the current queue in the customer interface.' => 'Steuert, ob die aktuelle Queue im Kundenbereich angezeigt werden soll.',
        'Show the history for this ticket' => 'Zeige die Historie für dieses Ticket an',
        'Show the ticket history' => 'Ticket-Historie anzeigen',
        'Show various content.' => 'Anzeige verschiedener Inhalte.',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            'Zeigt die Anhang-Anzahl im Ticket-Zoom an, wenn der Artikel Anhänge besitzt.',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link im Menü der TicketZoom-Ansicht im Agenten-Interface an, um Termine zu erstellen, welche direkt mit dem entsprechenden Ticket verknüpft sind. Zusätzliche Zugriffskontrolle, ob der Menüpunkt angezeigt wird oder nicht, kann mit dem Schlüssel "Gruppe" und "Inhalt" wie z.B. ("rw:group1;move_into:group2") erreicht werden. Um Menüeinträge zu gruppieren, verwenden Sie den Schlüssel "ClusterName" und im Inhalt den Namen, welchen Sie in der Ansicht verwenden möchten. Verwenden Sie "ClusterPriority" um die Reihenfolge in der jeweiligen Gruppierung zu beeinflussen.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum beobachten/nicht mehr beobachten eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Verlinken eines Tickets mit einem anderen Objekt im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Zusammenführen von Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Betrachten der Historie eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Bearbeiten der Freitextfelder eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Hinzufügen einer Notiz zu einem Ticket im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Hinzufügen von Notizen zu Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Hinzufügen eines eingehenden Telefonanrufs zu einem Ticket im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Hinzufügen eines ausgehenden Telefonanrufs zu einem Ticket im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt in der TicketZoom-Ansicht im Agentenbereich einen Menülink zum Ändern des Kunden an, der das Ticket eröffnet hat. Über die Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert kann gesteuert werden, welchen Agenten dieser Link angezeigt werden soll und welchen nicht. Um Elemente des Ticketmenüs zu gruppieren, können Sie "ClusterName" als Schlüssel und in "Content" einen beliebigen Namen als Wert verwenden, unter dem das Cluster in der Oberfläche angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Cluster innerhalb des Menüs zu steuern.',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Ändern des Besitzers eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Ändern des verantwortlichen Agenten eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Schließen von Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Schließen eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Zeigt einen Link zum Löschen von Tickets in den Ticketübersichten des Agentenbereichs an. Zusätzliche Zugriffskontrolle für diesen Link kann über den Schlüssel "Group" und dazugehörigen Inhalt wie "rw:group1;move_into:group2" als Wert erreicht werden.',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Löschen eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Zeigt einen Link zum Umwandeln eines regulären Tickets in ein Prozessticket in der Ticket-Detailansicht im Agenten-Interface an.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum zurück Gehen im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Zeigt einen Link zum Sperren/Entsperren eines Tickets im Ticket-Zoom des Agentenbereichs an.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Sperren/Entsperren eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Verschieben von Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Drucken eines Tickets oder Artikels im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to quick close a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Sofort Schließen von Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link in the menu to quick close a ticket in the ticket zoom view of the agent interface.' =>
            'Zeigt einen Link zum Sofort Schließen von Tickets in der Ticketübersicht des Agentenbereichs an.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Anzeigen der Historie von Tickets in den Ticketübersichten im Agentenbereich an.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Anzeigen der Priorität eines Tickets im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Senden einer ausgehenden E-Mail im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Zeigt in allen Ticket-Übersichten im Agentenbereich einen Link an, um Tickets als Junk zu kennzeichnen. Zusätzliche Zugriffskontrolle auf den Link kann durch befüllen des Schlüssels "Group" und befüllen des Contents (z. B. mit "rw:group1;move_into:group2") erreicht werden.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt einen Link zum Setzen einer Wartezeit für ein Ticket im Ticket-Zoom des Agentenbereichs an. Zusätzliche Zugriffskontrolle auf diesen Link kann durch Angabe von "Group" als Schlüssel und Inhalten wie "rw:group1;move_into:group2" als Wert konfiguriert werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Zeigt einen Link zum Verändern der Priorität von Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Zeigt einen Link zum Betrachten (Zoomen) von Tickets in den Ticketübersichten des Agentenbereichs an.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Zeigt einen Link zum Betrachten von Anhängen über eine Onlineansicht im Artikel-Zoom im Agentenbereich an.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Zeigt einen Link zum Herunterladen von Anhängen an Artikeln in der TicketZoom-Ansicht des Agentenbereichs an.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Zeigt einen Link um das geöffnete Ticket im Rohformat anzuzeigen.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Zeigt in der TicketZoom-Ansicht im Agentenbereich einen Link an, um ein Ticket als Junk zu kennzeichnen. Zusätzliche Zugriffskontrolle auf den Link kann durch befüllen des Schlüssels "Group" und befüllen des Contents (z. B. mit "rw:group1;move_into:group2") erreicht werden. Um Elemente des Ticketmenüs zu gruppieren, kann "ClusterName" als Schlüssel und ein beliebiger Name als Wert verwendet werden, unter dem diese Gruppe im Benutzer interface angezeigt werden soll. Verwenden Sie "ClusterPriority", um die Anzeigereihenfolge der verschiedenen Gruppen innerhalb des Ticketmenüs zu steuern.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Zeigt in der "Ticket Schließen" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Zeigt in der "Ticket FreiText" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Zeigt in der "Ticket Notiz" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Ticket Besitzer" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Warten auf Erinnerung" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Ticket Priorität" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Zeigt in der "Ticket Verantwortlicher" Ansicht der Agenten-Oberfläche eine Liste aller am Ticket beteiligten Agenten.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Zeigt in der "Ticket Schließen" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Zeigt in der "Ticket FreiText" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Zeigt in der "Ticket Notiz" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Ticket Besitzer" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Warten auf Erinnerung" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Zeigt in der "Ticket Priorität" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Zeigt in der "Ticket Verantwortlicher" Ansicht der Agenten-Oberfläche eine Liste aller möglichen Agenten (alle Agenten mit Berechtigung für Notizen in diesem Ticket/ dieser Queue) die informiert werden sollen.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Zeigt eine Vorschau der Ticket-Übersicht mit einigen Ticketinformationen an (CustomerInfo => 1 - zeigt auch Kundeninformation an, CustomerInfoMaxSize steuert die maximale Anzahl angezeigter Zeichen in der Kundeninformation).',
        'Shows all both ro and rw queues in the queue view.' => 'Zeigt sowohl rw als auch ro Queues in der Queue-Ansicht.',
        'Shows all both ro and rw tickets in the service view.' => 'Zeigt sowohl rw als auch ro Queues in der Service-Ansicht.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            'Zeigt alle Artikel in der Ticket-Zoom-Ansicht (ausgeklappte Ansicht).',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            'Zeigt alle Artikel in der Ticket-Detailansicht (ausgeklappte Ansicht).',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Zeigt alle Kunden-Identifikatoren in einem Mehrfachauswahlfeld (nicht sinnvoll, wenn Sie sehr viele Identifikatoren haben).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            'Zeigt alle Kundenbenutzer-Identifikatoren in einem Mehrfachauswahlfeld (nicht sinnvoll, wenn Sie sehr viele Identifikatoren haben).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Zeigt eine Besitzerauswahl in Telefon- und E-Mail-Tickets im Agentenbereich an.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Zeigt die andere Tickets des Kunden in AgentTicketPhone, AgentTicketEmail und AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Zeigt entweder den Betreff des neusten Kundenartikels oder den Tickettitel in der Kompakt-Ansicht von Ticketübersichten.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Zeigt Queues als Liste oder Baumstruktur (mit Eltern-/Kind-Beziehung) an.',
        'Shows information on how to start OTOBO Daemon' => 'Informationen über das Starten des OTOBO Daemons anzeigen',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Zeigt einen Link zu einer externen Seite in der Ticket-Detailansicht des Kundenbereichs. Die Sichtbarkeit des Links für bestimmte Gruppen kann über den Schlüssel "Group" und Inhalt wie "rw:group1;move_into:group2" gesteuert werden.',
        'Shows the article head information in the agent zoom view.' => 'Zeigt die Kopfinformationen des Artikels in der Detailansicht.',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Legt fest, ob die Liste von Artikeln in der Ticket-Detailansicht normal oder umgekehrt sortiert sein soll.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Zeigt Informationen zum jeweiligen Kundenbenutzer (Telefon und E-Mail) im Verfassen-Bildschirm.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Zeigt die aktivierten Ticket-Attribute im Kundenbereich (0 = abgeschaltet, 1 = eingeschaltet).',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Zeigt die Nachricht des Tages (MOTD) im Agenten-Dashboard. "Group" beschränkt den Zugang zum jeweiligen Dashlet (z. B. Group: admin;group1;group2). "Default" bestimmt, ob das Dashlet standardmäßig aktiv ist oder vom Nutzer manuell aktiviert werden muss. Mit "Mandatory" kann das Dashlet so konfiguriert werden, dass Nutzer es nicht ausblenden können.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Zeigt die Nachricht des Tages (MOTD) im Anmeldebildschirm des Agentenbereichs an.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Zeigt die Änderungschronik (umgekehrte Reihenfolge) in der Agentenoberfläche an.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Schließen-Bildschirm im Agentenbereich.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im verschieben-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Stapelverarbeitungs-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Freitextfelder-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Notiz hinzufügen-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Besitzer wechseln-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Wartezeit setzen-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Priorität setzen-Bildschirm des Agentenbereichs.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Zeigt die Auswahl zur Einstellung der Ticket-Priorität im Verantwortlicher setzen-Bildschirm des Agentenbereichs.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Schließe-Ticket-Bildschirm der Agentenoberfläche.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Freitextfelder-Bildschirm des Agentenbereichs.',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Notiz-Hinzufügen-Bildschirm der Agentenoberfläche.',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Besitzer-Wechseln-Bildschirm der Agentenoberfläche.',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Wartezeit-Setzen-Bildschirm der Agentenoberfläche.',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Priorität-Setzen-Bildschirm der Agentenoberfläche.',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            'Zeigt das Feld zur Eingabe eines Ticket-Titels im Verantwortlicher-Setzen-Bildschirm der Agentenoberfläche.',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            'Zeigt die Beschreibung der Zeitfelder in Langform (Tage, Stunden, Minuten), wenn dies aktiviert ist oder aber nur die initialen Buchstaben (T, S, M), wenn dies nicht aktiviert ist.',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            'Zeigt die Beschreibung der Zeitfelder in Langform (Tage, Stunden, Minuten), wenn dies aktiviert ist oder aber nur die initialen Buchstaben (T, S, M), wenn dies nicht aktiviert ist.',
        'Signature data.' => 'Signatur-Daten.',
        'Signatures' => 'Signaturen',
        'Simple' => 'Einfach',
        'Skin' => 'Skin',
        'Slovak' => 'Slowakisch',
        'Slovenian' => 'Slowenisch',
        'Small' => 'Klein',
        'Software Package Manager.' => 'Softwarepaketverwaltung.',
        'Solution time' => 'Lösungszeit',
        'SolutionDiffInMin' => 'Lösungszeitdifferenz in Minuten',
        'SolutionInMin' => 'Lösungszeit in Minuten',
        'Some description!' => 'Eine Beschreibung!',
        'Some picture description!' => 'Eine Bildbeschreibung!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Steuert die Sortierreihenfolge von Tickets bei Auswahl einer einzelnen Queue in der Queue-Ansicht nach dem Sortieren nach Priorität. Mögliche Werte: 0 = aufsteigend (älteste Tickets zuerst), 1 = absteigend (neuste Tickets zuerst). Tragen Sie die ID der Queue als Schlüssel und 0 oder 1 als Wert ein.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Steuert die Sortierreihenfolge von Tickets bei Auswahl eines einzelnen Services in der Service-Ansicht nach dem Sortieren nach Priorität. Mögliche Werte: 0 = aufsteigend (älteste Tickets zuerst), 1 = absteigend (neuste Tickets zuerst). Tragen Sie die ID der Queue als Schlüssel und 0 oder 1 als Wert ein.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Spam Assassin Beispielsetup. Ignoriert E-Mail, die von Spam Assassin markiert wurden.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Spam Assassin Beispielsetup. Verschiebt markierte E-Mails in die Spam-Queue.',
        'Spanish' => 'Spanisch',
        'Spanish (Colombia)' => 'Spanisch (Kolumbien)',
        'Spanish (Mexico)' => 'Spanisch (Mexiko)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'Spanische Stoppworte für den Volltext-Index. Diese Worte werden aus dem Suchindex entfernt.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Legt fest, ob Agenten Benachrichtigungen erhalten sollen, wenn sie eine Aktion selbst ausgelöst haben.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            'Legt das Verzeichnis zum Speichern von Daten fest, wenn "FS" als ArticleStorage gewählt wurde.',
        'Specifies the directory where SSL certificates are stored.' => 'Legt das Verzeichnis, wo SSL-Zertifikate gespeichert sind, fest.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Legt das Verzeichnis fest, in welchem die privaten SSL Zertifikate gespeichert sind.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com). You can use the OTOBO_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Legt die E-Mail-Adresse fest, die zum Versenden von E-Mails durch die Applikation verwendet werden soll. Die Adresse wird genutzt, um den vollständigen Anzeigenamen des Benachrichtigungs-Masters zu bilden (z. B. "OTOBO Notifications otobo@your.example.com). Sie können die OTOBO_CONFIG_FQDN-Variable nutzen, die Sie in der Konfiguration festgelegt haben, oder eine andere E-Mail-Adresse wählen.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Legt die Email-Adresse für Benachrichtigungen von Scheduler Tasks fest.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Legt die Gruppe fest, für die ein Agent Schreibrechte besitzen muss, um Zugriff auf die "SwitchToCustomer"-Funktion zu haben.',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            'Legt die Gruppe fest, für die ein Agent Schreibrechte besitzen muss, um die persönlichen Einstellungen anderer Agenten verändern zu können.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com).' =>
            'Legt den Namen fest, der beim Versenden von Benachrichtigungen durch die Applikation verwendet werden soll. Der Absendername wird genutzt, um den vollständigen Anzeigenamen des Benachrichtigungs-Masters zu bilden (z. B. "OTOBO Notifications otobo@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Legt die Reihenfolge fest, in der Vorname und Nachname von Agenten angezeigt wird.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Gibt den Pfad für die Datei mit dem Logo in der Kopfzeile der Webseite an. (gif|jpg|pnp, 700 x 100 Pixel).',
        'Specifies the path of the file for the performance log.' => 'Hinterlegt den Pfad für die Datei des Leistungsprotokolls.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Gibt den Pfad zu dem Konverter an, welcher das Ansehen von Microsoft Excel Dateien in der Weboberfläche erlaubt.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Gibt den Pfad zu dem Konverter an, welcher das Ansehen von Microsoft Word Dateien in der Weboberfläche erlaubt.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Gibt den Pfad zu dem Konverter an, welcher das Ansehen von PDF Dokumenten in der Weboberfläche erlaubt.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Gibt den Pfad zu dem Konverter an, welcher das Ansehen von XML Dateien in der Weboberfläche erlaubt.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Legt den Text fest, der im Protokoll einen CGI-Skripteintrag kennzeichnen soll.',
        'Specifies user id of the postmaster data base.' => 'Definiert die Benutzer-Id der Postmaster Datenbank.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Legt fest, ob bei der Suche nach Anhängen alle Storage-Backends geprüft werden sollen. Dies wird nur bei Installationen benötigt, bei denen sich Anhänge sowohl im Dateisystem, als auch in der Datenbank befinden.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            'Legt fest, ob Anhänge von MIMEBase-Artikeln indexiert werden und durchsuchbar sein sollen.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Legt fest, wieviele Unterebenen in vom Cache erstellten Verzeichnissen verwendet werden sollen. Dies verhindert, dass innerhalb eines Verzeichnisses zu viele Dateien erstellt werden.',
        'Specify the password to authenticate for the first mirror database.' =>
            'Geben Sie das Passwort für die Authentifikation mit der ersten Spiegeldatenbank an.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Geben Sie den Benutzernamen für die Authentifikation mit der ersten Spiegeldatenbank an.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward and bounce. Make sure that "rw" is always the last registered permission, as rw automatically grants all additional permissions.' =>
            'Standardmäßig verfügbare Berechtigungen für Agenten in der Anwendung. Sind weitere Berechtigungen erforderlich, können diese hier eingeben werden. Berechtigungen müssen definiert werden, um wirksam zu sein. Einige andere empfehlenswerte Berechtigungen werden bereits standardmäßig zur Verfügung gestellt: Notiz, Schließen, Warten auf...., Kunde, Freitext, Bewegen, Erstellen, Verantwortlich, Weiterleiten und Umleiten. Es ist zu beachten, dass "rw" immer die letzte registrierte Berechtigung ist, weil diese alle zusätzlichen Berechtigungen gewährt.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Startzahl für das Zählen von Statistiken. Jede neue Statistik erhöht die hier eingestellte Zahl.',
        'Started response time escalation.' => 'Antwortzeit-Eskalation gestartet.',
        'Started solution time escalation.' => 'Lösungszeit-Eskalation gestartet.',
        'Started update time escalation.' => 'Aktualisierungszeit-Eskalation gestartet.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Startet eine Wildcard-Suche innerhalb des aktiven Objekts, nachdem der Verknüpfungs-Bildschirm geöffnet wurde.',
        'Stat#' => 'Stat#',
        'States' => 'Status',
        'Statistics overview.' => 'Statistik-Übersicht.',
        'Statistics reports.' => 'Statistik-Berichte.',
        'Status view' => 'Ansicht nach Status',
        'Stopped response time escalation.' => 'Antwortzeit-Eskalation gestoppt.',
        'Stopped solution time escalation.' => 'Lösungszeit-Eskalation gestoppt.',
        'Stopped update time escalation.' => 'Aktualisierungszeit-Eskalation gestoppt.',
        'Stores cookies after the browser has been closed.' => 'Speichert Cookies nach dem Schließen des Browsers.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Entfernt leere Zeilen in der Ticket-Vorschau in der Queue-Ansicht.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Entfernt leere Zeilen in der Ticket-Vorschau in der Service-Ansicht.',
        'Support Agent' => 'Support-Agent',
        'Suspend already escalated tickets.' => 'Aussetzen der Eskalation bereits eskalierter Tickets.',
        'Swahili' => 'Swahili',
        'Swedish' => 'Schwedisch',
        'System Address Display Name' => 'System-Adresse Anzeigename',
        'System Configuration Deployment' => 'Inbetriebnahme Systemkonfiguration',
        'System Configuration Group' => 'Systemkonfigurations-Gruppe',
        'System Configuration Setting History' => 'Einstellungshistorie der Systemkonfiguration',
        'System Maintenance' => 'Systemwartung',
        'Templates ↔ Attachments' => 'Vorlagen ↔ Anhänge',
        'Templates ↔ Queues' => 'Vorlagen ↔ Queues',
        'Textarea' => 'Textfeld',
        'Thai' => 'Thai',
        'The PGP signature is expired.' => 'Die PGP-Signatur ist abgelaufen.',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            'Die PGP-Signatur wurde mit einem zurückgezogenen Schlüssel erstellt. Das heißt, die Signatur könnte gefälscht sein.',
        'The PGP signature was made by an expired key.' => 'Die PGP-Signatur wurde mit einem abgelaufenen Schlüssel erstellt.',
        'The PGP signature with the keyid has not been verified successfully.' =>
            'Die PGP-Signatur mit der SchlüsselID wurde nicht erfolgreich verifiziert.',
        'The PGP signature with the keyid is good.' => 'Die PGP-Signatur mit der SchlüsselID ist gültig.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Der interne Name des Skins, der im Agentenbereich genutzt werden soll. Verfügbare Skins finden Sie unter Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Der interne Name des Skins, der im Kundenbereich genutzt werden soll. Verfügbare Skins finden Sie unter Frontend::Customer::Skins.',
        'The daemon registration for sync with S3.' => 'Daemon-Registrierung für die S3-Synchronisation.',
        'The daemon registration for the scheduler cron task manager.' =>
            'Der Hintergrundprozess für den zeitgesteuerten Aufgabenplaner.',
        'The daemon registration for the scheduler future task manager.' =>
            'Der Hintergrundprozess für die zeitgesteuerte Planung der zukünftigen Aufgaben.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'Der Hintergrundprozess für den zeitgesteuerten Aufgabenplaner.',
        'The daemon registration for the scheduler task worker.' => 'Der Hintergrundprozess für die zeitgesteuerte Abarbeitung von Aufgaben.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            'Die Daemon-Registrierung für das Synchronisierungs-Management der Inbetriebnahme von Systemkonfigurationen.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Das Trennzeichen zwischen dem TicketHook und der Ticketnummer z.B. \':\'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Die Zeitspanne in Minuten nach der Erzeugung eines Ereignisses, während der neue Vorwarn- und Start-Ereignisse unterdrückt werden.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'Betreffsformat. "Links" führt zu "[TicketHook#:12345] Ein Betreff", "rechts" führt zu "Ein Betreff [TicketHook#:12345]". Bei Auswahl von "keine" enthält der Betreff keine Ticketnummer. In diesem Fall sollten Sie sicherstellen, dass die Einstellung PostMaster::CheckFollowUpModule###0200-References aktiviert ist, damit Folge-E-Mails anhand von E-Mail-Headern erkannt werden.',
        'The headline shown in the customer interface.' => 'Die in der Kundenoberfläche angezeigte Überschrift.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Erkenner für Tickets, z. B. Ticket#, Anruf#, MeinTicket#.',
        'The logo and signet shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server. The signet will be scaled to 32px*32px, the logo to 196px*32px. (In the mobile setup both have a height of 24px with variable length.)' =>
            'Logo und Signet, die im Header des Kundenbereichs angezeigt werden. Die URL zur Grafik kann eine relative URL zum Skin-Image-Verzeichnis oder eine vollständige URL sein, die auf einen anderen Webserver zeigt. Das Signet wird auf 32px*32px skaliert, das Logo auf 196px*32px. (In der Mobile-Version werden beide mit einer Höhe von 24px und variabler Länge angezeigt.)',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'Das Logo, das für das Design "default" im Agenten-Interface angezeigt wird. Mehr Informationen finden Sie in der Einstellung "AgentLogo".',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Das Logo, das im Agenten-Interface angezeigt wird. Die URL zu dem Bild kann entweder eine relative URL zum Designverzeichnis mit dem Bild sein, oder eine vollständige URL zu einem anderen Webserver.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Das Logo, das in der Abmelde-Box der Agenten-Oberfläche angezeigt wird. Die URL zu dem Bild kann entweder eine relative URL zum Designverzeichnis mit dem Bild sein, oder eine vollständige URL zu einem anderen Webserver.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Maximale Anzahl aufgeklappter Artikel in der Ticket-Detailansicht.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Die maximale Anzahl von Artikeln, welche auf einer Seite im AgentTicketZoom angezeigt werden.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'Die maximale Anzahl an Mails, die auf einmal abgerufen werden, bevor eine neue Verbindung zum Server aufgebaut wird.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            'Das von Ihnen eingegebene Secret ist ungültig. Das Secret darf nur Buchstaben (A-Z, Großbuchstaben) und Zahlen (2-7) enthalten und muss genau 16 Zeichen lang sein.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Der Text am Anfang des Betreffs einer E-Mail Antwort, z.B. RE, AW oder AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Der Text am Anfang des Betreffs, wenn eine E-Mail weitergeleitet wird, z.B. FW, Fwd oder WG.',
        'The value of the From field' => 'Der Wert des Von-Feldes',
        'Theme' => 'Schema',
        'This configuration defines all possible screens to enable or disable default columns.' =>
            'Diese Konfigurationsoption definiert alle möglichen Oberflächen, auf denen Standard-Spalten aktiviert oder deaktiviert werden.',
        'This configuration defines all possible screens to enable or disable dynamic fields.' =>
            'Diese Konfiguration definiert alle möglichen Oberflächen, auf denen dynamische Felder aktiviert oder deaktiviert werden.',
        'This configuration defines if only valids or all (invalids) dynamic fields should be shown.' =>
            'Diese Konfiguration definiert, ob nur gültige oder alle (ungültige) dynamischen Felder angezeigt werden sollen.',
        'This configuration defines the number of iterations that should be performed at max for calculating the WorkingTime for a Ticket. Attention: Setting this configuration to high can lead to performance issues.' =>
            'Diese Konfiguration definiert die maximale Anzahl der Durchläufe zur Berechnung der Arbeitszeit für ein Ticket. Achtung: Wird diese Einstellung auf hoch gesetzt, können Performance-Probleme auftreten.',
        'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.' =>
            'Diese Konfiguration registriert ein OutputFilter-Modul, das die JavaScript-Funktionalität zur Entfernung der PendingTime (Warten bis) einbringt.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            'Dieses Eventmodul speichert Attribute des Kundenbenutzers als Werte von dynamischen Feldern. Bitte schauen sie sich die DynamicFieldFromCustomerUser::Mapping-Einstellung für die Konfiguration des Mappings an.',
        'This is a Description for Comment on Framework.' => 'Dies ist die Beschreibung eines Kommentars.',
        'This is a Description for DynamicField on Framework.' => 'Dies ist die Beschreibung eines dynamischen Feldes.',
        'This is the default orange - black skin for the customer interface.' =>
            'Der Standard-Skin (grau) für den Kundenbereich.',
        'This is the default orange - black skin.' => 'Dies ist die Standard orange-schwarze Farbgebung.',
        'This key is not certified with a trusted signature!' => 'Dieser Schlüssel ist nicht mit einer Signatur signiert, der vertraut wird!',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Die PreRun()-Funktion dieses Moduls wird (wenn aktiviert) bei jeder Anfrage ausgeführt. Es kann z. B. genutzt werden, um Benutzereinstellungen zu prüfen oder Neuigkeiten anzuzeigen.',
        'This module is being used to extend the password policy.' => 'Dieses Modul ergänzt die Passwort-Richtlinie.',
        'This module is part of the admin area of OTOBO.' => 'Dieses Modul ist ein teil des Admin-Bereiches von OTOBO.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Legt fest, in welchem dynamischen Feld die Aktivitäts-ID im Prozessmanagement gespeichert werden soll.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Legt fest, in welchem dynamischen Feld die Prozess-ID im Prozessmanagement gespeichert werden soll.',
        'This option defines the process tickets default lock.' => 'Diese Option setzt die Prozess-Ticket Standardsperre.',
        'This option defines the process tickets default priority.' => 'Diese Option setzt die Prozess-Ticket Standardpriorität.',
        'This option defines the process tickets default queue.' => 'Diese Option setzt die Prozess-Ticket Standard-Queue.',
        'This option defines the process tickets default state.' => 'Diese Option setzt den Standard-Status für Prozess-Tickets.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Diese Option verweigert den Zugriff auf Tickets von anderen Kundenbenutzern mit dem selben Kundenunternehmen.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Diese Einstellung erlaubt das Überschreiben der eingebauten Länderliste. Durch Nutzung dieser Einstellung können Sie z. B. eine eigene, kürzere Länderliste nutzen, wenn dies für Sie passender ist.',
        'This setting is deprecated. Set OTOBOTimeZone instead.' => 'Diese Einstellung ist veraltet. Bitte nutzen Sie stattdessen die Einstellung OTOBOTimeZone.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            'Diese Einstellung zeigt die Sortier-Attribute aller Übersichtsansichten, nicht nur in der Queue-Ansicht.',
        'Ticket Close' => 'Ticket Close',
        'Ticket Close.' => 'Ticket schließen.',
        'Ticket Compose Bounce Email.' => 'E-Mail-Erstellung für Ticket-Umleitung.',
        'Ticket Compose email Answer.' => 'E-Mail-Erstellung für Ticket-Antwort.',
        'Ticket Customer.' => 'Ticket-Kunde.',
        'Ticket Forward Email.' => 'Ticket-Weiterleitung.',
        'Ticket FreeText.' => 'Ticket Freitext-Felder.',
        'Ticket History.' => 'Ticket-History.',
        'Ticket Lock.' => 'Ticket-Sperre.',
        'Ticket Merge.' => 'Ticket-Zusammenfassung.',
        'Ticket Move.' => 'Ticket verschieben.',
        'Ticket Note.' => 'Ticket-Notiz.',
        'Ticket Notifications' => 'Ticket-Benachrichtigungen',
        'Ticket Outbound Email.' => 'Ausgehende Ticket-E-Mail.',
        'Ticket Overview "Medium" Limit' => 'Begrenzung für Ticketübersicht "Mittel"',
        'Ticket Overview "Preview" Limit' => 'Begrenzung für Ticketübersicht "Vorschau"',
        'Ticket Overview "Small" Limit' => 'Begrenzung für Ticketübersicht "Klein"',
        'Ticket Owner.' => 'Ticket-Besitzer.',
        'Ticket Pending.' => 'Ticket in Wartestatus versetzen.',
        'Ticket Print.' => 'Ticket drucken.',
        'Ticket Priority.' => 'Ticket-Priorität.',
        'Ticket Queue Overview' => 'Ticket-Übersicht nach Queues',
        'Ticket Responsible.' => 'Ticket-Verantwortlicher.',
        'Ticket Watcher' => 'Ticket-Beobachter',
        'Ticket Zoom' => 'Ticket-Zoom',
        'Ticket Zoom.' => 'Ticket-Detailansicht.',
        'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            'Ticketattribute, die in der Konfigurationsmaske für den Ticket Invoker angezeigt werden sollen (0=sichtbar/wählbar, 1=Standard/vorausgewählt).',
        'Ticket bulk module.' => 'Ticket-Stapelverarbeitung.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Ticket Event Modul welche die Eskalation-Stop-Ereignisse auslöst.',
        'Ticket limit per page for Ticket Overview "Medium".' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Mittel".',
        'Ticket limit per page for Ticket Overview "Preview".' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Vorschau".',
        'Ticket limit per page for Ticket Overview "Small".' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Klein".',
        'Ticket notifications' => 'Ticket-Benachrichtigungen',
        'Ticket overview' => 'Ticket-Übersicht',
        'Ticket plain view of an email.' => 'Nur-Text-Ansicht für Ticket-E-Mails.',
        'Ticket split dialog.' => 'Ticket teilen-Dialog.',
        'Ticket title' => 'Ticket-Titel',
        'Ticket zoom view.' => 'Ticket-Detailansicht.',
        'TicketNumber' => 'Ticketnummer',
        'Tickets in the following queues will not be stored on the Elasticsearch server. To apply this to existing tickets, the ticket migration has to be run via console, after changing this option.' =>
            'Tickets in den folgenden Queues werden nicht auf dem Elasticsearch-Server gespeichert. Um diese Einstellung für vorhandene Tickets zu übernehmen, muss nach erfolgter Änderung eine Ticketmigration über die Konsole ausgeführt werden.',
        'Tickets.' => 'Tickets.',
        'Tile registration for the CustomerDashboard. Module is required.' =>
            'Kachel-Registrierung für das CustomerDashboard. Dieses Modul wird benötigt.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Zeit in Sekunden wird der aktuellen Zeit hinzugefügt wenn ein unerledigter-zustand gesetzt wird (Standard: 86400 = 1 Tag).',
        'To accept login information, such as an EULA or license.' => 'Um Login-Informationen zu akzeptieren, wie EULAs oder Lizenzen.',
        'To download attachments.' => 'Zum Herunterladen von Anhängen.',
        'To view HTML attachments.' => 'Zum Betrachten von HTML-Anhängen.',
        'Toggles display of OTOBO FeatureAddons list in PackageManager.' =>
            'Schaltet die Anzeige der OTOBO FeatureAddon-Liste in der Paket-Verwaltung um.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Symbol in der Toolbar, um schnell zur entsprechenden Funktion zu gelangen. Die Gruppenspezifische Sichtbarkeit dieses Links kann durch Nutzung des Schlüssels "Group" und Inhalten wie "rw:group1;move_into:group2" realisiert werden.',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Transportselektion der Terminbenachrichtigungen. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Transportselektion der Terminbenachrichtigungen. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.',
        'Tree view' => 'Baumansicht',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            'Stößt das Hinzufügen oder Aktualisieren von automatischen Terminen an, basierend auf Ticketzeiten.',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Löst Ticket-Eskalationsereignisse und Benachrichtigungsereignisse für Eskalationen aus.',
        'Turkish' => 'Türkisch',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Schaltet die SSL-Zertifikatsvalidierung ab, wenn Sie beispielsweise einen HTTPS-Proxy nutzen. Benutzung auf eigene Gefahr!',
        'Turns on drag and drop for the main navigation.' => 'Aktiviert Drag und Drop für die Hauptnavigation.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Schaltet den Remote-IP-Adressencheck ein. Es sollte ausgeschaltet werden, wenn die Applikation z. B. durch eine Proxy-Farm oder eine Einwahlverbindung genutzt wird, da sich die IP-Adresse bei dieser Nutzung pro Anfrage unterscheiden kann.',
        'Tweak the system as you wish.' => 'Passen Sie das System nach Ihren Wünschen an.',
        'Type of daemon log rotation to use: Choose \'OTOBO\' to let OTOBO system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            'Art der Logrotation, die vom Daemon genutzt werden soll. Wählen Sie "OTOBO", um das System die Rotation verwalten zu lassen oder "extern", um eine Drittapplikation dafür zu nutzen (z. B. logrotate). Hinweis: externe Mechanismen erfordern weiterhin eine eigene Konfiguration.',
        'Ukrainian' => 'Ukrainisch',
        'Unlock tickets that are past their unlock timeout.' => 'Geben Sie Tickets frei, deren Freigabe-Timeout abgelaufen ist.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Geben Sie tickets frei, wenn eine Notiz hinzugefügt wurde und der Besitzer nicht im Büro ist.',
        'Unlocked ticket.' => 'Ticketsperre aufgehoben.',
        'Up' => 'Auf',
        'Upcoming Events' => 'Anstehende Ereignisse',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Aktualisieren des "Gesehen"-Merkmals, wenn jeder Artikel betrachtet oder ein neuer Artikel erstellt wurde.',
        'Update time' => 'Aktualisierungszeit',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Aktualisiert den Ticket-Eskalations-Index nachdem ein Ticket-Attribut aktualisiert wurde.',
        'Updates the ticket index accelerator.' => 'Aktualisiert den Ticket-Index-Beschleuniger.',
        'Upload your PGP key.' => 'Laden Sie Ihren PGP Schlüssel hoch.',
        'Upload your S/MIME certificate.' => 'Laden Sie Ihr S/MIME Zertifikat hoch.',
        'Use Redis::Fast instead of Redis.' => 'Verwendet Redis::Fast statt Redis.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Nutzen Sie einen neuen Typ von Auswahl- und Autovervollständigen-Feldern in der Agenten-Schnittstelle, wo sie anwendbar sind (InputFields = Eingabefelder).',
        'Use specified Redis logical database.' => 'Verwendet die angegebene logische Redis-Datenbank.',
        'User Profile' => 'Benutzerprofil',
        'UserFirstname' => 'Benutzervorname',
        'UserLastname' => 'Benutzernachname',
        'Users, Groups & Roles' => 'Benutzer, Gruppen & Rollen',
        'Uses richtext for viewing and editing ticket notification.' => 'Nutzt Rich-Text zum Betrachten und Bearbeiten von Ticket-Benachrichtigungen.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Nutzt Rich-Text zum Betrachten und Bearbeiten von: Artikeln, Begrüßungen, Signaturen, Standard Vorlagen, Automatische Antworten und Benachrichtigungen.',
        'Vietnam' => 'Vietnamesisch',
        'View performance benchmark results.' => 'Ergebnisse der Leistungsmessung ansehen.',
        'Watch this ticket' => 'Dieses Ticket beobachten',
        'Watched Tickets' => 'Beobachtete Tickets',
        'Watched Tickets.' => 'Beobachtete Tickets.',
        'We are performing scheduled maintenance.' => 'Wir führen eine geplante Wartung durch.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Wir führen eine geplante Wartung durch. Das Einloggen ist im Moment nicht möglich.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Wir führen eine geplante Wartung durch. Wir werden bald wieder online sein.',
        'We have changed the default ticket unlock behaviour in OTOBO 10.1. Now, the ticket is not only unlocked, but also handed over to the system user again. Thus, the behaviour is clearer, but it is no longer possible to read out who last edited the ticket. Please deactivate this option to restore the behaviour of OTRS version 2-6 and OTOBO 10..' =>
            'In OTOBO 10.1 haben wir die Ticketfreigabe angepasst: Das Ticket wird nicht nur entsperrt, sondern zugleich an den Systembenutzer zurückgegeben. So entspricht die Darstellung klarer den Tatsachen. Zugleich kann aus der Besitzerinformation nicht mehr ersehen werden, wer ein Ticket zuletzt bearbeitet hat. Deaktivieren Sie die Optiopn, um das Verhalten der OTRS-Versionen 2 bis 6 und von OTOBO 10 wiederherstellen.',
        'Web Service' => 'Webservice',
        'Web Services' => 'Webservices',
        'Welcome text for the dashboard header. Name will be inserted to %s of the WelcomeText. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" and "UserLogin" will be substituted.' =>
            'Willkommenstext für den Dashboard-Header. Die in "Name" definierten Variablen werden anstelle von %s in den als Willkommenstext definierten Text eingefügt. Mögliche Variablen: "UserTitle", "UserFirstname", "UserLastname", "UserEmail" und "UserLogin".',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            'Legt fest, ob ein Ticket beim Anlegen automatisch auf den anlegenden Agenten gesperrt werden soll.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Wenn Tickets zusammengefasst werden, wird automatisch zu dem Ticket, das nicht länger aktiv ist, eine Notiz hinzugefügt. Hier können Sie den Textköper dieser Notiz definieren (dieser Text kann nicht durch den Agent verändert werden).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Wenn Tickets zusammengefasst werden, wird automatisch zu dem Ticket, das nicht länger aktiv ist, eine Notiz hinzugefügt. Hier können Sie den Gegenstand dieser Notiz definieren (dieser Text kann nicht durch den Agent verändert werden).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Wenn Tickets zusammengefasst werden, kann der Kunde durch Setzen des Kontrollkästchens "Sender informieren" per E-Mail informiert werden. In diesem Bereich können Sie einen vorformatierten Text definieren, der später durch die Agents modifiziert werden kann.',
        'Whether extended customer information is shown in the ticket print screen of the customer interface.' =>
            'Definiert, ob in der Ticket-Druckansicht im Kundenbereich erweiterte Kundendaten angezeigt werden.',
        'Whether fields should be automatically filled (1), and in that case also be hidden from ticket formulars (2).' =>
            'Definiert, ob Felder automatisch befüllt (1), und ob automatisch befüllte Felder in den Ticketformularen ausgeblendet werden sollen (2).',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Legt fest, ob Meta-Informationen aus Artikeln anhand von Filtern, die in Ticket::Frontend::ZoomCollectMetaFilters festgelegt wurden, extrahiert werden sollen.',
        'Whether the execution of TicketACL can be avoided by checking cached field dependencies. This can improve loading times of ticket formulars, but has to be disabled, if ACLModules are to be used for Ticket- and Form-ReturnTypes.' =>
            'Legt fest, ob die Ausführung der TicketACL durch Prüfen gecachter Abhängigkeiten zwischen Feldern umgangen werden kann. Diese Funktion kann die Ladezeit von Ticketformularen verbessern, muss aber deaktiviert werden, wenn ACLModules für Ticket- und Form-ReturnTypes verwendet werden sollen.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            'Legt fest, ob eine Weiterleitung aller Anfragen von http zu https erzwungen werden soll. Bitte stellen Sie sicher, dass Ihr Webserver korrekt für die Verwendung von https konfiguriert wurde, bevor Sie diese Einstellung aktivieren.',
        'Yes, but hide archived tickets' => 'Ja, aber archivierte Tickets verstecken',
        'Your email with ticket number "<OTOBO_TICKET>" is bounced to "<OTOBO_BOUNCE_TO>". Contact this address for further information.' =>
            'Ihre E-Mail mit Ticket-Nummer "<OTOBO_TICKET>" wurde an "<OTOBO_BOUNCE_TO>" umgeleitet. Kontaktieren Sie diese Adresse für weitere Informationen.',
        'Your email with ticket number "<OTOBO_TICKET>" is merged to "<OTOBO_MERGE_TO_TICKET>".' =>
            'Ihre E-Mail mit Ticket-Nummer "<OTOBO_TICKET>" wurde zu Ticket-Nummer "<OTOBO_MERGE_TO_TICKET>" zusammengefasst.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Die Auswahl ihrer bevorzugten (abbonnierten) Queues. Sie werden auch per E-Mail über diese Queues benachrichtigt, wenn die Einstellung aktiv ist.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Auswahl der bevorzugten Services. Es werden E-Mail-Benachrichtigungen über diesen ausgewählten Services versendet, falls aktiviert.',
        'Zoom' => 'Inhalt',
        'attachment' => 'Anhang',
        'bounce' => 'Umleiten',
        'compose' => 'Verfassen',
        'debug' => 'Debug',
        'error' => 'Fehler',
        'forward' => 'Weiterleiten',
        'info' => 'info',
        'inline' => 'inline',
        'normal' => 'normal',
        'notice' => 'Hinweis',
        'pending' => 'Warten',
        'phone' => 'Telefonanruf',
        'responsible' => 'Verantwortlicher',
        'reverse' => 'umgekehrt',
        'stats' => 'Stats',

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
