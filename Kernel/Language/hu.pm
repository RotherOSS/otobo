# --
# Copyright (C) 2006 Gabor Gancs /gg@magicnet.hu/
# Copyright (C) 2006 Krisztian Gancs /krisz@gancs.hu/
# Copyright (C) 2006 Flora Szabo /szaboflora@magicnet.hu/
# Copyright (C) 2007 Aron Ujvari <ujvari@hungary.com>
# Copyright (C) 2009 Arnold Matyasi <arn@webma.hu>
# Copyright (C) 2013 Csaba Németh <csaba@sopron.hu>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::hu;

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
    $Self->{DateFormatLong}      = '%Y. %B %D. %A %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';
    $Self->{Completeness}        = 0.935114503816794;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL kezelés',
        'Actions' => 'Műveletek',
        'Create New ACL' => 'Új ACL létrehozása',
        'Deploy ACLs' => 'ACL-ek üzembe állítása',
        'Export ACLs' => 'ACL-ek exportálása',
        'Filter for ACLs' => 'Szűrő az ACL-ekhez',
        'Just start typing to filter...' => 'Csak kezdjen el gépelni a szűréshez…',
        'Configuration Import' => 'Beállítás importálás',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Itt tud egy beállítófájlt feltölteni az ACL-ek importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy az ACL szerkesztőmodul exportálta.',
        'This field is required.' => 'Ez a mező kötelező.',
        'Overwrite existing ACLs?' => 'Felülírja a meglévő ACL-eket?',
        'Upload ACL configuration' => 'ACL beállítás feltöltése',
        'Import ACL configuration(s)' => 'ACL beállítások importálása',
        'Description' => 'Leírás',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Egy új ACL létrehozásához importálhat másik rendszerből exportált ACL-eket, vagy létrehozhat egy teljesen újat.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Az ACL-eken itt elvégzett változások csak akkor lesznek hatással a rendszer viselkedésére, ha azután üzembe állítja az ACL adatokat. Az ACL adatok üzembe állításával az újonnan elvégzett módosítások be lesznek írva a beállításokba.',
        'ACLs' => 'ACL-ek',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Ne feledje: Ez a táblázat az ACL-ek végrehajtási sorrendjét tünteti fel. Ha módosítani kell az ACL-ek végrehajtási sorrendjén, változtassa meg az érintett ACL-ek neveit.',
        'ACL name' => 'ACL név',
        'Comment' => 'Megjegyzés',
        'Validity' => 'Érvényesség',
        'Export' => 'Exportálás',
        'Copy' => 'Másolás',
        'No data found.' => 'Nem található adat.',
        'No matches found.' => 'Nincs találat.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '%s ACL szerkesztése',
        'Edit ACL' => 'ACL szerkesztése',
        'Go to overview' => 'Ugrás az áttekintőhöz',
        'Delete ACL' => 'ACL törlése',
        'Delete Invalid ACL' => 'Érvénytelen ACL törlése',
        'Match settings' => 'Illesztési beállítások',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Illesztési feltétel beállítása ehhez az ACL-hez. Használja a „Properties” értéket a jelenlegi képernyő megfeleltetéséhez, vagy a „PropertiesDatabase” értéket az adatbázisban lévő jelenlegi jegy megfeleltetéséhez.',
        'Change settings' => 'Változtatási beállítások',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Állítsa be, amit módosítani szeretne a feltétel egyezésekor. Ne feledkezzen meg arról, hogy a „Possible” a fehérlista, a „PossibleNot” a feketelista.',
        'Check the official %sdocumentation%s.' => 'Nézze meg a hivatalos %sdokumentációt%s.',
        'Show or hide the content' => 'A tartalom megjelenítése vagy elrejtése',
        'Edit ACL Information' => 'ACL információk szerkesztése',
        'Name' => 'Név',
        'Stop after match' => 'Leállítás találat után',
        'Edit ACL Structure' => 'ACL struktúra szerkesztése',
        'Save ACL' => 'ACL mentése',
        'Save' => 'Mentés',
        'or' => 'vagy',
        'Save and finish' => 'Mentés és befejezés',
        'Cancel' => 'Mégse',
        'Do you really want to delete this ACL?' => 'Valóban törölni szeretné ezt az ACL-t?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Egy új ACL létrehozása az űrlapadatok beküldésével. Az ACL létrehozása után lesz képes beállítási elemek hozzáadására szerkesztés módban.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Naptárkezelés',
        'Add Calendar' => 'Naptár hozzáadása',
        'Edit Calendar' => 'Naptár szerkesztése',
        'Calendar Overview' => 'Naptár áttekintő',
        'Add new Calendar' => 'Új naptár hozzáadása',
        'Import Appointments' => 'Időpontok importálása',
        'Calendar Import' => 'Naptár importálása',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Itt tölthet fel egy beállítófájlt egy naptár importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy a naptárkezelő modul exportálta.',
        'Overwrite existing entities' => 'Meglévő bejegyzések felülírása',
        'Upload calendar configuration' => 'Naptárbeállítás feltöltése',
        'Import Calendar' => 'Naptár importálása',
        'Filter for Calendars' => 'Szűrő a naptárakhoz',
        'Filter for calendars' => 'Szűrő a naptárakhoz',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'A csoportmezőtől függően a rendszer a felhasználókat a jogosultsági szintjük alapján fogja engedni hozzáférni a naptárhoz.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Csak olvasás: a felhasználók láthatják és exportálhatják a naptárban lévő összes időpontot.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Átmozgatás: a felhasználók módosíthatják az időpontokat a naptárban, de a naptárválasztás megváltoztatása nélkül.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Létrehozás: a felhasználók létrehozhatnak és törölhetnek időpontokat a naptárban.',
        'Read/write: users can manage the calendar itself.' => 'Írás, olvasás: a felhasználók magát a naptárat kezelhetik.',
        'Group' => 'Csoport',
        'Changed' => 'Módosítva',
        'Created' => 'Létrehozva',
        'Download' => 'Letöltés',
        'URL' => 'URL',
        'Export calendar' => 'Naptár exportálása',
        'Download calendar' => 'Naptár letöltése',
        'Copy public calendar URL' => 'Nyilvános naptár URL másolása',
        'Calendar' => 'Naptár',
        'Calendar name' => 'Naptár neve',
        'Calendar with same name already exists.' => 'Már létezik egy ilyen nevű naptár.',
        'Color' => 'Szín',
        'Permission group' => 'Jogosultsági csoport',
        'Ticket Appointments' => 'Jegyidőpontok',
        'Rule' => 'Szabály',
        'Remove this entry' => 'Bejegyzés eltávolítása',
        'Remove' => 'Eltávolítás',
        'Start date' => 'Kezdődátum',
        'End date' => 'Befejezési dátum',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Használja a lenti lehetőségeket annak leszűkítéséhez, hogy mely jegyek időpontjai legyenek automatikusan létrehozva.',
        'Queues' => 'Várólisták',
        'Please select a valid queue.' => 'Válasszon egy érvényes várólistát.',
        'Search attributes' => 'Keresési attribútumok',
        'Add entry' => 'Bejegyzés hozzáadása',
        'Add' => 'Hozzáadás',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Szabályok meghatározása automatikus időpontok létrehozásához ebben a naptárban a jegyadatok alapján.',
        'Add Rule' => 'Szabály hozzáadása',
        'Submit' => 'Elküldés',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Időpont importálása',
        'Go back' => 'Vissza',
        'Uploaded file must be in valid iCal format (.ics).' => 'A feltöltött fájlnak érvényes iCal formátumban (.ics) kell lennie.',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Ha a kívánt naptár nincs itt felsorolva, akkor győződjön meg arról, hogy van-e legalább „létrehozás” jogosultsága.',
        'Upload' => 'Feltöltés',
        'Update existing appointments?' => 'Frissíti a meglévő időpontokat?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'A naptárban lévő ilyen egyedi azonosítóval rendelkező összes meglévő időpont felül lesz írva.',
        'Upload calendar' => 'Naptár feltöltése',
        'Import appointments' => 'Időpontok importálása',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Időpont-értesítés kezelés',
        'Add Notification' => 'Értesítés hozzáadása',
        'Edit Notification' => 'Értesítés szerkesztése',
        'Export Notifications' => 'Értesítések exportálása',
        'Filter for Notifications' => 'Szűrő az értesítésekhez',
        'Filter for notifications' => 'Szűrő az értesítésekhez',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Itt tud egy beállítófájlt feltölteni az időpont-értesítések importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy az időpont-értesítés modul exportálta.',
        'Overwrite existing notifications?' => 'Felülírja a meglévő értesítéseket?',
        'Upload Notification configuration' => 'Értesítés beállítások feltöltése',
        'Import Notification configuration' => 'Értesítés beállítások importálása',
        'List' => 'Lista',
        'Delete' => 'Törlés',
        'Delete this notification' => 'Értesítés törlése',
        'Show in agent preferences' => 'Megjelenítés az ügyintézői beállításokban',
        'Agent preferences tooltip' => 'Ügyintézői beállítások buboréksúgó',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ez az üzenet egy buboréksúgóként lesz megjelenítve az ügyintézői beállítások képernyőn ennél az értesítésnél.',
        'Toggle this widget' => 'Felületi elem ki- és bekapcsolása',
        'Events' => 'Események',
        'Event' => 'Esemény',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Itt választhatja ki, hogy mely események fogják aktiválni ezt az értesítést. Egy további időpontszűrő alkalmazható lent a csak egy bizonyos feltétellel rendelkező időpontoknál történő küldéshez.',
        'Appointment Filter' => 'Időpont szűrő',
        'Type' => 'Típus',
        'Title' => 'Cím',
        'Location' => 'Hely',
        'Team' => 'Csapat',
        'Resource' => 'Erőforrás',
        'Recipients' => 'Címzettek',
        'Send to' => 'Küldés neki',
        'Send to these agents' => 'Küldés ezeknek az ügyintézőknek',
        'Send to all group members (agents only)' => 'Küldés az összes csoporttagnak (csak ügyintézőknek)',
        'Send to all role members' => 'Küldés az összes szereptagnak',
        'Send on out of office' => 'Küldés irodán kívüli állapotban',
        'Also send if the user is currently out of office.' => 'Akkor is küldje el, ha a felhasználó jelenleg irodán kívül van.',
        'Once per day' => 'Naponta egyszer',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'A felhasználó értesítése csak egyszer egy nap egy egyedüli időpontról egy kiválasztott átvitel használatával.',
        'Notification Methods' => 'Értesítési módszerek',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Ezek azok a lehetséges módszerek, amelyek ezen értesítés küldéséhez használhatók az egyes címzettek részére. Válasszon lent legalább egy módszert.',
        'Enable this notification method' => 'Értesítési módszer engedélyezése',
        'Transport' => 'Átvitel',
        'At least one method is needed per notification.' => 'Legalább egy módszer szükséges értesítésenként.',
        'Active by default in agent preferences' => 'Alapértelmezetten bekapcsolva az ügyintézői beállításokban',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Ez az alapértelmezett érték az olyan hozzárendelt címzett ügyintézőknél, akik még nem választottak ennél az értesítésnél a beállításaikban. Ha a doboz engedélyezve van, akkor az értesítés el lesz küldve az ilyen ügyintézőknek.',
        'This feature is currently not available.' => 'Ez a szolgáltatás jelenleg nem érhető el.',
        'Upgrade to %s' => 'Frissítés a következőre: %s',
        'Please activate this transport in order to use it.' => 'Kapcsolja be azt az átvitelt annak érdekében, hogy használni tudja.',
        'No data found' => 'Nem található adat',
        'No notification method found.' => 'Nem található értesítési módszer.',
        'Notification Text' => 'Értesítési szöveg',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Ez a nyelv nincs jelen vagy nincs engedélyezve a rendszeren. Ez az értesítési szöveg törölhető, ha többé nincs rá szükség.',
        'Remove Notification Language' => 'Értesítési nyelv eltávolítása',
        'Subject' => 'Tárgy',
        'Text' => 'Szöveg',
        'Message body' => 'Üzenettörzs',
        'Add new notification language' => 'Új értesítési nyelv hozzáadása',
        'Save Changes' => 'Változtatások mentése',
        'Tag Reference' => 'Címke hivatkozás',
        'Notifications are sent to an agent.' => 'Az értesítések egy ügyintézőnek kerülnek elküldésre.',
        'You can use the following tags' => 'A következő címkéket használhatja',
        'To get the first 20 character of the appointment title.' => 'Az időpontcím első 20 karakterének lekéréséhez.',
        'To get the appointment attribute' => 'Az időpont jellemzőjének lekéréséhez',
        ' e. g.' => ' például',
        'To get the calendar attribute' => 'A naptár jellemzőjének lekéréséhez',
        'Attributes of the recipient user for the notification' => 'A címzett felhasználó jellemzői az értesítésnél',
        'Config options' => 'Konfigurációs beállítások',
        'Example notification' => 'Példa értesítés',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'További címzett e-mail címek',
        'This field must have less then 200 characters.' => 'Ennek a mezőnek rövidebbnek kell lennie 200 karakternél.',
        'Article visible for customer' => 'A bejegyzés látható az ügyfélnek',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Egy bejegyzés lesz létrehozva, ha az értesítés elküldésre került az ügyfélnek vagy egy további e-mail címre.',
        'Email template' => 'E-mail sablon',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Ezen sablon használata a teljes e-mail előállításához (csak HTML e-maileknél).',
        'Enable email security' => 'E-mail biztonság engedélyezése',
        'Email security level' => 'E-mail biztonsági szint',
        'If signing key/certificate is missing' => 'Ha az aláíró kulcs vagy tanúsítvány hiányzik',
        'If encryption key/certificate is missing' => 'Ha a titkosító kulcs vagy tanúsítvány hiányzik',

        # Template: AdminAttachment
        'Attachment Management' => 'Mellékletkezelés',
        'Add Attachment' => 'Melléklet hozzáadása',
        'Edit Attachment' => 'Melléklet szerkesztése',
        'Filter for Attachments' => 'Szűrő a mellékletekhez',
        'Filter for attachments' => 'Szűrő a mellékletekhez',
        'Filename' => 'Fájlnév',
        'Download file' => 'Fájl letöltése',
        'Delete this attachment' => 'Melléklet törlése',
        'Do you really want to delete this attachment?' => 'Valóban törölni szeretné ezt a mellékletet?',
        'Attachment' => 'Melléklet',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Automatikus válasz kezelés',
        'Add Auto Response' => 'Automatikus válasz hozzáadása',
        'Edit Auto Response' => 'Automatikus válasz szerkesztése',
        'Filter for Auto Responses' => 'Szűrő az automatikus válaszokhoz',
        'Filter for auto responses' => 'Szűrő az automatikus válaszokhoz',
        'Response' => 'Válasz',
        'Auto response from' => 'Automatikus válasz feladója',
        'Reference' => 'Hivatkozás',
        'To get the first 20 character of the subject.' => 'A tárgy első 20 karakterének lekéréséhez.',
        'To get the first 5 lines of the email.' => 'Az e-mail első 5 sorának lekéréséhez.',
        'To get the name of the ticket\'s customer user (if given).' => 'A jegy ügyfél-felhasználója nevének lekéréséhez (ha meg van adva).',
        'To get the article attribute' => 'A bejegyzés jellemzőjének lekéréséhez',
        'Options of the current customer user data' => 'A jelenlegi ügyfél-felhasználó adatainak beállításai',
        'Ticket owner options' => 'Jegytulajdonos beállításai',
        'Ticket responsible options' => 'Jegyfelelős beállításai',
        'Options of the current user who requested this action' => 'A jelenlegi felhasználó beállításai, aki ezt a műveletet kérte',
        'Options of the ticket data' => 'A jegy adatainak beállításai',
        'Options of ticket dynamic fields internal key values' => 'A jegy dinamikus mezői belső kulcs értékeinek beállításai',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'A jegy dinamikus mezői megjelenített értékeinek beállításai, legördülő és többválasztós mezőknél hasznos',
        'Example response' => 'Példa válasz',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Felhőszolgáltatás kezelés',
        'Support Data Collector' => 'Támogatási adatgyűjtő',
        'Support data collector' => 'Támogatási adatgyűjtő',
        'Hint' => 'Tipp',
        'Currently support data is only shown in this system.' => 'Jelenleg a támogatási adatok csak ezen a rendszeren jelennek meg.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Beállítás',
        'Send support data' => 'Támogatási adatok küldése',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Frissítés',
        'System Registration' => 'Rendszer regisztráció',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'A rendszer regisztrálása',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'A rendszer regisztráció le van tiltva a rendszerénél. Ellenőrizze a beállításokat.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Ne feledje, hogy az OTOBO felhőszolgáltatások használatához a rendszer regisztrációja szükséges.',
        'Register this system' => 'A rendszer regisztrálása',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Itt tudja beállítani azokat az elérhető felhőszolgáltatásokat, amelyek biztonságosan kommunikálnak a következővel: %s.',
        'Available Cloud Services' => 'Elérhető felhőszolgáltatások',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Kommunikációs napló',
        'Time Range' => 'Időtartomány',
        'Show only communication logs created in specific time range.' =>
            'Csak azon kommunikációs naplók megjelenítése, amelyek egy adott időtartományban jöttek létre.',
        'Filter for Communications' => 'Szűrő a kommunikációkhoz',
        'Filter for communications' => 'Szűrő a kommunikációkhoz',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Ezen a képernyőn egy áttekintőt láthat a bejövő és kimenő kommunikációkról.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Megváltoztathatja a rendezést és az oszlopok sorrendjét az oszlopfejlécre kattintva.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Ha a különböző bejegyzésekre kattint, akkor átirányításra kerül az üzenetről szóló részletes képernyőre.',
        'Status for: %s' => 'Állapot ennél: %s',
        'Failing accounts' => 'Sikertelen fiókok',
        'Some account problems' => 'Néhány fiókprobléma van',
        'No account problems' => 'Nincs fiókprobléma',
        'No account activity' => 'Nincs fióktevékenység',
        'Number of accounts with problems: %s' => 'Problémás fiókok száma: %s',
        'Number of accounts with warnings: %s' => 'Figyelmeztetett fiókok száma: %s',
        'Failing communications' => 'Sikertelen kommunikációk',
        'No communication problems' => 'Nincs kommunikációs probléma',
        'No communication logs' => 'Nincs kommunikációs napló',
        'Number of reported problems: %s' => 'Jelentett problémák száma: %s',
        'Open communications' => 'Nyitott kommunikációk',
        'No active communications' => 'Nincsenek aktív kommunikációk',
        'Number of open communications: %s' => 'Nyitott kommunikációk száma: %s',
        'Average processing time' => 'Átlagos feldolgozási idő',
        'List of communications (%s)' => 'Kommunikációk felsorolása (%s)',
        'Settings' => 'Beállítások',
        'Entries per page' => 'Oldalankénti bejegyzések',
        'No communications found.' => 'Nem találhatók kommunikációk.',
        '%s s' => '%s mp',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Fiókállapot',
        'Back to overview' => 'Vissza az áttekintőhöz',
        'Filter for Accounts' => 'Szűrő a fiókokhoz',
        'Filter for accounts' => 'Szűrő a fiókokhoz',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Megváltoztathatja a rendezést és az oszlopok sorrendjét az oszlopfejlécre kattintva.',
        'Account status for: %s' => 'Fiókállapot ennél: %s',
        'Status' => 'Állapot',
        'Account' => 'Fiók',
        'Edit' => 'Szerkesztés',
        'No accounts found.' => 'Nem találhatók fiókok.',
        'Communication Log Details (%s)' => 'Kommunikációs napló részletei (%s)',
        'Direction' => 'Irány',
        'Start Time' => 'Kezdési idő',
        'End Time' => 'Befejezési idő',
        'No communication log entries found.' => 'Nem találhatók kommunikációs naplóbejegyzések.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Időtartam',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioritás',
        'Module' => 'Modul',
        'Information' => 'Információ',
        'No log entries found.' => 'Nem találhatók bejegyzések.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '%s kommunikáció részletes nézete elkezdődött ekkor: %s',
        'Filter for Log Entries' => 'Szűrő a naplóbejegyzésekhez',
        'Filter for log entries' => 'Szűrő a naplóbejegyzésekhez',
        'Show only entries with specific priority and higher:' => 'Csak bizonyos vagy magasabb prioritással rendelkező bejegyzések megjelenítése:',
        'Communication Log Overview (%s)' => 'Kommunikációs napló áttekintő (%s)',
        'No communication objects found.' => 'Nem találhatók kommunikációs objektumok.',
        'Communication Log Details' => 'Kommunikációs napló részletei',
        'Please select an entry from the list.' => 'Válasszon egy bejegyzést a listából.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Partneradatok',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Vissza a keresési eredményekhez',
        'Select' => 'Kiválasztás',
        'Search' => 'Keresés',
        'Wildcards like \'*\' are allowed.' => 'Helyettesítő karakterek (például „*”) engedélyezettek.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Érvényes',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Ügyfélkezelés',
        'Add Customer' => 'Ügyfél hozzáadása',
        'Edit Customer' => 'Ügyfél szerkesztése',
        'List (only %s shown - more available)' => 'Lista (csak %s látható – több érhető el)',
        'total' => 'összesen',
        'Please enter a search term to look for customers.' => 'Adjon meg egy keresési kifejezést az ügyfelek kereséséhez.',
        'Customer ID' => 'Ügyfél-azonosító',
        'Please note' => 'Ne feledje',
        'This customer backend is read only!' => 'Ez az ügyfél háttérprogram csak olvasható!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Ügyfél–Csoport kapcsolatok kezelése',
        'Notice' => 'Értesítés',
        'This feature is disabled!' => 'Ez a szolgáltatás le van tiltva!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Csak akkor használja ezt a szolgáltatást, ha csoportjogosultságokat szeretne meghatározni az ügyfelekhez.',
        'Enable it here!' => 'Itt engedélyezze!',
        'Edit Customer Default Groups' => 'Alapértelmezett ügyfélcsoportok szerkesztése',
        'These groups are automatically assigned to all customers.' => 'Ezek a csoportok automatikusan hozzá vannak rendelve minden ügyfélhez.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Ezeket a csoportokat a „CustomerGroupCompanyAlwaysGroups” beállításon keresztül kezelheti.',
        'Filter for Groups' => 'Szűrő a csoportokhoz',
        'Select the customer:group permissions.' => 'Az ügyfél:csoport jogosultságok kiválasztása.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ha semmi sincs kiválasztva, akkor ebben a csoportban nincsenek jogosultságok (a jegyek nem lesznek elérhetők az ügyfeleknek).',
        'Search Results' => 'Keresési eredmények',
        'Customers' => 'Ügyfelek',
        'Groups' => 'Csoportok',
        'Change Group Relations for Customer' => 'Csoportkapcsolatok megváltoztatása egy ügyfélnél',
        'Change Customer Relations for Group' => 'Ügyfélkapcsolatok megváltoztatása egy csoportnál',
        'Toggle %s Permission for all' => 'A(z) %s jogosultság ki- vagy bekapcsolása mindenkinek',
        'Toggle %s permission for %s' => 'A(z) %s jogosultság ki- vagy bekapcsolása ehhez: %s',
        'Customer Default Groups:' => 'Alapértelmezett ügyfélcsoportok:',
        'No changes can be made to these groups.' => 'Nem lehet változtatni ezeken a csoportokon.',
        'ro' => 'csak olvasás',
        'Read only access to the ticket in this group/queue.' => 'Csak olvasható hozzáférés ebben a csoportban/várólistában lévő jegyekhez.',
        'rw' => 'írás, olvasás',
        'Full read and write access to the tickets in this group/queue.' =>
            'Teljes írási és olvasási hozzáférés ebben a csoportban/várólistában lévő jegyekhez.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Ügyfél-felhasználó kezelés',
        'Add Customer User' => 'Ügyfél-felhasználó hozzáadása',
        'Edit Customer User' => 'Ügyfél-felhasználó szerkesztése',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Az ügyfél-felhasználó az ügyfél-előzményekhez és az ügyfélpanelen keresztüli bejelentkezéshez szükséges.',
        'List (%s total)' => 'Lista (összesen %s)',
        'Username' => 'Felhasználónév',
        'Email' => 'E-mail',
        'Last Login' => 'Utolsó belépés',
        'Login as' => 'Belépés mint',
        'Switch to customer' => 'Váltás az ügyfélre',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Ez az ügyfél háttérprogram csak olvasható, de az ügyfél-felhasználó beállításai megváltoztathatók!',
        'This field is required and needs to be a valid email address.' =>
            'Ez a mező kötelező és érvényes e-mail címet kell tartalmaznia.',
        'This email address is not allowed due to the system configuration.' =>
            'Ez az e-mail cím nem megengedett a rendszerbeállítások miatt.',
        'This email address failed MX check.' => 'Ez az e-mail cím megbukott az MX ellenőrzésen.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS probléma, ellenőrizze a beállításokat és a hibanaplót.',
        'The syntax of this email address is incorrect.' => 'Ennek az e-mail címnek hibás a szintaxisa.',
        'This CustomerID is invalid.' => 'Ez az ügyfél-azonosító érvénytelen.',
        'Effective Permissions for Customer User' => 'Tényleges jogosultságok az ügyfél-felhasználónál',
        'Group Permissions' => 'Csoportjogosultságok',
        'This customer user has no group permissions.' => 'Ennek az ügyfél-felhasználónak nincsenek csoportjogosultságai.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'A fenti táblázat a tényleges csoportjogosultságokat jeleníti meg az ügyfél-felhasználónál. A mátrix figyelembe veszi az összes örökölt jogosultságot (például ügyfélcsoportokon keresztül). Megjegyzés: a táblázat elküldés nélkül nem veszi figyelembe az ezen az űrlapon végzett változtatásokat.',
        'Customer Access' => 'Ügyfélhozzáférés',
        'Customer' => 'Ügyfél',
        'This customer user has no customer access.' => 'Ennek az ügyfél-felhasználónak nincs ügyfélhozzáférése.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'A fenti táblázat a megadott ügyfélhozzáféréseket jeleníti meg az ügyfél-felhasználónál jogosultsági környezet szerint. A mátrix figyelembe veszi az összes örökölt hozzáférést (például ügyfélcsoportokon keresztül). Megjegyzés: a táblázat elküldés nélkül nem veszi figyelembe az ezen az űrlapon végzett változtatásokat.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Ügyfél-felhasználó–Ügyfél kapcsolatok kezelése',
        'Select the customer user:customer relations.' => 'Az ügyfél-felhasználó:ügyfél kapcsolatok kiválasztása.',
        'Customer Users' => 'Ügyfél-felhasználók',
        'Change Customer Relations for Customer User' => 'Ügyfélkapcsolatok megváltoztatása egy ügyfél-felhasználónál',
        'Change Customer User Relations for Customer' => 'Ügyfél-felhasználó kapcsolatok megváltoztatása egy ügyfélnél',
        'Toggle active state for all' => 'Aktivált állapot ki- és bekapcsolása mindenkinek',
        'Active' => 'Aktív',
        'Toggle active state for %s' => 'Aktivált állapot ki- és bekapcsolása ehhez: %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Ügyfél-felhasználó–Csoport kapcsolatok kezelése',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Csak akkor használja ezt a szolgáltatást, ha csoportjogosultságokat szeretne meghatározni az ügyfél-felhasználókhoz.',
        'Edit Customer User Default Groups' => 'Ügyfél-felhasználó alapértelmezett csoportjainak szerkesztése',
        'These groups are automatically assigned to all customer users.' =>
            'Ezek a csoportok automatikusan hozzá vannak rendelve minden ügyfél-felhasználóhoz.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Ezeket a csoportokat a „CustomerGroupAlwaysGroups” beállításon keresztül kezelheti.',
        'Filter for groups' => 'Szűrő a csoportokhoz',
        'Select the customer user - group permissions.' => 'Az ügyfél-felhasználó – csoport jogosultságok kiválasztása.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Ha semmi sincs kiválasztva, akkor ebben a csoportban nincsenek jogosultságok (a jegyek nem lesznek elérhetők az ügyfél-felhasználónak).',
        'Customer User Default Groups:' => 'Ügyfél-felhasználó alapértelmezett csoportjai:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Ügyfél-felhasználó–Szolgáltatás kapcsolatok kezelése',
        'Edit default services' => 'Alapértelmezett szolgáltatások szerkesztése',
        'Filter for Services' => 'Szűrő a szolgáltatásokhoz',
        'Filter for services' => 'Szűrő a szolgáltatásokhoz',
        'Services' => 'Szolgáltatások',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Dinamikus mezők kezelése',
        'Add new field for object' => 'Új mező hozzáadása az objektumhoz',
        'Filter for Dynamic Fields' => 'Szűrő a dinamikus mezőkhöz',
        'Filter for dynamic fields' => 'Szűrő a dinamikus mezőkhöz',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Adatbázis',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Külső adatbázis használata beállítható adatforrásokként ennél a dinamikus mezőnél.',
        'Web service' => 'Webszolgáltatás',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Külső webszolgáltatások beállíthatók adatforrásokként ennél a dinamikus mezőnél.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Ez a funkció lehetővé teszi (több) partneradat hozzáadását a jegyhez.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Egy új mező hozzáadásához válassza ki a mezőtípust az objektum listájának egyikéből. Az objektum határozza meg a mező határát, és nem lehet azt megváltoztatni a mező létrehozása után.',
        'Dynamic Fields List' => 'Dinamikus mezők listája',
        'Dynamic fields per page' => 'Oldalankénti dinamikus mezők',
        'Label' => 'Címke',
        'Order' => 'Sorrend',
        'Object' => 'Objektum',
        'Delete this field' => 'Mező törlése',

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
        'Dynamic Fields' => 'Dinamikus mezők',
        'Go back to overview' => 'Vissza az áttekintőhöz',
        'General' => 'Általános',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ez a mező kötelező, és az értéke csak betű és szám karakter lehet.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Egyedinek kell lennie, és csak betű és szám karaktereket fogad el.',
        'Changing this value will require manual changes in the system.' =>
            'Az érték megváltoztatása kézi módosításokat fog igényelni a rendszeren.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ez azokon a képernyőkön megjelenítendő név, ahol a mező aktív.',
        'Field order' => 'Mezősorrend',
        'This field is required and must be numeric.' => 'Ez a mező kötelező, és csak számot tartalmazhat.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ez az a sorrend, amelyben ez a mező meg fog jelenni a képernyőkön, ahol aktív.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Nem lehetséges érvényteleníteni ezt a bejegyzést, az összes konfigurációs beállítást meg kell változtatni előtte.',
        'Field type' => 'Mezőtípus',
        'Object type' => 'Objektumtípus',
        'Internal field' => 'Belső mező',
        'This field is protected and can\'t be deleted.' => 'Ez a mező védett, és nem lehet törölni.',
        'This dynamic field is used in the following config settings:' =>
            'Ez a dinamikus mező a következő konfigurációs beállításokban van használva:',
        'Field Settings' => 'mezőbeállítások',
        'Default value' => 'Alapértelmezett érték',
        'This is the default value for this field.' => 'Ez az alapértelmezett érték ehhez a mezőhöz.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Kulcs',
        'Value' => 'Érték',
        'Remove value' => 'Érték eltávolítása',
        'Add Field' => '',
        'Add value' => 'Érték hozzáadása',
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
        'Translatable values' => 'Lefordítható értékek',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ha aktiválja ezt a lehetőséget, az értékek le lesznek fordítva a felhasználó által megadott nyelvre.',
        'Note' => 'Jegyzet',
        'You need to add the translations manually into the language translation files.' =>
            'A fordításokat kézzel kell hozzáadnia a nyelv fordítási fájljaihoz.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Lehetséges értékek',
        'Datatype' => '',
        'Filter' => 'Szűrő',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Hivatkozás megjelenítése',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Itt határozható meg egy opcionális HTTP hivatkozás a mező értékéhez az áttekintőben és a nagyítási képernyőkön.',
        'Example' => 'Példa',
        'Link for preview' => 'Hivatkozás az előnézethez',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Ha ki van töltve, akkor ez az URL lesz használva egy olyan előnézethez, amely akkor jelenik meg, ha erre a hivatkozásra rámutatnak a jegynagyításban. Ne feledje, hogy ahhoz, hogy ez működjön, a fenti szabályos URL-mezőt is ki kell tölteni.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Port',
        'Table / View' => '',
        'User' => 'Felhasználó',
        'Password' => 'Jelszó',
        'Identifier' => 'Azonosító',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Többválasztós',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Alapértelmezett dátumkülönbség',
        'This field must be numeric.' => 'Ez a mező csak számot tartalmazhat.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'A különbség MOSTANTÓL (másodpercben) a mező alapértelmezett értékének számításához (például 3600 vagy -60).',
        'Define years period' => 'Éves időszak meghatározása',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'A szolgáltatás aktiválásával egy rögzített évtartományt határozhat meg (a jövőben vagy a múltban), amely a mező év részében kerül megjelenítésre.',
        'Years in the past' => 'Elmúlt évek',
        'Years in the past to display (default: 5 years).' => 'A megjelenítendő elmúlt évek (alapértelmezés: 5 év).',
        'Years in the future' => 'Jövőbeli évek',
        'Years in the future to display (default: 5 years).' => 'A megjelenítendő jövőbeli évek (alapértelmezés: 5 év).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Ha a különleges karaktereket (&, @, :, /, stb.) nem kell kódolni, akkor használja az „url” szűrőt az „uri” szűrő helyett.',
        'Restrict entering of dates' => 'Korlátozás dátumok bevitelére',
        'Here you can restrict the entering of dates of tickets.' => 'Itt korlátozható a jegyek dátumának bevitele.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Érték hozzáadása',
        'Add empty value' => 'Üres érték hozzáadása',
        'Activate this option to create an empty selectable value.' => 'Aktiválja ezt a lehetőséget egy üres, kijelölhető érték létrehozásához.',
        'Tree View' => 'Fa nézet',
        'Activate this option to display values as a tree.' => 'Aktiválja ezt a lehetőséget az értékek faként való megjelenítéséhez.',

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
        'Fields' => 'Mezők',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Áttekintés',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Lehetőség van az elemek rendezésére is a listán belül fogd és vidd módon.',
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
        'Reset' => 'Visszaállítás',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Sorok száma',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'A mező magasságának megadása (sorokban) a szerkesztő módban.',
        'Number of cols' => 'Oszlopok száma',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'A mező szélességének megadása (karakterekben) a szerkesztő módban.',
        'Check RegEx' => 'Reguláris kifejezés ellenőrzése',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Itt adhatja meg az értéket ellenőrző reguláris kifejezést. A reguláris kifejezés az xms módosítóval lesz végrehajtva.',
        'RegEx' => 'Reguláris kifejezés',
        'Invalid RegEx' => 'Érvénytelen reguláris kifejezés',
        'Error Message' => 'Hibaüzenet',
        'Add RegEx' => 'Reguláris kifejezés hozzáadása',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Sablon',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Méret',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Ez a mező kötelező',
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
        'Admin Message' => 'Adminisztrátori üzenet',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Ezzel a modullal az adminisztrátorok üzeneteket küldhetnek az ügyintézőknek, csoportoknak vagy a tagoknak.',
        'Create Administrative Message' => 'Adminisztratív üzenet létrehozása',
        'Your message was sent to' => 'Az üzenet elküldve a következőknek',
        'From' => 'Feladó',
        'Send message to users' => 'Üzenet küldése a felhasználóknak',
        'Send message to group members' => 'Üzenet küldése a csoport tagjainak',
        'Group members need to have permission' => 'A csoport tagjainak jogosultságra van szükségük',
        'Send message to role members' => 'Üzenet küldése a szerep tagjainak',
        'Also send to customers in groups' => 'Küldés a csoportokban lévő ügyfeleknek is',
        'Body' => 'Törzs',
        'Send' => 'Küldés',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Általános ügyintéző feladat kezelés',
        'Edit Job' => 'Feladat szerkesztése',
        'Add Job' => 'Feladat hozzáadása',
        'Run Job' => 'Feladat futtatása',
        'Filter for Jobs' => 'Szűrő a feladatokhoz',
        'Filter for jobs' => 'Szűrő a feladatokhoz',
        'Last run' => 'Utolsó futás',
        'Run Now!' => 'Futtatás most!',
        'Delete this task' => 'Feladat törlése',
        'Run this task' => 'Feladat futtatása',
        'Job Settings' => 'Feladat-beállítások',
        'Job name' => 'Feladatnév',
        'The name you entered already exists.' => 'A megadott név már létezik.',
        'Automatic Execution (Multiple Tickets)' => 'Automatikus végrehajtás (több jegy)',
        'Execution Schedule' => 'Végrehajtás-ütemezés',
        'Schedule minutes' => 'Perc ütemezése',
        'Schedule hours' => 'Óra ütemezése',
        'Schedule days' => 'Nap ütemezése',
        'Automatic execution values are in the system timezone.' => 'Az automatikus végrehajtás értékei a rendszer időzónában vannak.',
        'Currently this generic agent job will not run automatically.' =>
            'Jelenleg ez az általános ügyintéző feladat nem fut le automatikusan.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Az automatikus végrehajtás engedélyezéséhez válasszon legalább egy értéket a perc, óra és nap közül!',
        'Event Based Execution (Single Ticket)' => 'Eseményalapú végrehajtás (egyetlen jegy)',
        'Event Triggers' => 'Eseményaktiválók',
        'List of all configured events' => 'Az összes beállított esemény listája',
        'Delete this event' => 'Esemény törlése',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Egy időszakos végrehajtás mellett vagy helyett meghatározhat olyan jegyeseményeket, amelyek aktiválni fogják ezt a feladatot.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Ha egy jegyesemény elsül, a jegy szűrő alkalmazásával kerül ellenőrzésre, hogy a jegy illeszkedik-e.',
        'Do you really want to delete this event trigger?' => 'Valóban törölni szeretné ezt az eseményaktiválót?',
        'Add Event Trigger' => 'Eseményaktiváló hozzáadása',
        'To add a new event select the event object and event name' => 'Egy új esemény hozzáadásához válassza ki az eseményobjektumot és az eseménynevet',
        'Select Tickets' => 'Jegyek kijelölése',
        '(e. g. 10*5155 or 105658*)' => '(például 10*5155 vagy 105658*)',
        '(e. g. 234321)' => '(például 234321)',
        'Customer user ID' => 'Ügyfél-felhasználó azonosítója',
        '(e. g. U5150)' => '(például U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Szabad-szavas keresés a bejegyzésben (például „Mar*in” vagy „Baue*”).',
        'To' => 'Címzett',
        'Cc' => 'Másolat',
        'Service' => 'Szolgáltatás',
        'Service Level Agreement' => 'Szolgáltatási megállapodás',
        'Queue' => 'Várólista',
        'State' => 'Állapot',
        'Agent' => 'Ügyintéző',
        'Owner' => 'Tulajdonos',
        'Responsible' => 'Felelős',
        'Ticket lock' => 'Jegyzár',
        'Dynamic fields' => 'Dinamikus mezők',
        'Add dynamic field' => 'Dinamikus mező hozzáadása',
        'Create times' => 'Létrehozási idők',
        'No create time settings.' => 'Nincsenek létrehozási idő beállítások.',
        'Ticket created' => 'Jegy létrehozva',
        'Ticket created between' => 'Jegy létrehozva a következő időpontok között',
        'and' => 'és',
        'Last changed times' => 'Utolsó módosítási idők',
        'No last changed time settings.' => 'Nincsenek utolsó módosítási idő beállítások.',
        'Ticket last changed' => 'Jegy utoljára módosítva',
        'Ticket last changed between' => 'Jegy utoljára módosítva a következő időpontok között',
        'Change times' => 'Módosítási idők',
        'No change time settings.' => 'Nincsenek módosítási idő beállítások.',
        'Ticket changed' => 'Jegy módosítva',
        'Ticket changed between' => 'Jegy módosítva a következő időpontok között',
        'Close times' => 'Lezárási idők',
        'No close time settings.' => 'Nincsenek lezárási idő beállítások.',
        'Ticket closed' => 'Jegy lezárva',
        'Ticket closed between' => 'Jegy lezárva a következő időpontok között',
        'Pending times' => 'Várakozási idők',
        'No pending time settings.' => 'Nincsenek várakozási idő beállítások.',
        'Ticket pending time reached' => 'Jegy várakozási ideje elérve',
        'Ticket pending time reached between' => 'Jegy várakozási ideje elérve a következő időpontok között',
        'Escalation times' => 'Eszkalációs idők',
        'No escalation time settings.' => 'Nincsenek eszkalációs idő beállítások.',
        'Ticket escalation time reached' => 'Jegy eszkalációs ideje elérve',
        'Ticket escalation time reached between' => 'Jegy eszkalációs ideje elérve a következő időpontok között',
        'Escalation - first response time' => 'Eszkaláció – első válaszidő',
        'Ticket first response time reached' => 'Jegy első válaszideje elérve',
        'Ticket first response time reached between' => 'Jegy első válaszideje elérve a következő időpontok között',
        'Escalation - update time' => 'Eszkaláció – frissítési idő',
        'Ticket update time reached' => 'Jegy frissítési ideje elérve',
        'Ticket update time reached between' => 'Jegy frissítési ideje elérve a következő időpontok között',
        'Escalation - solution time' => 'Eszkaláció – megoldási idő',
        'Ticket solution time reached' => 'Jegy megoldási ideje elérve',
        'Ticket solution time reached between' => 'Jegy megoldási ideje elérve a következő időpontok között',
        'Archive search option' => 'Archívumkeresési beállítások',
        'Update/Add Ticket Attributes' => 'Jegyjellemzők frissítése/hozzáadása',
        'Set new service' => 'Új szolgáltatás beállítása',
        'Set new Service Level Agreement' => 'Új szolgáltatási megállapodás beállítása',
        'Set new priority' => 'Új prioritás beállítása',
        'Set new queue' => 'Új várólista beállítása',
        'Set new state' => 'Új állapot beállítása',
        'Pending date' => 'Várakozási dátum',
        'Set new agent' => 'Új ügyintéző beállítása',
        'new owner' => 'új tulajdonos',
        'new responsible' => 'új felelős',
        'Set new ticket lock' => 'Új jegyzár beállítása',
        'New customer user ID' => 'Új ügyfél-azonosító azonosító',
        'New customer ID' => 'Új ügyfél-azonosító',
        'New title' => 'Új cím',
        'New type' => 'Új típus',
        'Archive selected tickets' => 'Kijelölt jegyek archiválása',
        'Add Note' => 'Jegyzet hozzáadása',
        'Visible for customer' => 'Látható az ügyfélnek',
        'Time units' => 'Időegységek',
        'Execute Ticket Commands' => 'Jegyparancsok végrehajtása',
        'Send agent/customer notifications on changes' => 'Ügyintéző/ügyfél értesítések küldése módosításkor',
        'CMD' => 'PARANCS',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ez a parancs lesz végrehajtva. Az ARG[0] lesz a jegy száma. Az ARG[1] lesz a jegy azonosítója.',
        'Delete tickets' => 'Jegyek törlése',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Figyelem: Minden érintett jegy el lesz távolítva az adatbázisból, és nem lehet visszaállítani!',
        'Execute Custom Module' => 'Egyéni modul végrehajtása',
        'Param %s key' => '%s. paraméter kulcsa',
        'Param %s value' => '%s. paraméter értéke',
        'Results' => 'Eredmények',
        '%s Tickets affected! What do you want to do?' => '%s jegy érintett! Mit szeretne tenni?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Figyelem: A TÖRLÉS lehetőséget használta. Minden törölt jegy el fog veszni!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Figyelem: %s jegy érintett, de csak %s módosítható egy feladat-végrehajtás során!',
        'Affected Tickets' => 'Érintett jegyek',
        'Age' => 'Életkor',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Általános felület webszolgáltatás kezelés',
        'Web Service Management' => 'Webszolgáltatás kezelés',
        'Debugger' => 'Hibakereső',
        'Go back to web service' => 'Vissza a webszolgáltatáshoz',
        'Clear' => 'Törlés',
        'Do you really want to clear the debug log of this web service?' =>
            'Valóban törölni szeretné ennek a webszolgáltatásnak a hibakeresési naplóját?',
        'Request List' => 'Kéréslista',
        'Time' => 'Idő',
        'Communication ID' => 'Kommunikáció-azonosító',
        'Remote IP' => 'Távoli IP',
        'Loading' => 'Betöltés',
        'Select a single request to see its details.' => 'Válasszon egy egyszerű kérést a részletei megtekintéséhez.',
        'Filter by type' => 'Szűrés típus szerint',
        'Filter from' => 'Szűrés ettől',
        'Filter to' => 'Szűrés eddig',
        'Filter by remote IP' => 'Szűrés távoli IP szerint',
        'Limit' => 'Korlát',
        'Refresh' => 'Frissítés',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Hibakezelés hozzáadása',
        'Edit ErrorHandling' => 'Hibakezelés szerkesztése',
        'Do you really want to delete this error handling module?' => 'Valóban törölni szeretné ezt a hibakezelési modult?',
        'All configuration data will be lost.' => 'Minden beállítási adat el fog veszni.',
        'General options' => 'Általános beállítások',
        'The name can be used to distinguish different error handling configurations.' =>
            'A név használható a különböző hibakezelési beállítások megkülönböztetéséhez.',
        'Please provide a unique name for this web service.' => 'Adjon meg egy egyedi nevet ehhez a webszolgáltatáshoz.',
        'Error handling module backend' => 'Hibakezelési modul háttérprogram',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Ez az OTOBO hibakezelési háttérprogram modul kerül meghívásra belsőleg a hibakezelési mechanizmus feldolgozásához.',
        'Processing options' => 'Feldolgozási beállítások',
        'Configure filters to control error handling module execution.' =>
            'Szűrők beállítása a hibakezelési modul végrehajtásának vezérléséhez.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Csak az összes beállított szűrőre illeszkedő kérések (ha van) fogják aktiválni a modulvégrehajtást.',
        'Operation filter' => 'Műveletszűrő',
        'Only execute error handling module for selected operations.' => 'Csak hibakezelési modul végrehajtása a kijelölt műveleteknél.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Megjegyzés: a művelet nem meghatározott azoknál a hibáknál, amelyek a bejövő kérésadatok fogadásakor fordulnak elő. Az ilyen hibaállapotot érintő szűrők nem használhatnak műveletszűrőket.',
        'Invoker filter' => 'Meghívószűrő',
        'Only execute error handling module for selected invokers.' => 'Csak hibakezelési modul végrehajtása a kijelölt meghívóknál.',
        'Error message content filter' => 'Hibaüzenet tartalomszűrő',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Egy reguláris kifejezés megadása annak korlátozásához, hogy mely hibaüzeneteknek kell hibakezelési modul végrehajtást okoznia.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'A hibaüzenet tárgya és adatai (amint a hibakereső hibabejegyzésében létható) lesznek figyelembe véve egy egyezésnél.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Példa: A „^.*401 Unauthorized.*\$” megadásával csak a hitelesítéssel kapcsolatos hibák kezelhetők.',
        'Error stage filter' => 'Hibaállapot szűrő',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Csak hibakezelési modul végrehajtása olyan hibáknál, amelyek bizonyos feldolgozási állapotoknál fordulnak elő.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Példa: csak olyan hibák kezelése, ahol nem sikerült alkalmazni a leképezést a kimenő adatoknál.',
        'Error code' => 'Hibakód',
        'An error identifier for this error handling module.' => 'Egy hibaazonosító ennél a hibakezelési modulnál.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ez az azonosító lesz elérhető az XSLT-leképezésben, és ez jelenik meg a hibakereső kimenetén.',
        'Error message' => 'Hibaüzenet',
        'An error explanation for this error handling module.' => 'Egy hibamagyarázat ennél a hibakezelési modulnál.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ez az üzenet lesz elérhető az XSLT-leképezésben, és ez jelenik meg a hibakereső kimenetén.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Annak meghatározása, hogy a feldolgozást le kell-e állítani a modul végrehajtása után, kihagyva az összes hátralévő modult vagy csak ugyanannak a háttérprogramnak a moduljait.',
        'Default behavior is to resume, processing the next module.' => 'Az alapértelmezett viselkedés a folytatás, a következő modul feldolgozása.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Ez a modul lehetővé teszi az ütemezett újrapróbálkozások beállítását a sikertelen kéréseknél.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Az általános felület webszolgáltatásainak alapértelmezett viselkedése, hogy minden egyes kérést pontosan egyszer küld el, és nincs újraütemezés a hibák után.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Ha egynél több modul is képes egy egyéni kérésnél végrehajtott újrapróbálkozás ütemezésére, akkor a legutóbb végrehajtott modul az irányadó, és meghatározza, hogy az újrapróbálkozás ütemezve legyen-e.',
        'Request retry options' => 'Kérés újrapróbálkozási beállítások',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Az újrapróbálkozási beállítások akkor lesznek alkalmazva, amikor a kérések hibakezelési modul végrehajtást okoznak (a feldolgozási beállítások alapján).',
        'Schedule retry' => 'Újrapróbálkozás ütemezése',
        'Should requests causing an error be triggered again at a later time?' =>
            'A hibát okozó kérések legyenek aktiválva ismét a későbbiekben?',
        'Initial retry interval' => 'Kezdeti újrapróbálkozási időköz',
        'Interval after which to trigger the first retry.' => 'Az az időköz, amely után az első újrapróbálkozást aktiválni kell.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Megjegyzés: ez és az összes későbbi újrapróbálkozási időköz a kezdeti kérés hibakezelési moduljának végrehajtási idején alapul.',
        'Factor for further retries' => 'Tényező a későbbi újrapróbálkozásokhoz',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Ha egy kérés még az első újrapróbálkozás után is hibával tér vissza, akkor annak meghatározása, hogy a következő kérések ugyanolyan időköz vagy növekvő időköz használatával legyenek-e aktiválva.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Példa: ha egy kérés eredetileg 10:00-kor kerül aktiválásra „1 perc” kezdeti időközzel és „2” újrapróbálkozási tényezővel, akkor az újrapróbálások 10:01-kor (1 perc), 10:03-kor (2*1=2 perc), 10:07-kor (2*2=4 perc), 10:15-kor (2*4=8 perc), stb. lennének aktiválva.',
        'Maximum retry interval' => 'Legnagyobb újrapróbálkozási időköz',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Ha az újrapróbálkozási időköz tényezőjénél „1,5” vagy „2” van kiválasztva, akkor a nem kívánt hosszúságú időközök megakadályozhatók a legnagyobb megengedett időköz meghatározásával.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'A legnagyobb újrapróbálkozási időközt túllépő kiszámított időközök ekkor automatikusan le lesznek rövidítve ennek megfelelően.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Példa: ha egy kérés eredetileg 10:00-kor kerül aktiválásra „1 perc” kezdeti időközzel, „2” újrapróbálkozási tényezővel és „5 perc” legnagyobb időközzel, akkor az újrapróbálások 10:01-kor (1 perc), 10:03-kor (2 perc), 10:07-kor (4 perc), 10:12-kor (8=>5 perc), 10:17-kor, stb. lennének aktiválva.',
        'Maximum retry count' => 'Legnagyobb újrapróbálkozási darabszám',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Az újrapróbálkozások legnagyobb száma, mielőtt egy sikertelen kérés eldobásra kerülne, de nem számít bele a kezdeti kérés.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Példa: ha egy kérés eredetileg 10:00-kor kerül aktiválásra „1 perc” kezdeti időközzel, „2” újrapróbálkozási tényezővel és „2” legnagyobb újrapróbálkozási darabszámmal, akkor az újrapróbálások csak 10:01-kor és 10:02-kor lennének aktiválva.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Megjegyzés: a legnagyobb újrapróbálkozási darabszám esetleg nem érhető el, ha legnagyobb újrapróbálkozási időtartam is be van állítva, és azt előbb éri el.',
        'This field must be empty or contain a positive number.' => 'Ennek a mezőnek üresnek kell lennie vagy pozitív számot kell tartalmaznia.',
        'Maximum retry period' => 'Legnagyobb újrapróbálkozási időtartam',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'A sikertelen kérések újrapróbálkozásainak legnagyobb időtartama, mielőtt azok eldobásra kerülnek (a kezdeti kérés hibakezelési moduljának végrehajtási ideje alapján).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Azok az újrapróbálkozások, amelyek normális esetben a legnagyobb időtartam elteltével kerülnének aktiválásra (az újrapróbálkozási időköz számítása szerint), pontosan a legnagyobb időtartamkor lesznek automatikusan aktiválva.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Példa: ha egy kérés eredetileg 10:00-kor kerül aktiválásra „1 perc” kezdeti időközzel, „2” újrapróbálkozási tényezővel és „30 perc” legnagyobb újrapróbálkozási időtartammal, akkor az újrapróbálások 10:01-kor, 10:03-kor, 10:07-kor, 10:15-kor és végül 10:31=>10:30-kor lennének aktiválva.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Megjegyzés: a legnagyobb újrapróbálkozási időtartam esetleg nem érhető el, ha legnagyobb újrapróbálkozási darabszám is be van állítva, és azt előbb éri el.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Meghívó hozzáadása',
        'Edit Invoker' => 'Meghívó szerkesztése',
        'Do you really want to delete this invoker?' => 'Valóban törölni szeretné ezt a meghívót?',
        'Invoker Details' => 'Meghívó részletei',
        'The name is typically used to call up an operation of a remote web service.' =>
            'A név tipikusan egy távoli webszolgáltatás műveletének meghívásához használható.',
        'Invoker backend' => 'Meghívó háttérprogram',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Ez az OTOBO meghívó háttérprogram modul lesz meghívva a távoli rendszerre küldendő adatok előkészítéséhez, és a válasz adatainak feldolgozásához.',
        'Mapping for outgoing request data' => 'Leképezés a kimenő kérés adataihoz',
        'Configure' => 'Beállítás',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Ez a leképezés fogja feldolgozni az OTOBO meghívójából származó adatokat olyan formára alakítva át azokat, ahogy a távoli rendszer várja.',
        'Mapping for incoming response data' => 'Leképezés a bejövő válasz adataihoz',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Ez a leképezés fogja a válasz adatait feldolgozni olyan formára alakítva át azokat, ahogy az OTOBO meghívója várja.',
        'Asynchronous' => 'Aszinkron',
        'Condition' => 'Feltétel',
        'Edit this event' => 'Esemény szerkesztése',
        'This invoker will be triggered by the configured events.' => 'Ezt a meghívót a beállított események fogják aktiválni.',
        'Add Event' => 'Esemény hozzáadása',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Egy új esemény hozzáadásához válassza ki az eseményobjektumot és az eseménynevet, majd kattintson a „+” gombra',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Az aszinkron esemény-aktiválókat az OTOBO ütemeződémon kezeli a háttérben (javasolt).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'A szinkron eseményaktiválók közvetlenül lehetnek feldolgozva a webkérések közben.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Általános felület meghívóesemény beállításai a webszolgáltatásnál: %s',
        'Go back to' => 'Vissza ide',
        'Delete all conditions' => 'Minden feltétel törlése',
        'Do you really want to delete all the conditions for this event?' =>
            'Valóban törölni szeretné az összes feltételt ennél az eseménynél?',
        'General Settings' => 'Általános beállítások',
        'Event type' => 'Eseménytípus',
        'Conditions' => 'Feltételek',
        'Conditions can only operate on non-empty fields.' => 'A feltételek csak nem üres mezőkön működhetnek.',
        'Type of Linking between Conditions' => 'Kapcsolat típusa a feltételek között',
        'Remove this Condition' => 'Feltétel eltávolítása',
        'Type of Linking' => 'Kapcsolat típusa',
        'Add a new Field' => 'Új mező hozzáadása',
        'Remove this Field' => 'Mező eltávolítása',
        'And can\'t be repeated on the same condition.' => 'És nem lehet ismételni ugyanazon a feltételen.',
        'Add New Condition' => 'Új feltétel hozzáadása',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Egyszerű leképezés',
        'Default rule for unmapped keys' => 'Alapértelmezett szabály a nem leképezett kulcsokhoz',
        'This rule will apply for all keys with no mapping rule.' => 'Ez a szabály alkalmazni fogja minden leképezési szabály nélküli kulcsra.',
        'Default rule for unmapped values' => 'Alapértelmezett szabály a nem leképezett értékekhez',
        'This rule will apply for all values with no mapping rule.' => 'Ez a szabály alkalmazni fogja minden leképezési szabály nélküli értékre.',
        'New key map' => 'Új kulcstérkép',
        'Add key mapping' => 'Új kulcsleképezés',
        'Mapping for Key ' => 'Leképezés a kulcshoz: ',
        'Remove key mapping' => 'Kulcsleképezés eltávolítása',
        'Key mapping' => 'Kulcsleképezés',
        'Map key' => 'Kulcs leképezése',
        'matching the' => 'illeszkedik',
        'to new key' => 'az új kulcsra',
        'Value mapping' => 'Értékleképezés',
        'Map value' => 'Érték leképezése',
        'to new value' => 'az új értékre',
        'Remove value mapping' => 'Értékleképezés eltávolítása',
        'New value map' => 'Új értéktérkép',
        'Add value mapping' => 'Értékleképezés hozzáadása',
        'Do you really want to delete this key mapping?' => 'Valóban törölni szeretné ezt a kulcsleképezést?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Általános gyorsbillentyűk',
        'MacOS Shortcuts' => 'MacOS gyorsbillentyűk',
        'Comment code' => 'Kód megjegyzésbe tétele',
        'Uncomment code' => 'Kód megjegyzés eltávolítása',
        'Auto format code' => 'Kód automatikus formázása',
        'Expand/Collapse code block' => 'Kódblokk kinyitása vagy összecsukása',
        'Find' => 'Keresés',
        'Find next' => 'Következő keresése',
        'Find previous' => 'Előző keresése',
        'Find and replace' => 'Keresés és csere',
        'Find and replace all' => 'Keresés és összes cseréje',
        'XSLT Mapping' => 'XSLT leképezés',
        'XSLT stylesheet' => 'XSLT-stíluslap',
        'The entered data is not a valid XSLT style sheet.' => 'A megadott adat nem érvényes XSLT-stíluslap.',
        'Here you can add or modify your XSLT mapping code.' => 'Itt adhatja hozzá vagy módosíthatja az XSLT leképezés kódját.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'A szerkesztőmező lehetővé teszi különböző függvények használatát, mint például automatikus formázás, ablakátméretezés, valamint címke- és zárójelkiegészítés.',
        'Data includes' => 'Adatfelvételek',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Egy vagy több adathalmaz kiválasztása, amely korábbi kérés/válasz állapotokban lett létrehozva, hogy belekerüljenek a leképezhető adatokba.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Ezek a halmazok az adatszerkezetben fognak megjelenni itt: „/AdatFelvetel/<AdatHalmazNev>” (a részletekért nézze meg az aktuális kérések hibakeresési kimenetét).',
        'Data key regex filters (before mapping)' => 'Adatkulcs reguláris kifejezés szűrők (leképezés előtt)',
        'Data key regex filters (after mapping)' => 'Adatkulcs reguláris kifejezés szűrők (leképezés után)',
        'Regular expressions' => 'Reguláris kifejezések',
        'Replace' => 'Csere',
        'Remove regex' => 'Reguláris kifejezés eltávolítása',
        'Add regex' => 'Reguláris kifejezés hozzáadása',
        'These filters can be used to transform keys using regular expressions.' =>
            'Ezek a szűrők használhatók a kulcsok átalakításához reguláris kifejezések használatával.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'Az adatszerkezet rekurzívan fog áthaladni, és az összes beállított reguláris kifejezés alkalmazva lesz az összes kulcson.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Használati esetek például: olyan kulcselőtagok eltávolítása, amelyek nem szükségesek, illetve olyan kulcsok javítása, amelyek érvénytelenek XML elemnevekként.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '1. példa: a keresés = „^jira:” és a csere = „” átalakítja a „jira:element” kulcsot „element” értékűre.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '2. példa: a keresés = „^” és a csere = „_” átalakítja a „16x16” kulcsot „_16x16” értékűre.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '3. példa: a keresés = „^(?<number>\d+) (?<text>.+?)\$” és a csere = „_\$+{text}_\$+{number}” átalakítja a „16 elemnév” kulcsot „_elemnév_16” értékűre.',
        'For information about regular expressions in Perl please see here:' =>
            'A Perlben lévő reguláris kifelezésekkel kapcsolatos információkat itt nézheti meg:',
        'Perl regular expressions tutorial' => 'Perl reguláris kifejezések ismertető',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Ha módosítók szükségesek, akkor azokat magukban a reguláris kifejezésekben kell megadni.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Az itt meghatározott reguláris kifejezések az XSLT-leképezés előtt lesznek alkalmazva.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Az itt meghatározott reguláris kifejezések az XSLT-leképezés után lesznek alkalmazva.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Művelet hozzáadása',
        'Edit Operation' => 'Művelet szerkesztése',
        'Do you really want to delete this operation?' => 'Valóban törölni szeretné ezt a műveletet?',
        'Operation Details' => 'Művelet részletei',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'A név tipikusan ennek a webszolgáltatás műveletnek a meghívásához használható egy távoli rendszerből.',
        'Operation backend' => 'Műveleti háttérprogram',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ez az OTOBO műveleti háttérprogram modul lesz belsőleg meghívva a kérés feldolgozásához, és az adat előállításához a válasz számára.',
        'Mapping for incoming request data' => 'Leképezés a bejövő kérés adataihoz',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Ez a leképezés fogja a kérés adatait feldolgozni olyan formára alakítva át azokat, ahogy az OTOBO várja.',
        'Mapping for outgoing response data' => 'Leképezés a kimenő válasz adataihoz',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Ez a leképezés fogja a válasz adatait feldolgozni olyan formára alakítva át azokat, ahogy a távoli rendszer várja.',
        'Include Ticket Data' => 'Jegyadatok felvétele',
        'Include ticket data in response.' => 'Jegyadatok felvétele a válaszba.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Hálózati átvitel',
        'Properties' => 'Tulajdonságok',
        'Route mapping for Operation' => 'Útvonal leképezés a művelethez',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Meghatározza azt az útvonalat, amelyet ehhez a művelethez kellene leképezni. A kettősponttal „:” megjelölt változók a megadott névhez lesznek leképezve, és a többivel együtt kerülnek átadásra a leképezéshez. (például /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Érvényes kérési módszerek a művelethez',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ezen művelet korlátozása a megadott kérési módszerekre. Ha nincs módszer kiválasztva, akkor minden kérés el lesz fogadva.',
        'Maximum message length' => 'Legnagyobb üzenethossz',
        'This field should be an integer number.' => 'Ez a mező csak egész szám lehet.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Itt adhatja meg a REST üzenetek legnagyobb méretét (bájtban), amelyeket az OTOBO fel fog dolgozni.',
        'Send Keep-Alive' => 'Életben tartás küldése',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Ez a beállítás azt határozza meg, hogy a bejövő kapcsolatok le legyenek-e zárva vagy maradjanak életben.',
        'Additional response headers' => 'További válasz fejlécek',
        'Add response header' => 'Válasz fejléc hozzáadása',
        'Endpoint' => 'Végpont',
        'URI to indicate specific location for accessing a web service.' =>
            'Adott helyet jelző URI egy webszolgáltatáshoz való hozzáféréshez.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Időkorlát',
        'Timeout value for requests.' => 'Időkorlátérték a kérésekhez.',
        'Authentication' => 'Hitelesítés',
        'An optional authentication mechanism to access the remote system.' =>
            'Egy opcionális hitelesítési mechanizmus a távoli rendszer eléréséhez.',
        'BasicAuth User' => 'Alap hitelesítés felhasználónév',
        'The user name to be used to access the remote system.' => 'A távoli rendszer hozzáféréséhez használandó felhasználónév.',
        'BasicAuth Password' => 'Alap hitelesítés jelszó',
        'The password for the privileged user.' => 'A privilegizált felhasználó jelszava.',
        'Use Proxy Options' => 'Proxybeállítások használata',
        'Show or hide Proxy options to connect to the remote system.' => 'Proxybeállítások megjelenítése vagy elrejtése a távoli rendszerhez való csatlakozáshoz.',
        'Proxy Server' => 'Proxy-kiszolgáló',
        'URI of a proxy server to be used (if needed).' => 'A használandó proxy-kiszolgáló URI-ja (ha szükséges).',
        'e.g. http://proxy_hostname:8080' => 'például http://proxy_hostname:8080',
        'Proxy User' => 'Proxy felhasználó',
        'The user name to be used to access the proxy server.' => 'A proxy-kiszolgáló eléréséhez használandó felhasználónév.',
        'Proxy Password' => 'Proxy jelszó',
        'The password for the proxy user.' => 'A proxy felhasználó jelszava.',
        'Skip Proxy' => 'Proxy kihagyása',
        'Skip proxy servers that might be configured globally?' => 'Kihagyja a proxy-kiszolgálókat, amelyek globálisan állíthatók be?',
        'Use SSL Options' => 'SSL beállítások használata',
        'Show or hide SSL options to connect to the remote system.' => 'SSL beállítások megjelenítése vagy elrejtése a távoli rendszerhez való csatlakozáshoz.',
        'Client Certificate' => 'Kliens tanúsítvány',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Az SSL-kliens tanúsítványfájljának teljes elérési útja és neve (PEM, DER vagy PKCS#12 formátumban kell lennie).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'például /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Kliens tanúsítvány kulcsa',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Az SSL-kliens tanúsítvány kulcsfájljának teljes elérési útja és neve (ha még nem tartalmazza a tanúsítványfájl).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'például /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Kliens tanúsítvány kulcsának jelszava',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'A jelszó az SSL-tanúsítvány megnyitásához, ha a kulcs titkosított.',
        'Certification Authority (CA) Certificate' => 'Hitelesítés-szolgáltató (CA) tanúsítvány',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'A hitelesítés-szolgáltató tanúsítványfájljának teljes elérési útja és neve, amely hitelesíti az SSL tanúsítványt.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'például /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Hitelesítés-szolgáltató (CA) könyvtár',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'A hitelesítés-szolgáltató könyvtárának teljes elérési útja, ahol a CA tanúsítványok tárolva vannak a fájlrendszeren.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'például /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Vezérlő leképezés a meghívóhoz',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Az a vezérlő, amelyhez a meghívónak kéréseket kell küldenie. A kettősponttal „:” megjelölt változók az adatok értékével lesznek helyettesítve és a kéréssel együtt kerülnek átadásra. (például /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Érvényes kérés parancs a meghívóhoz',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'A kérésekhez használandó megadott HTTP parancs ezzel a meghívóval (opcionális).',
        'Default command' => 'Alapértelmezett parancs',
        'The default HTTP command to use for the requests.' => 'A kéréseknél használandó alapértelmezett HTTP parancs.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'például https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'SOAP-művelet beállítása',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Állítsa „Igen” értékre egy kitöltött SOAP-művelet fejléc küldéséhez.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Állítsa „Nem” értékre egy üres SOAP-művelet fejléc küldéséhez.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Állítsa „Igen” értékre a fogadott SOAP-művelet fejlécének ellenőrzéséhez (ha nem üres).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Állítsa „Nem” értékre a fogadott SOAP-művelet fejlécének figyelmen kívül hagyásához.',
        'SOAPAction scheme' => 'SOAP-művelet séma',
        'Select how SOAPAction should be constructed.' => 'Válassza ki, hogy a SOAP-műveletet hogyan kell megszerkeszteni.',
        'Some web services require a specific construction.' => 'Néhány webszolgáltatás különleges szerkezetet igényel.',
        'Some web services send a specific construction.' => 'Néhány webszolgáltatás különleges szerkezetet küld.',
        'SOAPAction separator' => 'SOAP-művelet elválasztó',
        'Character to use as separator between name space and SOAP operation.' =>
            'Az elválasztóként használt karakter a névtér és a SOAP-művelet között.',
        'Usually .Net web services use "/" as separator.' => 'Általában a .Net webszolgáltatások „/” karaktert használnak elválasztóként.',
        'SOAPAction free text' => 'SOAP-művelet szabad szövege',
        'Text to be used to as SOAPAction.' => 'SOAP-műveletként használandó szöveg.',
        'Namespace' => 'Névtér',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI egy környezethez való SOAP metódusok adásához csökkentve a kétértelműséget.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'például urn:otobo-com:soap:functions vagy http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Kérés névséma',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Válassza ki, hogy a SOAP-kérés függvénycsomagolót hogyan kell felépíteni.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            'A „FunctionName” példaként van használva az aktuális meghívó/művelet nevénél.',
        '\'FreeText\' is used as example for actual configured value.' =>
            'A „FreeText” példaként van használva az aktuális beállított értéknél.',
        'Request name free text' => 'Kérés nevének szabad szövege',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Függvénycsomagoló név utótagként vagy helyettesítőként használandó szöveg.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Legyen tekintettel az XML-elem elnevezési korlátozásaira (például ne használja a „<” és az „&” karaktereket).',
        'Response name scheme' => 'Válasz névséma',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Válassza ki, hogy a SOAP-válasz függvénycsomagolót hogyan kell felépíteni.',
        'Response name free text' => 'Kérés nevének szabad szövege',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Itt adhatja meg a SOAP üzenetek legnagyobb méretét (bájtban), amelyeket az OTOBO fel fog dolgozni.',
        'Encoding' => 'Kódolás',
        'The character encoding for the SOAP message contents.' => 'A SOAP üzenettartalmak karakterkódolása.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'például utf-8, latin1, iso-8859-1, cp1250, stb.',
        'Sort options' => 'Rendezési beállítások',
        'Add new first level element' => 'Új első szintű elem hozzáadása',
        'Element' => 'Elem',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Kimenő rendezési sorrend az XML-mezőknél (a szerkezet a függvénynév csomagoló alatt indul) – nézze meg a SOAP-átvitel dokumentációját.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webszolgáltatás hozzáadása',
        'Edit Web Service' => 'Webszolgáltatás szerkesztése',
        'Clone Web Service' => 'Webszolgáltatás klónozása',
        'The name must be unique.' => 'A névnek egyedinek kell lennie.',
        'Clone' => 'Klónozás',
        'Export Web Service' => 'Webszolgáltatás exportálása',
        'Import web service' => 'Webszolgáltatás importálása',
        'Configuration File' => 'Beállítófájl',
        'The file must be a valid web service configuration YAML file.' =>
            'A fájlnak érvényes webszolgáltatás-beállító YAML fájlnak kell lennie.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Itt adhat egy nevet a webszolgáltatásnak. Ha a mező üres, akkor a beállítófájl neve lesz névként használva.',
        'Import' => 'Importálás',
        'Configuration History' => 'Beállítási előzmények',
        'Delete web service' => 'Webszolgáltatás törlése',
        'Do you really want to delete this web service?' => 'Valóban törölni szeretné ezt a webszolgáltatást?',
        'Ready2Adopt Web Services' => 'Használatra kész webszolgáltatások',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Itt kapcsolhatja be a legjobb gyakorlatainkat bemutató, használatra kész webszolgáltatásokat, amelyek az %s részei.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Ne feledje, hogy ezen webszolgáltatások függhetnek olyan egyéb moduloktól, amelyek csak bizonyos %s szerződési szintekkel érhetők el (lesz egy értesítés a további részletekkel az importáláskor).',
        'Import Ready2Adopt web service' => 'Használatra kész webszolgáltatás importálása',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            'Szeretné élvezni a szakértők által létrehozott webszolgáltatások előnyeit? Ahhoz, hogy importálhasson néhány kitapasztalt, használatra kész webszolgáltatást, frissítsen a következőre: %s.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'A beállítások mentése után ismét átirányításra kerül a szerkesztő képernyőre.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ha vissza szeretne térni az áttekintőre, kattintson a „Ugrás az áttekintőhöz” gombra.',
        'Remote system' => 'Távoli rendszer',
        'Provider transport' => 'Szolgáltató átvitel',
        'Requester transport' => 'Kérő átvitel',
        'Debug threshold' => 'Hibakeresési küszöbszint',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Szolgáltató módban az OTOBO olyan webszolgáltatásokat javasol, amelyeket a távoli rendszerek használnak.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Kérő módban az OTOBO a távoli rendszerek webszolgáltatásait használja.',
        'Network transport' => 'Hálózati átvitel',
        'Error Handling Modules' => 'Hibakezelési modulok',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'A hibakezelési modulok arra használhatók, hogy a kommunikáció során történt hibák esetén reagáljanak. Azok a modulok egy adott sorrendben lesznek végrehajtva, amely „fog és vidd” módon változtatható meg.',
        'Backend' => 'Háttérprogram',
        'Add error handling module' => 'Hibakezelési modul hozzáadása',
        'Operations are individual system functions which remote systems can request.' =>
            'A műveletek olyan egyedi rendszerfunkciók, amelyeket a távoli rendszerek kérhetnek.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'A meghívók előkészítik az adatokat egy távoli webszolgáltatáshoz intézendő kéréshez, és feldolgozzák a válasz adatait.',
        'Controller' => 'Vezérlő',
        'Inbound mapping' => 'Bejövő leképezés',
        'Outbound mapping' => 'Kimenő leképezés',
        'Delete this action' => 'Művelet törlése',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Legalább egy %s olyan vezérlővel rendelkezik, amely vagy nem aktív, vagy nincs jelen. Ellenőrizze a vezérlő regisztrációját, vagy törölje a következőt: %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Előzmények',
        'Go back to Web Service' => 'Vissza a webszolgáltatáshoz',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Itt tekintheti meg a jelenlegi webszolgáltatás beállításának régebbi verzióit, exportálhatja vagy akár vissza is állíthatja azokat.',
        'Configuration History List' => 'Beállítási előzmények listája',
        'Version' => 'Verzió',
        'Create time' => 'Létrehozás ideje',
        'Select a single configuration version to see its details.' => 'Válasszon egy egyszerű beállítási verziót a részletei megtekintéséhez.',
        'Export web service configuration' => 'Webszolgáltatás-beállítás exportálása',
        'Restore web service configuration' => 'Webszolgáltatás-beállítás visszaállítása',
        'Do you really want to restore this version of the web service configuration?' =>
            'Valóban vissza szeretné állítani a webszolgáltatás beállításának ezen verzióját?',
        'Your current web service configuration will be overwritten.' => 'A jelenlegi webszolgáltatás-beállítás felül lesz írva.',

        # Template: AdminGroup
        'Group Management' => 'Csoportkezelés',
        'Add Group' => 'Csoport hozzáadása',
        'Edit Group' => 'Csoport szerkesztése',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Az admin csoport az adminisztrációs területre, a stats csoport a statisztika területre való bejutáshoz van.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Új csoportok létrehozása a hozzáférési jogosultságok kezeléséhez az ügyintézők különböző csoportjainál (például beszerzési részleg, támogató részleg, értékesítési részleg, …). ',
        'It\'s useful for ASP solutions. ' => 'Ez ASP megoldásoknál hasznos. ',

        # Template: AdminLog
        'System Log' => 'Rendszernapló',
        'Here you will find log information about your system.' => 'Itt napló információkat fog találni a rendszeréről.',
        'Hide this message' => 'Üzenet elrejtése',
        'Recent Log Entries' => 'Legutóbbi naplóbejegyzések',
        'Facility' => 'Összetevő',
        'Message' => 'Üzenet',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Levelezőfiók-kezelés',
        'Add Mail Account' => 'Levelezőfiók hozzáadása',
        'Edit Mail Account for host' => 'Levelezőfiók szerkesztése a géphez',
        'and user account' => 'és a felhasználói fiókhoz',
        'Filter for Mail Accounts' => 'Szűrő a levelezőfiókokhoz',
        'Filter for mail accounts' => 'Szűrő a levelezőfiókokhoz',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Az összes fiókkal rendelkező bejövő e-mail a kiválasztott várólistába lesz kézbesítve.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Ha a fiókja megbízhatóként van megjelölve, akkor az érkezési időben már meglévő X-OTOBO fejlécek (a prioritáshoz, stb.) meg lesznek tartva és használva lesznek, például a levelezési szűrőkben.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'A kimenő e-mail a Sendmail* beállításokon keresztül állítható be itt: %s.',
        'System Configuration' => 'Rendszerbeállítások',
        'Host' => 'Kiszolgáló',
        'Delete account' => 'Fiók törlése',
        'Fetch mail' => 'Levél lekérése',
        'Do you really want to delete this mail account?' => 'Valóban törölni szeretné ezt a levelezési fiókot?',
        'Example: mail.example.com' => 'Példa: mail.example.com',
        'IMAP Folder' => 'IMAP mappa',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ezt csak akkor módosítsa, ha az INBOX mappától eltérőből szükséges a levél lekérése.',
        'Trusted' => 'Megbízható',
        'Dispatching' => 'Kézbesítés',
        'Edit Mail Account' => 'Levelezőfiók szerkesztése',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Adminisztrációs áttekintő',
        'Filter for Items' => 'Szűrő az elemekhez',
        'Favorites' => 'Kedvencek',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Hozzáadhat kedvenceket, ha a kurzort a jobb oldalon lévő elemek fölé viszi, és a csillag ikonra kattint.',
        'Links' => 'Hivatkozások',
        'View the admin manual on Github' => 'Az adminisztrátori kézikönyv megtekintése a GitHubon',
        'No Matches' => 'Nincs találat',
        'Sorry, your search didn\'t match any items.' => 'Sajnáljuk, a keresése nem illeszkedik egyetlen elemre sem.',
        'Set as favorite' => 'Beállítás kedvencként',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Jegyértesítés-kezelés',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Itt tud egy beállítófájlt feltölteni a jegyértesítések importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy a jegyértesítés modul exportálta.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Itt választhatja ki, hogy mely események fogják aktiválni ezt az értesítést. Egy további jegyszűrő alkalmazható lent a csak egy bizonyos feltétellel rendelkező jegynél történő küldéshez.',
        'Ticket Filter' => 'Jegyszűrő',
        'Lock' => 'Zárolás',
        'SLA' => 'SLA',
        'Customer User ID' => 'Ügyfél-felhasználó azonosítója',
        'Article Filter' => 'Bejegyzés szűrő',
        'Only for ArticleCreate and ArticleSend event' => 'Csak ArticleCreate és ArticleSend eseménynél',
        'Article sender type' => 'Bejegyzés küldő típus',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Ha az ArticleCreate vagy ArticleSend aktiváló eseményként van használva, meg kell adnia egy bejegyzés szűrőt is. Válasszon legalább egyet a bejegyzés szűrő mezőkből.',
        'Customer visibility' => 'Ügyfél láthatóság',
        'Communication channel' => 'Kommunikációs csatorna',
        'Include attachments to notification' => 'Mellékletek felvétele az értesítésbe',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'A felhasználó értesítése csak egyszer egy nap egy egyedüli jegyről egy kiválasztott átvitel használatával.',
        'This field is required and must have less than 4000 characters.' =>
            'Ez a mező kötelező, és rövidebbnek kell lennie 4000 karakternél.',
        'Notifications are sent to an agent or a customer.' => 'Az értesítések ügyintézőnek vagy ügyfélnek kerülnek elküldésre.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '(A legutóbbi ügyintéző bejegyzés) tárgya első 20 karakterének lekéréséhez.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '(A legutóbbi ügyintéző bejegyzés) törzse első 5 sorának lekéréséhez.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '(A legutóbbi ügyfél bejegyzés) tárgya első 20 karakterének lekéréséhez.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '(A legutóbbi ügyfél bejegyzés) törzse első 5 sorának lekéréséhez.',
        'Attributes of the current customer user data' => 'A jelenlegi ügyfél-felhasználó adatainak jellemzői',
        'Attributes of the current ticket owner user data' => 'A jelenlegi jegytulajdonos felhasználóadatainak jellemzői',
        'Attributes of the current ticket responsible user data' => 'A jelenlegi jegyfelelős felhasználóadatainak jellemzői',
        'Attributes of the current agent user who requested this action' =>
            'A jelenlegi ügyintéző-felhasználó jellemzői, aki ezt a műveletet kérte',
        'Attributes of the ticket data' => 'A jegy adatainak jellemzői',
        'Ticket dynamic fields internal key values' => 'A jegy dinamikus mezőinek belső kulcs értékei',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'A jegy dinamikus mezőinek megjelenített értékei, legördülő és többválasztós mezőknél hasznos',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Használjon vesszőt vagy pontosvesszőt az e-mail címek elválasztásához.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Használhatja az OTOBO címkéket (mint például <OTOBO_TICKET_DynamicField_...>) értékek beszúrásához a jelenlegi jegyből.',

        # Template: AdminPGP
        'PGP Management' => 'PGP kezelés',
        'Add PGP Key' => 'PGP kulcs hozzáadása',
        'PGP support is disabled' => 'A PGP támogatás le van tiltva',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Hogy képes legyen PGP-t használni az OTOBO-ben, ahhoz először engedélyeznie kell azt.',
        'Enable PGP support' => 'PGP támogatás engedélyezése',
        'Faulty PGP configuration' => 'Hibás PGP beállítás',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'A PGP támogatás engedélyezve van, de a hozzá tartozó beállítások hibákat tartalmaznak. Ellenőrizze a beállításokat a lenti gomb használatával.',
        'Configure it here!' => 'Itt állítsa be!',
        'Check PGP configuration' => 'PGP beállítások ellenőrzése',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Ezzel a módszerrel közvetlenül szerkesztheti a kulcstartót, amit a rendszer beállításainál beállított.',
        'Introduction to PGP' => 'Bevezetés a PGP-be',
        'Bit' => 'Bit',
        'Fingerprint' => 'Ujjlenyomat',
        'Expires' => 'Lejárat',
        'Delete this key' => 'Kulcs törlése',
        'PGP key' => 'PGP kulcs',

        # Template: AdminPackageManager
        'Package Manager' => 'Csomagkezelő',
        'Uninstall Package' => 'Csomag eltávolítása',
        'Uninstall package' => 'Csomag eltávolítása',
        'Do you really want to uninstall this package?' => 'Valóban el szeretné távolítani ezt a csomagot?',
        'Reinstall package' => 'Csomag újratelepítése',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Valóban újra szeretné telepíteni ezt a csomagot? Minden kézi változtatás el fog veszni.',
        'Go to updating instructions' => 'Ugrás a frissítési utasításokhoz',
        'Go to the OTOBO customer portal' => 'Ugrás az OTOBO ügyfélportáljára',
        'package information' => 'csomaginformációk',
        'Package installation requires a patch level update of OTOBO.' =>
            'A csomagtelepítés az OTOBO hibajavító szintű frissítését igényli.',
        'Package update requires a patch level update of OTOBO.' => 'A csomagfrissítés az OTOBO hibajavító szintű frissítését igényli.',
        'Please note that your installed OTOBO version is %s.' => 'Ne feledje, hogy a telepített OTOBO verziója %s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'A csomag telepítéséhez frissítenie kell az OTOBO-t %s vagy újabb verzióra.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Ez a csomag csak az OTOBO %s vagy régebbi verziójára telepíthető.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Ez a csomag csak az OTOBO %s vagy újabb verziójára telepíthető.',
        'Why should I keep OTOBO up to date?' => 'Miért kell naprakészen tartanom az OTOBO-t?',
        'You will receive updates about relevant security issues.' => 'Frissítéseket fog kapni a fontos biztonsági problémákról.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Frissítéseket fog kapni minden egyéb fontos OTOBO problémáról.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Hogyan végezhetek hibajavító szintű frissítést, ha nincs szerződésem?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Nézze meg az összes fontos információt a frissítési utasításokban itt: %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Abban az esetben, ha további kérdései vannak, szívesen megválaszoljuk azokat.',
        'Please visit our customer portal and file a request.' => 'Látogassa meg az ügyfélportálunkat, és küldjön egy kérést.',
        'Install Package' => 'Csomag telepítése',
        'Update Package' => 'Csomag frissítése',
        'Continue' => 'Folytatás',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Győződjön meg arról, hogy az adatbázisa elfogad-e %s MB méretűnél nagyobb csomagot (jelenleg csak legfeljebb %s MB méretű csomagot fogad el). A hibák elkerülése érdekében alkalmazkodjon az adatbázisa max_allowed_packet beállításához.',
        'Install' => 'Telepítés',
        'Update repository information' => 'Tároló-információk frissítése',
        'Cloud services are currently disabled.' => 'A felhőszolgáltatások jelenleg le vannak tiltva.',
        'OTOBO Verify can not continue!' => 'Az OTOBO Verify nem folytatható!',
        'Enable cloud services' => 'Felhőszolgáltatások engedélyezése',
        'Update all installed packages' => 'Az összes telepített csomag frissítése',
        'Online Repository' => 'Online tároló',
        'Vendor' => 'Gyártó',
        'Action' => 'Művelet',
        'Module documentation' => 'Modul-dokumentáció',
        'Local Repository' => 'Helyi tároló',
        'This package is verified by OTOBOverify (tm)' => 'Ezt a csomagot az OTOBOverify (tm) ellenőrizte',
        'Uninstall' => 'Eltávolítás',
        'Package not correctly deployed! Please reinstall the package.' =>
            'A csomag nincs megfelelően üzembe állítva! Telepítse újra a csomagot.',
        'Reinstall' => 'Újratelepítés',
        'Features for %s customers only' => 'Kizárólag %s ügyfelek számára elérhető funkciók',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Az %s használatával a következő opcionális szolgáltatások előnyeit élvezheti. Ha további információkra van szüksége, akkor vegye fel a kapcsolatot a következővel: %s.',
        'Package Information' => 'Csomaginformációk',
        'Download package' => 'Csomag letöltése',
        'Rebuild package' => 'Csomag újraépítése',
        'Metadata' => 'Metaadatok',
        'Change Log' => 'Változásnapló',
        'Date' => 'Dátum',
        'List of Files' => 'Fájlok listája',
        'Permission' => 'Jogosultság',
        'Download file from package!' => 'Fájl letöltése a csomagból!',
        'Required' => 'Kötelező',
        'Primary Key' => 'Elsődleges kulcs',
        'Auto Increment' => 'Automatikus növelés',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Fájleltérések ezzel a fájllal: %s',
        'File differences for file %s' => 'Fájleltérések ezzel a fájllal: %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Teljesítmény napló',
        'Range' => 'Tartomány',
        'last' => 'utolsó',
        'This feature is enabled!' => 'Ez a szolgáltatás engedélyezve van!',
        'Just use this feature if you want to log each request.' => 'Csak akkor használja ezt a szolgáltatást, ha minden egyes kérést naplózni szeretne.',
        'Activating this feature might affect your system performance!' =>
            'A szolgáltatás aktiválása hatással lehet a rendszer teljesítményére!',
        'Disable it here!' => 'Itt tiltsa le!',
        'Logfile too large!' => 'A naplófájl túl nagy!',
        'The logfile is too large, you need to reset it' => 'A naplófájl túl nagy, vissza kell állítania azt',
        'Interface' => 'Felület',
        'Requests' => 'Kérések',
        'Min Response' => 'Legkisebb válasz',
        'Max Response' => 'Legnagyobb válasz',
        'Average Response' => 'Átlagos válasz',
        'Period' => 'Időszak',
        'minutes' => 'perc',
        'Min' => 'Legkisebb',
        'Max' => 'Legnagyobb',
        'Average' => 'Átlag',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Levelezési szűrő kezelés',
        'Add PostMaster Filter' => 'Levelezési szűrő hozzáadása',
        'Edit PostMaster Filter' => 'Levelezési szűrő szerkesztése',
        'Filter for PostMaster Filters' => 'Szűrő a levelezési szűrőkhöz',
        'Filter for PostMaster filters' => 'Szűrő a levelezési szűrőkhöz',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Az e-mail fejléceken alapuló bejövő e-mailek kézbesítéséhez vagy szűréséhez. A reguláris kifejezések használatával való illesztés szintén lehetséges.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Ha csak az e-mail cím egyezését szeretné vizsgálni, használja az EMAILADDRESS:info@example.com kifejezést a feladó, a címzett vagy a másolat mezőkben.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Ha reguláris kifejezéseket használ, akkor a () belsejében lévő egyező értéket is használhatja [***] formában a „Beállítás” műveletben.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Használhat nevesített elfogásokat is %s, és használhatja a neveket a „Beállítás” műveletben %s (például reguláris kifejezés: %s, Beállítás művelet: %s). Az illesztett EMAILADDRESS a következő nevet kapja: „%s”.',
        'Delete this filter' => 'Szűrő törlése',
        'Do you really want to delete this postmaster filter?' => 'Valóban törölni szeretné ezt a levelezési szűrőt?',
        'A postmaster filter with this name already exists!' => 'Már létezik ilyen nevű levelezési szűrő!',
        'Filter Condition' => 'Szűrőfeltétel',
        'AND Condition' => 'ÉS feltétel',
        'Search header field' => 'Keresés a fejlécmezőben',
        'for value' => 'erre az értékre',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ennek a mezőnek érvényes reguláris kifejezésnek vagy szóliterálnak kell lennie.',
        'Negate' => 'Tagadás',
        'Set Email Headers' => 'E-mail fejlécek beállítása',
        'Set email header' => 'E-mail fejléc beállítása',
        'with value' => 'ezzel az értékkel',
        'The field needs to be a literal word.' => 'Ennek a mezőnek szóliterálnak kell lennie.',
        'Header' => 'Fejléc',

        # Template: AdminPriority
        'Priority Management' => 'Prioritás-kezelés',
        'Add Priority' => 'Prioritás hozzáadása',
        'Edit Priority' => 'Prioritás szerkesztése',
        'Filter for Priorities' => 'Szűrő a prioritásokhoz',
        'Filter for priorities' => 'Szűrő a prioritásokhoz',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Ez a prioritás megtalálható egy rendszerbállításban, az új prioritásra mutató beállítások frissítésének megerősítése szükséges!',
        'This priority is used in the following config settings:' => 'Ez a prioritás a következő konfigurációs beállításokban van használva:',

        # Template: AdminProcessManagement
        'Process Management' => 'Folyamatkezelés',
        'Filter for Processes' => 'Szűrő a folyamatokhoz',
        'Filter for processes' => 'Szűrő a folyamatokhoz',
        'Create New Process' => 'Új folyamat létrehozása',
        'Deploy All Processes' => 'Minden folyamat üzembe állítása',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Itt tölthet fel egy beállítófájlt egy folyamat importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy a folyamatkezelő modul exportálta.',
        'Upload process configuration' => 'Folyamat-beállítás feltöltése',
        'Import process configuration' => 'Folyamat-beállítás importálása',
        'Ready2Adopt Processes' => 'Használatra kész folyamatok',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Itt kapcsolhatja be a legjobb gyakorlatainkat bemutató, használatra kész folyamatokat. Ne feledje, hogy néhány további beállítás lehet szükséges.',
        'Import Ready2Adopt process' => 'Használatra kész folyamat importálása',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Egy új folyamat létrehozásához importálhat egy másik rendszerből exportált folyamatot, vagy létrehozhat egy teljesen újat.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'A folyamatokon itt elvégzett módosítás csak akkor lesz hatással a rendszer viselkedésére, ha szinkronizálja a folyamatadatokat. A folyamatok szinkronizálásával az újonnan elvégzett módosítások be lesznek írva a beállításokba.',
        'Processes' => 'Folyamatok',
        'Process name' => 'Folyamat neve',
        'Print' => 'Nyomtatás',
        'Export Process Configuration' => 'Folyamat-beállítás exportálása',
        'Copy Process' => 'Folyamat másolása',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Megszakítás és bezárás',
        'Go Back' => 'Vissza',
        'Please note, that changing this activity will affect the following processes' =>
            'Ne feledje, hogy a tevékenység megváltoztatása érinteni fogja a következő folyamatokat',
        'Activity' => 'Tevékenység',
        'Activity Name' => 'Tevékenység neve',
        'Activity Dialogs' => 'Tevékenység párbeszédek',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Tevékenység párbeszédeket rendelhet hozzá ehhez a tevékenységhez, ha az elemeket bal oldali listából a jobb oldali listába húzza az egérrel.',
        'Filter available Activity Dialogs' => 'Elérhető tevékenység párbeszédek szűrése',
        'Available Activity Dialogs' => 'Elérhető tevékenység párbeszédek',
        'Name: %s, EntityID: %s' => 'Név: %s, egyedazonosító: %s',
        'Create New Activity Dialog' => 'Új tevékenység párbeszéd létrehozása',
        'Assigned Activity Dialogs' => 'Hozzárendelt tevékenység párbeszédek',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Ne feledje, hogy a tevékenység párbeszéd módosítása érinteni fogja a következő tevékenységeket',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Ne feledje, hogy az ügyfél-felhasználók nem lesznek képesek megtekinteni vagy használni a következő mezőket: tulajdonos, felelős, zár, várakozási idő, ügyfél-azonosító.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Az ügyfelek csak a várólista mezőt használhatják egy új jegy létrehozásakor.',
        'Activity Dialog' => 'Tevékenység párbeszéd',
        'Activity dialog Name' => 'Tevékenység párbeszéd neve',
        'Available in' => 'Elérhető ebben',
        'Description (short)' => 'Leírás (rövid)',
        'Description (long)' => 'Leírás (hosszú)',
        'The selected permission does not exist.' => 'A kijelölt jogosultság nem létezik.',
        'Required Lock' => 'Zárolás szükséges',
        'The selected required lock does not exist.' => 'A kijelölt szükséges zárolás nem létezik.',
        'Submit Advice Text' => 'Elküldés értesítőszövege',
        'Submit Button Text' => 'Elküldés gomb szövege',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Mezőket rendelhet hozzá ehhez a tevékenység párbeszédhez, ha az elemeket bal oldali listából a jobb oldali listába húzza az egérrel.',
        'Filter available fields' => 'Elérhető mezők szűrése',
        'Available Fields' => 'Elérhető mezők',
        'Assigned Fields' => 'Hozzárendelt mezők',
        'Communication Channel' => 'Kommunikációs csatorna',
        'Is visible for customer' => 'Látható az ügyfélnek',
        'Display' => 'Megjelenítés',

        # Template: AdminProcessManagementPath
        'Path' => 'Útvonal',
        'Edit this transition' => 'Átmenet szerkesztése',
        'Transition Actions' => 'Átmenet műveletek',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Átmenet műveleteket rendelhet hozzá ehhez az átmenethez, ha az elemeket bal oldali listából a jobb oldali listába húzza az egérrel.',
        'Filter available Transition Actions' => 'Elérhető átmenet műveletek szűrése',
        'Available Transition Actions' => 'Elérhető átmenet műveletek',
        'Create New Transition Action' => 'Új átmenet művelet létrehozása',
        'Assigned Transition Actions' => 'Hozzárendelt átmenet műveletek',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Tevékenységek',
        'Filter Activities...' => 'Tevékenységek szűrése…',
        'Create New Activity' => 'Új tevékenység létrehozása',
        'Filter Activity Dialogs...' => 'Tevékenység párbeszédek szűrése…',
        'Transitions' => 'Átmenetek',
        'Filter Transitions...' => 'Átmenetek szűrése…',
        'Create New Transition' => 'Új átmenet létrehozása',
        'Filter Transition Actions...' => 'Átmenet műveletek szűrése…',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Folyamat szerkesztése',
        'Print process information' => 'Folyamat-információk nyomtatása',
        'Delete Process' => 'Folyamat törlése',
        'Delete Inactive Process' => 'Inaktív folyamat törlése',
        'Available Process Elements' => 'Elérhető folyamatelemek',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Az ezen az oldalsávon fent felsorolt elemek áthelyezhetők a jobb oldali vászonterületre fogd és vidd módon.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Tevékenységeket helyezhet a vászonterületre a tevékenység hozzárendeléséhez a folyamathoz.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Egy tevékenység párbeszéd hozzárendeléséhez egy folyamathoz húzza a tevékenység párbeszédelemet a tevékenység fölött elhelyezett oldalsávról a vászonterületre.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Kapcsolatot létesíthet két tevékenység között, ha az átmenet elemet a kapcsolat kezdő tevékenysége fölé ejti. Ezután viheti a nyíl szabad végét a befejező tevékenységre.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Műveletek rendelhetők egy átmenethez, ha a műveletelemet egy átmenet címkéjére ejti.',
        'Edit Process Information' => 'Folyamat-információk szerkesztése',
        'Process Name' => 'Folyamat neve',
        'The selected state does not exist.' => 'A kijelölt állapot nem létezik.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Tevékenységek, tevékenység párbeszédek és átmenetek hozzáadása és szerkesztése',
        'Show EntityIDs' => 'Entitás-azonosítók megjelenítése',
        'Extend the width of the Canvas' => 'A vászon szélességének kibővítése',
        'Extend the height of the Canvas' => 'A vászon magasságának kibővítése',
        'Remove the Activity from this Process' => 'Tevékenység eltávolítása ebből a folyamatból',
        'Edit this Activity' => 'Tevékenység szerkesztése',
        'Save Activities, Activity Dialogs and Transitions' => 'Tevékenységek, tevékenység párbeszédek és átmenetek mentése',
        'Do you really want to delete this Process?' => 'Valóban törölni szeretné ezt a folyamatot?',
        'Do you really want to delete this Activity?' => 'Valóban törölni szeretné ezt a tevékenységet?',
        'Do you really want to delete this Activity Dialog?' => 'Valóban törölni szeretné ezt a tevékenység párbeszédet?',
        'Do you really want to delete this Transition?' => 'Valóban törölni szeretné ezt az átmenetet?',
        'Do you really want to delete this Transition Action?' => 'Valóban törölni szeretné ezt az átmenet műveletet?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Valóban el szeretné távolítani ezt a tevékenységet a vászonról? Ezt csak akkor lehet változatlanul hagyni, ha mentés nélkül hagyja el ezt a képernyőt.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Valóban el szeretné távolítani ezt az átmenetet a vászonról? Ezt csak akkor lehet változatlanul hagyni, ha mentés nélkül hagyja el ezt a képernyőt.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Ezen a képernyőn hozhat létre új folyamatot. Annak érdekében, hogy az új folyamatot elérhetővé tegye a felhasználóknak, győződjön meg arról, hogy „Aktívra” állította az állapotát, és szinkronizálta a munka befejezése után.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'megszakítás és bezárás',
        'Start Activity' => 'Tevékenység indítása',
        'Contains %s dialog(s)' => '%s párbeszédet tartalmaz',
        'Assigned dialogs' => 'Hozzárendelt párbeszédek',
        'Activities are not being used in this process.' => 'Ebben a folyamatban nem használnak tevékenységeket.',
        'Assigned fields' => 'Hozzárendelt mezők',
        'Activity dialogs are not being used in this process.' => 'Ebben a folyamatban nem használnak tevékenység párbeszédeket.',
        'Condition linking' => 'Feltétel kapcsolása',
        'Transitions are not being used in this process.' => 'Ebben a folyamatban nem használnak átmeneteket.',
        'Module name' => 'Modulnév',
        'Transition actions are not being used in this process.' => 'Ebben a folyamatban nem használnak átmenet műveleteket.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Ne feledje, hogy az átmenet módosítása érinteni fogja a következő folyamatokat',
        'Transition' => 'Átmenet',
        'Transition Name' => 'Átmenet neve',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Ne feledje, hogy az átmenet művelet módosítása érinteni fogja a következő folyamatokat',
        'Transition Action' => 'Átmenet művelet',
        'Transition Action Name' => 'Átmenet művelet neve',
        'Transition Action Module' => 'Átmenet művelet modul',
        'Config Parameters' => 'Beállítási paraméterek',
        'Add a new Parameter' => 'Új paraméter hozzáadása',
        'Remove this Parameter' => 'Paraméter eltávolítása',

        # Template: AdminQueue
        'Queue Management' => 'Várólista-kezelés',
        'Add Queue' => 'Várólista hozzáadása',
        'Edit Queue' => 'Várólista szerkesztése',
        'Filter for Queues' => 'Szűrő a várólistákhoz',
        'Filter for queues' => 'Szűrő a várólistákhoz',
        'A queue with this name already exists!' => 'Már létezik ilyen nevű várólista!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Ez a várólista megtalálható egy rendszerbállításban, az új várólistára mutató beállítások frissítésének megerősítése szükséges!',
        'Sub-queue of' => 'Alvárólistája ennek',
        'Unlock timeout' => 'Feloldási időkorlát',
        '0 = no unlock' => '0 = nincs feloldás',
        'hours' => 'óra',
        'Only business hours are counted.' => 'Csak a nyitva tartás számít.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Ha egy ügyintéző zárol egy jegyet, és nem zárja le a feloldási időkorlát elérése előtt, akkor a jegy fel lesz oldva, és elérhetővé válik más ügyintézőknek.',
        'Notify by' => 'Értesítés',
        '0 = no escalation' => '0 = nincs eszkaláció',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Ha az új jegyhez nem lett ügyfél-elérhetőség – külső e-mail cím vagy telefon – hozzáadva az itt megadott idő lejárta előtt, a jegy eszkalálva lesz.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Ha hozzá lett adva egy bejegyzés, úgymint követő e-mail vagy ügyfélportál, az eszkaláció frissítési ideje vissza lesz állítva. Ha nincs ügyfél-elérhetőség – külső e-mail cím vagy telefon – hozzáadva az itt megadott idő lejárta előtt, a jegy eszkalálva lesz.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ha a jegy nem lett lezártra állítva az itt megadott idő lejárta előtt, a jegy eszkalálva lesz.',
        'Follow up Option' => 'Követés beállítás',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Megadja, hogy a lezárt jegyek követése újranyissa a jegyet, elutasítsa, vagy egy új jegyhez vezessen.',
        'Ticket lock after a follow up' => 'Jegy zárolása egy követés után',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ha egy jegy le van zárva, és az ügyfél egy követést küld, a jegy zárolva lesz a régi tulajdonosnak.',
        'System address' => 'Rendszercím',
        'Will be the sender address of this queue for email answers.' => 'Lesz-e a várólista feladójának címe a válasz e-mailekhez.',
        'Default sign key' => 'Alapértelmezett aláíró kulcs',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Egy aláíró kulcs használatához azonosítókkal rendelkező PGP kulcsokat vagy S/MIME tanúsítványokat kell hozzáadni a kiválasztott várólista rendszercíméhez.',
        'Salutation' => 'Megszólítás',
        'The salutation for email answers.' => 'A megszólítás a válasz e-mailekhez.',
        'Signature' => 'Aláírás',
        'The signature for email answers.' => 'Az aláírás a válasz e-mailekhez.',
        'This queue is used in the following config settings:' => 'Ez a várólista a következő konfigurációs beállításokban van használva:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Várólista–Automatikus válasz kapcsolatok kezelése',
        'Change Auto Response Relations for Queue' => 'Automatikus válasz kapcsolatok megváltoztatása egy várólistánál',
        'This filter allow you to show queues without auto responses' => 'Ez a szűrő lehetővé teszi az automatikus válaszok nélküli várólisták megjelenítést',
        'Queues without Auto Responses' => 'Várólisták automatikus válaszok nélkül',
        'This filter allow you to show all queues' => 'Ez a szűrő lehetővé teszi az összes várólista megjelenítést',
        'Show All Queues' => 'Az összes várólista megjelenítése',
        'Auto Responses' => 'Automatikus válaszok',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Sablon–Várólista kapcsolatok kezelése',
        'Filter for Templates' => 'Szűrő a sablonokhoz',
        'Filter for templates' => 'Szűrő a sablonokhoz',
        'Templates' => 'Sablonok',

        # Template: AdminRegistration
        'System Registration Management' => 'Rendszer regisztráció kezelés',
        'Edit System Registration' => 'Rendszer regisztráció szerkesztése',
        'System Registration Overview' => 'Rendszer regisztráció áttekintője',
        'Register System' => 'Rendszer regisztrálása',
        'Validate OTOBO-ID' => 'OTOBO-azonosító ellenőrzése',
        'Deregister System' => 'Rendszer regisztrációjának törlése',
        'Edit details' => 'Részletek szerkesztése',
        'Show transmitted data' => 'Átvitt adatok megtekintése',
        'Deregister system' => 'Rendszer regisztrációjának törlése',
        'Overview of registered systems' => 'Regisztrált rendszerek áttekintője',
        'This system is registered with OTOBO Team.' => 'Ez a rendszer regisztrálva van az OTRS csoporttal.',
        'System type' => 'Rendszertípus',
        'Unique ID' => 'Egyedi azonosító',
        'Last communication with registration server' => 'Utolsó kommunikáció a regisztrációs kiszolgálóval',
        'System Registration not Possible' => 'A rendszer regisztrációja nem lehetséges',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Ne feledje, hogy nem tudja regisztrálni a rendszerét, ha az OTOBO démon nem fut helyesen!',
        'Instructions' => 'Utasítások',
        'System Deregistration not Possible' => 'A rendszer regisztrációjának megszüntetése nem lehetséges',
        'OTOBO-ID Login' => 'OTOBO-azonosító bejelentkezés',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'A rendszer regisztráció az OTRS csoport szolgáltatása, amely számos előnyt biztosít!',
        'Read more' => 'Olvassa tovább',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Be kell jelentkeznie az OTOBO-azonosítójával a rendszer regisztrálásához.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Az OTOBO-azonosítója az OTOBO.com weboldalon a regisztrációhoz használt e-mail címe.',
        'Data Protection' => 'Adatvédelem',
        'What are the advantages of system registration?' => 'Mik a rendszer regisztrálásának előnyei?',
        'You will receive updates about relevant security releases.' => 'Frissítéseket fog kapni a fontos biztonsági kiadásokról.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'A rendszer regisztrálása által tovább fejleszthetjük a szolgáltatásainkat, mert nekünk minden fontos információ elérhető.',
        'This is only the beginning!' => 'És ez még csak a kezdet!',
        'We will inform you about our new services and offerings soon.' =>
            'Hamarosan értesíteni fogjuk az új szolgáltatásainkról és ajánlatainkról.',
        'Can I use OTOBO without being registered?' => 'Használható az OTOBO regisztráció nélkül?',
        'System registration is optional.' => 'A rendszer regisztrációja opcionális.',
        'You can download and use OTOBO without being registered.' => 'Letöltheti és használhatja az OTOBO-t anélkül, hogy regisztrálva lenne.',
        'Is it possible to deregister?' => 'Lehetséges a regisztráció törlése?',
        'You can deregister at any time.' => 'Bármikor törölheti a regisztrációt.',
        'Which data is transfered when registering?' => 'Milyen adatok kerülnek átvitelre a regisztrációkor?',
        'A registered system sends the following data to OTOBO Team:' => 'Egy regisztrált rendszer a következő adatokat küldi az OTRS csoportnak:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Teljes képzésű tartománynév (FQDN), OTOBO verzió, adatbázis, operációs rendszer és Perl verzió.',
        'Why do I have to provide a description for my system?' => 'Miért kell leírást megadnom a rendszeremhez?',
        'The description of the system is optional.' => 'A rendszer leírása opcionális.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'A megadott leírás és a rendszer típusa segít az azonosításban, és a regisztrált rendszer részleteinek kezelésében.',
        'How often does my OTOBO system send updates?' => 'Milyen gyakran küld az OTOBO rendszerem frissítéseket?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'A rendszer szabályos időközönként fog frissítéseket küldeni a regisztrációs kiszolgálónak.',
        'Typically this would be around once every three days.' => 'Ez tipikusan nagyjából három naponta történik.',
        'If you deregister your system, you will lose these benefits:' =>
            'Ha megszünteti a rendszer regisztrációját, a következő előnyöket fogja elveszíteni:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Be kell jelentkeznie az OTOBO-azonosítójával a rendszere regisztrációjának törléséhez.',
        'OTOBO-ID' => 'OTOBO-azonosító',
        'You don\'t have an OTOBO-ID yet?' => 'Még nincs OTOBO-azonosítója?',
        'Sign up now' => 'Regisztráljon most',
        'Forgot your password?' => 'Elfelejtette a jelszavát?',
        'Retrieve a new one' => 'Kérjen egy újat',
        'Next' => 'Következő',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Ezek az adatok rendszeresen el lesznek küldve az OTRS csoportnak, ha regisztrálja a rendszerét.',
        'Attribute' => 'Jellemző',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO verzió',
        'Operating System' => 'Operációs rendszer',
        'Perl Version' => 'Perl verzió',
        'Optional description of this system.' => 'A rendszer opcionális leírása.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Ez lehetővé fogja tenni a rendszer számára további támogatási adatok információinak küldését az OTRS csoportnak.',
        'Register' => 'Regisztráció',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Ha folytatja, ezzel a lépéssel törölni fogja a rendszer regisztrációját az OTRS csoportnál.',
        'Deregister' => 'Regisztráció törlése',
        'You can modify registration settings here.' => 'Itt módosíthatja a regisztrációs beállításokat.',
        'Overview of Transmitted Data' => 'Átvitt adatok áttekintője',
        'There is no data regularly sent from your system to %s.' => 'Nincsenek rendszeresen elküldött adatok a rendszeréről ide: %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'A következő adatok minimum 3 naponta lesznek elküldve a rendszeréről ide: %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Az adatok JSON formátumban kerülnek átvitelre biztonságos https kapcsolaton keresztül.',
        'System Registration Data' => 'Rendszer regisztráció adatok',
        'Support Data' => 'Támogatási adatok',

        # Template: AdminRole
        'Role Management' => 'Szerepkezelés',
        'Add Role' => 'Szerep hozzáadása',
        'Edit Role' => 'Szerep szerkesztése',
        'Filter for Roles' => 'Szűrő a szerepekhez',
        'Filter for roles' => 'Szűrő a szerepekhez',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Hozzon létre egy szerepet és tegyen bele csoportokat. Azután adja a szerepet a felhasználókhoz.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nincsenek szerepek meghatározva. Használja a „Hozzáadás” gombot egy új szerep létrehozásához.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Szerep–Csoport kapcsolatok kezelése',
        'Roles' => 'Szerepek',
        'Select the role:group permissions.' => 'A szerep:csoport jogosultságok kiválasztása.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Ha semmi sincs kiválasztva, akkor ebben a csoportban nincsenek jogosultságok (a jegyek nem lesznek elérhetők a szerepnek).',
        'Toggle %s permission for all' => 'A(z) %s jogosultság ki- vagy bekapcsolása mindenkinek',
        'move_into' => 'átmozgatás',
        'Permissions to move tickets into this group/queue.' => 'Jogosultságok jegyek áthelyezéséhez ebbe a csoportba/várólistába.',
        'create' => 'létrehozás',
        'Permissions to create tickets in this group/queue.' => 'Jogosultságok új jegyek létrehozásához ebben a csoportban/várólistában.',
        'note' => 'jegyzet',
        'Permissions to add notes to tickets in this group/queue.' => 'Jogosultságok a jegyekhez való jegyzetek hozzáadásához ebben a csoportban/várólistában.',
        'owner' => 'tulajdonos',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Jogosultságok a jegyek tulajdonosának megváltoztatásához ebben a csoportban/várólistában.',
        'priority' => 'prioritás',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Jogosultságok a jegy prioritásnak megváltoztatásához ebben a csoportban/várólistában.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Ügyintéző–Szerep kapcsolatok kezelése',
        'Add Agent' => 'Ügyintéző hozzáadása',
        'Filter for Agents' => 'Szűrő az ügyintézőkhöz',
        'Filter for agents' => 'Szűrő az ügyintézőkhöz',
        'Agents' => 'Ügyintézők',
        'Manage Role-Agent Relations' => 'Szerep–Ügyintéző kapcsolatok kezelése',

        # Template: AdminSLA
        'SLA Management' => 'SLA kezelés',
        'Edit SLA' => 'SLA szerkesztése',
        'Add SLA' => 'SLA hozzáadása',
        'Filter for SLAs' => 'Szűrő az SLA-khoz',
        'Please write only numbers!' => 'Csak számokat írjon!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME kezelés',
        'Add Certificate' => 'Tanúsítvány hozzáadása',
        'Add Private Key' => 'Személyes kulcs hozzáadása',
        'SMIME support is disabled' => 'Az S/MIME támogatás le van tiltva',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Hogy képes legyen S/MIME-t használni az OTOBO-ben, ahhoz először engedélyeznie kell azt.',
        'Enable SMIME support' => 'S/MIME támogatás engedélyezése',
        'Faulty SMIME configuration' => 'Hibás S/MIME beállítás',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Az S/MIME támogatás engedélyezve van, de a hozzá tartozó beállítások hibákat tartalmaznak. Ellenőrizze a beállításokat a lenti gomb használatával.',
        'Check SMIME configuration' => 'S/MIME beállítások ellenőrzése',
        'Filter for Certificates' => 'Szűrő a tanúsítványokhoz',
        'Filter for certificates' => 'Szűrő a tanúsítványokhoz',
        'To show certificate details click on a certificate icon.' => 'A tanúsítvány részleteinek megtekintéséhez kattintson a tanúsítvány ikonra.',
        'To manage private certificate relations click on a private key icon.' =>
            'A személyes tanúsítvány kapcsolatok kezeléséhez kattintson a személyes kulcs ikonra.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Itt adhat hozzá kapcsolatokat a személyes tanúsítványához, ezek lesznek beágyazva az S/MIME aláírásba minden alkalommal, amikor ezt a tanúsítványt egy e-mail aláírásához használja.',
        'See also' => 'Lásd még',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Ily módon közvetlenül szerkesztheti a fájlrendszeren a tanúsítványokat és a személyes kulcsokat.',
        'Hash' => 'Kivonat',
        'Create' => 'Létrehozás',
        'Handle related certificates' => 'Kapcsolódó tanúsítványok kezelése',
        'Read certificate' => 'Tanúsítvány olvasása',
        'Delete this certificate' => 'Tanúsítvány törlése',
        'File' => 'Fájl',
        'Secret' => 'Titok',
        'Related Certificates for' => 'Kapcsolódó tanúsítványok ehhez',
        'Delete this relation' => 'Kapcsolat törlése',
        'Available Certificates' => 'Elérhető tanúsítványok',
        'Filter for S/MIME certs' => 'Szűrő az S/MIME tanúsítványokhoz',
        'Relate this certificate' => 'Tanúsítvány összekapcsolása',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME tanúsítvány',
        'Certificate Details' => 'Tanúsítvány részletek',
        'Close this dialog' => 'Párbeszédablak bezárása',

        # Template: AdminSalutation
        'Salutation Management' => 'Megszólítás kezelés',
        'Add Salutation' => 'Megszólítás hozzáadása',
        'Edit Salutation' => 'Megszólítás szerkesztése',
        'Filter for Salutations' => 'Szűrő a megszólításokhoz',
        'Filter for salutations' => 'Szűrő a megszólításokhoz',
        'e. g.' => 'például',
        'Example salutation' => 'Példa megszólítás',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'A biztonsági módot engedélyezni szükséges!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'A biztonságos mód (normális esetben) a kezdeti telepítés befejezése után lesz beállítva.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Ha a biztonságos mód nincs aktiválva, aktiválja a rendszerbeállításon keresztül, mert az alkalmazás már fut.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL doboz',
        'Filter for Results' => 'Szűrő az eredményekhez',
        'Filter for results' => 'Szűrő az eredményekhez',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Itt tudja megadni az SQL-t, amelyet közvetlenül az alkalmazás adatbázisába küld. Nem lehetséges a táblák tartalmának megváltoztatása, csak kiválasztó lekérdezések engedélyezettek.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Itt tudja megadni az SQL-t, amelyet közvetlenül az alkalmazás adatbázisába küld.',
        'Options' => 'Beállítások',
        'Only select queries are allowed.' => 'Csak kiválasztó lekérdezések engedélyezettek.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Az SQL lekérdezés szintaktikájában hiba van. Ellenőrizze azt.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Legalább egy paraméter hiányzik a kötéshez. Ellenőrizze azt.',
        'Result format' => 'Eredmény formátum',
        'Run Query' => 'Lekérdezés futtatása',
        '%s Results' => '%s találat',
        'Query is executed.' => 'Lekérdezés végrehajtva.',

        # Template: AdminService
        'Service Management' => 'Szolgáltatás kezelés',
        'Add Service' => 'Szolgáltatás hozzáadása',
        'Edit Service' => 'Szolgáltatás szerkesztése',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'A szolgáltatás nevének legnagyobb hossza 200 karakter (alszolgáltatásokkal).',
        'Sub-service of' => 'Részszolgáltatása ennek',

        # Template: AdminSession
        'Session Management' => 'Munkamenet-kezelés',
        'Detail Session View for %s (%s)' => '%s (%s) részletes munkamenetnézete',
        'All sessions' => 'Összes munkamenet',
        'Agent sessions' => 'Ügyintéző munkamenetek',
        'Customer sessions' => 'Ügyfél munkamenetek',
        'Unique agents' => 'Egyedi ügyintézők',
        'Unique customers' => 'Egyedi ügyfelek',
        'Kill all sessions' => 'Összes munkamenet kilövése',
        'Kill this session' => 'Munkamenet kilövése',
        'Filter for Sessions' => 'Szűrő a munkamenetekhez',
        'Filter for sessions' => 'Szűrő a munkamenetekhez',
        'Session' => 'Munkamenet',
        'Kill' => 'Kilövés',
        'Detail View for SessionID: %s - %s' => 'A munkamenet-azonosító részletes nézete: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Aláírás kezelés',
        'Add Signature' => 'Aláírás hozzáadása',
        'Edit Signature' => 'Aláírás szerkesztése',
        'Filter for Signatures' => 'Szűrő az aláírásokhoz',
        'Filter for signatures' => 'Szűrő az aláírásokhoz',
        'Example signature' => 'Példa aláírás',

        # Template: AdminState
        'State Management' => 'Állapot kezelés',
        'Add State' => 'Állapot hozzáadása',
        'Edit State' => 'Állapot szerkesztése',
        'Filter for States' => 'Szűrő az állapotokhoz',
        'Filter for states' => 'Szűrő az állapotokhoz',
        'Attention' => 'Figyelem',
        'Please also update the states in SysConfig where needed.' => 'Frissítse az állapotokat a rendszer beállításaiban is, ahol szükséges.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Ez az állapot megtalálható egy rendszerbállításban, az új állapotra mutató beállítások frissítésének megerősítése szükséges!',
        'State type' => 'Állapottípus',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Nem lehetséges érvényteleníteni ezt a bejegyzést, mert nincsenek egyéb egyesítés állapotok a rendszeren!',
        'This state is used in the following config settings:' => 'Ez az állapot a következő konfigurációs beállításokban van használva:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'Nem lehetséges támogatási adatokat küldeni az OTRS csoportnak!',
        'Enable Cloud Services' => 'Felhőszolgáltatások engedélyezése',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Ezeket az adatokat küldik el az OTRS csoportnak rendszeresen. Az adatok küldésének leállításához frissítse a rendszer regisztrációját.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Kézzel is aktiválhatja a támogatási adatok küldését a gomb megnyomásával:',
        'Send Update' => 'Frissítés küldése',
        'Currently this data is only shown in this system.' => 'Jelenleg ezek az adatok csak ezen a rendszeren jelennek meg.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Erősen javasolt az adatok elküldése az OTRS csoportnak annak érdekében, hogy jobb támogatást kapjon.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Az adatküldés engedélyezéséhez regisztrálja a rendszerét az OTRS csoporttal, vagy frissítse a rendszer regisztrációjának információit (győződjön meg arról, hogy aktiválta a „Támogatási adatok küldése” lehetőséget).',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'A támogatási csomag (tartalmazza: rendszer regisztrációs információk, támogatási adatok, telepített csomagok listája és minden helyileg módosított forráskód fájl) előállítható a gomb megnyomásával:',
        'Generate Support Bundle' => 'Támogatási csomag előállítása',
        'The Support Bundle has been Generated' => 'A támogatási csomag előállítva',
        'Please choose one of the following options.' => 'Válassza a következő lehetőségek egyikét.',
        'Send by Email' => 'Küldés e-mailben',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'A támogatási csomag túl nagy az e-mailben történő küldéshez, ez a lehetőség le lett tiltva.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Ennek a felhasználónak az e-mail címe érvénytelen, ez a lehetőség le lett tiltva.',
        'Sending' => 'Küldés',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'A támogatási csomag automatikusan el lesz küldve e-mailben az OTRS csoportnak.',
        'Download File' => 'Fájl letöltése',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'A támogatási csomagot tartalmazó fájl le lesz töltve a helyi rendszerre. Mentse el a fájlt, és küldje el az OTRS csoportnak egy alternatív módszer használatával.',
        'Error: Support data could not be collected (%s).' => 'Hiba: A támogatási adatokat nem sikerült összegyűjteni (%s).',
        'Details' => 'Részletek',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Rendszer e-mail címek kezelése',
        'Add System Email Address' => 'Rendszer e-mail cím hozzáadása',
        'Edit System Email Address' => 'Rendszer e-mail cím szerkesztése',
        'Add System Address' => 'Rendszercím hozzáadása',
        'Filter for System Addresses' => 'Szűrő a rendszercímekhez',
        'Filter for system addresses' => 'Szűrő a rendszercímekhez',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Az összes, ezzel a címzett vagy másolati mezőben lévő címmel rendelkező bejövő e-mail a kijelölt várólistába lesz kézbesítve.',
        'Email address' => 'E-mail cím',
        'Display name' => 'Megjelenített név',
        'This email address is already used as system email address.' => 'Ez az e-mail cím már használatban van rendszer e-mail címként.',
        'The display name and email address will be shown on mail you send.' =>
            'A megjelenített név és az e-mail cím meg lesz jelenítve az elküldött leveleknél.',
        'This system address cannot be set to invalid.' => 'Ezt a rendszercímet nem lehet érvénytelenre állítani.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Ezt a rendszercímet nem lehet érvénytelenre állítani, mert egy vagy több várólistában vagy automatikus válaszban használják.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'interneten lévő adminisztrátori kézikönyv',
        'System configuration' => 'Rendszerbeállítások',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Navigáljon az elérhető beállítások között a bal oldali navigációs dobozban lévő fa használatával.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Keressen bizonyos beállításokat a lenti keresőmező használatával vagy a felső navigációban lévő keresés ikonból.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Ismerje meg, hogy hogyan kell használni a rendszert az %s elolvasásával.',
        'Search in all settings...' => 'Keresés az összes beállításban…',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Jelenleg nincsenek elérhető beállítások. Győződjön meg arról, hogy lefuttatta-e az „otobo.Console.pl Maint::Config::Rebuild” parancsot a szoftver használata előtt.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Változások üzembe állítása',
        'Help' => 'Súgó',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Ez az összes olyan beállítás áttekintője, amelyek az üzembe állítás részei lesznek, ha most elindítja. Összehasonlíthatja az egyes beállításokat a korábbi állapotukkal a jobb felső részen lévő ikonra kattintva.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'Egy üzembe állításból bizonyos beállítások végrehajtásához kattintson egy beállítás fejlécsávján lévő jelölőnégyzetre.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Alapértelmezetten csak azokat a beállításokat fogja üzembe állítani, amelyeket Ön változtatott meg. Ha olyan beállításokat is üzembe szeretne állítani, amelyeket más felhasználók változtattak meg, akkor kattintson a képernyő tetején lévő hivatkozásra a speciális üzembe állítási módba történő belépéshez.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Egy üzembe állítás visszaállításra került, amely azt jelenti, hogy az összes érintett beállítás vissza lett állítva a kijelölt üzembe állításból származó állapotra.',
        'Please review the changed settings and deploy afterwards.' => 'Nézze át a megváltozott beállításokat, és azután helyezze üzembe.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Az üres változáslista azt jelenti, hogy nincs különbség az érintett beállítások visszaállított és jelenlegi állapota között.',
        'Changes Overview' => 'Változások áttekintője',
        'There are %s changed settings which will be deployed in this run.' =>
            '%s megváltozott beállítás van, amely üzembe lesz állítva ebben a menetben.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Átváltás alap módra csak az ön által megváltoztatott beállítások üzembe állításához.',
        'You have %s changed settings which will be deployed in this run.' =>
            '%s megváltozott beállítása van, amely üzembe lesz állítva ebben a menetben.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Átváltás speciális módra a más felhasználók által megváltoztatott beállítások üzembe állításához is.',
        'There are no settings to be deployed.' => 'Nincsenek üzembe állítandó beállítások.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Átváltás speciális módra a más felhasználók által megváltoztatott üzembe állítható beállítások megtekintéséhez.',
        'Deploy selected changes' => 'Kijelölt változások üzembe állítása',

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
        'by' => '–',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Ez a csoport nem tartalmaz egyetlen beállítást sem. Próbáljon meg az alcsoportjai egyikére navigálni.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importálás és exportálás',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Töltsön fel egy fájlt a rendszerbe importáláshoz (.yml formátumban, ahogy a rendszerbeállítás modulból exportálva lett).',
        'Upload system configuration' => 'Rendszerbeállítás feltöltése',
        'Import system configuration' => 'Rendszerbeállítás importálása',
        'Download current configuration settings of your system in a .yml file.' =>
            'A rendszer jelenlegi konfigurációs beállításainak letöltése egy .yml fájlba.',
        'Include user settings' => 'Tartalmazza a felhasználó beállításait',
        'Export current configuration' => 'Jelenlegi beállítások exportálása',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Keresés erre:',
        'Search for category' => 'Kategória keresése',
        'Settings I\'m currently editing' => 'Beállítások, amelyeket jelenleg szerkesztek',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'A keresése („%s”) a(z) „%s” kategóriában nem adott vissza egyetlen találatot sem.',
        'Your search for "%s" in category "%s" returned one result.' => 'A keresése („%s”) a(z) „%s” kategóriában egy találatot adott vissza.',
        'Your search for "%s" in category "%s" returned %s results.' => 'A keresése („%s”) a(z) „%s” kategóriában %s találatot adott vissza.',
        'You\'re currently not editing any settings.' => 'Jelenleg nem szerkeszt egyetlen beállítást sem.',
        'You\'re currently editing %s setting(s).' => 'Jelenleg %s beállítást szerkeszt.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategória',
        'Run search' => 'Keresés futtatása',

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
        'View a custom List of Settings' => 'Egyéni beállításlista megtekintése',
        'View single Setting: %s' => 'Önálló beállítás megtekintése: %s',
        'Go back to Deployment Details' => 'Vissza az üzembe állítás részleteihez',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Rendszerkarbantartás kezelés',
        'Schedule New System Maintenance' => 'Új rendszerkarbantartás ütemezése',
        'Filter for System Maintenances' => 'Szűrő a rendszerkarbantartásokhoz',
        'Filter for system maintenances' => 'Szűrő a rendszerkarbantartásokhoz',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Egy rendszerkarbantartás időszak ütemezése az ügyintézők és ügyfelek értesítéséhez, hogy a rendszer leáll egy időszakra.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Nem sokkal a rendszerkarbantartás indulása előtt a felhasználók értesítést fognak kapni minden képernyőn ennek a ténynek a bejelentéséről.',
        'Stop date' => 'Végdátum',
        'Delete System Maintenance' => 'Rendszerkarbantartás törlése',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Rendszerkarbantartás szerkesztése',
        'Edit System Maintenance Information' => 'Rendszerkarbantartás információk szerkesztése',
        'Date invalid!' => 'Érvénytelen dátum!',
        'Login message' => 'Bejelentkező üzenet',
        'This field must have less then 250 characters.' => 'Ennek a mezőnek rövidebbnek kell lennie 250 karakternél.',
        'Show login message' => 'Bejelentkező üzenet megjelenítése',
        'Notify message' => 'Értesítő üzenet',
        'Manage Sessions' => 'Munkamenetek kezelése',
        'All Sessions' => 'Összes munkamenet',
        'Agent Sessions' => 'Ügyintéző munkamenetek',
        'Customer Sessions' => 'Ügyfél munkamenetek',
        'Kill all Sessions, except for your own' => 'Összes munkamenet kilövése, kivéve az Ön sajátját',

        # Template: AdminTemplate
        'Template Management' => 'Sablonkezelés',
        'Add Template' => 'Sablon hozzáadása',
        'Edit Template' => 'Sablon szerkesztése',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'A sablon egy olyan alapértelmezett szöveg, amely segít az ügyintézőknek a jegyek, válaszok vagy továbbítások gyorsabb írásában.',
        'Don\'t forget to add new templates to queues.' => 'Ne felejtse el hozzáadni az új sablonokat a várólistákhoz.',
        'Attachments' => 'Mellékletek',
        'Delete this entry' => 'Bejegyzés törlése',
        'Do you really want to delete this template?' => 'Valóban törölni szeretné ezt a sablont?',
        'A standard template with this name already exists!' => 'Már létezik ilyen nevű szabványos sablon!',
        'Create type templates only supports this smart tags' => 'Típussablonok létrehozása, amelyek csak ezeket az intelligens címkéket támogatják',
        'Example template' => 'Példa sablon',
        'The current ticket state is' => 'A jegy jelenlegi állapota',
        'Your email address is' => 'Az e-mail címe',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Sablon–Melléklet kapcsolatok kezelése',
        'Toggle active for all' => 'Aktiválás ki- és bekapcsolása mindenkinek',
        'Link %s to selected %s' => '%s összekapcsolása a kijelölt %s elemmel',

        # Template: AdminType
        'Type Management' => 'Típuskezelés',
        'Add Type' => 'Típus hozzáadása',
        'Edit Type' => 'Típus szerkesztése',
        'Filter for Types' => 'Szűrő a típusokhoz',
        'Filter for types' => 'Szűrő a típusokhoz',
        'A type with this name already exists!' => 'Már létezik ilyen nevű típus!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Ez a típus megtalálható egy rendszerbállításban, az új típusra mutató beállítások frissítésének megerősítése szükséges!',
        'This type is used in the following config settings:' => 'Ez a típus a következő konfigurációs beállításokban van használva:',

        # Template: AdminUser
        'Agent Management' => 'Ügyintéző-kezelés',
        'Edit Agent' => 'Ügyintéző szerkesztése',
        'Edit personal preferences for this agent' => 'Személyes beállítások szerkesztése ennél az ügyintézőnél',
        'Agents will be needed to handle tickets.' => 'Ügyintézőkre lesz szükség a jegyek kezeléséhez.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ne felejtse el hozzáadni az új ügyintézőt a csoportokhoz és/vagy szerepekhez!',
        'Please enter a search term to look for agents.' => 'Adjon meg egy keresési kifejezést az ügyintézők kereséséhez.',
        'Last login' => 'Utolsó belépés',
        'Switch to agent' => 'Váltás ügyintézőre',
        'Title or salutation' => 'Titulus vagy megszólítás',
        'Firstname' => 'Keresztnév',
        'Lastname' => 'Vezetéknév',
        'A user with this username already exists!' => 'Már létezik ilyen felhasználónevű felhasználó!',
        'Will be auto-generated if left empty.' => 'Legyen automatikusan előállított, ha üresen van hagyva.',
        'Mobile' => 'Mobiltelefon',
        'Effective Permissions for Agent' => 'Tényleges jogosultságok az ügyintézőnél',
        'This agent has no group permissions.' => 'Ennek az ügyintézőnek nincsenek csoportjogosultságai.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'A fenti táblázat a tényleges csoportjogosultságokat jeleníti meg az ügyintézőnél. A mátrix figyelembe veszi az összes örökölt jogosultságot (például szerepeken keresztül).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Ügyintéző–Csoport kapcsolatok kezelése',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Napirend áttekintő',
        'Manage Calendars' => 'Naptárak kezelése',
        'Add Appointment' => 'Időpont hozzáadása',
        'Today' => 'Ma',
        'All-day' => 'Egész nap',
        'Repeat' => 'Ismétlés',
        'Notification' => 'Értesítés',
        'Yes' => 'Igen',
        'No' => 'Nem',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Nem találhatók naptárak. Először adjon hozzá egy naptárat a naptárak kezelése oldal használatával.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Új időpont hozzáadása',
        'Calendars' => 'Naptárak',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Alap információk',
        'Date/Time' => 'Dátum/idő',
        'Invalid date!' => 'Érvénytelen dátum!',
        'Please set this to value before End date.' => 'Állítsa ezt egy befejezési dátum előtti értékre.',
        'Please set this to value after Start date.' => 'Állítsa ezt egy kezdési dátum utáni értékre.',
        'This an occurrence of a repeating appointment.' => 'Ez egy ismétlődő időpont előfordulása.',
        'Click here to see the parent appointment.' => 'Kattintson ide a szülőidőpont megtekintéséhez.',
        'Click here to edit the parent appointment.' => 'Kattintson ide a szülőidőpont szerkesztéséhez.',
        'Frequency' => 'Gyakoriság',
        'Every' => 'Minden',
        'day(s)' => 'nap',
        'week(s)' => 'hét',
        'month(s)' => 'hónap',
        'year(s)' => 'év',
        'On' => 'Be',
        'Monday' => 'hétfő',
        'Mon' => 'h',
        'Tuesday' => 'kedd',
        'Tue' => 'k',
        'Wednesday' => 'szerda',
        'Wed' => 'sze',
        'Thursday' => 'csütörtök',
        'Thu' => 'cs',
        'Friday' => 'péntek',
        'Fri' => 'p',
        'Saturday' => 'szombat',
        'Sat' => 'szo',
        'Sunday' => 'vasárnap',
        'Sun' => 'v',
        'January' => 'január',
        'Jan' => 'jan.',
        'February' => 'február',
        'Feb' => 'febr.',
        'March' => 'március',
        'Mar' => 'márc.',
        'April' => 'április',
        'Apr' => 'ápr.',
        'May_long' => 'május',
        'May' => 'máj.',
        'June' => 'június',
        'Jun' => 'jún.',
        'July' => 'július',
        'Jul' => 'júl.',
        'August' => 'augusztus',
        'Aug' => 'aug.',
        'September' => 'szeptember',
        'Sep' => 'szept.',
        'October' => 'október',
        'Oct' => 'okt.',
        'November' => 'november',
        'Nov' => 'nov.',
        'December' => 'december',
        'Dec' => 'dec.',
        'Relative point of time' => 'Relatív időpont',
        'Link' => 'Összekapcsolás',
        'Remove entry' => 'Bejegyzés eltávolítása',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Ügyfélinformációs-központ',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Ügyfél-felhasználó',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Megjegyzés: Az ügyfél érvénytelen!',
        'Start chat' => 'Csevegés indítása',
        'Video call' => 'Videohívás',
        'Audio call' => 'Hanghívás',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Ügyfél-felhasználó címjegyzék',
        'Search for recipients and add the results as \'%s\'.' => 'Címzettek keresése és az eredmények hozzáadása mint „%s”.',
        'Search template' => 'Keresési sablon',
        'Create Template' => 'Sablon létrehozása',
        'Create New' => 'Új létrehozása',
        'Save changes in template' => 'Módosítások mentése sablonba',
        'Filters in use' => 'Használatban lévő szűrők',
        'Additional filters' => 'További szűrők',
        'Add another attribute' => 'További jellemző hozzáadása',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Az „(Ügyfél)” azonosítóval rendelkező attribútumok az ügyfél-vállalatból vannak.',
        '(e. g. Term* or *Term*)' => '(például kifejezés* vagy *kifejezés*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Összes kijelölése',
        'The customer user is already selected in the ticket mask.' => 'Az ügyfél-felhasználó már ki van jelölve a jegymaszkban.',
        'Select this customer user' => 'Az ügyfél-felhasználó kiválasztása',
        'Add selected customer user to' => 'Kijelölt ügyfél-felhasználó hozzáadása ehhez:',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Keresési beállítások módosítása',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Ügyfél-felhasználó információs-központ',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'Az OTOBO démon egy démonfolyamat, amely olyan aszinkron feladatokat hajt végre, mint például jegyeszkaláció aktiválás, e-mail küldés, stb.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Egy futó OTOBO démon feltétlenül szükséges a helyes rendszerműködéshez.',
        'Starting the OTOBO Daemon' => 'Az OTOBO démon indítása',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Győződjön meg arról, hogy a(z) „%s” fájl létezik-e (.dist kiterjesztés nélkül). Ez a cron-feladat 5 percenként fogja ellenőrizni, hogy az OTOBO démon fut-e, és szükség szerint elindítja azt.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Hajtsa végre a(z) „%s start” parancsot, hogy megbizonyosodjon arról, hogy az „otobo” felhasználó cron-feladatai aktívak-e.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Ellenőrizze 5 perc után, hogy az OTOBO démon fut-e a rendszeren („bin/otobo.Daemon.pl status”).',

        # Template: AgentDashboard
        'Dashboard' => 'Vezérlőpult',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Új időpont',
        'Tomorrow' => 'Holnap',
        'Soon' => 'Hamarosan',
        '5 days' => '5 nap',
        'Start' => 'Indítás',
        'none' => 'nincs',

        # Template: AgentDashboardCalendarOverview
        'in' => 'ekkor:',

        # Template: AgentDashboardCommon
        'Save settings' => 'Beállítások mentése',
        'Close this widget' => 'Felületi elem bezárása',
        'more' => 'tovább',
        'Available Columns' => 'Elérhető oszlopok',
        'Visible Columns (order by drag & drop)' => 'Látható oszlopok (rendezés fogd és vidd módon)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Ügyfélkapcsolatok megváltoztatása',
        'Open' => 'Nyitott',
        'Closed' => 'Lezárva',
        '%s open ticket(s) of %s' => '%s nyitott jegye ennek: %s',
        '%s closed ticket(s) of %s' => '%s lezárt jegye ennek: %s',
        'Edit customer ID' => 'Ügyfél-azonosító szerkesztése',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eszkalált jegyek',
        'Open tickets' => 'Nyitott jegyek',
        'Closed tickets' => 'Lezárt jegyek',
        'All tickets' => 'Összes jegy',
        'Archived tickets' => 'Archivált jegyek',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Megjegyzés: Az ügyfél-felhasználó érvénytelen!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Ügyfél-felhasználó információk',
        'Phone ticket' => 'Telefonos jegy',
        'Email ticket' => 'E-mail jegy',
        'New phone ticket from %s' => 'Új telefonos jegy tőle: %s',
        'New email ticket to %s' => 'Új e-mail jegy neki: %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s elérhető!',
        'Please update now.' => 'Frissítse most.',
        'Release Note' => 'Kiadási megjegyzés',
        'Level' => 'Szint',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Beküldve %s ezelőtt.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Ennek a statisztikai felületi elemnek a beállítása hibákat tartalmaz. Nézze át a beállításait.',
        'Download as SVG file' => 'Letöltés SVG-fájlként',
        'Download as PNG file' => 'Letöltés PNG-fájlként',
        'Download as CSV file' => 'Letöltés CSV-fájlként',
        'Download as Excel file' => 'Letöltés Excel fájlként',
        'Download as PDF file' => 'Letöltés PDF-fájlként',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Válasszon egy érvényes kimeneti grafikonformátumot ennek a felületi elemnek a beállításaiban.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'A statisztika tartalma előkészítés alatt van, várjon türelemmel.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Ez a statisztika jelenleg nem használható, mert a beállításait javítania kell a statisztika adminisztrátorának.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Hozzárendelve az ügyfél-felhasználóhoz',
        'Accessible for customer user' => 'Hozzáférhető az ügyfél-felhasználónak',
        'My locked tickets' => 'Saját zárolt jegyek',
        'My watched tickets' => 'Saját megfigyelt jegyek',
        'My responsibilities' => 'Saját felelősségek',
        'Tickets in My Queues' => 'Jegyek a várólistáimban',
        'Tickets in My Services' => 'Jegyek a szolgáltatásaimban',
        'Service Time' => 'Szolgáltatás ideje',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Összesen',

        # Template: AgentDashboardUserOnline
        'out of office' => 'irodán kívül',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'eddig:',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Vissza',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentElasticsearchQuickResult
        'Ticketnumber' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'A hírek, a licenc és néhány változtatás elfogadásához.',
        'Yes, accepted.' => 'Igen, elfogadva.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Kapcsolatok kezelése ennél: %s',
        'Create new links' => 'Új kapcsolatok létrehozása',
        'Manage existing links' => 'Meglévő kapcsolatok kezelése',
        'Link with' => 'Összekapcsolás ezzel',
        'Start search' => 'Keresés indítása',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Jelenleg nincsenek kapcsolatok. Kattintson a fenti „Új kapcsolatok létrehozása” gombra ezen elem más objektumokkal történő összekapcsolásához.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Jelszó megváltoztatása',
        'Current password' => 'Jelenlegi jelszó',
        'New password' => 'Új jelszó',
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
        'Edit your preferences' => 'Beállítások szerkesztése',
        'Personal Preferences' => 'Személyes beállítások',
        'Preferences' => 'Beállítások',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Ne feledje: jelenleg %s beállításait szerkeszti.',
        'Go back to editing this agent' => 'Vissza az ügyintéző szerkesztéséhez',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Állítsa be a személyes beállításait. Az egyes beállításokat a jobb oldalán lévő pipára kattintva mentheti el.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Használhatja a lenti navigációs fát a csak bizonyos csoportokban lévő beállítások megjelenítéséhez.',
        'Dynamic Actions' => 'Dinamikus műveletek',
        'Filter settings...' => 'Beállítások szűrése…',
        'Filter for settings' => 'Szűrő a beállításokhoz',
        'Save all settings' => 'Összes beállítás mentése',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'A profilképeket letiltotta a rendszer adminisztrátora. Helyette a monogramját fogja látni.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Megváltoztathatja a profilképét, ha regisztrálja az e-mail címét (%s) a következő oldalon: %s. Ne feledje, hogy a gyorsítótárazás miatt eltarthat egy ideig, amíg az új profilképe elérhetővé válik.',
        'Off' => 'Ki',
        'End' => 'Befejezés',
        'This setting can currently not be saved.' => 'Ezt a beállítás jelenleg nem lehet elmenteni.',
        'This setting can currently not be saved' => 'Ezt a beállítás jelenleg nem lehet elmenteni',
        'Save this setting' => 'Beállítás mentése',
        'Did you know? You can help translating OTOBO at %s.' => 'Tudta? Segíthet az OTOBO fordításában a következő címen: %s.',

        # Template: SettingsList
        'Reset to default' => 'Visszaállítás az alapértelmezettre',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Válasszon a jobb oldali csoportok közül azon beállítások megtalálásához, amelyeket meg szeretne változtatni.',
        'Did you know?' => 'Tudta?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Megváltoztathatja a profilképét, ha regisztrálja az e-mail címét (%s) a következő oldalon: %s',

        # Template: AgentSplitSelection
        'Target' => 'Cél',
        'Process' => 'Folyamat',
        'Split' => 'Felosztás',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Statisztikakezelés',
        'Add Statistics' => 'Statisztika hozzáadása',
        'Read more about statistics in OTOBO' => 'Tudjon meg többet az OTOBO-ben lévő statisztikákról',
        'Dynamic Matrix' => 'Dinamikus mátrix',
        'Each cell contains a singular data point.' => 'Minden egyes cella egyetlen adatpontot tartalmaz.',
        'Dynamic List' => 'Dinamikus lista',
        'Each row contains data of one entity.' => 'Minden egyes sor egy bejegyzés adatát tartalmazza.',
        'Static' => 'Statikus',
        'Non-configurable complex statistics.' => 'Nem beállítható összetett statisztikák.',
        'General Specification' => 'Általános specifikáció',
        'Create Statistic' => 'Statisztika létrehozása',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Statisztika szerkesztése',
        'Run now' => 'Futtatás most',
        'Statistics Preview' => 'Statisztikák előnézet',
        'Save Statistic' => 'Statisztika mentése',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Statisztika importálása',
        'Import Statistics Configuration' => 'Statisztikák beállításának importálása',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statisztikák',
        'Run' => 'Futtatás',
        'Edit statistic "%s".' => '„%s” statisztika szerkesztése.',
        'Export statistic "%s"' => '„%s” statisztika exportálása',
        'Export statistic %s' => '%s statisztika exportálása',
        'Delete statistic "%s"' => '„%s” statisztika törlése',
        'Delete statistic %s' => '%s statisztika törlése',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Statisztikák áttekintő',
        'View Statistics' => 'Statisztika megtekintése',
        'Statistics Information' => 'Statisztikák információi',
        'Created by' => 'Létrehozta',
        'Changed by' => 'Módosította',
        'Sum rows' => 'Sorok összegzése',
        'Sum columns' => 'Oszlopok összegzése',
        'Show as dashboard widget' => 'Megjelenítés vezérlőpult felületi elemként',
        'Cache' => 'Gyorsítótár',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Ez a statisztika beállítási hibákat tartalmaz, és jelenleg nem használható.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '%s%s%s szabad szövegének módosítása',
        'Change Owner of %s%s%s' => '%s%s%s tulajdonosának módosítása',
        'Close %s%s%s' => '%s%s%s lezárása',
        'Add Note to %s%s%s' => 'Jegyzet hozzáadása ehhez: %s%s%s',
        'Set Pending Time for %s%s%s' => '%s%s%s várakozási idejének beállítása',
        'Change Priority of %s%s%s' => '%s%s%s prioritásának módosítása',
        'Change Responsible of %s%s%s' => '%s%s%s felelősének módosítása',
        'The ticket has been locked' => 'A jegy zárolva lett',
        'Undo & close' => 'Visszavonás és bezárás',
        'Ticket Settings' => 'Jegybeállítások',
        'Queue invalid.' => 'A várólista érvénytelen.',
        'Service invalid.' => 'Érvénytelen szolgáltatás.',
        'SLA invalid.' => 'Az SLA érvénytelen.',
        'New Owner' => 'Új tulajdonos',
        'Please set a new owner!' => 'Állítson be új tulajdonost!',
        'Owner invalid.' => 'A tulajdonos érvénytelen.',
        'New Responsible' => 'Új felelős',
        'Please set a new responsible!' => 'Állítson be új felelőst!',
        'Responsible invalid.' => 'A felelős érvénytelen.',
        'Next state' => 'Következő állapot',
        'State invalid.' => 'Az állapot érvénytelen.',
        'For all pending* states.' => 'Minden függőben* állapotnál.',
        'Add Article' => 'Bejegyzés hozzáadása',
        'Create an Article' => 'Egy bejegyzés létrehozása',
        'Inform agents' => 'Ügyintézők értesítése',
        'Inform involved agents' => 'Részt vevő ügyintézők értesítése',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Itt választhat ki további ügyintézőket, akiknek értesítést kell kapniuk az új bejegyzést illetően.',
        'Text will also be received by' => 'A szöveget meg fogja még kapni',
        'Text Template' => 'Szövegsablon',
        'Setting a template will overwrite any text or attachment.' => 'Egy sablon beállítása felül fog írni minden szöveget vagy mellékletet.',
        'Invalid time!' => 'Érvénytelen időpont!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '%s%s%s átirányítása',
        'Bounce to' => 'Átirányítás ide',
        'You need a email address.' => 'Egy e-mail címre van szüksége.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Egy érvényes e-mail cím szükséges, vagy ne használja a helyi e-mail címet.',
        'Next ticket state' => 'Következő jegyállapot',
        'Inform sender' => 'Küldő tájékoztatása',
        'Send mail' => 'Levél küldése',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Tömeges jegyművelet',
        'Send Email' => 'E-mail küldése',
        'Merge' => 'Egyesítés',
        'Merge to' => 'Egyesítés ezzel:',
        'Invalid ticket identifier!' => 'Érvénytelen jegyazonosító!',
        'Merge to oldest' => 'Egyesítés a legrégebbivel',
        'Link together' => 'Összekapcsolás',
        'Link to parent' => 'Összekapcsolás a szülővel',
        'Unlock tickets' => 'Jegyek feloldása',
        'Execute Bulk Action' => 'Tömeges művelet végrehajtása',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Válasz írása erre: %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ez a cím rendszercímként van regisztrálva és nem használható: %s',
        'Please include at least one recipient' => 'Vegyen fel legalább egy címzettet',
        'Select one or more recipients from the customer user address book.' =>
            'Egy vagy több címzett kiválasztása az ügyfél-felhasználó címjegyzékből.',
        'Customer user address book' => 'Ügyfél-felhasználó címjegyzék',
        'Remove Ticket Customer' => 'Jegy ügyfél eltávolítása',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Távolítsa el ezt a bejegyzést, és adjon meg egy újat a helyes értékkel.',
        'This address already exists on the address list.' => 'Ez a cím már létezik a címlistában.',
        'Remove Cc' => 'Másolat eltávolítása',
        'Bcc' => 'Rejtett másolat',
        'Remove Bcc' => 'Rejtett másolat eltávolítása',
        'Date Invalid!' => 'Érvénytelen dátum!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '%s%s%s ügyfelének módosítása',
        'Customer Information' => 'Ügyfél-információk',
        'Customer user' => 'Ügyfél-felhasználó',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Új e-mail jegy létrehozása',
        'Example Template' => 'Példa sablon',
        'To customer user' => 'Ügyfél-felhasználónak',
        'Please include at least one customer user for the ticket.' => 'Vegyen fel legalább egy ügyfél-felhasználót a jegyhez.',
        'Select this customer as the main customer.' => 'Az ügyfél kijelölése fő ügyfélként.',
        'Remove Ticket Customer User' => 'Jegy ügyfél-felhasználójának eltávolítása',
        'From queue' => 'Várólistából',
        'Get all' => 'Összes lekérése',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Kimenő e-mail ehhez: %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'E-mail újraküldése ennél: %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '%s jegy: az első válaszidő lejárt (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => '%s jegy: az első válaszidő le fog járni: %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => '%s jegy: a frissítés ideje lejárt (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => '%s jegy: a frissítési idő le fog járni: %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => '%s jegy: a megoldási idő lejárt (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => '%s jegy: a megoldási idő le fog járni: %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '%s%s%s továbbítása',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%s előzményei',
        'Filter for history items' => 'Szűrő az előzményelemekhez',
        'Expand/collapse all' => 'Összes kinyitása vagy összecsukása',
        'CreateTime' => 'Létrehozás ideje',
        'Article' => 'Bejegyzés',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '%s%s%s egyesítése',
        'Merge Settings' => 'Egyesítés beállítások',
        'You need to use a ticket number!' => 'Egy jegyszámot kell használnia!',
        'A valid ticket number is required.' => 'Érvényes jegyszám szükséges.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Próbálja meg beírni a jegyszám vagy a cím egy részét annak kereséséhez.',
        'Limit the search to tickets with same Customer ID (%s).' => 'A keresés korlátozása az azonos ügyfél-azonosítójú (%s) jegyekre.',
        'Inform Sender' => 'Küldő tájékoztatása',
        'Need a valid email address.' => 'Érvényes e-mail cím szükséges.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%s áthelyezése',
        'New Queue' => 'Új várólista',
        'Move' => 'Áthelyezés',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Nem található jegyadat.',
        'Open / Close ticket action menu' => 'Jegyművelet menü megnyitása vagy bezárása',
        'Select this ticket' => 'Jegy kijelölése',
        'Sender' => 'Küldő',
        'First Response Time' => 'Első válaszidő',
        'Update Time' => 'Frissítés ideje',
        'Solution Time' => 'Megoldás ideje',
        'Move ticket to a different queue' => 'Jegy áthelyezése egy másik várólistába',
        'Change queue' => 'Várólista módosítása',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Aktív szűrők eltávolítása ennél a képernyőnél.',
        'Tickets per page' => 'Jegyek oldalanként',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Hiányzó csatorna',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Áttekintő visszaállítása',
        'Column Filters Form' => 'Oszlopszűrők űrlap',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Felosztás új telefonos jegybe',
        'Save Chat Into New Phone Ticket' => 'Csevegés mentése egy új telefonos jegybe',
        'Create New Phone Ticket' => 'Új telefonos jegy létrehozása',
        'Please include at least one customer for the ticket.' => 'Vegyen fel legalább egy ügyfelet a jegyhez.',
        'To queue' => 'Várólistába',
        'Chat protocol' => 'Csevegés protokoll',
        'The chat will be appended as a separate article.' => 'A csevegés elkülönített bejegyzésként lesz hozzáfűzve.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefonhívás ehhez: %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Egyszerű szöveges e-mail megtekintése ennél: %s%s%s',
        'Plain' => 'Egyszerű',
        'Download this email' => 'E-mail letöltése',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Új folyamatjegy létrehozása',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Jegy besorolása egy folyamatba',

        # Template: AgentTicketSearch
        'Profile link' => 'Profil hivatkozás',
        'Output' => 'Kimenet',
        'Fulltext' => 'Szabad-szavas',
        'Customer ID (complex search)' => 'Ügyfél-azonosító (összetett keresés)',
        '(e. g. 234*)' => '(például 234*)',
        'Customer ID (exact match)' => 'Ügyfél-azonosító (pontos egyezés)',
        'Assigned to Customer User Login (complex search)' => 'Hozzárendelve egy ügyfél-felhasználó belépéshez (összetett keresés)',
        '(e. g. U51*)' => '(például U51*)',
        'Assigned to Customer User Login (exact match)' => 'Hozzárendelve egy ügyfél-felhasználó belépéshez (pontos egyezés)',
        'Accessible to Customer User Login (exact match)' => 'Hozzáférhető egy ügyfél-felhasználó belépéshez (pontos egyezés)',
        'Created in Queue' => 'Létrehozva a várólistában',
        'Lock state' => 'Zár állapot',
        'Watcher' => 'Megfigyelő',
        'Article Create Time (before/after)' => 'Bejegyzés létrehozási ideje (előtt/után)',
        'Article Create Time (between)' => 'Bejegyzés létrehozási ideje (között)',
        'Please set this to value before end date.' => 'Állítsa ezt egy befejezési dátum előtti értékre.',
        'Please set this to value after start date.' => 'Állítsa ezt egy kezdési dátum utáni értékre.',
        'Ticket Create Time (before/after)' => 'Jegy létrehozási ideje (előtt/után)',
        'Ticket Create Time (between)' => 'Jegy létrehozási ideje (között)',
        'Ticket Change Time (before/after)' => 'Jegy módosítási ideje (előtt/után)',
        'Ticket Change Time (between)' => 'Jegy módosítási ideje (között)',
        'Ticket Last Change Time (before/after)' => 'Jegy utolsó módosítási ideje (előtt/után)',
        'Ticket Last Change Time (between)' => 'Jegy utolsó módosítási ideje (között)',
        'Ticket Pending Until Time (before/after)' => 'Jegy függő befejezési ideje (előtt/után)',
        'Ticket Pending Until Time (between)' => 'Jegy függő befejezési ideje (között)',
        'Ticket Close Time (before/after)' => 'Jegy lezárási ideje (előtt/után)',
        'Ticket Close Time (between)' => 'Jegy lezárási ideje (között)',
        'Ticket Escalation Time (before/after)' => 'Jegy eszkalálási ideje (előtt/után)',
        'Ticket Escalation Time (between)' => 'Jegy eszkalálási ideje (között)',
        'Archive Search' => 'Archívum keresés',

        # Template: AgentTicketZoom
        'Sender Type' => 'Küldőtípus',
        'Save filter settings as default' => 'Szűrőbeállítások mentése alapértelmezettként',
        'Event Type' => 'Eseménytípus',
        'Save as default' => 'Mentés alapértelmezettként',
        'Drafts' => 'Piszkozatok',
        'Change Queue' => 'Várólista módosítása',
        'There are no dialogs available at this point in the process.' =>
            'Nem érhetők el párbeszédek a folyamat ezen pontján.',
        'This item has no articles yet.' => 'Ennek az elemnek még nincsenek bejegyzései.',
        'Ticket Timeline View' => 'Jegy idővonal nézet',
        'Article Overview - %s Article(s)' => 'Bejegyzés áttekintő – %s bejegyzés',
        'Page %s' => '%s. oldal',
        'Add Filter' => 'Szűrő hozzáadása',
        'Set' => 'Beállítás',
        'Reset Filter' => 'Szűrő visszaállítása',
        'No.' => 'Szám',
        'Unread articles' => 'Olvasatlan bejegyzések',
        'Via' => 'Ezen keresztül',
        'Important' => 'Fontos',
        'Unread Article!' => 'Olvasatlan bejegyzés!',
        'Incoming message' => 'Bejövő üzenet',
        'Outgoing message' => 'Kimenő üzenet',
        'Internal message' => 'Belső üzenet',
        'Sending of this message has failed.' => 'Az üzenet küldése nem sikerült.',
        'Resize' => 'Átméretezés',
        'Mark this article as read' => 'Bejegyzés megjelölése olvasottként',
        'Show Full Text' => 'Teljes szöveg megjelenítése',
        'Full Article Text' => 'Teljes bejegyzés szöveg',
        'No more events found. Please try changing the filter settings.' =>
            'Nem található több esemény. Próbáljon meg változtatni a szűrő beállításain.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'ezen keresztül: %s',
        'by %s' => '– %s',
        'Toggle article details' => 'Bejegyzés részleteinek ki- és bekapcsolása',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Az üzenet feldolgozás alatt van. Már %s alkalommal meg lett kísérelve a küldése. A következő próbálkozás %s múlva lesz.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'A következő bejegyzésben lévő hivatkozások megnyitásához lehet, hogy meg kell nyomnia a Ctrl vagy a Cmd vagy a Shift billentyűt, miközben a hivatkozásra kattint (a böngészőjétől és az operációs rendszerétől függően).',
        'Close this message' => 'Üzenet bezárása',
        'Image' => 'Kép',
        'PDF' => 'PDF',
        'Unknown' => 'Ismeretlen',
        'View' => 'Nézet',

        # Template: LinkTable
        'Linked Objects' => 'Kapcsolt objektumok',

        # Template: TicketInformation
        'Archive' => 'Archiválás',
        'This ticket is archived.' => 'Ez a jegy archiválva van.',
        'Note: Type is invalid!' => 'Megjegyzés: a típus érvénytelen!',
        'Pending till' => 'Várakozás eddig',
        'Locked' => 'Zárolt',
        '%s Ticket(s)' => '%s jegy',
        'Accounted time' => 'Elszámolt idő',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'A bejegyzés előnézete nem lehetséges, mert %s csatorna hiányzik a rendszeren.',
        'Please re-install %s package in order to display this article.' =>
            'Telepítse újra a(z) %s csomagot annak érdekében, hogy megjeleníthesse ezt a bejegyzést.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Az adatai védelme érdekében a távoli tartalom blokkolva lett.',
        'Load blocked content.' => 'Blokkolt tartalom betöltése.',

        # Template: Breadcrumb
        'Home' => 'Kezdőoldal',
        'Back to admin overview' => 'Vissza az adminisztrációs áttekintőhöz',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Ez a funkció felhőszolgáltatásokat igényel',
        'You can' => 'Lehetőségei',
        'go back to the previous page' => 'visszatérés az előző oldalra',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'Az ügyfél-azonosító nem változtatható meg, más ügyfél-azonosító nem rendelhető hozzá ehhez a jegyhez.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Először válasszon egy ügyfél-felhasználót, majd választhat egy ügyfél-azonosítót, hogy hozzárendelje ehhez a jegyhez.',
        'Select a customer ID to assign to this ticket.' => 'Ügyfél-azonosító kiválasztása, hogy hozzárendelje ehhez a jegyhez.',
        'From all Customer IDs' => 'Az összes ügyfél-azonosítóból',
        'From assigned Customer IDs' => 'A hozzárendelt ügyfél-azonosítókból',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => 'Új jegy',

        # Template: CustomerError
        'An Error Occurred' => 'Hiba történt',
        'Error Details' => 'Hiba részletei',
        'Traceback' => 'Visszakövetés',

        # Template: CustomerFooter
        'Powered by %s' => 'A gépházban: %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'A(z) %s lehetséges hálózati problémákat észlelt. Megpróbálhatja újratölteni ezt az oldalt kézzel, vagy megvárhatja, amíg a böngészője saját maga létesíti újra a kapcsolatot.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'A kapcsolat ismét kiépítésre került, miután egy átmeneti kapcsolat elveszett. Emiatt az oldalon lévő elemek esetleg nem fognak helyesen működni. Annak érdekében, hogy ismét képes legyen minden elemet helyesen használni, erősen ajánlott az oldal újratöltése.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nem érhető el',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Annak érdekében, hogy megtapasztalja ezt a szoftvert, szükséges lesz engedélyeznie a JavaScriptet a böngészőben.',
        'Browser Warning' => 'Böngésző figyelmeztetés',
        'The browser you are using is too old.' => 'A használt böngésző túl régi.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Ez a szoftver a böngészők hatalmas listájával futtatható, frissítse ezek egyikére.',
        'Please see the documentation or ask your admin for further information.' =>
            'További információkért nézze meg a dokumentációt, vagy kérdezze az adminisztrátort.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => 'Egy pillanat, hamarosan átirányítjuk…',
        'Login' => 'Belépés',
        'Your user name' => 'A felhasználóneve',
        'User name' => 'Felhasználónév',
        'Your password' => 'A jelszava',
        'Forgot password?' => 'Elfelejtette a jelszót?',
        'Your 2 Factor Token' => 'Az Ön kétlépcsős tokenje',
        '2 Factor Token' => 'Kétlépcsős token',
        'Log In' => 'Bejelentkezés',
        'Request Account' => '',
        'Request New Password' => 'Új jelszó kérése',
        'Your User Name' => 'A felhasználóneve',
        'A new password will be sent to your email address.' => 'Az új jelszó el lesz küldve az e-mail címére.',
        'Create Account' => 'Fiók létrehozása',
        'Please fill out this form to receive login credentials.' => 'Töltse ki ezt az űrlapot a bejelentkezési adatok fogadásához.',
        'How we should address you' => 'Hogyan szólítsuk meg',
        'Your First Name' => 'A keresztneve',
        'Your Last Name' => 'A vezetékneve',
        'Your email address (this will become your username)' => 'Az e-mail címe (ez lesz a felhasználóneve)',

        # Template: CustomerNavigationBar
        'Logout' => 'Kilépés',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Üdvözöljük!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Szolgáltatási megállapodás',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Oldal',
        'Tickets' => 'Jegyek',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'például 10*5155 vagy 105658*',
        'CustomerID' => 'Ügyfél-azonosító',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Szabad-szavas keresés a jegyekben (például „Kata*n” vagy „Gerg*”)',
        'Types' => 'Típusok',
        'Time Restrictions' => 'Idő megkötések',
        'No time settings' => 'Nincsenek időbeállítások',
        'All' => 'Összes',
        'Specific date' => 'Adott dátum',
        'Only tickets created' => 'Csak létrehozott jegyek',
        'Date range' => 'Dátumtartomány',
        'Only tickets created between' => 'Csak ezek között létrehozott jegyek',
        'Ticket Archive System' => 'Jegyarchiváló rendszer',
        'Save Search as Template?' => 'Menti a keresést sablonként?',
        'Save as Template?' => 'Menti sablonként?',
        'Save as Template' => 'Mentés sablonként',
        'Template Name' => 'Sablonnév',
        'Pick a profile name' => 'Válasszon egy profilnevet',
        'Output to' => 'Kimenet ide',

        # Template: CustomerTicketSearchResultShort
        'of' => '/',
        'Search Results for' => 'Keresési eredmények ennél',
        'Remove this Search Term.' => 'A keresési kifejezés eltávolítása.',

        # Template: CustomerTicketZoom
        'Reply' => 'Válasz',
        'Discard' => '',
        'Ticket Information' => 'Jegyinformációk',
        'Categories' => '',

        # Template: Chat
        'Expand article' => 'Bejegyzés kinyitása',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Figyelmeztetés',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Esemény információk',
        'Ticket fields' => 'Jegymezők',

        # Template: Error
        'Send a bugreport' => 'Hibajelentés küldése',
        'Expand' => 'Kinyitás',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Kattintson a melléklet törléséhez.',

        # Template: DraftButtons
        'Update draft' => 'Piszkozat frissítése',
        'Save as new draft' => 'Mentés új piszkozatként',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Betöltötte a következő piszkozatot: „%s”.',
        'You have loaded the draft "%s". You last changed it %s.' => 'Betöltötte a következő piszkozatot: „%s”. Utoljára %s-kor változtatta meg.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Betöltötte a következő piszkozatot: „%s”. Utoljára %s-kor %s változtatta meg.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Ne feledje, hogy ez a piszkozat elavult, mert a jegyet módosították a piszkozat létrehozása óta.',

        # Template: Header
        'Edit personal preferences' => 'Személyes beállítások szerkesztése',
        'Personal preferences' => 'Személyes beállítások',
        'You are logged in as' => 'Belépett a következő néven:',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nem érhető el',
        'Step %s' => '%s. lépés',
        'License' => 'Licenc',
        'Database Settings' => 'Adatbázis-beállítások',
        'General Specifications and Mail Settings' => 'Általános specifikációk és levelezési beállítások',
        'Finish' => 'Befejezés',
        'Welcome to %s' => 'Üdvözli a(z) %s',
        'Germany' => 'Németország',
        'Phone' => 'Telefon',
        'Switzerland' => '',
        'Web site' => 'Weboldal',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Kimenő levél beállítása',
        'Outbound mail type' => 'Kimenő levél típusa',
        'Select outbound mail type.' => 'Válassza ki a kimenő levél típusát.',
        'Outbound mail port' => 'Kimenő levél portja',
        'Select outbound mail port.' => 'Válassza ki a kimenő levél portját.',
        'SMTP host' => 'SMTP kiszolgáló',
        'SMTP host.' => 'SMTP kiszolgáló.',
        'SMTP authentication' => 'SMTP hitelesítés',
        'Does your SMTP host need authentication?' => 'Az SMTP kiszolgáló igényel hitelesítést?',
        'SMTP auth user' => 'SMTP hitelesítő felhasználó',
        'Username for SMTP auth.' => 'Felhasználónév az SMTP hitelesítéshez.',
        'SMTP auth password' => 'SMTP hitelesítő jelszó',
        'Password for SMTP auth.' => 'Jelszó az SMTP hitelesítéshez.',
        'Configure Inbound Mail' => 'Bejövő levél beállítása',
        'Inbound mail type' => 'Bejövő levél típusa',
        'Select inbound mail type.' => 'Válassza ki a bejövő levél típusát.',
        'Inbound mail host' => 'Bejövő levél kiszolgálója',
        'Inbound mail host.' => 'Bejövő levél kiszolgálója.',
        'Inbound mail user' => 'Bejövő levél felhasználója',
        'User for inbound mail.' => 'Felhasználó a bejövő levélhez.',
        'Inbound mail password' => 'Bejövő levél jelszava',
        'Password for inbound mail.' => 'Jelszó a bejövő levélhez.',
        'Result of mail configuration check' => 'A levélbeállítás-ellenőrzés eredménye',
        'Check mail configuration' => 'Levélbeállítás ellenőrzése',
        'Skip this step' => 'Lépés kihagyása',

        # Template: InstallerDBResult
        'Done' => 'Kész',
        'Error' => 'Hiba',
        'Database setup successful!' => 'Az adatbázis beállítása sikeres!',

        # Template: InstallerDBStart
        'Install Type' => 'Telepítés típusa',
        'Create a new database for OTOBO' => 'Új adatbázis létrehozása az OTOBO-hez',
        'Use an existing database for OTOBO' => 'Meglévő adatbázis használata az OTOBO-hez',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Ha az adatbázishoz rendszergazda jelszót állított be, akkor azt itt meg kell adni. Ha nem, hagyja üresen ezt a mezőt.',
        'Database name' => 'Adatbázis neve',
        'Check database settings' => 'Adatbázis-beállítások ellenőrzése',
        'Result of database check' => 'Az adatbázis-ellenőrzés eredménye',
        'Database check successful.' => 'Az adatbázis-ellenőrzés sikeres.',
        'Database User' => 'Adatbázis felhasználó',
        'New' => 'Új',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Egy új, korlátozott jogosultságokkal rendelkező adatbázis felhasználó lesz létrehozva ehhez az OTOBO rendszerhez.',
        'Repeat Password' => 'Jelszó ismétlése',
        'Generated password' => 'Előállított jelszó',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'A jelszavak nem egyeznek',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Ahhoz, hogy az OTOBO-t használni tudja, a következő parancsot kell begépelnie a parancssorba (terminálban/parancsértelmezőben) rendszergazdaként.',
        'Restart your webserver' => 'Indítsa újra a webkiszolgálót',
        'After doing so your OTOBO is up and running.' => 'Miután ezt megtette, az OTOBO készen áll és fut.',
        'Start page' => 'Kezdőoldal',
        'Your OTOBO Team' => 'Az OTOBO csapata',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Licenc elutasítása',
        'Accept license and continue' => 'Licenc elfogadása és folytatás',

        # Template: InstallerSystem
        'SystemID' => 'Rendszer azonosító',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'A rendszer azonosítója. Minden jegyszám és minden HTTP munkamenet-azonosító tartalmazza ezt a számot.',
        'System FQDN' => 'Rendszer FQDN',
        'Fully qualified domain name of your system.' => 'A rendszer teljes képzésű tartományneve.',
        'AdminEmail' => 'Adminisztrátori e-mail',
        'Email address of the system administrator.' => 'A rendszer adminisztrátorának e-mail címe.',
        'Organization' => 'Szervezet',
        'Log' => 'Napló',
        'LogModule' => 'Naplómodul',
        'Log backend to use.' => 'A használandó naplózó háttérprogram.',
        'LogFile' => 'Naplófájl',
        'Webfrontend' => 'Webes felhasználói felület',
        'Default language' => 'Alapértelmezett nyelv',
        'Default language.' => 'Alapértelmezett nyelv.',
        'CheckMXRecord' => 'MX rekord ellenőrzése',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'A kézzel megadott e-mail címek ellenőrzése a DNS-ben található MX rekordokkal. Ne használja ezt a lehetőséget, ha a DNS lassú, vagy nem oldja fel a nyilvános címeket.',

        # Template: LinkObject
        'Delete link' => 'Kapcsolat törlése',
        'Delete Link' => 'Kapcsolat törlése',
        'Object#' => 'Objektum#',
        'Add links' => 'Kapcsolatok hozzáadása',
        'Delete links' => 'Kapcsolatok törlése',

        # Template: Login
        'Lost your password?' => 'Elfelejtette a jelszavát?',
        'Back to login' => 'Vissza a bejelentkezéshez',

        # Template: MetaFloater
        'Scale preview content' => 'Előnézet tartalmának méretezése',
        'Open URL in new tab' => 'URL megnyitása új lapon',
        'Close preview' => 'Előnézet bezárása',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Ennek a weboldalnak nem lehet biztosítani az előnézetét, mert nem engedte meg a beágyazását.',

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
        'Feature not Available' => 'A szolgáltatás nem érhető el',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Sajnáljuk, de az OTOBO ezen szolgáltatása jelenleg nem érhető el mobil készülékekről. Ha használni szeretné, akkor vagy váltson asztali módra, vagy használja a megszokott asztali eszközét.',

        # Template: Motd
        'Message of the Day' => 'A nap üzenete',
        'This is the message of the day. You can edit this in %s.' => 'Ez a nap üzenete. Ezt a %s fájlban szerkesztheti.',

        # Template: NoPermission
        'Insufficient Rights' => 'Nincs elegendő joga',
        'Back to the previous page' => 'Vissza az előző oldalra',

        # Template: Alert
        'Alert' => 'Riasztás',
        'Powered by' => 'A gépházban:',

        # Template: Pagination
        'Show first page' => 'Első oldal megjelenítése',
        'Show previous pages' => 'Előző oldalak megjelenítése',
        'Show page %s' => '%s. oldal megjelenítése',
        'Show next pages' => 'Következő oldalak megjelenítése',
        'Show last page' => 'Utolsó oldal megjelenítése',

        # Template: PictureUpload
        'Need FormID!' => 'Űrlap-azonosító szükséges!',
        'No file found!' => 'Nem található fájl!',
        'The file is not an image that can be shown inline!' => 'A fájl nem olyan kép, amelyet beágyazva meg lehetne jeleníteni!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Nem találhatók felhasználó által beállítható értesítések.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Üzenetek fogadása a(z) „%s” értesítéshez a(z) „%s” átviteli módszerrel.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Folyamat-információk',
        'Dialog' => 'Párbeszéd',

        # Template: Article
        'Inform Agent' => 'Ügyintéző értesítése',

        # Template: PublicDefault
        'Welcome' => 'Üdvözöljük',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Ez az OTOBO alapértelmezett nyilvános felülete! Nem került megadásra műveleti paraméter.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Telepíthetne egy olyan egyéni nyilvános modult (a csomagkezelőn keresztül), amelynek van nyilvános felülete, mint például a GyIK modulnak.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Jogosultságok',
        'You can select one or more groups to define access for different agents.' =>
            'Kiválaszthat egy vagy több csoportot a hozzáférés meghatározásához a különböző ügyintézőknél.',
        'Result formats' => 'Eredmény formátumok',
        'Time Zone' => 'Időzóna',
        'The selected time periods in the statistic are time zone neutral.' =>
            'A kiválasztott időszakok a statisztikában időzóna semlegesek.',
        'Create summation row' => 'Összegző sor létrehozása',
        'Generate an additional row containing sums for all data rows.' =>
            'Egy további sort állít elő, amely az összes adatsor összegeit tartalmazza.',
        'Create summation column' => 'Összegző oszlop létrehozása',
        'Generate an additional column containing sums for all data columns.' =>
            'Egy további oszlopot állít elő, amely az összes adatoszlop összegeit tartalmazza.',
        'Cache results' => 'Eredmények gyorstárazása',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Eltárolja a statisztikák eredményadatait egy gyorsítótárban az azonos beállítással rendelkező későbbi nézetekben való használathoz (legalább egy kiválasztott időmezőt igényel).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'A statisztika biztosítása felületi elemként, amelyet az ügyintézők aktiválhatnak a vezérlőpultjukon.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Ne feledje, hogy a vezérlőpult felületi elem engedélyezése aktiválni fogja a statisztika gyorsítótárának használatát a vezérlőpulton.',
        'If set to invalid end users can not generate the stat.' => 'Ha érvénytelenre állítja, a végfelhasználók nem tudják a statisztikát előállítani.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Problémák vannak ennek a statisztikának a beállításaiban:',
        'You may now configure the X-axis of your statistic.' => 'Most beállíthatja a statisztika X-tengelyét.',
        'This statistic does not provide preview data.' => 'Ez a statisztika nem szolgáltat előnézeti adatokat.',
        'Preview format' => 'Előnézeti formátum',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Ne feledje, hogy az előnézet véletlenszerű adatokat használ, és nincs tekintettel az adatszűrőkre.',
        'Configure X-Axis' => 'X-tengely beállítása',
        'X-axis' => 'X-tengely',
        'Configure Y-Axis' => 'Y-tengely beállítása',
        'Y-axis' => 'Y-tengely',
        'Configure Filter' => 'Szűrő beállítása',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Csak egyetlen elemet válasszon, vagy kapcsolja ki a „Rögzített” gombot.',
        'Absolute period' => 'Abszolút időszak',
        'Between %s and %s' => '%s és %s között',
        'Relative period' => 'Relatív időszak',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'A már teljes %s és a jelenlegi+közelgő teljes %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Ne tegyen lehetővé változtatásokat ezen az elemen, amikor a statisztikát előállítják.',

        # Template: StatsParamsWidget
        'Format' => 'Formátum',
        'Exchange Axis' => 'Tengelyek felcserélése',
        'Configurable Params of Static Stat' => 'Statikus statisztika beállítható paraméterei',
        'No element selected.' => 'Nincs elem kiválasztva.',
        'Scale' => 'Skála',
        'show more' => 'több megjelenítése',
        'show less' => 'kevesebb megjelenítése',

        # Template: D3
        'Download SVG' => 'SVG letöltése',
        'Download PNG' => 'PNG letöltése',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'A kijelölt időszak határozza meg azt az alapértelmezett időkeretet ennél a statisztikánál, amelyből az adatokat begyűjti.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Azt az időegységet határozza meg, amely a kijelölt időszaknak jelentési adatpontokba történő felosztásához lesz használva.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Ne feledje, hogy az Y-tengely méretezésének nagyobbnak kell lennie az X-tengely méretezésénél (például X-tengely => Hónap, Y-tengely => Év).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Ez a beállítás le van tiltva.',
        'This setting is fixed but not deployed yet!' => 'Ez a beállítás javítva lett, de még nincs üzembe állítva!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Ez a beállítás jelenleg felülírásra kerül ebben: %s, és ezért itt nem változtatható meg!',
        'Changing this setting is only available in a higher config level!' =>
            'A beállítás megváltoztatása csak magasabb beállítási szinten érhető el!',
        '%s (%s) is currently working on this setting.' => '%s (%s) jelenleg ezzel a beállítással dolgozik.',
        'Toggle advanced options for this setting' => 'Speciális lehetőségek ki- és bekapcsolása ehhez a beállításhoz',
        'Disable this setting, so it is no longer effective' => 'A beállítás letiltása, hogy többé ne legyen hatályban',
        'Disable' => 'Letiltás',
        'Enable this setting, so it becomes effective' => 'A beállítás engedélyezése, hogy hatályban lévő legyen',
        'Enable' => 'Engedélyezés',
        'Reset this setting to its default state' => 'A beállítás visszaállítása az alapértelmezett állapotára',
        'Reset setting' => 'Beállítás visszaállítása',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Lehetővé teszi a felhasználóknak ezen beállítás elfogadását a személyes beállításaikon belülről',
        'Allow users to update' => 'Engedélyezés a felhasználóknak a frissítéshez',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Többé ne tegye lehetővé a felhasználóknak ezen beállítás elfogadását a személyes beállításaikon belülről',
        'Forbid users to update' => 'Tiltás a felhasználóknak a frissítéshez',
        'Show user specific changes for this setting' => 'Felhasználóra jellemző változások megjelenítése ennél a beállításnál',
        'Show user settings' => 'Felhasználói beállítások megjelenítése',
        'Copy a direct link to this setting to your clipboard' => 'Erre a beállításra mutató közvetlen hivatkozás másolása a vágólapra',
        'Copy direct link' => 'Közvetlen hivatkozás másolása',
        'Remove this setting from your favorites setting' => 'A beállítás eltávolítása a kedvenc beállításokból',
        'Remove from favourites' => 'Eltávolítás a kedvencekből',
        'Add this setting to your favorites' => 'A beállítás hozzáadása a kedvencekhez',
        'Add to favourites' => 'Hozzáadás a kedvencekhez',
        'Cancel editing this setting' => 'A beállítás szerkesztésének megszakítása',
        'Save changes on this setting' => 'A beállításon elvégzett változások mentése',
        'Edit this setting' => 'A beállítás szerkesztése',
        'Enable this setting' => 'A beállítás engedélyezése',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Ez a csoport nem tartalmaz egyetlen beállítást sem. Próbáljon meg az alcsoportjai egyikére vagy egy másik csoportra navigálni.',

        # Template: SettingsListCompare
        'Now' => 'Most',
        'User modification' => 'Felhasználó-módosítás',
        'enabled' => 'engedélyezve',
        'disabled' => 'letiltva',
        'Setting state' => 'Beállítás állapota',

        # Template: Actions
        'Edit search' => 'Keresés szerkesztése',
        'Go back to admin: ' => 'Vissza az adminisztrációhoz: ',
        'Deployment' => 'Üzembe állítás',
        'My favourite settings' => 'Kedvenc beállításaim',
        'Invalid settings' => 'Érvénytelen beállítások',

        # Template: DynamicActions
        'Filter visible settings...' => 'Látható beállítások szűrése…',
        'Enable edit mode for all settings' => 'Szerkesztőmód engedélyezése az összes beállításnál',
        'Save all edited settings' => 'Az összes szerkesztett beállítás mentése',
        'Cancel editing for all settings' => 'Szerkesztés megszakítása az összes beállításnál',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Ebből a felületi elemből az összes művelet csak a jobb oldalon látható beállításokra lesz alkalmazva.',

        # Template: Help
        'Currently edited by me.' => 'Jelenleg én szerkesztem.',
        'Modified but not yet deployed.' => 'Módosított, de még nem üzembe állított.',
        'Currently edited by another user.' => 'Jelenleg másik felhasználó által szerkesztve.',
        'Different from its default value.' => 'Eltérő az alapértelmezett értékétől.',
        'Save current setting.' => 'Jelenlegi beállítás mentése.',
        'Cancel editing current setting.' => 'Jelenlegi beállítás szerkesztésének megszakítása.',

        # Template: Navigation
        'Navigation' => 'Navigáció',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO tesztoldal',
        'Unlock' => 'Feloldás',
        'Welcome %s %s' => 'Üdvözli a(z) %s %s',
        'Counter' => 'Számláló',

        # Template: Warning
        'Go back to the previous page' => 'Vissza az előző oldalra',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Megjelenítés',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Piszkozat címe',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Bejegyzés megjelenítés',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Valóban törölni szeretné a következőt: „%s”?',
        'Confirm' => 'Megerősítés',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Betöltés, kérem várjon…',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Kattintson egy feltöltendő fájl kiválasztásához.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Kattintson a fájlok kijelöléséhez, vagy egyszerűen dobja ide azokat.',
        'Click to select a file or just drop it here.' => 'Kattintson egy fájl kijelöléséhez, vagy egyszerűen dobja ide azt.',
        'Uploading...' => 'Feltöltés…',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => 'Folyamat állapota',
        'Running' => 'Fut',
        'Finished' => 'Befejezve',
        'No package information available.' => 'Nem érhetők el csomaginformációk.',

        # JS Template: AddButton
        'Add new entry' => 'Új bejegyzés hozzáadása',

        # JS Template: AddHashKey
        'Add key' => 'Kulcs hozzáadása',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Üzembe állítás megjegyzése…',
        'This field can have no more than 250 characters.' => 'Ez a mező nem tartalmazhat 250 karakternél többet.',
        'Deploying, please wait...' => 'Üzembe állítás, kérem várjon…',
        'Preparing to deploy, please wait...' => 'Előkészítés az üzembe állításhoz, kérem várjon…',
        'Deploy now' => 'Üzembe állítás most',
        'Try again' => 'Próbálja újra',

        # JS Template: DialogReset
        'Reset options' => 'Lehetőségek visszaállítása',
        'Reset setting on global level.' => 'Beállítás visszaállítása globális szinten.',
        'Reset globally' => 'Visszaállítás globálisan',
        'Remove all user changes.' => 'Az összes felhasználói változtatás eltávolítása.',
        'Reset locally' => 'Visszaállítás lokálisan',
        'user(s) have modified this setting.' => 'felhasználó módosította ezt a beállítást.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Valóban vissza szeretné állítani ezt a beállítást az alapértelmezett értékére?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Használhatja a kategóriaválasztást a lenti navigációs fának a kijelölt kategóriából származó bejegyzésekre való korlátozásához. Amint kiválasztja a kategóriát, a fa újraépítésre kerül.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Adatbázis háttérprogram',
        'CustomerIDs' => 'Ügyfél-azonosítók',
        'Fax' => 'Fax',
        'Street' => 'Utca',
        'Zip' => 'Irányítószám',
        'City' => 'Város',
        'Country' => 'Ország',
        'Mr.' => 'Úr',
        'Mrs.' => 'Úrhölgy',
        'Address' => 'Cím',
        'View system log messages.' => 'Rendszernapló üzenetek megtekintése.',
        'Edit the system configuration settings.' => 'A rendszer konfigurációs beállításainak szerkesztése.',
        'Update and extend your system with software packages.' => 'A rendszer frissítése vagy kibővítése szoftvercsomagokkal.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Az adatbázis ACL információi nincsenek szinkronizálva a rendszer beállításaival, állítson üzembe minden ACL-t.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Az ACL-eket nem sikerült importálni egy ismeretlen hiba miatt, további információkért nézze meg az OTOBO naplókat',
        'The following ACLs have been added successfully: %s' => 'A következő ACL-ek sikeresen hozzá lettek adva: %s',
        'The following ACLs have been updated successfully: %s' => 'A következő ACL-ek sikeresen frissítve lettek: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Hibák történtek a következő ACL-ek hozzáadásakor vagy frissítésekor: %s. További információkért nézze meg a naplófájlt.',
        'There was an error creating the ACL' => 'Hiba történt az ACL létrehozásakor',
        'Need ACLID!' => 'ACL-azonosító szükséges!',
        'Could not get data for ACLID %s' => 'Nem sikerült lekérni az adatokat az ACL-azonosítóhoz: %s',
        'There was an error updating the ACL' => 'Hiba történt az ACL frissítésekor',
        'There was an error setting the entity sync status.' => 'Hiba történt az egyed szinkronizációs állapotának beállításakor.',
        'There was an error synchronizing the ACLs.' => 'Hiba történt az ACL-ek szinkronizálásakor.',
        'ACL %s could not be deleted' => 'A(z) %s ACL törlése nem sikerült',
        'There was an error getting data for ACL with ID %s' => 'Hiba történt az adatok lekérésekor a(z) %s azonosítóval rendelkező ACL-nél',
        '%s (copy) %s' => '%s (másolat) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Ne feledje, hogy az ACL korlátozások mellőzve lesznek a rendszergazda fióknál (1-es felhasználó-azonosító).',
        'Exact match' => 'Pontos egyezés',
        'Negated exact match' => 'Tagadott pontos egyezés',
        'Regular expression' => 'Reguláris kifejezés',
        'Regular expression (ignore case)' => 'Reguláris kifejezés (kis- és nagybetű megegyezik)',
        'Negated regular expression' => 'Tagadott reguláris kifejezés',
        'Negated regular expression (ignore case)' => 'Tagadott reguláris kifejezés (kis- és nagybetű megegyezik)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'A rendszer nem tudta létrehozni a naptárat!',
        'Please contact the administrator.' => 'Vegye fel a kapcsolatot a rendszergazdával.',
        'No CalendarID!' => 'Nincs naptár-azonosító!',
        'You have no access to this calendar!' => 'Nincs hozzáférése ehhez a naptárhoz!',
        'Error updating the calendar!' => 'Hiba a naptár frissítésekor!',
        'Couldn\'t read calendar configuration file.' => 'Nem sikerült beolvasni a naptárbeállító fájlt.',
        'Please make sure your file is valid.' => 'Győződjön meg arról, hogy a fájl érvényes-e.',
        'Could not import the calendar!' => 'Nem sikerült importálni a naptárat!',
        'Calendar imported!' => 'Naptár importálva!',
        'Need CalendarID!' => 'Naptár-azonosító szükséges!',
        'Could not retrieve data for given CalendarID' => 'Nem sikerült lekérni az adatokat a megadott naptár-azonosítóhoz',
        'Successfully imported %s appointment(s) to calendar %s.' => '%s időpont sikeresen importálva a(z) %s naptárba.',
        '+5 minutes' => '+5 perc',
        '+15 minutes' => '+15 perc',
        '+30 minutes' => '+30 perc',
        '+1 hour' => '+1 óra',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Nincsenek jogosultságok',
        'System was unable to import file!' => 'A rendszer nem tudta importálni a fájlt!',
        'Please check the log for more information.' => 'További információkért nézze meg a naplót.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Az értesítés neve már létezik!',
        'Notification added!' => 'Értesítés hozzáadva!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Hiba történt az adatok lekérésekor az ID:%s azonosítóval rendelkező értesítésnél!',
        'Unknown Notification %s!' => 'Ismeretlen értesítés: %s!',
        '%s (copy)' => '%s (másolat)',
        'There was an error creating the Notification' => 'Hiba történt az értesítés létrehozásakor',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Az értesítéseket nem sikerült importálni egy ismeretlen hiba miatt, további információkért nézze meg az OTOBO naplókat',
        'The following Notifications have been added successfully: %s' =>
            'A következő értesítések sikeresen hozzá lettek adva: %s',
        'The following Notifications have been updated successfully: %s' =>
            'A következő értesítések sikeresen frissítve lettek: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Hibák történtek a következő értesítések hozzáadásakor vagy frissítésekor: %s. További információkért nézze meg a naplófájlt.',
        'Notification updated!' => 'Értesítés frissítve!',
        'Agent (resources), who are selected within the appointment' => 'Ügyintéző (erőforrások), aki az időponton belül ki lett jelölve',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Az összes ügyintéző, akiknek (legalább) olvasási jogosultságuk van az időponthoz (naptárhoz)',
        'All agents with write permission for the appointment (calendar)' =>
            'Az összes ügyintéző, akiknek írási jogosultságuk van az időponthoz (naptárhoz)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Melléklet hozzáadva!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Automatikus válasz hozzáadva!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'Érvénytelen kommunikáció-azonosító!',
        'All communications' => 'Összes kommunikáció',
        'Last 1 hour' => 'Utolsó 1 óra',
        'Last 3 hours' => 'Utolsó 3 óra',
        'Last 6 hours' => 'Utolsó 6 óra',
        'Last 12 hours' => 'Utolsó 12 óra',
        'Last 24 hours' => 'Utolsó 24 óra',
        'Last week' => 'Utolsó hét',
        'Last month' => 'Utolsó hónap',
        'Invalid StartTime: %s!' => 'Érvénytelen kezdési idő: %s!',
        'Successful' => 'Sikeres',
        'Processing' => 'Feldolgozás alatt',
        'Failed' => 'Sikertelen',
        'Invalid Filter: %s!' => 'Érvénytelen szűrő: %s!',
        'Less than a second' => 'Kevesebb mint egy másodperc',
        'sorted descending' => 'csökkenően rendezve',
        'sorted ascending' => 'növekvően rendezve',
        'Trace' => 'Követés',
        'Debug' => 'Hibakeresés',
        'Info' => 'Információ',
        'Warn' => 'Figyelmeztetés',
        'days' => 'nap',
        'day' => 'nap',
        'hour' => 'óra',
        'minute' => 'perc',
        'seconds' => 'másodperc',
        'second' => 'másodperc',

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
        'Customer company updated!' => 'Ügyfél-vállalat frissítve!',
        'Dynamic field %s not found!' => 'A(z) %s dinamikus mező nem található!',
        'Unable to set value for dynamic field %s!' => 'Nem lehet beállítani a(z) %s dinamikus mező értékét!',
        'Customer Company %s already exists!' => 'A(z) %s ügyfél-vállalat már létezik!',
        'Customer company added!' => 'Ügyfél-vállalat hozzáadva!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Nem található beállítás a „CustomerGroupPermissionContext” értékéhez!',
        'Please check system configuration.' => 'Ellenőrizze a rendszerbeállításokat.',
        'Invalid permission context configuration:' => 'Érvénytelen jogosultsági környezet beállítás:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Ügyfél frissítve!',
        'New phone ticket' => 'Új telefonos jegy',
        'New email ticket' => 'Új e-mail jegy',
        'Customer %s added' => '%s ügyfél hozzáadva',
        'Customer user updated!' => 'Ügyfél-felhasználó frissítve!',
        'Same Customer' => 'Ugyanaz az ügyfél',
        'Direct' => 'Közvetlen',
        'Indirect' => 'Közvetett',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Ügyfélfelhasználó-kapcsolatok megváltoztatása egy csoportnál',
        'Change Group Relations for Customer User' => 'Csoportkapcsolatok megváltoztatása egy ügyfél-felhasználónál',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Ügyfél-felhasználók kiosztása a szolgáltatáshoz',
        'Allocate Services to Customer User' => 'Szolgáltatások kiosztása az ügyfél-felhasználóhoz',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'A mezők beállítása nem érvényes',
        'Objects configuration is not valid' => 'Az objektumok beállítása nem érvényes',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Nem sikerült megfelelően visszaállítani a dinamikus mező sorrendjét. További részletekért nézze meg a hibanaplót.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Meghatározatlan alművelet.',
        'Need %s' => '%s szükséges',
        'Add %s field' => '%s mező hozzáadása',
        'The field does not contain only ASCII letters and numbers.' => 'Ez a mező nem csak ASCII betűket és számokat tartalmaz.',
        'There is another field with the same name.' => 'Már létezik egy ugyanilyen nevű mező.',
        'The field must be numeric.' => 'Ez a mező csak számot tartalmazhat.',
        'Need ValidID' => 'Érvényesség-azonosító szükséges',
        'Could not create the new field' => 'Nem sikerült létrehozni az új mezőt',
        'Need ID' => 'Azonosító szükséges',
        'Could not get data for dynamic field %s' => 'Nem sikerült lekérni az adatokat a dinamikus mezőhöz: %s',
        'Change %s field' => '%s mező megváltoztatása',
        'The name for this field should not change.' => 'Ennek a mezőnek a nevét nem szabad megváltoztatni.',
        'Could not update the field %s' => 'Nem sikerült frissíteni a következő mezőt: %s',
        'Currently' => 'Jelenleg',
        'Unchecked' => 'Nincs bejelölve',
        'Checked' => 'Bejelölve',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Ez a mezőérték kettőzött.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Jövőbeli dátumbejegyzések megakadályozása',
        'Prevent entry of dates in the past' => 'Múltbeli dátumbejegyzések megakadályozása',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => 'A beállítást egy másik felhasználó zárolta!',
        'System was not able to reset the setting!' => 'A rendszer nem volt képes visszaállítani a beállítást!',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Válasszon legalább egy címzettet.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'perc',
        'hour(s)' => 'óra',
        'Time unit' => 'Időegység',
        'within the last ...' => 'az elmúlt … belül',
        'within the next ...' => 'a következő … belül',
        'more than ... ago' => 'több mint … ezelőtt',
        'Unarchived tickets' => 'Archiválatlan jegyek',
        'archive tickets' => 'jegyek archiválása',
        'restore tickets from archive' => 'jegyek visszaállítása az archívumból',
        'Need Profile!' => 'Profil szükséges!',
        'Got no values to check.' => 'Nem kaptam értékeket az ellenőrzéshez.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Távolítsa el a következő szavakat, mert azok nem használhatók a jegykiválasztásnál:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Webszolgáltatás-azonosító szükséges!',
        'Could not get data for WebserviceID %s' => 'Nem sikerült lekérni az adatokat a webszolgáltatás-azonosítóhoz: %s',
        'ascending' => 'növekvő',
        'descending' => 'csökkenő',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Kommunikációs típus szükséges!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'A kommunikációs típusnak „kérelmezőnek” vagy „szolgáltatónak” kell lennie!',
        'Invalid Subaction!' => 'Érvénytelen alművelet!',
        'Need ErrorHandlingType!' => 'Hibakeresési típus szükséges!',
        'ErrorHandlingType %s is not registered' => 'A(z) %s hibakeresési típus nincs regisztrálva',
        'Could not update web service' => 'Nem sikerült frissíteni a webszolgáltatást',
        'Need ErrorHandling' => 'Hibakezelés szükséges',
        'Could not determine config for error handler %s' => 'Nem sikerült meghatározni a beállítást a(z) %s hibakezelőnél',
        'Invoker processing outgoing request data' => 'Kimenő kérés adatainak meghívó feldolgozása',
        'Mapping outgoing request data' => 'Kimenő kérés adatainak leképezése',
        'Transport processing request into response' => 'Átvitel által feldolgozott kérés válaszba',
        'Mapping incoming response data' => 'Bejövő válasz adatainak leképezése',
        'Invoker processing incoming response data' => 'Meghívó által feldolgozott bejövő válaszadatok',
        'Transport receiving incoming request data' => 'Átvitel által fogadott bejövő kérésadatok',
        'Mapping incoming request data' => 'Bejövő kérés adatainak leképezése',
        'Operation processing incoming request data' => 'Művelet által feldolgozott bejövő kérésadatok',
        'Mapping outgoing response data' => 'Kimenő válasz adatainak leképezése',
        'Transport sending outgoing response data' => 'Átvitel által küldött kimenő válaszadatok',
        'skip same backend modules only' => 'csak ugyanazon háttérprogram-modulok kihagyása',
        'skip all modules' => 'az összes modul kihagyása',
        'Operation deleted' => 'Művelet törölve',
        'Invoker deleted' => 'Meghívó törölve',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 másodperc',
        '15 seconds' => '15 másodperc',
        '30 seconds' => '30 másodperc',
        '45 seconds' => '45 másodperc',
        '1 minute' => '1 perc',
        '2 minutes' => '2 perc',
        '3 minutes' => '3 perc',
        '4 minutes' => '4 perc',
        '5 minutes' => '5 perc',
        '10 minutes' => '10 perc',
        '15 minutes' => '15 perc',
        '30 minutes' => '30 perc',
        '1 hour' => '1 óra',
        '2 hours' => '2 óra',
        '3 hours' => '3 óra',
        '4 hours' => '4 óra',
        '5 hours' => '5 óra',
        '6 hours' => '6 óra',
        '12 hours' => '12 óra',
        '18 hours' => '18 óra',
        '1 day' => '1 nap',
        '2 days' => '2 nap',
        '3 days' => '3 nap',
        '4 days' => '4 nap',
        '6 days' => '6 nap',
        '1 week' => '1 hét',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Nem sikerült meghatározni a beállítást a(z) %s meghívónál',
        'InvokerType %s is not registered' => 'A(z) %s meghívótípus nincs regisztrálva',
        'MappingType %s is not registered' => 'A(z) %s leképezéstípus nincs regisztrálva',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Meghívó szükséges!',
        'Need Event!' => 'Esemény szükséges!',
        'Could not get registered modules for Invoker' => 'Nem sikerült lekérni a regisztrált modulokat a meghívóhoz',
        'Could not get backend for Invoker %s' => 'Nem sikerült lekérni a háttérprogramot a(z) %s meghívóhoz',
        'The event %s is not valid.' => 'A(z) %s esemény nem érvényes.',
        'Could not update configuration data for WebserviceID %s' => 'Nem sikerült frissíteni a beállítási adatokat a(z) %s webszolgáltatás-azonosítónál',
        'This sub-action is not valid' => 'Ez az alművelet nem érvényes',
        'xor' => 'kizáró vagy',
        'String' => 'Szöveg',
        'Regexp' => 'Reguláris kifejezés',
        'Validation Module' => 'Ellenőrző modul',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Egyszerű leképezés a kimenő adatokhoz',
        'Simple Mapping for Incoming Data' => 'Egyszerű leképezés a bejövő adatokhoz',
        'Could not get registered configuration for action type %s' => 'Nem sikerült regisztráltatni a beállítást a(z) %s művelettípushoz',
        'Could not get backend for %s %s' => 'Nem sikerült lekérni a háttérprogramot ennél: %s %s',
        'Keep (leave unchanged)' => 'Megtartás (változatlanul hagyás)',
        'Ignore (drop key/value pair)' => 'Mellőzés (kulcs-érték pár eldobása)',
        'Map to (use provided value as default)' => 'Leképezés (biztosított érték használata alapértelmezettként)',
        'Exact value(s)' => 'Pontos értékek',
        'Ignore (drop Value/value pair)' => 'Mellőzés (érték-érték pár eldobása)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'XSLT leképezés a kimenő adatokhoz',
        'XSLT Mapping for Incoming Data' => 'XSLT leképezés a bejövő adatokhoz',
        'Could not find required library %s' => 'Nem található a szükséges programkönyvtár: %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Kimenő kérésadatok a feldolgozás előtt (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Kimenő kérésadatok a leképezés előtt (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Kimenő kérésadatok a leképezés után (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Bejövő válaszadatok a leképezés előtt (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Kimenő hibakezelő adatok a hibakezelés után (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Bejövő kérésadatok a leképezés előtt (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Bejövő kérésadatok a leképezés után (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Kimenő válaszadatok a leképezés előtt (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Kimenő hibakezelő adatok a hibakezelés után (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Nem sikerült meghatározni a beállítást a(z) %s műveletnél',
        'OperationType %s is not registered' => 'A(z) %s művelettípus nincs regisztrálva',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Érvényes alművelet szükséges!',
        'This field should be an integer.' => 'Ez a mező csak egész szám lehet.',
        'File or Directory not found.' => 'Fájl vagy könyvtár nem található.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Már létezik egy ugyanilyen nevű webszolgáltatás.',
        'There was an error updating the web service.' => 'Hiba történt a webszolgáltatás frissítésekor.',
        'There was an error creating the web service.' => 'Hiba történt a webszolgáltatás létrehozásakor.',
        'Web service "%s" created!' => 'A(z) „%s” webszolgáltatás létrehozva!',
        'Need Name!' => 'Név szükséges!',
        'Need ExampleWebService!' => 'Példa webszolgáltatás szükséges!',
        'Could not load %s.' => 'Nem sikerült betölteni: %s.',
        'Could not read %s!' => 'Nem sikerült olvasni: %s!',
        'Need a file to import!' => 'Egy fájl szükséges az importáláshoz!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Az importált fájl nem rendelkezik érvényes YAML tartalommal! A részletekért nézze meg az OTOBO naplóját.',
        'Web service "%s" deleted!' => 'A(z) „%s” webszolgáltatás törölve!',
        'OTOBO as provider' => 'OTOBO mint szolgáltató',
        'Operations' => 'Műveletek',
        'OTOBO as requester' => 'OTOBO mint kérelmező',
        'Invokers' => 'Meghívók',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Nem kaptam webszolgáltatás előzmény-azonosítót!',
        'Could not get history data for WebserviceHistoryID %s' => 'Nem sikerült lekérni az előzményadatokat a(z) %s webszolgáltatás előzmény-azonosítóhoz',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Csoport frissítve!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Levelezőfiók hozzáadva!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Az e-mail fiók lekérését egy másik folyamat már lekérte. Próbálja meg később újra!',
        'Dispatching by email To: field.' => 'Szétválogatás az e-mail címzett mezője szerint.',
        'Dispatching by selected Queue.' => 'Szétválogatás a kiválasztott várólista szerint.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Az ügyintéző, aki létrehozta a jegyet',
        'Agent who owns the ticket' => 'Az ügyintéző, aki a jegy tulajdonosa',
        'Agent who is responsible for the ticket' => 'Az ügyintéző, aki a jegyért felelős',
        'All agents watching the ticket' => 'A jegyet megfigyelő összes ügyintéző',
        'All agents with write permission for the ticket' => 'A jegyhez írási jogosultsággal rendelkező összes ügyintéző',
        'All agents subscribed to the ticket\'s queue' => 'A jegy várólistájára feliratkozott összes ügyintéző',
        'All agents subscribed to the ticket\'s service' => 'A jegy szolgáltatására feliratkozott összes ügyintéző',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'A jegy várólistájára és szolgáltatására is feliratkozott összes ügyintéző',
        'Customer user of the ticket' => 'A jegy ügyfél-felhasználója',
        'All recipients of the first article' => 'Az első bejegyzés összes címzettje',
        'All recipients of the last article' => 'Az utolsó bejegyzés összes címzettje',
        'Invisible to customer' => 'Láthatatlan az ügyfélnek',
        'Visible to customer' => 'Látható az ügyfélnek',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'A PGP környezet nem működik. További információkért nézze meg a naplót!',
        'Need param Key to delete!' => 'Kulcs paraméter szükséges a törléshez!',
        'Key %s deleted!' => 'A(z) %s kulcs törölve!',
        'Need param Key to download!' => 'Kulcs paraméter szükséges a letöltéshez!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Sajnáljuk, de az Apache::Reload modul PerlModule és PerlInitHandler beállításként szükséges az Apache beállítófájljában. Nézze meg a scripts/apache2-httpd.include.conf parancsfájlt is. Alternatívaként használhatja a bin/otobo.Console.pl parancssori eszközt is a csomagok telepítéséhez!',
        'No such package!' => 'Nincs ilyen csomag!',
        'No such file %s in package!' => 'Nincs ilyen %s fájl a csomagban!',
        'No such file %s in local file system!' => 'Nincs ilyen %s fájl a helyi fájlrendszeren!',
        'Can\'t read %s!' => 'Nem olvasható: %s!',
        'File is OK' => 'A fájl rendben van',
        'Package has locally modified files.' => 'A csomag helyileg módosított fájlokkal rendelkezik.',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'A csomagot nem ellenőrizte az OTRS csoport! Nem javasolt a csomag használata.',
        'Not Started' => 'Nincs elindítva',
        'Updated' => 'Frissítve',
        'Already up-to-date' => 'Már naprakész',
        'Installed' => 'Telepítve',
        'Not correctly deployed' => 'Nincs megfelelően üzembe állítva',
        'Package updated correctly' => 'A csomag megfelelően frissítve',
        'Package was already updated' => 'A csomag már frissítve lett',
        'Dependency installed correctly' => 'A függőség megfelelően telepítve',
        'The package needs to be reinstalled' => 'A csomagot újra kell telepíteni',
        'The package contains cyclic dependencies' => 'A csomag körkörös függőségeket tartalmaz',
        'Not found in on-line repositories' => 'Nem található az internetes tárolókban',
        'Required version is higher than available' => 'A szükséges verzió magasabb az elérhetőnél',
        'Dependencies fail to upgrade or install' => 'A függőségek frissítése vagy telepítése sikertelen',
        'Package could not be installed' => 'A csomagot nem sikerült telepíteni',
        'Package could not be upgraded' => 'A csomagot nem sikerült frissíteni',
        'Repository List' => 'Tárolólista',
        'No packages found in selected repository. Please check log for more info!' =>
            'Nem találhatók csomagok a kijelölt tárolóban. További információkért nézze meg a naplót!',
        'Package not verified due a communication issue with verification server!' =>
            'A csomag nincs ellenőrizve az ellenőrző-kiszolgálóval történő kommunikációs hiba miatt!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Nem lehet kapcsolódni az OTOBO szolgáltatáskiegészítő lista kiszolgálójához!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Nem lehet lekérni az OTOBO szolgáltatáskiegészítő listát a kiszolgálóról!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Nem lehet lekérni az OTOBO szolgáltatáskiegészítőt a kiszolgálóról!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Nincs ilyen szűrő: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioritás hozzáadva!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Az adatbázis folyamatkezelő információi nincsenek szinkronizálva a rendszer beállításaival, szinkronizáljon minden folyamatot.',
        'Need ExampleProcesses!' => 'Példafolyamatok szükségesek!',
        'Need ProcessID!' => 'Folyamatazonosító szükséges!',
        'Yes (mandatory)' => 'Igen (kötelező)',
        'Unknown Process %s!' => 'Ismeretlen folyamat: %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Hiba történt egy új egyedazonosító előállításakor ennél a folyamatnál',
        'The StateEntityID for state Inactive does not exists' => 'Az állapotegyed-azonosító az Inaktív állapotnál nem létezik',
        'There was an error creating the Process' => 'Hiba történt a folyamat létrehozásakor',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor ennél a folyamategyednél: %s',
        'Could not get data for ProcessID %s' => 'Nem sikerült lekérni az adatokat a folyamatazonosítóhoz: %s',
        'There was an error updating the Process' => 'Hiba történt a folyamat frissítésekor',
        'Process: %s could not be deleted' => 'Folyamat: %s törlése nem sikerült',
        'There was an error synchronizing the processes.' => 'Hiba történt a folyamatok szinkronizálásakor.',
        'The %s:%s is still in use' => 'A(z) %s:%s még mindig használatban van',
        'The %s:%s has a different EntityID' => 'A(z) %s:%s eltérő egyedazonosítóval rendelkezik',
        'Could not delete %s:%s' => 'Nem sikerült törölni: %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor a(z) %s egyednél: %s',
        'Could not get %s' => 'Nem sikerült lekérni: %s',
        'Need %s!' => '%s szükséges!',
        'Process: %s is not Inactive' => 'Folyamat: %s nem inaktív',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Hiba történt egy új egyedazonosító előállításakor ennél a tevékenységnél',
        'There was an error creating the Activity' => 'Hiba történt a tevékenység létrehozásakor',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor a tevékenységegyednél: %s',
        'Need ActivityID!' => 'Tevékenység-azonosító szükséges!',
        'Could not get data for ActivityID %s' => 'Nem sikerült lekérni az adatokat a tevékenység-azonosítóhoz: %s',
        'There was an error updating the Activity' => 'Hiba történt a tevékenység frissítésekor',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Hiányzó paraméter: tevékenység és tevékenység párbeszéd szükséges!',
        'Activity not found!' => 'Nem található tevékenység!',
        'ActivityDialog not found!' => 'Nem található tevékenység párbeszéd!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'A tevékenység párbeszéd már hozzá van rendelve a tevékenységhez. Nem adhat hozzá egy tevékenység párbeszédet kétszer!',
        'Error while saving the Activity to the database!' => 'Hiba történt a tevékenységnek az adatbázisba történő mentése közben!',
        'This subaction is not valid' => 'Ez az alművelet nem érvényes',
        'Edit Activity "%s"' => 'Tevékenység szerkesztése: „%s”',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Hiba történt egy új egyedazonosító előállításakor ennél a tevékenység párbeszédnél',
        'There was an error creating the ActivityDialog' => 'Hiba történt a tevékenység párbeszéd létrehozásakor',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor a tevékenység párbeszéd egyednél: %s',
        'Need ActivityDialogID!' => 'Tevékenység párbeszéd azonosító szükséges!',
        'Could not get data for ActivityDialogID %s' => 'Nem sikerült lekérni az adatokat a tevékenység párbeszéd azonosítójához: %s',
        'There was an error updating the ActivityDialog' => 'Hiba történt a tevékenység párbeszéd frissítésekor',
        'Edit Activity Dialog "%s"' => 'Tevékenység párbeszéd szerkesztése: „%s”',
        'Agent Interface' => 'Ügyintézői felület',
        'Customer Interface' => 'Ügyfélfelület',
        'Agent and Customer Interface' => 'Ügyintézői és ügyfélfelület',
        'Do not show Field' => 'Ne jelenjen meg a mező',
        'Show Field' => 'Mező megjelenítése',
        'Show Field As Mandatory' => 'Mező megjelenítése kötelezőként',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Útvonal szerkesztése',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Hiba történt egy új egyedazonosító előállításakor ennél az átmenetnél',
        'There was an error creating the Transition' => 'Hiba történt az átmenet létrehozásakor',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor az átmenetegyednél: %s',
        'Need TransitionID!' => 'Átmenet-azonosító szükséges!',
        'Could not get data for TransitionID %s' => 'Nem sikerült lekérni az adatokat az átmenet-azonosítóhoz: %s',
        'There was an error updating the Transition' => 'Hiba történt az átmenet frissítésekor',
        'Edit Transition "%s"' => 'Átmenet szerkesztése: „%s”',
        'Transition validation module' => 'Átmenet-ellenőrző modul',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Legalább egy érvényes beállítási paraméter szükséges.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Hiba történt egy új egyedazonosító előállításakor ennél az átmenet műveletnél',
        'There was an error creating the TransitionAction' => 'Hiba történt az átmenet művelet létrehozásakor',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Hiba történt az egyed szinkronizációs állapotának beállításakor az átmenet művelet egyednél: %s',
        'Need TransitionActionID!' => 'Átmenet művelet azonosító szükséges!',
        'Could not get data for TransitionActionID %s' => 'Nem sikerült lekérni az adatokat az átmenet művelet azonosítóhoz: %s',
        'There was an error updating the TransitionAction' => 'Hiba történt az átmenet művelet frissítésekor',
        'Edit Transition Action "%s"' => 'Átmenet művelet szerkesztése: „%s”',
        'Error: Not all keys seem to have values or vice versa.' => 'Hiba: úgy tűnik, hogy nem minden kulcsnak van értéke, és fordítva.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Várólista frissítve!',
        'Don\'t use :: in queue name!' => 'Ne használjon :: karaktereket a várólista nevében!',
        'Click back and change it!' => 'Kattintson vissza, és változtassa meg!',
        '-none-' => '-nincs-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Várólisták (automatikus válaszok nélkül)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Várólista-kapcsolatok megváltoztatása egy sablonnál',
        'Change Template Relations for Queue' => 'Sablonkapcsolatok megváltoztatása egy várólistánál',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktív',
        'Test' => 'Teszt',
        'Training' => 'Oktatás',
        'Development' => 'Fejlesztés',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Szerep frissítve!',
        'Role added!' => 'Szerep hozzáadva!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Csoportkapcsolatok megváltoztatása egy szerepnél',
        'Change Role Relations for Group' => 'Szerepkapcsolatok megváltoztatása egy csoportnál',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Szerep',
        'Change Role Relations for Agent' => 'Szerepkapcsolatok megváltoztatása egy ügyintézőnél',
        'Change Agent Relations for Role' => 'Ügyintéző-kapcsolatok megváltoztatása egy szerepnél',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Kérjük először aktiválja: %s!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'Az S/MIME környezet nem működik. További információkért nézze meg a naplót!',
        'Need param Filename to delete!' => 'Fájlnév paraméter szükséges a törléshez!',
        'Need param Filename to download!' => 'Fájlnév paraméter szükséges a letöltéshez!',
        'Needed CertFingerprint and CAFingerprint!' => 'Tanúsítvány ujjlenyomat és hitelesítésszolgáltató ujjlenyomat szükséges!',
        'CAFingerprint must be different than CertFingerprint' => 'A hitelesítésszolgáltató ujjlenyomatának eltérőnek kell lennie a tanúsítvány ujjlenyomatától',
        'Relation exists!' => 'A kapcsolat létezik!',
        'Relation added!' => 'Kapcsolat hozzáadva!',
        'Impossible to add relation!' => 'Lehetetlen hozzáadni a kapcsolatot!',
        'Relation doesn\'t exists' => 'A kapcsolat nem létezik',
        'Relation deleted!' => 'Kapcsolat törölve!',
        'Impossible to delete relation!' => 'Lehetetlen törölni a kapcsolatot!',
        'Certificate %s could not be read!' => 'A(z) %s tanúsítványt nem sikerült beolvasni!',
        'Needed Fingerprint' => 'Ujjlenyomat szükséges',
        'Handle Private Certificate Relations' => 'Személyes tanúsítványkapcsolatok kezelése',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Megszólítás hozzáadva!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Aláírás frissítve!',
        'Signature added!' => 'Aláírás hozzáadva!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Állapot hozzáadva!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'A(z) %s fájlt nem sikerült beolvasni!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Rendszer e-mail cím hozzáadva!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Érvénytelen beállítások',
        'There are no invalid settings active at this time.' => 'Nincsenek érvénytelen bekapcsolt beállítások jelen pillanatban.',
        'You currently don\'t have any favourite settings.' => 'Jelenleg nincs egyetlen kedvenc beállítása sem.',
        'The following settings could not be found: %s' => 'A következő beállítások nem találhatók: %s',
        'Import not allowed!' => 'Az importálás nem engedélyezett!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'A rendszerbeállításokat nem sikerült importálni egy ismeretlen hiba miatt, további információkért nézze meg az OTOBO naplókat.',
        'Category Search' => 'Kategóriakeresés',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Néhány importált beállítás nincs jelen a konfiguráció jelenlegi állapotában, vagy nem volt lehetséges frissíteni azokat. További információkért nézze meg az OTOBO naplóját.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'Engedélyeznie kell a beállítást zárolás előtt!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Nem dolgozhat ezzel a beállítással, mert jelenleg %s (%s) dolgozik vele.',
        'Missing setting name!' => 'Hiányzó beállításnév!',
        'Missing ResetOptions!' => 'Hiányzó visszaállítási lehetőségek!',
        'System was not able to lock the setting!' => 'A rendszer nem volt képes zárolni a beállítást!',
        'System was unable to update setting!' => 'A rendszer nem tudta frissíteni a beállítást!',
        'Missing setting name.' => 'Hiányzó beállításnév.',
        'Setting not found.' => 'A beállítás nem található.',
        'Missing Settings!' => 'Hiányzó beállítások!',

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
        'Start date shouldn\'t be defined after Stop date!' => 'A kezdődátumot nem lehet a végdátum utánra meghatározni!',
        'There was an error creating the System Maintenance' => 'Hiba történt a rendszerkarbantartás létrehozásakor',
        'Need SystemMaintenanceID!' => 'Rendszerkarbantartás-azonosító szükséges!',
        'Could not get data for SystemMaintenanceID %s' => 'Nem sikerült lekérni az adatokat a rendszerkarbantartás-azonosítóhoz: %s',
        'System Maintenance was added successfully!' => 'A rendszerkarbantartás sikeresen hozzá lett adva!',
        'System Maintenance was updated successfully!' => 'A rendszerkarbantartás sikeresen frissítve lett!',
        'Session has been killed!' => 'A munkamenet ki lett lőve!',
        'All sessions have been killed, except for your own.' => 'Összes munkamenet ki lett lőve, kivéve az Ön sajátját.',
        'There was an error updating the System Maintenance' => 'Hiba történt a rendszerkarbantartás frissítésekor',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Nem volt lehetséges a rendszerkarbantartás egyedet törölni: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Sablon frissítve!',
        'Template added!' => 'Sablon hozzáadva!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Mellékletkapcsolatok megváltoztatása egy sablonnál',
        'Change Template Relations for Attachment' => 'Sablonkapcsolatok megváltoztatása egy mellékletnél',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Típus szükséges!',
        'Type added!' => 'Típus hozzáadva!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Ügyintéző frissítve!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Csoportkapcsolatok megváltoztatása egy ügyintézőnél',
        'Change Agent Relations for Group' => 'Ügyintéző-kapcsolatok megváltoztatása egy csoportnál',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Hónap',
        'Week' => 'Hét',
        'Day' => 'Nap',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Minden időpont',
        'Appointments assigned to me' => 'Hozzám rendelt időpontok',
        'Showing only appointments assigned to you! Change settings' => 'Csak az önhöz rendelt időpontok vannak megjelenítve! Beállítások megváltoztatása',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Az időpont nem található!',
        'Never' => 'Soha',
        'Every Day' => 'Minden nap',
        'Every Week' => 'Minden héten',
        'Every Month' => 'Minden hónapban',
        'Every Year' => 'Minden évben',
        'Custom' => 'Egyéni',
        'Daily' => 'Napi',
        'Weekly' => 'Heti',
        'Monthly' => 'Havi',
        'Yearly' => 'Éves',
        'every' => 'minden',
        'for %s time(s)' => '%s alkalommal',
        'until ...' => 'eddig: …',
        'for ... time(s)' => '… alkalommal',
        'until %s' => 'eddig: %s',
        'No notification' => 'Nincs értesítés',
        '%s minute(s) before' => '%s perccel előtte',
        '%s hour(s) before' => '%s órával előtte',
        '%s day(s) before' => '%s nappal előtte',
        '%s week before' => '%s héttel előtte',
        'before the appointment starts' => 'az időpont kezdete előtt',
        'after the appointment has been started' => 'miután az időpont elkezdődött',
        'before the appointment ends' => 'az időpont vége előtt',
        'after the appointment has been ended' => 'miután az időpont véget ért',
        'No permission!' => 'Nincs jogosultság!',
        'Cannot delete ticket appointment!' => 'Nem lehet törölni a jegyidőpontot!',
        'No permissions!' => 'Nincsenek jogosultságok!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s további',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Ügyfél előzmények',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'Nincs címzett mező megadva!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Nincs ilyen beállítás ehhez: %s',
        'Statistic' => 'Statisztika',
        'No preferences for %s!' => 'Nincsenek beállítások ehhez: %s!',
        'Can\'t get element data of %s!' => 'Nem lehet lekérni a(z) „%s” elemadatait!',
        'Can\'t get filter content data of %s!' => 'Nem lehet lekérni a(z) „%s” szűrőtartalom-adatait!',
        'Customer Name' => 'Ügyfél neve',
        'Customer User Name' => 'Ügyfél-felhasználó neve',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Forrásobjektum és forráskulcs szükséges!',
        'You need ro permission!' => 'Csak olvasható jogosultságra van szüksége!',
        'Can not delete link with %s!' => 'A következővel való kapcsolat nem törölhető: %s!',
        '%s Link(s) deleted successfully.' => '%s kapcsolat sikeresen törölve.',
        'Can not create link with %s! Object already linked as %s.' => 'Nem lehet kapcsolatot létrehozni ezzel: %s! Az objektum már a következőként kapcsolódik: %s.',
        'Can not create link with %s!' => 'A következővel való kapcsolat nem hozható létre: %s!',
        '%s links added successfully.' => '%s kapcsolat sikeresen hozzáadva.',
        'The object %s cannot link with other object!' => 'A(z) %s objektum nem kapcsolható össze más objektummal!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Csoport paraméter szükséges!',
        'This feature is not available.' => '',
        'Updated user preferences' => 'Felhasználói beállítások frissítve',
        'System was unable to deploy your changes.' => 'A rendszer nem tudta üzembe állítani a változtatásokat.',
        'Setting not found!' => 'A beállítás nem található!',
        'System was unable to reset the setting!' => 'A rendszer nem tudta visszaállítani a beállítást!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Folyamatjegy',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'A(z) %s paraméter hiányzik.',
        'Invalid Subaction.' => 'Érvénytelen alművelet.',
        'Statistic could not be imported.' => 'A statisztika importálása nem sikerült.',
        'Please upload a valid statistic file.' => 'Töltsön fel egy érvényes statisztikafájlt.',
        'Export: Need StatID!' => 'Exportálás: statisztikaazonosító szükséges!',
        'Delete: Get no StatID!' => 'Törlés: nem kaptam statisztikaazonosítót!',
        'Need StatID!' => 'Statisztikaazonosító szükséges!',
        'Could not load stat.' => 'Nem sikerült betölteni a statisztikát.',
        'Add New Statistic' => 'Új statisztika hozzáadása',
        'Could not create statistic.' => 'Nem sikerült létrehozni a statisztikát.',
        'Run: Get no %s!' => 'Futtatás: nem kaptam ilyet: %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Nincs jegyazonosító megadva!',
        'You need %s permissions!' => '%s jogosultságokra van szüksége!',
        'Loading draft failed!' => 'A piszkozat betöltése nem sikerült!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Sajnáljuk, a jegy tulajdonosának kell lennie a művelet végrehajtásához.',
        'Please change the owner first.' => 'Először változtassa meg a tulajdonost.',
        'FormDraft functionality disabled!' => 'Az űrlappiszkozat funkcionalitás le van tiltva!',
        'Draft name is required!' => 'A piszkozat neve kötelező!',
        'FormDraft name %s is already in use!' => 'A(z) %s űrlappiszkozatnév már használatban van!',
        'Could not perform validation on field %s!' => 'Nem sikerült végrehajtani az ellenőrzést a következő mezőn: %s!',
        'No subject' => 'Nincs tárgy',
        'Could not delete draft!' => 'Nem sikerült a piszkozat törlése!',
        'Previous Owner' => 'Korábbi tulajdonos',
        'wrote' => 'írta',
        'Message from' => 'Üzenet tőle',
        'End message' => 'Üzenet vége',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s szükséges!',
        'Plain article not found for article %s!' => 'Egyszerű bejegyzés nem található a(z) %s bejegyzéshez!',
        'Article does not belong to ticket %s!' => 'A bejegyzés nem tartozik ehhez a jegyhez: %s!',
        'Can\'t bounce email!' => 'Nem lehet átirányítani az e-mailt!',
        'Can\'t send email!' => 'Nem lehet elküldeni az e-mailt!',
        'Wrong Subaction!' => 'Rossz alművelet!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Nem lehet zárolni a jegyeket, nincsenek jegyazonosítók megadva!',
        'Ticket (%s) is not unlocked!' => 'A jegy (%s) nincs feloldva!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'A következő jegyek figyelmen kívül lettek hagyva, mert egy másik ügyintéző zárolta azokat vagy nincs írási hozzáférése a jegyekhez: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'A következő jegy figyelmen kívül lett hagyva, mert egy másik ügyintéző zárolta azt vagy nincs írási hozzáférése a jegyhez: %s.',
        'You need to select at least one ticket.' => 'Legalább egy jegyet ki kell választania.',
        'Bulk feature is not enabled!' => 'A tömeges funkció nincs engedélyezve!',
        'No selectable TicketID is given!' => 'Nincs kiválasztható jegyazonosító megadva!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Vagy nem választott ki jegyet, vagy csak olyan jegyeket, amelyeket más ügyintézők zároltak.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'A következő jegyek figyelmen kívül lettek hagyva, mert másik ügyintéző zárolta azokat vagy nincs írási hozzáférése ezekhez a jegyekhez: %s.',
        'The following tickets were locked: %s.' => 'A következő jegyek zárolva lettek: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'A bejegyzés tárgya üres lesz, ha a tárgy csak a jegyhorgot tartalmazza!',
        'Address %s replaced with registered customer address.' => 'A(z) %s cím kicserélve a regisztrált ügyfél címével.',
        'Customer user automatically added in Cc.' => 'Az ügyfél-felhasználó automatikusan hozzáadva a másolati mezőhöz.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Jegy létrehozva: „%s”!',
        'No Subaction!' => 'Nincs alművelet!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Nem kaptam jegyazonosítót!',
        'System Error!' => 'Rendszerhiba!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'Nincs bejegyzés-azonosító megadva!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Következő hét',
        'Ticket Escalation View' => 'Jegyeszkaláció nézet',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'A(z) %s bejegyzés nem található!',
        'Forwarded message from' => 'Továbbított üzenet tőle',
        'End forwarded message' => 'Továbbított üzenet vége',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Nem lehet megjeleníteni az előzményeket, nincs jegyazonosító megadva!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Nem lehet zárolni a jegyet, nincs jegyazonosító megadva!',
        'Sorry, the current owner is %s!' => 'Sajnáljuk, a jelenlegi tulajdonos %s!',
        'Please become the owner first.' => 'Először legyen Ön a tulajdonos.',
        'Ticket (ID=%s) is locked by %s!' => 'A jegyet (ID=%s) %s zárolta!',
        'Change the owner!' => 'Változtassa meg a tulajdonost!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Új bejegyzés',
        'Pending' => 'Függőben',
        'Reminder Reached' => 'Emlékeztető elérve',
        'My Locked Tickets' => 'Saját zárolt jegyek',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Nem lehet egyesíteni a jegyet saját magával!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Áthelyezés jogosultságokra van szüksége!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'A csevegés nem aktív.',
        'No permission.' => 'Nincs jogosultság.',
        '%s has left the chat.' => '%s kilépett a csevegésből.',
        'This chat has been closed and will be removed in %s hours.' => 'Ez a csevegés le lett zárva és eltávolításra kerül %s órán belül.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Zárolt jegy.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Nincs bejegyzésazonosító!',
        'This is not an email article.' => 'Ez nem egy e-mail bejegyzés.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Nem lehet olvasni az egyszerű bejegyzést! Talán nincs is egyszerű e-mail a háttérprogramban! Olvassa el a háttérprogram üzenetét.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Jegyazonosító szükséges!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Nem sikerült lekérni a tevékenység párbeszéd egyedazonosítót: „%s”!',
        'No Process configured!' => 'Nincs beállított folyamat!',
        'The selected process is invalid!' => 'A kiválasztott folyamat érvénytelen!',
        'Process %s is invalid!' => 'A(z) %s folyamat érvénytelen!',
        'Subaction is invalid!' => 'Az alművelet érvénytelen!',
        'Parameter %s is missing in %s.' => 'A(z) %s paraméter hiányzik ebben: %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Nincs tevékenység párbeszéd beállítva a _RenderAjax szubrutinban ehhez: %s!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Nem érkezett kezdő tevékenységegyed-azonosító vagy kezdő tevékenység párbeszéd egyedazonosító a(z) %s folyamatnál a _GetParam szubrutinban!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Nem sikerült lekérni a jegyet a(z) %s jegyazonosítóhoz a _GetParam szubrutinban!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Nem sikerült meghatározni a tevékenység egyedazonosítóját. A dinamikus mező vagy a beállítás nincs megfelelően beállítva!',
        'Process::Default%s Config Value missing!' => 'A Process::Default%s beállítás értéke hiányzik!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Nem kaptam folyamategyed-azonosítót vagy jegyazonosítót és tevékenység párbeszéd egyed-azonosítót!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Nem lehet lekérni a kezdő tevékenység párbeszédet és a(z) „%s” folyamategyed-azonosító kezdő tevékenység párbeszédét!',
        'Can\'t get Ticket "%s"!' => 'Nem lehet lekérni a(z) „%s” jegyet!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Nem lehet lekérni a folyamategyed-azonosítót vagy a tevékenységegyed-azonosítót a(z) „%s” jegynél!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Nem lehet lekérni a tevékenység beállítását a(z) „%s” tevékenységegyed-azonosítónál!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Nem lehet lekérni a tevékenység párbeszéd beállítását a(z) „%s” tevékenység párbeszéd egyed-azonosítójánál!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Nem lehet lekérni az adatokat a(z) „%s” mezőnél, amely a(z) „%s” tevékenység párbeszédhez tartozik!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'A várakozási idő csak akkor használható, ha az állapot vagy az állapotazonosító be van állítva ugyanannál a tevékenység párbeszédnél. Tevékenység párbeszéd: %s!',
        'Pending Date' => 'Várakozás dátuma',
        'for pending* states' => 'függőben* állapotokhoz',
        'ActivityDialogEntityID missing!' => 'A tevékenység párbeszéd egyedazonosító hiányzik!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Nem sikerült lekérni a beállítást a tevékenység párbeszéd egyedazonosítóhoz: „%s”!',
        'Couldn\'t use CustomerID as an invisible field.' => 'Nem sikerült az ügyfél-azonosítót láthatatlan mezőként használni.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Hiányzó folyamategyed-azonosító, ellenőrizze az ActivityDialogHeader.tt fájlt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Nincs beállítva kezdő tevékenység párbeszéd vagy a(z) „%s” folyamat kezdő tevékenység párbeszéde!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Nem sikerült jegyet létrehozni a(z) „%s” folyamategyed-azonosítóval rendelkező folyamatnál!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Nem sikerült beállítani a(z) „%s” folyamategyed-azonosítót a következő jegyazonosítónál: „%s”!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Nem sikerült beállítani a(z) „%s” tevékenységegyed-azonosítót a következő jegyazonosítónál: „%s”!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Nem sikerült eltárolni a tevékenység párbeszédet, érvénytelen jegyazonosító: %s!',
        'Invalid TicketID: %s!' => 'Érvénytelen jegyazonosító: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Hiányzó tevékenységegyed-azonosító a következő jegyben: %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Ez a lépés többé nem tartozik a jelenlegi tevékenységhez a folyamatban a következő jegynél: „%s%s%s”! Egy másik felhasználó időközben megváltoztatta ezt a jegyet. Zárja be ezt az ablakot, és töltse újra a jegyet.',
        'Missing ProcessEntityID in Ticket %s!' => 'Hiányzó folyamategyed-azonosító a következő jegyben: %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Nem sikerült beállítani a(z) %s dinamikus mező értékét, amely a(z) „%s” azonosítójú jegyhez tartozik a(z) „%s” tevékenység párbeszédben!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Nem sikerült beállítani a várakozási időt a(z) „%s” azonosítójú jegynél a(z) „%s” tevékenység párbeszédben!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Hibás tevékenység párbeszéd mezőbeállítás: %s, nem lehet „Display => 1 / mező megjelenítése” (változtassa meg a beállítását, hogy „Display => 0 / ne jelenítse meg a mezőt” vagy „Display => 2 / mező megjelenítése kötelezőként” legyen)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Nem sikerült a(z) %s beállítása a(z) „%s” azonosítójú jegynél a(z) „%s” tevékenység párbeszédben!',
        'Default Config for Process::Default%s missing!' => 'A Process::Default%s alapértelmezett beállítása hiányzik!',
        'Default Config for Process::Default%s invalid!' => 'A Process::Default%s alapértelmezett beállítása érvénytelen!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Elérhető jegyek',
        'including subqueues' => 'alvárólisták felvétele',
        'excluding subqueues' => 'alvárólisták kizárása',
        'QueueView' => 'Várólista nézet',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Saját felelős jegyek',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'utolsó-keresés',
        'Untitled' => 'Névtelen',
        'Ticket Number' => 'Jegyszám',
        'Ticket' => 'Jegy',
        'printed by' => 'nyomtatta',
        'CustomerID (complex search)' => 'Ügyfél-azonosító (összetett keresés)',
        'CustomerID (exact match)' => 'Ügyfél-azonosító (pontos egyezés)',
        'Invalid Users' => 'Érvénytelen felhasználók',
        'Normal' => 'Normál',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'több mint …',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'A szolgáltatás nincs engedélyezve!',
        'Service View' => 'Szolgáltatás nézet',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Állapot nézet',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Saját megfigyelt jegyek',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'A szolgáltatás nem aktív',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Kapcsolat törölve',
        'Ticket Locked' => 'Jegy zárolva',
        'Pending Time Set' => 'Várakozási idő beállítva',
        'Dynamic Field Updated' => 'Dinamikus mező frissítve',
        'Outgoing Email (internal)' => 'Kimenő e-mail (belső)',
        'Ticket Created' => 'Jegy létrehozva',
        'Type Updated' => 'Típus frissítve',
        'Escalation Update Time In Effect' => 'Eszkaláció frissítési idő van hatályban',
        'Escalation Update Time Stopped' => 'Eszkaláció frissítési ideje leállítva',
        'Escalation First Response Time Stopped' => 'Eszkaláció első válaszideje leállítva',
        'Customer Updated' => 'Ügyfél frissítve',
        'Internal Chat' => 'Belső csevegés',
        'Automatic Follow-Up Sent' => 'Automatikus követés elküldve',
        'Note Added' => 'Jegyzet hozzáadva',
        'Note Added (Customer)' => 'Jegyzet hozzáadva (ügyfél)',
        'SMS Added' => 'SMS hozzáadva',
        'SMS Added (Customer)' => 'SMS hozzáadva (ügyfél)',
        'State Updated' => 'Állapot frissítve',
        'Outgoing Answer' => 'Kimenő válasz',
        'Service Updated' => 'Szolgáltatás frissítve',
        'Link Added' => 'Kapcsolat hozzáadva',
        'Incoming Customer Email' => 'Bejövő ügyfél e-mail',
        'Incoming Web Request' => 'Bejövő webkérés',
        'Priority Updated' => 'Prioritás frissítve',
        'Ticket Unlocked' => 'Jegy feloldva',
        'Outgoing Email' => 'Kimenő e-mail',
        'Title Updated' => 'Cím frissítve',
        'Ticket Merged' => 'Jegy egyesítve',
        'Outgoing Phone Call' => 'Kimenő telefonhívás',
        'Forwarded Message' => 'Továbbított üzenet',
        'Removed User Subscription' => 'Felhasználói feliratkozás eltávolítva',
        'Time Accounted' => 'Idő elszámolva',
        'Incoming Phone Call' => 'Bejövő telefonhívás',
        'System Request.' => 'Rendszer kérés.',
        'Incoming Follow-Up' => 'Bejövő követés',
        'Automatic Reply Sent' => 'Automatikus válasz elküldve',
        'Automatic Reject Sent' => 'Automatikus elutasítás elküldve',
        'Escalation Solution Time In Effect' => 'Eszkaláció megoldási idő van hatályban',
        'Escalation Solution Time Stopped' => 'Eszkaláció megoldási ideje leállítva',
        'Escalation Response Time In Effect' => 'Eszkaláció válaszidő van hatályban',
        'Escalation Response Time Stopped' => 'Eszkaláció válaszideje leállítva',
        'SLA Updated' => 'SLA frissítve',
        'External Chat' => 'Külső csevegés',
        'Queue Changed' => 'Várólista módosítva',
        'Notification Was Sent' => 'Értesítés elküldve',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Ez a jegy nem létezik, vagy nincs jogosultsága a hozzáféréshez annak jelenlegi állapotában.',
        'Missing FormDraftID!' => 'Hiányzó űrlappiszkozat-azonosító!',
        'Can\'t get for ArticleID %s!' => 'Nem lehet lekérni a(z) %s bejegyzés-azonosítóhoz!',
        'Article filter settings were saved.' => 'A bejegyzésszűrő beállításai mentésre kerültek.',
        'Event type filter settings were saved.' => 'Az eseménytípus-szűrő beállításai mentésre kerültek.',
        'Need ArticleID!' => 'Bejegyzésazonosító szükséges!',
        'Invalid ArticleID!' => 'Érvénytelen bejegyzésazonosító!',
        'Forward article via mail' => 'Bejegyzés továbbítása levélben',
        'Forward' => 'Továbbítás',
        'Fields with no group' => 'Csoport nélküli mezők',
        'Invisible only' => 'Csak láthatatlan',
        'Visible only' => 'Csak látható',
        'Visible and invisible' => 'Látható és láthatatlan',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'A bejegyzést nem sikerült megnyitni! Talán egy másik bejegyzés oldalon van?',
        'Show one article' => 'Egy bejegyzés megjelenítése',
        'Show all articles' => 'Összes bejegyzés megjelenítése',
        'Show Ticket Timeline View' => 'Jegy idővonal nézet megjelenítése',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'Nem érkezett űrlap-azonosító.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Hiba: a fájlt nem sikerült megfelelően törölni. Vegye fel a kapcsolatot a rendszergazdával (hiányzó fájlazonosító).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'Bejegyzésazonosító szükséges!',
        'No TicketID for ArticleID (%s)!' => 'Nincs jegyazonosító a bejegyzésazonosítóhoz (%s)!',
        'HTML body attachment is missing!' => 'A HTML törzs melléklete hiányzik!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'Fájlazonosító és bejegyzésazonosító szükséges!',
        'No such attachment (%s)!' => 'Nincs ilyen melléklet (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Rendszerbeállítás ellenőrzése ennél: %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Rendszerbeállítás ellenőrzése ennél: %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'Nincs elegendő jogosultsága a jegy létrehozásához az alapértelmezett várólistában.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Ügyfél-azonosító szükséges!',
        'My Tickets' => 'Saját jegyek',
        'Company Tickets' => 'Vállalati jegyek',
        'Untitled!' => 'Névtelen!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Ügyfél valódi neve',
        'Created within the last' => 'Létrehozva az elmúlt … belül',
        'Created more than ... ago' => 'Létrehozva több mint … ezelőtt',
        'Please remove the following words because they cannot be used for the search:' =>
            'Távolítsa el a következő szavakat, mert azok nem használhatók a keresésnél:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Nem lehet újranyitni a jegyet, mert ez nem lehetséges ebben a várólistában!',
        'Create a new ticket!' => 'Hozzon létre új jegyet!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Biztonságos mód bekapcsolva!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Ha újra szeretné futtatni a telepítőt, akkor tiltsa le a biztonságos módot a rendszerbeállításokban.',
        'Directory "%s" doesn\'t exist!' => 'A(z) „%s” könyvtár nem létezik!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Először állítsa be a „Home” értékét a Kernel/Config.pm fájlban!',
        'File "%s/Kernel/Config.pm" not found!' => 'A(z) „%s/Kernel/Config.pm” fájl nem található!',
        'Directory "%s" not found!' => 'A(z) „%s” könyvtár nem található!',
        'Install OTOBO' => 'OTOBO telepítése',
        'Intro' => 'Bevezetés',
        'Kernel/Config.pm isn\'t writable!' => 'A Kernel/Config.pm nem írható!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Ha használni szeretné a telepítőt, akkor állítsa írhatóra a Kernel/Config.pm fájlt a webkiszolgáló felhasználójának!',
        'Database Selection' => 'Adatbázis-kijelölés',
        'Unknown Check!' => 'Ismeretlen ellenőrzés!',
        'The check "%s" doesn\'t exist!' => 'A(z) „%s” ellenőrzés nem létezik!',
        'Enter the password for the database user.' => 'Adja meg az adatbázis felhasználó jelszavát.',
        'Database %s' => '%s adatbázis',
        'Configure MySQL' => 'MySQL beállítása',
        'Enter the password for the administrative database user.' => 'Adja meg az adatbázis adminisztrátor felhasználó jelszavát.',
        'Configure PostgreSQL' => 'PostgreSQL beállítása',
        'Configure Oracle' => 'Oracle beállítása',
        'Unknown database type "%s".' => 'Ismeretlen adatbázistípus: „%s”.',
        'Please go back.' => 'Lépjen vissza.',
        'Create Database' => 'Adatbázis létrehozása',
        'Install OTOBO - Error' => 'Az OTOBO telepítése – hiba',
        'File "%s/%s.xml" not found!' => 'A(z) „%s/%s.xml” fájl nem található!',
        'Contact your Admin!' => 'Vegye fel a kapcsolatot a rendszergazdával!',
        'System Settings' => 'Rendszerbeállítások',
        'Syslog' => 'Rendszernapló',
        'Configure Mail' => 'Levelezés beállítása',
        'Mail Configuration' => 'Levelezési beállítások',
        'Can\'t write Config file!' => 'Nem lehet írni a beállítófájlt!',
        'Unknown Subaction %s!' => 'Ismeretlen alművelet: %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Nem lehet kapcsolódni az adatbázishoz, a DBD::%s Perl-modul nincs telepítve!',
        'Can\'t connect to database, read comment!' => 'Nem lehet kapcsolódni az adatbázishoz, olvassa el a megjegyzést!',
        'Database already contains data - it should be empty!' => 'Az adatbázis már tartalmaz adatokat – üresnek kell lennie!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Hiba: Győződjön meg arról, hogy az adatbázisa elfogad-e %s MB méretűnél nagyobb csomagot (jelenleg csak legfeljebb %s MB méretű csomagot fogad el). A hibák elkerülése érdekében alkalmazkodjon az adatbázisa max_allowed_packet beállításához.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Hiba: Állítsa be az adatbázison az innodb_log_file_size értékét legalább %s MB méretűre (jelenleg: %s MB, ajánlott: %s MB). További információkért nézze meg a következőt: %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            'Hibás adatbázis egyeztetés (a %s értéke %s, de utf8 értékűnek kell lennie).',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Nincs %s!',
        'No such user!' => 'Nincs ilyen felhasználó!',
        'Invalid calendar!' => 'Érvénytelen naptár!',
        'Invalid URL!' => 'Érvénytelen URL!',
        'There was an error exporting the calendar!' => 'Hiba történt a naptár exportálásakor!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'A Package::RepositoryAccessRegExp beállítás szükséges',
        'Authentication failed from %s!' => 'Sikertelen hitelesítés innen: %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Csevegés',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Bejegyzés átirányítása egy másik e-mail címre',
        'Bounce' => 'Átirányítás',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Válasz mindenkinek',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'A bejegyzés újraküldése',
        'Resend' => 'Újraküldés',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Üzenetnapló részleteinek megtekintése ennél a bejegyzésnél',
        'Message Log' => 'Üzenetnapló',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Válasz a jegyzetre',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Bejegyzés felosztása',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Forrás megtekintése ennél a bejegyzésnél',
        'Plain Format' => 'Egyszerű formátum',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Bejegyzés nyomtatása',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'Vegye fel velünk a kapcsolatot a sales@otrs.com címen',
        'Get Help' => 'Segítségkérés',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Megjelölés',
        'Unmark' => 'Megjelölés megszüntetése',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Csomag újratelepítése',
        'Re-install' => 'Újratelepítés',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Titkosított',
        'Sent message encrypted to recipient!' => 'Az elküldött üzenet titkosítva a címzettnek!',
        'Signed' => 'Aláírt',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'A „PGP SIGNED MESSAGE” fejléc megtalálható, de érvénytelen!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'Az „S/MIME SIGNED MESSAGE” fejléc megtalálható, de érvénytelen!',
        'Ticket decrypted before' => 'A jegy korábban visszafejtésre került',
        'Impossible to decrypt: private key for email was not found!' => 'Lehetetlen visszafejteni: nem található személyes kulcs az e-mailhez!',
        'Successful decryption' => 'Sikeres visszafejtés',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Nincsenek elérhető titkosító kulcsok a címekhez: „%s”. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Nincsenek kiválasztott titkosító kulcsok a címekhez: „%s”. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Nem lehet lejárt titkosítási kulcsot használni a címekhez: „%s”. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Nem lehet visszavont titkosítási kulcsot használni a címekhez: „%s”. ',
        'Encrypt' => 'Titkosítás',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'A kulcsok vagy tanúsítványok csak olyan címzetteknél fognak megjelenni, akiknek egynél több kulcsuk vagy tanúsítványuk van. Az első megtalált kulcs vagy tanúsítvány előre ki lesz választva. Győződjön meg arról, hogy a helyeset válassza ki.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'E-mail biztonság',
        'PGP sign' => 'PGP aláírás',
        'PGP sign and encrypt' => 'PGP aláírás és titkosítás',
        'PGP encrypt' => 'PGP titkosítás',
        'SMIME sign' => 'S/MIME aláírás',
        'SMIME sign and encrypt' => 'S/MIME aláírás és titkosítás',
        'SMIME encrypt' => 'S/MIME titkosítás',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Nem lehet lejárt aláíró kulcsot használni: „%s”. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'Nem lehet visszavont aláíró kulcsot használni: „%s”. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Nincsenek elérhető aláíró kulcsok a címekhez: „%s”.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Nincsenek kiválasztott aláíró kulcsok a címekhez: „%s”.',
        'Sign' => 'Aláírás',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'A kulcsok vagy tanúsítványok csak olyan küldőnél fognak megjelenni, akinek egynél több kulcsa vagy tanúsítványa van. Az első megtalált kulcs vagy tanúsítvány előre ki lesz választva. Győződjön meg arról, hogy a helyeset válassza ki.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Megjelenített',
        'Refresh (minutes)' => 'Frissítés (perc)',
        'off' => 'ki',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Megjelenített ügyfél-azonosítók',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Megjelenített ügyfél-felhasználók',
        'Offline' => 'Kilépett',
        'User is currently offline.' => 'A felhasználó jelenleg nincs kapcsolatban.',
        'User is currently active.' => 'A felhasználó jelenleg aktív.',
        'Away' => 'Távol',
        'User was inactive for a while.' => 'A felhasználó inaktív volt egy ideig.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Egy jegy kezdési ideje a befejezési ideje után lett beállítva!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Nem lehet kapcsolódni az OTOBO hírek kiszolgálójához!',
        'Can\'t get OTOBO News from server!' => 'Nem lehet lekérni az OTOBO híreket a kiszolgálóról!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Nem lehet kapcsolódni a termékhírek kiszolgálójához!',
        'Can\'t get Product News from server!' => 'Nem lehet lekérni a termékhíreket a kiszolgálóról!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Nem lehet kapcsolódni ehhez: %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Megjelenített jegyek',
        'Shown Columns' => 'Megjelenített oszlopok',
        'filter not active' => 'a szűrő nem aktív',
        'filter active' => 'a szűrő aktív',
        'This ticket has no title or subject' => 'Ennek a jegynek nincs címe vagy tárgya',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7 napos statisztika',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'A felhasználó elérhetetlenre állította az állapotát.',
        'Unavailable' => 'Nem érhető el',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Szabványos',
        'The following tickets are not updated: %s.' => 'A következő jegyek nem lettek frissítve: %s.',
        'h' => 'ó',
        'm' => 'p',
        'd' => 'n',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Ez a jegy nem létezik, vagy nincs jogosultsága a hozzáféréshez annak jelenlegi állapotában. A következő műveletek valamelyikét végezheti el:',
        'This is a' => 'Ez egy',
        'email' => 'e-mail',
        'click here' => 'kattintson ide',
        'to open it in a new window.' => 'hogy megnyissa új ablakban.',
        'Year' => 'Év',
        'Hours' => 'Óra',
        'Minutes' => 'Perc',
        'Check to activate this date' => 'Jelölje be a dátum aktiválásához',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Nincs jogosultság!',
        'No Permission' => 'Nincs jogosultság',
        'Show Tree Selection' => 'Fakijelölés megjelenítése',
        'Split Quote' => 'Idézet felosztása',
        'Remove Quote' => 'Idézés eltávolítása',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Összekapcsolva mint',
        'Search Result' => 'Keresési eredmény',
        'Linked' => 'Összekapcsolt',
        'Bulk' => 'Tömeges',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Egyszerű',
        'Unread article(s) available' => 'Olvasatlan bejegyzések érhetők el',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Időpont',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Archívum keresés',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Bejelentkezett ügyintéző: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Több eszkalált jegy van!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Válasszon egy időzónát a beállításaiban, és erősítse meg a mentés gombra kattintva.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Bejelentkezett ügyfél: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'A rendszerkarbantartás aktív!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Egy rendszerkarbantartás időszak fog kezdődni ekkor: %s, és várható befejezése: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'Az OTOBO démon nem fut.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Engedélyezte az Irodán kívül funkciót, szeretné letiltani azt?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '%s érvénytelen beállítása van üzembe állítva. Kattintson ide az érvénytelen beállítások megtekintéséhez.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Olyan beállításai vannak, melyek nincsenek üzembe állítva. Szeretné üzembe állítani azokat?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'A beállítások frissítés alatt vannak, legyen türelemmel…',
        'There is an error updating the system configuration!' => 'Hiba történt a rendszerbeállítások frissítésekor!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Ne használja a rendszergazda fiókot a(z) %s szoftverrel való munkához! Hozzon létre új ügyintézőket, és azokkal a fiókokkal dolgozzon inkább.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Győződjön meg arról, hogy kiválasztott-e legalább egy átviteli módszert a kötelező értesítésekhez.',
        'Preferences updated successfully!' => 'A beállítások sikeresen frissítve!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(folyamatban)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Olyan befejezési dátumot adjon meg, amely a kezdődátum után van.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Jelszó ellenőrzése',
        'The current password is not correct. Please try again!' => 'A jelenlegi jelszó nem helyes. Próbálja újra.',
        'Please supply your new password!' => 'Adja meg az új jelszavát!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Ezt a jelszót tiltja a jelenlegi rendszerbeállítás. Vegye fel a kapcsolatot a rendszergazdával, ha további kérdései vannak.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Nem lehet frissíteni a jelszót, legalább %s karakter hosszúnak kell lennie!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Nem lehet frissíteni a jelszót, legalább 2 kisbetűt és 2 nagybetűt kell tartalmaznia!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Nem lehet frissíteni a jelszót, legalább 1 számjegyet kell tartalmaznia!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Nem lehet frissíteni a jelszót, legalább 2 betűt kell tartalmaznia!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Az időzóna sikeresen frissítve!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'érvénytelen',
        'valid' => 'érvényes',
        'No (not supported)' => 'Nincs (nem támogatott)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Nincs már teljes vagy a jelenlegi+közelgő teljes relatív időérték kiválasztva.',
        'The selected time period is larger than the allowed time period.' =>
            'A kiválasztott időszak nagyobb a megengedett időszaknál.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Nincs elérhető időskála érték a jelenleg kiválasztott időskála értékhez az X-tengelyen.',
        'The selected date is not valid.' => 'A kiválasztott dátum nem érvényes.',
        'The selected end time is before the start time.' => 'A kiválasztott befejezési idő a kezdési idő előtt van.',
        'There is something wrong with your time selection.' => 'Valami baj van az időkiválasztással.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Csak egy elemet válasszon, vagy engedélyezze a módosítást a statisztika előállításakor.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Ennek a mezőnek legalább egy értékét válassza ki, vagy engedélyezze a módosítást a statisztika előállításakor.',
        'Please select one element for the X-axis.' => 'Válasszon egy elemet az X-tengelyhez.',
        'You can only use one time element for the Y axis.' => 'Csak egy időelemet használhat az Y-tengelynél.',
        'You can only use one or two elements for the Y axis.' => 'Csak egy vagy két elemet használhat az Y-tengelynél.',
        'Please select at least one value of this field.' => 'Válasszon legalább egy értéket ebből a mezőből.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Adjon meg egy értéket, vagy engedélyezze a módosítást a statisztika előállításakor.',
        'Please select a time scale.' => 'Válasszon egy időskálát.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'A jelentési időintervallum túl kicsi, használjon nagyobb időskálát.',
        'second(s)' => 'másodperc',
        'quarter(s)' => 'negyedév',
        'half-year(s)' => 'félév',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Távolítsa el a következő szavakat, mert azok nem használhatók a jegykorlátozásoknál: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Szerkesztés megszakítása és a beállítás feloldása',
        'Reset this setting to its default value.' => 'A beállítás visszaállítása az alapértelmezett értékére.',
        'Unable to load %s!' => 'Nem lehet betölteni: %s!',
        'Content' => 'Tartalom',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Feloldás a várakozási sorba való visszarakáshoz',
        'Lock it to work on it' => 'Zárolás a rajta végzett munkához',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Leiratkozás',
        'Remove from list of watched tickets' => 'Eltávolítás a megfigyelt jegyek listájáról',
        'Watch' => 'Megfigyelés',
        'Add to list of watched tickets' => 'Hozzáadás a megfigyelt jegyek listájához',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Rendezés',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Zárolt jegyek (új)',
        'Locked Tickets Reminder Reached' => 'Zárolt jegyek (emlékeztető elérve)',
        'Locked Tickets Total' => 'Zárolt jegyek (összes)',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Felelős jegyek (új)',
        'Responsible Tickets Reminder Reached' => 'Felelős jegyek (emlékeztető elérve)',
        'Responsible Tickets Total' => 'Felelős jegyek (összes)',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Megfigyelt jegyek (új)',
        'Watched Tickets Reminder Reached' => 'Megfigyelt jegyek (emlékeztető elérve)',
        'Watched Tickets Total' => 'Megfigyelt jegyek (összes)',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Jegy dinamikus mezők',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Nem sikerült beolvasni az ACL beállítófájlját. Győződjön meg arról, hogy a fájl érvényes-e.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Jelenleg nem lehetséges bejelentkezni ütemezett rendszerkarbantartás miatt.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'A munkamenet érvénytelen. Jelentkezzen be újra.',
        'Session has timed out. Please log in again.' => 'A munkamenet túllépte az időkorlátot. Jelentkezzen be újra.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Csak PGP aláírás',
        'PGP encrypt only' => 'Csak PGP titkosítás',
        'SMIME sign only' => 'Csak S/MIME aláírás',
        'SMIME encrypt only' => 'Csak S/MIME titkosítás',
        'PGP and SMIME not enabled.' => 'A PGP és az S/MIME nincs engedélyezve.',
        'Skip notification delivery' => 'Értesítés-kézbesítés kihagyása',
        'Send unsigned notification' => 'Aláíratlan értesítés küldése',
        'Send unencrypted notification' => 'Titkosítatlan értesítés küldése',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Beállítási lehetőségek hivatkozása',
        'This setting can not be changed.' => 'Ez a beállítás nem változtatható meg.',
        'This setting is not active by default.' => 'Ez a beállítás alapértelmezetten nincs bekapcsolva.',
        'This setting can not be deactivated.' => 'Ez a beállítás nem kapcsolható ki.',
        'This setting is not visible.' => 'Ez a beállítás nem látható.',
        'This setting can be overridden in the user preferences.' => 'Ez a beállítás felülbírálható a felhasználói beállításokban.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Ez a beállítás felülbírálható a felhasználói beállításokban, de alapértelmezetten nincs bekapcsolva.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'A(z) „%s” ügyfél-felhasználó már létezik.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Ez az e-mail cím már használatban van egy másik ügyfél-felhasználónál.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'előtt/után',
        'between' => 'között',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'például Szöveg vagy Sz*eg',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'A mező mellőzése.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Ez a mező kötelező vagy',
        'The field content is too long!' => 'A mező tartalma túl hosszú!',
        'Maximum size is %s characters.' => 'A legnagyobb méret %s karakter.',

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
            'Nem sikerült beolvasni az értesítés beállítófájlját. Győződjön meg arról, hogy a fájl érvényes-e.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Az importált értesítésnek 4000 karakternél hosszabb törzsszövege van.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'nincs telepítve',
        'installed' => 'telepített',
        'Unable to parse repository index document.' => 'Nem sikerült feldolgozni a tároló index dokumentumot.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Ebben a tárolóban nem találhatók csomagok a keretrendszer verziójához, csak más keretrendszer verziókhoz való csomagokat tartalmaz.',
        'File is not installed!' => 'A fájl nincs telepítve!',
        'File is different!' => 'A fájl eltérő!',
        'Can\'t read file!' => 'Nem olvasható a fájl!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '<p>Ha folytatja a csomag telepítését, a következő hibák fordulhatnak elő!</p><ul><li>Biztonsági problémák</li><li>Stabilitási problémák</li><li>Teljesítmény problémák</li></ul><p>Vegye figyelembe, hogy a csomag használata során felmerülő problémákra nem vonatkozik az OTOBO szolgáltatási szerződése!</p>',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>Alapértelmezetten nem lehetséges azoknak a csomagoknak a telepítése, amelyeket nem ellenőrzött az OTRS csoport. A nem ellenőrzött csomagok telepítést az „AllowNotVerifiedPackages” rendszerbeállításon keresztül aktiválhatja.</p>',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'A(z) „%s” folyamat és annak összes adata sikeresen importálva lett.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inaktív',
        'FadeAway' => 'Kivezetve',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Nem sikerült elérni a regisztrációs kiszolgálót. Próbálja meg később újra.',
        'No content received from registration server. Please try again later.' =>
            'Nem érkezett tartalom a regisztrációs kiszolgálótól. Próbálja meg később újra.',
        'Can\'t get Token from sever' => 'Nem lehet lekérni a tokent a kiszolgálóról',
        'Username and password do not match. Please try again.' => 'A felhasználónév és a jelszó nem egyezik. Próbálja újra.',
        'Problems processing server result. Please try again later.' => 'Hiba a kiszolgáló eredményének feldolgozásakor. Próbálja meg később újra.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Összesen',
        'week' => 'hét',
        'quarter' => 'negyedév',
        'half-year' => 'félév',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Állapot típusa',
        'Created Priority' => 'Létrehozott prioritás',
        'Created State' => 'Létrehozott állapot',
        'Create Time' => 'Létrehozás ideje',
        'Pending until time' => 'Függő befejezési idő',
        'Close Time' => 'Lezárás ideje',
        'Escalation' => 'Eszkaláció',
        'Escalation - First Response Time' => 'Eszkaláció – első válaszidő',
        'Escalation - Update Time' => 'Eszkaláció – frissítési idő',
        'Escalation - Solution Time' => 'Eszkaláció – megoldási idő',
        'Agent/Owner' => 'Ügyintéző/Tulajdonos',
        'Created by Agent/Owner' => 'Létrehozta: ügyintéző/tulajdonos',
        'Assigned to Customer User Login' => 'Hozzárendelve egy ügyfél-felhasználó belépéshez',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Kiértékelés',
        'Ticket/Article Accounted Time' => 'Jegy/Bejegyzés elszámolt idő',
        'Ticket Create Time' => 'Jegy létrehozásának ideje',
        'Ticket Close Time' => 'Jegy lezárásának ideje',
        'Accounted time by Agent' => 'Ügyintéző által elszámolt idő',
        'Total Time' => 'Teljes idő',
        'Ticket Average' => 'Jegy átlag',
        'Ticket Min Time' => 'Jegy legkisebb ideje',
        'Ticket Max Time' => 'Jegy legnagyobb ideje',
        'Number of Tickets' => 'Jegyek száma',
        'Article Average' => 'Bejegyzés átlag',
        'Article Min Time' => 'Bejegyzés legkisebb ideje',
        'Article Max Time' => 'Bejegyzés legnagyobb ideje',
        'Number of Articles' => 'Bejegyzések száma',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'korlátlan',
        'Attributes to be printed' => 'Nyomtatandó jellemzők',
        'Sort sequence' => 'Rendezési sorrend',
        'State Historic' => 'Történelmi állapot',
        'State Type Historic' => 'Történelmi állapottípus',
        'Historic Time Range' => 'Történelmi időtartomány',
        'Number' => 'Szám',
        'Last Changed' => 'Utoljára módosítva',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Megoldás átlaga',
        'Solution Min Time' => 'Megoldás legkisebb ideje',
        'Solution Max Time' => 'Megoldás legnagyobb ideje',
        'Solution Average (affected by escalation configuration)' => 'Megoldás átlaga (az eszkalációs beállítás által érintett)',
        'Solution Min Time (affected by escalation configuration)' => 'Megoldás legkisebb ideje (az eszkalációs beállítás által érintett)',
        'Solution Max Time (affected by escalation configuration)' => 'Megoldás legnagyobb ideje (az eszkalációs beállítás által érintett)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Megoldás munkaidejének átlaga (az eszkalációs beállítás által érintett)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Megoldás legkisebb munkaideje (az eszkalációs beállítás által érintett)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Megoldás legnagyobb munkaideje (az eszkalációs beállítás által érintett)',
        'First Response Average (affected by escalation configuration)' =>
            'Első válasz átlaga (az eszkalációs beállítás által érintett)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Első válasz legkisebb ideje (az eszkalációs beállítás által érintett)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Első válasz legnagyobb ideje (az eszkalációs beállítás által érintett)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Első válasz munkaidejének átlaga (az eszkalációs beállítás által érintett)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Első válasz legkisebb munkaideje (az eszkalációs beállítás által érintett)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Első válasz legnagyobb munkaideje (az eszkalációs beállítás által érintett)',
        'Number of Tickets (affected by escalation configuration)' => 'Jegyek száma (az eszkalációs beállítás által érintett)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Nap',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Elavult táblák',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'Elavult táblák találhatók az adatbázisban. Ezek eltávolíthatók, ha üresek.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tábla jelenlét',
        'Internal Error: Could not open file.' => 'Belső hiba: Nem sikerült megnyitni a fájlt.',
        'Table Check' => 'Táblaellenőrzés',
        'Internal Error: Could not read file.' => 'Belső hiba: Nem sikerült olvasni a fájlt.',
        'Tables found which are not present in the database.' => 'Olyan táblák találhatók, amelyek nincsenek az adatbázisban.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Adatbázisméret',
        'Could not determine database size.' => 'Nem sikerült meghatározni az adatbázis méretét.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Adatbázis-verzió',
        'Could not determine database version.' => 'Nem sikerült meghatározni az adatbázis verzióját.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Kliens kapcsolat karakterkészlete',
        'Setting character_set_client needs to be utf8.' => 'A character_set_client beállításnak utf8 értékűnek kell lennie.',
        'Server Database Charset' => 'Kiszolgáló adatbázis karakterkészlete',
        'The setting character_set_database needs to be \'utf8\'.' => 'A character_set_database beállításnak „utf8” értékűnek kell lennie.',
        'Table Charset' => 'Tábla karakterkészlete',
        'There were tables found which do not have \'utf8\' as charset.' =>
            'Olyan táblák találhatók, amelyek nem „utf8” karakterkészletűek.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB naplófájl méret',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Az innodb_log_file_size beállításnak legalább 256 MB értékűnek kell lennie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Érvénytelen alapértelmezett értékek',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Érvénytelen alapértelmezett értékekkel rendelkező táblák találhatók. Az automatikus javításukhoz futtassa a következő parancsot: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Legnagyobb lekérdezési méret',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'A „max_allowed_packet” beállításnak nagyobbnak kell lennie mint 64 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Lekérdezési gyorsítótár méret',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'A „query_cache_size” beállítást használni kell (nagyobb mint 10 MB, de nem több mint 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Alapértelmezett tárolómotor',
        'Table Storage Engine' => 'Táblatároló-motor',
        'Tables with a different storage engine than the default engine were found.' =>
            'Az alapértelmezett motortól eltérő motorral rendelkező táblák találhatók.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x vagy újabb szükséges.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG beállítás',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'Az NLS_LANG értékét al32utf8 értékre kell állítani (például: GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT beállítás',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'Az NLS_DATE_FORMAT értékét „YYYY-MM-DD HH24:MI:SS” értékre kell állítani.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT beállítás SQL ellenőrzés',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Elsődleges kulcs sorozatok és aktiválók',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'A következő, valószínűleg rossz névvel rendelkező sorozatok és/vagy aktiválók találhatók. Nevezze át kézzel azokat.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'A client_encoding beállításnak UNICODE vagy UTF8 értékűnek kell lennie.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'A server_encoding beállításnak UNICODE vagy UTF8 értékűnek kell lennie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Dátumformátum',
        'Setting DateStyle needs to be ISO.' => 'A DateStyle beállításnak ISO értékűnek kell lennie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Elsődleges kulcs sorozatok',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'A következő, valószínűleg rossz névvel rendelkező sorozatok találhatók. Nevezze át kézzel azokat.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 vagy újabb szükséges.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO lemezpartíció',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Lemezhasználat',
        'The partition where OTOBO is located is almost full.' => 'Az OTOBO-t tartalmazó partíció majdnem betelt.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Az OTOBO-t tartalmazó partíciónak nincs tárhely problémája.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Lemezpartíciók használata',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Disztribúció',
        'Could not determine distribution.' => 'Nem sikerült meghatározni a disztribúciót.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel verzió',
        'Could not determine kernel version.' => 'Nem sikerült meghatározni a kernel verzióját.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Rendszerterhelés',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'A rendszerterhelésnek legfeljebb annyinak kell lennie, ahány processzorral a rendszer rendelkezik (például 8-as vagy kisebb terhelés egy 8 processzoros rendszeren rendben van).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl modulok',
        'Not all required Perl modules are correctly installed.' => 'Nincs minden szükséges Perm modul megfelelően telepítve.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Perl modulok vizsgálata',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'A CPAN::Audit azt jelentette, hogy egy vagy több telepített Perl modul ismert sebezhetőséggel rendelkezik. Ne feledje, hogy lehetnek tévesen jelzett jelentések is azoknál a disztribúcióknál, amelyek úgy foltozzák a Perl modulokat, hogy nem változtatják meg a verziószámokat.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'A CPAN::Audit nem jelentett semmilyen ismert sebezhetőséget a telepített Perl modulokban.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Szabad lapozófájl méret (%)',
        'No swap enabled.' => 'Nincs lapozófájl engedélyezve.',
        'Used Swap Space (MB)' => 'Használt lapozófájl méret (MB)',
        'There should be more than 60% free swap space.' => '60%-nál több szabad lapozófájlnak kellene lennie.',
        'There should be no more than 200 MB swap space used.' => '200 MB-nál nem kellene több lapozófájlt használni.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Bejegyzés keresési index állapot',
        'Indexed Articles' => 'Indexelt bejegyzések',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Bejegyzések kommunikációs csatornánként',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Bejövő kommunikációk',
        'Outgoing communications' => 'Kimenő kommunikációk',
        'Failed communications' => 'Sikertelen kommunikációk',
        'Average processing time of communications (s)' => 'Kommunikációk átlagos feldolgozási ideje (mp)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Kommunikációs napló fiókjának állapota (az elmúlt 24 óra)',
        'No connections found.' => 'Nem találhatók kapcsolatok.',
        'ok' => 'OK',
        'permanent connection errors' => 'állandó kommunikációs hibák',
        'intermittent connection errors' => 'időszakos kommunikációs hibák',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Konfigurációs beállítások',
        'Could not determine value.' => 'Nem sikerült meghatározni az értéket.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Démon',
        'Daemon is running.' => 'A démon fut.',
        'Daemon is not running.' => 'A démon nem fut.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Adatbázis rekordok',
        'Ticket History Entries' => 'Jegy előzmény bejegyzések',
        'Articles' => 'Bejegyzések',
        'Attachments (DB, Without HTML)' => 'Mellékletek (DB, HTML nélkül)',
        'Customers With At Least One Ticket' => 'Legalább egy jeggyel rendelkező ügyfelek',
        'Dynamic Field Values' => 'Dinamikus mező értékek',
        'Invalid Dynamic Fields' => 'Érvénytelen dinamikus mezők',
        'Invalid Dynamic Field Values' => 'Érvénytelen dinamikus mező értékek',
        'GenericInterface Webservices' => 'Általános felület webszolgáltatások',
        'Process Tickets' => 'Folyamatjegyek',
        'Months Between First And Last Ticket' => 'Az első és az utolsó jegy közti hónapok',
        'Tickets Per Month (avg)' => 'Jegyek havonta (átlag)',
        'Open Tickets' => 'Nyitott jegyek',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Alapértelmezett SOAP felhasználónév és jelszó',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Biztonsági kockázat: a SOAP::User és a SOAP::Password alapértelmezett beállításait használja. Változtassa meg.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Alapértelmezett adminisztrátor jelszó',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Biztonsági kockázat: a root@localhost ügyintéző fióknak még mindig az alapértelmezett jelszava van. Változtassa meg, vagy érvénytelenítse a fiókot.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'E-mail várakozási sor',
        'Emails queued for sending' => 'Küldéshez sorba állított e-mailek',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (tartománynév)',
        'Please configure your FQDN setting.' => 'Állítsa be az FQDN beállítását.',
        'Domain Name' => 'Tartománynév',
        'Your FQDN setting is invalid.' => 'Az FQDN beállítás érvénytelen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Fájlrendszer írhatóság',
        'The file system on your OTOBO partition is not writable.' => 'Az OTOBO partíció fájlrendszere nem írható.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Örökölt konfigurációs biztonsági mentések',
        'No legacy configuration backup files found.' => 'Nem találhatók örökölt biztonsági mentés fájlok.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Örökölt konfigurációs biztonsági mentés fájlok találhatók a Kernel/Config/Backups mappában, de néhány csomagnak még szükségük lehet rájuk.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Az örökölt konfigurációs biztonsági mentés fájlok többé nem szükségesek a telepített csomagokhoz, távolítsa el azokat a Kernel/Config/Backups mappából.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Csomagtelepítési állapot',
        'Some packages have locally modified files.' => 'Néhány csomag helyileg módosított fájlokkal rendelkezik.',
        'Some packages are not correctly installed.' => 'Néhány csomag nincs megfelelően telepítve.',
        'Package Verification Status' => 'Csomagellenőrzési állapot',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            'Néhány csomagot nem ellenőrzött az OTRS csoport! Nem javasolt a csomagok használata.',
        'Package Framework Version Status' => 'Csomag keretrendszer verziójának állapota',
        'Some packages are not allowed for the current framework version.' =>
            'Néhány csomag nem engedélyezett a jelenlegi keretrendszer verzióhoz.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Csomaglista',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Munkamenet-konfigurációs beállítások',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'Várakozási sorba helyezett levelek',
        'There are emails in var/spool that OTOBO could not process.' => 'Olyan levelek találhatók a var/spool mappában, amelyeket az OTOBO nem tudott feldolgozni.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'A rendszer-azonosító beállítás érvénytelen, csak számjegyeket tartalmazhat.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Alapértelmezett jegytípus',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'A beállított alapértelmezett jegytípus érvénytelen vagy hiányzik. Változtassa meg a Ticket::Type::Default beállításait, és válasszon egy érvényes jegytípust.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Jegyindexelő modul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Több mint 60.000 jegye van, ezért a StaticDB háttérprogramot kellene használnia. További információkért nézze meg az adminisztrátori kézikönyvet (Teljesítmény finomhangolás).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Érvénytelen felhasználók zárolt jegyekkel',
        'There are invalid users with locked tickets.' => 'Zárolt jegyekkel rendelkező érvénytelen felhasználók vannak.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Nem kellene 8.000 nyitott jegynél többel rendelkeznie a rendszeren.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Jegykeresés indexelő modul',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Az indexelési folyamat kényszeríti az eredeti bejegyzésszöveg tárolását a bejegyzés keresési indexében anélkül, hogy szűrőket hajtana végre vagy a kiszűrendő szavak listáit alkalmazná. Ez meg fogja növelni a keresési index méretét, és ezért lelassíthatja a szabad-szavas kereséseket.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Árva rekordok a ticket_lock_index táblában',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A ticket_lock_index tábla árva rekordokat tartalmaz. Futtassa a bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" parancsot a StaticDB index tisztításához.',
        'Orphaned Records In ticket_index Table' => 'Árva rekordok a ticket_index táblában',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A ticket_index tábla árva rekordokat tartalmaz. Futtassa a bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" parancsot a StaticDB index tisztításához.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Időbeállítások',
        'Server time zone' => 'Kiszolgáló időzónája',
        'OTOBO time zone' => 'OTOBO időzóna',
        'OTOBO time zone is not set.' => 'Az OTOBO időzónája nincs beállítva.',
        'User default time zone' => 'Felhasználó alapértelmezett időzónája',
        'User default time zone is not set.' => 'A felhasználó alapértelmezett időzónája nincs beállítva.',
        'Calendar time zone is not set.' => 'A naptár időzónája nincs beállítva.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI – ügyintézői felszín használat',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI – ügyintézői téma használat',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI – különleges statisztikák',
        'Agents using custom main menu ordering' => 'Egyéni menürendezést használó ügyintézők',
        'Agents using favourites for the admin overview' => 'Kedvenceket használó ügyintézők az adminisztrációs áttekintőnél',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webkiszolgáló',
        'Loaded Apache Modules' => 'Betöltött Apache modulok',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM modell',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'Az OTOBO az apache „prefork” MPM modellel való futtatását igényli.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI gyorsító használat',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'A FastCGI vagy a mod_perl használatára lenne szüksége a teljesítmény növeléséhez.',
        'mod_deflate Usage' => 'mod_deflate használat',
        'Please install mod_deflate to improve GUI speed.' => 'Telepítse a mod_deflate csomagot a felhasználói felület sebességének növeléséhez.',
        'mod_filter Usage' => 'mod_filter használat',
        'Please install mod_filter if mod_deflate is used.' => 'Telepítse a mod_filter modult, ha a mod_deflate használatban van.',
        'mod_headers Usage' => 'mod_headers használat',
        'Please install mod_headers to improve GUI speed.' => 'Telepítse a mod_headers csomagot a felhasználói felület sebességének növeléséhez.',
        'Apache::Reload Usage' => 'Apache::Reload használat',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Az Apache::Reload vagy az Apache2::Reload használata kellene PerlModule és PerlInitHandler modulként a webkiszolgáló újraindításának megakadályozásához, amikor modulokat telepít és frissít.',
        'Apache2::DBI Usage' => 'Apache2::DBI használat',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Az Apache2::DBI használata kellene az előre kiépített adatbázis-kapcsolatokkal való jobb teljesítmény eléréséhez.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Környezeti változók',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Támogatási adatgyűjtés',
        'Support data could not be collected from the web server.' => 'A támogatási adatokat nem sikerült begyűjteni a webkiszolgálóról.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webkiszolgáló verzió',
        'Could not determine webserver version.' => 'Nem sikerült meghatározni a webkiszolgáló verzióját.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Egyidejű felhasználók részletei',
        'Concurrent Users' => 'Egyidejű felhasználók',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Probléma',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'A(z) %s beállítás nem létezik!',
        'Setting %s is not locked to this user!' => 'A(z) %s beállítás nem ehhez a felhasználóhoz van zárolva!',
        'Setting value is not valid!' => 'A beállítás értéke nem érvényes!',
        'Could not add modified setting!' => 'Nem sikerült hozzáadni a módosított beállítást!',
        'Could not update modified setting!' => 'Nem sikerült frissíteni a módosított beállítást!',
        'Setting could not be unlocked!' => 'A beállítást nem sikerült feloldani!',
        'Missing key %s!' => 'Hiányzó %s kulcs!',
        'Invalid setting: %s' => 'Érvénytelen beállítás: %s',
        'Could not combine settings values into a perl hash.' => 'Nem sikerült egyesíteni a beállítások értékeit Perl kivonatba.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Nem lehet zárolni az üzembe állítást a következő felhasználó-azonosítónál: „%s”!',
        'All Settings' => 'Összes beállítás',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Alapértelmezett',
        'Value is not correct! Please, consider updating this field.' => 'Az érték nem helyes! Érdemes lenne frissíteni ezt a mezőt.',
        'Value doesn\'t satisfy regex (%s).' => 'Az érték nem teljesíti a reguláris kifejezést (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Engedélyezve',
        'Disabled' => 'Letiltva',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'A rendszer nem volt képes kiszámítani a felhasználó dátumát az OTOBO időzónájában!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'A rendszer nem volt képes kiszámítani a felhasználó dátumát és idejét az OTOBO időzónájában!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Az érték nem helyes! Érdemes lenne frissíteni ezt a modult.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Az érték nem helyes! Érdemes lenne frissíteni ezt a beállítást.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Feloldás idejének átállítása.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Csevegés résztvevője',
        'Chat Message Text' => 'Csevegés üzenet szövege',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Sikertelen bejelentkezés! A megadott felhasználónév vagy jelszó hibás.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'A hitelesítés sikerült, de nem található felhasználói adatrekord az adatbázisban. Vegye fel a kapcsolatot a rendszergazdával.',
        'Can`t remove SessionID.' => 'Nem lehet eltávolítani a munkamenet-azonosítót.',
        'Logout successful.' => 'Sikeres kilépés.',
        'Feature not active!' => 'A funkció nem aktív!',
        'Sent password reset instructions. Please check your email.' => 'A jelszó visszaállítási utasítások elküldve. Nézze meg a leveleit.',
        'Invalid Token!' => 'Érvénytelen token!',
        'Sent new password to %s. Please check your email.' => 'Az új jelszó elküldve erre a címre: %s. Nézze meg a leveleit.',
        'Error: invalid session.' => 'Hiba: érvénytelen munkamenet.',
        'No Permission to use this frontend module!' => 'Nincs jogosultsága ezen előtétprogram-modul használatához!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'A hitelesítés sikerült, de nem található ügyfélrekord az ügyfél háttérprogramban. Vegye fel a kapcsolatot a rendszergazdával.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'A jelszó visszaállítása sikertelen. Vegye fel a kapcsolatot a rendszergazdával.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Ez az e-mail cím már létezik. Jelentkezzen be, vagy állítsa vissza a jelszavát.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Ez az e-mail cím nem megengedett a regisztráláshoz. Vegye fel a kapcsolatot a támogató csapattal.',
        'Added via Customer Panel (%s)' => 'Hozzáadva az ügyfélpanelen keresztül (%s)',
        'Customer user can\'t be added!' => 'Az ügyfél-felhasználót nem lehet hozzáadni!',
        'Can\'t send account info!' => 'Nem lehet elküldeni a fiókinformációkat!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Az új fiók létrehozva. A bejelentkezési információkat elküldtük erre a címre: %s. Nézze meg a leveleit.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'A(z) „%s” művelet nem található!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'átmenetileg érvénytelen',
        'Group for default access.' => 'Csoport az alapértelmezett hozzáféréshez.',
        'Group of all administrators.' => 'Az összes adminisztrátor csoportja.',
        'Group for statistics access.' => 'Csoport a statisztikák hozzáféréshez.',
        'new' => 'új',
        'All new state types (default: viewable).' => 'Minden új állapottípus (alapértelmezett: megtekinthető).',
        'open' => 'nyitott',
        'All open state types (default: viewable).' => 'Minden nyitott állapottípus (alapértelmezett: megtekinthető).',
        'closed' => 'lezárva',
        'All closed state types (default: not viewable).' => 'Minden lezárt állapottípus (alapértelmezett: nem megtekinthető).',
        'pending reminder' => 'emlékeztető függőben',
        'All \'pending reminder\' state types (default: viewable).' => 'Minden „emlékeztető függőben” állapottípus (alapértelmezett: megtekinthető).',
        'pending auto' => 'automatikus függőben',
        'All \'pending auto *\' state types (default: viewable).' => 'Minden „automatikus * függőben” állapottípus (alapértelmezett: megtekinthető).',
        'removed' => 'eltávolított',
        'All \'removed\' state types (default: not viewable).' => 'Minden „eltávolított” állapottípus (alapértelmezett: nem megtekinthető).',
        'merged' => 'egyesített',
        'State type for merged tickets (default: not viewable).' => 'Állapottípus az egyesített jegyeknél (alapértelmezett: nem megtekinthető).',
        'New ticket created by customer.' => 'Az ügyfél által létrehozott új jegy.',
        'closed successful' => 'sikeresen lezárva',
        'Ticket is closed successful.' => 'A jegy sikeresen lezárva.',
        'closed unsuccessful' => 'sikertelenül lezárva',
        'Ticket is closed unsuccessful.' => 'A jegy sikertelenül lezárva.',
        'Open tickets.' => 'Nyitott jegyek.',
        'Customer removed ticket.' => 'Az ügyfél eltávolította a jegyet.',
        'Ticket is pending for agent reminder.' => 'A jegy ügyintézői emlékeztetőre vár.',
        'pending auto close+' => 'automatikus lezárás függőben+',
        'Ticket is pending for automatic close.' => 'A jegy automatikus lezárásra vár.',
        'pending auto close-' => 'automatikus lezárás függőben-',
        'State for merged tickets.' => 'Állapot az egyesített jegyeknél.',
        'system standard salutation (en)' => 'a rendszer szabványos megszólítása (en)',
        'Standard Salutation.' => 'Szabványos megszólítás.',
        'system standard signature (en)' => 'a rendszer szabványos aláírása (en)',
        'Standard Signature.' => 'Szabványos aláírás.',
        'Standard Address.' => 'Szabványos cím.',
        'possible' => 'lehetséges',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Követések lehetségesek a lezárt jegyeknél. A jegy újra lesz nyitva.',
        'reject' => 'elutasítás',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Követések nem lehetségesek a lezárt jegyeknél. Nem lesz új jegy létrehozva.',
        'new ticket' => 'új jegy',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Követések nem lehetségesek a lezárt jegyeknél. Egy új jegy lesz létrehozva.',
        'Postmaster queue.' => 'Levelezési várólista.',
        'All default incoming tickets.' => 'Minden alapértelmezetten bejövő jegy.',
        'All junk tickets.' => 'Minden szemét jegy.',
        'All misc tickets.' => 'Minden egyéb jegy.',
        'auto reply' => 'automatikus válasz',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatikus válasz, amely akkor lesz kiküldve, miután egy új jegyet létrehoztak.',
        'auto reject' => 'automatikus elutasítás',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatikus elutasítás, amely akkor lesz kiküldve, miután egy követést elutasítottak (abban az esetben, ha a várólista követési beállítása „elutasítás”).',
        'auto follow up' => 'automatikus követés',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatikus beállítás, amely akkor lesz kiküldve, miután egy követést fogadtak egy jegyhez (abban az esetben, ha a várólista követési beállítása „lehetséges”).',
        'auto reply/new ticket' => 'automatikus válasz/új jegy',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatikus válasz, amely akkor lesz kiküldve, miután egy követést elutasítottak és egy új jegyet létrehoztak (abban az esetben, ha a várólista követési beállítása „új jegy”).',
        'auto remove' => 'automatikus eltávolítás',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Automatikus eltávolítás akkor lesz kiküldve, miután egy ügyfél eltávolította a kérést.',
        'default reply (after new ticket has been created)' => 'alapértelmezett válasz (miután egy új jegyet létrehoztak)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'alapértelmezett elutasítás (egy lezárt jegy követése és elutasítása után)',
        'default follow-up (after a ticket follow-up has been added)' => 'alapértelmezett követés (miután egy jegy követést hozzáadtak)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'alapértelmezett elutasítás/új jegy létrehozva (új jegy létrehozásával történő lezárt követés után)',
        'Unclassified' => 'Osztályozatlan',
        '1 very low' => '1 nagyon alacsony',
        '2 low' => '2 alacsony',
        '3 normal' => '3 normál',
        '4 high' => '4 magas',
        '5 very high' => '5 nagyon magas',
        'unlock' => 'feloldott',
        'lock' => 'zárolt',
        'tmp_lock' => 'átmenetileg zárolt',
        'agent' => 'ügyintéző',
        'system' => 'rendszer',
        'customer' => 'ügyfél',
        'Ticket create notification' => 'Jegy létrehozási értesítés',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Egy értesítést fog kapni minden alkalommal, amikor egy új jegy jön létre a „Saját várólistái” vagy a „Saját szolgáltatásai” egyikében.',
        'Ticket follow-up notification (unlocked)' => 'Jegy követési értesítés (feloldott)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Egy értesítést fog kapni, ha egy ügyfél egy követést küld egy olyan feloldott jegyhez, amely a „Saját várólistáiban” vagy a „Saját szolgáltatásaiban” van.',
        'Ticket follow-up notification (locked)' => 'Jegy követési értesítés (zárolt)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Egy értesítést fog kapni, ha egy ügyfél egy követést küld egy olyan zárolt jegyhez, amelynek Ön a jegytulajdonosa vagy a felelőse.',
        'Ticket lock timeout notification' => 'Jegyzárolási időkorlát értesítés',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Egy értesítést fog kapni, amint az Ön tulajdonában lévő jegy automatikusan feloldásra kerül.',
        'Ticket owner update notification' => 'Jegytulajdonos frissítési értesítés',
        'Ticket responsible update notification' => 'Jegyfelelős frissítési értesítés',
        'Ticket new note notification' => 'Új jegyjegyzet értesítés',
        'Ticket queue update notification' => 'Jegyvárólista frissítési értesítés',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Egy értesítést fog kapni, ha egy jegyet a „Saját várólistái” egyikébe helyeznek át.',
        'Ticket pending reminder notification (locked)' => 'Jegy emlékeztető függőben értesítés (zárolt)',
        'Ticket pending reminder notification (unlocked)' => 'Jegy emlékeztető függőben értesítés (feloldott)',
        'Ticket escalation notification' => 'Jegyeszkaláció értesítés',
        'Ticket escalation warning notification' => 'Jegyeszkaláció figyelmeztetési értesítés',
        'Ticket service update notification' => 'Jegyszolgáltatás frissítési értesítés',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Egy értesítést fog kapni, ha egy jegy szolgáltatását a „Saját szolgáltatásai” egyikére változtatják meg.',
        'Appointment reminder notification' => 'Időpont emlékeztető értesítés',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Egy értesítést fog kapni minden alkalommal, amikor egy emlékeztető idő elérésre kerül az időpontjai egyikénél.',
        'Ticket email delivery failure notification' => 'Jegy e-mail kézbesítési hiba értesítése',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Hiba történt az AJAX kommunikáció közben. Állapot: %s, hiba: %s',
        'This window must be called from compose window.' => 'Ezt az ablakot a jegyválasz ablakból kell meghívni.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Összes hozzáadása',
        'An item with this name is already present.' => 'Már létezik egy elem ezzel a névvel.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ez az elem még mindig tartalmaz részelemeket. Biztosan törölni szeretné ezt az elemet a részelemeivel együtt?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Több',
        'Less' => 'Kevesebb',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Nyomja meg a Ctrl+C (Cmd+C) billentyűket a vágólapra másoláshoz',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Melléklet törlése',
        'Deleting attachment...' => 'Melléklet törlése…',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Hiba történt a melléklet törlésekor. További információkért nézze meg a naplókat.',
        'Attachment was deleted successfully.' => 'A melléklet sikeresen törölve lett.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Valóban törölni szeretné ezt a dinamikus mezőt? MINDEN hozzárendelt adat EL FOG VESZNI!',
        'Delete field' => 'Mező törlése',
        'Deleting the field and its data. This may take a while...' => 'A mező és az adatainak törlése folyamatban van. Ez eltarthat egy ideig…',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Dinamikus mező eltávolítása',
        'Remove selection' => 'Kijelölés eltávolítása',
        'Do you really want to delete this generic agent job?' => 'Valóban törölni szeretné ezt az általános ügyintéző feladatot?',
        'Delete this Event Trigger' => 'Eseményaktiváló törlése',
        'Duplicate event.' => 'Esemény kettőzése.',
        'This event is already attached to the job, Please use a different one.' =>
            'Ez az esemény már csatolva van a feladathoz, használjon egy másikat.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Hiba történt a kommunikáció közben.',
        'Request Details' => 'Kérés részletei',
        'Request Details for Communication ID' => 'Kérés részletei a kommunikáció-azonosítónál',
        'Show or hide the content.' => 'A tartalom megjelenítése vagy elrejtése.',
        'Clear debug log' => 'Hibakeresési napló törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Hibakezelési modul törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Nem lehetséges új eseményaktiváló hozzáadása, mert az esemény nincs beállítva.',
        'Delete this Invoker' => 'Meghívó törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Sajnáljuk, de az egyetlen meglévő feltételt nem lehet eltávolítani.',
        'Sorry, the only existing field can\'t be removed.' => 'Sajnáljuk, de az egyetlen meglévő mezőt nem lehet eltávolítani.',
        'Delete conditions' => 'Feltételek törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Leképezés a kulcshoz: %s',
        'Mapping for Key' => 'Leképezés a kulcshoz',
        'Delete this Key Mapping' => 'Kulcsleképezés törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Művelet törlése',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Webszolgáltatás klónozása',
        'Delete operation' => 'Művelet törlése',
        'Delete invoker' => 'Meghívó törlése',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'FIGYELEM: Ha az „admin” csoport nevét megváltoztatja a megfelelő SysConfig beállítások előtt, úgy ki lesz zárva az adminisztrációs felületről! Ha ez megtörtént, akkor nevezze vissza a csoportot „admin” névre egy SQL utasítás segítségével.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Levelezési fiók törlése',
        'Deleting the mail account and its data. This may take a while...' =>
            'A levelezési fiók és az adatainak törlése folyamatban van. Ez eltarthat egy ideig…',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Valóban törölni szeretné ezt az értesítési nyelvet?',
        'Do you really want to delete this notification?' => 'Valóban törölni szeretné ezt az értesítést?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Valóban törölni szeretné ezt a kulcsot?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Egy csomagfrissítési folyamat jelenleg is fut, kattintson ide a frissítési folyamattal kapcsolatos állapotinformációk megtekintéséhez.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'Egy csomagfrissítés nemrég befejeződött. Kattintson ide az eredmények megtekintéséhez.',
        'No response from get package upgrade result.' => 'Nincs válasz a csomaglekérés frissítések eredményéről.',
        'Update all packages' => 'Összes csomag frissítése',
        'Dismiss' => 'Eltüntetés',
        'Update All Packages' => 'Összes csomag frissítése',
        'No response from package upgrade all.' => 'Nincs válasz az összes csomag frissítéséről.',
        'Currently not possible' => 'Jelenleg nem lehetséges',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Ez jelenleg le van tiltva egy folyamatban lévő csomagfrissítés miatt.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Ez a beállítás jelenleg le van tiltva, mert az OTOBO démon nem fut.',
        'Are you sure you want to update all installed packages?' => 'Biztosan frissíteni szeretné az összes telepített csomagot?',
        'No response from get package upgrade run status.' => 'Nincs válasz a csomaglekérés frissítések futási állapotáról.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Levelezési szűrő törlése',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'A levelezési szűrő és az adatainak törlése folyamatban van. Ez eltarthat egy ideig…',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Entitás eltávolítása a vászonról',
        'No TransitionActions assigned.' => 'Nincsenek átmenet műveletek hozzárendelve.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Még nincsenek párbeszédek hozzárendelve. Csak fogjon meg egy tevékenység párbeszédet a bal oldali listából, és húzza ide.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Ez a tevékenység nem törölhető, mert ez a kezdő tevékenység.',
        'Remove the Transition from this Process' => 'Átmenet eltávolítása ebből a folyamatból',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Amint ezt a gombot vagy hivatkozást használja, el fogja hagyni ezt a képernyőt, és a jelenlegi állapota automatikusan el lesz mentve. Szeretné folytatni?',
        'Delete Entity' => 'Entitás törlése',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Ez a tevékenység már használatban van a folyamatban. Nem adhatja hozzá kétszer!',
        'Error during AJAX communication' => 'Hiba történt az AJAX kommunikáció közben',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Egy kapcsolatban nem lévő átmenet már el van helyezve a vásznon. Először csatlakoztassa ezt az átmenetet, mielőtt egy másik átmenetet helyezne el.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Ez az átmenet már használatban van a tevékenységben. Nem használhatja kétszer!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ez az átmenet művelet már használatban van az útvonalon. Nem használhatja kétszer!',
        'Hide EntityIDs' => 'Entitás-azonosítók elrejtése',
        'Edit Field Details' => 'Mezőrészletek szerkesztése',
        'Customer interface does not support articles not visible for customers.' =>
            'Az ügyfélfelület nem támogatja az ügyfeleknek nem látható bejegyzéseket.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Sajnáljuk, de az egyetlen meglévő paramétert nem lehet eltávolítani.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Valóban törölni szeretné ezt a tanúsítványt?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Frissítés küldése…',
        'Support Data information was successfully sent.' => 'A támogatási adatok információi sikeresen elküldve.',
        'Was not possible to send Support Data information.' => 'Nem volt lehetséges a támogatási adatok információinak küldése.',
        'Update Result' => 'Eredmény frissítése',
        'Generating...' => 'Előállítás…',
        'It was not possible to generate the Support Bundle.' => 'Nem volt lehetséges a támogatási csomag előállítása.',
        'Generate Result' => 'Előállítás eredménye',
        'Support Bundle' => 'Támogatási csomag',
        'The mail could not be sent' => 'A levelet nem sikerült elküldeni',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Nem lehetséges ezt a bejegyzést érvénytelenre állítani. Az összes érintett konfigurációs beállítást meg kell változtatni előtte.',
        'Cannot proceed' => 'Nem lehet folytatni',
        'Update manually' => 'Frissítés kézzel',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Az érintett beállításokat frissíttetheti automatikusan az elvégzett változtatások érvényesítéséhez, vagy megteheti saját maga a „frissítés kézzel” megnyomásával.',
        'Save and update automatically' => 'Mentés és frissítés automatikusan',
        'Don\'t save, update manually' => 'Ne mentse, frissítés kézzel',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'Az az elem, amelyet jelenleg néz, egy még nem üzembe állított konfigurációs beállítás része, amely lehetetlenné teszi annak szerkesztését a jelenlegi állapotában. Várja meg, amíg a beállítást üzembe helyezik. Ha nem biztos abban, hogy mit kell ezután csinálni, akkor vegye fel a kapcsolatot a rendszergazdával.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Betöltés…',
        'Search the System Configuration' => 'A rendszerbeállítás keresése',
        'Please enter at least one search word to find anything.' => 'Adjon meg legalább egy keresőszót, ha bármire rá szeretne keresni.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Sajnálatos módon az üzembe állítás jelenleg nem lehetséges, mert talán egy másik ügyintéző már üzembe állította. Próbálja meg később újra.',
        'Deploy' => 'Üzembe állítás',
        'The deployment is already running.' => 'Az üzembe állítás már fut.',
        'Deployment successful. You\'re being redirected...' => 'Az üzembe állítás sikerült. Most átirányítjuk…',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Hiba történt. Mentse el az összes beállítást, amelyet szerkesztett, és nézze mag a naplót a további információkért.',
        'Reset option is required!' => 'Visszaállítási lehetőség szükséges!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Az üzembe állítás visszaállításával az összes beállítás vissza lesz állítva arra az értékre, amelyben az üzembe állítás pillanatában volt. Valóban folytatni akarja?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Az értékekkel rendelkező kulcsok nem nevezhetők át. Távolítsa inkább el ezt a kulcs/érték párt, és adja hozzá azután ismét.',
        'Unlock setting.' => 'Beállítás feloldása.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Valóban törölni szeretné ezt az ütemezett rendszerkarbantartást?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Sablon törlése',
        'Deleting the template and its data. This may take a while...' =>
            'A sablon és az adatainak törlése folyamatban van. Ez eltarthat egy ideig…',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Ugrás',
        'Timeline Month' => 'Havi idővonal',
        'Timeline Week' => 'Heti idővonal',
        'Timeline Day' => 'Napi idővonal',
        'Previous' => 'Előző',
        'Resources' => 'Erőforrások',
        'Su' => 'v',
        'Mo' => 'h',
        'Tu' => 'k',
        'We' => 'sze',
        'Th' => 'cs',
        'Fr' => 'p',
        'Sa' => 'szo',
        'This is a repeating appointment' => 'Ez egy ismétlődő időpont',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Csak ezt az előfordulást szeretné szerkeszteni vagy az összeset?',
        'All occurrences' => 'Összes előfordulás',
        'Just this occurrence' => 'Csak ez az előfordulás',
        'Too many active calendars' => 'Túl sok aktív naptár',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Vagy kapcsoljon ki néhányat először, vagy növelje a korlátot a beállításokban.',
        'Restore default settings' => 'Alapértelmezett beállítások visszaállítása',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Biztosan törölni szeretné ezt az időpontot? Ezt a műveletet nem lehet visszavonni.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Először válasszon egy ügyfél-felhasználót, majd válasszon egy ügyfél-azonosítót, hogy hozzárendelje ehhez a jegyhez.',
        'Duplicated entry' => 'Kettőzött bejegyzés',
        'It is going to be deleted from the field, please try again.' => 'Ez törölve lesz a mezőből, próbálja újra.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Adjon meg legalább egy keresési értéket, vagy * karaktert, ha bármire rá szeretne keresni.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Információk az OTOBO démonról',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Ellenőrizze a pirosan megjelölt mezőket a helyes bevitelekért.',
        'month' => 'hónap',
        'Remove active filters for this widget.' => 'A felületi elem aktív szűrőinek eltávolítása.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Kis türelmet…',
        'Searching for linkable objects. This may take a while...' => 'Összekapcsolható objektumok keresés. Ez eltarthat egy ideig…',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Valóban törölni szeretné ezt a kapcsolatot?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Olyan böngészőbővítményt használ mint az AdBlock vagy az AdBlockPlus? Ez számos problémát okozhat, emiatt erősen javasoljuk, hogy adjon hozzá kivételt ehhez a tartományhoz.',
        'Do not show this warning again.' => 'Ne jelenjen meg újra ez a figyelmeztetés.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Sajnáljuk, de nem tud minden módszert letiltani a kötelezőként megjelölt értesítéseknél.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Sajnáljuk, de nem tud minden módszert letiltani ennél az értesítésnél.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Ne feledje, hogy a megváltoztatott beállítások legalább egyike oldalújratöltést igényel. Kattintson ide a jelenlegi képernyő újratöltéséhez.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Ismeretlen hiba történt. Vegye fel a kapcsolatot a rendszergazdával.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Átváltás asztali módra',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Távolítsa el a következő szavakat a keresésből, mivel azokra nem lehet rákeresni:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Előállítás',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Ennek az elemnek gyermekelemei vannak, és jelenleg nem lehet eltávolítani.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Valóban törölni szeretné ezt a statisztikát?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Ügyfél-azonosító kiválasztása, hogy hozzárendelje ehhez a jegyhez',
        'Do you really want to continue?' => 'Valóban folytatni akarja?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' …és további %s',
        ' ...show less' => ' …kevesebb megjelenítése',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Új piszkozat hozzáadása',
        'Delete draft' => 'Piszkozat törlése',
        'There are no more drafts available.' => 'Nem érhető el több piszkozat.',
        'It was not possible to delete this draft.' => 'Nem volt lehetséges a piszkozat a törlése.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Bejegyzésszűrő',
        'Apply' => 'Alkalmaz',
        'Event Type Filter' => 'Eseménytípus szűrő',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Csúsztassa a navigációs sávot',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Kapcsolja ki a kompatibilitási módot az Internet Explorerben!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Átváltás mobil módra',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Hiba: a böngésző-ellenőrzés sikertelen!',
        'Reload page' => 'Oldal újratöltése',
        'Reload page (%ss)' => 'Oldal újratöltése (%s mp)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'A(z) %s névteret nem sikerült előkészíteni, mert a(z) %s nem található.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'Hiba történt! További részletekért nézze meg a böngésző hibanaplóját!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Egy vagy több hiba történt!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Levélellenőrzés sikeres.',
        'Error in the mail settings. Please correct and try again.' => 'Hiba van a levélbeállításokban. Javítsa és próbálja újra.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'A csomópont megnyitása egy új ablakban',
        'Please add values for all keys before saving the setting.' => 'Adjon értéket az összes kulcsnak, mielőtt elmentené a beállítást.',
        'The key must not be empty.' => 'A kulcs nem lehet üres.',
        'A key with this name (\'%s\') already exists.' => 'Egy ilyen nevű kulcs („%s”) már létezik.',
        'Do you really want to revert this setting to its historical value?' =>
            'Valóban vissza szeretné állítani ezt a beállítást a korábbi értékére?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Dátumkijelölés megnyitása',
        'Invalid date (need a future date)!' => 'Érvénytelen dátum (jövőbeli dátum szükséges)!',
        'Invalid date (need a past date)!' => 'Érvénytelen dátum (múltbeli dátum szükséges)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Nem érhető el',
        'and %s more...' => 'és további %s…',
        'Show current selection' => 'Jelenlegi kijelölés megjelenítése',
        'Current selection' => 'Jelenlegi kijelölés',
        'Clear all' => 'Összes törlése',
        'Filters' => 'Szűrők',
        'Clear search' => 'Keresés törlése',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Ha most elhagyja ezt az oldalt, az összes megnyitott felugró ablak is be fog záródni!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'A képernyő felugró ablaka már meg van nyitva. Szeretné bezárni, és helyette ezt betölteni?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nem sikerült megnyitni a felugró ablakot. Tiltson le minden felugró ablak blokkolót ennél az alkalmazásnál.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Növekvő rendezés alkalmazva, ',
        'Descending sort applied, ' => 'Csökkenő rendezés alkalmazva, ',
        'No sort applied, ' => 'Nincs rendezés alkalmazva, ',
        'sorting is disabled' => 'a rendezés le van tiltva',
        'activate to apply an ascending sort' => 'kapcsolja be egy növekvő rendezés alkalmazásához',
        'activate to apply a descending sort' => 'kapcsolja be egy csökkenő rendezés alkalmazásához',
        'activate to remove the sort' => 'kapcsolja be a rendezés eltávolításához',

        # JS File: Core.UI.Table
        'Remove the filter' => 'A szűrő eltávolítása',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Jelenleg nincsenek elérhető elemek, amelyekből kijelölhetne.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Csak egy fájlt válasszon a feltöltéshez.',
        'Sorry, you can only upload one file here.' => 'Sajnáljuk, itt csak egy fájlt tud feltölteni.',
        'Sorry, you can only upload %s files.' => 'Sajnáljuk, csak %s fájlt tud feltölteni.',
        'Please only select at most %s files for upload.' => 'Legfeljebb csak %s fájlt válasszon a feltöltéshez.',
        'The following files are not allowed to be uploaded: %s' => 'A következő fájlok nem engedélyezettek a feltöltéshez: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'A következő fájlok túllépik a legnagyobb megengedett fájlonkénti %s méretet, és nem lettek feltöltve: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'A következő fájlok már fel lettek töltve, és nem lesznek újra feltöltve: %s',
        'No space left for the following files: %s' => 'Nincs több hely a következő fájloknak: %s',
        'Available space %s of %s.' => 'Elérhető hely: %s/%s.',
        'Upload information' => 'Feltöltési információk',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Ismeretlen hiba történt a melléklet törlése során. Kérjük, próbálja meg újra. Ha a hiba továbbra is fennáll, akkor vegye fel a kapcsolatot a rendszergazdával.',

        # JS File: Core.Language.UnitTest
        'yes' => 'igen',
        'no' => 'nem',
        'This is %s' => 'Ez egy %s',
        'Complex %s with %s arguments' => 'Összetett %s %s argumentummal',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'Nem érhető el adat.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Csoportosított',
        'Stacked' => 'Halmozott',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Folyam',
        'Expanded' => 'Kifeszített',

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
