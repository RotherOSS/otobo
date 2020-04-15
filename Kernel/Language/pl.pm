# --
# Copyright (C) 2003-2010 Tomasz Melissa <janek at rumianek.com>
# Copyright (C) 2009 Artur Skalski <skal.ar at wp.pl>
# Copyright (C) 2011-2013 Informatyka Boguslawski sp. z o.o. sp.k., http://www.ib.pl/
# Copyright (C) 2014 Wojciech Myrda <wmyrda at auticon.pl>, http://www.auticon.pl
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%A %Y-%M-%D %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';
    $Self->{Completeness}        = 0.691793893129771;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Zarządzanie ACL',
        'Actions' => 'Akcje',
        'Create New ACL' => 'Utwórz nowy ACL',
        'Deploy ACLs' => 'Wdróż ACL',
        'Export ACLs' => 'Eksportuj ACL',
        'Filter for ACLs' => 'Filtr dla ACLi',
        'Just start typing to filter...' => 'Aby filtrować, wystarczy zacząć pisać',
        'Configuration Import' => 'Import konfiguracji',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Tutaj możesz wgrać pliki konfiguracyjne ACL do systemu. Plik musi być w formacie .yml takim jaki jest eksportowany z modułu edytora ACL.',
        'This field is required.' => 'To pole jest wymagane.',
        'Overwrite existing ACLs?' => 'Nadpisać istniejący ACL?',
        'Upload ACL configuration' => 'Wgraj konfigurację ACL',
        'Import ACL configuration(s)' => 'Importuj konfigurację ACL',
        'Description' => 'Opis',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'By utworzyć nowy ACL możesz importować te uprzednio eksportowane z innego systemu lub utworzyć kompletnie nowe.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Zmiany dokonane tu dla reguł ACL będą mieć wpływ na zachowanie systemu dopiero po ich wdrożeniu. Podczas wdrażania danych ACL, zmiany zostaną zapisane w konfiguracji.',
        'ACLs' => 'ACLe',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Proszę zapamiętaj: Ta tabela reprezentuje kolejność wykonania ACLi. Jeśli potrzebujesz by kolejność była inna wówczas proszę zmień odpowiednio ich nazwy.',
        'ACL name' => 'Nazwa ACL',
        'Comment' => 'Komentarz',
        'Validity' => 'Aktualność',
        'Export' => 'Eksport',
        'Copy' => 'Kopia',
        'No data found.' => 'Nie odnaleziono żadnych elementów spełniających kryteria',
        'No matches found.' => 'Nie odnaleziono dopasowań.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Edytuj ACL %s',
        'Edit ACL' => 'Edytuj ACL',
        'Go to overview' => 'Idź do przeglądu',
        'Delete ACL' => 'Usuń ACL',
        'Delete Invalid ACL' => 'Usuń nieprawidłowy ACL',
        'Match settings' => 'Dopasuj ustawienia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Ustaw kryteria dla tego ACL. Uzyj \'Własciwości\' by dopasować obecne okno lub \'Właściwości Bazy Danych\' by dopasowac atrybuty obecnego zgłoszenia w bazie danych.',
        'Change settings' => 'Zmień ustawienia',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Ustaw co chcesz zmienić jeśli kryteria zostaną spełnione. Prosze zapamiętaj, że \'możliwe\' jest białą listą, \'Niemożliwe\' jest czarną listą',
        'Check the official %sdocumentation%s.' => 'Sprawdź oficjalną %sdokumentację%s',
        'Show or hide the content' => 'Pokaż lub ukryj treść',
        'Edit ACL Information' => 'Edytuj informację ACL',
        'Name' => 'Nazwa',
        'Stop after match' => 'Zatrzymaj po dopasowaniu',
        'Edit ACL Structure' => 'Edytuj strukturę ACL',
        'Save ACL' => 'Zapisz ACL',
        'Save' => 'Zapisz',
        'or' => 'lub',
        'Save and finish' => 'Zapisz i zakończ',
        'Cancel' => 'Anuluj',
        'Do you really want to delete this ACL?' => 'Czy na pewno chcesz usunąć ten ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Utwórz nowy ACL poprzez wypełnienie formularza danych. Po dodaniu ACL będzie możliwe dodawanie pozycji konfiguracji w trybie edycji.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Zarządzanie Kalendarzami',
        'Add Calendar' => 'Dodaj Kalendarz',
        'Edit Calendar' => 'Edytuj Kalendarz',
        'Calendar Overview' => 'Przegląd Kalendarzy',
        'Add new Calendar' => 'Dodaj nowy Kalendarz',
        'Import Appointments' => 'Zaimportuj Wydarzenia',
        'Calendar Import' => 'Import Kalendarza',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'W tym miejscu możesz załadować plik konfiguracyjny by zaimportować kalendarz to systemu. Plik musi być w formacie .yml, podobnie jak wyeksportowany moduł zarządzania kalendarzem.',
        'Overwrite existing entities' => 'Nadpisać istniejące encje',
        'Upload calendar configuration' => 'Wczytaj konfigurację kalendarza',
        'Import Calendar' => 'Zaimportuj Kalendarz',
        'Filter for Calendars' => 'Filtr dla Kalendarzy',
        'Filter for calendars' => 'Filtr dla kalendarzy',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'W zależności od pola grupy, system udostępni użytkownikom dostęp do kalendarza zgodnie z ich uprawnieniami.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Tylko do odczytu: użytkownicy mogą widzieć i eksportować wszystkie wydarzenia w kalendarzu.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Przenieś na: użytkownicy mogą modyfikować wydarzenia w kalendarzu, jednak bez możliwości zmiany wybranego kalendarza.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Utwórz: użytkownicy mogą tworzyć i usuwać wydarzenia w kalendarzu.',
        'Read/write: users can manage the calendar itself.' => 'Odczyt/Zapis: użytkownicy mogą zarządzać kalendarzem.',
        'Group' => 'Grupa',
        'Changed' => 'Zmienione',
        'Created' => 'Utworzone',
        'Download' => 'Pobierz',
        'URL' => 'URL',
        'Export calendar' => 'Wyeksportuj kalendarz',
        'Download calendar' => 'Ściągnij kalendarz',
        'Copy public calendar URL' => 'Skopiuj URL publicznego kalendarza',
        'Calendar' => 'Kalendarz',
        'Calendar name' => 'Nazwa kalendarza',
        'Calendar with same name already exists.' => 'Kalendarz z tą nazwą już istnieje.',
        'Color' => 'Kolor',
        'Permission group' => 'Grupa uprawnień',
        'Ticket Appointments' => 'Wydarzenia Zgłoszeń',
        'Rule' => 'Reguła',
        'Remove this entry' => 'Usuń tę pozycję',
        'Remove' => 'Usuń',
        'Start date' => 'Data początku',
        'End date' => 'Data zakończenia',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Użyj opcji poniżej by zawęzić dla jakich zgłoszeń będą tworzone automatyczne wydarzenai.',
        'Queues' => 'Kolejki',
        'Please select a valid queue.' => 'Proszę wybrać ważną kolejkę.',
        'Search attributes' => 'Atrybuty wyszukiwania',
        'Add entry' => 'Dodaj pozycję',
        'Add' => 'Dodaj',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definiuje reguły dla automatycznego tworzenia wydarzeń w tym kalendarzu, w zależności od danych zgłoszenia.',
        'Add Rule' => 'Dodaj regułę',
        'Submit' => 'Akceptuj',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Import Wydarzeń',
        'Go back' => 'Wstecz',
        'Uploaded file must be in valid iCal format (.ics).' => 'Wczytany plik musi posiadać prawidłowy format iCAL (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Jeśli szukany Kalendarz nie jest tutaj wyświetlony, proszę upewnić się, że posiadasz przy najmniej uprawnienie \'Utwórz\'.',
        'Upload' => 'Wyślij',
        'Update existing appointments?' => 'Zaktualizować istniejące wydarzenia?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Wszystkie istniejące wydarzenia w kalendarzu z tym samym UniqueID zostaną nadpisane.',
        'Upload calendar' => 'Wczytaj kalendarz.',
        'Import appointments' => 'Import wydarzeń',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Zarządzanie Powiadomieniami Wydarzeń',
        'Add Notification' => 'Dodaj powiadomienie',
        'Edit Notification' => 'Edytuj Powiadomienie',
        'Export Notifications' => 'Eksportuj powiadomienia',
        'Filter for Notifications' => 'Filtr powiadomień',
        'Filter for notifications' => 'Filtr powiadomień',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Tu możesz przesłać plik konfiguracji by zaimportować powiadomienia o spotkaniach do systemu. Plik powinien być w formacie .yml, takim jak wyeksportowany z modułu powiadomień o spotkaniach.',
        'Overwrite existing notifications?' => 'Nadpisać istniejące powiadomienia?',
        'Upload Notification configuration' => 'Prześlij konfigurację powiadomień',
        'Import Notification configuration' => 'Importuj konfigurację powiadomień',
        'List' => 'Lista',
        'Delete' => 'Usuń',
        'Delete this notification' => 'Usuń to powiadomienie',
        'Show in agent preferences' => 'Pokaż w preferencjach agenta',
        'Agent preferences tooltip' => 'Podpowiedź (etykieta) w preferencjach agenta',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ten komunikat agent zobaczy na ekranie ustawień jako podpowiedź opisująca te powiadomienie.',
        'Toggle this widget' => 'Przełącz ten widget',
        'Events' => 'Zdarzenia',
        'Event' => 'Zdarzenie',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Tu można wybrać, które zdarzenia będą wyzwalać to powiadomienie. Zdefiniowany poniżej dodatkowy filtr wydarzeń może ograniczyć powiadomienia do wydarzeń spełniających określone kryteria.',
        'Appointment Filter' => 'Filtr wydarzeń',
        'Type' => 'Typ',
        'Title' => 'Tytuł',
        'Location' => 'Miejsce',
        'Team' => 'Zespół',
        'Resource' => 'Zasoby',
        'Recipients' => 'Odbiorcy',
        'Send to' => 'Wyślij do',
        'Send to these agents' => 'Wyślij do tych agentów',
        'Send to all group members (agents only)' => ' Wyślij do wszystkich członków grupy (tylko agenci)',
        'Send to all role members' => 'Wyślij do wszystkich członków roli',
        'Send on out of office' => 'Wyślij powiadomienie o nieobecności w biurze',
        'Also send if the user is currently out of office.' => 'Również wyślij jeśli użytkownik jest aktualnie poza biurem',
        'Once per day' => 'Jeden na dzień',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Powiadamiaj użytkownika o pojedynczym wydarzeniu, przy użyciu wybranego transportu, tylko raz dziennie.',
        'Notification Methods' => 'Metoda powiadomienia',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'To są metody, które mogą zostać użyte do wysłania tego powiadomienia do każdego z odbiorców. Wybierz przynajmniej jedną metodę poniżej.',
        'Enable this notification method' => 'Włącz tą metodę powiadomienia',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Wymagana jest przynajmniej jedna metoda na powiadomienie.',
        'Active by default in agent preferences' => 'Domyślnie aktywne w ustawieniach agenta',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Wartość domyślna ustawienia odbioru tego powiadomienia dla agenta, który nie określił jeszcze tej wartości w swoich preferencjach. Jeśli pole jest zaznaczone, powiadomienie będzie do takich agentów wysyłane.',
        'This feature is currently not available.' => 'Ta funkcja jest obecnie niedostępna.',
        'Upgrade to %s' => 'Zaktualizuj do %s',
        'Please activate this transport in order to use it.' => 'Aktywuj ten sposób transportu aby go użyć.',
        'No data found' => 'Nie znaleziono danych',
        'No notification method found.' => 'Nie znaleziono metody powiadomienia',
        'Notification Text' => 'Treść powiadomienia',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Ten język nie jest obecny lub włączony w systemie. Powiadomienie może zostać skasowane, jeśli nie jest już potrzebne.',
        'Remove Notification Language' => 'Usuń język powiadomienia',
        'Subject' => 'Temat',
        'Text' => 'Treść',
        'Message body' => 'Treść wiadomości',
        'Add new notification language' => 'Dodaj nowy język powiadomienia',
        'Save Changes' => 'Zapisz zmiany',
        'Tag Reference' => 'Opis tag\'u',
        'Notifications are sent to an agent.' => 'Powiadomienia są wysyłane do agenta.',
        'You can use the following tags' => 'Możesz używać następujących znaczników',
        'To get the first 20 character of the appointment title.' => 'By pobrać pierwsze 20 znaków tytułu wydarzenia.',
        'To get the appointment attribute' => 'By pobrać atrybut wydarzenia',
        ' e. g.' => 'np.',
        'To get the calendar attribute' => 'By pobrać atrybut kalendarza',
        'Attributes of the recipient user for the notification' => 'Atrybuty danych odbiorcy powiadomienia',
        'Config options' => 'Opcje konfiguracyjne',
        'Example notification' => 'Przykładowe powiadomienie',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Dodatkowe adresy email odbiorców',
        'This field must have less then 200 characters.' => 'To pole musi zawierać mniej niż 200 znaków.',
        'Article visible for customer' => 'Artykuł widoczny dla klienta',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Artykuł zostanie utworzony jeżeli zostanie wysłane powiadomienie do klienta lub na adres dodatkowy.',
        'Email template' => 'Formatka email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Użyj tego szablonu, aby wygenerować kompletną wiadomość email (dotyczy tylko emaili HTML).',
        'Enable email security' => 'Włącz zabezpieczenia email',
        'Email security level' => 'Poziom zabezpieczeń Email',
        'If signing key/certificate is missing' => 'Jeśli brakuje podpisanego klucza / certyfikatu',
        'If encryption key/certificate is missing' => 'Jeśli brakuje klucza szyfrującego / certyfikatu',

        # Template: AdminAttachment
        'Attachment Management' => 'Zarządzanie załącznikami',
        'Add Attachment' => 'Dodaj załącznik',
        'Edit Attachment' => 'Edytuj załącznik',
        'Filter for Attachments' => 'Filtr załączników',
        'Filter for attachments' => 'Filtr dla załączników',
        'Filename' => 'Nazwa pliku',
        'Download file' => 'Pobierz plik',
        'Delete this attachment' => 'Usuń ten załącznik',
        'Do you really want to delete this attachment?' => 'Czy na pewno usunąć załącznik?',
        'Attachment' => 'Załącznik',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Zarządzanie automatycznymi odpowiedziami',
        'Add Auto Response' => 'Dodaj automatyczną odpowiedź',
        'Edit Auto Response' => 'Edytuj automatyczną odpowiedź',
        'Filter for Auto Responses' => 'Filtrowanie automatycznych odpowiedzi',
        'Filter for auto responses' => 'Filtr dla automatycznych odpowiedzi',
        'Response' => 'Odpowiedź',
        'Auto response from' => 'Automatyczna odpowiedź od',
        'Reference' => 'Podpowiedzi',
        'To get the first 20 character of the subject.' => 'Pokaż pierwsze 20 znaków tematu.',
        'To get the first 5 lines of the email.' => 'Pokaż 5 linii wiadomości e-mail.',
        'To get the name of the ticket\'s customer user (if given).' => 'Pokaż nazwę klienta ze zgłoszenia (jeśli jest podana).',
        'To get the article attribute' => 'Pokaż właściwości wiadomości',
        'Options of the current customer user data' => 'Opcje danych obecnego użytkownika',
        'Ticket owner options' => 'Opcje właściciela zgłoszenia',
        'Ticket responsible options' => 'Opcje odpowiedzialego za zgłoszenie',
        'Options of the current user who requested this action' => 'Opcje bieżącego użytkownika, który żądał akcji',
        'Options of the ticket data' => 'Opcje danych zgłoszenia',
        'Options of ticket dynamic fields internal key values' => 'Opcje wewnętrznych wartości kluczy pól dynamicznych zgłoszeń',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcje wartości wyświetlanych pól dynamicznych zgłoszeń, przydatne dla pól Dropdown i Multiselect',
        'Example response' => 'Przykładowa odpowiedź',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Zarządzanie usługami w chmurze',
        'Support Data Collector' => 'Kolekcjoner Danych Wsparcia',
        'Support data collector' => 'Kolekcjoner danych wsparcia',
        'Hint' => 'Podpowiedź',
        'Currently support data is only shown in this system.' => 'Obecnie dane wsparca są wyświetlane jedynie w tym systemie.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Konfiguracja',
        'Send support data' => 'Wysyłaj dane wsparcia',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Zaktualizuj',
        'System Registration' => 'Rejestracja systemu',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Zarejestruj ten system',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Rejestracja Systemu jest wyłączona. Sprawdź konfigurację.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Zauważ że używanie usług OTOBO w chmurze wymaga by Twój system był zarejestrowany',
        'Register this system' => 'Zarejestruj system',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Tu możesz skonfigurować dostępne usługi, które mogą komunikować się bezpiecznie z %s',
        'Available Cloud Services' => 'Dostępne usługi w chmurze',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Log komunikacji',
        'Time Range' => 'Zakres czasu',
        'Show only communication logs created in specific time range.' =>
            'Pokaż log komunikacyjny utworzony tylko w określonym zakresie czasu.',
        'Filter for Communications' => 'Filtr kanałów komunikacji',
        'Filter for communications' => 'Filtr kanałów komunikacji',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Na tym ekranie możesz zobaczyć podsumowanie komunikacji przychodzącej i wychodzącej.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Możesz zmienić kolejność i sortowanie kolumn klikając na nagłówek tabeli.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Jeśli klikniesz w niektóre kolumny elementu, zostaniesz przekierowany do ekranu szczegółów.',
        'Status for: %s' => 'Status dla: 1 %s',
        'Failing accounts' => 'Nieprawidłowe konta',
        'Some account problems' => 'Występują problemy kont',
        'No account problems' => 'Nie ma problemów z kontami',
        'No account activity' => 'Nie ma aktywności konta',
        'Number of accounts with problems: %s' => 'Ilość kont z problemami: %s',
        'Number of accounts with warnings: %s' => 'Ilość kont z ostrzeżeniami: %s',
        'Failing communications' => 'Niepowodzenia komunikacji',
        'No communication problems' => 'Brak problemów komunikacyjnych',
        'No communication logs' => 'Brak logów komunikacyjnych',
        'Number of reported problems: %s' => 'Liczba zaraportowanych problemów: %s',
        'Open communications' => 'Otwarta komunikacja',
        'No active communications' => 'Brak aktywnej komunikacji',
        'Number of open communications: %s' => 'Liczba otwartych komunikacji: %s',
        'Average processing time' => 'Średni czas przetwarzania',
        'List of communications (%s)' => 'Lista komunikacji (%s)',
        'Settings' => 'Ustawienia',
        'Entries per page' => 'Pozycji na stronie',
        'No communications found.' => 'Nie znaleziono komunikacji.',
        '%s s' => '%s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Status konta',
        'Back to overview' => 'Powrót do przeglądu',
        'Filter for Accounts' => 'Filtr dla Kont',
        'Filter for accounts' => 'Filtr dla kont',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Możesz zmienić kolejność i sortowanie kolumn klikając na nagłówek tabeli.',
        'Account status for: %s' => 'Stan konta dla: 1 %s',
        'Status' => 'Stan',
        'Account' => 'Konto',
        'Edit' => 'Edytuj',
        'No accounts found.' => 'Brak znalezionych kont.',
        'Communication Log Details (%s)' => 'Szczegóły logu komunikacyjnego (%s)',
        'Direction' => 'Kierunek',
        'Start Time' => 'Czas rozpoczęcia',
        'End Time' => 'Czas zakończenia',
        'No communication log entries found.' => 'Nie znaleziono pozycji logu komunikacyjnego.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Czas trwania',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Priorytet',
        'Module' => 'Moduł',
        'Information' => 'Informacje',
        'No log entries found.' => 'Nie znaleziono pozycji logu.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Podgląd szczegółów dla %s komunikacja rozpoczęta o %s',
        'Filter for Log Entries' => 'Filtruj pozycje logu',
        'Filter for log entries' => 'Filtruj pozycje logu',
        'Show only entries with specific priority and higher:' => 'Pokaż tylko te pozycje logu od określonego priorytetu wzwyż:',
        'Communication Log Overview (%s)' => 'Przegląd Logu Komunikacyjnego (%s)',
        'No communication objects found.' => 'Nie znaleziono obiektów komunikacyjnych.',
        'Communication Log Details' => 'Szczegóły Logu Komunikacyjnego',
        'Please select an entry from the list.' => 'Wybierz pozycję z listy.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Połącz z danymi',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Wstecz do wyników wyszukiwania',
        'Select' => 'Zaznacz',
        'Search' => 'Szukaj',
        'Wildcards like \'*\' are allowed.' => 'Wieloznaczniki (wildcards) takie jak \'*\' są dozwolone.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Aktualne',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Zarządzanie klientami',
        'Add Customer' => 'Dodaj Klienta',
        'Edit Customer' => 'Edytuj Klienta',
        'List (only %s shown - more available)' => 'Lista (pokazano tylko %s - jest więcej dostępnych',
        'total' => 'wszystkich',
        'Please enter a search term to look for customers.' => 'Prosimy wprowadź frazę wyszukiwania by odszukać klientów.',
        'Customer ID' => 'Identyfikator Klienta',
        'Please note' => 'Zwróć uwagę',
        'This customer backend is read only!' => 'Ten backend klienta jest tylko do odczytu!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Zarządzaj relacjami Klient-Grupa',
        'Notice' => 'Uwaga',
        'This feature is disabled!' => 'Ta funkcja jest wyłączona!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Użyj tej funkcji jeśli chcesz określić grupę uprawnień dla klientów.',
        'Enable it here!' => 'Włącz tutaj!',
        'Edit Customer Default Groups' => 'Edytuj Domyślne Grupy Klientów',
        'These groups are automatically assigned to all customers.' => 'Te grupy są automatycznie przypisywane wszystkim klientom.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Możesz zarządzać tymi grupami poprzez ustawienia konfiguracji
"CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filtr dla grup.',
        'Select the customer:group permissions.' => 'Wybierz uprawnienia klient:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jeśli nic nie zostało zaznaczone, wtedy nie ma uprawnień w tej grupie (zgłoszenia nie będą dostępne dla klienta).',
        'Search Results' => 'Wyniki wyszukiwania',
        'Customers' => 'Klienci',
        'Groups' => 'Grupy',
        'Change Group Relations for Customer' => 'Zmień relacje grupy dla klienta',
        'Change Customer Relations for Group' => 'Zmień relacje klienta do grup',
        'Toggle %s Permission for all' => 'Przełącz uprawnienie %s dla wszystkich',
        'Toggle %s permission for %s' => 'Przełącz uprawnienie %s dla %s',
        'Customer Default Groups:' => 'Domyślne grupy klientów',
        'No changes can be made to these groups.' => 'Nie można wprowadzić zmian do tych grup.',
        'ro' => 'odczyt',
        'Read only access to the ticket in this group/queue.' => 'Prawo jedynie do odczytu zgłoszeń w tej grupie/kolejce',
        'rw' => 'odczyt/zapis',
        'Full read and write access to the tickets in this group/queue.' =>
            'Prawa pełnego odczytu i zapisu zgłoszeń w tej grupie/kolejce',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Zarządzanie użytkownikami klientów',
        'Add Customer User' => 'Dodaj użytkownika klienta',
        'Edit Customer User' => 'Edytuj użytkownika klienta',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Aby posiadać historię klienta i umożliwić mu logowanie się do panelu klienta konieczne jest założenie konta użytkownika klienta.',
        'List (%s total)' => 'Lista (%s wszystkich)',
        'Username' => 'Nazwa użytkownika',
        'Email' => 'E-Mail',
        'Last Login' => 'Ostatnie logowanie',
        'Login as' => 'Nazwa użytkownika',
        'Switch to customer' => 'Zmień klienta',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Ten backend klienta jest tylko do odczytu, ale preferencje użytkownika klienta mogą być zmieniane!',
        'This field is required and needs to be a valid email address.' =>
            'To pole jest wymagane i musi być poprawnym adresem e-mail.',
        'This email address is not allowed due to the system configuration.' =>
            'Ten adres e-mail nie jest dozwolony z uwagi na konfigurację systemu.',
        'This email address failed MX check.' => 'Walidacja MX tego adresu e-mail nie powiodła się.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problem z DNS, sprawdź konfigurację i log błędów.',
        'The syntax of this email address is incorrect.' => 'Składnia tego adresu e-mail jest niepoprawna.',
        'This CustomerID is invalid.' => 'CustomerID jest nieprawidłowy.',
        'Effective Permissions for Customer User' => 'Efektywne uprawnienia dla Użytkownika Klienta',
        'Group Permissions' => 'Uprawnienia Grupy',
        'This customer user has no group permissions.' => 'Ten użytkownik klienta, nie jest członkiem żadnej z grup zabezpieczeń,',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Powyższa tabela pokazuje efektywne uprawnienia do grup użytkownika klienta. Macierz pobiera wszystkie dziedziczone uprawnienia dla konta (np. poprzez grupy użytkownika). Uwaga: Tabela nie zawiera zmian dokonanych na tej formatce i jeszcze nie zapisanych.',
        'Customer Access' => 'Dostęp Klienta',
        'Customer' => 'Nazwa klienta',
        'This customer user has no customer access.' => 'Ten użytkownik klienta nie ma dostępu jako klient.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Tabela powyżej pokazuje przyznany dostęp klienta dla użytkownika klienta przez kontekst uprawnień. Macierz uwzględnia cały dziedziczny dostęp (na przykład poprzez grupy klientów). Uwaga: tabela nie uwzględnia zmian wprowadzonych w tym formularzu bez jego przesyłania.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Zarządzaj relacjami Użytkownik klienta - Klient',
        'Select the customer user:customer relations.' => 'Wybierz relacje użytkownik klienta:klient',
        'Customer Users' => 'Użytkownicy klienta',
        'Change Customer Relations for Customer User' => 'Zmień relacje Klienta dla Użytkownika klienta',
        'Change Customer User Relations for Customer' => 'Zmień relacje Użytkownika klienta do Klienta',
        'Toggle active state for all' => 'Przełącz stan aktywności dla wszystkich',
        'Active' => 'Aktywne',
        'Toggle active state for %s' => 'Przełącz stan aktywności dla %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Zarządzaj relacjami Użytkownik klienta - Grupa',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Użyj tej funkcjonalności jeśli chcesz określić uprawnienia grup dla użytkowników klienta.',
        'Edit Customer User Default Groups' => 'Zmień Domyślną Grupę Użytkownika Klienta',
        'These groups are automatically assigned to all customer users.' =>
            'Te grupy zostaną automatycznie przypisane do wszystkich użytkowników klienta.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Możesz zarządzać tymi grupami poprzez parametr "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtr dla grup.',
        'Select the customer user - group permissions.' => 'Określ uprawnienia użytkownik klienta - grupa.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Jeśli nic nie zostało zaznaczone, wtedy nie ma uprawnień w tej grupie (zgłoszenia nie będą dostępne dla klienta).',
        'Customer User Default Groups:' => 'Domyślna Grupa Użytkownika klienta',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Zarządzaj relacjami Użytkownik klienta - Usługi',
        'Edit default services' => 'Edytuj domyślną usługę',
        'Filter for Services' => 'Filtruj usługi',
        'Filter for services' => 'Filtr usług',
        'Services' => 'Usługi',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Zarządzanie polami dynamicznymi',
        'Add new field for object' => 'Dodaj nowej pole do obiektu',
        'Filter for Dynamic Fields' => 'Filtr dla Pól Dynamicznych',
        'Filter for dynamic fields' => 'Filtr dla pól dynamicznych',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Baza danych',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Użyj zewnętrznych baz danych jako konfigurowalnych źródeł danych dla tego dynamicznego pola.',
        'Web service' => 'Serwis sieciowy',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Dla tego pola dynamicznego można skonfigurować jako źródło danych zewnętrzny serwis sieciowy.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Ta funkcja umożliwia dodawanie (wielu) kontaktów z danymi do biletów.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Aby dodać nowe pole, wybierz typ pola z listy obiektów. Wybrany obiekt definiuje typ pola, który nie będzie mógł być zmieniony po utworzeniu tego pola.',
        'Dynamic Fields List' => 'Lista pól dynamicznych',
        'Dynamic fields per page' => 'Pola dynamiczne na stronę',
        'Label' => 'Etykieta',
        'Order' => 'Zamówienie',
        'Object' => 'Obiekt',
        'Delete this field' => 'Usuń to pole',

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
        'Dynamic Fields' => 'Pola dynamiczne',
        'Go back to overview' => 'Powrót do przeglądu',
        'General' => 'Ogólne',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'To pole jest wymaganel a wartość powinna być alfanumeryczna.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Musi być unikalne i zawierać wyłącznie znaki alfanumeryczne.',
        'Changing this value will require manual changes in the system.' =>
            'Zmiana tej wartości wymagać będzie ręcznych zmian w systemie.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ta nazwa będzie wyświetlana na ekranach, na których pole to będzie aktywne.',
        'Field order' => 'Kolejność pola',
        'This field is required and must be numeric.' => 'To pole jest wymagane i musi być numeryczne.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'To jest kolejność zgodnie z którą pole to będzie wyświetlane na ekranach, na których pole to będzie aktywne.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Nie można unieważnić tego wpisu, wszystkie ustawienia konfiguracji muszą zostać wcześniej zmienione.',
        'Field type' => 'Typ pola',
        'Object type' => 'Typ obiektu',
        'Internal field' => 'Pole wewnętrzne',
        'This field is protected and can\'t be deleted.' => 'To pole jest chronione i nie może być usunięte.',
        'This dynamic field is used in the following config settings:' =>
            'To dynamiczne pole jest używane w następujących ustawieniach konfiguracji:Pole dynamiczne',
        'Field Settings' => 'Ustawienia pola',
        'Default value' => 'Domyślna wartość',
        'This is the default value for this field.' => 'To jest domyślna wartość tego pola.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Klucz',
        'Value' => 'Wartość',
        'Remove value' => 'Usuń wartość',
        'Add Field' => '',
        'Add value' => 'Dodaj wartość',
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
        'Translatable values' => 'Wartości przetłumaczalne',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Jeśli uaktywnisz tę opcję, wartości zostaną przetłumaczone na język użytkownika.',
        'Note' => 'Notatka',
        'You need to add the translations manually into the language translation files.' =>
            'Musisz dodać tłumaczenia ręcznie do plików z tłumaczeniami.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Dopuszczalne wartości',
        'Datatype' => '',
        'Filter' => 'Filtr',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Pokaż odnośnik',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Tutaj możesz ustalić opcjonalny odnośnik HTTP dla wartości pola, który będzie wyświetlany na ekranach przeglądów i szczegółów.',
        'Example' => 'Przykład',
        'Link for preview' => 'Link do podglądu',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Jeżeli jest wpisany, ten link (URL) będzie używany do podglądu, który będzie widoczny w szczegółach zgłoszenia, gdy najedziesz kursorem na ten link. Zauważ, że żeby ten podgląd działał, pełny adres (URL) w polu powyżej również musi być wpisany.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Port',
        'Table / View' => '',
        'User' => 'Użytkownik',
        'Password' => 'Hasło',
        'Identifier' => 'Identyfikator',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Multiwybór',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Domyślne przesunięcie daty',
        'This field must be numeric.' => 'To pole musi być numeryczne.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Przesunięcie w sekundach względem czasu bieżącego do obliczenia domyślnej wartości pola (mp. 3600 lub -60).',
        'Define years period' => 'Zdefiniuj zakres lat',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Uaktywnij tę opcję aby zdefiniować ograniczony przedział lat (w przyszłość i przeszłość) wyświetlanych w części "rok" tego pola.',
        'Years in the past' => 'Lata wstecz',
        'Years in the past to display (default: 5 years).' => 'Liczba wyświetlanych lat wstecz (domyślnie: 5 lat).',
        'Years in the future' => 'Lata naprzód',
        'Years in the future to display (default: 5 years).' => 'Liczba wyświetlanych lat naprzód (domyślnie: 5 lat).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Jeżeli znaki specjalne (&, @, :, /, etc.) nie mogą zostać zakodowane, użyj filtra \'url\' zamiast \'uri\'.',
        'Restrict entering of dates' => 'Ogranicz zakres wprowadzanych dat',
        'Here you can restrict the entering of dates of tickets.' => 'Tutaj możesz ograniczyć zakres wprowadzanych dat w zgłoszeniach. ',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Dodaj Wartość',
        'Add empty value' => 'Dodaj pustą wartość',
        'Activate this option to create an empty selectable value.' => 'Uaktywnij tę opcję by utworzyć pustą, wybieralną wartość.',
        'Tree View' => 'Widok drzewa',
        'Activate this option to display values as a tree.' => 'Aktywuj tę opcję by otrzymać wartości w formie drzewa.',

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
        'Fields' => 'Pola',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Przegląd',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Porządkowanie elementów na liście jest możliwe również za pomocą chwytania i upuszczania.',
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
        'Reset' => 'Resetuj',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Liczba wierszy',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Określ wysokość (w liniach) dla tego pola w trybie edycji.',
        'Number of cols' => 'Liczba kolumn',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Określ szerokość (w znakach) dla tego pola w trybie edycji.',
        'Check RegEx' => 'Sprawdź wyrażenie regularne',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Tutaj możesz określić wyrażenie regularne sprawdzające tą wartość. To sprawdzenie będzie wykonywane razem z modyfikatorami xms.',
        'RegEx' => 'Wyrażenie regularne',
        'Invalid RegEx' => 'Nieprawidłowe wyrażenie regularne',
        'Error Message' => 'Komunikat błędu',
        'Add RegEx' => 'Dodaj wyrażenie regularne',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Szablon',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Rozmiar',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'To pole jest wymagane',
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
        'Admin Message' => 'Wiadomość Administratora',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Przy pomocy tego modułu administratorzy mogą wysyłać wiadomości do agentów, członków grup lub ról.',
        'Create Administrative Message' => 'Utwórz wiadomość od administratora',
        'Your message was sent to' => 'Twoja wiadomość została wysłana do',
        'From' => 'Od',
        'Send message to users' => 'Wyślij wiadomość do użytkowników',
        'Send message to group members' => 'Wyślij wiadomość do członków grupy',
        'Group members need to have permission' => 'Członkowie grupy muszą posiadać uprawnienia',
        'Send message to role members' => 'Wyślij wiadomość do posiadaczy roli',
        'Also send to customers in groups' => 'Wyślij także, do klientów w grupach',
        'Body' => 'Treść',
        'Send' => 'Wyślij',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Zarządzanie zadaniami automatycznymi',
        'Edit Job' => 'Edytuj Zadanie',
        'Add Job' => 'Dodaj Zadanie',
        'Run Job' => 'Wykonaj Zadanie',
        'Filter for Jobs' => 'Filtr Zadań',
        'Filter for jobs' => 'Filtr zadań',
        'Last run' => 'Ostatnie uruchomienie',
        'Run Now!' => 'Uruchom teraz',
        'Delete this task' => 'Usuń to zadanie',
        'Run this task' => 'Uruchom to zadanie',
        'Job Settings' => 'Ustawienia zadania',
        'Job name' => 'Nazwa zadania',
        'The name you entered already exists.' => 'Podana nazwa już istnieje.',
        'Automatic Execution (Multiple Tickets)' => 'Automatyczne wykonywanie (Wiele Ticketów)',
        'Execution Schedule' => 'Harmonogram wykonania',
        'Schedule minutes' => 'Ustal minuty',
        'Schedule hours' => 'Ustal godziny',
        'Schedule days' => 'Ustal dni',
        'Automatic execution values are in the system timezone.' => 'Wartości automatycznego wykonania są określone dla strefy czasowej systemu.',
        'Currently this generic agent job will not run automatically.' =>
            'Zadanie nie zostanie uruchomione automatycznie.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Aby uruchomić automatyczne wykonywanie zaznacz przynajmniej jedną wartość dla minut, godzin i dni!',
        'Event Based Execution (Single Ticket)' => 'Wykonywanie bazowane na zdarzeniach (pojedyńcze zgłoszenie)',
        'Event Triggers' => 'Triggery',
        'List of all configured events' => 'Lista wszystkich skonfigurowanych zdarzeń',
        'Delete this event' => 'Usuń to zdarzenie',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Dodatkowo lub alternatywnie dla wykonywania okresowego możesz zdefiniować zdarzenia które spowodują wykonannie tego zadania.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Jeśli zgłoszenie zostanie wykonane wówczas filtr zgłoszeń zostanie wykonany dla sprawdzenia dopasowania zgłoszenia. Tylko wówczas zadanie jest wykonane na danym zgłoszeniu.',
        'Do you really want to delete this event trigger?' => 'Czy na pewno chcesz usunąć ten trigger?',
        'Add Event Trigger' => 'Dodaj trigger',
        'To add a new event select the event object and event name' => 'Aby dodać nowe wydarzenie, wybierz obiekt zdarzenia i nazwę wydarzenia',
        'Select Tickets' => 'Zaznacz zgłoszenia',
        '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
        '(e. g. 234321)' => '(np. 3242442)',
        'Customer user ID' => 'ID Użytkownika Klienta',
        '(e. g. U5150)' => '(np. U4543)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Szukanie pełnotekstowe we wiadomości (np. "J*n" lub "Kowalsk*")',
        'To' => 'Do',
        'Cc' => 'DW',
        'Service' => 'Usługa',
        'Service Level Agreement' => ' Umowa o gwarantowanym poziomie świadczenia usług - Service Level Agreement (SLA)',
        'Queue' => 'Kolejka',
        'State' => 'Stan',
        'Agent' => 'Agent',
        'Owner' => 'Właściciel',
        'Responsible' => 'Odpowiedzialny',
        'Ticket lock' => 'Blokada zgłoszenia',
        'Dynamic fields' => 'Pola dynamiczne',
        'Add dynamic field' => '',
        'Create times' => 'Czasy utworzenia',
        'No create time settings.' => 'Bez czasów utworzenia.',
        'Ticket created' => 'Zgłoszenie utworzone',
        'Ticket created between' => 'Zgłoszenie utworzone między',
        'and' => 'i',
        'Last changed times' => 'Data ostatnich modyfikacji',
        'No last changed time settings.' => 'Nie ustawiono czasu ostatniej zmiany.',
        'Ticket last changed' => 'Ostatnia modyfikacja zgłoszenia',
        'Ticket last changed between' => 'Ostatnia modyfikacja zgłoszenia między',
        'Change times' => 'Czasy zmiany',
        'No change time settings.' => 'Brak zmiany ustawień czasu',
        'Ticket changed' => 'Zgłoszenie zmieniono',
        'Ticket changed between' => 'Zgłoszenie zmieniono pomiędzy',
        'Close times' => 'Czasy zamknięcia',
        'No close time settings.' => 'Bez czasów zamkniecia.',
        'Ticket closed' => 'Zgłoszenie zamknięte',
        'Ticket closed between' => 'Zgłoszenie zamknięte między',
        'Pending times' => 'Czasy oczekiwania',
        'No pending time settings.' => 'Bez czasów oczekiwania.',
        'Ticket pending time reached' => 'Oczekiwanie zakończone',
        'Ticket pending time reached between' => 'Oczekiwanie zakończone między',
        'Escalation times' => 'Czasy eskalacji',
        'No escalation time settings.' => 'Brak ustawionego czasu eskalacji.',
        'Ticket escalation time reached' => 'Osiągnięty czas eskalacji zgłoszenia',
        'Ticket escalation time reached between' => 'Czas eskalacji zgłoszenia będzie osiągnięty za',
        'Escalation - first response time' => 'Eskalacja - czas pierwszej odpowiedzi',
        'Ticket first response time reached' => 'Osiągnięty czas pierwszej odpowiedzi na zgłoszenie',
        'Ticket first response time reached between' => 'Czas pierwszej odpowiedzi na zgłoszenie będzie osiągnięty za',
        'Escalation - update time' => 'Eskalacja - czas aktualizacji',
        'Ticket update time reached' => 'Osiągnięty czas aktualizacji zgłoszenia',
        'Ticket update time reached between' => 'Czas aktualizacji zgłoszenia będzie osiągnięty za',
        'Escalation - solution time' => 'Eskalacja - czas rozwiązania',
        'Ticket solution time reached' => 'Osiągnięty czas rozwiązania zgłoszenia',
        'Ticket solution time reached between' => 'Czas rozwiązania zgłoszenia będzie osiągnięty za',
        'Archive search option' => 'Aktywna opcja szukania',
        'Update/Add Ticket Attributes' => 'Zmień/dodaj parametry zgłoszenia',
        'Set new service' => 'Ustaw nową usługę',
        'Set new Service Level Agreement' => 'Ustaw nowe SLA',
        'Set new priority' => 'Ustaw nowy priorytet',
        'Set new queue' => 'Ustaw nową kolejkę',
        'Set new state' => 'Ustaw nowy stan',
        'Pending date' => 'Data oczekiwania',
        'Set new agent' => 'Ustaw nowego agenta',
        'new owner' => 'nowy właściciel',
        'new responsible' => 'nowy odpowiedzialny',
        'Set new ticket lock' => 'Ustaw nową blokadę zgłoszenia',
        'New customer user ID' => 'Nowe ID Użytkownika Klienta',
        'New customer ID' => 'Nowy klient',
        'New title' => 'Nowy tytuł',
        'New type' => 'Nowy typ',
        'Archive selected tickets' => 'Zarchiwizuj zaznaczone zgłoszenia',
        'Add Note' => 'Dodaj notatkę',
        'Visible for customer' => 'Widoczny dla klienta',
        'Time units' => 'Zaraportowany czas obsługi',
        'Execute Ticket Commands' => 'Wykonaj polecenia zgłoszeń',
        'Send agent/customer notifications on changes' => 'Wyślij powidomienia agentowi/klientowi przy zmianie ',
        'CMD' => 'linia poleceń',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Komenda zostanie wykonana. ARG[0] to numer zgłoszenia. ARG[1] to id zgłoszenia.',
        'Delete tickets' => 'Usuń zgłoszenia',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Uwaga: wszystkie wybrane zgłoszenia będą usunięte z bazy danych i nie będzie można ich przywrócić!',
        'Execute Custom Module' => 'Uruchom własny moduł',
        'Param %s key' => 'Klucz parametru %s',
        'Param %s value' => 'Wartość parametru %s',
        'Results' => 'Wyniki',
        '%s Tickets affected! What do you want to do?' => 'Liczba wybranych zgłoszeń %s. Co chcesz zrobić?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Uwaga: Użyta została opcja USUWANIA. Wszystkie usunięte zgłoszenia będą utracone!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Ostrzeżenie: Istnieje %s zgłoszeń, których dotyczy zadanie ale tylko %s może być zmodyfikowanych przy jednym wykonaniu zadania.',
        'Affected Tickets' => 'Wybrane zgłoszenia',
        'Age' => 'Wiek',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Zarządzanie serwisami sieciowymi GenericInterface',
        'Web Service Management' => 'Zarządzanie Web Service',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Powróć do usług sieciowych',
        'Clear' => 'Wyczyść',
        'Do you really want to clear the debug log of this web service?' =>
            'Czy na pewno chcesz wyczyścić log debug tego serwisu sieciowego?',
        'Request List' => 'Lista żądań',
        'Time' => 'Czas',
        'Communication ID' => 'Identyfikator komunikacji',
        'Remote IP' => 'Zdalny IP',
        'Loading' => 'Ładowanie',
        'Select a single request to see its details.' => 'Zaznacz pojedyncze żądanie aby zobaczyć jego szczegóły.',
        'Filter by type' => 'Filtruj po typie',
        'Filter from' => 'Filtruj od',
        'Filter to' => 'Filtruj do',
        'Filter by remote IP' => 'Filtruj po zdalnym IP',
        'Limit' => 'Limit',
        'Refresh' => 'Odswież',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Dodaj obsługę błędu',
        'Edit ErrorHandling' => 'Edytuj obsługę błędu',
        'Do you really want to delete this error handling module?' => 'Czy na pewno chcesz usunąć ten moduł obsługi błędów?',
        'All configuration data will be lost.' => 'Cała konfiguracja zostanie utracona.',
        'General options' => 'Opcje ogólne',
        'The name can be used to distinguish different error handling configurations.' =>
            'Nazwa może być używana do rozróżniania różnych konfiguracji obsługi błędów.',
        'Please provide a unique name for this web service.' => 'Podaj unikalną nazwę dla tego serwisu sieciowego.',
        'Error handling module backend' => 'Moduł obsługi błędów',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Ten moduł zaplecza obsługi błędów OTOBO będzie wywoływany wewnętrznie w celu przetworzenia mechanizmu obsługi błędów.',
        'Processing options' => 'Opcje przetwarzania',
        'Configure filters to control error handling module execution.' =>
            'Skonfiguruj filtry, aby kontrolować wykonywanie modułu obsługi błędów.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Tylko żądania pasujące do wszystkich skonfigurowanych filtrów (jeśli są) będą pozwalać na wykonanie modułu.',
        'Operation filter' => 'Filtr operacji',
        'Only execute error handling module for selected operations.' => 'Wykonuj tylko moduł obsługi błędów dla wybranych operacji.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Uwaga: Operacja nieokreślona dla błędów występujących podczas odbierania przychodzących danych żądania. Filtry z tym stopniem błędu nie powinny używać filtra operacji.',
        'Invoker filter' => 'FIltr odwołujący',
        'Only execute error handling module for selected invokers.' => 'Wykonuj tylko moduł obsługi błędów dla wybranych odwołań.',
        'Error message content filter' => 'Filtr treści komunikatu o błędzie',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Wprowadź wyrażenie regularne, aby ograniczyć, które komunikaty o błędach powinny spowodować wykonanie modułu obsługi błędów.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Obiekt z komunikatem o błędzie i dane (widoczne w opisie błędu debuggera) zostaną uwzględnione w dopasowaniu.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Przykład: Wprowadź  \'^.*401 Unauthorized.*\$\', aby obsłużyć tylko błędy związane z uwierzytelnianiem.',
        'Error stage filter' => 'Filtr fazy błędu',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Moduł obsługi błędów należy uruchamiać wyłącznie w przypadku błędów, które występują podczas określonych etapów przetwarzania.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Przykład: błędy związane z obsługą tylko wtedy, gdy nie można zastosować mapowania dla danych wychodzących.',
        'Error code' => 'Kod błędu',
        'An error identifier for this error handling module.' => 'Identyfikator błędu dla tego modułu obsługi błędów.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ten identyfikator będzie dostępny w XSLT-Mapping i pokazany na wyjściu debuggera.',
        'Error message' => 'Komunikat błędu',
        'An error explanation for this error handling module.' => 'Objaśnienie błędu dla tego modułu obsługi błędów.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ta wiadomość będzie dostępna w XSLT-Mapping i pokazana na wyjściu debuggera.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Zdefiniuj, czy przetwarzanie powinno zostać zatrzymane po wykonaniu modułu, pomijając wszystkie pozostałe moduły lub tylko te z tego samego zaplecza.',
        'Default behavior is to resume, processing the next module.' => 'Domyślnym zachowaniem jest wznowienie, przetwarzanie następnego modułu.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Ten moduł umożliwia skonfigurowanie zaplanowanych ponownych prób dla nieudanych żądań.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Domyślnym zachowaniem usług WWW ogólnego interfejsu jest wysyłanie każdego żądania dokładnie jeden raz i nieprzekazywanie po błędach.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Jeśli dla pojedynczego żądania wykonywany jest więcej niż jeden moduł zdolny do planowania ponownej próby, ostatni wykonany moduł jest autorytatywny i określa, czy ponowna próba jest zaplanowana.',
        'Request retry options' => 'Poproś o opcje ponowienia',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Opcje ponowienia są stosowane, gdy żądania powodują wykonanie modułu obsługi błędów (w oparciu o opcje przetwarzania).',
        'Schedule retry' => 'Zaplanuj powtórzenie',
        'Should requests causing an error be triggered again at a later time?' =>
            'Czy żądania powodujące błąd będą uruchamiane ponownie w późniejszym czasie?',
        'Initial retry interval' => 'Początkowy interwał ponawiania próby',
        'Interval after which to trigger the first retry.' => 'Czas po którym ma zostać uruchomiona pierwsza powtórka próby.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Uwaga: Ten i wszystkie kolejne interwały ponowienia są oparte na czasie wykonania modułu obsługi błędów dla początkowego żądania.',
        'Factor for further retries' => 'Współczynnik dla dalszych prób',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Jeżeli żądanie zwróci błąd również po pierwszej powtórce próby, określ czy kolejne próby mają być uruchamiane w takich samych interwałach lub coraz większych.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym odstępem czasu o wartości: 1 minuta i współczynnikiem powtórzenia: 2, ponowne próby będą uruchamiane o 10:01 (1 minuta), 10:03 (2 * 1 = 2 minuty), 10:07 (2 * 2 = 4 minuty), 10:15 (2 * 4 = 8 minut), ...',
        'Maximum retry interval' => 'Maksymalny interwał ponawiania prób',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Jeżeli wybrano współczynnik interwału powtórzenia: 1,5 lub 2, można zapobiec niepożądanym długim interwałom, definiując maksymalny dopuszczalny przedział czasu.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Odstępy obliczone w celu przekroczenia maksymalnego interwału ponawiania będą wówczas automatycznie odpowiednio skracane.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym interwałem: 1 minuta, współczynnik ponowienia: 2 i maksymalny czas: 5 minut, ponowne próby będą uruchamiane o 10:01 (1 minuta), 10:03 (2 minuty), 10:07 (4 minuty), 10:12 (8 => 5 minut), 10:17, ...',
        'Maximum retry count' => 'Maksymalna liczba powtórzeń',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Maksymalna liczba ponownych prób przed odrzuceniem żądania jest odrzucana, nie licząc początkowego żądania.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym interwałem: 1 minuta, współczynnik ponów: 2 i maksymalna liczba ponownych prób: 2, ponowne próby będą uruchamiane tylko o 10:01 i 10:02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Uwaga: Maksymalna liczba powtórzeń może nie zostać osiągnięta, jeśli maksymalny czas ponowienia jest również skonfigurowany i osiągnięty wcześniej.',
        'This field must be empty or contain a positive number.' => 'To pole musi być puste lub zawierać liczbę dodatnią.',
        'Maximum retry period' => 'Maksymalny okres powtarzania',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Maksymalny czas ponowienia próśb o niepowodzenie przed ich odrzuceniem (w oparciu o czas wykonania modułu obsługi błędów dla pierwotnego żądania).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Próby, które normalnie byłyby uruchamiane po upływie maksymalnego okresu (zgodnie z obliczeniem przedziału czasu ponownej próby), będą automatycznie uruchamiane dokładnie w maksymalnym okresie.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Przykład: jeśli żądanie jest początkowo wyzwalane o godzinie 10:00 z początkowym interwałem:  minuta, współczynnikiem powtórzenia: 2 i maksymalnym czasem ponowienia próby po: 30 minutach. Ponowne próby będą uruchamiane o 10:01, 10:03, 10:07, 10:15 i wreszcie o 10:31 => 10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Uwaga: Maksymalny czas ponowienia może nie zostać osiągnięty, jeśli maksymalna liczba ponownych prób jest również skonfigurowana i osiągnięta wcześniej.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Dodaj wywołanie',
        'Edit Invoker' => 'Edytuj wywołanie',
        'Do you really want to delete this invoker?' => 'Czy na pewno chcesz usunąć ten invoker?',
        'Invoker Details' => 'Szczegóły invokera.',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Nazwa jest zwykle używana do wywołania operacji zdalnego serwisu sieciowego.',
        'Invoker backend' => 'Zaplecze invokera',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Ten moduł zaplecza invokera OTOBO będzie wywołany by przygotować dane do wysyłki do systemu zdalnego oraz by przetworzyć odpowiedź z tego systemu.',
        'Mapping for outgoing request data' => 'Mapowanie wysyłanych danych żądania',
        'Configure' => 'Konfiguruj',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dane z invokera OTOBO będą przetworzone przez to mapowanie na dane oczekiwane przez system zdalny.',
        'Mapping for incoming response data' => 'Mapowanie otrzymanych danych z odpowiedzi',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Dane z odpowiedzi będą przetworzone przez to mapowanie na dane oczekiwane przez invoker OTOBO.',
        'Asynchronous' => 'Asynchroniczny',
        'Condition' => 'Warunek',
        'Edit this event' => 'Edytuj to zdarzenie',
        'This invoker will be triggered by the configured events.' => 'Ten invoker będzie wykonany przez skonfigurowane zdarzenia.',
        'Add Event' => 'Dodaj wydarzenie',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Aby dodać nowe zdarzenie, zaznacz obiekt zdarzenia i nazwę zdarzenia i kliknij przycisk "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Wyzwalacze (triggery) zdarzeń asynchronicznych obsługiwane przez harmonogram OTOBO pracujący w tle (zalecane)',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Triggery synchroniczne będą przetwarzane bezpośrednio w trakcie przetwarzania żądania web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Powrót do',
        'Delete all conditions' => 'Usuń wszystkie warunki',
        'Do you really want to delete all the conditions for this event?' =>
            'Czy na pewno chcesz usunąć wszystkie warunki dla tego wydarzenia?',
        'General Settings' => 'Główne ustawienia',
        'Event type' => 'Typ wydarzenia',
        'Conditions' => 'Warunki',
        'Conditions can only operate on non-empty fields.' => 'Wyrażenia warunkowe mogą operować tylko na polach niepustych.',
        'Type of Linking between Conditions' => 'Typ połączenia pomiędzy warunkami',
        'Remove this Condition' => 'Usuń ten warunek',
        'Type of Linking' => 'Typ połączenia',
        'Add a new Field' => 'Dodaj nowe pole',
        'Remove this Field' => 'Usuń to pole',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => 'Dodaj nowy warunek',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Proste mapowanie',
        'Default rule for unmapped keys' => 'Domyślna reguła dla niezmapowanych kluczy',
        'This rule will apply for all keys with no mapping rule.' => 'Ta reguła będzie obowiązywać dla wszystkich kluczy bez reguły mapowania.',
        'Default rule for unmapped values' => 'Domyślna reguła dla niezamapowanych wartości',
        'This rule will apply for all values with no mapping rule.' => 'Ta reguła będzie obowiązywać dla wszystkich wartości bez reguły mapowania.',
        'New key map' => 'Nowe mapowanie klucza',
        'Add key mapping' => 'Dodaj mapowanie klucza',
        'Mapping for Key ' => 'Mapowanie klucza',
        'Remove key mapping' => 'Usuń mapowanie',
        'Key mapping' => 'Mapowanie klucza',
        'Map key' => 'Mapuj klucz',
        'matching the' => 'dopasowywanie',
        'to new key' => 'do nowego klucza',
        'Value mapping' => 'Mapowanie wartości',
        'Map value' => 'Mapuj wartość',
        'to new value' => 'na nową wartość',
        'Remove value mapping' => 'Usuń mapowanie wartości',
        'New value map' => 'Nowe mapowanie wartości',
        'Add value mapping' => 'Dodaj mapowanie wartości',
        'Do you really want to delete this key mapping?' => 'Czy na pewno chcesz usunąć to mapowanie klucza?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => 'Skróty MacOS',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => 'Zwiń/Rozwiń blok kodu',
        'Find' => 'Znajdź',
        'Find next' => 'Znajdź następny',
        'Find previous' => 'Znajdź poprzedni',
        'Find and replace' => 'Znajdź i zamień',
        'Find and replace all' => 'Znajdź i zamień wszystko',
        'XSLT Mapping' => 'Mapowanie XSLT',
        'XSLT stylesheet' => 'Arkusz stylu XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'Wprowadzone dane nie są prawidłowym arkuszem stylu XSLT.',
        'Here you can add or modify your XSLT mapping code.' => 'Tutaj możesz dodać lub zmodyfikować kod mapujący XSLT.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => 'Regularne wyrażenia',
        'Replace' => 'Zamień',
        'Remove regex' => 'Usuń regex',
        'Add regex' => 'Dodaj regex',
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
        'Perl regular expressions tutorial' => 'Przewodnik wyrażeń regularnych Perla',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Dodaj operację',
        'Edit Operation' => 'Zmień operację',
        'Do you really want to delete this operation?' => 'Czy na pewno chcesz usunąć tę operację?',
        'Operation Details' => 'Szczegóły operacji',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Nazwa jest zwykle używana do wywoływania tej operacji serwisu sieciowego ze zdalnego systemu.',
        'Operation backend' => 'Zaplecze operacji',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ten moduł zaplecza operacji OTOBO będzie wywoływany wewnętrznie aby przetworzyć żądanie i wygenerować dane odpowiedzi.',
        'Mapping for incoming request data' => 'Mapowanie otrzymanych danych żądania',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Dane żądania będą przetwarzane przez to mapowanie aby przekształcić je do postaci oczekiwanej przez OTOBO.',
        'Mapping for outgoing response data' => 'Mapowanie danych wysyłanej odpowiedzi',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dane odpowiedzi będą przetwarzane przez to mapowanie aby przetworzyć je do postaci oczekiwanej przez system zdalny.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Właściwości',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Określ trasę, która powinna zostać odwzorowana dla tej operacji. Zmienne określone przez \':\' zostaną odwzorowane we wprowadzonej nazwie i przekazane dalej razem z innymi do odwzorowań (np. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Poprawne metody wywołania dla tej operacji',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ogranicz tą operację do określonych metod wywołania. Jeżeli żadna metoda nie zostanie wybrana, wszystkie dostępne metody będą akceptowane',
        'Maximum message length' => 'Maksymalna długość wiadomości',
        'This field should be an integer number.' => 'To pole powinno być liczbą całkowitą.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Tu możesz określić maksymalny rozmiar komunikatów REST, które OTOBO będzie przetwarzał (w bajtach).',
        'Send Keep-Alive' => 'Wysyłaj "Keep-Alive" (podtrzymuj)',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Ta konfiguracja określa czy przychodzące połączenia powinny być zamknięte lub utrzymane. ',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Punkt końcowy',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Czas wygaśnięcia',
        'Timeout value for requests.' => '',
        'Authentication' => 'Autentykacja',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'BasicAuth Użytkownik',
        'The user name to be used to access the remote system.' => 'Nazwa użytkownika do logowania do zdalnego systemu.',
        'BasicAuth Password' => 'BasicAuth Hasło',
        'The password for the privileged user.' => 'Hasło użytkownika do logowania do zdalnego systemu.',
        'Use Proxy Options' => 'Użyj ustawień proxy',
        'Show or hide Proxy options to connect to the remote system.' => 'Pokaż lub ukryj ustawienia Proxy aby połączyć się z systemem zdalnym',
        'Proxy Server' => 'Serwer proxy',
        'URI of a proxy server to be used (if needed).' => 'URI serwera proxy jeśli ma być używany (jeśli wymagane).',
        'e.g. http://proxy_hostname:8080' => 'np. http://proxy_hostname:8080',
        'Proxy User' => 'Użytkownik proxy',
        'The user name to be used to access the proxy server.' => 'Nazwa użytkownika, która ma być używana do logowania do serwera proxy.',
        'Proxy Password' => 'Hasło do proxy',
        'The password for the proxy user.' => 'Hasło użytkownika proxy.',
        'Skip Proxy' => 'Pomiń Proxy',
        'Skip proxy servers that might be configured globally?' => 'Pomiń serwery proxy może być skonfigurowane globalnie?',
        'Use SSL Options' => 'Użyj opcji SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Pokaż lub ukryj opcje SSL połączenia do zdalnego systemu.',
        'Client Certificate' => 'Certyfikat Klienta',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Pełna ścieżka i nazwa pliku certyfikatu SSL klienta (powinno być: PEM, DER lub PKCS#12 format)',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'np. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Klucz Certyfikatu Klienta',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Pełna ścieżka i nazwa pliku certyfikatu SSL klienta (jeśli nie jest włączone w plik certyfikatu)',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'np. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Hasło Klucza Certyfikatu Klienta',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Hasło do otwarcia certyfikatu SSL jeśli jest zaszyfrowany.',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Pełna ścieżka i nazwa pliku z certyfikatem CA, który potwierdza certyfikat SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'np. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Katalog Certification Authority (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Pełna ścieżka do katalogu gdzie znajdują się certyfikaty CA.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'np. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => 'Polecenie domyślne',
        'The default HTTP command to use for the requests.' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'np. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Ustaw SOAPAction',
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
        'SOAPAction separator' => 'Separator SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI nadające kontekst metodom SOAP w celu uniknięcia niejednoznaczności.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'np. urn:otobo-com:soap:functions lub http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Tutaj możesz określić maksymalny rozmiar (w bajtach) wiadomości SOAP, które OTOBO będzie przetwarzać.',
        'Encoding' => 'Kodowanie',
        'The character encoding for the SOAP message contents.' => 'Kodowanie znaków dla zawartości wiadomości SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'np. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => 'Opcje sortowania',
        'Add new first level element' => 'Dodaj element pierwszego poziomu',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Dodaj Web Service',
        'Edit Web Service' => 'Zmień Web Service',
        'Clone Web Service' => 'Zamknij Web Service',
        'The name must be unique.' => 'Nazwa musi być unikalna',
        'Clone' => 'Klonuj',
        'Export Web Service' => 'Eksportuj Web Service',
        'Import web service' => 'Importuj serwis sieciowy',
        'Configuration File' => 'Plik konfiguracyjny.',
        'The file must be a valid web service configuration YAML file.' =>
            'Plik musi być poprawnym plikiem konfiguracyjnym YAML web service.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importuj',
        'Configuration History' => 'Konfiguracja Historii',
        'Delete web service' => 'Usuń serwis sieciowy',
        'Do you really want to delete this web service?' => 'Czy na pewno chcesz usunąć serwis siecioy?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Po zapisaniu konfiguracji będziesz przekierowany ponownie do ekranu edycji.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Jeśli chcesz wrócić do przeglądu, kliknij przycisk "Idź do przeglądu".',
        'Remote system' => 'Zdalny system',
        'Provider transport' => 'Transport serwera',
        'Requester transport' => 'Transport klienta',
        'Debug threshold' => 'Poziom debugowania',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'W trybie serwera OTOBO udostępnia usługi sieciowe, które są używane przez zdalne systemy.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'W trybie klienta OTOBO używa usług systemów zdalnych.',
        'Network transport' => 'Transport sieciowy',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => 'Zaplecze',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Operacje to indywidualne funkcje systemowe, które mogą być wywołane przez zdalne systemy.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokery przygotowują dane żądania do zdalnej usługi sieciowej i przetwarzają dane jej odpowiedzi.',
        'Controller' => 'kontroler',
        'Inbound mapping' => 'Mapowanie przychodzące',
        'Outbound mapping' => 'Mapowanie wychodzące',
        'Delete this action' => 'Usuń tę akcję',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Przynajmniej jeden %s ma kontroler, który jest albo nieaktywny albo nieobecny; sprawdź zarejestrowanie kontrolera lub usuń %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historia',
        'Go back to Web Service' => 'Powróć do serwisów sieciowych',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Tutaj możesz zobaczyć starsze wersje bieżącej konfiguracji web service, wyeksportować je lub przywrócić.',
        'Configuration History List' => 'Lista historii konfiguracji',
        'Version' => 'Wersja',
        'Create time' => 'Czas utworzenia',
        'Select a single configuration version to see its details.' => 'Zaznacz pojedynczą wersję konfiguracji aby zobaczy jej szczegóły.',
        'Export web service configuration' => 'Eksportuj konfigurację serwisów sieciowych',
        'Restore web service configuration' => 'Przywróć konfigurację serwisów sieciowych',
        'Do you really want to restore this version of the web service configuration?' =>
            'Czy na pewno chcesz przywrócić tę wersję konfiguracji serwisu sieciowego?',
        'Your current web service configuration will be overwritten.' => 'Twoja obecna konfiguracja serwisu sieciowego zostanie nadpisana.',

        # Template: AdminGroup
        'Group Management' => 'Zarządzanie grupami',
        'Add Group' => 'Dodaj grupę',
        'Edit Group' => 'Edytuj Grupę',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Grupa Admin posiada prawa do Administracji systemem. Grupa Stats umożliwia przeglądanie statystyk zgłoszeń.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Utwórz nowe grupy aby obsłużyć prawa dostępu dla różnych grup agentów (np. działu zakupu, działu wsparcia, działu sprzedaży, ...). ',
        'It\'s useful for ASP solutions. ' => 'Przydatne dla rozwiązań ASP. ',

        # Template: AdminLog
        'System Log' => 'Log systemu',
        'Here you will find log information about your system.' => 'Tutaj znajdziesz informacje o swoim systemie OTRS',
        'Hide this message' => 'Ukryj tę wiadomość',
        'Recent Log Entries' => 'Ostatnie pozycje loga',
        'Facility' => 'Obiekt',
        'Message' => 'Informacja',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Zarządzanie kontami e-mail',
        'Add Mail Account' => 'Dodaj Konto Pocztowe',
        'Edit Mail Account for host' => 'Zmień konto mailowe dla hosta',
        'and user account' => 'i konto użytkownika',
        'Filter for Mail Accounts' => 'Filtruj po Konta E-Mail',
        'Filter for mail accounts' => 'Filtruj po konta e-mail',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Wszystkie przychodzące na jedno konto wiadomości będą umieszczone w zaznacznej kolejce.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Wychodzące emaile będą skonfigurowane przez ustawienia Sendmail* w %s.',
        'System Configuration' => 'Konfiguracja Systemu',
        'Host' => 'Adres',
        'Delete account' => 'Usuń konto',
        'Fetch mail' => 'Pobierz pocztę',
        'Do you really want to delete this mail account?' => 'Czy naprawdę chcesz usunąć to konto e-mail?',
        'Example: mail.example.com' => 'Na przykład: mail.example.com',
        'IMAP Folder' => 'Folder IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Zmień to jeśli potrzebujesz pobirać pocztę z innego foldera niż INBOX.',
        'Trusted' => 'Zaufane',
        'Dispatching' => 'Przekazanie',
        'Edit Mail Account' => 'Edytuj Konto Pocztowe',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Podgląd administracyjny',
        'Filter for Items' => 'Filtr pozycji',
        'Favorites' => 'Ulubione',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => 'Linki',
        'View the admin manual on Github' => 'Zobacz Instrukcję administratora na Github',
        'No Matches' => 'Brak Dopasowań',
        'Sorry, your search didn\'t match any items.' => 'Niestety twoje kryteria wyszukiwania nie pasują do żadnych elementów.',
        'Set as favorite' => 'Ustaw jako ulubiony',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Zarządzanie powiadomieniami ',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Tu możesz wybrać które zdarzenia będą wywoływać te powiadomienie. Poniżej może zostać zastosowany dodatkowy filtr zgłoszeń by wysyłać powiadomienie tylko dla zgłoszeń spełniających określone kryteria.',
        'Ticket Filter' => 'Filtr zgłoszeń',
        'Lock' => 'Blokada',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID Użytkownika Klienta',
        'Article Filter' => 'Filtr wiadomości',
        'Only for ArticleCreate and ArticleSend event' => 'Tylko w przypadku UtworzeniaWiadomości lub WysłaniaWiadomości',
        'Article sender type' => 'Typ nadawcy wiadomości',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Jeśli UtworzenieWiadomości lub WysłanieWiadomości inicjuje jakieś zdarzenie, konieczne jest również określenie filtra wiadomości. Należy wybrać co najmniej jedno pole pole filtrowania wiadomości.',
        'Customer visibility' => 'Widoczność Klienta',
        'Communication channel' => 'Kanał komunikacji',
        'Include attachments to notification' => 'Umieść załączniki w powiadomieniu',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Powiadamiaj użytkownika raz na dzień o pojedynczym tickecie używając wybranego sposobu',
        'This field is required and must have less than 4000 characters.' =>
            'To pole jest wymagane i musi być krótsze niż 4000 znaków.',
        'Notifications are sent to an agent or a customer.' => 'Powiadomienia są wysyłane do agenta obsługi lub klienta',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Aby uzyskać pierwsze 20 znaków tematu (najnowszej wiadomości agenta).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Aby uzyskać pierwsze 5 linii treści (najnowszej wiadomości agenta).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Aby uzyskać pierwsze 20 znaków tematu (najnowszej wiadomości klienta).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Aby uzyskać pierwsze 5 linii treści (najnowszej wiadomości klienta).',
        'Attributes of the current customer user data' => 'Atrybuty danych obecnego użytkownika klienta',
        'Attributes of the current ticket owner user data' => 'Atrybuty danych użytkownika aktualnego właściciela zgłoszenia',
        'Attributes of the current ticket responsible user data' => 'Atrybuty danych użytkownika aktualnego odpowiedzialnego za zgłoszenie',
        'Attributes of the current agent user who requested this action' =>
            'Opcje bieżącego agenta, który żądał akcji',
        'Attributes of the ticket data' => 'Atrybuty danych zgłoszenia',
        'Ticket dynamic fields internal key values' => 'Wartości wewnętrznych kluczy pól dynamicznych',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Wyświetlane wartości pól dynamicznych zgłoszeń, przydatne dla pól list rozwijanych i wielokrotnego wyboru.',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Aby wstawić wartości z bieżącego zgłoszenia, możesz użyć tagów OTOBO takich jak <OTOBO_TICKET_DynamicField_...>',

        # Template: AdminPGP
        'PGP Management' => 'Zarządzanie PGP',
        'Add PGP Key' => 'Dodaj klucz PGP',
        'PGP support is disabled' => 'Wsparcie dla PGP jest wyłączone',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Aby móc używać PGP w OTOBO musisz najpierw włączyć dla niego wsparcie.',
        'Enable PGP support' => 'Aktywuj wsparcie dla PGP',
        'Faulty PGP configuration' => 'Błędna konfiguracja PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Wsparcie dla PGP jest włączone, ale odpowiadająca mu konfiguracja zawiera błędy. Sprawdź proszę konfigurację używając przycisku poniżej.',
        'Configure it here!' => 'Skonfiguruj to tutaj!',
        'Check PGP configuration' => 'Sprawdź konfigurację PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'W ten sposób mozesz bezpośrednio edytować plik kluczy skonfigurowany w SysConfig.',
        'Introduction to PGP' => 'Wprowadenie do PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Znacznik (fingerprint)',
        'Expires' => 'Wygasa',
        'Delete this key' => 'Usuń ten klucz',
        'PGP key' => 'Klucz PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Menedżer pakietów',
        'Uninstall Package' => 'Odinstaluj pakiet',
        'Uninstall package' => 'Odinstaluj pakiet',
        'Do you really want to uninstall this package?' => 'Czy na pewno chcesz odinstalować ten pakiet?',
        'Reinstall package' => 'Reinstaluj pakiet',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Czy na pewno chcesz reinstalować ten pakiet? Wszystkie ręczne modyfikacje będą utracone.',
        'Go to updating instructions' => '',
        'Go to the OTOBO customer portal' => 'Przejdź do portalu klienta OTOBO',
        'package information' => 'informacja o pakiecie',
        'Package installation requires a patch level update of OTOBO.' =>
            'Instalacja pakietu wymaga zastosowania odpowiedniego poziomu aktualizacji OTOBO',
        'Package update requires a patch level update of OTOBO.' => 'Aktualizacja pakietu wymaga zastosowania odpowiedniego poziomu aktualizacji OTOBO',
        'Please note that your installed OTOBO version is %s.' => 'Zauważ, że twoja zainstalowana wersja OTOBO to %s',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'Aby zainstalować ten pakiet musisz zaktualizować OTOBO do wersji%s lub nowszej.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Ten pakiet może być zainstalowany w OTOBO jedynie w wersji %s lub starszej.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Ten pakiet może być zainstalowany w OTOBO jedynie w wersji %s lub nowszej.',
        'Why should I keep OTOBO up to date?' => 'Dlaczego powinienem aktualizować OTOBO?',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Będziesz otrzymywał informacje o innych istotnych problemach w OTOBO.',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'W przyapdku gdy posiadasz dodatkowe pytania będziemy zadowoleni by móc na nie odpowiedzieć.',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Instaluj pakiet',
        'Update Package' => 'Aktualizuj pakiet',
        'Continue' => 'Kontynuuj',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Proszę upewnij się, że baza danych akceptuje rozmiar powyżej %s (ona obecnie akceptuje pakiety tylko do %s MB). Proszę zmień ustawienie max_allowed_packet by uniknąć błędów w bazie danych.',
        'Install' => 'Instaluj',
        'Update repository information' => 'Zaktualizuj informację o repozytoriach',
        'Cloud services are currently disabled.' => 'Usługi w chmurze są wyłączone.',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => 'Uruchom usługi w churze',
        'Update all installed packages' => 'Zaktualizuj wszystkie zainstalowane pakiety',
        'Online Repository' => 'Baza on-line',
        'Vendor' => 'Producent',
        'Action' => 'Akcja',
        'Module documentation' => 'Dokumentacja modułu',
        'Local Repository' => 'Lokalna baza',
        'This package is verified by OTOBOverify (tm)' => 'Ten pakiet został zweryfikowany poprzez OTOBOverify (tm)',
        'Uninstall' => 'Odinstaluj',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakiet wdrożony nieprawidłowo! Zainstaluj pakiet ponownie.',
        'Reinstall' => 'Przeinstaluj',
        'Features for %s customers only' => 'Funkcje tylko dla %s klientów',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => 'Informacja o pakietach',
        'Download package' => 'Pobierz pakiet',
        'Rebuild package' => 'Przebuduj pakiet',
        'Metadata' => 'Metadane',
        'Change Log' => 'Log zmian',
        'Date' => 'Data',
        'List of Files' => 'Lista plików',
        'Permission' => 'Prawo dostępu',
        'Download file from package!' => 'Pobierz plik z pakietu!',
        'Required' => 'Wymagany',
        'Primary Key' => 'Klucz podstawowy',
        'Auto Increment' => 'Automatycznie zwiększane',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Różnice plikowe dla pliku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log wydajnosci',
        'Range' => 'Zakres',
        'last' => 'w ciągu',
        'This feature is enabled!' => 'Ta funkcja jest włączona!',
        'Just use this feature if you want to log each request.' => 'Wybierz tę opcję jeżeli chcesz logować każde żądanie.',
        'Activating this feature might affect your system performance!' =>
            'Włączenie tej opcji może wpłynąć na wydajność twojego systemu!',
        'Disable it here!' => 'Wyłącz tutaj!',
        'Logfile too large!' => 'Plik log jest za duży!',
        'The logfile is too large, you need to reset it' => 'Log jest zbyt duży - musisz go zresetować!',
        'Interface' => 'Interfejs',
        'Requests' => 'Żądania',
        'Min Response' => 'Min. odpowiedź',
        'Max Response' => 'Max odpowiedź',
        'Average Response' => 'Średnia odpowiedź',
        'Period' => 'Okres',
        'minutes' => 'minut(-y)',
        'Min' => 'Min.',
        'Max' => 'Max.',
        'Average' => 'Średnia',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Zarządzanie filtrami poczty przychodzącej',
        'Add PostMaster Filter' => 'Dodaj filtr pocztowy',
        'Edit PostMaster Filter' => 'Edytuj filtr pocztowy',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Aby rozdzielić lub odfiltrować napływające wiadomości e-mail na podstawie nagłówków e-mail. Możliwe dopasowywanie przy użyciu wyrażeń regularnych.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jeżeli chcesz tylko dopasować adres e-mail użyj EMAILADDRESS:info@example.com w polach Od, Do lub Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Jeśli użyjesz wyrażeń regularnych, możesz również użyć dopasowanej wartości w () jako [***] w akcji \'Set\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Usuń ten filtr',
        'Do you really want to delete this postmaster filter?' => 'Czy na pewno chcesz skasować ten filtr pocztowy?',
        'A postmaster filter with this name already exists!' => 'Filtr poczty o takiej nazwie już istnieje!',
        'Filter Condition' => 'Warunek filtra',
        'AND Condition' => 'Warunek ORAZ',
        'Search header field' => '',
        'for value' => 'dla wartości',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Pole musi zawierać poprawne wyrażenie regularne lub słowo.',
        'Negate' => 'Zaprzeczenie',
        'Set Email Headers' => 'Ustaw nagłówek e-mail',
        'Set email header' => 'Ustaw nagłówek wiadomości e-mail',
        'with value' => 'z wartością',
        'The field needs to be a literal word.' => 'Pole musi zawierać słowo.',
        'Header' => 'Nagłówek',

        # Template: AdminPriority
        'Priority Management' => 'Zarządzanie priorytetami',
        'Add Priority' => 'Dodaj priorytet',
        'Edit Priority' => 'Edytuj priorytet',
        'Filter for Priorities' => 'Filtr dla Priorytetów',
        'Filter for priorities' => 'Filtr dla priorytetów',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Zarządzanie procesami',
        'Filter for Processes' => 'Filtr procesów',
        'Filter for processes' => '',
        'Create New Process' => 'Utwórz nowy proces',
        'Deploy All Processes' => 'Wdróż wszystkie procesy',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Tutaj możesz załadować plik konfiguracji aby zaimportować proces do twojego systemu. Plik musi być w formacie .yml wyeksportowanym z modułu zarządzania procesami.',
        'Upload process configuration' => 'Załaduj konfigurację procesu',
        'Import process configuration' => 'Importuj konfigurację procesu',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Aby utworzyć nowy proces, możesz albo zaimportować proces, który został wyeksportowany z innego systemu lub utworzyć całkowicie nowy proces.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Zmiany wprowadzone tutaj do procesów zostaną uwzględnione w systemie jeśli zsynchronizujesz dane procesów. Wskutek synchronizacji procesów, nowe zmiany będą zapisane do konfiguracji.',
        'Processes' => 'Procesy',
        'Process name' => 'Nazwa procesu',
        'Print' => 'Drukuj',
        'Export Process Configuration' => 'Eksportuj konfigurację procesu',
        'Copy Process' => 'Kopiuj proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Zrezygnuj i zamknij',
        'Go Back' => 'Wstecz',
        'Please note, that changing this activity will affect the following processes' =>
            'Zwróć uwagę, że zmiana tego działania wpłynie na następujące procesy',
        'Activity' => 'Działanie',
        'Activity Name' => 'Nazwa działania',
        'Activity Dialogs' => 'Okna działań',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisać okna działań do tego działania poprzez przeciągnięcie elementów za pomocą myszki z listy po lewej stronie do listy po prawej stronie.',
        'Filter available Activity Dialogs' => 'Filtruj dostępne okna działań',
        'Available Activity Dialogs' => 'Dostępne okna działań',
        'Name: %s, EntityID: %s' => 'Nazwa: %s, EtnityID: %s',
        'Create New Activity Dialog' => 'Utwórz nowe okno działania',
        'Assigned Activity Dialogs' => 'Przypisane okna działań',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Zwróć uwagę, że zmiany tego okna wpłyną na następnujące działania',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Miej na uwadze, że użytkownicy klientów nie będą widzieć pól: Właściciel, Odpowiedzialny, Blokada, CzasOczekiwania i IDużytkownika.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'Okna działania',
        'Activity dialog Name' => 'Nazwa okna działania',
        'Available in' => 'Dostępne w',
        'Description (short)' => 'Opis (krótki)',
        'Description (long)' => 'Opis (długi)',
        'The selected permission does not exist.' => 'Zaznaczone uprawnienie nie istnieje.',
        'Required Lock' => 'Wymagana blokada',
        'The selected required lock does not exist.' => 'Zaznaczona wymagana blokada nie istnieje.',
        'Submit Advice Text' => 'Tekst porady wysyłania',
        'Submit Button Text' => 'Tekst przycisku wysyłania',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisac pola do tego okna działania za pomocą przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
        'Filter available fields' => 'Filtruj dostępne pola',
        'Available Fields' => 'Dostępne pola',
        'Assigned Fields' => 'Przypisane pola',
        'Communication Channel' => 'Kanał Komunikacji',
        'Is visible for customer' => 'Jest widoczna dla klienta',
        'Display' => 'Wyświetl',

        # Template: AdminProcessManagementPath
        'Path' => 'Ścieżka',
        'Edit this transition' => 'Edytuj to przejście',
        'Transition Actions' => 'Akcje przejścia',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisać akcje przejścia do tego przejścia za pomocą przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
        'Filter available Transition Actions' => 'Filtruj dostępne akcje przejścia',
        'Available Transition Actions' => 'Dostępne akcje przejścia',
        'Create New Transition Action' => 'Utwórz nową akcję przejścia',
        'Assigned Transition Actions' => 'Przypisane akcje przejścia',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Działania',
        'Filter Activities...' => 'Filtruj działania...',
        'Create New Activity' => 'Utwórz nowe działanie',
        'Filter Activity Dialogs...' => 'Filtruj okna działań...',
        'Transitions' => 'Przejścia',
        'Filter Transitions...' => 'Filtruj przejścia...',
        'Create New Transition' => 'Utwórz nowe przejście',
        'Filter Transition Actions...' => 'Filtruj akcje przejść...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Edytuj proces',
        'Print process information' => 'Drukuj informację o procesie',
        'Delete Process' => 'Usuń proces',
        'Delete Inactive Process' => 'Usuń nieaktywny proces',
        'Available Process Elements' => 'Dostępne elementy procesów',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementy z listy ponad tym paskiem bocznym mogą być przenoszone do obszaru projektu po prawej stronie za pomocą chwytania i upuszczania.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Możes umieszczać działania na obszarze projektu aby przypisywać te działania do procesu.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Aby przypisać okno działania do działania, upuść element okna działania z paska bocznego na działanie znajdujące się w obszarze projektu.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Akcje mogą być przypisywane do przejść poprzez upuszczanie elementu akcji na etykietę przejścia.',
        'Edit Process Information' => 'Edytuj informacje o procesie',
        'Process Name' => 'Nazwa procesu',
        'The selected state does not exist.' => 'Wybrany stan nie istnieje.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Dodaj i edytuj działania, okna działań i przejścia',
        'Show EntityIDs' => 'Pokaż EntityID',
        'Extend the width of the Canvas' => 'Zwiększ szerokość obszaru projektu',
        'Extend the height of the Canvas' => 'Zwiększ wysokość obszaru projektu',
        'Remove the Activity from this Process' => 'Usuń działanie z tego procesu',
        'Edit this Activity' => 'Edytuj to działanie',
        'Save Activities, Activity Dialogs and Transitions' => 'Zapisz aktywności, dialogi aktywności i przejść',
        'Do you really want to delete this Process?' => 'Czy na pewno chcesz usunąć ten proces?',
        'Do you really want to delete this Activity?' => 'Czy na pewno chcesz usunąć to działanie? ',
        'Do you really want to delete this Activity Dialog?' => 'Czy na pewno chcesz usunąć to okno działania? ',
        'Do you really want to delete this Transition?' => 'Czy na pewno chcesz usunąć to przejście?',
        'Do you really want to delete this Transition Action?' => 'Czy na pewno chcesz usunąć tę akcję przejścia? ',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Czy na pewno chcesz usunąć to działanie z obszaru projektu? Cofnięcie tego będzie możliwe tylko poprzez opuszczenie tego ekranu bez zapisywania.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Czy na pewno chcesz usunąć to przejście z obszaru projektu? Cofnięcie tego będzie możliwe tylko poprzez opuszczenie tego ekranu bez zapisywania.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Na tym ekranie możesz utworzyć nowy proces. Aby udostępnić proces użytkownikom, ustaw stan na "Aktywne" i zsynchronizuj po zakończeniu.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'zrezygnuj i zamknij',
        'Start Activity' => 'Działanie początkowe',
        'Contains %s dialog(s)' => 'Zawiera %s okien',
        'Assigned dialogs' => 'Przypisane okna',
        'Activities are not being used in this process.' => 'Działania nie są używane w tym procesie.',
        'Assigned fields' => 'Przypisane pola',
        'Activity dialogs are not being used in this process.' => 'Okna działań nie są używane w tym procesie.',
        'Condition linking' => 'Łączenie warunkowe',
        'Transitions are not being used in this process.' => 'Przejścia nie są używane w tym procesie.',
        'Module name' => 'Nazwa modułu',
        'Transition actions are not being used in this process.' => 'Akcje przejść nie są używane w tym procesie.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Zwróć uwagę, że zmiana tego przejścia wpłynie na następujące procesy',
        'Transition' => 'Przejście',
        'Transition Name' => 'Nazwa przejścia',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Zwróć uwagę, że zmiana tej akcji przejścia wpłynie na następujące procesy',
        'Transition Action' => 'Akcja przejścia',
        'Transition Action Name' => 'Nazwa akcji przejścia',
        'Transition Action Module' => 'Moduł akcji przejścia',
        'Config Parameters' => 'Parametry konfiguracyjne',
        'Add a new Parameter' => 'Dodaj nowy parametr',
        'Remove this Parameter' => 'Usuń ten parametr',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Dodaj kolejkę',
        'Edit Queue' => 'Edytuj kolejkę',
        'Filter for Queues' => 'Filtrowanie kolejek',
        'Filter for queues' => 'Filtr dla kolejek',
        'A queue with this name already exists!' => 'Kolejka o tej nazwie już istnieje!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Podkolejka kolejki',
        'Unlock timeout' => 'Limit czasowy odblokowania',
        '0 = no unlock' => '0 = bez odblokowania',
        'hours' => 'godz.',
        'Only business hours are counted.' => 'Tylko godziny pracy są liczone.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jeśli agent zablokuje zgłoszenie i nie zamknie go w czasie określonym przez limit odblokowania, zgłoszenie zostanie odblokowane i będzie dostępne dla innych agentów.',
        'Notify by' => 'Powiadom wcześniej',
        '0 = no escalation' => '0 = brak eskalacji',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli nie będzie kontaktu z klientem, ani wiadomości e-mail, ani telefonu dodanego do zgłoszenia przed upływem określonego tutaj czasu, zgłoszenie to będzie eskalowane.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli dodana zostanie wiadomość, przez e-mail lub przez panel klienta, czas aktualizacji eskalacji będzie zresetowany. Jeśli nie będzie kontaktu z klientem, ani wiadomości e-mail, ani telefonu dodanego do zgłoszenia przed upływem określonego tutaj czasu, zgłoszenie to będzie eskalowane.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Jeśli zgłoszenie nie zostanie zamknięce do przed podanym tutaj czasem, zgłoszenie będzie eskalowane.',
        'Follow up Option' => 'Opcje nawiązań',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Określa czy wiadomość nawiązująca do zamkniętego zgłoszenia będzie otwierała to zgłoszenie czy będzie odrzucana czy też będzie generowała nowe zgłoszenie.',
        'Ticket lock after a follow up' => 'Zgłoszenie zablokowane po nowej wiadomości',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Jeśli zgłoszenie jest zamknięte a klient wyśle nową wiadomość do zgłoszenia, zgłoszenie to będzie zablokowane dla ostatniego właściciela.',
        'System address' => 'Adres systemowy',
        'Will be the sender address of this queue for email answers.' => 'Będzie adresem nadawcy odpowiedzi e-mailowych wysyłanych z tej kolejki.',
        'Default sign key' => 'Domyślny klucz do podpisywania',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Powitanie',
        'The salutation for email answers.' => 'Powitanie dla odpowiedzi e-mailowych.',
        'Signature' => 'Podpis',
        'The signature for email answers.' => 'Podpis dla odpowiedzi e-mailowych.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Zarządzaj relacjami kolejka-autoodpowiedź',
        'Change Auto Response Relations for Queue' => 'Zmień relacje autoodpowiedzi dla kolejki',
        'This filter allow you to show queues without auto responses' => 'Ten filtr pozwala pokazać zapytania bez automatycznych odpowiedzi',
        'Queues without Auto Responses' => 'Kolejki bez Auto Odpowiedzi',
        'This filter allow you to show all queues' => 'Ten filtr pozwala na wyświetlenie wszystkich kolejek',
        'Show All Queues' => 'Pokaż Wszystkie Kolejki',
        'Auto Responses' => 'Automatyczne odpowiedzi',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Zarządzaj relacjami Szablonowo-Kolejkowymi',
        'Filter for Templates' => 'Filtr szalbonów',
        'Filter for templates' => '',
        'Templates' => 'Szablony',

        # Template: AdminRegistration
        'System Registration Management' => 'Zarządzanie rejestracją systemu',
        'Edit System Registration' => 'Zmień Rejestracje Systemu',
        'System Registration Overview' => '',
        'Register System' => 'Zarejestruj System',
        'Validate OTOBO-ID' => '',
        'Deregister System' => 'Wyrejestruj system',
        'Edit details' => 'Edytuj detale',
        'Show transmitted data' => 'Pokaż wysłane dane',
        'Deregister system' => 'Wyrejestruj system',
        'Overview of registered systems' => 'Przegląd zarejestrowanych systemów',
        'This system is registered with OTOBO Team.' => 'Ten system jest zarejestrowany w grupie OTRS.',
        'System type' => 'Typ systemu',
        'Unique ID' => 'Unikalne ID',
        'Last communication with registration server' => 'Ostatnia komunikacja z serwerem rejestrującym',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Zauważ, że nie możesz zarejestrować swojego systemu jeśli Demon OTOBO nie jest poprawnie uruchomiony!',
        'Instructions' => 'Instrukcje',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'Login OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'System rejestracji jest serwisem grupy OTRS, kóry posiada wiele zalet!',
        'Read more' => 'Przeczytaj więcej',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Musisz zalogować się przy użyciu swojego loginu OTOBO-ID by móc zarejestrować system.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Twoje OTOBO-ID to adres e-mail który użyłeś podczas rejestracji na stonie OTOBO.com.',
        'Data Protection' => 'Ochrona danych',
        'What are the advantages of system registration?' => 'Jakie są zalety z rejestracji systemu?',
        'You will receive updates about relevant security releases.' => 'Będziesz otrzymywał informacje o istotnych wydaniach bezpieczeństwa.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Wraz z rejestracją możliwe będzie świadczenie przez nas ulepszonego serwisu dla was, gdyż będziemy posiadali wszystkie ku temu potrzebne informacje.',
        'This is only the beginning!' => 'To tylko początek!',
        'We will inform you about our new services and offerings soon.' =>
            'Niedługo będziemy informować o naszych serwisach i ofertach.',
        'Can I use OTOBO without being registered?' => 'Czy mogę używać OTOBO bez dokonania rejestracji?',
        'System registration is optional.' => 'Rejestracja systemu jest opcjonalna.',
        'You can download and use OTOBO without being registered.' => 'Możesz pobrać oraz użytkować OTOBO bez dokonywania rejestrcji.',
        'Is it possible to deregister?' => 'Czy wyrejestrowanie jest możliwe?',
        'You can deregister at any time.' => 'Wyrejestrować można się w każdej chwili.',
        'Which data is transfered when registering?' => 'Jakie dane są przesyłane podczas rejestracji?',
        'A registered system sends the following data to OTOBO Team:' => 'Zarejestrowany system wysyła następujące dane do Grupy OTRS:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Pełna jednoznaczna nazwa domenowa (FQDN), wersja OTOBO, Baza danych, System operacyjny oraz wersja Perl.',
        'Why do I have to provide a description for my system?' => 'Dlaczego muszę udzielić opisu mojego systemu?',
        'The description of the system is optional.' => 'Udzielenie opisu systemu jest opcjonalne.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Opis oraz typ systemu który podasz pomogą tobie w identyfikacji oraz zarządzaniu zarejestrowanymi systemami.',
        'How often does my OTOBO system send updates?' => 'Jak często mój system OTOBO wysyła uaktualnienia?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Twój system będzie wysyłał uaktulanienia do serwera rejestracji w regularnych przedziałach czasowych.',
        'Typically this would be around once every three days.' => 'Typowo będzie to następowało co trzy dni.',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Musisz zalogować się przy użyciu swojego OTOBO-ID b ymóc dokonać derejestracji.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Nie posiadasz jeszcze OTOBO-ID?',
        'Sign up now' => 'Zarejestruj się',
        'Forgot your password?' => 'Zapomniałeś swojego hasła?',
        'Retrieve a new one' => 'Otrzymaj nowe',
        'Next' => 'Dalej',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'następujące dane będą przesyłane do Grupy OTRS gdy zarejestrujesz system.',
        'Attribute' => 'Atrybut',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'Wersja OTOBO',
        'Operating System' => 'System operacyjny',
        'Perl Version' => 'Wersja Perl',
        'Optional description of this system.' => 'Opcjonalny opis systemu',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Pozwala na przesyłanie dodatkowych danych do grupy wsparcia OTRS',
        'Register' => 'Zarejestruj',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Kontynuacja tego kroku spowoduje wyrejestrowanie systemu z Grupy OTRS',
        'Deregister' => 'Wyrejestrowanie',
        'You can modify registration settings here.' => 'Tutaj możesz zmienić ustawienia rejestracji.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => 'Dane wsparcia',

        # Template: AdminRole
        'Role Management' => 'Zarządzanie rolami',
        'Add Role' => 'Dodaj rolę',
        'Edit Role' => 'Edytuj rolę',
        'Filter for Roles' => 'Filtr ról',
        'Filter for roles' => 'Filtr dla ról',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Utwórz rolę i dodaj grupę do niej. Potem dodaj rolę do użytkownika.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nie ma zdefiniowanych ról. Użyj przycisku \'Dodaj rolę\' aby utworzyć nową rolę.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Zarządzaj relacjami rola-grupa',
        'Roles' => 'Role',
        'Select the role:group permissions.' => 'Zaznacz uprawnienia rola:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jeśli nic nie będzie zaznaczone, wtedy nie będzie uprawnień w tej grupie (zgłoszenia nie będą dostępne dla roli).',
        'Toggle %s permission for all' => 'Przełącz uprawnienie %s dla wszystkich',
        'move_into' => 'przenieś do',
        'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zgłoszeń do tej grupy/kolejki',
        'create' => 'utwórz',
        'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zgłoszeń w tej grupie/kolejce',
        'note' => 'uwaga',
        'Permissions to add notes to tickets in this group/queue.' => 'Uprawnienia do dodawania uwag do zgłoszeń w tej grupie/kolejce.',
        'owner' => 'właściciel',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Uprawnienia do zmiany właściciela zgłoszeńw tej grupie/kolejce.',
        'priority' => 'priorytet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Uprawnienia do zmiany priorytetu zgłoszenia w tej grupie/kolejce',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Zarządzaj relacjami agent-rola',
        'Add Agent' => 'Dodaj agenta',
        'Filter for Agents' => 'Filtrowanie agentów',
        'Filter for agents' => '',
        'Agents' => 'Agenci',
        'Manage Role-Agent Relations' => 'Zarządzaj relacjami rola-agent',

        # Template: AdminSLA
        'SLA Management' => 'Konfiguracja SLA',
        'Edit SLA' => 'Edytuj SLA',
        'Add SLA' => 'Dodaj SLA',
        'Filter for SLAs' => 'Filtr dla SLA',
        'Please write only numbers!' => 'Podaj wyłączenie numery!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Konfiguracja S/MIME',
        'Add Certificate' => 'Dodaj certyfikat',
        'Add Private Key' => 'Dodaj klucz prywatny',
        'SMIME support is disabled' => 'Wsparcie dla SMIME jest wyłączone',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Aby móc używać SMIME w OTOBO musisz najpierw włączyć dla niego wsparcie.',
        'Enable SMIME support' => 'Aktywuj wsparcie dla SMIME',
        'Faulty SMIME configuration' => 'Błędna konfiguracja SMIME',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => 'Sprawdź konfigurację SMIME',
        'Filter for Certificates' => 'Filtr dla Certyfikatów',
        'Filter for certificates' => 'Filtruj certyfikaty',
        'To show certificate details click on a certificate icon.' => 'Kliknij w ikonę certyfikatu by zobaczyć jego detale.',
        'To manage private certificate relations click on a private key icon.' =>
            'Kliknij w ikonę prywatne by zarządzać relacjami certyfikatu prywatnego.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Zobacz także',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'W taki sposób możesz bezpośrednio edytować certyfikaty i klucze prywarne w systemie plików.',
        'Hash' => 'Skrót (hash)',
        'Create' => 'Utwórz',
        'Handle related certificates' => 'Obsługuj powiązane certyfikaty',
        'Read certificate' => 'Czytaj certyfikat',
        'Delete this certificate' => 'Usuń ten certyfikat',
        'File' => 'Plik',
        'Secret' => 'Hasło',
        'Related Certificates for' => 'Certyfikaty powiązane dla',
        'Delete this relation' => 'Usuń to powiązanie',
        'Available Certificates' => 'Dostępne certyfikaty',
        'Filter for S/MIME certs' => 'Filtruj certyfikaty S/MIME',
        'Relate this certificate' => 'Powiąż ten certyfikat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certyfikat S/MIME',
        'Certificate Details' => 'Szczegóły Certyfikatu',
        'Close this dialog' => 'Zamknij to okno dialogowe',

        # Template: AdminSalutation
        'Salutation Management' => 'Zarządzanie powitaniami',
        'Add Salutation' => 'Dodaj powitanie',
        'Edit Salutation' => 'Edytuj powitanie',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'np.',
        'Example salutation' => 'Przykładowe powitanie',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Tryb bezpieczny będzie (standardowo) włączony po inicjalnej instalacji.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Jeśli tryb bezpieczny nie jest aktywny, uaktywnij go w SysConfig gdyż twoja aplikacja jest już uruchomiona.',

        # Template: AdminSelectBox
        'SQL Box' => 'Konsola SQL',
        'Filter for Results' => 'Filtr dla Wyników',
        'Filter for results' => 'Filtr dla wyników',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Wpisz zapytanie SQL, które zostanie wysłane bezpośrednio do bazy danych.',
        'Options' => 'Opcje',
        'Only select queries are allowed.' => 'Tylko wybrane zapytania są dozwolone.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Składnia twojego zapytania SQL jest niepoprawna. Sprawdź ją.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Brakuje przynajmniej jednego parametru połączenia. Sprawdź je.',
        'Result format' => 'Format wyników',
        'Run Query' => 'Uruchom polecenie',
        '%s Results' => '1%s Wyniki',
        'Query is executed.' => 'Zapytanie jest wykonywane.',

        # Template: AdminService
        'Service Management' => 'Konfiguracja usług',
        'Add Service' => 'Dodaj usługę',
        'Edit Service' => 'Edytuj usługę',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Długość nazwy usługi to maksymalnie 200 znaków (razem z podusługą)',
        'Sub-service of' => 'Usługa podrzędna dla',

        # Template: AdminSession
        'Session Management' => 'Zarządzanie sesjami',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Wszystkie sesje',
        'Agent sessions' => 'Sesje agentów',
        'Customer sessions' => 'Sesje klientów',
        'Unique agents' => 'Unikalni agenci',
        'Unique customers' => 'Unikalni klienci',
        'Kill all sessions' => 'Zakończ wszystkie sesje',
        'Kill this session' => 'Zabij tą sesję',
        'Filter for Sessions' => 'Filtr dla Sesji',
        'Filter for sessions' => 'Filtr dla sesji',
        'Session' => 'Sesja',
        'Kill' => 'Zabij',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Konfiguracja podpisów',
        'Add Signature' => 'Dodaj podpis',
        'Edit Signature' => 'Edytuj podpis',
        'Filter for Signatures' => 'Filtr dla Podpisów',
        'Filter for signatures' => 'Filtr dla podpisów',
        'Example signature' => 'Przykładowy podpis',

        # Template: AdminState
        'State Management' => 'Zarządzanie stanami',
        'Add State' => 'Dodaj stan',
        'Edit State' => 'Edytuj stan',
        'Filter for States' => 'Filtr dla Stanów',
        'Filter for states' => 'Filtr dla stanów',
        'Attention' => 'Uwaga',
        'Please also update the states in SysConfig where needed.' => 'Zaktualizuj również stan w konfiguracji systemu tam gdzie to konieczne.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Rodzaj stanu',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => 'Uruchom usługi w churze',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => 'Wyślij aktualizację',
        'Currently this data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Jest wysoce zalecanym by wysłać te dane do Grupy OTRS w celu uzyskania lepszego wsparcia.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Aby włączyć przesyłanie danych, zarejestruj swój system w Grupie OTRS lub zaktualizuj informacje rejestracyjne systemu (upewnij się że opcja \'wysyłaj dane wsparcia\' jest akywna).',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Proszę wybrać jedną z poniższych opcji.',
        'Send by Email' => 'Wyślij za pomocą wiadomości e-mail',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Pakiet serwisowy jest zbyt duży, by wysłać go e-mailem. Ta opcja została wyłączona.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Adres e-mail użytkownika jest nieprawidłowy. Ta opcja została wyłączona.',
        'Sending' => 'Nadawca',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'Pakiet serwisowy zostanie automatycznie wysłany e-mailem do Grupy OTRS',
        'Download File' => 'Pobierz plik',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Szczegóły',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Konfiguracja adresów e-mail Systemu',
        'Add System Email Address' => 'Dodaj systemowy adres e-mail',
        'Edit System Email Address' => 'Edytuj systemowy adres e-mail',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Wszystkie przychodzące wiadomości e-mail z tym adresem w Do lub DW będą skierowane do wskazanej kolejki.',
        'Email address' => 'Adres e-mail',
        'Display name' => 'Wyświetlana nazwa',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Wyświetlana nazwa oraz adres e-mail będą umieszczane w wysyłanej poczcie.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'dokumentację administratora online',
        'System configuration' => 'Konfiguracja systemu',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Poruszaj się wśród dostępnych ustawień, używając drzewa w obszarze nawigacyjnym po lewej stronie.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Znajdź określone ustawienia używając poniższego pola wyszukiwania, lub przy pomocy ikony wyszukiwania w menu nawigacyjnym.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Przeczytaj "%s" i dowiedz się jak używać konfiguracji systemu.',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Wdrażanie zmian',
        'Help' => 'Pomoc',
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
        'Changes Overview' => 'Przegląd Zmian',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Przełącz się do trybu zaawansowanego by wdrożyć parametry konfiguracji zmienione również przez innych użytkowników.',
        'There are no settings to be deployed.' => 'Nie ma zmian parametrów do wdrożenia.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Przełącz się do trybu zaawansowanego by zobaczyć gotowe do wdrożenia parametry konfiguracji zmienione przez innych użytkowników.',
        'Deploy selected changes' => 'Opublikuj wybrane zmiany',

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
        'by' => 'przez',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Import i Eksport',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => 'Ustawienia, które aktualnie edytuję',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Twoje wyszukiwanie "%s" w categorii "%s" nie zwróciło żadnego wyniku.',
        'Your search for "%s" in category "%s" returned one result.' => 'Twoje wyszukiwanie "%s" w categorii "%s" zwróciło jeden wynik.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Twoje wyszukiwanie "%s" w categorii "%s" zwróciło "%s" wyników.',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategoria',
        'Run search' => 'Szukaj',

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
        'Go back to Deployment Details' => 'Wróć do szczegółów wdrożenia',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Zarządzanie konserwacją systemu',
        'Schedule New System Maintenance' => 'Zaplanuj nową konserwację systemu',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => 'Data końca',
        'Delete System Maintenance' => 'Usuń konserwację systemu',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Niepoprawna data',
        'Login message' => 'Wiadomość przy logowaniu',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Pokaż wiadomość przy logowaniu',
        'Notify message' => 'Komunikat',
        'Manage Sessions' => 'Zarządzanie sesjami',
        'All Sessions' => 'Wszystkie sesje',
        'Agent Sessions' => 'Sesje Agentów',
        'Customer Sessions' => 'Sesje Klientów',
        'Kill all Sessions, except for your own' => 'Zakończ wszystkie sesje z wyjątkiem własnej',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Dodaj szablon',
        'Edit Template' => 'Edytuj szablon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Szablon jest domyślnym tekstem który pozwala agentom na szybsze wypisywanie zgłoszeń, odpowiedzi i przekazań.',
        'Don\'t forget to add new templates to queues.' => 'Nie zapomnij dodać nowych szablonów do kolejki.',
        'Attachments' => 'Załączniki',
        'Delete this entry' => 'Usuń tę pozycję',
        'Do you really want to delete this template?' => 'Czy na pewno chcesz usunąć ten szablon?',
        'A standard template with this name already exists!' => 'Szablon o takiej nazwie już istnieje!',
        'Create type templates only supports this smart tags' => 'Tworzenie typowych szablonów wspiera jedynie takie tagi',
        'Example template' => 'Przykładowy szablon',
        'The current ticket state is' => 'Aktualny stan zgłoszenia to',
        'Your email address is' => 'Twój adres e-mail to',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Przełącz aktywność dla wszystkich',
        'Link %s to selected %s' => 'Łącz %s do zaznaczenia %s',

        # Template: AdminType
        'Type Management' => 'Zarządzanie typami',
        'Add Type' => 'Dodaj typ',
        'Edit Type' => 'Edytuj typ zgłoszenia',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Typ o takiej nazwie już istnieje!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Zarządzanie agentami',
        'Edit Agent' => 'Edytuj agenta',
        'Edit personal preferences for this agent' => 'Edytuj ustawienia osobiste tego agenta',
        'Agents will be needed to handle tickets.' => 'Agenci są potrzebni do obsługi zgłoszeń.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Nie zapomnij dodać nowego agenta do grup lub/i ról!',
        'Please enter a search term to look for agents.' => 'Podaj frazy wyszukiwania agentów.',
        'Last login' => 'Ostatnie logowanie',
        'Switch to agent' => 'Przełącz na agenta',
        'Title or salutation' => 'Tytuł albo zwrot grzecznościowy',
        'Firstname' => 'Imię',
        'Lastname' => 'Nazwisko',
        'A user with this username already exists!' => 'Użytkownik o takiej nazwie już istnieje!',
        'Will be auto-generated if left empty.' => 'Zostanie wygenerowane automatycznie jeśli pozostawione puste.',
        'Mobile' => 'Tel. kom.',
        'Effective Permissions for Agent' => 'Wypadkowe uprawnienia agenta',
        'This agent has no group permissions.' => 'Ten Agent nie ma uprawnień do grup.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zarządzaj relacjami agent-grupa',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Przegląd terminarza',
        'Manage Calendars' => 'Zarządzaj kalendarzami',
        'Add Appointment' => 'Dodaj wydarzenie',
        'Today' => 'Dzisiaj',
        'All-day' => 'całodobowo',
        'Repeat' => 'Powtarzaj',
        'Notification' => 'Powiadomienie',
        'Yes' => 'Tak',
        'No' => 'Nie',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Nie znaleziono kalendarzy. Proszę dodać najpierw kalendarz używając strony Zarządzanie Kalendarzami.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Dodaj nowe wydarzenie',
        'Calendars' => 'Kalendarze',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Podstawowe informacje',
        'Date/Time' => 'Data/Czas',
        'Invalid date!' => 'Błędna data!',
        'Please set this to value before End date.' => 'Proszę ustawić tę wartość przed datą zakończenia.',
        'Please set this to value after Start date.' => 'Proszę ustawić tę wartość po dacie rozpoczęcia.',
        'This an occurrence of a repeating appointment.' => 'To jest wystąpienie powtarzalnego wydarzenia.',
        'Click here to see the parent appointment.' => 'Kliknij tutaj by sprawdzić wydarzenie główne.',
        'Click here to edit the parent appointment.' => 'Kliknij tutaj by edytować wydarzenie główne.',
        'Frequency' => 'Częstotliwość',
        'Every' => 'Każdy',
        'day(s)' => 'dzień(dni)',
        'week(s)' => 'tydzień(tygodnie)',
        'month(s)' => 'miesiąc(-cy)',
        'year(s)' => 'rok(lat)',
        'On' => 'Włączone',
        'Monday' => '1.Poniedziałek',
        'Mon' => 'Pn',
        'Tuesday' => '2.Wtorek',
        'Tue' => 'Wt',
        'Wednesday' => '3.Środa',
        'Wed' => 'Śr',
        'Thursday' => '4.Czwartek',
        'Thu' => 'Cz',
        'Friday' => '5.Piątek',
        'Fri' => 'Pt',
        'Saturday' => '6.Sobota',
        'Sat' => 'So',
        'Sunday' => '7.Niedziela',
        'Sun' => 'Nd',
        'January' => 'Styczeń',
        'Jan' => 'Sty',
        'February' => 'Luty',
        'Feb' => 'Lut',
        'March' => 'Marzec',
        'Mar' => 'Mar',
        'April' => 'Kwiecień',
        'Apr' => 'Kwi',
        'May_long' => 'Maj',
        'May' => 'Maj',
        'June' => 'Czerwiec',
        'Jun' => 'Cze',
        'July' => 'Lipiec',
        'Jul' => 'Lip',
        'August' => 'Sierpień',
        'Aug' => 'Sie',
        'September' => 'Wrzesień',
        'Sep' => 'Wrz',
        'October' => 'Październik',
        'Oct' => 'Paź',
        'November' => 'Listopad',
        'Nov' => 'Lis',
        'December' => 'Grudzień',
        'Dec' => 'Gru',
        'Relative point of time' => '',
        'Link' => 'Połącz',
        'Remove entry' => 'Usuń pozycję',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centrum informacji o kliencie',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Użytkownik klienta',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Uwaga: Nieprawidłowy klient!',
        'Start chat' => 'Rozpocznij czat',
        'Video call' => 'Wideo rozmowa',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Szablon wyszukiwania',
        'Create Template' => 'Utwórz szablon',
        'Create New' => 'Utwórz nowy',
        'Save changes in template' => 'Zapisz zmiany w szablonie',
        'Filters in use' => 'Filtry w użyciu',
        'Additional filters' => 'Dodatkowe filtry',
        'Add another attribute' => 'Dodaj inny parametr',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Zaznacz wszystkie',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Zmień kryteria wyszukiwania',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centrum Informacji o użytkowniku klienta',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Uruchomiony Daemon OTOBO jest niezbędny do prawidłowego działania systemu.',
        'Starting the OTOBO Daemon' => 'Uruchom OTOBO Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Pulpit',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nowe wydarzenie',
        'Tomorrow' => 'Jutro',
        'Soon' => 'Niebawem',
        '5 days' => '5 dni',
        'Start' => 'Start',
        'none' => 'brak',

        # Template: AgentDashboardCalendarOverview
        'in' => 'za',

        # Template: AgentDashboardCommon
        'Save settings' => 'Zapisz ustawienia',
        'Close this widget' => 'Zamknij ten widget',
        'more' => 'więcej',
        'Available Columns' => 'Dostępne kolumny',
        'Visible Columns (order by drag & drop)' => 'Widoczne kolumny (sortuj poprzez przeciągnij i upuść)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Otwarte',
        'Closed' => 'Zamknięte',
        '%s open ticket(s) of %s' => '% otwartych zgłoszeń z %s',
        '%s closed ticket(s) of %s' => '%s zamkniętych zgłoszeń z %s',
        'Edit customer ID' => 'Zmień ID klienta',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Zgłoszenia eskalowane',
        'Open tickets' => 'Otwarte zgłoszenia',
        'Closed tickets' => 'Zamknięte zgłoszenia',
        'All tickets' => 'Wszystkie zgłoszenia',
        'Archived tickets' => 'Zarchiwizowane zgłoszenia',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Uwaga: Użytkownik klienta jest nieprawidłowy!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Informacje o Użytkowniku Klienta',
        'Phone ticket' => 'Zgłoszenia tel.',
        'Email ticket' => 'Zgłoszenia e-mail',
        'New phone ticket from %s' => 'Nowe zgłoszenie tel. od %s',
        'New email ticket to %s' => 'Nowe zgłoszenie e-mail od %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s jest dostępna',
        'Please update now.' => 'Prosimy, zaktualizuj teraz.',
        'Release Note' => 'Uwagi do wydania',
        'Level' => 'Poziom',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Opublikowane %s temu.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Konfiguracja tego wigdeta statystyk zawiera błędy, przejrzyj jego ustawienia.',
        'Download as SVG file' => 'Pobierz jako plik SVG',
        'Download as PNG file' => 'Pobierz jako plik PNG',
        'Download as CSV file' => 'Pobierz jako plik CSV',
        'Download as Excel file' => 'Pobierz jako plik Excel',
        'Download as PDF file' => 'Pobierz jako plik PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Statystyki są dla ciebie przygotowywane. Proszę o cierpliwość.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Przypisane do użytkownika klienta',
        'Accessible for customer user' => 'Dostępne dla użytkownika klienta',
        'My locked tickets' => 'Zablokowane',
        'My watched tickets' => 'Obserwowane',
        'My responsibilities' => 'Odpowiedzialny',
        'Tickets in My Queues' => 'Zgłoszenia w Moich Kolejkach',
        'Tickets in My Services' => 'Zgłoszenia w Moje Usługi',
        'Service Time' => 'W godzinach roboczych',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Suma',

        # Template: AgentDashboardUserOnline
        'out of office' => 'poza biurem',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'do',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Powrót',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentElasticsearchQuickResult
        'Ticketnumber' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Aby zaakceptować niektóre wiadomości, licencje lub niektóre zmiany.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => 'Połącz z',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Zmień hasło',
        'Current password' => 'Aktualne hasło',
        'New password' => 'Nowe hasło',
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
        'Edit your preferences' => 'Zmień swoje ustawienia',
        'Personal Preferences' => 'Ustawienia osobiste',
        'Preferences' => 'Ustawienia',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Dostosuj swoje ustawienia osobiste. Każdą z opcji można zapisać klikając ✓ po prawej stronie.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => 'Akcje dynamiczne',
        'Filter settings...' => 'Ustawienia filtru...',
        'Filter for settings' => 'Filtr dla ustawień',
        'Save all settings' => 'Zapisz wszystkie ustawienia',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Wyłączone',
        'End' => 'Koniec',
        'This setting can currently not be saved.' => 'To ustawienie nie może być teraz zapisane',
        'This setting can currently not be saved' => 'To ustawienie nie może być teraz zapisane',
        'Save this setting' => 'Zapisz ustawienie',
        'Did you know? You can help translating OTOBO at %s.' => 'Czy wiesz, że możesz pomóc w tłumaczeniu OTOBO na %s',

        # Template: SettingsList
        'Reset to default' => 'Przywróć do domyślnych',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => 'Cel',
        'Process' => 'Proces',
        'Split' => 'Podziel',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => 'Dodaj Statystyki',
        'Read more about statistics in OTOBO' => '',
        'Dynamic Matrix' => 'Macierz dynamiczna',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Lista dynamiczna',
        'Each row contains data of one entity.' => '',
        'Static' => 'statyczny',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => 'Utwórz statystykę',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Uruchom teraz',
        'Statistics Preview' => 'Podgląd statystyk',
        'Save Statistic' => 'Zapisz Statystyki',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statystyki',
        'Run' => 'Uruchom',
        'Edit statistic "%s".' => 'Edytuj statystykę "%s".',
        'Export statistic "%s"' => 'Eksportuj statystykę "%s"',
        'Export statistic %s' => 'Eksportuj statystykę %s',
        'Delete statistic "%s"' => 'Usuń statystykę "%s"',
        'Delete statistic %s' => 'Usuń statystykę %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Przegląd statystyk',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Utworzone przez',
        'Changed by' => 'Zmienione przez',
        'Sum rows' => 'Suma wierszy',
        'Sum columns' => 'Suma kolumn',
        'Show as dashboard widget' => 'Pokaż jako widget pulpitu',
        'Cache' => 'Pamięć podręczna',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => 'Zmień właściciela dla %s%s%s',
        'Close %s%s%s' => 'Zamknij %s%s%s',
        'Add Note to %s%s%s' => 'Dodaj notatkę do %s%s%s',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => 'Zmień priorytet dla %s%s%s',
        'Change Responsible of %s%s%s' => 'Zmień odpowiedzialnego dla %s%s%s',
        'The ticket has been locked' => 'Zgłoszenie zostało zablokowane',
        'Undo & close' => 'Cofnij i zamknij',
        'Ticket Settings' => 'Ustawienia zgłoszenia',
        'Queue invalid.' => 'Nie prawidłowa kolejka.',
        'Service invalid.' => 'Nieprawidłowa usługa.',
        'SLA invalid.' => 'Nie prawidłowe SLA',
        'New Owner' => 'Nowy właściciel',
        'Please set a new owner!' => 'Prosimy ustaw nowego właściciela!',
        'Owner invalid.' => 'Nie prawidłowy właściciel.',
        'New Responsible' => 'Nowy odpowiedzialny',
        'Please set a new responsible!' => 'Ustaw nowego odpowiedzialnego!',
        'Responsible invalid.' => 'Nie prawidłowy odpowiedzialny.',
        'Next state' => 'Następny stan',
        'State invalid.' => 'Stan jest nie prawidłowy.',
        'For all pending* states.' => 'Dla wszystkich stanów "oczekujacych".',
        'Add Article' => 'Dodaj wiadomość',
        'Create an Article' => 'Utwórz wiadomość',
        'Inform agents' => 'Poinformuj agentów',
        'Inform involved agents' => 'Poinformuj zaangażowanych agentów',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Tutaj można wybrać dodatkowych Agentów, którzy powinni otrzymać powiadomienie o nowej wiadomości.',
        'Text will also be received by' => 'Tekst zostanie również odebrany przez',
        'Text Template' => 'Tekst szablonu',
        'Setting a template will overwrite any text or attachment.' => 'Wybranie szablonu usunie całą treść i załączniki.',
        'Invalid time!' => 'Błędny czas!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Odbij %s%s%s',
        'Bounce to' => 'Przekaż do',
        'You need a email address.' => 'Potrzebujesz adresu e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Potrzebny poprawny adres e-mail lub nie używaj lokalnego adresu e-mail.',
        'Next ticket state' => 'Następny stan zgłoszenia',
        'Inform sender' => 'Powiadom nadawcę',
        'Send mail' => 'Wyślij wiadomość!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Akcja grupowa',
        'Send Email' => 'Wyślij e-mail',
        'Merge' => 'Scal',
        'Merge to' => 'Scal z',
        'Invalid ticket identifier!' => 'Niepoprawny identyfikator zgłoszenia!',
        'Merge to oldest' => 'Scal z najstarszym',
        'Link together' => 'Połącz razem',
        'Link to parent' => 'Połącz z rodzicem',
        'Unlock tickets' => 'Odblokuj zgłoszenia',
        'Execute Bulk Action' => 'Wykonaj działanie zbiorcze',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Utwórz Odpowiedź dla %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ten adres został zarejestrowany jako adres systemowy i nie może zostać użyty: %s',
        'Please include at least one recipient' => 'Wprowadź przynajmniej jednego odbiorcę',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Usuń klienta ze zgłoszenia',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Usuń ten wpis i wprowadź nowy z poprawną wartością.',
        'This address already exists on the address list.' => 'Ten adres juz istnieje na liście adresów.',
        'Remove Cc' => 'Usuń DW',
        'Bcc' => 'UDW',
        'Remove Bcc' => 'Usuń UDW',
        'Date Invalid!' => 'Niepoprawna data!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Zmień klienta dla %s%s%s',
        'Customer Information' => 'Informacje o kliencie',
        'Customer user' => 'Użytkownik klienta',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Utwórz nowe zgłoszenie e-mail',
        'Example Template' => 'Przykładowy szablon',
        'To customer user' => 'Do użytkownika klienta',
        'Please include at least one customer user for the ticket.' => 'Proszę dodaj przynajmniej jednego użytkownika do zgłoszenia.',
        'Select this customer as the main customer.' => 'Wybierz tego klienta jako podstawowego',
        'Remove Ticket Customer User' => 'Usuń zgłoszenie użytkownika klienta',
        'From queue' => 'Do kolejki',
        'Get all' => 'Pobierz wszystkich',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Zewnętrzny Email dla %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas reakcji (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Zgłoszenie %s: czas reakcji zostanie przekroczony za %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas aktualizacji (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Zgłoszenie %s: czas aktualizacji zostanie przekroczony za %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas rozwiązania (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Zgłoszenie %s: czas rozwiązania zostanie przekroczony za %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Prześlij %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Historia %s%s%s',
        'Filter for history items' => '',
        'Expand/collapse all' => 'Rozwiń/zwiń wszystko',
        'CreateTime' => 'Czas utworzenia',
        'Article' => 'Wiadomość',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Scal %s%s%s',
        'Merge Settings' => 'Ustawienia scalania',
        'You need to use a ticket number!' => 'Musisz użyć numeru zgłoszenia!',
        'A valid ticket number is required.' => 'Wymagany jest poprawny numer zgłoszenia.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => 'Powiadom nadawcę',
        'Need a valid email address.' => 'Potrzebny poprawny adres e-mail',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Przenieś %s%s%s',
        'New Queue' => 'Nowa kolejka',
        'Move' => 'Przenieś',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Nie odnaleziono danych zgłoszenia.',
        'Open / Close ticket action menu' => 'Menu akcji otwartych / zamkniętych zgłoszeń',
        'Select this ticket' => 'Zaznacz to zgłoszenie',
        'Sender' => 'Nadawca',
        'First Response Time' => 'Czas pozostały do pierwszej odpowiedzi',
        'Update Time' => 'Czas pozostały do aktualizacji',
        'Solution Time' => 'Czas pozostały do rozwiązania',
        'Move ticket to a different queue' => 'Przenieś zgłoszenie do innej kolejki',
        'Change queue' => 'Zmień kolejkę',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Usuń aktywne filtry z tego ekranu.',
        'Tickets per page' => 'Zgłoszeń na stronę',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Resetuj wygląd',
        'Column Filters Form' => 'Formularz filtrów kolumn',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Rozdziel jako nowe zgłoszenie telefoniczne',
        'Save Chat Into New Phone Ticket' => 'Zapisz czat jako nowe zgłoszenie telefoniczne',
        'Create New Phone Ticket' => 'Utwórz nowe zgłoszenie telefoniczne',
        'Please include at least one customer for the ticket.' => 'Wprowadź przynajmniej jednego klienta dla zgłoszenia.',
        'To queue' => 'Do kolejki',
        'Chat protocol' => 'Protokół czatu',
        'The chat will be appended as a separate article.' => 'Wiadomość czatu będzie dodana jako osobna wiadomość w zgłoszeniu.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefon do %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Zobacz teskt wiadomości email dla %s%s%s',
        'Plain' => 'Bez formatowania',
        'Download this email' => 'Pobierz ten e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Utwórz nowe zgłoszenie do procesu',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Zapisz zgłoszenie jako proces',

        # Template: AgentTicketSearch
        'Profile link' => 'Link do profilu',
        'Output' => 'Format wyjściowy',
        'Fulltext' => 'Pełnotekstowe',
        'Customer ID (complex search)' => 'ID Klienta (wyszukiwanie kompleksowe)',
        '(e. g. 234*)' => '(np. 234*)',
        'Customer ID (exact match)' => 'ID Klienta (dokładne dopasowanie)',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '(np. U51*)',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Utworzono w kolejce',
        'Lock state' => 'Stan blokady',
        'Watcher' => 'Obserwujący',
        'Article Create Time (before/after)' => 'Czas utworzenia wiadomości (przed/po)',
        'Article Create Time (between)' => 'Czas utworzenia wiadomości (pomiędzy)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Czas utworzenia zgłoszenia (przed/po)',
        'Ticket Create Time (between)' => 'Czas utworzenia zgłoszenia (pomiędzy)',
        'Ticket Change Time (before/after)' => 'Czas zmiany zgłoszenia (przed/po)',
        'Ticket Change Time (between)' => 'Czas zmiany zgłoszenia (pomiędzy)',
        'Ticket Last Change Time (before/after)' => 'Data modyfikacji zgłoszenia (przed/po)',
        'Ticket Last Change Time (between)' => 'Data modyfikacji zgłoszenia (pomiędzy)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Czas zamknięcia zgłoszenia (przed/po)',
        'Ticket Close Time (between)' => 'Czas zamknięcia zgłoszenia (pomiędzy)',
        'Ticket Escalation Time (before/after)' => 'Czas eskalacji zgłoszenia (przez/po)',
        'Ticket Escalation Time (between)' => 'Czas eskalacji zgłoszenia (pomiędzy)',
        'Archive Search' => 'Szukanie w archiwum',

        # Template: AgentTicketZoom
        'Sender Type' => 'Typ nadawcy',
        'Save filter settings as default' => 'Zapisz ustawienia filtru jako domyślne',
        'Event Type' => 'Typ zdarzenia',
        'Save as default' => 'Zapisz jako domyślny',
        'Drafts' => 'Szkice',
        'Change Queue' => 'Zmień kolejkę',
        'There are no dialogs available at this point in the process.' =>
            'W tym punkcie procesów brak jest jeszcze dialogów.',
        'This item has no articles yet.' => 'Ten element nie zawiera jeszcze żadnych wiadomości.',
        'Ticket Timeline View' => 'Podgląd linii czasu zgłoszenia',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => 'Strona %s',
        'Add Filter' => 'Dodaj filtr',
        'Set' => 'Ustaw',
        'Reset Filter' => 'resetuj filtr',
        'No.' => 'Lp.',
        'Unread articles' => 'Nieprzeczytane wiadomości',
        'Via' => 'Przez',
        'Important' => 'Ważne',
        'Unread Article!' => 'Nieprzeczytana wiadomość!',
        'Incoming message' => 'Wiadomość przychodząca',
        'Outgoing message' => 'Wiadomość wychodząca',
        'Internal message' => 'Wiadomość wewnętrzna',
        'Sending of this message has failed.' => '',
        'Resize' => 'Zmień rozmiar',
        'Mark this article as read' => 'Oznacz wiadomość jako przeczytaną',
        'Show Full Text' => 'Pokaż pełną treść',
        'Full Article Text' => 'Pełna treść wiadomości',
        'No more events found. Please try changing the filter settings.' =>
            'Nie znaleziono więcej zdarzeń. Proszę spróbuj zmienić ustawienia filtrów.',

        # Template: Chat
        '#%s' => '',
        'via %s' => 'przez %s',
        'by %s' => 'przez %s',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'W celu otwarcia linków zawartych w wiadomości może być konieczne naciśnięcie klawisza Ctrl, Cmd lub Shift w połączeniu z kliknięciem klawisza myszy (w zależności od używanej przeglądarki internetowej).',
        'Close this message' => 'Zamknij wiadomość',
        'Image' => 'Obraz',
        'PDF' => 'PDF',
        'Unknown' => 'Nieznany',
        'View' => 'Zobacz',

        # Template: LinkTable
        'Linked Objects' => 'Połączone elementy',

        # Template: TicketInformation
        'Archive' => 'Archiwum',
        'This ticket is archived.' => 'To zgłoszenie jest zarchiwizowane.',
        'Note: Type is invalid!' => 'Uwaga: Typ jest niepoprawny!',
        'Pending till' => 'Oczekuje do',
        'Locked' => 'Blokada',
        '%s Ticket(s)' => '%s Zgłoszenie(a)',
        'Accounted time' => 'Zaraportowany czas',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Aby chronić twoją prywatność, zdalna zawartość została zablokowana.',
        'Load blocked content.' => 'Załaduj zablokowaną treść.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Ta funkcja wymaga usług w chmurze',
        'You can' => 'Możesz',
        'go back to the previous page' => 'powrócić do poprzedniej strony',

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
        'New Ticket' => 'Nowe zgłoszenie',

        # Template: CustomerError
        'An Error Occurred' => 'Wystąpił błąd',
        'Error Details' => 'Szczegóły błędu',
        'Traceback' => 'Śledź wstecz',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nie jest dostęny',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Ostrzeżenie dotyczące przeglądarki',
        'The browser you are using is too old.' => 'Przeglądarka której używasz jest zbyt stara.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Zajrzyj do dokumentacji lub zapytaj o szczegóły swojego administratora.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => 'Poczekaj chwilę, trwa przekierowywanie...',
        'Login' => 'Login',
        'Your user name' => 'Twoja nazwa użytkownika',
        'User name' => 'Nazwa użytkownika',
        'Your password' => 'Twoje hasło',
        'Forgot password?' => 'Zapomniane hasło?',
        'Your 2 Factor Token' => 'Twój token weryfikacji dwuetapowej',
        '2 Factor Token' => 'Token weryfikacji dwuetapowej',
        'Log In' => 'Zaloguj się',
        'Request Account' => '',
        'Request New Password' => 'Prośba o nowe hasło',
        'Your User Name' => 'Nazwa użytkownika',
        'A new password will be sent to your email address.' => 'Nowe hasło będzie wysłane na twój adres e-mail',
        'Create Account' => 'Utwórz konto',
        'Please fill out this form to receive login credentials.' => 'Wypełnij ten formularz aby otrzymać dane logowania.',
        'How we should address you' => 'Jak powinniśmy cię tytułować',
        'Your First Name' => 'Twoje imię',
        'Your Last Name' => 'Twoje nazwisko',
        'Your email address (this will become your username)' => 'Twój adres e-mail (stanie się twoją nazwą użytkownika)',

        # Template: CustomerNavigationBar
        'Logout' => 'Wyloguj',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Witaj!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Strona',
        'Tickets' => 'Zgłoszenia',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'np. 10*5155 lub 105658*',
        'CustomerID' => 'Identyfikator klienta',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Typy zgłoszeń',
        'Time Restrictions' => '',
        'No time settings' => 'Brak ustawień czasowych',
        'All' => 'Wszystkie',
        'Specific date' => 'Konkretna data',
        'Only tickets created' => 'Tylko zgłoszenia utworzone',
        'Date range' => 'Zakres dat',
        'Only tickets created between' => 'Tylko zgłoszenia utworzone między',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Zapisać jako szablon?',
        'Save as Template' => 'Zapisz jako szablon',
        'Template Name' => 'Nazwa szablonu',
        'Pick a profile name' => 'Wybierz nazwę profilu',
        'Output to' => 'Wyniki prezentuj jako',

        # Template: CustomerTicketSearchResultShort
        'of' => 'z',
        'Search Results for' => 'Wyniki wyszukiwania dla',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Reply' => 'Odpowiedź',
        'Discard' => '',
        'Ticket Information' => 'Informacje o zgłoszeniu',
        'Categories' => '',

        # Template: Chat
        'Expand article' => 'Rozwiń wiadomość',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Ostrzeżenie',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Informacje o zdarzeniach',
        'Ticket fields' => 'Pola zgłoszenia',

        # Template: Error
        'Send a bugreport' => 'Wysłać raport na temat błędu',
        'Expand' => 'Rozwiń',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => 'Zaktualizuj szkic',
        'Save as new draft' => 'Zapisz jako nowy szkic',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Wczytałeś szkic "%s"',
        'You have loaded the draft "%s". You last changed it %s.' => 'Wczytałeś szkic "%s". Ostatnio zmieniałeś go %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Wczytałeś szkic "%s". Ostatnio zmieniony %s przez %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Zauważ, że szkic jest nieaktualny ponieważ zgłoszenie zostało zmienione od czasu utworzenia szkicu.',

        # Template: Header
        'Edit personal preferences' => 'Edytuj ustawienia osobiste',
        'Personal preferences' => 'Ustawienia osobiste',
        'You are logged in as' => 'Jesteś zalogowany jako',

        # Template: Installer
        'JavaScript not available' => 'JavaSript nie jest dostępny',
        'Step %s' => 'Krok %s',
        'License' => 'Licencja',
        'Database Settings' => 'Ustawienia bazy danych',
        'General Specifications and Mail Settings' => 'Ustawienia ogólne i poczty e-mail',
        'Finish' => 'Koniec',
        'Welcome to %s' => 'Witaj w %s',
        'Germany' => '',
        'Phone' => 'Tel.',
        'Switzerland' => '',
        'Web site' => 'Strona WWW',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Konfiguruj pocztę wychodzącą',
        'Outbound mail type' => 'Typ poczty wychodzącej',
        'Select outbound mail type.' => 'Wskaż typ poczty wychodzącej',
        'Outbound mail port' => 'Port poczty wychodzącej',
        'Select outbound mail port.' => 'Wybierz port poczty wychodzącej',
        'SMTP host' => 'Serwer SMTP',
        'SMTP host.' => 'Serwer SMTP.',
        'SMTP authentication' => 'Autentykacja SMTP',
        'Does your SMTP host need authentication?' => 'Czy twój serwer SMTP wymaga autentykacji?',
        'SMTP auth user' => 'Użytkownik do autentykacji SMTP',
        'Username for SMTP auth.' => 'Użytkownik do autentykacji SMTP.',
        'SMTP auth password' => 'Hasło do autentykacji SMTP',
        'Password for SMTP auth.' => 'Hasło do autentykacji SMTP.',
        'Configure Inbound Mail' => 'Konfiguruj pocztę przychodzącą',
        'Inbound mail type' => 'Typ poczty przychodzącej',
        'Select inbound mail type.' => 'Wskaż typ poczty przychodzącej',
        'Inbound mail host' => 'Serwer poczty przychodzącej',
        'Inbound mail host.' => 'Serwer poczty przychodzącej.',
        'Inbound mail user' => 'Użytkownik poczty przychodzącej',
        'User for inbound mail.' => 'Użytkownik poczty przychodzącej.',
        'Inbound mail password' => 'Hasło do poczty przychodzącej',
        'Password for inbound mail.' => 'Hasło do poczty przychodzącej.',
        'Result of mail configuration check' => 'Wynik sprawdzania konfiguracji poczty',
        'Check mail configuration' => 'Sprawdź konfigurację poczty',
        'Skip this step' => 'Pomiń ten krok',

        # Template: InstallerDBResult
        'Done' => 'Wykonane',
        'Error' => 'Błąd',
        'Database setup successful!' => 'Konfiguracja bazy danych powiodła się!',

        # Template: InstallerDBStart
        'Install Type' => 'Zainstaluj typ',
        'Create a new database for OTOBO' => 'Utwórz nową baze danych dla OTOBO',
        'Use an existing database for OTOBO' => 'Użyj istniejącej bazy danych dla OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Jeśli ustawiłeś hasło główne do bazy danych to wprowadź je w tym polu. Jeśli nie to pozostaw pole puste .',
        'Database name' => 'Nazwa bazy danych',
        'Check database settings' => 'Sprawdź ustawienia bazy danych',
        'Result of database check' => 'Wynik sprawdzenia bazy danych',
        'Database check successful.' => 'Sprawdzanie bazy zakończone pomyślnie.',
        'Database User' => 'Użytkownik bazy danych',
        'New' => 'Nowe',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Dla tego systemu OTOBO utworzony zostanie nowy użytkownik bazy danych z ograniczonymi uprawnieniami.',
        'Repeat Password' => 'Powtórz hasło',
        'Generated password' => 'Wygenerowane hasło',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Hasła nie zgadzają się',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Musisz wpisać następujące polecenie w linii komend (Terminal/Shell) jako root.',
        'Restart your webserver' => 'Uruchom ponownie serwer WWW',
        'After doing so your OTOBO is up and running.' => 'Po zakończeniu tych czynności Twój system OTOBO będzie gotowy do pracy.',
        'Start page' => 'Strona startowa',
        'Your OTOBO Team' => 'Twój Zespół OTOBO',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Nie akceptuję licencji',
        'Accept license and continue' => 'Zaakceptuj licencje i kontynuuj',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identyfikator systemu. Każde zgłoszenie i każde ID sesji HTTP zawiera ten numer',
        'System FQDN' => 'Pełna domena systemu (FQDN)',
        'Fully qualified domain name of your system.' => 'Pełna nazwa domenowa (FQDN) twojego systemu.',
        'AdminEmail' => 'E-mail administratora',
        'Email address of the system administrator.' => 'Adres e-mail administratora systemu',
        'Organization' => 'Organizacja',
        'Log' => 'Log',
        'LogModule' => 'Moduł logowania',
        'Log backend to use.' => 'Używany moduł logowania',
        'LogFile' => 'Plik log',
        'Webfrontend' => 'Interfejs webowy',
        'Default language' => 'Domyślny język',
        'Default language.' => 'Domyślny język.',
        'CheckMXRecord' => 'Sprawdź rekord MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Poprawność wprowadzanych ręcznie adresów e-mail jest sprawdzana z rekordami MX w bazie DNS. Nie używaj tej opcji jeśli twój DNS jest wolny lub nie rozwiązuje adresów publicznych.',

        # Template: LinkObject
        'Delete link' => 'Usuń połączenie',
        'Delete Link' => 'Usuń Połączenie',
        'Object#' => 'Obiekt#',
        'Add links' => 'Dodaj odnośniki',
        'Delete links' => 'Usuń odnośniki',

        # Template: Login
        'Lost your password?' => 'Zapomniałeś hasła?',
        'Back to login' => 'Powrót do logowania',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => 'Otwórz URL w nowej zakładce',
        'Close preview' => 'Zamknij podgląd',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

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
        'Feature not Available' => '',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Wiadomość dnia',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Niewystarczające uprawnienia',
        'Back to the previous page' => 'Powrót do poprzedniej strony',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Oparte na',

        # Template: Pagination
        'Show first page' => 'Pokaż pierwszą stronę',
        'Show previous pages' => 'Pokaż poprzednie strony',
        'Show page %s' => 'Pokaż stronę %s',
        'Show next pages' => 'Pokaż następne strony',
        'Show last page' => 'Pokaż ostatnią stronę',

        # Template: PictureUpload
        'Need FormID!' => 'Potrzebne ID formularza!',
        'No file found!' => 'Nie odnaleziono pliku!',
        'The file is not an image that can be shown inline!' => 'Plik nie jest obrazkiem, który może być pokazany w treści!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informacje procesowe',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Poinformuj agenta',

        # Template: PublicDefault
        'Welcome' => 'Witaj',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Uprawnienia',
        'You can select one or more groups to define access for different agents.' =>
            'Możesz wskazać jedną lub więcej grup aby zdefiniować dostęp dla różnych agentów.',
        'Result formats' => '',
        'Time Zone' => 'Strefa czasowa',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'Buforuj wyniki',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Udostępnij statystyki jako widget który agenci mogą aktywowac na swoim pulpicie.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Jeśli ustawiono wartość \'nieaktywne\' to użytkownicy nie będą mogli wygenerować tej statystyki.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => 'Skonfiguruj oś X',
        'X-axis' => 'Oś X',
        'Configure Y-Axis' => 'Skonfiguruj oś Y',
        'Y-axis' => 'oś Y',
        'Configure Filter' => 'Konfiguruj filtr',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Wybierz jeden element lub odznacz przycisk \'Stały\'.',
        'Absolute period' => 'Okres bezwzględny',
        'Between %s and %s' => 'Pomiędzy %s i %s',
        'Relative period' => 'Okres względny',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Zakończonych okresów %s oraz okres bieżący + przyszłe okresy %s%s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Zamień osie',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Nie wybrano elementu',
        'Scale' => 'Skala',
        'show more' => 'pokaż więcej',
        'show less' => 'pokaż mniej',

        # Template: D3
        'Download SVG' => 'Pobierz SVG',
        'Download PNG' => 'Pobierz PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'To ustawienie jest wyłączone.',
        'This setting is fixed but not deployed yet!' => 'To ustawienie jest przygotowane ale jeszcze nie wdrożone!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => 'Wyłącz',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => 'Włącz',
        'Reset this setting to its default state' => '',
        'Reset setting' => 'Przywróć ustawienie',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => 'Pozwól użytkownikom aktualizować',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => 'Zabroń użytkownikom aktualizować',
        'Show user specific changes for this setting' => '',
        'Show user settings' => 'Pokaż ustawienia użytkownika',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => 'Usuń z ulubionych',
        'Add this setting to your favorites' => 'Dodaj to ustawienie do swoich ulubionych',
        'Add to favourites' => 'Dodaj do ulubionych',
        'Cancel editing this setting' => 'Anuluj zmianę tego ustawienia',
        'Save changes on this setting' => 'Zapisz zmiany dla tego ustawienia',
        'Edit this setting' => 'Zmień to ustawienie',
        'Enable this setting' => 'Włącz to ustawienie',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => 'Teraz',
        'User modification' => 'Modyfikacje użytkownika',
        'enabled' => 'włączone',
        'disabled' => 'wyłączone',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => 'Wdrożenie',
        'My favourite settings' => 'Moje ulubione ustawienia',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtruj widoczne ustawienia...',
        'Enable edit mode for all settings' => 'Włącz tryb edycji dla wszystkich ustawień',
        'Save all edited settings' => 'Zapisz wszystkie edytowane ustawienia',
        'Cancel editing for all settings' => 'Anuluj edycję wszystkich ustawień',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Wszystkie akcje dostępne w tym widżecie stosuje się wyłącznie do ustawień widocznych po prawej stronie.',

        # Template: Help
        'Currently edited by me.' => 'Obecnie edytowane przeze mnie',
        'Modified but not yet deployed.' => 'Zmodyfikowane, ale jeszcze nie wdrożone.',
        'Currently edited by another user.' => 'Obecnie edytowane przez innego użytkownika',
        'Different from its default value.' => 'Wartość różna od wartości domyślnej.',
        'Save current setting.' => 'Zapisz bieżące ustawienie.',
        'Cancel editing current setting.' => 'Anuluj edycję bieżącego ustawienia.',

        # Template: Navigation
        'Navigation' => 'Nawigacja',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO Strona testowa',
        'Unlock' => 'Odblokuj',
        'Welcome %s %s' => 'Witaj %s %s',
        'Counter' => 'Licznik',

        # Template: Warning
        'Go back to the previous page' => 'Powrót do poprzedniej strony',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Pokaż',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Tytuł szkicu',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Potwierdź',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Kliknij aby wybrać pliki lub po prostu upuść je tutaj.',
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
        'Process state' => 'Stan procesu',
        'Running' => '',
        'Finished' => 'Zakończono',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Dodaj nową pozycję',

        # JS Template: AddHashKey
        'Add key' => 'Dodaj klucz',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Komentarz do wdrożenia...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => 'Wdrażanie, proszę czekać...',
        'Preparing to deploy, please wait...' => 'Przygotowanie do wdrożenia, proszę czekać...',
        'Deploy now' => 'Wdróż teraz',
        'Try again' => 'Spróbuj ponownie',

        # JS Template: DialogReset
        'Reset options' => 'Opcje Resetu',
        'Reset setting on global level.' => 'Resetuj ustawienia na poziomie globalnym',
        'Reset globally' => 'Resetuj globalnie',
        'Remove all user changes.' => 'Wycofaj wszystkie zmiany użytkownika',
        'Reset locally' => 'Resetuj lokalnie',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'Identyfikatory klientów',
        'Fax' => 'Faks',
        'Street' => 'Ulica',
        'Zip' => 'Kod pocztowy',
        'City' => 'Miejscowość',
        'Country' => 'Kraj',
        'Mr.' => 'Pan',
        'Mrs.' => 'Pani',
        'Address' => 'Adres',
        'View system log messages.' => 'Podgląd dziennika zdarzeń systemowych',
        'Edit the system configuration settings.' => 'Edytuj ustawienia konfiguracji systemu.',
        'Update and extend your system with software packages.' => 'Zaktualizuj i rozbuduj swój system przy pomocy pakietów oprogramowania.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Dane dostępu ACL z bazy danych nie są zsynchronizowane z konfiguraacją systemu, proszę wprowadź wszystkie ACLe.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACL nie została zaimportowania z powodu nieznanego błędu, więcej informacji znajdziesz w logach OTOBO',
        'The following ACLs have been added successfully: %s' => 'Dodanie następujących ACLi powiodło się: %s',
        'The following ACLs have been updated successfully: %s' => 'Aktualizacja następujących ACLi powiodła się: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Podczas dodawania/aktualizacji następujących ACLi wystąpiły błędy: %s. Więcej informacji znajdziesz w pliku logu.',
        'There was an error creating the ACL' => 'Podczas tworzenia ACLa wystąpił błąd.',
        'Need ACLID!' => 'Potrzebny ACLID!',
        'Could not get data for ACLID %s' => 'Nieudane pobranie danych dla ACLID %s',
        'There was an error updating the ACL' => 'Podczas aktualizacji ACL wystąpił błąd.',
        'There was an error setting the entity sync status.' => 'Podczas ustawiania statusu synchronizacji encji wystąpił błąd.',
        'There was an error synchronizing the ACLs.' => 'Wystąpił błąd podczas synchronizacji ACLi.',
        'ACL %s could not be deleted' => 'ACL %s nie mógł zostać usunięty',
        'There was an error getting data for ACL with ID %s' => 'Nastąpił błąd przy pobieraniu danych dla ACL o ID %s',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Dokładne dopasowanie',
        'Negated exact match' => 'Zanegowane dokładne dopasowanie',
        'Regular expression' => 'Wyrażenie regularne',
        'Regular expression (ignore case)' => 'Wyrażenie regularne (ignoruj wielkość liter)',
        'Negated regular expression' => 'Zanegowane wyrażenie regularne',
        'Negated regular expression (ignore case)' => 'Zanegowane wyrażenie regularne (ignoruj wielkość liter)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'System nie był w stanie stworzyć Kalendarza.',
        'Please contact the administrator.' => 'Proszę skontaktuj się z administratorem',
        'No CalendarID!' => 'Brak CalendarID!',
        'You have no access to this calendar!' => 'Nie masz dostępu do tego kalendarza!',
        'Error updating the calendar!' => 'Błąd aktualizacji kalendarza!',
        'Couldn\'t read calendar configuration file.' => 'Nie można odczytać pliku konfiguracyjnego kalendarza.',
        'Please make sure your file is valid.' => 'Proszę upewnić się, że plik jest właściwy.',
        'Could not import the calendar!' => 'Nie można zaimportować kalendarza!',
        'Calendar imported!' => 'Kalendarz Zaimportowany!',
        'Need CalendarID!' => 'Potrzebne CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Nie można odczytać informacji dla podanego CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Poprawnie zaimportowano %s wydarzeń do kalendarza %s.',
        '+5 minutes' => '+5 minut',
        '+15 minutes' => '+15 minut',
        '+30 minutes' => '+30 minut',
        '+1 hour' => '+1 godzina',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Brak uprawnień',
        'System was unable to import file!' => 'System nie był w stanie zaimportować pliku!',
        'Please check the log for more information.' => 'Proszę sprawdzić logi dla dokładniejszych informacji.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Powiadomienie o tej samej nazwie już istnieje!',
        'Notification added!' => 'Powiadomienie dostało dodane!',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => 'Nieznane Powiadomienie %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Wystąpił błąd podczas tworzenia powiadomienia',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => 'Powiadomienie zostało zaktualizowane!',
        'Agent (resources), who are selected within the appointment' => 'Agenci (zasoby), wybrani w ramach wydarzenia',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Wszyscy agenci posiadający (przynajmniej) prawo odczytu zdarzenia (kalendarza)',
        'All agents with write permission for the appointment (calendar)' =>
            'Wszyscy agenci z prawem zapisu wydarzenia (kalendarza)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Załącznik dodany!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Automatyczna odpowiedź została dodana!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => 'Cała komunikacja',
        'Last 1 hour' => 'Ostatnia godzina',
        'Last 3 hours' => 'Ostatnie 3 godziny',
        'Last 6 hours' => 'Ostatnie 6 godzin',
        'Last 12 hours' => 'Ostatnie 12 godzin',
        'Last 24 hours' => 'Ostatnie 24 godziny',
        'Last week' => 'Ostatni tydzień',
        'Last month' => 'Ostatni miesiąc',
        'Invalid StartTime: %s!' => 'Niepoprawny StartTime: 1%s!',
        'Successful' => 'Sukces',
        'Processing' => 'Przetwarzanie',
        'Failed' => 'Niepowodzenie',
        'Invalid Filter: %s!' => '',
        'Less than a second' => 'Mniej niż sekunda',
        'sorted descending' => 'posortowane malejąco',
        'sorted ascending' => 'posortowane rosnąco',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Info',
        'Warn' => '',
        'days' => 'dni',
        'day' => 'dzień',
        'hour' => 'godzina',
        'minute' => 'minuta',
        'seconds' => 'sekund',
        'second' => 'drugi',

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
        'Customer company updated!' => 'Firma zaktualizowana!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Firma klienta %s już istnieje!',
        'Customer company added!' => 'Firma dodana!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Klient zaktualizowany!',
        'New phone ticket' => 'Nowe zgłoszenie telefoniczne',
        'New email ticket' => 'Nowe zgłoszenie e-mail',
        'Customer %s added' => 'Klient %s został dodany',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Przypisz Użytkowników Klienta do Usług',
        'Allocate Services to Customer User' => 'Przypisz Usługi do Użytkownika Klienta',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Konfiguracja pól jest niepoprawna',
        'Objects configuration is not valid' => 'Konfiguracja obiektów jest niepoprawna',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Nie udało się prawidłowo przywrócić kolejności Pól Dynamicznych, więcej szczegółów znajduje się w pliku logu.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Nieokreślone działanie podrzędne.',
        'Need %s' => 'Wymagany %s',
        'Add %s field' => 'Dodaj 1%s pole',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => 'Wymagane poprawne ID',
        'Could not create the new field' => 'Nie udało się utworzyć nowego pola',
        'Need ID' => 'Wymagane ID',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => 'Zmień 1%s pole',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => 'Aktualnie',
        'Unchecked' => 'Niezaznaczone',
        'Checked' => 'Zaznaczone',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Nie pozwalaj na wprowadzanie dat w przyszłości',
        'Prevent entry of dates in the past' => 'Nie pozwalaj na wprowadzanie dat w przeszłości',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to reset the setting!' => '',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Wybierz przynajmniej jednego odbiorcę.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minut(-a/-y)',
        'hour(s)' => 'godz.',
        'Time unit' => 'Jednostka czasu',
        'within the last ...' => 'w ciągu ostatniego(-ch) ...',
        'within the next ...' => 'w ciągu następnego(-ych) ...',
        'more than ... ago' => 'wcześniej niż ...',
        'Unarchived tickets' => 'Zgłoszenia nie zachiwizowane',
        'archive tickets' => 'archiwizuj zgłoszenia',
        'restore tickets from archive' => 'przywróć zgłoszenia z archiwum',
        'Need Profile!' => 'Potrzebny Profil!',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Wymagane ID webserwisu',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'rosnąco',
        'descending' => 'malejąco',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
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
        'skip all modules' => '',
        'Operation deleted' => 'Operacja usunięta',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 sekund',
        '15 seconds' => '15 sekund',
        '30 seconds' => '30 sekund',
        '45 seconds' => '45 sekund',
        '1 minute' => '1 minuta',
        '2 minutes' => '2 minuty',
        '3 minutes' => '3 minuty',
        '4 minutes' => '4 minuty',
        '5 minutes' => '5 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
        '30 minutes' => '30 minut',
        '1 hour' => '1 godzina',
        '2 hours' => '2 godziny',
        '3 hours' => '3 godziny',
        '4 hours' => '4 godziny',
        '5 hours' => '5 godzin',
        '6 hours' => '6 godzin',
        '12 hours' => '12 godzin',
        '18 hours' => '18 godzin',
        '1 day' => '1 dzień',
        '2 days' => '2 dni',
        '3 days' => '3 dni',
        '4 days' => '4 dni',
        '6 days' => '6 dni',
        '1 week' => '1 tydzień',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'Ciąg',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
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
        'Could not determine config for operation %s' => '',
        'OperationType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => '',
        'Need Name!' => 'Wymagana nazwa!',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => 'Wymagany plik do zaimportowania!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTOBO as provider' => 'OTOBO jako usługodawca',
        'Operations' => 'Operacje',
        'OTOBO as requester' => 'OTOBO jako wnioskujący',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Grupa zaktualizowana!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Konto pocztowe dodane!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Przydzielaj na podstawie pola DO:',
        'Dispatching by selected Queue.' => 'Przydzielaj na podstawie wybranej kolejki.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Agent który utworzył zgłoszenie',
        'Agent who owns the ticket' => 'Agent który jest właścicielem zgłoszenia',
        'Agent who is responsible for the ticket' => 'Agent który jest odpowiedzialny za zgłoszenie',
        'All agents watching the ticket' => 'Wszyscy Agenci którzy obserwują zgłoszenie',
        'All agents with write permission for the ticket' => 'Wszyscy agenci z prawami do zapisu w zgłoszeniu',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer user of the ticket' => 'Użytkownik klienta w tym zgłoszeniu',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => 'Klucz %s usunięty!',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => 'Nie można odczytać %s!',
        'File is OK' => 'Plik jest OK',
        'Package has locally modified files.' => '',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'Pakiet nie został zweryfikowany przez Grupę OTRS! Zalecamy nie korzystanie z tego pakietu.',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => 'Zainstalowane',
        'Not correctly deployed' => 'Niepoprawnie wdrożone',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => 'Nie znaleziono w repozytoriach on-line',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => 'Lista Repezytoriów',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '',
        'Can\'t get OTOBO Feature Add-on list from server!' => '',
        'Can\'t get OTOBO Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Dodano priorytet!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Informacje zarządzania procesami z bazy danych nie są zsynchronizowane z konfiguracją systemu, zsynchronizuj wszystkie procesy.',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => 'Potrzebny ProcessID!',
        'Yes (mandatory)' => 'Tak (obowiązkowo)',
        'Unknown Process %s!' => 'Nieznany Proces %s!',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => 'Nie istnieje identyfikator stanu "nieaktywny"',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => 'Proces: %s nie może być usunięty',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '%s:%s jest cały czas w użyciu',
        'The %s:%s has a different EntityID' => '%s:%s mają inne EtnityID',
        'Could not delete %s:%s' => 'Nie można usunąć %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => 'Nie można pobrać %s',
        'Need %s!' => 'Potrzebny %s!',
        'Process: %s is not Inactive' => 'Proces: %s jest nie aktywny',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => 'Potrzebny ActivityID!',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => 'Działanie podrzędne jest nieprawidłowe',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => 'Interfejs Agenta',
        'Customer Interface' => 'Interfejs klienta',
        'Agent and Customer Interface' => 'Interfejs Klienta i Agenta',
        'Do not show Field' => 'Nie pokazuj pola',
        'Show Field' => 'Pokaż pole.',
        'Show Field As Mandatory' => 'Pokaż pole jako wymagane',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Zmień Ścieżkę',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Kolejka zaktualizowana!',
        'Don\'t use :: in queue name!' => 'Nie używaj :: w nazwie kolejki!',
        'Click back and change it!' => 'Naciśnij powrót i zmień to!',
        '-none-' => '-brak-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Kolejki (bez automatycznych odpowiedzi)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Zmień relacje kolejki dla szablonu',
        'Change Template Relations for Queue' => 'Zmień relacje szablonu dla kolejki',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produkcja',
        'Test' => '',
        'Training' => 'Trening',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rola zaktualizowana!',
        'Role added!' => 'Rola dodana!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Zmień relacje grup do roli',
        'Change Role Relations for Group' => 'Zmień relacje ról do grupy',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rola',
        'Change Role Relations for Agent' => 'Zmień relacje ról do agenta',
        'Change Agent Relations for Role' => 'Zmień relacje agentów do roli',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Najpierw aktywuj %s',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => 'Relacja istnieje!',
        'Relation added!' => 'Relacja dodana!',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => 'Relacja nie istnieje',
        'Relation deleted!' => 'Relacja usunięta!',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Powitanie dodane!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Zaktualizowano podpis!',
        'Signature added!' => 'Dodano podpis!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Stan dodany!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Plik %s nie mógł zostać odczytany!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Systemowy adres e-mail dodany!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Import niedozwolony!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'System was not able to lock the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

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
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Sesja została zabita!',
        'All sessions have been killed, except for your own.' => 'Zakończono wszystkie aktywne sesje za wyjątkiem bieżącej.',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Szablon zmieniony!',
        'Template added!' => 'Szablon dodany!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Zmień relacje załącznika dla szablonu',
        'Change Template Relations for Attachment' => 'Zmień relacje szablonu dla załącznika',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Potrzebny Typ!',
        'Type added!' => 'Typ dodany!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agent został zaktualizowany!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Zmień relacje grup do agenta',
        'Change Agent Relations for Group' => 'Zmień relacje agentów do grupy',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Miesiąc',
        'Week' => 'Tydzień',
        'Day' => 'Dzień',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Wszystkie wydarzenia',
        'Appointments assigned to me' => 'Wydarzenia przypisane do mnie',
        'Showing only appointments assigned to you! Change settings' => 'Wyświetlanie wydarzeń przypisanych do Ciebie! Zmień ustawienia',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Wydarzenie nie odnalezione!',
        'Never' => 'Nigdy',
        'Every Day' => 'Codziennie',
        'Every Week' => 'Co tydzeń',
        'Every Month' => 'Co miesiąc',
        'Every Year' => 'Co rok',
        'Custom' => 'Własne',
        'Daily' => 'Dziennie',
        'Weekly' => 'Tygodniowo',
        'Monthly' => 'Miesięcznie',
        'Yearly' => 'Rocznie',
        'every' => 'każde',
        'for %s time(s)' => '',
        'until ...' => 'dopóki ...',
        'for ... time(s)' => '',
        'until %s' => 'aż do %s',
        'No notification' => 'Brak powiadomień',
        '%s minute(s) before' => '%s minut(y) przed',
        '%s hour(s) before' => '%s godzin(y) przed',
        '%s day(s) before' => '%s dni(dzień) przed',
        '%s week before' => '%s tygodnie przed',
        'before the appointment starts' => 'zanim wydarzenie rozpocznie się',
        'after the appointment has been started' => 'po rozpoczęciu wydarzeniu',
        'before the appointment ends' => 'przed zakończeniem wydarzenia',
        'after the appointment has been ended' => 'po zakończeniu wydarzenia',
        'No permission!' => 'Brak uprawnień!',
        'Cannot delete ticket appointment!' => 'Nie można usunąć wydarzenia dla zgłoszenia!',
        'No permissions!' => 'Brak uprawnień!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+ %s więcej',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Historia Klienta',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => 'Statystyka',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => 'Nazwa klienta',
        'Customer User Name' => 'Nazwa użytkownika klienta',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => 'Potrzebujesz uprawnień do odczytu!',
        'Can not delete link with %s!' => 'Nie można usunąć połączenia z %s!',
        '%s Link(s) deleted successfully.' => '%s Połączenie (a) usunięte pomyślnie.',
        'Can not create link with %s! Object already linked as %s.' => 'Nie można utworzyć łączenia z %s! Już połączono jako %s.',
        'Can not create link with %s!' => 'Nie można stworzyć połączenia z %s!',
        '%s links added successfully.' => '%s połączenie dodane pomyślnie.',
        'The object %s cannot link with other object!' => 'Obiekt %s nie może być połączony z innym obiektem!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'This feature is not available.' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => 'System nie mógł wdrożyć twoich zmian.',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Zgłoszenie procesowe',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Brak parametru %s',
        'Invalid Subaction.' => 'Nieprawidłowe działanie podrzędne.',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => 'Dodaj nowe statystyki',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => 'Potrzebujesz uprawnień do %s !',
        'Loading draft failed!' => 'Nieudane wczytanie szkicu!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Przykro mi, musisz być właścicielem zgłoszenia aby wykonać tę operację.',
        'Please change the owner first.' => 'Najpierw zmień właściciela.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => 'Nazwa szkicu jest wymagana!',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Brak tematu',
        'Could not delete draft!' => 'Nie można usunąć szkicu!',
        'Previous Owner' => 'Poprzedni właściciel',
        'wrote' => 'napisał(a)',
        'Message from' => 'Wiadomość od',
        'End message' => 'Wiadomość kończąca',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s jest potrzebny!',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => 'Nie można odbić email\'a!',
        'Can\'t send email!' => 'Nie można wysłać email\'a!',
        'Wrong Subaction!' => 'Złe działanie podrzędne!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Nie można zablokować zgłoszeń, nie podano TicketID.',
        'Ticket (%s) is not unlocked!' => 'Zgłoszenie (%s) nie jest odblokowane!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => 'Musisz zaznaczyć przynajmniej jedno zgłoszenie.',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Następujące zgłoszenia zostały zignorowane ponieważ albo są zablokowane przez innego agenta, albo nie masz praw zapisu do tych zgłoszeń: %s.',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Adres %s zastąpiony zarejestrowanym adresem klienta.',
        'Customer user automatically added in Cc.' => 'Użytkownik automatycznie dodany jako DW (Cc).',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Zgłoszenie "%s" utworzone!',
        'No Subaction!' => 'Brak działania podrzędnego!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => 'Błąd systemu!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Następny tydzień',
        'Ticket Escalation View' => 'Widok eskalowanych zgłoszeń',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Wiadomość przekazana od',
        'End forwarded message' => 'Wiadomość kończąca przekazana od',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => 'Przykro mi, aktualnym właścicielem jest %s!',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => 'Zmień właściciela!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nowa wiadomość',
        'Pending' => 'Oczekujące',
        'Reminder Reached' => 'Przypomnienie',
        'My Locked Tickets' => 'Moje zablokowane zgłoszenia',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Wymaga uprawnień do przenoszenia!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Czat jest nieaktywny.',
        'No permission.' => 'Brak uprawnień!',
        '%s has left the chat.' => '%s opuścił czat.',
        'This chat has been closed and will be removed in %s hours.' => 'Ten czat został zamknięty i będzie usunięty w ciągu %sgodzin.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Zgłoszenie zablokowane.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => 'Żaden proces nie został jeszcze skonfigurowany!',
        'The selected process is invalid!' => 'Wybrany proces jest nieprawidłowy!',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => 'Działanie podrzędne jest nieprawidłowe!',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'Termin oczekiwania',
        'for pending* states' => 'dla stanów oczekujących*',
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
        'Available tickets' => 'Dostępne zgłoszenia',
        'including subqueues' => 'włączając podkolejki',
        'excluding subqueues' => 'wyłączając podkolejki',
        'QueueView' => 'Widok kolejek',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Zgłoszenia, za które jestem odpowiedzialny',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'ostatnie wyszukiwanie',
        'Untitled' => 'Bez tytułu',
        'Ticket Number' => 'Numer zgłoszenia',
        'Ticket' => 'Zgłoszenie',
        'printed by' => 'Wydrukowane przez',
        'CustomerID (complex search)' => 'ID klienta (wyszukiwanie złożone)',
        'CustomerID (exact match)' => 'ID klienta (dokładne dopasowanie)',
        'Invalid Users' => 'Nieprawidłowi użytkownicy',
        'Normal' => 'Normalne',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => 'później niż ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Przegląd usług',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Podgląd stanów',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Moje obserwowane zgłoszenia',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => 'Zagłoszenie zablokowane',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => 'Pole Dynamiczne Zaktualizowane',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Zgłoszenie Utworzone',
        'Type Updated' => '',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Klient zaktualizowany',
        'Internal Chat' => 'Czat wewnętrzny',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => 'Uwaga Dodana',
        'Note Added (Customer)' => 'Notatka doana (klient)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'Stan Zaktualizowany',
        'Outgoing Answer' => 'Odpowiedź Wychodząca',
        'Service Updated' => 'Usługa Zaktualizowana',
        'Link Added' => '',
        'Incoming Customer Email' => ' Wiadomość od klienta',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => 'Wiadomość Wychodząca',
        'Title Updated' => 'Tytuł został zaktualizowany',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => 'Telefon Wychodzący',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Telefon Przychodzący',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'SLA Zaktualizowane',
        'External Chat' => 'Czat zewnętrzny',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Prześlij wiadomość dalej przez e-mail',
        'Forward' => 'Prześlij dalej',
        'Fields with no group' => '',
        'Invisible only' => 'Tylko niewidoczne',
        'Visible only' => 'Tylko widoczne',
        'Visible and invisible' => 'Widoczne i niewidoczne',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Wiadomość nie może być otwarta! Być może znajduje się na innej stronie wiadomości.',
        'Show one article' => 'Pokaż tylko jedną wiadomość',
        'Show all articles' => 'Pokaż wszystkie wiadomości',
        'Show Ticket Timeline View' => 'Pokaż podgląd linii czasu zgłoszenia',

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
        'Need CustomerID!' => 'Potrzebne ID Klienta!',
        'My Tickets' => 'Moje zgłoszenia',
        'Company Tickets' => 'Zgłoszenia firmy',
        'Untitled!' => 'Bez tytułu!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Prawdziwe nazwisko klienta',
        'Created within the last' => 'Utworzone w ciągu ostatniego(-ich)',
        'Created more than ... ago' => 'Utworzone wcześniej niż ...',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => 'Utwórz nowe zgłoszenie!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => 'Katalog "%s" nie został znaleziony!',
        'Install OTOBO' => 'Zainstaluj OTOBO',
        'Intro' => 'Wprowadzenie',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm nie jest zapisywalny!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Jeśli chcesz użyć instalatora, ustaw Kernel/Config.pm jako zapisywalny dla użytkownika WebServer',
        'Database Selection' => 'Wybór bazy danych',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Wprowadź hasło użytkownika bazy danych.',
        'Database %s' => 'Baza danych %s',
        'Configure MySQL' => 'Skonfiguruj MySQL',
        'Enter the password for the administrative database user.' => 'Wprowadź hasło administratora bazy danych.',
        'Configure PostgreSQL' => 'Skonfiguruj PostgreSQL',
        'Configure Oracle' => 'Skonfiguruj Oracle',
        'Unknown database type "%s".' => 'Nieznany typ bazy danych "%s".',
        'Please go back.' => '',
        'Create Database' => 'Utwórz bazę danych',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => 'Skontaktuj się ze swoim Administratorem',
        'System Settings' => 'Konfiguracja Systemu',
        'Syslog' => '',
        'Configure Mail' => 'Skonfiguruj pocztę',
        'Mail Configuration' => 'Konfiguracja poczty',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => 'Nieznane działanie podrzędne: %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Baza danych zawiera już dane - powinna być pusta!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Brak %s!',
        'No such user!' => 'Nie ma takiego użytkownika!',
        'Invalid calendar!' => 'Niewłaściwy kalendarz!',
        'Invalid URL!' => 'Niewłaściwy URL!',
        'There was an error exporting the calendar!' => 'Błąd podczas eksportowania kalendarza!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Czat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Przekaż wiadomość na inny adres e-mail',
        'Bounce' => 'Przekaż',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Odpowiedz wszystkim',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Odpowiedź na notatkę',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Podziel wiadomość',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Bez formatowania',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Wydrukuj tą wiadomość',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Zaznacz',
        'Unmark' => 'Odznacz',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Zainstaluj ponownie pakiet',
        'Re-install' => 'Zainstaluj ponownie',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Zaszyfrowany',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Podpis',
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
        'Encrypt' => 'Zaszyfruj',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Zabezpieczenia e-mail',
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
        'Sign' => 'Podpis',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Pokazane',
        'Refresh (minutes)' => 'Odświeżaj (minuty)',
        'off' => 'wyłączone',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Widoczni użytkownicy klienta',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => 'Poza',
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
        'Shown Tickets' => 'Wyświetlane zgłoszenia',
        'Shown Columns' => 'Wyświetlane kolumny',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Zgłoszenie nie ma tytułu albo tematu',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Statystyka z 7 dni',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'godz.',
        'm' => 'min',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'To jest',
        'email' => 'e-mail',
        'click here' => 'kliknij tutaj',
        'to open it in a new window.' => 'aby otworzyć w nowym oknie',
        'Year' => 'Rok',
        'Hours' => 'Godziny',
        'Minutes' => 'Minut(-y)',
        'Check to activate this date' => 'Zaznacz aby aktywować tę datę',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Brak uprawnień!',
        'No Permission' => 'Brak uprawnień',
        'Show Tree Selection' => 'Pokaż wybór drzewa',
        'Split Quote' => 'Podziel cytując',
        'Remove Quote' => 'Usuń cytowanie',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Połączone jako',
        'Search Result' => 'Wynik wyszukiwania',
        'Linked' => 'Połączone',
        'Bulk' => 'Zbiorczo',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Lekkie',
        'Unread article(s) available' => 'Dostępne są nieprzeczytane wiadomości ',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Wydarzenie',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Szukanie w archiwum',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Zalogowany Agent: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Istnieje więcej eskalowanych zgłoszeń!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Zalogowany Klient: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Konserwacja systemu w toku!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'Demon OTOBO nie jest uruchomiony.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Usługa wiadomości o  nieobecności jest aktywna, czy chcesz ją wyłączyć?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Są opublikowane nieprawidłowe parametry: %s. Kliknij tutaj aby je wyświetlić.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Masz niewdrożone parametry, czy chcesz je wdrożyć?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Trwa aktualizacja konfiguracji. Proszę o cierpliwość...',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => 'Konfiguracja uaktualniona!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Powtórz hasło',
        'The current password is not correct. Please try again!' => 'Aktualne hasło jest niepoprawne. Spróbuj jeszcze raz!',
        'Please supply your new password!' => '',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Nie można zmienić hasła, musi się ono składać z co najmniej %s znaków!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Nie można zmienić hasła. Hasło musi zawierać co najmniej 1 cyfrę!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'nieaktualne',
        'valid' => 'aktualne',
        'No (not supported)' => 'Nie (nie obsługiwany)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'sekund(a)',
        'quarter(s)' => 'kwartał(y)',
        'half-year(s)' => 'półrocze(a)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => 'Nie można załadować %s!',
        'Content' => 'Zawartość',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Odblokuj aby przywrócić do kolejki',
        'Lock it to work on it' => 'Zablokuj by na tym pracować',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Nie obserwuj',
        'Remove from list of watched tickets' => 'Usuń z listy obserwowanych zgłoszeń',
        'Watch' => 'Obserwuj',
        'Add to list of watched tickets' => 'Dodaj do listy obserwowanych zgłoszeń',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sortuj według',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Zablokowane nowe zgłoszenia',
        'Locked Tickets Reminder Reached' => 'Zablokowane zgłoszenia z przekroczonym czasem przypomnienia',
        'Locked Tickets Total' => 'Zablokowane zgłoszenia razem',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Odpowiedzialność za nowe zgłoszenia',
        'Responsible Tickets Reminder Reached' => 'Odpowiedzialność za zgłoszenia z przekroczonym czasem przypomnienia',
        'Responsible Tickets Total' => 'Odpowiedzialność za zgłoszenia razem',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Obserwowane nowe zgłoszenia',
        'Watched Tickets Reminder Reached' => 'Obserwowane zgłoszenia z przekroczonym czasem przypomnienia',
        'Watched Tickets Total' => 'Obserwowane zgłoszenia razem',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Informacje dodatkowe',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'W tej chwili logowanie nie jest możliwe w związku z planowaną przerwą techniczną.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sesja nieważna. Zaloguj się ponownie.',
        'Session has timed out. Please log in again.' => 'Sesja wygasła. Zaloguj się ponownie',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Opcje konfiguracji',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
        'This setting is not visible.' => 'To ustawienie jest niewidoczne.',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'przed/po',
        'between' => 'pomiędzy',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'To pole jes twymagane lub',
        'The field content is too long!' => 'Zawartość pola jest zbyt długa!',
        'Maximum size is %s characters.' => 'Maksymalny rozmiar to %s znaków',

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

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOInvalidSettingsCheck.pm
        'Check for invalid configuration settings.' => '',
        'Invalid setting detected.' => '',
        'No invalid setting detected, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => '',
        'An error occured during SysConfig data migration or no configuration exists.' =>
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

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageMigration.pm
        'Check if %s!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => '',
        '%s script does not exist.' => '',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            '',
        'All required Perl modules have been installed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBORebuildConfig.pm
        'OTOBO config rebuild.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBORebuildConfigCleanup.pm
        'OTOBO Config cleanup.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'nie zainstalowane',
        'installed' => 'zainstalowany',
        'Unable to parse repository index document.' => 'Nie można sparsować indeksu rezpozytorium.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nie znaleziono pakietów dla Twojej wersji frameworka w tym repozytorium, zawiera ono tylko pakiety pasujące do innych wersji frameworka.',
        'File is not installed!' => 'Plik nie jest zainstalowany!',
        'File is different!' => 'Plik jest inny!',
        'Can\'t read file!' => 'Nie można czytać pliku!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Nieaktywny',
        'FadeAway' => 'Wygaszony',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Nie można połączyć się z serwerem rejestracji. Prosimy spróbuj ponownie później.',
        'No content received from registration server. Please try again later.' =>
            'Z serwera rejestracji nie otrzymano żadnych danych. Prosimy spróbuj ponownie później.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Użytkownik oraz hasło nie zgadzają się. Prosze spróbuj ponownie.',
        'Problems processing server result. Please try again later.' => 'Problem przy procesowaniu rezultatów. Prosimy spróbuj ponownie później.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Suma',
        'week' => 'tydzień',
        'quarter' => 'kwartał',
        'half-year' => 'półrocze',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Utworzony priorytet',
        'Created State' => 'Utworzony stan',
        'Create Time' => 'Czas utworzenia',
        'Pending until time' => '',
        'Close Time' => 'Data zamknięcia',
        'Escalation' => 'Eskalacja',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agent/Właściciel',
        'Created by Agent/Owner' => 'Utworzone przez Agenta/Właściciela',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Ocenione przez',
        'Ticket/Article Accounted Time' => 'Rozliczony czas zgłoszenia (wiadomości)',
        'Ticket Create Time' => 'Czas utworzenia zgłoszenia',
        'Ticket Close Time' => 'Czas zamknięcia zgłoszenia',
        'Accounted time by Agent' => 'Czas rozliczony przez Agenta',
        'Total Time' => 'Czas całkowity',
        'Ticket Average' => 'Średnia zgłoszenia',
        'Ticket Min Time' => 'Min. czas zgłoszenia',
        'Ticket Max Time' => 'Maks. czas zgłoszenia',
        'Number of Tickets' => 'Ilość zgłoszeń',
        'Article Average' => 'Średnia wiadomości',
        'Article Min Time' => 'Min. czas wiadomości',
        'Article Max Time' => 'Maks. czas wiadomości',
        'Number of Articles' => 'Ilość wiadomości',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Drukowane atrybuty',
        'Sort sequence' => 'Kolejność sortowania',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Liczba',
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
        'Days' => 'Dni',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Obecność tabeli',
        'Internal Error: Could not open file.' => 'Błąd wewnętrzny: Nie można otworzyć pliku.',
        'Table Check' => 'Sprawdzanie tabeli',
        'Internal Error: Could not read file.' => 'Błąd wewnętrzny: Nie można odczytać pliku.',
        'Tables found which are not present in the database.' => 'Zostały wykryte tabele których nie ma w bazie danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Rozmiar bazy danych',
        'Could not determine database size.' => 'Nie udało się określić rozmiaru bazy danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Wersja bazy danych',
        'Could not determine database version.' => 'Nie udało się określić wersji bazy danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Kodowanie znaków połączenia Klienta',
        'Setting character_set_client needs to be utf8.' => 'Character_set_client musi być ustawione na utf8.',
        'Server Database Charset' => 'Kodowanie znaków serwera bazy danych',
        'The setting character_set_database needs to be \'utf8\'.' => 'Wartość character_set_database musi być ustawiona na \'utf8\'.',
        'Table Charset' => 'Kodowanie znaków tabeli',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Rozmiar pliku dziennika InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Parametr "innodb_log_file_size" musi być ustawiony na co najmniej 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maksymalny rozmiar zapytania',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'Wartość \'max_allowed_packet\' powinna być większa niż 64MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Rozmiar pamięci podręcznej zapytania',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Parametr "query_cache_size" powinień być ustawiony (więcej niż 10 MB, ale nie więcej niż 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Domyślny magazyn danych',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Znaleziono tabele z ustawionym magazynem danych innym niż domyślny.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Wymagany jest MYSQL w wersji 5.x lub wyższej.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Ustawienie NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => 'Ustawienie NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT musi mieć postać "RRRR-MM-DD GG:MM:SS".',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Ustawienie SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Parametr "client_encoding" musi być ustawiony na UNICODE lub UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Parametr "server_encoding" musi być ustawiony na UNICODE lub UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Format daty',
        'Setting DateStyle needs to be ISO.' => 'Parametr "DateStyle" musi być zgodny z ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Partycja dysku OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Użycie dysku',
        'The partition where OTOBO is located is almost full.' => 'Partycja na której znajduje się OTOBO jest prawie pełna.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Na partycji na której znajduje się OTOBO zabrakło wolnego miejsca.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Użycie miejsca partycji',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Dystrybucja',
        'Could not determine distribution.' => 'Nie udało się określić dystrybucji.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Wersja jądra systemu',
        'Could not determine kernel version.' => 'Nie udało się określić wersji jądra systemu.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Obciążenie systemu',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Maksymalne obciążenie systemu powinno być równe ilości procesorów dostępnych w serwerze (np. obciążenie równe 8 lub mniej na 8 rdzeniowym serwerze jest prawidłowe).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Moduły Perl',
        'Not all required Perl modules are correctly installed.' => 'Nie wszystkie wymagane moduły Perl są poprawnie zainstalowane.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Dostępna przestrzeń stronicowania (%)',
        'No swap enabled.' => 'Nie włączona partycja SWAP.',
        'Used Swap Space (MB)' => 'Używana przestrzeń wymiany (MB)',
        'There should be more than 60% free swap space.' => ' Co najmniej 60% przestrzeni wymiany powinno być wolne.',
        'There should be no more than 200 MB swap space used.' => 'Co najmniej 200 MB przestrzeni wymiany powinno być używane.',

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
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Ustawienia konfiguracyjne',
        'Could not determine value.' => 'Nie można określić wartości.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Demon',
        'Daemon is running.' => 'Demon jest uruchomiony',
        'Daemon is not running.' => 'Demon nie jest uruchomiony',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Rekordy bazy danych',
        'Ticket History Entries' => 'Historia zgłoszeń',
        'Articles' => 'Wiadomości',
        'Attachments (DB, Without HTML)' => 'Załączniki (DB, bez HTML)',
        'Customers With At Least One Ticket' => 'Klienci którzy posiadają co najmniej jedno zgłoszenie',
        'Dynamic Field Values' => 'Wartości pól dynamicznych',
        'Invalid Dynamic Fields' => 'Nieprawidłowe pola dynamiczne',
        'Invalid Dynamic Field Values' => 'Nieprawidłowe wartości pól dynamicznych',
        'GenericInterface Webservices' => 'Ogólny interfejs usług sieciowych',
        'Process Tickets' => 'Zgłoszenia procesowe',
        'Months Between First And Last Ticket' => 'Ilość miesięcy pomiędzy pierwszym, a ostatnim zgłoszeniem',
        'Tickets Per Month (avg)' => 'Zgłoszeń w miesiącu (śred.)',
        'Open Tickets' => 'Otwarte zgłoszenia',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Zagrożenie bezpieczeństwa: używasz domyślnych ustawień SOAP::User i SOAP::Password. Należy je zmienić.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Domyślne hasło Admina',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Zagrożenie bezpieczeństwa: Konto agenta "root@localhost" nadal ma ustawione domyślne hasło. Należy je zmienić lub wyłączyć konto.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Kolejka Nadawcza Email',
        'Emails queued for sending' => 'Emaile w kolejce wysyłania',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nazwa domeny)',
        'Please configure your FQDN setting.' => 'Skonfiguruj proszę ustawienie twojej FQDN',
        'Domain Name' => 'Nazwa domeny',
        'Your FQDN setting is invalid.' => 'Kompletna nazwa hosta (FQDN) jest nieprawidłowa.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'System plików jest zapisywalny',
        'The file system on your OTOBO partition is not writable.' => 'System plików na partycji OTOBO nie ma praw do zapisu.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Stan instalacji pakietu',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Niektóre pakiety nie zostały poprawnie zainstalowane.',
        'Package Verification Status' => 'Stan Weryfikacji Pakietów',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Lista pakietów',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Wartość pola SystemID jest nieprawidłowa, powinno zawierać tylko cyfry.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Domyślny Typ Zgłoszenia',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Moduł indeksów zgłoszeń',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Masz ponad 60 000 zgłoszeń i powinieneś korzystać z modułu StaticDB. Zobacz podręcznik administratora (poprawa wydajności) w celu uzyskania dodatkowych informacji.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Nie należy utrzymywać  w systemie więcej niż 8 000 otwartych zgłoszeń.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Osierocone rekordy w tabeli ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => 'Osierocone rekordy w tabeli ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Ustawienia czasu',
        'Server time zone' => 'Ustawienia strefy czasowej serwera',
        'OTOBO time zone' => 'Strefa czasowa OTOBO',
        'OTOBO time zone is not set.' => 'Strefa czasowa OTOBO nie jest ustawiona.',
        'User default time zone' => 'Domyślna strefa czasowa użytkownika',
        'User default time zone is not set.' => 'Nie ustawiona domyślna strefa czasowa użytkownika.',
        'Calendar time zone is not set.' => 'Strefa czasowa kalendarza nie jest ustawiona.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Serwer www',
        'Loaded Apache Modules' => 'Załadowane moduły Apache',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Model MPM',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO wymaga uruchomienia serwera Apache wraz z modelem "prefork" MPM.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Wykorzystanie akceleratora CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Należy korzystać z FastCGI lub mod_perl w celu zwiększenia wydajności.',
        'mod_deflate Usage' => 'Wykorzystanie mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Należy zainstalować mod_deflate w celu poprawy wydajności GUI.',
        'mod_filter Usage' => 'Wykorzystanie mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Należy zainstalować mod_filter jeśli wykorzystywany jest mod_deflate.',
        'mod_headers Usage' => 'Wykorzystanie mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Należy zainstalować mod_headers w celu poprawy wydajności GUI.',
        'Apache::Reload Usage' => 'Wykorzystanie Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload lub Apache2::Reload powinno być używane jako moduł Perl oraz PerlInitHandler, aby uniknąć ponownego uruchomienia serwera WWW podczas instalacji i aktualizacji modułów.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Zmienne środowiskowe',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Wersja serwera WWW',
        'Could not determine webserver version.' => 'Nie udało się określić wersji serwera WWW.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Jednocześni Użytkownicy',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => 'Wartość ustawienia jest nieprawidłowa!',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => 'Ustawienia nie można odblokować!',
        'Missing key %s!' => 'Brakujący klucz %s!',
        'Invalid setting: %s' => 'Nieprawidłowe ustawienie: %s',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => 'Nie mogę zablokować wdrożenia dla UserID \'%s\'!',
        'All Settings' => 'Wszystkie Ustawienia',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Domyślne',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => 'Wartość nie pasuje do regex (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Włączony',
        'Disabled' => 'Wyłączony',

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
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Logowanie nieudane! Podano błędną nazwę użytkownika lub hasło.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Wylogowanie zakończone pomyślnie.',
        'Feature not active!' => 'Funkcja nieaktywna!',
        'Sent password reset instructions. Please check your email.' => 'Instrukcje dotyczące resetowania hasła zostały wysłane. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Invalid Token!' => 'Błędny token!',
        'Sent new password to %s. Please check your email.' => 'Nowe hasło wysłane na adres %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Error: invalid session.' => 'Błąd: nie prawidłowa sesja.',
        'No Permission to use this frontend module!' => 'Brak uprawnień do użycia tego modułu!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Wpisany adres e-mail już istnieje. Wystarczy się zalogować lub skorzystać z funkcji resetowania hasła.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Podany adres e-mail nie jest dopuszczony do rejestracji. Skontaktuj się z Obsługą Kienta.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => 'Nie mozna dodać użytkownika klienta!',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Utworzono nowe konto. Informacje dotyczące sposobu logowania zostały wysłane na adres %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'czasowo nieaktualne',
        'Group for default access.' => 'Grupa z podstawowymi prawami dostępu.',
        'Group of all administrators.' => 'Grupa wszystkich administratorów.',
        'Group for statistics access.' => 'Grupa z dostępem do statystyk.',
        'new' => 'nowe',
        'All new state types (default: viewable).' => '',
        'open' => 'otwarte',
        'All open state types (default: viewable).' => '',
        'closed' => 'zamknięte',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'oczekujące przypomnienie',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'oczekujące na automatyczne',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'usunięte',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'scalone',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => 'Nowe zgłoszenie stworzone przez klienta.',
        'closed successful' => 'zamknięte z powodzeniem',
        'Ticket is closed successful.' => 'Zgłoszenie zamknięte z powodzeniem.',
        'closed unsuccessful' => 'zamknięte bez powodzenia',
        'Ticket is closed unsuccessful.' => 'Zgłoszenie zamknięte bez powodzenia.',
        'Open tickets.' => 'Otwarte zgłoszenia.',
        'Customer removed ticket.' => 'Usunięte zgłoszenia klienta.',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'oczekujące na automatyczne zamknięcie+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'oczekujące na automatyczne zamknięcie-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => 'Standardowe powitanie.',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'możliwe',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'odrzuć',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => 'nowe zgłoszenie',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Kolejka poczty przychodzącej.',
        'All default incoming tickets.' => '',
        'All junk tickets.' => 'Wszystkie śmieciowe wiadomości.',
        'All misc tickets.' => 'Inne zgłoszenia.',
        'auto reply' => 'automatyczna odpowiedź',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'automatyczne odrzucenie',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'automatyczne śledzenie',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'automatyczna odpowiedź / nowe zgłoszenie',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'automatyczne usunięcie',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => 'automatyczna odpowiedź (jak już zostanie stworzone nowe zgłoszenie)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Niesklasyfikowane',
        '1 very low' => '1 bardzo niski',
        '2 low' => '2 niski',
        '3 normal' => '3 normalny',
        '4 high' => '4 wysoki',
        '5 very high' => '5 bardzo wysoki',
        'unlock' => 'odblokowane',
        'lock' => 'zablokowane',
        'tmp_lock' => '',
        'agent' => 'Agent',
        'system' => 'System',
        'customer' => 'klient',
        'Ticket create notification' => 'Powiadomienia o nowym zgłoszeniu',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Otrzymasz powiadomienie, za każdym razem, gdy zgłoszenie zostanie utworzone w jednej z „Twoich Kolejek” lub „Twoich Usług”. ',
        'Ticket follow-up notification (unlocked)' => 'Powiadomienia o nowej wiadomości w zgłoszeniu (odblokowane)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'Powiadomienia o nowej wiadomości w zgłoszeniu (zablokowane)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zgłoszenia',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'Powiadomienia o zmianie właściciela zgłoszenia',
        'Ticket responsible update notification' => 'Powiadomienia o zmianie odpowiedzialnego za zgłoszenie',
        'Ticket new note notification' => 'Powiadomienia o nowej notatce w zgłoszeniu',
        'Ticket queue update notification' => 'Powiadomienia o zmianie kolejki zgłoszenia',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Otrzymasz powiadomienie, za każdym razem, gdy zgłoszenie zostanie przesunięte do jednej z Twoich Kolejek.',
        'Ticket pending reminder notification (locked)' => 'Powiadomienia o oczekującym przypomnieniu w zgłoszeniu (zablokowane)',
        'Ticket pending reminder notification (unlocked)' => 'Powiadomienia o oczekującym przypomnieniu w zgłoszeniu (odblokowane)',
        'Ticket escalation notification' => 'Powiadomienie o eskalacji zgłoszenia',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => 'Powiadomienie o zmianie usługi zgłoszenia',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => 'Powiadomienie przypominające o wydarzeniu',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Otrzymasz powiadomienie za każdym razem gdy zostanie osiągnięty czas przypomnienia dla jednego z twoich wydarzeń.',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Dodaj wszystkie',
        'An item with this name is already present.' => 'Pozycja o tej nazwie już istnieje.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ta pozycja nadal zawiera podpozycje. Czy jesteś pewien, że chce usunąć ją wraz z nimi?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Więcej',
        'Less' => 'Mniej',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Usuń ten Załącznik',
        'Deleting attachment...' => 'Usuwanie załącznika...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => 'Załącznik został pomyślnie usunięty.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Czy na pewno chcesz usunąć to pole dynamiczne? Wszystkie związane dane będą USUNIĘTE!',
        'Delete field' => 'Usuń pole',
        'Deleting the field and its data. This may take a while...' => 'Trwa kasowanie pola i skojarzonych z nim danych. To może chwilę potrwać...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Usuń zaznaczenie',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Usuń ten trigger',
        'Duplicate event.' => 'Duplikuj zdarzenie',
        'This event is already attached to the job, Please use a different one.' =>
            'Jeśli zdarzenie jest już dodane do zadania wówczas prosze użyj innego.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'W trakcie komunikacji wystąpił błąd.',
        'Request Details' => 'Szczegóły żądania',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Pokaż lub ukryj zawartość.',
        'Clear debug log' => 'Wyczyść log debug',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Usuń ten invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Usuń to mapowanie klucza',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Usuń tę operację',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Klonuj serwis sieciowy',
        'Delete operation' => 'Usuń operację',
        'Delete invoker' => 'Usuń invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'Uwaga: Jeżeli zmienisz nazwę grupy \'admin\', przed wykonaniem właściwych zmian w SysConfig, zablokujesz panel administratorów! Jeżeli to nastąpi, przywróć nazwę grupy admin z użyciem SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Usuń to Konto Pocztowe',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Czy na pewno chcesz usunąć ten język powiadomienia?',
        'Do you really want to delete this notification?' => 'Czy na pewno chcesz usunąć to powiadomienie?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => 'Aktualizuj wszystkie pakiety',
        'Dismiss' => 'Zwolnij',
        'Update All Packages' => 'Aktualizuj wszystkie pakiety',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => 'Czy na pewno chcesz zaktualizować wszystkie zainstalowane pakiety?',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Usuń ten filtr pocztowy',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Usuwanie filtra pocztowego i jego danych. To może chwilę potrwać....',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Usuń Entity z obszaru projektu',
        'No TransitionActions assigned.' => 'Brak przypisanych akcji przejścia.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Brak jeszcze przypisanych okien. Wybierz okno działań z listy po lewej stronie i upuść je tutaj.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'To działanie nie może być usunięte ponieważ jest działaniem początkowym.',
        'Remove the Transition from this Process' => 'Usuń to przejście z tego procesu',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Gdy tylko użyjesz tego przycisku lub odnośnika, opuścisz ten ekran a jego obecny stan zostanie automatycznie zapisany. Czy chcesz kontynuować?',
        'Delete Entity' => 'Usuń Entity',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'To działanie jest już użyte w procesie. Nie możesz dodać go dwukrotnie!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Niepodłączone przejście jest już przygotowane. Proszę wpierw połącz to przejście przed umieszczeniem kolejnego.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'To przejście jest już użyte w tym działaniu. Nie możesz użyć go dwukrotnie!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ta akcja przejścia jest już użyta na tej ścieżce. Nie możesz użyć jej dwukrotnie!',
        'Hide EntityIDs' => 'Ukryj EntityID',
        'Edit Field Details' => 'Edytuj szczegóły pola',
        'Customer interface does not support articles not visible for customers.' =>
            'Interfejs klienta nie wspiera wyświetlania artykułów niewidocznych dla klienta',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Wysyłanie aktualizacji...',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => 'Wyślij wynik',
        'Generating...' => 'Generowanie...',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => 'Generuj wynik',
        'Support Bundle' => 'Pakiet serwisowy',
        'The mail could not be sent' => 'Wiadomość nie mogła być wysłana',

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
        'Loading...' => 'Ładowanie...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => 'Wdróż',
        'The deployment is already running.' => 'Wdrażanie jest już aktualnie uruchomione.',
        'Deployment successful. You\'re being redirected...' => 'Wdrożenie udane. Zostaniesz przekierowany...',
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
            'Czy jesteś pewien, że chcesz usunąć zaplanowaną konserwację systemu?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Przejdź',
        'Timeline Month' => 'Widok Miesięczny',
        'Timeline Week' => 'Widok Tygodniowy',
        'Timeline Day' => 'Widok Dzienny',
        'Previous' => 'Poprzednie',
        'Resources' => 'Zasoby',
        'Su' => 'Nd',
        'Mo' => 'Pn',
        'Tu' => 'Wt',
        'We' => 'Śr',
        'Th' => 'Cz',
        'Fr' => 'Pt',
        'Sa' => 'So',
        'This is a repeating appointment' => 'To powtarzające wydarzenie',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Czy chciałbyś edytować tylko to wystąpienie czy wszystkie?',
        'All occurrences' => 'Wszystkie wystąpienia',
        'Just this occurrence' => 'Tylko to wystąpienie',
        'Too many active calendars' => 'Zbyt dużo aktywnych kalendarzy',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Proszę wyłączyć kilka lub zwiększyć limit w konfiguracji.',
        'Restore default settings' => 'Przywróć ustawienia domyślne',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Czy jesteś pewien, że chcesz usunąć to wydarzenie? Tej operacji nie można cofnąć.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Zduplikowana pozycja',
        'It is going to be deleted from the field, please try again.' => 'To zostanie usunięte z pola, spróbuj ponownie.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Wprowadź przynajmniej jedną wyszukiwaną wartość lub * aby znaleźć cokolwiek.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informacje o OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Proszę sprawdź poprawnośc danych w polach oznaczonych jako czerowne.',
        'month' => 'miesiąc',
        'Remove active filters for this widget.' => 'Usuń aktywne filtry dla tego widgeta.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Proszę czekać...',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Czy na pewno chcesz usunąć to połączenie?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Czy używasz wtyczki typu AdBlock lub AdBlockPlus w swojej przeglądarce? To może powodować wiele problemów i dlatego gorąco zalecamy dodanie wyjątku we wtyczce dla tej domeny.',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Przełącz na pełną wersję strony',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Czy na pewno chcesz usunąć tą statystykę?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Czy jesteś pewien, że chcesz kontynuować?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...i %s więcej',
        ' ...show less' => '...pokaż mniej',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Dodaj nowy szkic',
        'Delete draft' => 'Usuń szkic',
        'There are no more drafts available.' => 'Nie ma więcej dostępnych szkiców.',
        'It was not possible to delete this draft.' => 'Usunięcie szkicu jest niemożliwe.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtr wiadomości',
        'Apply' => 'Zastosuj',
        'Event Type Filter' => 'Filtr typu zdarzenia',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Wysuń panel nawigacji',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Proszę wyłącz Widok Zgodności w Internet Explorerze!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Przełącz na wersję mobilną',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => 'Przeładuj stronę',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Wystąpił jeden lub więcej błędów!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Sprawdzanie poczty e-mail zakończone pomyślnie.',
        'Error in the mail settings. Please correct and try again.' => 'Błąd w ustawieniach poczty. Popraw i spróbuj ponownie.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Otwórz wybór daty',
        'Invalid date (need a future date)!' => 'Niepoprawna data (wymagana przyszła data)!',
        'Invalid date (need a past date)!' => 'Nieprawidłowa data (wymagana data przeszła)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Nie dostępne',
        'and %s more...' => 'oraz %s więcej...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Wyczyść',
        'Filters' => 'Filtry',
        'Clear search' => 'Wyczyść szukanie',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Jeśli opuścisz tę stronę, wszystkie okna popup będą również zamknięte!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Okno popup tej strony jest wciąż otwarte. Czy chcesz je zamknąć i załadować zamiast niego to okno?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nie można otworzyć okna popup. Usuń wszelkie blokady popup-ów dla tej aplikacji.',

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
        'There are currently no elements available to select from.' => 'Obecnie nie ma jeszcze elementów z których można by wybrać.',

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
        'yes' => 'tak',
        'no' => 'nie',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Pogrupowane',
        'Stacked' => 'Zestakowane',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Stream',
        'Expanded' => 'Rozszerzony',

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
