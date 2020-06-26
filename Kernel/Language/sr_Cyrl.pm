# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2010 Milorad Jovanovic <j.milorad at gmail.com>
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
package Kernel::Language::sr_Cyrl;

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
    $Self->{Completeness}        = 0.929047619047619;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Управљање ACL',
        'Actions' => 'Акције',
        'Create New ACL' => 'Креирај нову ACL листу',
        'Deploy ACLs' => 'Распореди ACL листе',
        'Export ACLs' => 'Извези ACL листе',
        'Filter for ACLs' => 'Филтер за ACL',
        'Just start typing to filter...' => 'Почните са куцањем за филтер...',
        'Configuration Import' => 'Увоз конфигурације',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Овде можете послати конфигурациону датотеку за увоз ACL листа у ваш систем. Датотека мора бити у .yml формату ако се извози од стране ACL едитор модула.',
        'This field is required.' => 'Ово поље је обавезно.',
        'Overwrite existing ACLs?' => 'Препиши преко постојећих ACL листа?',
        'Upload ACL configuration' => 'Отпреми ACL конфигурацију',
        'Import ACL configuration(s)' => 'Увези ACL конфигурацију',
        'Description' => 'Опис',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Да бисте креирали нову ACL можете или увести ACL листе које су извезене из другог система или направити комплетно нову.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Промене на ACL листама овде само утичу на понашање система, уколико накнадно употребите све ACL податке.',
        'ACLs' => 'ACL листе',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Напомена: Ова табела представља редослед извршавања у ACL листама. Ако је потребно да промените редослед којим се извршавају ACL листе, молимо промените имена тих ACL листа.',
        'ACL name' => 'Назив ACL',
        'Comment' => 'Коментар',
        'Validity' => 'Важност',
        'Export' => 'Извоз',
        'Copy' => 'Копија',
        'No data found.' => 'Ништа није пронађено.',
        'No matches found.' => 'Ништа није пронађено.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Уреди ACL %s',
        'Edit ACL' => 'Уреди ACL',
        'Go to overview' => 'Иди на преглед',
        'Delete ACL' => 'Обриши ACL',
        'Delete Invalid ACL' => 'Обриши неважећу ACL',
        'Match settings' => 'Усклади подешавања',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Подесите усклађене критеријуме за ову ACL листу. Користите Properties тако да одговара постојећем приказу екрана или PropertiesDatabase да би одговарао атрибутима постојећег тикета који су у бази података.',
        'Change settings' => 'Промени подешавања',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Подесите оно што желите да мењате ако се критеријуми слажу. Имајте на уму да је \'Possible\' бела листа, \'PossibleNot\' црна листа.',
        'Check the official %sdocumentation%s.' => 'Прочитајте званичну %sдокументацију%s.',
        'Show or hide the content' => 'Покажи или сакриј садржај',
        'Edit ACL Information' => 'Уреди информације о ACL',
        'Name' => 'Назив',
        'Stop after match' => 'Заустави после поклапања',
        'Edit ACL Structure' => 'Уреди структуру ACL',
        'Save ACL' => 'Сачувај ACL',
        'Save' => 'Сачувај',
        'or' => 'или',
        'Save and finish' => 'Сачувај и заврши',
        'Cancel' => 'Откажи',
        'Do you really want to delete this ACL?' => 'Да ли стварно желите да обришете ову ACL листу?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Креирајте нову ACL листу подношењем обрасца са подацима. Након креирања ACL листе, бићете у могућности да додате конфигурационе ставке у моду измене.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Управљање календарима',
        'Add Calendar' => 'Додај календар',
        'Edit Calendar' => 'Измени календар',
        'Calendar Overview' => 'Преглед календара',
        'Add new Calendar' => 'Додај нови календар',
        'Import Appointments' => 'Увези термине',
        'Calendar Import' => 'Увоз календара',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Овде можете учитати конфигурациону датотеку за увоз календара у ваш систем. Датотека мора бити у .yml формату извезена од стране модула за управљање календарима.',
        'Overwrite existing entities' => 'Напиши преко постојећих ентитета',
        'Upload calendar configuration' => 'Учитај конфигурацију календара',
        'Import Calendar' => 'Увези календар',
        'Filter for Calendars' => 'Филтер за календаре',
        'Filter for calendars' => 'Филтер за календаре',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'У зависности од поља групе, систем ће дозволити приступ календару оператерима према њиховом нивоу приступа.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'RO: оператери могу прегледати и експортовати све термине у календару.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Премести у: оператери могу модификовати термине у календару, али без промене ком календару припадају.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Креирање: оператери могу креирати и брисати термине у календару.',
        'Read/write: users can manage the calendar itself.' => 'RW: оператери могу администрирати и сам календар.',
        'Group' => 'Група',
        'Changed' => 'Измењено',
        'Created' => 'Креирано',
        'Download' => 'Преузимање',
        'URL' => 'Адреса',
        'Export calendar' => 'Извези календар',
        'Download calendar' => 'Преузми календар',
        'Copy public calendar URL' => 'Ископирај јавну адресу календара (URL)',
        'Calendar' => 'Календар',
        'Calendar name' => 'Назив календара',
        'Calendar with same name already exists.' => 'Календар са истим називом већ постоји.',
        'Color' => 'Боја',
        'Permission group' => 'Група приступа',
        'Ticket Appointments' => 'Термини тикета',
        'Rule' => 'Правило',
        'Remove this entry' => 'Уклони овај унос',
        'Remove' => 'Уклони',
        'Start date' => 'Датум почетка',
        'End date' => 'Датум краја',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Користећи опције испод изаберите за које тикете ће термини бити аутоматски креирани.',
        'Queues' => 'Редови',
        'Please select a valid queue.' => 'Молимо да одаберете важећи ред.',
        'Search attributes' => 'Атрибути претраге',
        'Add entry' => 'Додај унос',
        'Add' => 'Додати',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Дефинишите правила за креирање аутоматских термина у овом календару на основу тикета.',
        'Add Rule' => 'Додај правило',
        'Submit' => 'Пошаљи',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Увоз термина',
        'Go back' => 'Иди назад',
        'Uploaded file must be in valid iCal format (.ics).' => 'Послати фајл мора бити у исправном iCal формату (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Уколико жељени календар није излистан, проверите да ли имате ниво приступа \'креирање\' за групу календара.',
        'Upload' => 'Отпремање',
        'Update existing appointments?' => 'Освежи постојеће термине?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Сви постојећи термини у календару са истим UniqueID пољем ће бити пребрисани.',
        'Upload calendar' => 'Пошаљи календар',
        'Import appointments' => 'Увези термине',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Управљање обавештењима о терминима',
        'Add Notification' => 'Додај Обавештење',
        'Edit Notification' => 'Уреди обавештење',
        'Export Notifications' => 'Обавештења о извозу',
        'Filter for Notifications' => 'Филтер за обавештења',
        'Filter for notifications' => 'Филтер за обавештења',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Овде можете послати конфигурациону датотеку за увоз обавештења о термину у ваш систем. Датотека мора бити у истом .yml формату који је могуће добити извозом у екрану управљања обавештењима о терминима.',
        'Overwrite existing notifications?' => 'Препиши преко постојећих обавештења?',
        'Upload Notification configuration' => 'Отпреми конфигурацију обавештавања',
        'Import Notification configuration' => 'Увези конфигурацију обавештења',
        'List' => 'Листа',
        'Delete' => 'Избрисати',
        'Delete this notification' => 'Обриши ово обавештење',
        'Show in agent preferences' => 'Приказано у оператерским поставкама',
        'Agent preferences tooltip' => 'Порука за оператерска подешавања',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ова порука ће бити приказана на екрану оператерских подешавања као испомоћ.',
        'Toggle this widget' => 'Преклопи овај додатак',
        'Events' => 'Догађаји',
        'Event' => 'Догађај',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Овде можете изабрати који догађаји ће покренути обавештавање. Додатни филтер за термине може бити примењен ради слања само за термине по одређеном критеријуму.',
        'Appointment Filter' => 'Филтер термина',
        'Type' => 'Тип',
        'Title' => 'Наслов',
        'Location' => 'Локација',
        'Team' => 'Тим',
        'Resource' => 'Ресурс',
        'Recipients' => 'Примаоци',
        'Send to' => 'Пошаљи за',
        'Send to these agents' => 'Пошаљи овим оператерима',
        'Send to all group members (agents only)' => 'Пошаљи свим члановима групе (само оператерима)',
        'Send to all role members' => 'Пошаљи свим припадницима улоге',
        'Send on out of office' => 'Пошаљи и кад је ван канцеларије',
        'Also send if the user is currently out of office.' => 'Такође пошаљи и када је корисник ван канцеларије.',
        'Once per day' => 'Једном дневно',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Обавести корисника само једном дневно о појединачном термину коришћењем изабраног транспорта.',
        'Notification Methods' => 'Методе обавештавања',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Ово су могуће методе које се могу користити за слање обавештења сваком примаоцу. Молимо вас да изаберете бар једну методу од понуђених.',
        'Enable this notification method' => 'Активирај овај метод обавештавања',
        'Transport' => 'Транспорт',
        'At least one method is needed per notification.' => 'Неопходан је најмање један метод по обавештењу.',
        'Active by default in agent preferences' => 'Подразумевано активно у оператерским поставкама',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Ово је подразумевана вредност за придружене оператере примаоце који за ово обавештење у својим поставкама нису још направили избор. Ако је бокс активиран, обавештење ће бити послато таквим оператерима.',
        'This feature is currently not available.' => 'Ово својство тренутно није доступно.',
        'Upgrade to %s' => 'Унапреди на %s',
        'Please activate this transport in order to use it.' => 'Молимо активирајте овај транспорт пре коришћења.',
        'No data found' => 'Ништа није пронађено',
        'No notification method found.' => 'Није пронађена метода обавештавања.',
        'Notification Text' => 'Текст обавештења',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Овај језик није присутан или укључен на систему. Ово обавештење може бити избрисано уколико више није неопходно.',
        'Remove Notification Language' => 'Уклони језик обавештења',
        'Subject' => 'Предмет',
        'Text' => 'Текст',
        'Message body' => 'Садржај поруке',
        'Add new notification language' => 'Уклони нови језик обавештења',
        'Save Changes' => 'Сачувај промене',
        'Tag Reference' => 'Референца ознаке',
        'Notifications are sent to an agent.' => 'Обавештење ће бити послато оператеру.',
        'You can use the following tags' => 'Можете користити следеће ознаке',
        'To get the first 20 character of the appointment title.' => 'Да видите првих 20 карактера наслова термина.',
        'To get the appointment attribute' => 'Да видите атрибуте термина',
        ' e. g.' => ' нпр.',
        'To get the calendar attribute' => 'Да видите атрибуте календара',
        'Attributes of the recipient user for the notification' => 'Атрибути корисника примаоца за обавештење',
        'Config options' => 'Конфигурационе опције',
        'Example notification' => 'Пример обавештења',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Имејл адреса додатног примаоца',
        'This field must have less then 200 characters.' => 'Ово поље не сме бити дуже од 200 карактера.',
        'Article visible for customer' => 'Чланак видљив клијентима',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Чланак је креиран и обавештење послато клијенту или на другу имејл адресу.',
        'Email template' => 'Имејл шаблон',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Употребите овај шаблон за генерисање комплетног имејла (само за HTML имејлове).',
        'Enable email security' => 'Активирајте безбедност имејла',
        'Email security level' => 'Ниво безбедности имејла',
        'If signing key/certificate is missing' => 'Ако потписивање кључа/сертификата недостаје',
        'If encryption key/certificate is missing' => 'Ако кључа/сертификат за шифрирање недостаје',

        # Template: AdminAttachment
        'Attachment Management' => 'Управљање прилозима',
        'Add Attachment' => 'Додај прилог',
        'Edit Attachment' => 'Уреди прилог',
        'Filter for Attachments' => 'Филтер за прилоге',
        'Filter for attachments' => 'Филтер за прилоге',
        'Filename' => 'Назив датотеке',
        'Download file' => 'Преузми датотеку',
        'Delete this attachment' => 'Обриши овај прилог',
        'Do you really want to delete this attachment?' => 'Да ли стварно желите да обришете овај прилог?',
        'Attachment' => 'Прилог',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Управљање аутоматским одговорима',
        'Add Auto Response' => 'Додај Аутоматски Одговор',
        'Edit Auto Response' => 'Уреди Аутоматски Одговор',
        'Filter for Auto Responses' => 'Филтер за аутоматске одговоре',
        'Filter for auto responses' => 'Филтер за аутоматске одговоре',
        'Response' => 'Одговор',
        'Auto response from' => 'Аутоматски одговор од',
        'Reference' => 'Референца',
        'To get the first 20 character of the subject.' => 'Да видите првих 20 слова предмета.',
        'To get the first 5 lines of the email.' => 'Да видите првих 5 линија имејла.',
        'To get the name of the ticket\'s customer user (if given).' => 'Да прибавите назив клијента корисника за тикет (ако је дат).',
        'To get the article attribute' => 'Да видите атрибуте чланка',
        'Options of the current customer user data' => 'Опције података о актуелном клијенту кориснику',
        'Ticket owner options' => 'Опције власника тикета',
        'Ticket responsible options' => 'Опције одговорног за тикет',
        'Options of the current user who requested this action' => 'Опције актуелног корисника који је тражио ову акцију',
        'Options of the ticket data' => 'Опције података о тикету',
        'Options of ticket dynamic fields internal key values' => 'Опције за вредности интерних кључева динамичких поља тикета',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Опције за приказане вредности динамичких поља тикета, корисно за поља Dropdown и Multiselect',
        'Example response' => 'Пример одговора',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Управљање сервисима у облаку',
        'Support Data Collector' => 'Сакупљач података подршке',
        'Support data collector' => 'Сакупљач података подршке',
        'Hint' => 'Савет',
        'Currently support data is only shown in this system.' => 'Актуелни подаци подршке се приказују само на овом систему.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Конфигурација',
        'Send support data' => 'Пошаљи податке за подршку',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Ажурирање',
        'System Registration' => 'Регистрација система',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Региструј овај систем',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Системска регистрације је деактивирана за ваш систем. Молимо да проверите вашу конфигурацију.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Напомињемо да коришћење OTOBO сервиса у облаку захтевају да систем буде регистрован.',
        'Register this system' => 'Региструј овај систем',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Овде можете подесити да доступни сервиси у облаку користе сигурну комуникацију преко %s.',
        'Available Cloud Services' => 'Расположиви сервиси у облаку',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Комуникациони лог',
        'Time Range' => 'Временски опсег',
        'Show only communication logs created in specific time range.' =>
            'Прикажи само комуникационе логове креиране у одређеном временском периоду.',
        'Filter for Communications' => 'Филтер за комуникације',
        'Filter for communications' => 'Филтер за комуникације',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'У овом екрану можете прегледати све долазне и одлазне комуникације.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Можете изменити редослед сортирања колона кликом на наслове колона.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Уколико кликнете на појединачне ставке, бићете редиректовани на екран детаља у вези поруке.',
        'Status for: %s' => 'Статус за: %s',
        'Failing accounts' => 'Налози са грешкама',
        'Some account problems' => 'Пар проблема са налозима',
        'No account problems' => 'Без проблема са налозима',
        'No account activity' => 'Без активности налога',
        'Number of accounts with problems: %s' => 'Број налога са проблемима: %s',
        'Number of accounts with warnings: %s' => 'Број налога са упозорењима: %s',
        'Failing communications' => 'Неуспеле комуникације',
        'No communication problems' => 'Без проблема са комуникацијама',
        'No communication logs' => 'Без комуникационих логова',
        'Number of reported problems: %s' => 'Број пријављених проблема: %s',
        'Open communications' => 'Отворене комуникације',
        'No active communications' => 'Без активних комуникација',
        'Number of open communications: %s' => 'Број отворених комуникација: %s',
        'Average processing time' => 'Просечно време обраде',
        'List of communications (%s)' => 'Листа комуникација (%s)',
        'Settings' => 'Подешавања',
        'Entries per page' => 'Уноса по страни',
        'No communications found.' => 'Нису пронађене комуникације.',
        '%s s' => '%s с',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Статус налога',
        'Back to overview' => 'Иди назад на преглед',
        'Filter for Accounts' => 'Филтер за налоге',
        'Filter for accounts' => 'Филтер за налоге',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Можете изменити редослед сортирања колона кликом на наслове колона.',
        'Account status for: %s' => 'Статус налога за: %s',
        'Status' => 'Статус',
        'Account' => 'Налог',
        'Edit' => 'Уредити',
        'No accounts found.' => 'Нису пронађени налози.',
        'Communication Log Details (%s)' => 'Детаљи комуникационог лога (%s)',
        'Direction' => 'Смер',
        'Start Time' => 'Време почетка',
        'End Time' => 'Време завршетка',
        'No communication log entries found.' => 'Нису пронађене ставке комуникационог лога.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Трајање',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Приоритет',
        'Module' => 'Модул',
        'Information' => 'Информација',
        'No log entries found.' => 'Нису пронађене ставке лога.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Детаљни приказ за комуникацију %s започету у %s',
        'Filter for Log Entries' => 'Филтер за лог ставке',
        'Filter for log entries' => 'Филтер за лог ставке',
        'Show only entries with specific priority and higher:' => 'Прикажи само ставке са одговарајућим приоритетом и више:',
        'Communication Log Overview (%s)' => 'Преглед комуникационих логова (%s)',
        'No communication objects found.' => 'Нису пронађени комуникациони објекти.',
        'Communication Log Details' => 'Детаљи комуникационог лога',
        'Please select an entry from the list.' => 'Молимо изаберите ставку из листе.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Контакт са подацима',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Врати се на резултате претраге',
        'Select' => 'Изабери',
        'Search' => 'Тражи',
        'Wildcards like \'*\' are allowed.' => 'Џокерски знаци као \'*\' су дозвољени.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Важећи',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Управљање клијентима',
        'Add Customer' => 'Додај клијента',
        'Edit Customer' => 'Измени клијента',
        'List (only %s shown - more available)' => 'Листа (само %s је приказано - расположиво више)',
        'total' => 'укупно',
        'Please enter a search term to look for customers.' => 'Молимо унесите појам претраге за проналажење клијената.',
        'Customer ID' => 'ID клијента',
        'Please note' => 'Напомињемо',
        'This customer backend is read only!' => 'Овај извор клијената се може само прегледати.',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Управљање релацијама клијент-група',
        'Notice' => 'Напомена',
        'This feature is disabled!' => 'Ова функција је искључена!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Употребите ову функцију ако желите да дефинишете групне дозволе за клијенте.',
        'Enable it here!' => 'Активирајте је овде!',
        'Edit Customer Default Groups' => 'Уреди подразумеване групе за клијента',
        'These groups are automatically assigned to all customers.' => 'Ове групе су аутоматски додељене свим клијентима.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Можете управљати овим групама преко конфигурационог подешавања CustomerGroupCompanyAlwaysGroups.',
        'Filter for Groups' => 'Филтер за групе',
        'Select the customer:group permissions.' => 'Изабери клијент:група дозволе.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ако ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни клијенту).',
        'Search Results' => 'Резултат претраге',
        'Customers' => 'Клијенти',
        'Groups' => 'Групе',
        'Change Group Relations for Customer' => 'Промени везе са групама за клијента',
        'Change Customer Relations for Group' => 'Промени везе са клијентима за групу',
        'Toggle %s Permission for all' => 'Промени %s дозволе за све',
        'Toggle %s permission for %s' => 'Промени %s дозволе за %s',
        'Customer Default Groups:' => 'Подразумеване групе за клијента:',
        'No changes can be made to these groups.' => 'На овим групама промене нису могуће.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Приступ ограничен само на читање за тикете у овим групама/редовима.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Приступ без ограничења за тикете у овим групама/редовима.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Управљање клијентима клијентима',
        'Add Customer User' => 'Додај клијента корисника',
        'Edit Customer User' => 'Уреди клијента корисника',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Клијент клијент треба да има клијентски историјат и да се пријави преко клијентског панела.',
        'List (%s total)' => 'Листа (%s укупно)',
        'Username' => 'Корисничко име',
        'Email' => 'Имејл',
        'Last Login' => 'Последња пријава',
        'Login as' => 'Пријави се као',
        'Switch to customer' => 'Пређи на клијента',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Овај извор клијената се може само прегледати, али клијентска подешавања се могу изменити!',
        'This field is required and needs to be a valid email address.' =>
            'Ово је обавезно поље и мора да буде исправна имејл адреса.',
        'This email address is not allowed due to the system configuration.' =>
            'Ова имејл адреса није дозвољена због системске конфигурације.',
        'This email address failed MX check.' => 'Ова имејл адреса не задовољава MX проверу.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS проблем, молимо проверите конфигурацију и грешке у логу.',
        'The syntax of this email address is incorrect.' => 'Синтакса ове имејл адресе је неисправна.',
        'This CustomerID is invalid.' => 'Овај ID клијента је неисправан.',
        'Effective Permissions for Customer User' => 'Ефективне дозволе за клијент корисника',
        'Group Permissions' => 'Дозволе за групу',
        'This customer user has no group permissions.' => 'Овај клијент корисник нема дозволе за групе.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Табела изнад приказује ефективне дозволе за групе клијент корисника. Матрица узима у обзир све наслеђене дозволе (нпр. путем клијент група). Напомена: табела не узима у обзир измене на овој форми без слања исте.',
        'Customer Access' => 'Приступ клијенту',
        'Customer' => 'Клијент',
        'This customer user has no customer access.' => 'Овај клијент корисник нема приступ клијенту.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Табела изнад приказује додељени приступ клијенту за клијент корисника према контексту дозволе. Матрица узима у обзир сав наслеђени приступ (нпр. путем клијент група). Напомена: табела не узима у обзир измене на овој форми без слања исте.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Управљање релацијама клијент корисник-клијент',
        'Select the customer user:customer relations.' => 'Одаберите клијент корисник:клијент релације.',
        'Customer Users' => 'Клијенти корисници',
        'Change Customer Relations for Customer User' => 'Промени релације са клијентима за клијент корисника',
        'Change Customer User Relations for Customer' => 'Промени релације са клијент корисницима за клијента',
        'Toggle active state for all' => 'Промени активно стање за све',
        'Active' => 'Активно',
        'Toggle active state for %s' => 'Промени активно стање за %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Управљање релацијама клијент корисник-група',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Употребите ову функцију ако желите да дефинишете групне дозволе за клијент кориснике.',
        'Edit Customer User Default Groups' => 'Уреди подразумеване групе за клијент кориснике',
        'These groups are automatically assigned to all customer users.' =>
            'Ове групе су аутоматски додељене свим клијент корисницима.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Можете управљати овим групама преко конфигурационих подешавања CustomerGroupAlwaysGroups.',
        'Filter for groups' => 'Филтер за групе',
        'Select the customer user - group permissions.' => 'Изабери клијент корисник:група дозволе.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Ако ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни клијент кориснику).',
        'Customer User Default Groups:' => 'Подразумеване групе за клијент корисника:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Управљање релацијама клијент корисници-сервиси',
        'Edit default services' => 'Уреди подразумеване услуге',
        'Filter for Services' => 'Филтер за сервисе',
        'Filter for services' => 'Филтер за сервисе',
        'Services' => 'Услуге',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Управљање динамичким пољима',
        'Add new field for object' => 'Додај ново поље објекту',
        'Filter for Dynamic Fields' => 'Филтер за динамичка поља',
        'Filter for dynamic fields' => 'Филтер за динамичка поља',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'База података',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Користите екстерне базе података као извор података за ово динамичко поље.',
        'Web service' => 'Веб сервис',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Екстерни веб сервиси се могу конфигурисати као извор података за ово динамичко поље.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Ова функција вам омогућава да додате (вишеструке) контакте са подацима тикетима.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'За додавање новог поља изаберите тип поља из једне од листа објеката. Објект дефинише границе поља и после креирања поља се не може мењати.',
        'Dynamic Fields List' => 'Листа динамичких поља',
        'Dynamic fields per page' => 'Број динамичких поља по страни',
        'Label' => 'Ознака',
        'Order' => 'Сортирање',
        'Object' => 'Објекат',
        'Delete this field' => 'Обриши ово поље',

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
        'Dynamic Fields' => 'Динамичка поља',
        'Go back to overview' => 'Иди назад на преглед',
        'General' => 'Опште',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ово поље је обавезно и може садржати само од слова и бројеве.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Мора бити јединствено и прихвата само слова и бројеве.',
        'Changing this value will require manual changes in the system.' =>
            'Измена овог поља ће захтевати ручне промене у систему.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ово је назив који ће се приказивати на екранима где је поље активно.',
        'Field order' => 'Редослед поља',
        'This field is required and must be numeric.' => 'Ово поље је обавезно и мора бити нумеричко.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ово је редослед по ком ће поља бити приказана на екранима где су активна.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Није могуће обележити ову ставку као неважећу, сва подешавања морају бити прво измењена.',
        'Field type' => 'Тип поља',
        'Object type' => 'Тип објекта',
        'Internal field' => 'Интерно поље',
        'This field is protected and can\'t be deleted.' => 'Ово поље је заштићено и не може бити обрисано.',
        'This dynamic field is used in the following config settings:' =>
            'Ово динамичко поље је употребљено у следећим поставкама:',
        'Field Settings' => 'Подешавање поља',
        'Default value' => 'Подразумевана вредност',
        'This is the default value for this field.' => 'Ово је подразумевана вредност за ово поље.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Кључ',
        'Value' => 'Вредност',
        'Remove value' => 'Уклони вредност',
        'Add Field' => '',
        'Add value' => 'Додај вредност',
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
        'Translatable values' => 'Преводљиве вредности',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ако активирате ову опцију вредности ће бити преведене на изабрани језик.',
        'Note' => 'Напомена',
        'You need to add the translations manually into the language translation files.' =>
            'Ове преводе морате ручно додати у датотеке превода.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Могуће вредности',
        'Datatype' => '',
        'Filter' => 'Филтер',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Покажи везу',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Овде можете да унесете опциону HTTP везу за вредност поља у екранима прегледа.',
        'Example' => 'Пример',
        'Link for preview' => 'Веза за преглед',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Ако је попуњено, овај URL ће се користити за преглед који се приказује када је показивач изнад везе у детаљима тикета. Узмите у обзир, да би ово радило, нормално URL поље изнад, мора такође да буде попуњено.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Порт',
        'Table / View' => '',
        'User' => 'Корисник',
        'Password' => 'Лозинка',
        'Identifier' => 'Идентификатор',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Вишеструки избор',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Подразумевана разлика датума',
        'This field must be numeric.' => 'Ово поље мора бити нумеричко.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Разлика (у секундама) од САДА, за израчунавање подразумеване вредности поља (нпр. 3600 или -60).',
        'Define years period' => 'Дефиниши период у годинама',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Активирајте ову опцију ради дефинисања фиксног опсега година (у будућност и прошлост) за приказ при избору година у пољу.',
        'Years in the past' => 'Године у прошлости',
        'Years in the past to display (default: 5 years).' => 'Године у прошлости за приказ (подразумевано је 5 година).',
        'Years in the future' => 'Године у будућности',
        'Years in the future to display (default: 5 years).' => 'Године у будућности за приказ (подразумевано је 5 година).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Уколико специјални карактери (&, @, :, /, итд) не треба да буду енкодирани, користите \'url\' филтер уместо \'uri\'.',
        'Restrict entering of dates' => 'Ограничи унос датума',
        'Here you can restrict the entering of dates of tickets.' => 'Овде можете ограничити унос датума за тикете.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Додај Вредност',
        'Add empty value' => 'Додај без вредности',
        'Activate this option to create an empty selectable value.' => 'Активирај ову опцију за креирање избора без вредности.',
        'Tree View' => 'Приказ у облику стабла',
        'Activate this option to display values as a tree.' => 'Активирај ову опцију за приказ вредности у облику стабла.',

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
        'Fields' => 'Поља',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Преглед',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Мењање редоследа елемената унутар листе је, такође, могуће преврачењем елемената и пуштањем.',
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
        'Reset' => 'Поништи',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Број редова',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Унеси висину (у линијама) за ово поље у моду обраде.',
        'Number of cols' => 'Број колона',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Унеси ширину (у знаковима) за ово поље у моду уређивања.',
        'Check RegEx' => 'Провери регуларне изразе',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Овде можете да дефинишете регуларни израз за проверу вредности. Израз ће бити извршен са модификаторима за xms.',
        'RegEx' => 'Регуларни израз',
        'Invalid RegEx' => 'Неважећи регуларни израз',
        'Error Message' => 'Порука о грешци',
        'Add RegEx' => 'Додај регуларни израз',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Шаблон',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Величина',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Ово поље је обавезно.',
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
        'Admin Message' => 'Административна порука',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Са овим модулом, администратори могу слати поруке оператерима, групама или припадницима улоге.',
        'Create Administrative Message' => 'Креирај административну поруку',
        'Your message was sent to' => 'Ваша порука је послата',
        'From' => 'Од',
        'Send message to users' => 'Пошаљи поруку корисницима',
        'Send message to group members' => 'Пошаљи поруку члановима групе',
        'Group members need to have permission' => 'Чланови групе треба да имају дозволу',
        'Send message to role members' => 'Пошаљи поруку припадницима улоге',
        'Also send to customers in groups' => 'Такође пошаљи клијентима у групама',
        'Body' => 'Садржај',
        'Send' => 'Шаљи',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Управљање пословима генеричког оператера',
        'Edit Job' => 'Уреди посао',
        'Add Job' => 'Додај посао',
        'Run Job' => 'Покрени посао',
        'Filter for Jobs' => 'Филтер за послове',
        'Filter for jobs' => 'Филтер за послове',
        'Last run' => 'Последње покретање',
        'Run Now!' => 'Покрени сад!',
        'Delete this task' => 'Обриши овај посао',
        'Run this task' => 'Покрени овај посао',
        'Job Settings' => 'Подешавање посла',
        'Job name' => 'Назив посла',
        'The name you entered already exists.' => 'Назив које сте унели већ постоји.',
        'Automatic Execution (Multiple Tickets)' => 'Аутоматско извршење (вишеструки тикети)',
        'Execution Schedule' => 'Распоред извршења',
        'Schedule minutes' => 'Планирано минута',
        'Schedule hours' => 'Планирано сати',
        'Schedule days' => 'Планирано дана',
        'Automatic execution values are in the system timezone.' => 'Времена аутоматског извршавања су у системској временској зони.',
        'Currently this generic agent job will not run automatically.' =>
            'Тренутно овај посао генерички оператера неће бити извршен аутоматски.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Да бисте омогућили аутоматско извршавање изаберите бар једну вредност од минута, сати и дана!',
        'Event Based Execution (Single Ticket)' => 'Извршење засновано на догађају (појединачни тикет)',
        'Event Triggers' => 'Окидачи догађаја',
        'List of all configured events' => 'Листа свих конфигурисаних догађаја',
        'Delete this event' => 'Обриши овај догађај',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Додатно или алтернативно за периодично извршење, можете дефинисати догађаје тикета који ће покренути овај посао.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Уколико је догађај тикета отказао, биће примењен тикет филтер да потврди да ли тикет одговара. Само тада ће се посао на тикету покренути.',
        'Do you really want to delete this event trigger?' => 'Да ли стварно желите да обришете овај окидач догађаја?',
        'Add Event Trigger' => 'Додај окидач догађаја',
        'To add a new event select the event object and event name' => 'За додавање новог догађаја изаберите објекат и назив догађаја',
        'Select Tickets' => 'Изабери тикете',
        '(e. g. 10*5155 or 105658*)' => 'нпр. 10*5144 или 105658*',
        '(e. g. 234321)' => 'нпр. 234321',
        'Customer user ID' => 'ID клијента корисника',
        '(e. g. U5150)' => '(нпр. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Текстуална претрага у чланку (нпр. "Mar*in" или "Baue*").',
        'To' => 'За',
        'Cc' => 'Cc',
        'Service' => 'Услуга',
        'Service Level Agreement' => 'Споразум о нивоу услуге',
        'Queue' => 'Ред',
        'State' => 'Стање',
        'Agent' => 'Оператер',
        'Owner' => 'Власник',
        'Responsible' => 'Одговоран',
        'Ticket lock' => 'Тикет закључан',
        'Dynamic fields' => 'Динамичка поља',
        'Add dynamic field' => 'Додај динамичко поље',
        'Create times' => 'Времена отварања',
        'No create time settings.' => 'Нема подешавања времена отварања.',
        'Ticket created' => 'Тикет отворен',
        'Ticket created between' => 'Тикет отворен између',
        'and' => 'и',
        'Last changed times' => 'Време задње промене',
        'No last changed time settings.' => 'Није подешено време последње промене.',
        'Ticket last changed' => 'Време задње промене тикета',
        'Ticket last changed between' => 'Задња промена тикета између',
        'Change times' => 'Промена времена',
        'No change time settings.' => 'Нема промене времена.',
        'Ticket changed' => 'Промењен тикет',
        'Ticket changed between' => 'Тикет промењен између',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Времена затварања',
        'No close time settings.' => 'Није подешено време затварања.',
        'Ticket closed' => 'Тикет затворен',
        'Ticket closed between' => 'Тикет затворен између',
        'Pending times' => 'Времена чекања',
        'No pending time settings.' => 'Нема подешавања времена чекања.',
        'Ticket pending time reached' => 'Достигнуто време чекања тикета',
        'Ticket pending time reached between' => 'Време чекања тикета достигнуто између',
        'Escalation times' => 'Времена ескалације',
        'No escalation time settings.' => 'Нема подешавања времена ескалације.',
        'Ticket escalation time reached' => 'Достигнуто време ескалације тикета',
        'Ticket escalation time reached between' => 'Време ескалације тикета достигнуто између',
        'Escalation - first response time' => 'Ескалација - време првог одзива',
        'Ticket first response time reached' => 'Достигнуто време првог одзива на тикет',
        'Ticket first response time reached between' => 'Време првог одзива на тикет достигнуто између',
        'Escalation - update time' => 'Ескалација - време ажурирања',
        'Ticket update time reached' => 'Достигнуто време ажурирања тикета',
        'Ticket update time reached between' => 'Време ажурирања тикета достигнуто између',
        'Escalation - solution time' => 'Ескалација - време решавања',
        'Ticket solution time reached' => 'Достигнуто време решавања тикета',
        'Ticket solution time reached between' => 'Време решавања тикета достигнуто између',
        'Archive search option' => 'Опције претраге архива',
        'Update/Add Ticket Attributes' => 'Ажурирај/Додај атрибуте тикета',
        'Set new service' => 'Постави нове услуге',
        'Set new Service Level Agreement' => 'Постави нови Споразум о нивоу услуга',
        'Set new priority' => 'Постави нови приоритет',
        'Set new queue' => 'Постави нови ред',
        'Set new state' => 'Постави ново стање',
        'Pending date' => 'Чекање до',
        'Set new agent' => 'Постави новог оператера',
        'new owner' => 'нови власник',
        'new responsible' => 'нови одговорни',
        'Set new ticket lock' => 'Постави ново закључавање тикета',
        'New customer user ID' => 'Нови ID клијент корисника',
        'New customer ID' => 'Нови ID клијента',
        'New title' => 'Нови наслов',
        'New type' => 'Нови тип',
        'Archive selected tickets' => 'Архивирај изабране тикете',
        'Add Note' => 'Додај напомену',
        'Visible for customer' => 'Видљиво клијенту',
        'Time units' => 'Временске јединице',
        'Execute Ticket Commands' => 'Изврши команде тикета',
        'Send agent/customer notifications on changes' => 'Пошаљи обавештења оператеру/клијенту при променама',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ова наредба ће бити извршена. ARG[0] је број тикета, а ARG[1] ID тикета.',
        'Delete tickets' => 'Обриши тикете',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'УПОЗОРЕЊЕ: Сви обухваћени тикети ће бити неповратно уклоњени из базе!',
        'Execute Custom Module' => 'Покрени извршавање посебног модула',
        'Param %s key' => 'Кључ параметра %s',
        'Param %s value' => 'Вредност параметра %s',
        'Results' => 'Резултати',
        '%s Tickets affected! What do you want to do?' => '%s тикета је обухваћено. Шта желите да урадите?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'УПОЗОРЕЊЕ: Употребили сте опцију за брисање. Сви обрисани тикети ће бити изгубљени!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Упозорење: Обухваћено је %s тикета али само %s може бити измењено током једног извршавања посла!',
        'Affected Tickets' => 'Обухваћени тикети',
        'Age' => 'Старост',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Управљање оштим интерфејсом веб сервиса',
        'Web Service Management' => 'Управљање веб сервисима',
        'Debugger' => 'Програм за отклањање грешака',
        'Go back to web service' => 'Иди назад на веб сервис',
        'Clear' => 'Очисти',
        'Do you really want to clear the debug log of this web service?' =>
            'Да ли стварно желите да очистите отклањање грешака у логу овог веб сервиса?',
        'Request List' => 'Листа захтева',
        'Time' => 'Време',
        'Communication ID' => 'ID комуникације',
        'Remote IP' => 'Удаљена IP адреса',
        'Loading' => 'Учитавање',
        'Select a single request to see its details.' => 'Изаберите један захтев да би видели његове детаље.',
        'Filter by type' => 'Филтер по типу',
        'Filter from' => 'Филтер од',
        'Filter to' => 'Филтер до',
        'Filter by remote IP' => 'Филтер по удаљеној IP адреси',
        'Limit' => 'Ограничење',
        'Refresh' => 'Освежавање',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Додај обраду грешке',
        'Edit ErrorHandling' => 'Уреди обраду грешке',
        'Do you really want to delete this error handling module?' => 'Да ли стварно желите да обришете овај модул за обраду грешке?',
        'All configuration data will be lost.' => 'Сви конфигурациони подаци ће бити изгубљени.',
        'General options' => 'Општа подешавања',
        'The name can be used to distinguish different error handling configurations.' =>
            'Назив се може користити за прављење разлике између појединачних конфигурација за обраду грешке.',
        'Please provide a unique name for this web service.' => 'Молимо да обезбедите јединствени назив за овај веб сервис.',
        'Error handling module backend' => 'Модул за обраду грешке',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Овај модул за отклањање грешака ће бити позван интерно да обради грешку.',
        'Processing options' => 'Подешавања обраде',
        'Configure filters to control error handling module execution.' =>
            'Конфигуришите филтере за контролу модула за обраду грешке.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Само захтеви који одговарају подешеним филтерима (уколико их има) ће резултирати у позивању модула.',
        'Operation filter' => 'Филтер операције',
        'Only execute error handling module for selected operations.' => 'Изврши модул за обраду грешке само за одговарајуће операције.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Напомена: операција за грешке приликом пријема захтева није дефинисана. Филтери за овај ниво обраде не би требало да користе филтер операције.',
        'Invoker filter' => 'Филтер позиваоца',
        'Only execute error handling module for selected invokers.' => 'Изврши модул за обраду грешке само за одговарајуће позиваоце.',
        'Error message content filter' => 'Филтер садржаја поруке о грешци',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Унесите регуларни израз за ограничење које поруке о грешци ће резултирати у позивању модула.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Наслов и садржај поруке о грешци (како су приказани у програму за отклањање грешака) који ће бити сматрани као задовољен услов.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Пример: унесите \'^.*401 Unauthorized.*\$\' за обраду само грешака у вези аутентикације.',
        'Error stage filter' => 'Филтер грешке у одговарућој фази',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Изврши модул за обраду грешке само уколико се догоде током одговарајуће фазе у току захтева.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Пример: обради само грешке када није могуће било мапирати одлазне податке.',
        'Error code' => 'Код грешке',
        'An error identifier for this error handling module.' => 'Идентификатор овог модула за обраду грешака.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Овај идентификатор ће бити доступан у XSLT мапирању и приказан у програму за отклањање грешака.',
        'Error message' => 'Порука о грешци',
        'An error explanation for this error handling module.' => 'Објашњење овог модула за обраду грешака.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ова порука ће бити доступна у XSLT мапирању и приказана у програму за отклањање грешака.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Дефинише да ли процесирање треба да буде заустављено након што је модул извршен, приликом тока прескачући све остале модуле или само оне истог типа.',
        'Default behavior is to resume, processing the next module.' => 'Подразумевано понашање је да се настави процесирање следећег модула.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Овај модул омогућава конфигурацију планираних поновних покушаја за неуспеле захтеве.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Подразумевано понашање веб сервиса је да пошаље сваки захтев само једанпут и да не планира поновно извршавање у случају грешке.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Уколико је више од једног модула способно да поново изврши појединачни захтев, само последњи модул ће бити узет у обзир и одредиће да ли ће бити поновног покушаја.',
        'Request retry options' => 'Подешавања поновних покушаја',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Поновни покушаји ће бити планирани када се изврши модул за обраду грешке (на основу подешавања истих).',
        'Schedule retry' => 'Поновни покушај',
        'Should requests causing an error be triggered again at a later time?' =>
            'Да ли захтеви који резултују у грешкама треба да буду поново извршени?',
        'Initial retry interval' => 'Почетни интервал поновних покушаја',
        'Interval after which to trigger the first retry.' => 'Временски интервал након кога ће бити извршен први поновни покушај.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Напомена: овај и сви наредни интервали поновних покушаја су засновани на времену извршавања модула за обраду грешке почетног захтева.',
        'Factor for further retries' => 'Фактор интервала поновних покушаја',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Уколико захтев резултира грешком и после првог поновног покушаја, дефинише да ли су следећи покушаји извршени у истом или увећавајућем интервалу.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута и фактором интервала 2, поновни покушаји ће бити извршени у 10:01 (1 минут), 10:03 (2*1=2 минута), 10:07 (2*2=4 минута), 10:15 (2*4=8 минута), ...',
        'Maximum retry interval' => 'Максимални интервал поновних покушаја',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Уколико је одабран фактор интервала поновних покушаја од 1.5 или 2, могуће је спречити исувише дуге интервале дефинисањем максимално дозвољеног интервала.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Интервал који прелази максимално дозвољени интервал ће аутоматски бити скраћен.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним интервалом од 5 минута, поновни покушаји ће бити извршени у 10:01 (1 минут), 10:03 (2*1=2 минута), 10:07 (2*2=4 минута), 10:12 (8=> 5 минута), 10:17, ...',
        'Maximum retry count' => 'Максимални број поновних покушаја',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Максимални дозвољени број поновних покушаја пре него што је неуспели захтево одбачен, не рачунајући почетни захтев.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним бројем поновних покушаја 2, поновни покушаји ће бити извршени само у 10:01 и 10:03.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Напомена: максимални дозвољених број поновних покушаја не мора бити достигнут уколико је подешен максимални период поновних покушаја и достигнут раније.',
        'This field must be empty or contain a positive number.' => 'Ово поље мора да буде празно или позитиван број.',
        'Maximum retry period' => 'Максимални период поновних покушаја',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Максимални дозвољени временски период понових покушаја пре него што је неуспели захтев одбачен (заснован на времену извршавања модула за обраду грешке почетног захтева).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Поновни покушаји који би стандардно били извршени после максималног временског периода (на основу израчунатог интервала) ће аутоматски бити извршени тачно у максималном периоду.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним периодом од 30 минута, поновни покушаји ће бити извршени у 10:01, 10:03, 10:07, 10:15 и коначно у 10:31=>10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Напомена: максимални дозвољени период не мора бити достигнут уколико је подешен максимални број поновних покушаја и достигнут раније.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Додај позиваоца',
        'Edit Invoker' => 'Уреди позиваоца',
        'Do you really want to delete this invoker?' => 'Да ли стварно желите да избришете овог позиваоца?',
        'Invoker Details' => 'Детаљи позиваоца',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Назив се обично користи за покретање операције удаљеног веб сервиса.',
        'Invoker backend' => 'Модул позиваоца',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Овај модул позиваоца биће позван да припреми податке за слање на удаљени систем и да обради податке његовог одговора.',
        'Mapping for outgoing request data' => 'Мапирање за излазне податке захтева',
        'Configure' => 'Подеси',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Подаци из OTOBO позиваоца биће обрађени овим мапирањем, да би их трансформисали у типове података које удаљени систем очекује.',
        'Mapping for incoming response data' => 'Мапирање за улазне податке одговора',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Подаци одговора из OTOBO позиваоца биће обрађени овим мапирањем, да би их трансформисали у типове података које удаљени систем очекује..',
        'Asynchronous' => 'Асинхрони',
        'Condition' => 'Услов',
        'Edit this event' => 'Уреди овај догађај',
        'This invoker will be triggered by the configured events.' => 'Овај позиваоц ће бити активиран преко подешених догађаја.',
        'Add Event' => 'Додај догађај',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'За додавање новог догађаја изаберите објекат и назив догађаја па кликните на "+" дугме',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Асинхроним окидачима догађаја управља планер OTOBO системског сервиса у позадини (препоручено).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Синхрони окидачи догађаја биће обрађени директно током веб захтева.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Подешавања позиваоца догађаја у општем интерфејсу за веб сервис %s',
        'Go back to' => 'Иди назад на',
        'Delete all conditions' => 'Избриши све услове',
        'Do you really want to delete all the conditions for this event?' =>
            'Да ли стварно желите да обришете све услове овог догађаја?',
        'General Settings' => 'Општа подешавања',
        'Event type' => 'Тип догађаја',
        'Conditions' => 'Услови',
        'Conditions can only operate on non-empty fields.' => 'Услови могу да се примене само са поља која нису празна.',
        'Type of Linking between Conditions' => 'Тип везе између услова',
        'Remove this Condition' => 'Уклони овај услов',
        'Type of Linking' => 'Тип везе',
        'Add a new Field' => 'Додај ново поље',
        'Remove this Field' => 'Уклони ово поље',
        'And can\'t be repeated on the same condition.' => 'И се не може поновити у истом услову.',
        'Add New Condition' => 'Додај нови услов',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Једноставно мапирање',
        'Default rule for unmapped keys' => 'Подразумевано правило за немапиране кључеве',
        'This rule will apply for all keys with no mapping rule.' => 'Ово правило ће се примењивати за све кључеве без правила мапирања.',
        'Default rule for unmapped values' => 'Подразумевано правило за немапиране вредности',
        'This rule will apply for all values with no mapping rule.' => 'Ово правило ће се примењивати за све вредности без правила мапирања.',
        'New key map' => 'Novo mapiranje ključa',
        'Add key mapping' => 'Додај мапирање кључа',
        'Mapping for Key ' => 'Мапирање за кључ ',
        'Remove key mapping' => 'Уклони мапирање кључа',
        'Key mapping' => 'Мапирање кључа',
        'Map key' => 'Мапирај кључ',
        'matching the' => 'Подударање са',
        'to new key' => 'на нови кључ',
        'Value mapping' => 'Вредносно мапирање',
        'Map value' => 'Мапирај вредност',
        'to new value' => 'на нову вредност',
        'Remove value mapping' => 'Уклони мапирање вредности',
        'New value map' => 'Ново мапирање вредности',
        'Add value mapping' => 'Додај мапирану вредност',
        'Do you really want to delete this key mapping?' => 'Да ли стварно желите да обришете ово мапирање кључа?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Опште пречице',
        'MacOS Shortcuts' => 'MacOS пречице',
        'Comment code' => 'Додај коментар кода',
        'Uncomment code' => 'Уклони коментар кода',
        'Auto format code' => 'Форматирај код аутоматски',
        'Expand/Collapse code block' => 'Прошири/смањи блок кода',
        'Find' => 'Пронађи',
        'Find next' => 'Пронађи следеће',
        'Find previous' => 'Пронађи претходно',
        'Find and replace' => 'Пронађи и замени',
        'Find and replace all' => 'Пронађи и замени све',
        'XSLT Mapping' => 'XSLT мапирање',
        'XSLT stylesheet' => 'XSLT опис стилова',
        'The entered data is not a valid XSLT style sheet.' => 'Унети подаци нису исправан XSLT опис стилова.',
        'Here you can add or modify your XSLT mapping code.' => 'Овде може додати и изменити код XSLT мапирања.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'Поље за уређивање вам омогућава да користите функције као што су аутоматско форматирање, промена величине прозора и аутоматско допуњавање команди и заграда.',
        'Data includes' => 'Подаци укључују',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Одаберите један или више скупова података који су креирани у ранијој фази захтева/одговора за укључивање у податке за мапирање.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Ови скупови ће бити укључени у структуру на путањи \'/DataInclude/<DataSetName>\' (видите програм за отклањање грешака за детаље).',
        'Data key regex filters (before mapping)' => 'Филтери регуларних израза (пре мапирања)',
        'Data key regex filters (after mapping)' => 'Филтери регуларних израза (после мапирања)',
        'Regular expressions' => 'Регуларни изрази',
        'Replace' => 'Замени',
        'Remove regex' => 'Уклони регуларни израз',
        'Add regex' => 'Додај регуларни израз',
        'These filters can be used to transform keys using regular expressions.' =>
            'Ови филтери се могу користи за трансформацију кључева коришћењем регуларних израза.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'Структура података ће бити процесирана рекурзивно и сви подешени регуларни изрази ће бити примењени на све кључеве.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Примери коришћења су нпр. уклањањен непожељних префикса из кључева или исправљање кључева који су неисправни као XML називи.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Пример 1: пронађи = \'^jira:\' / замени = \'\' претвара \'jira:element\' у \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Пример 2: пронађи = \'^\' / замени = \'_\' претвара \'16x16\' у \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Пример 3: Search = \'^(?\d+) (?.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' претвара \'16 elementname\' у \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'За информације о Perl регуларним изразима, молимо посетите:',
        'Perl regular expressions tutorial' => 'Приручних Perl регуларних израза',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Уколико су вам неопходни модификатори, мораћете да их дефинишете у оквиру самих регуларних израза.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Регуларни изрази дефинисани овде биће примењени пре XSLT мапирања.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Регуларни изрази дефинисани овде биће примењени после XSLT мапирања.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Додај операцију',
        'Edit Operation' => 'Уреди операцију',
        'Do you really want to delete this operation?' => 'Да ли стварно желите да обришете ову операцију?',
        'Operation Details' => 'Детаљи операције',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Назив се обично користи за позивање операције веб сервиса из удаљеног система.',
        'Operation backend' => 'Модул операције',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Овај модул операције ће бити интерно позван да обради захтев, генерисањем података за одговор.',
        'Mapping for incoming request data' => 'Мапирање за долазне податке захтева',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Подаци захтева ће бити обрађени кроз мапирање, ради трансформације у облик који OTOBO очекује.',
        'Mapping for outgoing response data' => 'Мапирање за излазне податке одговора',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Подаци одговора ће бити обрађени кроз ово мапирање, ради трансформације у облик који удаљени систем очекује.',
        'Include Ticket Data' => 'Укључи податке тикета',
        'Include ticket data in response.' => 'Укључи податке тикета у одговору.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Мрежни транспорт',
        'Properties' => 'Својства',
        'Route mapping for Operation' => 'Мапирање руте за операцију',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Дефинише руту која ће бити мапирана на ову операцију. Променљиве обележене са \':\' ће бити мапиране за унети назив и прослеђене са осталима (нпр. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Важеће методе захтева за операцију',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ограничи ову опреацију на поједине методе захтева. Ако ни једна метода није изабрана сви захтеви ће бити прихваћени.',
        'Maximum message length' => 'Највећа дужина поруке',
        'This field should be an integer number.' => 'Ово поље треба да буде цео број.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Овде можете унети максималну величину (у бајтима) REST порука које ће OTOBO да обради.',
        'Send Keep-Alive' => 'Пошаљи Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Конфигурација дефинише да ли долазна конекција треба да се затвори и одржава.',
        'Additional response headers' => 'Додатна заглавља у одговорима',
        'Add response header' => 'Додај заглавље у одговору',
        'Endpoint' => 'Крајња тачка',
        'URI to indicate specific location for accessing a web service.' =>
            'URI за идентификацију специфичне локације за приступ сервису.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Временско ограничење',
        'Timeout value for requests.' => 'Временско ограничење за захтеве.',
        'Authentication' => 'Аутентификација',
        'An optional authentication mechanism to access the remote system.' =>
            'Опциони механизам аутентификације за приступ удаљеном систему.',
        'BasicAuth User' => 'BasicAuth корисник',
        'The user name to be used to access the remote system.' => 'Корисничко име које ће бити коришћено за приступ удаљеном систему.',
        'BasicAuth Password' => 'BasicAuth лозинка',
        'The password for the privileged user.' => 'Лозинка за привилегованог корисника.',
        'Use Proxy Options' => 'Користи Proxy подешавања',
        'Show or hide Proxy options to connect to the remote system.' => 'Прикажи или сакриј Proxy опције за повезивање са удаљеним системом.',
        'Proxy Server' => 'Proxy сервер',
        'URI of a proxy server to be used (if needed).' => 'URI од proxy сервера да буде коришћен (ако је потребно).',
        'e.g. http://proxy_hostname:8080' => 'нпр. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy корисник',
        'The user name to be used to access the proxy server.' => 'Корисничко име које ће се користити за приступ proxy серверу.',
        'Proxy Password' => 'Proxy лозинка',
        'The password for the proxy user.' => 'Лозинка за proxy корисника.',
        'Skip Proxy' => 'Игнориши Proxy',
        'Skip proxy servers that might be configured globally?' => 'Да ли желите да игноришете Proxy сервере који су можда подешени глобално?',
        'Use SSL Options' => 'Користи SSL опције',
        'Show or hide SSL options to connect to the remote system.' => 'Прикажи или сакриј SSL опције за повезивање са удаљеним системом.',
        'Client Certificate' => 'Клијентски сертификат',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Цела путања и назив за датотеку SSL сертификата (мора бити у PEM, DER или PKCS#12 формату).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'нпр. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Кључ клијентског сертификата',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Цела путања и назив за датотеку кључа SSL сертификата (уколико није укључен у датотеку сертификата).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'нпр. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Лозинка кључа клијентског сертификата',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Лозинка за отварање SSL сертификата уколико је кључ шифрован.',
        'Certification Authority (CA) Certificate' => 'Сертификат сертификационог тела (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Цела путања и назив сертификационог тела које провера исправност SSL сертификата.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'нпр. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Директоријум сертификационог тела (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Цела путања директоријума сертификационог тела где се складиште CA сертификати у систему датотека.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'нпр. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Мапирање контролера за позиваоца',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Контролер коме ће позивалац прослеђивати захтеве. Променљиве обележене са \':\' ће бити замењене њиховим вредностима и прослеђене заједно са захтевом (нпр. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Важећа команда захтева за позиваоца',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Специфична HTTP команда за примену на захтеве са овим позиваоцем (необавезно).',
        'Default command' => 'Подразумевана команда',
        'The default HTTP command to use for the requests.' => 'Подразумевена HTTP команда за захтеве.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'нпр. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Дефиниши SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Изабери "Да" за слање попуњеног SOAPAction заглавља.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Изабери "Не" за слање празног SOAPAction заглавља.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Изабери "Да" за проверу примљеног SOAPAction заглавља (уколико није празно).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Изабери "Не" за игнорисање примљеног SOAPAction заглавља.',
        'SOAPAction scheme' => 'SOAPAction шема',
        'Select how SOAPAction should be constructed.' => 'Изаберите како ће бити конструисан SOAPAction.',
        'Some web services require a specific construction.' => 'Поједини веб сервиси захтевају специфичну конструкцију.',
        'Some web services send a specific construction.' => 'Поједини веб сервиси шаљу специфичну конструкцију.',
        'SOAPAction separator' => 'Сепаратор SOAP акције',
        'Character to use as separator between name space and SOAP operation.' =>
            'Знак који ће се користити као сепаратор између заглавља и SOAP методе.',
        'Usually .Net web services use "/" as separator.' => '.Net веб сервиси обично користе "/" као сепаратор.',
        'SOAPAction free text' => 'SOAPAction слободан текст',
        'Text to be used to as SOAPAction.' => 'Текст који ће се користити као SOAPAction.',
        'Namespace' => 'Врста захтева',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI који даје контекст SOAP методама, смањује двосмислености.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => 'Захтев за шему назива',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Изаберите како ће бити конструисан омотач функције SOAP захтева.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' се користи као пример за стваран назив позиваоца/операције.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' се користи као пример за стварну подешену вредност.',
        'Request name free text' => 'Слободан текст назива захтева',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Текст који ће бити кориштен као наставак назива или замена омотача функције.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Молимо да узмете у обзир XML оганичења именовања (нпр. немојте користити \'<\' и \'&\').',
        'Response name scheme' => 'Шема назива одговора',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Изаберите како ће бити конструисан омотач функције SOAP одговора.',
        'Response name free text' => 'Слободан текст назива одговора',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Овде можете унети максималну величину (у бајтима) SOAP порука које ће OTOBO да обради.',
        'Encoding' => 'Кодни распоред',
        'The character encoding for the SOAP message contents.' => 'Кодни распоред знакова за садржај SOAP поруке.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'нпр. utf-8, latin1, iso-8859-1, cp1250, ...',
        'Sort options' => 'Опције сортирања',
        'Add new first level element' => 'Додај нови елемент првог нивоа',
        'Element' => 'Елемент',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Одлазни редослед сортирања за XML поља (структура испод назива омотача функције) - погледајте документацију за SOAP транспорт.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Додај веб сервис',
        'Edit Web Service' => 'Уреди веб сервис',
        'Clone Web Service' => 'Клонирај веб сервис',
        'The name must be unique.' => 'Назив мора бити јединствен.',
        'Clone' => 'Клонирај',
        'Export Web Service' => 'Извези веб сервис',
        'Import web service' => 'Увези веб сервис',
        'Configuration File' => 'Конфигурациона датотека',
        'The file must be a valid web service configuration YAML file.' =>
            'Датотека мора да буде важећа YAML конфигурациона датотека веб сервиса.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Овде можете дефинисати назив веб сервиса. Уколико је ово поље празно, биће коришћен назив конфигурационе датотеке.',
        'Import' => 'Увези',
        'Configuration History' => 'Историјат конфигурације',
        'Delete web service' => 'Обриши веб сервис',
        'Do you really want to delete this web service?' => 'Да ли стварно желите да обришете овај веб сервис?',
        'Ready2Adopt Web Services' => 'Ready2Adopt веб сервиси',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Овде можете активирати Ready2Adopt веб сервисе спремне за употребу који осликавају нашу најбољу праксу која је део %s.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Молимо да имате на уму да веб сервиси могу да зависе од других модула који су доступни у оквиру одређених %s нивоа уговора (постоји обавешетење са додатним детаљима при увозу).',
        'Import Ready2Adopt web service' => 'Увези Ready2Adopt веб сервис',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            'Да ли желите да искористите веб сервисе креиране од стране експерата? Унапредите на %s да би могли да увезете софистициране Ready2Adopt веб сервисе спремне за употребу.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Након снимања конфигурације бићете поново преусмерени на приказ екрана за уређивање.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ако желите да се вратите на преглед, молимо да кликнете на дугме \'Иди на преглед\'.',
        'Remote system' => 'Удаљени систем',
        'Provider transport' => 'Транспорт провајдера',
        'Requester transport' => 'Транспорт потражиоца',
        'Debug threshold' => 'Праг уклањања грешака',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'У режиму провајдера, OTOBO нуди веб сервисе који се користе од стране удаљених система.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'У режиму наручиоца, OTOBO користи веб сервисе удаљених система.',
        'Network transport' => 'Мрежни транспорт',
        'Error Handling Modules' => 'Модули за обраду грешке',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Модули за обраду грешке се користе за реакцију у случуја грешака у току комуникације. Ови модули се извршавају у одговарајућем редоследу, који може бити измењен превлачењем.',
        'Backend' => 'Модул',
        'Add error handling module' => 'Додај модул за обраду грешке',
        'Operations are individual system functions which remote systems can request.' =>
            'Операције су индивидуалне системске функције које удаљени системи могу да захтевају.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Позиваоци припремају податке за захтев на удаљеном wеб сервису и обрађују податке његових одговора.',
        'Controller' => 'Контролер',
        'Inbound mapping' => 'Улазно мапирање',
        'Outbound mapping' => 'Излазно мапирање',
        'Delete this action' => 'Обриши ову акцију',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Најмање један %s има контролер који или није активан или није присутан, молимо проверите регистрацију контролера или избришите %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Историја',
        'Go back to Web Service' => 'Вратите се на веб сервис',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Овде можете видети старије верзије конфигурације актуелног веб сервиса, експортовати их или их обновити.',
        'Configuration History List' => 'Листа - историјат конфигурације',
        'Version' => 'Верзија',
        'Create time' => 'Време креирања',
        'Select a single configuration version to see its details.' => 'Изабери само једну конфигурациону верзију за преглед њених детаља.',
        'Export web service configuration' => 'Извези конфигурацију веб сервиса',
        'Restore web service configuration' => 'Обнови конфигурацију веб сервиса',
        'Do you really want to restore this version of the web service configuration?' =>
            'Да ли стварно желите да вратите ову верзију конфигурације веб сервиса?',
        'Your current web service configuration will be overwritten.' => 'Актуелна конфигурација веб сервиса биће преписана.',

        # Template: AdminGroup
        'Group Management' => 'Управљање групама',
        'Add Group' => 'Додај групу',
        'Edit Group' => 'Уреди групу',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '\'admin\' група служи за приступ администрационом простору, а \'stats\' група статистикама.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Направи нове групе за руковање правима приступа разним групама оператера (нпр. одељење набавке, техничка подршка, продаја, ...). ',
        'It\'s useful for ASP solutions. ' => 'Корисно за ASP решења. ',

        # Template: AdminLog
        'System Log' => 'Системски дневник',
        'Here you will find log information about your system.' => 'Овде ћете наћи лог информације о вашем систему.',
        'Hide this message' => 'Сакриј ову поруку',
        'Recent Log Entries' => 'Последњи лог уноси',
        'Facility' => 'Инсталација',
        'Message' => 'Порука',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Управљање имејл налозима',
        'Add Mail Account' => 'Додај имејл налог',
        'Edit Mail Account for host' => 'Уреди имејл налог за сервер',
        'and user account' => 'и кориснички налог',
        'Filter for Mail Accounts' => 'Филтер за имејл налоге',
        'Filter for mail accounts' => 'Филтер за имејл налоге',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Све долазне поруке са једног имејл налога ће бити усмерене у изабрани ред.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Ако је ваш налог од поверења, постојећа X-OTOBO заглавља у тренутку пријема (за приоритет, итд.) ће бити сачувана коришћена, нпр. у PostMaster филтерима.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Подешавања одлазећих имејл порука могу бити конфигурисана путем Sendmail* опција у %s.',
        'System Configuration' => 'Конфигурација система',
        'Host' => 'Домаћин',
        'Delete account' => 'Обриши налог',
        'Fetch mail' => 'Преузми пошту',
        'Do you really want to delete this mail account?' => 'Да ли стварно желите да обришете овај имејл налог?',
        'Example: mail.example.com' => 'Пример: mail.example.com',
        'IMAP Folder' => 'IMAP фолдер',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ово измените само ако је потребно примити пошту из другог фолдера, а не из INBOX-а.',
        'Trusted' => 'Од поверења',
        'Dispatching' => 'Отпрема',
        'Edit Mail Account' => 'Уреди имејл налог',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Административни преглед',
        'Filter for Items' => 'Филтер за ставке',
        'Favorites' => 'Омиљене',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Можете додати омиљене превлачењем курсора преко ставке са десне стране и кликом на иконицу звезде.',
        'Links' => 'Везе',
        'View the admin manual on Github' => 'Прегледајте упутство за администраторе на Github',
        'No Matches' => 'Ништа није пронађено',
        'Sorry, your search didn\'t match any items.' => 'Жао нам је, ваша претрага није вратила резултате.',
        'Set as favorite' => 'Стави у омиљене',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Управљање обавештењима о тикетима',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Овде можете послати конфигурациону датотеку за увоз обавештења о тикету у ваш систем. Датотека мора бити у .yml формату ако се извози од стране модула за обавештења о тикету.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Овде можете изабрати који догађаји ће покренути обавештавање. Додатни филтер за тикете може бити примењен ради слања само за тикете по одређеном критеријуму.',
        'Ticket Filter' => 'Филтер тикета',
        'Lock' => 'Закључај',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID клијента корисника',
        'Article Filter' => 'Филтер чланка',
        'Only for ArticleCreate and ArticleSend event' => 'Само за догађај креирање чланка и слање чланка',
        'Article sender type' => 'Тип пошиљаоца чланка',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Ако се користе догађаји креирање чланка и слање чланка, неопходно је дефинисати филтер чланка. Молим вас селектујте бар једно поље за филтер чланка.',
        'Customer visibility' => 'Видљиво клијентима',
        'Communication channel' => 'Комуникациони канал',
        'Include attachments to notification' => 'Укључи прилоге уз обавштење',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Обавети корисника само једном дневно о поједином тикету коришћењем изабраног транспорта.',
        'This field is required and must have less than 4000 characters.' =>
            'Ово поље је обавезно и не сме бити дуже од 4000 карактера.',
        'Notifications are sent to an agent or a customer.' => 'Обавештење послато оператеру или клијенту.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Да видите првих 20 слова предмета (последњег чланка оператера).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Да видите првих 5 линија поруке (последњег чланка оператера).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Да видите првих 20 слова предмета (последњег чланка клијента).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Да видите првих 5 линија поруке (последњег чланка клијента).',
        'Attributes of the current customer user data' => 'Атрибути података актуелног клијента корисника',
        'Attributes of the current ticket owner user data' => 'Атрибути података корисника власника актуелног тикета',
        'Attributes of the current ticket responsible user data' => 'Атрибути података одговорног корисника актуелног тикета',
        'Attributes of the current agent user who requested this action' =>
            'Атрибути актуелног корисника оператера који је тражио ову акцију',
        'Attributes of the ticket data' => 'Атрибути података тикета',
        'Ticket dynamic fields internal key values' => 'Вредности интерних кључева динамичких поља тикета',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Приказане вредности динамичких поља, корисно за падајућа и поља са вишеструким избором',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Користите зарез или тачку-зарез за одвајање имејл адреса.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Можете користити OTOBO тагове као <OTOBO_TICKET_DynamicField_...> за уметање вредности из тренутног тикета.',

        # Template: AdminPGP
        'PGP Management' => 'Управљање PGP кључевима',
        'Add PGP Key' => 'Додај PGP кључ',
        'PGP support is disabled' => 'PGP подршка је онемогућена',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Да би могли да користите PGP у OTOBO, морате га прво омогућити.',
        'Enable PGP support' => 'Омогући PGP подршку',
        'Faulty PGP configuration' => 'Неисправна PGP конфигурација',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP подршка ја омогућена али релевантна конфигурација садржи грешке. Молимо да проверите конфигурацију притиском на дугме испод.',
        'Configure it here!' => 'Подесите то овде!',
        'Check PGP configuration' => 'Провери PGP конфигурацију',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'На овај начин можете директно уређивати комплет кључева подешен у SysConfig (системским конфигурацијама).',
        'Introduction to PGP' => 'Увод у PGP',
        'Bit' => 'Бит',
        'Fingerprint' => 'Отисак',
        'Expires' => 'Истиче',
        'Delete this key' => 'Обриши овај кључ',
        'PGP key' => 'PGP кључ',

        # Template: AdminPackageManager
        'Package Manager' => 'Управљање пакетима',
        'Uninstall Package' => 'Деинсталирај пакет',
        'Uninstall package' => 'Деинсталирај пакет',
        'Do you really want to uninstall this package?' => 'Да ли стварно желите да деинсталирате овај пакет?',
        'Reinstall package' => 'Инсталирај поново пакет',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Да ли стварно желите да поново инсталирате овај пакет? Све ручне промене ће бити изгубљене.',
        'Go to updating instructions' => 'Иди на упутство за ажурирање',
        'Go to the OTOBO customer portal' => 'Иди на OTOBO кориснички портал',
        'package information' => 'Информације о пакету',
        'Package installation requires a patch level update of OTOBO.' =>
            'Инсталација пакета захтева ажурирану верзију OTOBO.',
        'Package update requires a patch level update of OTOBO.' => 'Ажурирање пакета захтева ажурирану верзију OTOBO.',
        'Please note that your installed OTOBO version is %s.' => 'Тренутно инсталирана OTOBO верзија је %s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'Да бисте инсталирали овај пакет, неопходно је да ажурирате ваш OTOBO на верзију %s или новију.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Овај пакет се може инсталирати само на OTOBO верзију%s или старију.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Овај пакет се може инсталирати само на OTOBO верзију%s или новију.',
        'Why should I keep OTOBO up to date?' => 'Зашто би требало да OTOBO увек буде ажуриран?',
        'You will receive updates about relevant security issues.' => 'Добићете ажурирања одговарајућих безбедносних издања.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Добићете ажурирања свих других релевантних OTOBO издања.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Како могу да ажурирам верзију OTOBO уколико немам уговор?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Молимо пронађите све релевантне информације у оквиру инструкција за ажурирање на %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'У случају да имате додтана питања, биће нам задовољство да одговоримо на њих.',
        'Please visit our customer portal and file a request.' => 'Молимо посетите наш кориснички портал и поднесите захтев.',
        'Install Package' => 'Инсталирај пакет',
        'Update Package' => 'Ажурирај пакет',
        'Continue' => 'Настави',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Молимо вас да будете сигурни да ваша база података прихвата пакете величине преко %s MB (тренутно прихвата само пакете до %s MB). Молимо вас да прилагодите подешавања \'max_allowed_packet\' на вашој бази података, да би сте избегли грешке.',
        'Install' => 'Инсталирај',
        'Update repository information' => 'Ажурирај информације о спремишту',
        'Cloud services are currently disabled.' => 'Сервиси у облаку су тренутно деактивирани.',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => 'Активирај сервисе у облаку',
        'Update all installed packages' => 'Ажурирај све инсталиране пакете',
        'Online Repository' => 'Мрежно спремиште',
        'Vendor' => 'Продавац',
        'Action' => 'Акција',
        'Module documentation' => 'Документација модула',
        'Local Repository' => 'Локално спремиште',
        'This package is verified by OTOBOverify (tm)' => 'Овај пакет је верификован од стране OTOBOverify (tm)',
        'Uninstall' => 'Деинсталирај',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Пакет није коректно инсталиран! Инсталирајте га поново.',
        'Reinstall' => 'Инсталирај поново',
        'Features for %s customers only' => 'Својства само за %s клијенте',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Са %s можете имати користи од следећих опционих функција. Молимо да контактирате %s уколико су вам потребне додатне информације.',
        'Package Information' => 'Информације о пакету',
        'Download package' => 'Преузми пакет',
        'Rebuild package' => 'Обнови пакет(rebuild)',
        'Metadata' => 'Мета подаци',
        'Change Log' => 'Промени лог',
        'Date' => 'Датум',
        'List of Files' => 'Списак датотека',
        'Permission' => 'Дозвола',
        'Download file from package!' => 'Преузми датотеку из пакета!',
        'Required' => 'Обавезно',
        'Primary Key' => 'Примарни кључ',
        'Auto Increment' => 'Ауто увећање',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Разлике за датотеку %s',
        'File differences for file %s' => 'Разлике за датотеку %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Перформанса лог-а',
        'Range' => 'Опсег',
        'last' => 'последње',
        'This feature is enabled!' => 'Ова функција је активна!',
        'Just use this feature if you want to log each request.' => 'Активирати ову могућност само ако желите да забележите сваки захтев.',
        'Activating this feature might affect your system performance!' =>
            'Активирање ове функције може утицати на перформансе система!',
        'Disable it here!' => 'Искључите је овде!',
        'Logfile too large!' => 'Лог датотека је превелика!',
        'The logfile is too large, you need to reset it' => 'Лог датотека је превелика, треба да је ресетујете',
        'Interface' => 'Интерфејс',
        'Requests' => 'Захтеви',
        'Min Response' => 'Мин одзив',
        'Max Response' => 'Макс одзив',
        'Average Response' => 'Просечан одзив',
        'Period' => 'Период',
        'minutes' => 'минути',
        'Min' => 'Мин',
        'Max' => 'Макс',
        'Average' => 'Просек',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управљање PostMaster филтерима',
        'Add PostMaster Filter' => 'Додај PostMaster филтер',
        'Edit PostMaster Filter' => 'Уреди PostMaster филтер',
        'Filter for PostMaster Filters' => 'Филтер за PostMaster филтере',
        'Filter for PostMaster filters' => 'Филтер за PostMaster филтере',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Ради отпреме или филтрирања долазних имејлова на основу заглавља. Поклапање помоћу регуларних израза је такође могуће.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Уколико желите поклапање само са имејл адресом, користите EMAILADDRESS:info@example.com у From, To или Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Уколико користите регуларне изразе, такође можете користити и упатеру вредност у () као (***) у \'Set\' action.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Можете користити и именоване скупове %s и референцирати називе у пољу \'на вредност\' %s (нпр. регуларни израз: %s, на вредност: %s). Препознате имејл адресе имају назив \'%s\'.',
        'Delete this filter' => 'Обриши овај филтер',
        'Do you really want to delete this postmaster filter?' => 'Да ли стварно желите да обришете овај postmaster филтер?',
        'A postmaster filter with this name already exists!' => 'PostMaster филтер са овим називом већ постоји!',
        'Filter Condition' => 'Услов филтрирања',
        'AND Condition' => 'AND услов',
        'Search header field' => 'Претражи заглавље имејла',
        'for value' => 'за вредност',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ово поље треба да буде важећи регуларни израз или дословно реч.',
        'Negate' => 'Негирати',
        'Set Email Headers' => 'Подеси заглавља имејла',
        'Set email header' => 'Подеси заглавље имејла',
        'with value' => 'на вредност',
        'The field needs to be a literal word.' => 'Ово поље треба да буде дословно реч.',
        'Header' => 'Заглавље',

        # Template: AdminPriority
        'Priority Management' => 'Управљање приоритетима',
        'Add Priority' => 'Додај Приоритет',
        'Edit Priority' => 'Уреди Приоритет',
        'Filter for Priorities' => 'Филтер за приоритете',
        'Filter for priorities' => 'Филтер за приоритете',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Овај приоритет се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'This priority is used in the following config settings:' => 'Овај приоритет се користи у следећим системским подешавањима:',

        # Template: AdminProcessManagement
        'Process Management' => 'Управљање процесима',
        'Filter for Processes' => 'Филтер процеса',
        'Filter for processes' => 'Филтер процеса',
        'Create New Process' => 'Креирај нови процес',
        'Deploy All Processes' => 'Распореди све процесе',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Овде можете учитати конфигурациону датотеку за увоз процеса у ваш систем. Датотека мора бити у .yml формату извезена од стране модула за управљање процесом.',
        'Upload process configuration' => 'Учитај конфигурацију процеса',
        'Import process configuration' => 'Увези конфигурацију процеса',
        'Ready2Adopt Processes' => 'Ready2Adopt процеси',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Овде можете активирати Ready2Adopt процесе примера најбоље праксе који су спремни за употребу. Молимо обратите пажњу да је можда неопходна додатна конфигурација.',
        'Import Ready2Adopt process' => 'Увези Ready2Adopt процес',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'За креирање новог процеса можете или увести процес који је извезен из другог система или креирати комплетно нов.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Промене у процесима једино утичу на понашање система, ако синхронизујете податке процеса. Синхронизовањем процеса, новонаправљене промене ће бити уписане у конфигурацију.',
        'Processes' => 'Процеси',
        'Process name' => 'Назив процеса',
        'Print' => 'Штампај',
        'Export Process Configuration' => 'Извези конфигурацију процеса',
        'Copy Process' => 'Копирај процес',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Поништи & затвори',
        'Go Back' => 'Врати се назад',
        'Please note, that changing this activity will affect the following processes' =>
            'Напомињемо да ће измене ове активности утицати на пратеће процесе',
        'Activity' => 'Активност',
        'Activity Name' => 'Назив активности',
        'Activity Dialogs' => 'Дијалози активности',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Дијалоге активности можете доделити овој активности превлачењем елемената мишем од леве листе до десне листе.',
        'Filter available Activity Dialogs' => 'Филтрирај слободне дијалоге активности',
        'Available Activity Dialogs' => 'Слободни дијалози активности',
        'Name: %s, EntityID: %s' => 'Назив: %s, ID ентитета: %s',
        'Create New Activity Dialog' => 'Креирај нов дијалог активности',
        'Assigned Activity Dialogs' => 'Додељени дијалози активности',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Напомињемо да ће промена овог дијалога активности утицати на пратеће активности',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Напомињемо да клијенти корисници нису у могућности да виде или користе следећа поља: Owner, Responsible, Lock, PendingTime и CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Поље у реду једино може бити коришћено од стране клијента када креирају нови тикет.',
        'Activity Dialog' => 'Дијалог активности',
        'Activity dialog Name' => 'Назив дијалога активности',
        'Available in' => 'Расположиво у',
        'Description (short)' => 'Опис (кратак)',
        'Description (long)' => 'Опис (дугачак)',
        'The selected permission does not exist.' => 'Изабрана овлашћења не постоје.',
        'Required Lock' => 'Обавезно закључај',
        'The selected required lock does not exist.' => 'Одабрано захтевано закључавање не постоји.',
        'Submit Advice Text' => 'Пошаљи текст савета',
        'Submit Button Text' => 'Пошаљи текст дугмета',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Поља можете доделити у овом дијалогу активности превлачењем елемената мишем из леве листе у десну листу.',
        'Filter available fields' => 'Филтрирај расположива поља',
        'Available Fields' => 'Расположива поља',
        'Assigned Fields' => 'Додељена поља',
        'Communication Channel' => 'Комуникациони канал',
        'Is visible for customer' => 'Видљиво клијенту',
        'Display' => 'Прикажи',

        # Template: AdminProcessManagementPath
        'Path' => 'Путања',
        'Edit this transition' => 'Уредите ову транзицију',
        'Transition Actions' => 'Транзиционе акције',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Можете доделити транзиционе активности у овој транзицији превлачењем елемената мишем из леве листе у десну листу.',
        'Filter available Transition Actions' => 'Филтрирај расположиве транзиционе активности',
        'Available Transition Actions' => 'Расположиве транзиционе акције',
        'Create New Transition Action' => 'Креирај нову транзициону активност',
        'Assigned Transition Actions' => 'Додељене транзиционе активности',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Активности',
        'Filter Activities...' => 'Филтрирај активности ...',
        'Create New Activity' => 'Креирај нову активност',
        'Filter Activity Dialogs...' => 'Филтрирај дијалоге активности ...',
        'Transitions' => 'Транзиције',
        'Filter Transitions...' => 'Филтрирај транзиције ...',
        'Create New Transition' => 'Креирај нову транзицију',
        'Filter Transition Actions...' => 'Филтрирај транзиционе активности ...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Уреди процес',
        'Print process information' => 'Штампај информације процеса',
        'Delete Process' => 'Избриши процес',
        'Delete Inactive Process' => 'Избриши неактиван процес',
        'Available Process Elements' => 'Расположиви елементи процеса',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Елементи, наведени горе у издвојеном одељку, могу да се померају по површини на десну страну коришћењем превуци и пусти технике.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Можете поставити активности на поврсину како би доделити ову активност процесу.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'За додељивање Дијалога Активности некој активности, превуците елемент дијалога активности из издвојеног дела, преко активности смештене на површини.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Везу између две активности можете започети превлачењем елемента транзиције преко почетка активности везе. Након тога можете да преместите слободан крај стрелице до краја активности.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Активност може бити додељена транзицији превлачењем елемента активности на ознаку транзиције.',
        'Edit Process Information' => 'Уреди информације о процесу',
        'Process Name' => 'Назив процеса',
        'The selected state does not exist.' => 'Одабрани статус не постоји.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Додај и уреди активости, дијалоге активности и транзиције',
        'Show EntityIDs' => 'Покажи ID ентитета',
        'Extend the width of the Canvas' => 'Прошири ширину простора',
        'Extend the height of the Canvas' => 'Продужи висину простора',
        'Remove the Activity from this Process' => 'Уклони активност из овог процеса',
        'Edit this Activity' => 'Уреди ову активност',
        'Save Activities, Activity Dialogs and Transitions' => 'Сачувај активости, дијалоге активности и транзиције',
        'Do you really want to delete this Process?' => 'Да ли стварно желите да обришете овај процес?',
        'Do you really want to delete this Activity?' => 'Да ли стварно желите да обришете ову активност?',
        'Do you really want to delete this Activity Dialog?' => 'Да ли стварно желите да обришете овај дијалог активности?',
        'Do you really want to delete this Transition?' => 'Да ли стварно желите да обришете ову транзицију?',
        'Do you really want to delete this Transition Action?' => 'Да ли стварно желите да обришете ову транзициону активност?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Да ли стварно желите да уклоните ову активност са површине? Ово једино може да се опозове уколико напустите екран, а да претходно не сачувате измене.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Да ли стварно желите да уклоните ову транзицију са површине? Ово једино може да се опозове уколико напустите екран, а да претходно не сачувате измене.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'У овом екрану можете креирати нови процес. Да би нови процес био доступан корисницима, молимо вас да поставите статус на \'Active\' и урадите синхронизацију након завршетка вашег рада.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'поништи & затвори',
        'Start Activity' => 'Почетак активности',
        'Contains %s dialog(s)' => 'Садржи %s дијалога',
        'Assigned dialogs' => 'Додељени дијалози',
        'Activities are not being used in this process.' => 'Активности се не користе у овом процесу.',
        'Assigned fields' => 'Додељена поља',
        'Activity dialogs are not being used in this process.' => 'Дијалози активности се не користе у овом процесу.',
        'Condition linking' => 'Услов повезивања',
        'Transitions are not being used in this process.' => 'Транзиције се не користе у овом процесу.',
        'Module name' => 'Назив модула',
        'Transition actions are not being used in this process.' => 'Транзиционе активности се не користе у овом процесу.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Напомињемо да би мењење ове транзиције утицало на пратеће процесе',
        'Transition' => 'Транзиција',
        'Transition Name' => 'Назив транзиције',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Напомињемо да би мењење ове транзиционе активности утицало на пратеће процесе',
        'Transition Action' => 'Транзициона активност',
        'Transition Action Name' => 'Назив транзиционе активности',
        'Transition Action Module' => 'Модул транзиционе активности',
        'Config Parameters' => 'Конфигурациони параметри',
        'Add a new Parameter' => 'Додај нови параметар',
        'Remove this Parameter' => 'Уклони овај параметар',

        # Template: AdminQueue
        'Queue Management' => 'Управљање редовима',
        'Add Queue' => 'Додај Ред',
        'Edit Queue' => 'Уреди Ред',
        'Filter for Queues' => 'Филтер за редове',
        'Filter for queues' => 'Филтер за редове',
        'A queue with this name already exists!' => 'Ред са овим називом већ постоји!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Овај ред се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'Sub-queue of' => 'Под-ред од',
        'Unlock timeout' => 'Време до откључавања',
        '0 = no unlock' => '0 = нема откључавања',
        'hours' => 'сати',
        'Only business hours are counted.' => 'Рачуна се само радно време.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Ако оператер закључа тикет и не откључа га пре истека времена откључавања, тикет ће се откључати и постати доступан другим запосленима.',
        'Notify by' => 'Обавештен од',
        '0 = no escalation' => '0 = нема ескалације',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Ако контакт са клијентом, било спољашњи имејл или позив, није додат на нови тикет пре истицања дефинисаног времена, тикет ће ескалирати.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Ако постоји додат чланак, као нпр. наставак преко имејл поруке или клијентског портала, време ажурирања ескалације се ресетује. Ако не постоје контакт подаци о клијенту, било имејл или позив додати на тикет пре истицања овде дефинисаног времена, тикет ће ескалирати.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ако се тикет не затвори пре овде дефинисаног времена, тикет ескалира.',
        'Follow up Option' => 'Опције наставка',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Дефинишите да ли наставак на затворени тикет поново отвара тикет или отвара нови.',
        'Ticket lock after a follow up' => 'Закључавање тикета после наставка',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ако је тикет затворен, а клијент пошаље наставак, тикет ће бити закључан на старог власника.',
        'System address' => 'Системска адреса',
        'Will be the sender address of this queue for email answers.' => 'Биће адреса пошиљаоца за имејл одговоре из овог реда.',
        'Default sign key' => 'Подразумевани кључ потписа',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'За коришћење својства потписивања, PGP кључеви или S/MIME сертификати идентитета морају бити додати за системску адресу одабраног реда.',
        'Salutation' => 'Поздрав',
        'The salutation for email answers.' => 'Поздрав за имејл одговоре.',
        'Signature' => 'Потпис',
        'The signature for email answers.' => 'Потпис за имејл одговоре.',
        'This queue is used in the following config settings:' => 'Овај ред се користи у следећим системским подешавањима:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Управљање везама ред-аутоматски одговор',
        'Change Auto Response Relations for Queue' => 'Промени релације са аутоматским одговорима за ред',
        'This filter allow you to show queues without auto responses' => 'Овај филтер вам омогућава приказ редова без аутоматских одговора',
        'Queues without Auto Responses' => 'Редови без аутоматских одговора',
        'This filter allow you to show all queues' => 'Овај филтер вам омогућава приказ свих редова',
        'Show All Queues' => 'Прикажи све редове',
        'Auto Responses' => 'Аутоматски одговори',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Управљање односом шаблон-ред',
        'Filter for Templates' => 'Филтер за шаблоне',
        'Filter for templates' => 'Филтер за шаблоне',
        'Templates' => 'Шаблони',

        # Template: AdminRegistration
        'System Registration Management' => 'Управљање системом регистрације',
        'Edit System Registration' => 'Уреди регистрацију система',
        'System Registration Overview' => 'Преглед регистрације система',
        'Register System' => 'Региструј систем',
        'Validate OTOBO-ID' => 'Провери важност OTOBO-ID',
        'Deregister System' => 'Искључи систем из регистра',
        'Edit details' => 'Уреди детаље',
        'Show transmitted data' => 'Покажи послате податке',
        'Deregister system' => 'Одјави систем',
        'Overview of registered systems' => 'Преглед регистрованих система',
        'This system is registered with OTOBO Team.' => '',
        'System type' => 'Тип система',
        'Unique ID' => 'Јединствени ID',
        'Last communication with registration server' => 'Последња комуникација са регистрационим сервером',
        'System Registration not Possible' => 'Регистрација система није могућа',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Молимо да обратите пажњу да не можете регистровати ваш систем ако OTOBO системски процес не ради коректно!',
        'Instructions' => 'Инструкције',
        'System Deregistration not Possible' => 'Одјава система није могућа',
        'OTOBO-ID Login' => 'OTOBO-ID пријава',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Прочитај више',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Потребно је да се пријавите са вашим OTOBO-ID да региструјете ваш систем.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Ваш OTOBO-ID је имејл адреса коју користите за пријаву на веб страну OTOBO.com.',
        'Data Protection' => 'Заштита података',
        'What are the advantages of system registration?' => 'Које су предности регистрације система?',
        'You will receive updates about relevant security releases.' => 'Добићете ажурирања одговарајућих безбедносних издања.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Са регистрацијом система можемо побољшати наше услуге за вас, јер ми имамо доступне све релевантне информације.',
        'This is only the beginning!' => 'Ово је само почетак!',
        'We will inform you about our new services and offerings soon.' =>
            'Информисаћемо вас о нашим новим услугама и понудама ускоро!',
        'Can I use OTOBO without being registered?' => 'Да ли могу да користим OTOBO уколико нисам регистрован?',
        'System registration is optional.' => 'Регистрација система је опционална.',
        'You can download and use OTOBO without being registered.' => 'Можете преузети OTOBO и уколико нисте регистровани.',
        'Is it possible to deregister?' => 'Да ли је могућа одјава?',
        'You can deregister at any time.' => 'Можете се одјавити у било које доба.',
        'Which data is transfered when registering?' => 'Који подаци се преносе приликом регистрације?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Пуно квалификовано име домена (FQDN), OTOBO верзија, база података, оперативни систем и Perl верзија.',
        'Why do I have to provide a description for my system?' => 'Зашто морам да проследим опис мог система?',
        'The description of the system is optional.' => 'Опис система је опциони.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Наведени опис и тип система помажу вам да идентификујете и управљате детаљима регистрованог система.',
        'How often does my OTOBO system send updates?' => 'Колико често ће мој OTOBO систем слати ажурирања?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ваш систем ће у редовним временским интервалима слати ажурирања регистрационом серверу.',
        'Typically this would be around once every three days.' => 'Обично је то једном у свака три дана.',
        'If you deregister your system, you will lose these benefits:' =>
            'Ако дерегиструјете ваш систем, изгубићете следеће олакшице:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Да би сте ођавили ваш систем, морате да се пријавите са вашим OTOBO-ID',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Још увек немате OTOBO-ID?',
        'Sign up now' => 'Региструјте се сада',
        'Forgot your password?' => 'Заборавили сте лозинку?',
        'Retrieve a new one' => 'Преузми нову',
        'Next' => 'Следеће',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => 'Атрибут',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO верзија',
        'Operating System' => 'Оперативни систем',
        'Perl Version' => 'Perl верзија',
        'Optional description of this system.' => 'Опциони опис овог система.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Региструј',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => 'Искључи из регистра',
        'You can modify registration settings here.' => 'Овде можете изменити регистрациона подешавања.',
        'Overview of Transmitted Data' => 'Преглед послатих података',
        'There is no data regularly sent from your system to %s.' => 'Нема података који су редовно слати са вашег система за %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Следећи подаци су слати барем свака 3 дана са вашег система за %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Подаци ће бити послати у JSON формату преко сигурне https везе. ',
        'System Registration Data' => 'Подаци о регистрацији система',
        'Support Data' => 'Подаци подршке',

        # Template: AdminRole
        'Role Management' => 'Управљање улогама',
        'Add Role' => 'Додај Улогу',
        'Edit Role' => 'Уреди Улогу',
        'Filter for Roles' => 'Филтер за улоге',
        'Filter for roles' => 'Филтер за улоге',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Направи улогу и додај групе у њу. Онда додај улогу корисницима.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Нема дефинисаних улога. употребите дугме \'Add\' за креирање нове улоге.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Управљање везама улога-група',
        'Roles' => 'Улоге',
        'Select the role:group permissions.' => 'Изабери дозволе за улогу:групу',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Уколико ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни за ову улогу).',
        'Toggle %s permission for all' => 'Промени %s дозволе за све',
        'move_into' => 'премести у',
        'Permissions to move tickets into this group/queue.' => 'Дозволе да се тикети преместе у ову групу/ред.',
        'create' => 'креирај',
        'Permissions to create tickets in this group/queue.' => 'Дозвола да се тикет креира у ову групу/ред.',
        'note' => 'напомена',
        'Permissions to add notes to tickets in this group/queue.' => 'Дозволе за додавање напомена на тикете у овој групи/реду.',
        'owner' => 'власник',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Дозволе за промену власника тикета у овој групи/реду.',
        'priority' => 'приоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Дозвола да се мења приоритет тикета у овој групи/реду.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Управљање везама оператер-улога',
        'Add Agent' => 'Додај Оператера',
        'Filter for Agents' => 'Филтер за оператере',
        'Filter for agents' => 'Филтер за оператере',
        'Agents' => 'Оператери',
        'Manage Role-Agent Relations' => 'Управљање релацијама улога-оператер',

        # Template: AdminSLA
        'SLA Management' => 'Управљање SLA',
        'Edit SLA' => 'Уреди SLA',
        'Add SLA' => 'Додај SLA',
        'Filter for SLAs' => 'Филтер за SLA',
        'Please write only numbers!' => 'Молимо пишите само бројеве!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME управљање',
        'Add Certificate' => 'Додај сертификат',
        'Add Private Key' => 'Додај приватни кључ',
        'SMIME support is disabled' => 'SMIME подршка је онемогућена',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Да би могли да користите SMIME у OTOBO, морате је прво омогућити.',
        'Enable SMIME support' => 'Омогући SMIME подршку',
        'Faulty SMIME configuration' => 'Неисправна SMIME конфигурација',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME подршка ја омогућена али релевантна конфигурација садржи грешке. Молимо да проверите конфигурацију притиском на дугме испод.',
        'Check SMIME configuration' => 'Провери SMIME конфигурацију',
        'Filter for Certificates' => 'Филтер за сертификате',
        'Filter for certificates' => 'Филтер за сертификате',
        'To show certificate details click on a certificate icon.' => 'За приказивање детаља сертификата кликни на иконицу сертификат.',
        'To manage private certificate relations click on a private key icon.' =>
            'За управљање везама приватног сертификата кликните на иконицу приватни кључ.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Овде можете додати везе на ваш приватни сертификат, што ће бити уграђено у S/MIME потпис сваки пут кад употребите овај сертификат за потпис имејла.',
        'See also' => 'Погледај још',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'На овај начин можете директно да уређујете сертификате и приватне кључеве у систему датотека.',
        'Hash' => 'Hash',
        'Create' => 'Креирај',
        'Handle related certificates' => 'Руковање повезаним сертификатима',
        'Read certificate' => 'Читај сертификат',
        'Delete this certificate' => 'Обриши овај сертификат',
        'File' => 'Датотека',
        'Secret' => 'Тајна',
        'Related Certificates for' => 'Повезани сертификати за',
        'Delete this relation' => 'Обриши ову везу',
        'Available Certificates' => 'Расположиви сертификати',
        'Filter for S/MIME certs' => 'Филтер за S/MIME сертификате',
        'Relate this certificate' => 'Повежи овај сертификат',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME сертификат',
        'Certificate Details' => 'Детаљи сертификата',
        'Close this dialog' => 'Затвори овај дијалог',

        # Template: AdminSalutation
        'Salutation Management' => 'Управљање поздравима',
        'Add Salutation' => 'Додај Поздрав',
        'Edit Salutation' => 'Уреди Поздрав',
        'Filter for Salutations' => 'Филтер за поздраве',
        'Filter for salutations' => 'Филтер за поздраве',
        'e. g.' => 'нпр.',
        'Example salutation' => 'Пример поздрава',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'Потребно је да сигуран мод буде укључен!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Сигуран мод ће (уобичајено) бити подешен након иницијалне инсталације.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Уколико сигуран мод није активиран, покрените га кроз системску конфигурацију јер је ваша апликација већ покренута.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Бокс',
        'Filter for Results' => 'Филтер за резултате',
        'Filter for results' => 'Филтер за резултате',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Овде можете унети SQL команде и послати их директно апликационој бази података. Није могуће мењати садржај табела, дозвољен је једино \'select\' упит.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Овде можете унети SQL команде и послати их директно апликационој бази података.',
        'Options' => 'Опције',
        'Only select queries are allowed.' => 'Дозвољени су само \'select\' упити.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Постоји грешка у синтакси вашег SQL упита. Молимо проверите.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Најмање један параметар недостаје за повезивање. Молимо проверите.',
        'Result format' => 'Формат резултата',
        'Run Query' => 'Покрени упит',
        '%s Results' => '%s Резултати',
        'Query is executed.' => 'Упит је извршен.',

        # Template: AdminService
        'Service Management' => 'Управљање услугама',
        'Add Service' => 'Додај услугу',
        'Edit Service' => 'Уреди услугу',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Максимална дужина назива услуге је 200 карактера (са под-услугом).',
        'Sub-service of' => 'Под-услуга од',

        # Template: AdminSession
        'Session Management' => 'Управљање сесијама',
        'Detail Session View for %s (%s)' => 'Детаљни приказ сесије за %s (%s)',
        'All sessions' => 'Све сесије',
        'Agent sessions' => 'Сесије оператера',
        'Customer sessions' => 'Сесије клијената',
        'Unique agents' => 'Јединствени оператери',
        'Unique customers' => 'Јединствени клијенти',
        'Kill all sessions' => 'Угаси све сесије',
        'Kill this session' => 'Угаси ову сесију',
        'Filter for Sessions' => 'Филтер за сесије',
        'Filter for sessions' => 'Филтер за сесије',
        'Session' => 'Сесија',
        'Kill' => 'Угаси',
        'Detail View for SessionID: %s - %s' => 'Детаљни преглед за ID сесије: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Управљање потписима',
        'Add Signature' => 'Додај Потпис',
        'Edit Signature' => 'Уреди Потпис',
        'Filter for Signatures' => 'Филтер за потписе',
        'Filter for signatures' => 'Филтер за потписе',
        'Example signature' => 'Пример потписа',

        # Template: AdminState
        'State Management' => 'Управљање статусима',
        'Add State' => 'Додај Статус',
        'Edit State' => 'Уреди Статус',
        'Filter for States' => 'Филтер за стања',
        'Filter for states' => 'Филтер за стања',
        'Attention' => 'Пажња',
        'Please also update the states in SysConfig where needed.' => 'Молимо да ажурирате стаусе и у системској конфигурацији где је то потребно.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Ово стање се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност! ',
        'State type' => 'Тип статуса',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Није могуће обележити ову ставку као неважећу јер не постоји више статуса спојених тикета у систему!',
        'This state is used in the following config settings:' => 'Ово стање се користи у следећим системским подешавањима: ',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => 'Активирај сервисе у облаку',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Можете мануелно активирати слање подржаних података притискањем овог дугмета:',
        'Send Update' => 'Пошаљи ажурирање',
        'Currently this data is only shown in this system.' => 'Тренутно су ови подаци приказани само у овом систему.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Пакет за подршку (укључујући: информације о регистрацији система, податке за подршку, листу инсталираних пакета и свих локално модификованих датотека изворног кода) може бити генерисан притиском на ово дугме:',
        'Generate Support Bundle' => 'Генериши пакет подршке',
        'The Support Bundle has been Generated' => 'Пакет подршке је генерисан',
        'Please choose one of the following options.' => 'Молимо изаберите једну од понуђених опција.',
        'Send by Email' => 'Послато имејлом',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Пакет подршке је превелик за слање путем имејла, ова опција је онемогућена.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Имејл адреса овог корисника је неважећа, ова опција је искључена.',
        'Sending' => 'Слање',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => 'Преузми датотеку',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Подржани подаци не могу бити прикупљени (%s).',
        'Details' => 'Детаљи',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Управљање системском имејл адресом',
        'Add System Email Address' => 'Додај системску имејл адресу',
        'Edit System Email Address' => 'Уреди системску имејл адресу',
        'Add System Address' => 'Додај системску адресу',
        'Filter for System Addresses' => 'Филтер за системске адресе',
        'Filter for system addresses' => 'Филтер за системске адресе',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Све долазне поруке са овом адресом у пољу To или Cc биће отпремљене у изабрани ред.',
        'Email address' => 'Имејл адреса',
        'Display name' => 'Прикажи назив',
        'This email address is already used as system email address.' => 'Ова имејл адреса је већ употребљена као системска имејл адреса.',
        'The display name and email address will be shown on mail you send.' =>
            'Приказано име и имејл адреса ће бити приказани на поруци коју сте послали.',
        'This system address cannot be set to invalid.' => 'Ова системска адреса се не може означити као неважећа.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Ова системска адреса се не може означити као неважећа јер се користи у једном или више аутоматских одговора.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'приручника за администраторе',
        'System configuration' => 'Системска конфигурација',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Прегледајте доступна подешавањеа коришћењем навигације са леве стране.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Претражите одговарајућа подешавања коришћењем поља за претрагу испод или преко иконице за претрагу на горњој навигацији.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Сазнајте како да користите системску конфигурацију читањем %s.',
        'Search in all settings...' => 'Претражите сва подешавања...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Тренутно нема доступних подешавања. Молимо проверите да ли сте покренули скрипт \'otobo.Console.pl Maint::Config::Rebuild\' пре коришћења апликације.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Распоред промена',
        'Help' => 'Помоћ',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Ово је преглед свих подешавања која ће бити део распореда уколико га покренете. Моћете их упоредити са претходним стањем кликом на иконицу у горњем десном углу.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'За изузимање појединачних подешавања из распореда, активирајте кућицу у заглављу подешавања.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Подразумевано, биће распоређена само подешавања која сте ви изменили. Уколико желите да распоредите и подешавања измењена од стране других корисника, молимо кликните на везу при врху екрана за приступ екрану напредног распореда.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Распоред је обновљен, што значи да су сва подешавања постављена на вредности из одабраног распореда.',
        'Please review the changed settings and deploy afterwards.' => 'Молимо прегледајте измењена подешавања и распоредите их.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Празна листа промена значи да нема промена између обновљеног и тренутног стања вредности подешавања.',
        'Changes Overview' => 'Преглед промена',
        'There are %s changed settings which will be deployed in this run.' =>
            'Укупно %s промењених подешавања ће бити распоређено.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Пређите на основни мод за распоред подешавања које сте само ви променили.',
        'You have %s changed settings which will be deployed in this run.' =>
            'Имате %s промењених подешавања која ће бити распоређена.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Пређите на напредни мод за распоред подешавања које су променили и остали корисници.',
        'There are no settings to be deployed.' => 'Нема подешавања која се могу распоредити.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Прежите на напредни мод да видите која подешавања промењена од стране осталих корисника могу бити распоређена.',
        'Deploy selected changes' => 'Распореди означене промене',

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
        'by' => 'од',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Ова категорија не садржи ниједно подешавање. Молимо пробајте неку од под-група.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Увоз & извоз',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Отпремите датотеку за увоз у ваш систем (.yml формат извезен из модула системске конфигурације).',
        'Upload system configuration' => 'Отпреми системску конфигурацију',
        'Import system configuration' => 'Увези системску конфигурацију',
        'Download current configuration settings of your system in a .yml file.' =>
            'Преузмите тренутну конфигурацију вашег система као .yml датотеку.',
        'Include user settings' => 'Укључи корисничка подешавања',
        'Export current configuration' => 'Извези тренутну конфигурацију',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Тражи за',
        'Search for category' => 'Тражи за категорију',
        'Settings I\'m currently editing' => 'Подешавања која тренутно мењате',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Ваша претрага за "%s" у категорији "%s" није вратила резултате.',
        'Your search for "%s" in category "%s" returned one result.' => 'Ваша претрага за "%s" у категорији "%s" је вратила један резултат.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Ваша претрага за "%s" у категорији "%s" је вратила %s резултат(a).',
        'You\'re currently not editing any settings.' => 'Тренутно не мењате ниједно подешавање.',
        'You\'re currently editing %s setting(s).' => 'Тренутно мењате %s подешавање/а.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Категорија',
        'Run search' => 'Покрени претрагу',

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
        'View a custom List of Settings' => 'Преглед листе подешавања',
        'View single Setting: %s' => 'Преглед појединачног подешавања: %s',
        'Go back to Deployment Details' => 'Назад на детаље распоређивања',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Управљање системом одржавања',
        'Schedule New System Maintenance' => 'Планирај ново оржавање система.',
        'Filter for System Maintenances' => 'Филтер за одржавања система',
        'Filter for system maintenances' => 'Филтер за одржавања система',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Планирање периода одржавања система ради обавештавања оператера и клијената да је систем искључен у том периоду. ',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Неко време пре него отпочне одржавање система, корисници ће добити обавештење које најављује овај догађај на сваки екран.',
        'Stop date' => 'Датум завршетка',
        'Delete System Maintenance' => 'Обриши одржавање система',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Уреди одржавање система',
        'Edit System Maintenance Information' => 'Уреди одржавање система',
        'Date invalid!' => 'Неисправан датум',
        'Login message' => 'Порука пријаве',
        'This field must have less then 250 characters.' => 'Ово поље не сме бити дуже од 250 карактера.',
        'Show login message' => 'Покажи поруку пријаве',
        'Notify message' => 'Порука обавештења',
        'Manage Sessions' => 'Управљање сесијама',
        'All Sessions' => 'Све сесије',
        'Agent Sessions' => 'Сесије оператера',
        'Customer Sessions' => 'Сесије клијената',
        'Kill all Sessions, except for your own' => 'Прекини све сесије, осим сопствене',

        # Template: AdminTemplate
        'Template Management' => 'Управљање шаблонима',
        'Add Template' => 'Додај Шаблон',
        'Edit Template' => 'Уреди Шаблон',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Шаблон је подразумевани текст који помаже вашим агентима да брже испишу тикете, одговоре или прослеђене поруке.',
        'Don\'t forget to add new templates to queues.' => 'Не заборавите да додате нови шаблон у реду.',
        'Attachments' => 'Прилози',
        'Delete this entry' => 'Обриши овај унос',
        'Do you really want to delete this template?' => 'Да ли стварно желите да обришете овај шаблон?',
        'A standard template with this name already exists!' => 'Стандардни шаблон са овим називом већ постоји!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Креирај тип шаблона који подржавају само ове паметне ознаке.',
        'Example template' => 'Пример шаблона',
        'The current ticket state is' => 'Тренутни стаус тикета је',
        'Your email address is' => 'Ваша имејл адреса је',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Управљање релацијама шаблони-прилози',
        'Toggle active for all' => 'Промени стање у активан за све',
        'Link %s to selected %s' => 'Повежи %s са изабраним %s',

        # Template: AdminType
        'Type Management' => 'Управљање типовима',
        'Add Type' => 'Додај Тип ',
        'Edit Type' => 'Уреди Тип',
        'Filter for Types' => 'Филтер за типове',
        'Filter for types' => 'Филтер за типове',
        'A type with this name already exists!' => 'Тип са овим називом већ постоји!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Овај тип се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'This type is used in the following config settings:' => 'Овај тип се користи у следећим системским подешавањима:',

        # Template: AdminUser
        'Agent Management' => 'Управљање оператерима',
        'Edit Agent' => 'Уреди Оператера',
        'Edit personal preferences for this agent' => 'Уредите лична подешавања за овог оператера',
        'Agents will be needed to handle tickets.' => 'Биће потребни оператери за обраду тикета.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Не заборавите да додате новог оператера у групе и/или улоге!',
        'Please enter a search term to look for agents.' => 'Молимо унесите појам за претрагу ради налажења оператера.',
        'Last login' => 'Претходна пријава',
        'Switch to agent' => 'Пређи на оператера',
        'Title or salutation' => 'Наслов поздрава',
        'Firstname' => 'Име',
        'Lastname' => 'Презиме',
        'A user with this username already exists!' => 'Ово корисничко име је већ употребљено!',
        'Will be auto-generated if left empty.' => 'Биће аутоматски генерисано ако се остави празно.',
        'Mobile' => 'Мобилни',
        'Effective Permissions for Agent' => 'Ефективне дозоле за оператера',
        'This agent has no group permissions.' => 'Овај оператер нема дозволе за групе.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'Табела изнад приказује ефективне дозволе за групе оператера. Матрица узима у обзир све наслеђене дозволе (нпр. путем улога).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Управљање релацијама оператер-група',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Преглед дневног реда',
        'Manage Calendars' => 'Управљање календарима',
        'Add Appointment' => 'Додај термин',
        'Today' => 'Данас',
        'All-day' => 'Целодневно',
        'Repeat' => 'Понављање',
        'Notification' => 'Обавештење',
        'Yes' => 'Да',
        'No' => 'Не',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Није пронађен ниједан календар. Молимо прво додајте календар коришћењем екрана Управљање календарима.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Додај нови термин',
        'Calendars' => 'Календари',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Основне информације',
        'Date/Time' => 'Датум/време',
        'Invalid date!' => 'Неважећи датум!',
        'Please set this to value before End date.' => 'Молимо поставите овај датум пре краја.',
        'Please set this to value after Start date.' => 'Молимо поставите овај датум после почетка.',
        'This an occurrence of a repeating appointment.' => 'Ово је термин који се понавља.',
        'Click here to see the parent appointment.' => 'Кликните овде за преглед матичног термина.',
        'Click here to edit the parent appointment.' => 'Кликните овде за измену матичног термина.',
        'Frequency' => 'Учесталост',
        'Every' => 'Сваког(е)',
        'day(s)' => 'дан(и)',
        'week(s)' => 'недеља(е)',
        'month(s)' => 'месец(и)',
        'year(s)' => 'година(е)',
        'On' => 'Укључено',
        'Monday' => 'понедељак',
        'Mon' => 'пон',
        'Tuesday' => 'уторак',
        'Tue' => 'уто',
        'Wednesday' => 'среда',
        'Wed' => 'сре',
        'Thursday' => 'четвртак',
        'Thu' => 'чет',
        'Friday' => 'петак',
        'Fri' => 'пет',
        'Saturday' => 'субота',
        'Sat' => 'суб',
        'Sunday' => 'недеља',
        'Sun' => 'нед',
        'January' => 'јануар',
        'Jan' => 'Јан',
        'February' => 'фебруар',
        'Feb' => 'Феб',
        'March' => 'март',
        'Mar' => 'Мар',
        'April' => 'април',
        'Apr' => 'Апр',
        'May_long' => 'мај',
        'May' => 'Мај',
        'June' => 'јун',
        'Jun' => 'Јун',
        'July' => 'јул',
        'Jul' => 'Јул',
        'August' => 'август',
        'Aug' => 'Авг',
        'September' => 'септембар',
        'Sep' => 'Сеп',
        'October' => 'октобар',
        'Oct' => 'Окт',
        'November' => 'новембар',
        'Nov' => 'Нов',
        'December' => 'децембар',
        'Dec' => 'Дец',
        'Relative point of time' => 'Релативно време',
        'Link' => 'Повежи',
        'Remove entry' => 'Уклони унос',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Клијентски информативни центар',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Клијент корисник',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Напомена: клијент је неважећи!',
        'Start chat' => 'Почни ћаскање',
        'Video call' => 'Видео позив',
        'Audio call' => 'Аудио позив',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Адресар клијент корисника',
        'Search for recipients and add the results as \'%s\'.' => 'Претражите за примаоце и додајте резултате као \'%s\'.',
        'Search template' => 'Шаблон претраге',
        'Create Template' => 'Направи шаблон',
        'Create New' => 'Направи нов',
        'Save changes in template' => 'Сачувај промене у шаблону',
        'Filters in use' => 'Филтери у употреби',
        'Additional filters' => 'Додатни филтери',
        'Add another attribute' => 'Додај још један атрибут',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Атрибути са идентификатором \'(Customer)\' долазе из клијент фирми.',
        '(e. g. Term* or *Term*)' => '(нпр. Term* или *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Изабери све',
        'The customer user is already selected in the ticket mask.' => 'Клијент корисник је већ одабран у форми тикета.',
        'Select this customer user' => 'Означи овог клијент корисника',
        'Add selected customer user to' => 'Додај означеног клијент корисника у',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Промени опције претраге',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Клијент-кориснички информативни центар',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO сервис је системски процес који извршава асинхроне послове, нпр. окидање ескалација тикета, слање имејлова, итд.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Покренут OTOBO системски сервис је неопходан за исправно функционисање система.',
        'Starting the OTOBO Daemon' => 'Покретање OTOBO системског сервиса',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Осигурава да датотека \'%s\' постоји (без .dist екстензије). Овај крон посао ће проверавати сваких 5 минута да ли OTOBO системски сервис ради и покреће га ако је потребно.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Извршите \'%s start\' да би били сигурни да су крон послови за OTOBO корисника увек активни.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'После 5 минута, проверава да ли OTOBO системски сервис функционише у систему (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Командна табла',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Нови термин',
        'Tomorrow' => 'Сутра',
        'Soon' => 'Ускоро',
        '5 days' => '5 дана',
        'Start' => 'Почетак',
        'none' => 'ни један',

        # Template: AgentDashboardCalendarOverview
        'in' => 'у',

        # Template: AgentDashboardCommon
        'Save settings' => 'Сачувај подешавања',
        'Close this widget' => 'Затвори овај додатак',
        'more' => 'још',
        'Available Columns' => 'Расположиве колоне',
        'Visible Columns (order by drag & drop)' => 'Видљиве колоне (редослед према превуци и пусти)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Промени релације клијената',
        'Open' => 'Отворено',
        'Closed' => 'Затворени',
        '%s open ticket(s) of %s' => '%s отворених тикета од %s',
        '%s closed ticket(s) of %s' => '%s затворених тикета од %s',
        'Edit customer ID' => 'Уреди ID клијента',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Ескалирани тикети',
        'Open tickets' => 'Отворени тикети',
        'Closed tickets' => 'Затворени тикети',
        'All tickets' => 'Сви тикети',
        'Archived tickets' => 'Архивирани тикети',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Напомена: клијент корисник је неважећи!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Информације о клијент кориснику',
        'Phone ticket' => 'Тикет позива',
        'Email ticket' => 'Имејл тикет',
        'New phone ticket from %s' => 'Нови тикет позива од %s',
        'New email ticket to %s' => 'Нови имејл тикет од %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s је доступан!',
        'Please update now.' => 'Молимо ажурирајте сада.',
        'Release Note' => 'Напомена уз издање',
        'Level' => 'Ниво',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Послато пре %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Конфигурација за овај статистички додатак садржи грешке, молимо проверите ваша подешавања.',
        'Download as SVG file' => 'Преузми као SVG датотеку',
        'Download as PNG file' => 'Преузми као PNG датотеку',
        'Download as CSV file' => 'Преузми као CSV датотеку',
        'Download as Excel file' => 'Преузми као Excel датотеку',
        'Download as PDF file' => 'Преузми као PDF датотеку',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Молимо да у конфигурацији овог додатка изаберете важећи излазни формат графикона.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Садржај ове статистике се припрема за вас, молимо будите стрпљиви.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Ова статистика се тренутно не може користити зато што администратор статистике треба да коригује њену конфигурацију.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Додељени клијент корисник',
        'Accessible for customer user' => 'Дозвољен приступ за клијент корисника',
        'My locked tickets' => 'Моји закључани тикети',
        'My watched tickets' => 'Моји праћени тикети',
        'My responsibilities' => 'Одговоран сам за',
        'Tickets in My Queues' => 'Тикети у мојим редовима',
        'Tickets in My Services' => 'Тикети у мојим услугама',
        'Service Time' => 'Време услуге',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Укупно',

        # Template: AgentDashboardUserOnline
        'out of office' => 'ван канцеларије',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'dok',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Назад',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Да би прихватили неке вести, дозволе или неке промене.',
        'Yes, accepted.' => 'Да, прихваћено.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Уреди везе за %s',
        'Create new links' => 'Направи нове везе',
        'Manage existing links' => 'Уреди постојеће везе',
        'Link with' => 'Повежи са',
        'Start search' => 'Започни претрагу',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Тренутно нема веза. Молимо кликните на \'Додај нове везе\' при врху да бисте повезали овај објекат са осталим.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Промена лозинке',
        'Current password' => 'Садашња лозинка',
        'New password' => 'Нова лозинка',
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
        'Edit your preferences' => 'Уреди личне поставке',
        'Personal Preferences' => 'Лична подешавања',
        'Preferences' => 'Подешавања',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Напомена: тренутно мењате подешавања од %s.',
        'Go back to editing this agent' => 'Назад на уређивање овог оператера',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Подесите своја лична подешавања. Сачувајте свако подешавање штиклирањем са десне стране.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Можете користити навигацију испод за приказ подешавања која припадају одређеним групама.',
        'Dynamic Actions' => 'Динамичке акције',
        'Filter settings...' => 'Изфилтрирајте подешавања...',
        'Filter for settings' => 'Филтер за подешавања',
        'Save all settings' => 'Сачувајте сва подешавања',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Приказ аватар сличице је онемогућен од стране систем администратора. Уместо сличице биће приказани ваши иницијали.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Вашу аватар сличицу можете променити регистрацијом ваше имејл адресе %s на %s. Молимо обратите пажњу да је због кеширања неопходно да прође неко време пре него што ваш нови аватар постане видљив.',
        'Off' => 'Искључено',
        'End' => 'Крај',
        'This setting can currently not be saved.' => 'Ово подешавање тренутно не може бити сачувано.',
        'This setting can currently not be saved' => 'Ово подешавање тренутно не може бити сачувано',
        'Save this setting' => 'Сачувај ово подешавање',
        'Did you know? You can help translating OTOBO at %s.' => 'Да ли сте знали? Можете да помогнете у превођењу OTOBO на %s.',

        # Template: SettingsList
        'Reset to default' => 'Поништи на подразумевану вредност',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Изаберите групу са десне стране за приказ подешавања доступних за промене.',
        'Did you know?' => 'Да ли сте знали?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Вашу аватар сличицу можете променити регистрацијом ваше имејл адресе %s на %s',

        # Template: AgentSplitSelection
        'Target' => 'Циљ',
        'Process' => 'Процес',
        'Split' => 'Подели',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Управљање статистикама',
        'Add Statistics' => 'Додај статистику',
        'Read more about statistics in OTOBO' => 'Прочитајте више о статистикама у OTOBO',
        'Dynamic Matrix' => 'Динамичка матрица',
        'Each cell contains a singular data point.' => 'Свака ћелија садржи појединачни податак.',
        'Dynamic List' => 'Динамичка листа',
        'Each row contains data of one entity.' => 'Сваки ред садржи податке појединачног објекта.',
        'Static' => 'Статички',
        'Non-configurable complex statistics.' => 'Комплексне статистике које није могуће конфигурисати.',
        'General Specification' => 'Општа спецификација',
        'Create Statistic' => 'Креирај статистику',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Уређивање статистика',
        'Run now' => 'Покрени сад',
        'Statistics Preview' => 'Преглед статистике',
        'Save Statistic' => 'Сачувај статистику',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Увоз статистика',
        'Import Statistics Configuration' => 'Увези конфигурацију статистике',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Статистике',
        'Run' => 'Покрени',
        'Edit statistic "%s".' => 'Измени статистику "%s".',
        'Export statistic "%s"' => 'Извези статистику "%s"',
        'Export statistic %s' => 'Измени статистику %s',
        'Delete statistic "%s"' => 'Обриши статистику "%s"',
        'Delete statistic %s' => 'Обриши статистику %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Преглед статистика',
        'View Statistics' => 'Преглед статистика',
        'Statistics Information' => 'Информације о статистици',
        'Created by' => 'Креирао',
        'Changed by' => 'Изменио',
        'Sum rows' => 'Збир редова',
        'Sum columns' => 'Збир колона',
        'Show as dashboard widget' => 'Прикажи као додатак контролне табле',
        'Cache' => 'Кеш',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Ова статистика садржи конфигурационе грешке и сад се не може користити.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Промени слободни текст за %s%s%s',
        'Change Owner of %s%s%s' => 'Промени власника за %s%s%s',
        'Close %s%s%s' => 'Затвори %s%s%s',
        'Add Note to %s%s%s' => 'Додај напомену %s%s%s',
        'Set Pending Time for %s%s%s' => 'Постави време чекања за %s%s%s',
        'Change Priority of %s%s%s' => 'Промени приоритет за %s%s%s',
        'Change Responsible of %s%s%s' => 'Промени одговорног за %s%s%s',
        'The ticket has been locked' => 'Тикет је закључан.',
        'Undo & close' => 'Одустани & затвори',
        'Ticket Settings' => 'Подешавање тикета',
        'Queue invalid.' => 'Неважећи ред.',
        'Service invalid.' => 'Неважећа услуга.',
        'SLA invalid.' => 'Неважећи SLA.',
        'New Owner' => 'Нови власник',
        'Please set a new owner!' => 'Молимо да одредите новог власника!',
        'Owner invalid.' => ' Неважећи власник.',
        'New Responsible' => 'Нови одговорни',
        'Please set a new responsible!' => 'Молимо да одредите новог одговорног!',
        'Responsible invalid.' => 'Неважећи одговоран.',
        'Next state' => 'Следећи статус',
        'State invalid.' => 'Неважеће стање.',
        'For all pending* states.' => 'За сва стања* чекања.',
        'Add Article' => 'Додај чланак',
        'Create an Article' => 'Креирај чланак',
        'Inform agents' => 'Обавести оператере',
        'Inform involved agents' => 'Обавести укључене оператере',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Овде можете изабрати додатне оператере који треба да примају обавештења у вези са новим чланком.',
        'Text will also be received by' => 'Текст ће такође примити и:',
        'Text Template' => 'Шаблон текста',
        'Setting a template will overwrite any text or attachment.' => 'Подешавање шаблона ће преписати сваки текст или прилог.',
        'Invalid time!' => 'Неважеће време!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Одбаци %s%s%s',
        'Bounce to' => 'Преусмери на',
        'You need a email address.' => 'Потребна вам је имејл адреса.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Исправна имејл адреса је неопходна, али не користите локалну адресу!',
        'Next ticket state' => 'Наредни статус тикета',
        'Inform sender' => 'Обавести пошиљаоца',
        'Send mail' => 'Пошаљи имејл!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Масовне акције на тикетима',
        'Send Email' => 'Пошаљи имејл',
        'Merge' => 'Споји',
        'Merge to' => 'Обједини са',
        'Invalid ticket identifier!' => 'Неважећи идентификатор тикета!',
        'Merge to oldest' => 'Обједини са најстаријом',
        'Link together' => 'Повежи заједно',
        'Link to parent' => 'Повежи са надређеним',
        'Unlock tickets' => 'Откључај тикете',
        'Execute Bulk Action' => 'Изврши масовну акцију',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Напиши одговор за %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ова адреса је регистрована као системска и не може бити коришћена: %s',
        'Please include at least one recipient' => 'Молимо да укључите бар једног примаоца',
        'Select one or more recipients from the customer user address book.' =>
            'Одаберите једног или више примаоца из адресара клијент корисника.',
        'Customer user address book' => 'Адресар клијент корисника',
        'Remove Ticket Customer' => 'Уклони клијент са тикета **',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Молимо да уклоните овај унос и унесете нов са исправном вредношћу.',
        'This address already exists on the address list.' => 'Ова адреса већ постоји у листи.',
        'Remove Cc' => 'Уклони Cc',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Уклони Bcc',
        'Date Invalid!' => 'Неисправан датум!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Промени клијента за %s%s%s',
        'Customer Information' => 'Информације о клијенту',
        'Customer user' => 'Клијент корисник',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Отвори нови имејл тикет',
        'Example Template' => 'Пример шаблона',
        'To customer user' => 'За клијента корисника',
        'Please include at least one customer user for the ticket.' => 'Молимо вас укључите барем једног клијента корисника за тикет.',
        'Select this customer as the main customer.' => 'Означи овог клијента као главног клијента.',
        'Remove Ticket Customer User' => 'Уклони тикет клијента корисника **',
        'From queue' => 'из реда',
        'Get all' => 'Узми све',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Одлазни имејл за %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Пошаљи поново имејл за %s %s %s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Тикет %s: време одзива је истекло (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Тикет %s: време одзива ће истећи за %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Тикет %s: време ажурирања је преко (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Тикет %s: време ажурирања истиче за %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Тикет %s: време решавања је истекло (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Тикет %s: време решавања истиче за %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Проследи %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Историјат од %s%s%s',
        'Filter for history items' => 'Филтер за ставке историјата',
        'Expand/collapse all' => 'Прошири/скупи све',
        'CreateTime' => 'Време креирања',
        'Article' => 'Чланак',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Споји %s%s%s',
        'Merge Settings' => 'Подешавања спајања',
        'You need to use a ticket number!' => 'Молимо вас да користите број тикета!',
        'A valid ticket number is required.' => 'Неопходан је исправан број тикета.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Унесите део броја или наслова тикета за претрагу.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Ограничите претрагу на тикете са истим ID клијента (%s).',
        'Inform Sender' => 'Обавести пошиљаоца',
        'Need a valid email address.' => 'Потребна је исправна имејл адреса.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Премести %s%s%s',
        'New Queue' => 'Нови Ред',
        'Move' => 'Премести',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Нису нађени подаци о тикету',
        'Open / Close ticket action menu' => 'Акциони мени Отварања / Затварања тикета',
        'Select this ticket' => 'Изаберите овај тикет',
        'Sender' => 'Пошиљаоц',
        'First Response Time' => 'Време првог одговора',
        'Update Time' => 'Време ажурирања',
        'Solution Time' => 'Време решавања',
        'Move ticket to a different queue' => 'Премести тикет у други ред',
        'Change queue' => 'Промени ред',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Уклони активне филтере за овај екран.',
        'Tickets per page' => 'Тикета по страни',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Недостаје канал',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Поништи преглед',
        'Column Filters Form' => 'Форма филтера колона',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Подели у нови тикет позива',
        'Save Chat Into New Phone Ticket' => 'Сачувај ћаскање у нови тикет позива',
        'Create New Phone Ticket' => 'Отвори нови тикет позива',
        'Please include at least one customer for the ticket.' => 'Молимо да укључите бар једног клијента за тикет.',
        'To queue' => 'У ред',
        'Chat protocol' => 'Протокол ћаскања',
        'The chat will be appended as a separate article.' => 'Ћаскање ће бити додато као посебан чланак.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Позив за %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Приказ имејла као обичан текст за %s%s%s',
        'Plain' => 'Неформатирано',
        'Download this email' => 'Preuzmi ovu poruku',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Направи нови процес тикет',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Прикључи тикет процесу',

        # Template: AgentTicketSearch
        'Profile link' => 'Веза профила',
        'Output' => 'Преглед резултата',
        'Fulltext' => 'Текст',
        'Customer ID (complex search)' => 'ID клијента (сложена претрага)',
        '(e. g. 234*)' => '(нпр. 234*)',
        'Customer ID (exact match)' => 'ID клијента (тачно поклапање)',
        'Assigned to Customer User Login (complex search)' => 'Додељено клијент кориснику (сложена претрага)',
        '(e. g. U51*)' => '(нпр.  U51*)',
        'Assigned to Customer User Login (exact match)' => 'Додељено клијент кориснику (тачно поклапање)',
        'Accessible to Customer User Login (exact match)' => 'Видљиво клијент кориснику (тачно поклапање)',
        'Created in Queue' => 'Отворено у реду',
        'Lock state' => 'Стаус закључавања',
        'Watcher' => 'Праћење',
        'Article Create Time (before/after)' => 'Време креирања чланка (пре/после)',
        'Article Create Time (between)' => 'Време креирања чланка (између)',
        'Please set this to value before end date.' => 'Молимо поставите овај датум пре краја.',
        'Please set this to value after start date.' => 'Молимо поставите овај датум после почетка.',
        'Ticket Create Time (before/after)' => 'Време отварања тикета (пре/после)',
        'Ticket Create Time (between)' => 'Време отварања тикета (између)',
        'Ticket Change Time (before/after)' => 'Време промене тикета (пре/после)',
        'Ticket Change Time (between)' => 'Време промене тикета (између)',
        'Ticket Last Change Time (before/after)' => 'Време последње промене тикета (пре/после)',
        'Ticket Last Change Time (between)' => 'Време последње промене тикета (између)',
        'Ticket Pending Until Time (before/after)' => 'Време тикета на чекању (пре/после)',
        'Ticket Pending Until Time (between)' => 'Време тикета на чекању (између)',
        'Ticket Close Time (before/after)' => 'Време затварања тикета (пре/после)',
        'Ticket Close Time (between)' => 'Време затварања тикета (између)',
        'Ticket Escalation Time (before/after)' => 'Време ескалације тикета (пре/после)',
        'Ticket Escalation Time (between)' => 'Време ескалације тикета (између)',
        'Archive Search' => 'Претрага архива',

        # Template: AgentTicketZoom
        'Sender Type' => 'Тип пошиљаоца',
        'Save filter settings as default' => 'Сачувај подешавања филтера као подразумевана',
        'Event Type' => 'Тип догађаја',
        'Save as default' => 'Сачувај као подразумевано',
        'Drafts' => 'Нацрти',
        'Change Queue' => 'Промени Ред',
        'There are no dialogs available at this point in the process.' =>
            'У овом тренутку нема слободних дијалога у процесу.',
        'This item has no articles yet.' => 'Ова ставка још увек нема члканке.',
        'Ticket Timeline View' => 'Преглед тикета на временској линији',
        'Article Overview - %s Article(s)' => 'Преглед чланака - %s чланак(а)',
        'Page %s' => 'Страна %s',
        'Add Filter' => 'Додај Филтер',
        'Set' => 'Подеси',
        'Reset Filter' => 'Ресетуј Филтер',
        'No.' => 'Бр.',
        'Unread articles' => 'Непрочитани чланци',
        'Via' => 'Преко',
        'Important' => 'Важно',
        'Unread Article!' => 'Непрочитани Чланци!',
        'Incoming message' => 'Долазна порука',
        'Outgoing message' => 'Одлазна порука',
        'Internal message' => 'Интерна порука',
        'Sending of this message has failed.' => 'Слање ове поруке није успело.',
        'Resize' => 'Промена величине',
        'Mark this article as read' => 'Означи овај чланак као прочитан',
        'Show Full Text' => 'Прикажи цео текст',
        'Full Article Text' => 'Текст целог чланка',
        'No more events found. Please try changing the filter settings.' =>
            'Нема више догађаја. Покушајте да промените подешавања филтера.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'преко %s',
        'by %s' => 'од стране %s',
        'Toggle article details' => 'Преклопи детаље чланка',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Ова порука се процесира. Слање је покушано већ %s пут(а). Следећи покушај биће у %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Да отворите везе у овом чланку, можда ћете морати да притиснете Ctrl или Cmd или Shift тастер док кликнете на везу (зависи од вашег прегледача и оперативног система). ',
        'Close this message' => 'Затвори ову поруку',
        'Image' => 'Слика',
        'PDF' => 'PDF',
        'Unknown' => 'Непознато',
        'View' => 'Преглед',

        # Template: LinkTable
        'Linked Objects' => 'Повезани објекти',

        # Template: TicketInformation
        'Archive' => 'Архивирај',
        'This ticket is archived.' => 'Овај тикет је архивиран',
        'Note: Type is invalid!' => 'Напомена: тип је неважећи!',
        'Pending till' => 'На чекању до',
        'Locked' => 'Закључано',
        '%s Ticket(s)' => '%s тикет(а)',
        'Accounted time' => 'Обрачунато време',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'Преглед овог чланка није могућ јер %s канал недостаје у систему.',
        'Please re-install %s package in order to display this article.' =>
            'Молимо поново инсталирајте пакет %s за приказ овог чланка.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Да бисте заштитили своју приватност, удаљени садржај је блокиран.',
        'Load blocked content.' => 'Учитај блокирани садржај.',

        # Template: Breadcrumb
        'Home' => 'Почетна',
        'Back to admin overview' => 'Назан на администраторски преглед',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Ова функција захтева сервисе у облаку',
        'You can' => 'Ви можете',
        'go back to the previous page' => 'иди на претходну страну',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'ID клијента не може бити промењен, ниједан други ID не може бити додељен овом тикету.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Прво одаберите клијент корисника, онда можете одабрати ID клијента за доделу овом тикету.',
        'Select a customer ID to assign to this ticket.' => 'Одаберите ID клијента за доделу овом тикету.',
        'From all Customer IDs' => 'Из листе свих ID клијента',
        'From assigned Customer IDs' => 'Из листе додељених ID клијента',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => 'Нови тикет',

        # Template: CustomerError
        'An Error Occurred' => 'Догодила се грешка',
        'Error Details' => 'Детаљи грешке',
        'Traceback' => 'Испрати уназад',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s је детектовао могуће проблеме са вашом мрежном везом. Можете покушати да ручно освежите ову страницу или да сачекате да ваш прегледач сам поново успостави везу.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Веза је поново успостављена након привременог прекида. Због тога, елементи на овој страници су могли да престану да коректно функционишу. Да би све елементе могли поново нормално да користите, препоручујемо обавезно освежавање ове странице. ',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript није доступан.',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Како би сте користили апликацију, неопходно је да активирате JavaScript у вашем веб претраживачу.',
        'Browser Warning' => 'Упозорење веб претраживача',
        'The browser you are using is too old.' => 'Веб претраживач који користите је превише стар.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Ова апликација функционише на великом броју веб претраживача, молимо да инсталирате и користите један од ових.',
        'Please see the documentation or ask your admin for further information.' =>
            'Молимо да прегледате документацију или питате вашег администратора за додатне информације.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'Сачекајте моменат, бићете преусмерени...',
        'Login' => 'Пријављивање',
        'Your user name' => 'Ваше корисничко име',
        'User name' => 'Корисничко име',
        'Your password' => 'Ваша лозинка',
        'Forgot password?' => 'Заборавили сте лозинку?',
        'Your 2 Factor Token' => 'Ваш двофакторски токен',
        '2 Factor Token' => 'Двофакторски токен',
        'Log In' => 'Пријављивање',
        'Request Account' => '',
        'Request New Password' => 'Захтев за нову лозинку',
        'Your User Name' => 'Ваше корисничко име',
        'A new password will be sent to your email address.' => 'Нова лозинка ће бити послата на вашу имејл адресу.',
        'Create Account' => 'Креирајте налог',
        'Please fill out this form to receive login credentials.' => 'Молимо да попуните овај образац да би сте добили податке за пријаву.',
        'How we should address you' => 'Како да вас ословљавамо',
        'Your First Name' => 'Ваше име',
        'Your Last Name' => 'Ваше презиме',
        'Your email address (this will become your username)' => 'Ваша имејл адреса (то ће бити ваше корисничко име)',

        # Template: CustomerNavigationBar
        'Logout' => 'Одјава',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Добродошли!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Споразум о нивоу услуге',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Страна',
        'Tickets' => 'Тикети',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Профил',
        'e. g. 10*5155 or 105658*' => 'нпр. 10*5155 или 105658*',
        'CustomerID' => 'ID клијента',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Текстуално претраживање у тикетима (нпр. "John*n" или "Will*")',
        'Types' => 'Типови',
        'Time Restrictions' => 'Временска ограничења',
        'No time settings' => 'Нема подешавања времена',
        'All' => 'Све',
        'Specific date' => 'Одређени датум',
        'Only tickets created' => 'Само креирани тикети',
        'Date range' => 'Распон датума',
        'Only tickets created between' => 'Само тикети креирани између',
        'Ticket Archive System' => 'Систем за архивирање тикета',
        'Save Search as Template?' => 'Сачувај претрагу као шаблон?',
        'Save as Template?' => 'Сачувати као шаблон?',
        'Save as Template' => 'Сачувај као шаблон',
        'Template Name' => 'Назив шаблона',
        'Pick a profile name' => 'Изабери назив профила',
        'Output to' => 'Излаз на',

        # Template: CustomerTicketSearchResultShort
        'of' => 'од',
        'Search Results for' => 'Резултати претраживања за',
        'Remove this Search Term.' => 'Уклони овај израз за претрагу.',

        # Template: CustomerTicketZoom
        'Reply' => 'Одговори',
        'Discard' => '',
        'Ticket Information' => 'Информације о тикету',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => 'Рашири чланак',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Упозорење',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Информације о догађају',
        'Ticket fields' => 'Поља тикета',

        # Template: Error
        'Send a bugreport' => 'Пошаљи извештај о грешци',
        'Expand' => 'Прошири',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Кликните овде да обришете прилог.',

        # Template: DraftButtons
        'Update draft' => 'Aжурирај нацрт',
        'Save as new draft' => 'Сачувај као нови нацрт',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Већ сте учитали нацрт "%s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Већ сте учитали нацрт "%s". Последњи пут сте га променили у %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Већ сте учитали нацрт "%s". Последњи пут је промењен у %s од стране %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Молимо обратите пажњу да је овај нацрт застарео јер је тикет модификован од када је нацрт креиран.',

        # Template: Header
        'Edit personal preferences' => 'Уреди личне поставке',
        'Personal preferences' => 'Лична подешавања',
        'You are logged in as' => 'Пријављени сте као',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nije dostupan.',
        'Step %s' => 'Корак %s',
        'License' => 'Лиценца',
        'Database Settings' => 'Подешавање базе података',
        'General Specifications and Mail Settings' => 'Опште спецификације и подешавање поште',
        'Finish' => 'Заврши',
        'Welcome to %s' => 'Добродошли у %s',
        'Germany' => 'Немачка',
        'Phone' => 'Позив',
        'Switzerland' => '',
        'Web site' => 'Веб сајт',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Подешавање одлазне поште',
        'Outbound mail type' => 'Тип одлазне поште',
        'Select outbound mail type.' => 'Изаберите тип одлазне поште',
        'Outbound mail port' => 'Порт за одлазну пошту',
        'Select outbound mail port.' => 'Изаберите порт за одлазну пошту',
        'SMTP host' => 'SMTP сервер',
        'SMTP host.' => 'SMTP сервер.',
        'SMTP authentication' => 'SMTP аутентификација',
        'Does your SMTP host need authentication?' => 'Да ли ваш SMTP сервер захтева аутентификацију?',
        'SMTP auth user' => 'SMTP корисник',
        'Username for SMTP auth.' => 'Корисничко име за SMTP аутентификацију',
        'SMTP auth password' => 'Лозинка SMTP аутентификације',
        'Password for SMTP auth.' => 'Лозинка за SMTP аутентификацију',
        'Configure Inbound Mail' => 'Подешавање долазне поште',
        'Inbound mail type' => 'Тип долазне поште',
        'Select inbound mail type.' => 'Изабери тип долазне поште',
        'Inbound mail host' => 'Сервер долазне поште',
        'Inbound mail host.' => 'Сервер долазне поште.',
        'Inbound mail user' => 'Корисник долазне поште',
        'User for inbound mail.' => 'Корисник за долазну пошту.',
        'Inbound mail password' => 'Лозинка долазне поште',
        'Password for inbound mail.' => 'Лозинка за долазну пошту.',
        'Result of mail configuration check' => 'Резултат провере подешавања поште',
        'Check mail configuration' => 'Провери конфигурацију мејла',
        'Skip this step' => 'Прескочи овај корак',

        # Template: InstallerDBResult
        'Done' => 'Урађено',
        'Error' => 'Грешка',
        'Database setup successful!' => 'Успешно инсталирање базе',

        # Template: InstallerDBStart
        'Install Type' => 'Инсталирај тип',
        'Create a new database for OTOBO' => 'Креирај нову базу података за OTOBO',
        'Use an existing database for OTOBO' => 'Користи постојећу базу података за OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Ако сте поставили рут лозинку за вашу базу података, она мора бити унета овде. Ако нисте, ово поље оставите празно.',
        'Database name' => 'Назив базе података',
        'Check database settings' => 'Проверите подешавања базе',
        'Result of database check' => 'Резултат провере базе података',
        'Database check successful.' => 'Успешна провера базе података.',
        'Database User' => 'Корисник базе података',
        'New' => 'Ново',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Нови корисник базе са ограниченим правима ће бити креиран за овај OTOBO систем.',
        'Repeat Password' => 'Понови лозинку',
        'Generated password' => 'Генерисана лозинка',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Лозинке се не поклапају',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Да би сте користили OTOBO морате унети следеће у командну линију (Terminal/Shell) као root.',
        'Restart your webserver' => 'Поново покрените ваш веб сервер.',
        'After doing so your OTOBO is up and running.' => 'После овога ваш OTOBO је укључен и ради.',
        'Start page' => 'Početna strana',
        'Your OTOBO Team' => 'Ваш OTOBO тим',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Не прихватај лиценцу',
        'Accept license and continue' => 'Прихвати лиценцу и настави',

        # Template: InstallerSystem
        'SystemID' => 'Системски ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Системски идентификатор. Сваки број тикета и сваки ID HTTP сесије садржи овај број.',
        'System FQDN' => 'Sistemski FQDN',
        'Fully qualified domain name of your system.' => 'Пун назив домена вашег система',
        'AdminEmail' => 'Административни имејл',
        'Email address of the system administrator.' => 'Имејл адреса систем администратора.',
        'Organization' => 'Организација',
        'Log' => 'Лог',
        'LogModule' => 'Лог модул',
        'Log backend to use.' => 'Лог модул у употреби.',
        'LogFile' => 'Лог датотека',
        'Webfrontend' => 'Мрежни интерфејс',
        'Default language' => 'Подразумевани језик',
        'Default language.' => 'Подразумевани језик',
        'CheckMXRecord' => 'Провери MX податке',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ручно унета имејл адреса се проверава помоћу MX податка пронађеног у DNS. Немојте користити ову опцију ако је ваш DNS спор или не може да разреши јавне адресе.',

        # Template: LinkObject
        'Delete link' => 'Обриши везу',
        'Delete Link' => 'Обриши везу',
        'Object#' => 'Објекат#',
        'Add links' => 'Додај везе',
        'Delete links' => 'Обриши везе',

        # Template: Login
        'Lost your password?' => 'Изгубили сте лозинку?',
        'Back to login' => 'Назад на пријављивање',

        # Template: MetaFloater
        'Scale preview content' => 'Скалирај садржај за приказ',
        'Open URL in new tab' => 'Отвори УРЛ у новом листу',
        'Close preview' => 'Затвори преглед',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Преглед ове веб странице није могућ јер она не дозвољава да буде уграђена.',

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
        'Feature not Available' => 'Својство није доступно',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'На жалост, ово својство моментално није доступно за мобилне уређаје. Ако желите да га користите, можете де вратити на десктоп мод или користити стандардни десктоп уређај.',

        # Template: Motd
        'Message of the Day' => 'Данашња порука',
        'This is the message of the day. You can edit this in %s.' => 'Ово је дневна порука. Можете је уредити у %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Недовољна овлаштења',
        'Back to the previous page' => 'Вратите се на претходну страну',

        # Template: Alert
        'Alert' => 'Упозорење',
        'Powered by' => 'Покреће',

        # Template: Pagination
        'Show first page' => 'Покажи прву страну',
        'Show previous pages' => 'Покажи претходне стране',
        'Show page %s' => 'Покажи страну %s',
        'Show next pages' => 'Покажи следеће стране',
        'Show last page' => 'Покажи последњу страну',

        # Template: PictureUpload
        'Need FormID!' => 'Неопходан FormID!',
        'No file found!' => 'Датотека није пронађена!',
        'The file is not an image that can be shown inline!' => 'Датотека није слика која се може непосредно приказати!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Нису пронађена обавештења која корисник може да подеси.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Примите поруке за обавештавање \'%s\' пренете путем \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Информације о процесу',
        'Dialog' => 'Дијалог',

        # Template: Article
        'Inform Agent' => 'Обавести оператера',

        # Template: PublicDefault
        'Welcome' => 'Добродошли',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Ово је подразумевани јавни интерфејс за OTOBO! Нема датих акционих параметара.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Можете инсталирати додатни модул (видите управљање пакетима), нпр. FAQ, који има јавни интерфејс.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Дозволе',
        'You can select one or more groups to define access for different agents.' =>
            'Можете изабрати једну или више група за дефинисање приступа за различите оператере.',
        'Result formats' => 'Формат резултата',
        'Time Zone' => 'Временска зона',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Изабрани временски периоди у статистици су неутрални по питању временске зоне.',
        'Create summation row' => 'Креирај ред са збиром',
        'Generate an additional row containing sums for all data rows.' =>
            'Генериши додатни ред који садржи суме за све редове са подацима.',
        'Create summation column' => 'Креирај колону са збиром',
        'Generate an additional column containing sums for all data columns.' =>
            'Генериши додатну колону која садржи суме за све колоне са подацима.',
        'Cache results' => 'Кеширај резултате',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Чува резултате статистика у кешу за коришћење у следећим прегледима са истим подешавањима (захтева изабрано бар једно временско поље).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Омогући статистику као додатак који опертатери могу активирати у својој контролној табли.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Напомињемо да ће омогућавање додатка кеширати ову статистику на контролној табли.',
        'If set to invalid end users can not generate the stat.' => 'Ако је подешено на неважеће, крајњи корисници не могу генерисати статистику.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Постоје неки проблеми у подешавању ове статистике:',
        'You may now configure the X-axis of your statistic.' => 'Сада можете подесити X осу ваше статистике.',
        'This statistic does not provide preview data.' => 'Ова статистика не омогућава привремени приказ.',
        'Preview format' => 'Формат приказа',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Напомињемо да приказ користи насумично изабране податке и не узима у обзир филтере података.',
        'Configure X-Axis' => 'Подеси X осу',
        'X-axis' => 'Х-оса',
        'Configure Y-Axis' => 'Подеси Y осу',
        'Y-axis' => 'Y-оса',
        'Configure Filter' => 'Подеси филтер',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Молимо да изаберете само један елемент или искључите дугме \'фиксирано\'!',
        'Absolute period' => 'Апсолутни период',
        'Between %s and %s' => 'Између %s и %s',
        'Relative period' => 'Релативни период',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Комплетна прошлост %s и комплетна тренутна+будућа %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Онемогући промене овог елемента при генерисању статистике.',

        # Template: StatsParamsWidget
        'Format' => 'Формат',
        'Exchange Axis' => 'Замени осе',
        'Configurable Params of Static Stat' => 'Подесиви параметри статичке статистике',
        'No element selected.' => 'Није изабран ни један елемент.',
        'Scale' => 'Скала',
        'show more' => 'прикажи више',
        'show less' => 'прикажи мање',

        # Template: D3
        'Download SVG' => 'Преузми SVG',
        'Download PNG' => 'Преузме PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Одабрани временски период дефинише подразумеван временски оквир за прикупљање података статистике.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Дефинише временску јединицу која се користи за поделу изабраног временског периода у појединачне тачке на извештају.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Молимо запамтите, да скала за Y-осу треба да буде већа од скале за Х-осу (нпр. Х-Оса => месец; Y-оса => година).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Ово подешавање је искључено.',
        'This setting is fixed but not deployed yet!' => 'Ово подешавање је статичко, али није још распоређено!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Ово подешавање је тренутно прегажено у %s и не може бити измењено овде!',
        'Changing this setting is only available in a higher config level!' =>
            'Промена овог подешавања је могућа само у напредном конфигурационом моду.',
        '%s (%s) is currently working on this setting.' => '%s (%s) тренутно ради на овом подешавању.',
        'Toggle advanced options for this setting' => 'Преклопи напредне опције за ово подешавање',
        'Disable this setting, so it is no longer effective' => 'Искључи ово подешавање, тако да више није ефективно',
        'Disable' => 'Искључи',
        'Enable this setting, so it becomes effective' => 'Укључи ово подешавање, тако да постане ефективно',
        'Enable' => 'Укључи',
        'Reset this setting to its default state' => 'Поништи ово подешавање на подразумевану вредност',
        'Reset setting' => 'Поништи подешавање',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Омогући корисницима да мењају ово подешавање у њиховим личним подешавањима',
        'Allow users to update' => 'Дозволи корисницима да мењају',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Онемогући корисницима да мењају ово подешавање у њиховим личним подешавањима',
        'Forbid users to update' => 'Забрани корисницима да мењају',
        'Show user specific changes for this setting' => 'Прикажи корисничке промене за ово подешавање',
        'Show user settings' => 'Прикажи корисничке промене',
        'Copy a direct link to this setting to your clipboard' => 'Копирај директну везу за ово подешавање',
        'Copy direct link' => 'Копирај директну везу',
        'Remove this setting from your favorites setting' => 'Уклони ово подешавање из омиљених',
        'Remove from favourites' => 'Уклони из омиљених',
        'Add this setting to your favorites' => 'Додај ово подешавање у омиљена',
        'Add to favourites' => 'Додај у омиљене',
        'Cancel editing this setting' => 'Одустани од промене овог подешавања',
        'Save changes on this setting' => 'Сачувај промене за ово подешавање',
        'Edit this setting' => 'Промени ово подешавање',
        'Enable this setting' => 'Укључи ово подешавање',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Ова група не садржи ниједно подешавање. Молимо пробајте неку од под-група или другу групу.',

        # Template: SettingsListCompare
        'Now' => 'Сад',
        'User modification' => 'Корисничке промене',
        'enabled' => 'укључено',
        'disabled' => 'искључено',
        'Setting state' => 'Вредност подешавања',

        # Template: Actions
        'Edit search' => 'Уреди претрагу',
        'Go back to admin: ' => 'Назад на admin:',
        'Deployment' => 'Распоред',
        'My favourite settings' => 'Моја омиљена подешавања',
        'Invalid settings' => 'Неважећа подешавања',

        # Template: DynamicActions
        'Filter visible settings...' => 'Изфилтрирај видљива подешавања...',
        'Enable edit mode for all settings' => 'Промени сва подешавања',
        'Save all edited settings' => 'Сними сва промењена подешавања',
        'Cancel editing for all settings' => 'Одустани од промене свих подешавања',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Све акције из овог додатка се односе на видљива подешавања са десне стране.',

        # Template: Help
        'Currently edited by me.' => 'Тренутно мењате ви.',
        'Modified but not yet deployed.' => 'Промењено али нераспоређено.',
        'Currently edited by another user.' => 'Тренутно мења други корисник.',
        'Different from its default value.' => 'Разликује се од подразумеване вредности.',
        'Save current setting.' => 'Сачувај тренутно подешавање.',
        'Cancel editing current setting.' => 'Одустани од промене тренутног подешавања.',

        # Template: Navigation
        'Navigation' => 'Навигација',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO тест страна',
        'Unlock' => 'Откључај',
        'Welcome %s %s' => 'Добродошли %s %s',
        'Counter' => 'Бројач',

        # Template: Warning
        'Go back to the previous page' => 'Вратите се на претходну страну',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Прикажи',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Наслов нацрта',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Приказ чланака',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Да ли заиста желите да обришете "%s"?',
        'Confirm' => 'Потврди',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Учитавање, молимо сачекајте...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Кликните овде за отпремање датотеке.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Кликните да одаберете датотеке или их једноставно превуците овде.',
        'Click to select a file or just drop it here.' => 'Кликните да одаберете датотеку или је једноставно превуците овде.',
        'Uploading...' => 'Отпремање...',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => 'Стање процеса',
        'Running' => 'У току',
        'Finished' => 'Завршено',
        'No package information available.' => 'Нема информација о пакету.',

        # JS Template: AddButton
        'Add new entry' => 'Додај нов унос',

        # JS Template: AddHashKey
        'Add key' => 'Додај кључ',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Коментар распоређувања...',
        'This field can have no more than 250 characters.' => 'Ово поље не може садржати више од 250 карактера.',
        'Deploying, please wait...' => 'Распоређивање у току, молимо сачекајте...',
        'Preparing to deploy, please wait...' => 'Припрема за распоређивање, молимо сачекајте...',
        'Deploy now' => 'Распореди сад',
        'Try again' => 'Покушајте поново',

        # JS Template: DialogReset
        'Reset options' => 'Поништи подешавања',
        'Reset setting on global level.' => 'Поништи подешавање на глобалном нивоу.',
        'Reset globally' => 'Поништи глобално',
        'Remove all user changes.' => 'Поништи све корисничке промене.',
        'Reset locally' => 'Поништи локално',
        'user(s) have modified this setting.' => 'корисник(а) је је променило ово подешавање.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Да ли стварно желите да поништите ово подешавање на његову подразумевану вредност?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Можете одабрати категорију за ограничавање навигационих ставки испод. Чим одаберете категорију, навигација ће бити освежена.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'База података',
        'CustomerIDs' => 'ID-еви клијента',
        'Fax' => 'Факс',
        'Street' => 'Улица',
        'Zip' => 'ПБ',
        'City' => 'Место',
        'Country' => 'Држава',
        'Mr.' => 'Г-дин',
        'Mrs.' => 'Г-ђа',
        'Address' => 'Адреса',
        'View system log messages.' => 'Преглед порука системског лога.',
        'Edit the system configuration settings.' => 'Уреди подешавања системске конфигурације.',
        'Update and extend your system with software packages.' => 'Ажурирај и надогради систем софтверским пакетима.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL информације из базе података нису синхронизоване са системском конфигурацијом, молимо вас да примените све ACL листе.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACL листе не могу да се увезу због непознате грешке, молимо да проверите OTOBO логове за више информација',
        'The following ACLs have been added successfully: %s' => 'Следеће ACL листе су успешно додате: %s',
        'The following ACLs have been updated successfully: %s' => 'Следеће ACL листе су успешно ажуриране: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Постоје грешке у додавању/ажурирању следећих ACL: %s. Молимо проверите лог датотеку за више информација.',
        'There was an error creating the ACL' => 'Дошло је до грешке при креирању ACL',
        'Need ACLID!' => 'Неопходан ACLID!',
        'Could not get data for ACLID %s' => 'Не могу прибавити податке за ИД ACL листе %s',
        'There was an error updating the ACL' => 'Дошло је до грешке при ажурирању ACL',
        'There was an error setting the entity sync status.' => 'Дошло је до грешке приликом подешавања статуса синхронизације ентитета.',
        'There was an error synchronizing the ACLs.' => 'Дошло је до грешке при синхронизацији ACLs',
        'ACL %s could not be deleted' => 'ACL листу %s није могуће обрисати',
        'There was an error getting data for ACL with ID %s' => 'Дошло је до грешке приликом прибављања података за ACL листу са ИД %s',
        '%s (copy) %s' => '%s (копија) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Молимо обратите пажњу да ће ACL рестрикције бити игнорисане за супер-администраторски налог (UserID 1).',
        'Exact match' => 'Тачно поклапање',
        'Negated exact match' => 'Негирано тачно поклапање',
        'Regular expression' => 'Регуларни израз',
        'Regular expression (ignore case)' => 'Регуларни израз (игнориши величину слова)',
        'Negated regular expression' => 'Негирани регуларни израз',
        'Negated regular expression (ignore case)' => 'Негирани регуларни израз (игнориши величину слова)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Систем није успео да креира календар!',
        'Please contact the administrator.' => 'Молимо контактирајте администратора!',
        'No CalendarID!' => 'Нема CalendarID!',
        'You have no access to this calendar!' => 'Немате приступ овом календару!',
        'Error updating the calendar!' => 'Грешка приликом измене календара',
        'Couldn\'t read calendar configuration file.' => 'Учитавање конфигурације календара није било могуће.',
        'Please make sure your file is valid.' => 'Молимо вас да проверите да ли је ваш фајл исправан.',
        'Could not import the calendar!' => 'Није могућ увоз календара!',
        'Calendar imported!' => 'Календар је увезен!',
        'Need CalendarID!' => 'Неопходан CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Не могу прибавити податке за дати CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Успешно увезено %s термин(а) у календар %s.',
        '+5 minutes' => '+5 минута',
        '+15 minutes' => '+15 минута',
        '+30 minutes' => '+30 минута',
        '+1 hour' => '+1 сат',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Без дозволе',
        'System was unable to import file!' => 'Систем није успео да увезе фајл!',
        'Please check the log for more information.' => 'Молимо проверите лог за више информација.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Обавештење са овим називом већ постоји!',
        'Notification added!' => 'Обавештење додато!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Дошло је до грешке приликом прибављања података за ID обавештења:%s!',
        'Unknown Notification %s!' => 'Непознато обавештење %s!',
        '%s (copy)' => '%s (копија)',
        'There was an error creating the Notification' => 'Дошло је до грешке приликом креирања обавештења',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Обавештења не могу да се увезу због непознате грешке, молимо да проверите OTOBO логове за више информација',
        'The following Notifications have been added successfully: %s' =>
            'Следећа обавештења су успешно додата: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Следећа обавештења су успешно ажурирана: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Постоје грешке у додавању/ажурирању следећих обавештења: %s. Молимо проверите лог датотеку за више информација.',
        'Notification updated!' => 'Обавештење ажурирано!',
        'Agent (resources), who are selected within the appointment' => 'Оператер (ресурс), који је изабран у термину',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Сви оператери са (најмање) дозволом прегледа термина (календара)',
        'All agents with write permission for the appointment (calendar)' =>
            'Сви оператери са дозволом писања у термину (календару)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Додат прилог!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Аутоматски одговор додат!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'Неважећи CommunicationID!',
        'All communications' => 'Све комуникације',
        'Last 1 hour' => 'Последњи 1 сат',
        'Last 3 hours' => 'Последња 3 сата',
        'Last 6 hours' => 'Последњих 6 сати',
        'Last 12 hours' => 'Последњих 12 сати',
        'Last 24 hours' => 'Последњих 24 сата',
        'Last week' => 'Прошла недеља',
        'Last month' => 'Прошли месец',
        'Invalid StartTime: %s!' => 'Неважећи StartTime: %s!',
        'Successful' => 'Успешно',
        'Processing' => 'У процесу',
        'Failed' => 'Неуспешно',
        'Invalid Filter: %s!' => 'Неважећи филтер: %s!',
        'Less than a second' => 'Краће од секунде',
        'sorted descending' => 'сортирано опадајуће',
        'sorted ascending' => 'сортирано растуће',
        'Trace' => 'Испитивање',
        'Debug' => 'Отклањање неисправности',
        'Info' => 'Инфо',
        'Warn' => 'Упозорење',
        'days' => 'дани',
        'day' => 'дан',
        'hour' => 'сат',
        'minute' => 'минут',
        'seconds' => 'секунде',
        'second' => 'секунда',

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
        'Customer company updated!' => 'Ажурирана фирма клијента!',
        'Dynamic field %s not found!' => 'Динамичко поље %s није пронађено!',
        'Unable to set value for dynamic field %s!' => 'Није могуће поставити вредност за динамичко поље %s!',
        'Customer Company %s already exists!' => 'Клијентска фирма %s већ постоји!',
        'Customer company added!' => 'Додата фирма клијента!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Конфигурација за \'CustomerGroupPermissionContext\' није пронађена!',
        'Please check system configuration.' => 'Молимо проверите системску конфигурацију.',
        'Invalid permission context configuration:' => 'Неважећа конфигурација контекста дозволе:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Ажуриран клијент!',
        'New phone ticket' => 'Нови тикет позива',
        'New email ticket' => 'Нови имејл тикет',
        'Customer %s added' => 'Додат клијент %s.',
        'Customer user updated!' => 'Ажуриран клијент корисник!',
        'Same Customer' => 'Исти клијент',
        'Direct' => 'Директно',
        'Indirect' => 'Индиректно',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Промени релације са клијент корисницима за групу',
        'Change Group Relations for Customer User' => 'Промени релације са групама за клијент корисника',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Придружи клијент кориснике сервису',
        'Allocate Services to Customer User' => 'Придружи сервисе клијент кориснику',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Конфигурација поља је неважећа',
        'Objects configuration is not valid' => 'Конфигурација објекта је неважећа',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Није могуће поништити редослед динамичких поља, молимо да проверите OTOBO логове за више информација.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Недефинисана субакција.',
        'Need %s' => 'Неопходан %s',
        'Add %s field' => 'Додај %s поље',
        'The field does not contain only ASCII letters and numbers.' => 'Поље не садржи само ASCII слова и бројеве.',
        'There is another field with the same name.' => 'Постоји друго поље са истим именом.',
        'The field must be numeric.' => 'Поље мора бити нумеричко.',
        'Need ValidID' => 'Неопходан ValidID',
        'Could not create the new field' => 'Није могуће креирати ново поље',
        'Need ID' => 'Неопходан ID',
        'Could not get data for dynamic field %s' => 'Не могу прибавити податке за динамичко поље %s',
        'Change %s field' => 'Измени %s поље',
        'The name for this field should not change.' => 'Назив овог поља није пожељно мењати.',
        'Could not update the field %s' => 'Није могуће ажурирати поље %s',
        'Currently' => 'Тренутно',
        'Unchecked' => 'Искључено',
        'Checked' => 'Укључено',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Вредност овог поља је умножена.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Спречава унос датума у будућности',
        'Prevent entry of dates in the past' => 'Спречава унос датума у прошлости',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => 'Подешавање је закључано од стране другог корисника!',
        'System was not able to reset the setting!' => 'Систем није успео да поништи подешавање!',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Изаберите бар једног примаоца.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'минут(и)',
        'hour(s)' => 'сат(и)',
        'Time unit' => 'Јединица времена',
        'within the last ...' => 'у последњих ...',
        'within the next ...' => 'у следећих ...',
        'more than ... ago' => 'пре више од ...',
        'Unarchived tickets' => 'Неархивирани тикети',
        'archive tickets' => 'архивирај тикете',
        'restore tickets from archive' => 'врати тикете из архиве',
        'Need Profile!' => 'Неопходан Profile!',
        'Got no values to check.' => 'Нема вредности за проверу.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Молимо да уклоните следеће речи јер се не могу користити за избор тикета:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Неопходан WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Не могу прибавити податке за ID веб сервиса %s',
        'ascending' => 'растући',
        'descending' => 'опадајући',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Неопходан тип комуникације!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Тип комуникације мора да буде \'Requester\' или \'Provider\'!',
        'Invalid Subaction!' => 'Неважећа субакција!',
        'Need ErrorHandlingType!' => 'Неопходан ErrorHandlingType!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s није регистрован',
        'Could not update web service' => 'Није могуће ажурирати веб сервис',
        'Need ErrorHandling' => 'Неопходан ErrorHandling',
        'Could not determine config for error handler %s' => 'Није могуће утврдити конфигурацију за обраду грешке %s',
        'Invoker processing outgoing request data' => 'Обрада излазних података захтева у позиваоцу',
        'Mapping outgoing request data' => 'Мапирање излазних података захтева',
        'Transport processing request into response' => 'Обрада захтева у одговор у транспорту',
        'Mapping incoming response data' => 'Мапирање долазних података одговора',
        'Invoker processing incoming response data' => 'Обрада долазних података одговара у позиваоцу',
        'Transport receiving incoming request data' => 'Примање долазних података захтева у транспорту',
        'Mapping incoming request data' => 'Мапирање долазних података захтева',
        'Operation processing incoming request data' => 'Обрада долазних података захтева у операцији',
        'Mapping outgoing response data' => 'Мапирање одлазних података одговора',
        'Transport sending outgoing response data' => 'Слање одлазних података одговора у транспорту',
        'skip same backend modules only' => 'прескочи само исте позадинске модуле',
        'skip all modules' => 'прескочи све модуле',
        'Operation deleted' => 'Операција обрисана',
        'Invoker deleted' => 'Позивалац обрисан',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 секунди',
        '15 seconds' => '15 секунди',
        '30 seconds' => '30 секунди',
        '45 seconds' => '45 секунди',
        '1 minute' => '1 минут',
        '2 minutes' => '2 минута',
        '3 minutes' => '3 минута',
        '4 minutes' => '4 минута',
        '5 minutes' => '5 минута',
        '10 minutes' => '10 минута',
        '15 minutes' => '15 минута',
        '30 minutes' => '30 минута',
        '1 hour' => '1 сат',
        '2 hours' => '2 сата',
        '3 hours' => '3 сата',
        '4 hours' => '4 сата',
        '5 hours' => '5 сати',
        '6 hours' => '6 сати',
        '12 hours' => '12 сати',
        '18 hours' => '18 сати',
        '1 day' => '1 дан',
        '2 days' => '2 дана',
        '3 days' => '3 дана',
        '4 days' => '4 дана',
        '6 days' => '6 дана',
        '1 week' => '1 недеља',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Није могуће утврдити конфигурацију за позиваоца %s',
        'InvokerType %s is not registered' => 'Тип позиваоца %s није регистрован',
        'MappingType %s is not registered' => 'MappingType %s није регистрован',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Неопходан позивалац!',
        'Need Event!' => 'Неопходан догађај!',
        'Could not get registered modules for Invoker' => 'Није могуће пронаћи регистровани модул позиваоца',
        'Could not get backend for Invoker %s' => 'Није могуће пронаћи модул за позиваоца %s',
        'The event %s is not valid.' => 'Догађај %s није важећи.',
        'Could not update configuration data for WebserviceID %s' => 'Не могу ажурирати конфигурационе податке за ID веб сервиса %s',
        'This sub-action is not valid' => 'Ова подакција је неважећа',
        'xor' => 'xor',
        'String' => 'Низ знакова',
        'Regexp' => 'Регуларни израз',
        'Validation Module' => 'Модул валидације',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Једноставно мапирање излазних података',
        'Simple Mapping for Incoming Data' => 'Једноставно мапирање долазних података',
        'Could not get registered configuration for action type %s' => 'Не могу прибавити регистровану конфигурацију за тип акције %s',
        'Could not get backend for %s %s' => 'Није могуће пронаћи модул за %s %s',
        'Keep (leave unchanged)' => 'Задржи (остави непромењено)',
        'Ignore (drop key/value pair)' => 'Игнориши (одбаци пар кључ/вредност)',
        'Map to (use provided value as default)' => 'Мапирај на (употреби понуђену вредност као подразумевану)',
        'Exact value(s)' => 'Тачна вредност(и)',
        'Ignore (drop Value/value pair)' => 'Игнориши (одбаци пар вредност/вредност)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'XSLT мапирање одлазних података',
        'XSLT Mapping for Incoming Data' => 'XSLT мапирање долазних података',
        'Could not find required library %s' => 'Није могуће пронаћи потребну библиотеку %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Подаци одлазећег захтева пре извршавања (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Подаци одлазећег захтева пре мапирања (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Подаци примљеног захтева после мапирања (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Подаци примљеног одговора пре мапирања (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Подаци о одлазећој грешци после обраде грешке (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Подаци примљеног захтева пре мапирања (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Подаци примљеног захтева после мапирања (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Подаци одлазећег одговора пре мапирања (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Подаци о одлазећој грешци после обраде грешке (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Није могуће утврдити конфигурацију за операцију %s',
        'OperationType %s is not registered' => 'Тип операције %s није регистрован',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Неопходан важећи Subaction!',
        'This field should be an integer.' => 'Ово поље мора бити цео број.',
        'File or Directory not found.' => 'Датотека или директоријум нису пронађени.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Постоји други веб сервис са истим именом.',
        'There was an error updating the web service.' => 'Дошло је до грешке при ажурирању веб сервиса.',
        'There was an error creating the web service.' => 'Дошло је до грешке при креирању веб сервиса.',
        'Web service "%s" created!' => 'Веб сервис "%s" је креиран!',
        'Need Name!' => 'Неопходан Name!',
        'Need ExampleWebService!' => 'Неопходан ExampleWebService!',
        'Could not load %s.' => 'Није било могуће учитати %s.',
        'Could not read %s!' => 'Није могуће прочитати %s!',
        'Need a file to import!' => 'Неопходна датотека за увоз!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Увезена датотека нема исправан YAML садржај! Молимо проверите OTOBO лог за детаље',
        'Web service "%s" deleted!' => 'Веб сервис "%s" је обрисан!',
        'OTOBO as provider' => 'OTOBO као пружалац услуга',
        'Operations' => 'Операције',
        'OTOBO as requester' => 'OTOBO као наручилац',
        'Invokers' => 'Позиваоци',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Нема WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Не могу прибавити податке историјата за ID веб сервиса %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Ажурирана група!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Додат имејл налог!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Тренутно други процес преузима пошту имејл налога. Молимо покушајте касније.',
        'Dispatching by email To: field.' => 'Отпремање путем имејла За: поље.',
        'Dispatching by selected Queue.' => 'Отпремање путем изабраног реда.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Оператер који је креирао тикет',
        'Agent who owns the ticket' => 'Оператер који је власник тикета',
        'Agent who is responsible for the ticket' => 'Оператер који је одговоран за тикет',
        'All agents watching the ticket' => 'Сви оператери који надзиру тикет',
        'All agents with write permission for the ticket' => 'Сви оператери са дозволом писања за тикет',
        'All agents subscribed to the ticket\'s queue' => 'Сви оператери претплаћени на ред тикета',
        'All agents subscribed to the ticket\'s service' => 'Сви оператери претплаћени на сервис тикета',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Сви оператери претплаћени и на ред и на сервис тикета',
        'Customer user of the ticket' => 'Клијент корисник тикета',
        'All recipients of the first article' => 'Сви примаоци првог чланка',
        'All recipients of the last article' => 'Сви примаоци последњег чланка',
        'Invisible to customer' => 'Невидљиво клијенту',
        'Visible to customer' => 'Видљиво клијенту',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP окружење не функционише. За више информација проверите лог.',
        'Need param Key to delete!' => 'Неопходан параметар Key за брисање!',
        'Key %s deleted!' => 'Кључ %s је обрисан!',
        'Need param Key to download!' => 'Неопходан параметар Key за преузимање!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Жао нам је, али Apache::Reload је неопходан као PerlModule и PerlInitHandler у конфигурацији Apache-а. Молимо погледајте scripts/apache2-httpd.include.conf. Алтернативно, можете користити конзолну алатку bin/otobo.Console.pl за инсталацију пакета!',
        'No such package!' => 'Нема таквог пакета!',
        'No such file %s in package!' => 'Нема такве датотеке %s у пакету!',
        'No such file %s in local file system!' => 'Нема такве датотеке %s у локалном систему!',
        'Can\'t read %s!' => 'Немогуће читање %s!',
        'File is OK' => 'Датотека је у реду',
        'Package has locally modified files.' => 'Пакет садржи локално измењене датотеке.',
        'Package not verified by the OTOBO Team!' => '',
        'Not Started' => 'Није покренуто',
        'Updated' => 'Ажурирано',
        'Already up-to-date' => 'Већ ажурно',
        'Installed' => 'Инсталирано',
        'Not correctly deployed' => 'Није коректно распоређено',
        'Package updated correctly' => 'Пакет успешно ажуриран',
        'Package was already updated' => 'Пакет је већ ажуран',
        'Dependency installed correctly' => 'Зависни пакети успешно инсталирани',
        'The package needs to be reinstalled' => 'Пакет мора бити реинсталиран.',
        'The package contains cyclic dependencies' => 'Пакет садржи цикличне зависности',
        'Not found in on-line repositories' => 'Није пронађен у мрежном спремишту',
        'Required version is higher than available' => 'Неопходна верзија је већа од тренутне',
        'Dependencies fail to upgrade or install' => 'Грешка прилико ажурирања или инсталације зависних пакета',
        'Package could not be installed' => 'Пакет није могао бити инсталиран',
        'Package could not be upgraded' => 'Пакет није могао бити ажуриран',
        'Repository List' => 'Листа спремишта',
        'No packages found in selected repository. Please check log for more info!' =>
            'У изабраном спремишту нема пакета. Молимо проверите лог за више информација.',
        'Package not verified due a communication issue with verification server!' =>
            'Пакет није верификован због комуникацијског проблема са верификационим сервером!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Није могуће повезати се са OTOBO Feature Add-on сервером!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Не могу прибавити OTOBO Feature Add-on листу са сервера!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Не могу прибавити OTOBO Feature Add-on са сервера!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Нема таквог филтера: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Додат приоритет!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Обрађене информације из базе података нису синхронизоване са системском конфигурацијом, молимо вас да синхронизујете све процесе.',
        'Need ExampleProcesses!' => 'Неопходан ExampleProcesses!',
        'Need ProcessID!' => 'Неопходан ProcessID!',
        'Yes (mandatory)' => 'Да (обавезно)',
        'Unknown Process %s!' => 'Непознат процес %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за овај процес',
        'The StateEntityID for state Inactive does not exists' => 'StateEntityID за неактивно стање не постоји',
        'There was an error creating the Process' => 'Дошло је до грешке приликом креирања Процеса',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације за ентитет процеса: %s',
        'Could not get data for ProcessID %s' => 'Не могу прибавити податке за ID процеса %s',
        'There was an error updating the Process' => 'Дошло је до грешке приликом ажурирања Процеса',
        'Process: %s could not be deleted' => 'Процес: %s се не може обрисати',
        'There was an error synchronizing the processes.' => 'Дошло је до грешке при синхронизацији процеса.',
        'The %s:%s is still in use' => '%s:%s је још у употреби',
        'The %s:%s has a different EntityID' => '%s:%s има различит ID ентитета',
        'Could not delete %s:%s' => 'Није могуће обрисати %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за %s ентитет: %s',
        'Could not get %s' => 'Није могуће прибавити %s',
        'Need %s!' => 'Неопходан %s!',
        'Process: %s is not Inactive' => 'Процес: %s није неактиван',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову aктивност',
        'There was an error creating the Activity' => 'Дошло је до грешке приликом креирања Активности',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Активности: %s',
        'Need ActivityID!' => 'Неопходан ActivityID!',
        'Could not get data for ActivityID %s' => 'Не могу прибавити податке за ID активности %s',
        'There was an error updating the Activity' => 'Дошло је до грешке приликом ажурирања Активности',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Недостају параметри: неопходни Activity и ActivityDialog!',
        'Activity not found!' => 'Активност није пронађена!',
        'ActivityDialog not found!' => 'Дијалог активности није пронађен!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Дијалог активности је већ додељен активности. Не можете додавати дијалог два пута.',
        'Error while saving the Activity to the database!' => 'Грешка при чувању активности у бази података!',
        'This subaction is not valid' => 'Ова подакција је неважећа',
        'Edit Activity "%s"' => 'Уреди активност "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за овај дијалог активности',
        'There was an error creating the ActivityDialog' => 'Дошло је до грешке приликом креирања Дијалога активности',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Диајлога активности: %s',
        'Need ActivityDialogID!' => 'Неопходан ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Не могу прибавити податке за ID дијалога активности %s',
        'There was an error updating the ActivityDialog' => 'Дошло је до грешке приликом ажурирања Дијалога ктивности',
        'Edit Activity Dialog "%s"' => 'Уреди дијалог активности "%s"',
        'Agent Interface' => 'Оператерски интерфејс',
        'Customer Interface' => 'Клијентски интерфејс',
        'Agent and Customer Interface' => 'Оператерски и клијентски интерфејс',
        'Do not show Field' => 'Не приказуј ово поље',
        'Show Field' => 'Прикажи поље',
        'Show Field As Mandatory' => 'Прикажи поље као обавезно',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Уреди путању',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову транзицију',
        'There was an error creating the Transition' => 'Дошло је до грешке приликом креирања Транзиције',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Транзиције: %s',
        'Need TransitionID!' => 'Неопходан TransitionID!',
        'Could not get data for TransitionID %s' => 'Не могу прибавити податке за ID транзиције %s',
        'There was an error updating the Transition' => 'Дошло је до грешке приликом ажурирања Транзиције',
        'Edit Transition "%s"' => 'Уреди транзицију "%s"',
        'Transition validation module' => 'Модул валидације транзиције',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Неопходан је бар један валидан конфигурациони параметар.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову транзициону акцију',
        'There was an error creating the TransitionAction' => 'Дошло је до грешке приликом креирања Транзиционе акције',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Транзиционе акције: %s',
        'Need TransitionActionID!' => 'Неопходан TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Не могу прибавити податке за ID транзиционе акције %s',
        'There was an error updating the TransitionAction' => 'Дошло је до грешке приликом ажурирања Транзиционе акције',
        'Edit Transition Action "%s"' => 'Уреди транзициону акцију "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Грешка: Сви кључеви немају вредност или обрнуто.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Ажуриран ред!',
        'Don\'t use :: in queue name!' => 'Немојте користити :: у називу реда!',
        'Click back and change it!' => 'Кликните на назад и промените то!',
        '-none-' => '-ни један-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Редови (без аутоматских одговора)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Промени релације са редовима за шаблон',
        'Change Template Relations for Queue' => 'Промени релације са шаблонима за ред',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Продукција',
        'Test' => 'Тест',
        'Training' => 'Тренинг',
        'Development' => 'Развој',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Ажурирана улога!',
        'Role added!' => 'Додата улога!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Промени релација са групама за улогу',
        'Change Role Relations for Group' => 'Промени релације са улогама за групу',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Улога',
        'Change Role Relations for Agent' => 'Промени релације са улогама за оператера',
        'Change Agent Relations for Role' => 'Промени релације са оператерима за улогу',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Молимо, прво активирајте %s.',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME окружење не функционише. За више информација проверите лог.',
        'Need param Filename to delete!' => 'Неопходан параметар Filename за брисање!',
        'Need param Filename to download!' => 'Неопходан параметар Filename за преузимање!',
        'Needed CertFingerprint and CAFingerprint!' => 'Неопходан CertFingerprint и CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint мора бити другачији од CertFingerprint',
        'Relation exists!' => 'Веза постоји!',
        'Relation added!' => 'Додата веза!',
        'Impossible to add relation!' => 'Немогуће додавање везе!',
        'Relation doesn\'t exists' => 'Веза не постоји',
        'Relation deleted!' => 'Веза обрисана!',
        'Impossible to delete relation!' => 'Немогуће брисање везе!',
        'Certificate %s could not be read!' => 'Сертификат %s није могуће прочитати!',
        'Needed Fingerprint' => 'Неопходан Fingerprint',
        'Handle Private Certificate Relations' => 'Руковање везама приватних сертификата',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Поздрав додат!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Ажуриран потпис!',
        'Signature added!' => 'Додат потпис!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Додат статус!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Датотеку %s није могуће прочитати!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Додата системска имејл адреса!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Неважећа подешавања',
        'There are no invalid settings active at this time.' => 'У овом тренутку нема неважећих подешавања.',
        'You currently don\'t have any favourite settings.' => 'Тренутно немате ниједно омиљено подешавање.',
        'The following settings could not be found: %s' => 'Следећа подешавања нису могла бити пронађена: %s',
        'Import not allowed!' => 'Увоз није дозвољен!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'Системска конфигурација није могла бити увежена звог непознате грешке, молико проверите OTOBO логове за више информација.',
        'Category Search' => 'Претрага категорија',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Нека увезена подешавања нису присутна у тренутној конфигурацији или није било могуће ажурирати их. Молимо проверите OTOBO лог за више информација.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'Морате укључити подешавање пре закључавања!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Не можете уредити ово подешавање зато што %s (%s) тренутно ради на њему.',
        'Missing setting name!' => 'Недостаје назив подешавања!',
        'Missing ResetOptions!' => 'Недостаје ResetOptions!',
        'System was not able to lock the setting!' => 'Систем није успео да закључа подешавање!',
        'System was unable to update setting!' => 'Систем није успео да сачува подешавање!',
        'Missing setting name.' => 'Недостаје назив подешавања.',
        'Setting not found.' => 'Подешавање није пронађено.',
        'Missing Settings!' => 'Недостаје Settings!',

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
        'Start date shouldn\'t be defined after Stop date!' => 'Датум почетка не би требало одредити после датума завршетка!',
        'There was an error creating the System Maintenance' => 'Дошло је до грешке приликом креирања Одржавања система',
        'Need SystemMaintenanceID!' => 'Неопходан SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Не могу прибавити податке за системско одржавање %s',
        'System Maintenance was added successfully!' => 'Системско одржавање је успешно додато!',
        'System Maintenance was updated successfully!' => 'Системско одржавање је успешно ажурирано!',
        'Session has been killed!' => 'Сесија је прекинута!',
        'All sessions have been killed, except for your own.' => 'Све сесије су прекинуте, осим сопствене.',
        'There was an error updating the System Maintenance' => 'Дошло је до грешке приликом ажурирања Одржавања система',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Није било могуће обрисати унос за системско одржавање: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Шаблон ажуриран!',
        'Template added!' => 'Шаблон додат!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Промени релације са прилозима за шаблон',
        'Change Template Relations for Attachment' => 'Промени релације са шаблонима за прилог',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Неопходан Type!',
        'Type added!' => 'Додат тип!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Ажуриран оператер!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Промени везе са групом за оператера',
        'Change Agent Relations for Group' => 'Промени везе са оператером за групу',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Месец',
        'Week' => 'Седмица',
        'Day' => 'Дан',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Сви термини',
        'Appointments assigned to me' => 'Термини додељени мени',
        'Showing only appointments assigned to you! Change settings' => 'Приказ само термина додељених вама! Измените подешавања',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Термин није пронађен!',
        'Never' => 'Никада',
        'Every Day' => 'Сваки дан',
        'Every Week' => 'Сваке седмице',
        'Every Month' => 'Сваког месеца',
        'Every Year' => 'Сваке године',
        'Custom' => 'Прилагођено',
        'Daily' => 'Дневно',
        'Weekly' => 'Седмично',
        'Monthly' => 'Месечно',
        'Yearly' => 'Годишње',
        'every' => 'сваког(е)',
        'for %s time(s)' => 'укупно %s пут(а)',
        'until ...' => 'до ...',
        'for ... time(s)' => 'укупно ... пут(а)',
        'until %s' => 'до %s',
        'No notification' => 'Без обавештења',
        '%s minute(s) before' => '%s минут(а) пре',
        '%s hour(s) before' => '%s сат(а) пре',
        '%s day(s) before' => '%s дан(а) пре',
        '%s week before' => '%s недеља пре',
        'before the appointment starts' => 'пре него што термин започне',
        'after the appointment has been started' => 'пошто термин започне',
        'before the appointment ends' => 'пре него што се термин заврши',
        'after the appointment has been ended' => 'пошто се термин заврши',
        'No permission!' => 'Без дозволе!',
        'Cannot delete ticket appointment!' => 'Није могуће обрисати термин тикета!',
        'No permissions!' => 'Без дозволе!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s више',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Историјат клијента',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'Није дат RecipientField!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Нема такве конфигурације за %s',
        'Statistic' => 'Статистика',
        'No preferences for %s!' => 'Нема поставки за %s!',
        'Can\'t get element data of %s!' => 'Не могу прибавити податке елемента за %s!',
        'Can\'t get filter content data of %s!' => 'Не могу прибавити податке садржаја филтера за %s!',
        'Customer Name' => 'Назив клијента',
        'Customer User Name' => 'Назив клијент корисника',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Неопходни SourceObject и SourceKey!',
        'You need ro permission!' => 'Неопходна вам је ro дозвола!',
        'Can not delete link with %s!' => 'Не може се обрисати веза са %s!',
        '%s Link(s) deleted successfully.' => '%sвеза(е) успешно обрисана(е).',
        'Can not create link with %s! Object already linked as %s.' => 'Не може се креирати веза са %s! Објект је већ повезан као %s.',
        'Can not create link with %s!' => 'Не може се креирати веза са %s!',
        '%s links added successfully.' => '%sвеза(е) успешно додата(е).',
        'The object %s cannot link with other object!' => 'Објект %s се не може повезати са другим објектом!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Неопходан параметар групе! ',
        'This feature is not available.' => '',
        'Updated user preferences' => 'Ажуриране корисничке поставке',
        'System was unable to deploy your changes.' => 'Систем није успео да распореди ваше промене.',
        'Setting not found!' => 'Подешавање није пронађено!',
        'System was unable to reset the setting!' => 'Систем није успео да поништи подешавање!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Процес тикет',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Недостаје параметар %s.',
        'Invalid Subaction.' => 'Неважећа субакција.',
        'Statistic could not be imported.' => 'Статистика се не може увести.',
        'Please upload a valid statistic file.' => 'Молимо да учитате исправну датотеку статистике.',
        'Export: Need StatID!' => 'Извоз: неопходан StatID!',
        'Delete: Get no StatID!' => 'Delete: нема StatID!',
        'Need StatID!' => 'Неопходан StatID!',
        'Could not load stat.' => 'Није могуће учитавање статистике.',
        'Add New Statistic' => 'Додај нову статистику',
        'Could not create statistic.' => 'Није могуће креирање статистике.',
        'Run: Get no %s!' => 'Run: Нема %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Није дат TicketID!',
        'You need %s permissions!' => 'Неопходне су вам %s дозволе!',
        'Loading draft failed!' => 'Учитавање нацрта неуспело!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'На жалост, морате бити власник тикета за ову акцију.',
        'Please change the owner first.' => 'Молимо прво промените власника.',
        'FormDraft functionality disabled!' => 'Својство FormDraft искључено!',
        'Draft name is required!' => 'Назив нацрта је обавезан!',
        'FormDraft name %s is already in use!' => 'Нацрта под називом %s већ постоји!',
        'Could not perform validation on field %s!' => 'Није могуће обавити валидацију за поље %s!',
        'No subject' => 'Нема предмет',
        'Could not delete draft!' => 'Није могуће обрисати нацрт!',
        'Previous Owner' => 'Претходни власник',
        'wrote' => 'написао/ла',
        'Message from' => 'Порука од',
        'End message' => 'Крај поруке',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s је неопходно!',
        'Plain article not found for article %s!' => 'Није пронађен обичан чланак за чланак %s!',
        'Article does not belong to ticket %s!' => 'Чланак не припада тикету %s!',
        'Can\'t bounce email!' => 'Не могу одбацити имејл!',
        'Can\'t send email!' => 'Не могу послати имејл!',
        'Wrong Subaction!' => 'Погрешна субакција!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Тикети се не могу закључати, није дат TicketIDs!',
        'Ticket (%s) is not unlocked!' => 'Тикет (%s) није откључан!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Следећи тикети су били игнорисани зато што су закључани од стране другог оператера или зато што немате право уписа у њих: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'Следећи тикет је игнорисан зато што је закључан од стране другог оператера или зато што немате право уписа у исти: %s.',
        'You need to select at least one ticket.' => 'Неопходно је да изаберете бар један тикет.',
        'Bulk feature is not enabled!' => 'Масовна функција није активирана!',
        'No selectable TicketID is given!' => 'Није дат TicketID који се може изабрати!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Нисте селектовали ни један тикет или само тикете које су закључали други оператери.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Следећи тикети су били игнорисани зато што су закључани од стране другог оператера или зато што немате право уписа у њих: %s.',
        'The following tickets were locked: %s.' => 'Следећи тикети су били закључани: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'Наслов чланка ће бити празан уколико предмет садржи само прикључак тикета!',
        'Address %s replaced with registered customer address.' => 'Адреса %s је замењена регистровном адресом клијента.',
        'Customer user automatically added in Cc.' => 'Клијент клијент се аутоматски додаје у Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Тикет "%s" је креиран!',
        'No Subaction!' => 'Нема субакције!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Нема TicketID!',
        'System Error!' => 'Системска грешка!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'Није дат ArticleID!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Следеће недеље',
        'Ticket Escalation View' => 'Ескалациони преглед тикета',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Чланак %s није пронађен!',
        'Forwarded message from' => 'Прослеђена порука од',
        'End forwarded message' => 'Крај прослеђене поруке',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Не може се приказати историјат, није дат TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Тикет се не може закључати, није дат TicketID!',
        'Sorry, the current owner is %s!' => 'На жалост, актуелни власник је %s!',
        'Please become the owner first.' => 'Молимо прво преузмите власништво.',
        'Ticket (ID=%s) is locked by %s!' => 'Тикет (ID=%s) је закључан од стране %s!',
        'Change the owner!' => 'Промени власника!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Нови чланак',
        'Pending' => 'На чекању',
        'Reminder Reached' => 'Достигнут подсетник',
        'My Locked Tickets' => 'Моји закључани тикети',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Тикет се не може повезати са собом!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Неопходна вам је дозвола за премештање!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Ћаскање није активно.',
        'No permission.' => 'Нема дозволе.',
        '%s has left the chat.' => '%s је напустио ћаскање.',
        'This chat has been closed and will be removed in %s hours.' => 'Ово ћаскање је затворено и биће уклоњено за %s сати.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Закључан тикет.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Нема ArticleID!',
        'This is not an email article.' => 'Ово није имејл чланак.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Немогуће читање неформатираног чланка! Можда не постоји неформатирана порука у спремишту! Прочитајте поруку из приказа.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Неопходан TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Не могу прибавити ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'Нема конфигурисаног процеса!',
        'The selected process is invalid!' => 'Означени процес је неважећи!',
        'Process %s is invalid!' => 'Процес %s је неважећи!',
        'Subaction is invalid!' => 'Субакција је неважећа!',
        'Parameter %s is missing in %s.' => 'Недостаје параметар %s у %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Ниједан ActivityDialog није конфигурисан за %s у _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Нема Start ActivityEntityID или Start ActivityDialogEntityID за процес %s у _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Нема тикета за TicketID: %s у _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Не може се утврдити ActivityEntityID. DynamicField или Config нису правилно подешени!',
        'Process::Default%s Config Value missing!' => 'Вредност конфигурације за Process::Default%s недостаје!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Нема ProcessEntityID или TicketID и ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Не могу прибавити StartActivityDialog и StartActivityDialog за ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Не могу прибавити тикет "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Не могу прибавити ProcessEntityID или ActivityEntityID за тикет "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Не могу прибавити конфигурацију Activity за ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Не могу прибавити конфигурацију ActivityDialog за ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Не могу прибавити податке за поље "%s" од ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Време чекања тикета може бити коришћено ако су State или StateID подешени за исти дијалог активности. ActivityDialog: %s!',
        'Pending Date' => 'Датум чекања',
        'for pending* states' => 'за стања* чекања',
        'ActivityDialogEntityID missing!' => 'Недостаје ActivityDialogEntityID!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Не могу прибавити конфигурацију за ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => 'CustomerID се не може користити као невидљиво поље.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Нема ProcessEntityID, проверите ваш ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Нема StartActivityDialog или StartActivityDialog за процес "%s"!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Не могу креирати тикет за процес са ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Не могу поставити ProcessEntityID "%s" за TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Не могу поставити ActivityEntityID "%s" за TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Не могу снимити дијалог активности, неважећи TicketID: %s!',
        'Invalid TicketID: %s!' => 'Неважећи TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Недостаје ActivityEntityID у тикету %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Овај корак не припада више тренутној активности процеса за тикет \'%s%s%s\'! Други корисник је у међувремену променио овај тикет. Молимо да затворите овај прозор и поново учитате тикет.',
        'Missing ProcessEntityID in Ticket %s!' => 'Недостаје ProcessEntityID у тикету %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити вредност динамичког поља за %s за TicketID "%s" у ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити време чекања тикета за тикет "%s" у ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Погрешна конфигурација поља у дијалогу активности: %s не може бити Display => 1 / приказано. (Молимо подесите конфигурацију да буде Display => 0 / није приказано или Display => 2 / прикажи као обавезно)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити %s за тикет "%s" у ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Подразумевано подешавање за Process::Default%s недостаје!',
        'Default Config for Process::Default%s invalid!' => 'Подразумевано подешавање за Process::Default%s је неважеће!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Слободни тикети',
        'including subqueues' => 'укључујући подредове',
        'excluding subqueues' => 'искључујући подредове',
        'QueueView' => 'Преглед реда',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Тикети за које сам одговоран',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'последња претрага',
        'Untitled' => 'Нема наслов',
        'Ticket Number' => 'Број тикета',
        'Ticket' => 'Тикет',
        'printed by' => 'штампао',
        'CustomerID (complex search)' => 'ID клијента (сложена претрага)',
        'CustomerID (exact match)' => 'ID клијента (тачно поклапање)',
        'Invalid Users' => 'Погрешни корисници',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'у више од ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Функција није активирана!',
        'Service View' => 'Преглед услуге',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Преглед статуса',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Моји надзирани тикети',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Функција није активна',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Обрисана веза',
        'Ticket Locked' => 'Закључан тикет',
        'Pending Time Set' => 'Времена чекања је подешено',
        'Dynamic Field Updated' => 'Ажурирано динамичко поље',
        'Outgoing Email (internal)' => 'Одлазни имејл (интерни)',
        'Ticket Created' => 'Креиран тикет',
        'Type Updated' => 'Ажуриран тип',
        'Escalation Update Time In Effect' => 'Актуелно време ажурирања ескалације',
        'Escalation Update Time Stopped' => 'Време ажурирања ескалације је заустављено',
        'Escalation First Response Time Stopped' => 'Време првог одзива ескалације је заустављено',
        'Customer Updated' => 'Ажуриран клијент',
        'Internal Chat' => 'Интерно ћаскање',
        'Automatic Follow-Up Sent' => 'Послат аутоматски наставак',
        'Note Added' => 'Додата напомена',
        'Note Added (Customer)' => 'Додата напомена (клијент)',
        'SMS Added' => 'Додат SMS',
        'SMS Added (Customer)' => 'Додат SMS (клијент)',
        'State Updated' => 'Ажурирано стање',
        'Outgoing Answer' => 'Одлазни одговор',
        'Service Updated' => 'Ажуриран сервис',
        'Link Added' => 'Додата веза',
        'Incoming Customer Email' => 'Долазни имејл клијента',
        'Incoming Web Request' => 'Долазни веб захтев',
        'Priority Updated' => 'Ажуриран приоритет',
        'Ticket Unlocked' => 'Откључан тикет',
        'Outgoing Email' => 'Одлазни имејл',
        'Title Updated' => 'Ажуриран наслов',
        'Ticket Merged' => 'Спојен тикет',
        'Outgoing Phone Call' => 'Одлазни позив',
        'Forwarded Message' => 'Прослеђена порука',
        'Removed User Subscription' => 'Уклоњена претплата за корисника',
        'Time Accounted' => 'Време је обрачунато',
        'Incoming Phone Call' => 'Долазни позив',
        'System Request.' => 'Системски захтев.',
        'Incoming Follow-Up' => 'Долазни наставак',
        'Automatic Reply Sent' => 'Послат аутоматски одговор',
        'Automatic Reject Sent' => 'Послато аутоматско одбијање',
        'Escalation Solution Time In Effect' => 'Актуелно време решавања ескалације',
        'Escalation Solution Time Stopped' => 'Време решења ескалације је заустављено',
        'Escalation Response Time In Effect' => 'Актуелно време одговора на ескалацију',
        'Escalation Response Time Stopped' => 'Време одзива ескалације је заустављено',
        'SLA Updated' => 'SLA је ажуриран',
        'External Chat' => 'Екстерно ћаскање',
        'Queue Changed' => 'Промењен ред',
        'Notification Was Sent' => 'Обавештење је послато',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Овај тикет више не постоји, или тренутно немате дозволу за приступ истом.',
        'Missing FormDraftID!' => 'Недостаје FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'Не могу прибавити ArticleID %s!',
        'Article filter settings were saved.' => 'Подешавања филтера чланка су сачувана.',
        'Event type filter settings were saved.' => 'Подешавања филтера типа догађаја су сачувана.',
        'Need ArticleID!' => 'Неопходан ArticleID!',
        'Invalid ArticleID!' => 'Неважећи ArticleID!',
        'Forward article via mail' => 'Проследи чланак путем мејла',
        'Forward' => 'Проследи',
        'Fields with no group' => 'Поља без групе',
        'Invisible only' => 'Само невидљиви',
        'Visible only' => 'Само видљиви',
        'Visible and invisible' => 'Видљиви и невидљиви',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Чланак се не може отворити! Могуће је да је на другој страници?',
        'Show one article' => 'Прикажи један чланак',
        'Show all articles' => 'Прикажи све чланке',
        'Show Ticket Timeline View' => 'Прикажи тикете на временској линији',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'Није дат FormID.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Грешка: датотека није могла бити обрисана. Молимо контактирајте вашег администратора (недостаје FileID).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'Неопходан ArticleID!',
        'No TicketID for ArticleID (%s)!' => 'Нема TicketID за овај ArticleID (%s)!',
        'HTML body attachment is missing!' => 'Прилог са HTML садржајем недостаје!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'Неопходни FileID и ArticleID!',
        'No such attachment (%s)!' => 'Нема таквог прилога (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Проверите подешавања за %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Проверите подешавања за %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'Немаш одговарајуће дозволе за креирање тикета у подразумеваном реду.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Неопходан CustomerID!',
        'My Tickets' => 'Моји тикети',
        'Company Tickets' => 'Тикети фирми',
        'Untitled!' => 'Нема наслов!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Право име клијента',
        'Created within the last' => 'Креирано у последњих',
        'Created more than ... ago' => 'Креирано пре више од ...',
        'Please remove the following words because they cannot be used for the search:' =>
            'Молимо да уклоните следеће речи  јер се не могу користити за претрагу:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Тикет се не може поново отворити, није могуће у овом реду!',
        'Create a new ticket!' => 'Отвори нови тикет!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Сигуран режим је активан!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Уколико желите да поново покренете инсталацију, онемогућите SecureMode у подешавањима.',
        'Directory "%s" doesn\'t exist!' => 'Директоријум "%s" не постоји!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Прво подесите "Home" у Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => 'Датотека "%s/Kernel/Config.pm" није пронађена!',
        'Directory "%s" not found!' => 'Директоријум "%s" није пронађен!',
        'Install OTOBO' => 'Инсталирај OTOBO',
        'Intro' => 'Увод',
        'Kernel/Config.pm isn\'t writable!' => 'Немогућ упис у %s/Kernel/Config.pm!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Ако желите да користите инсталациони програм, подесите дозволу писања у Kernel/Config.pm за веб сервер корисника!',
        'Database Selection' => 'Селекција базе података',
        'Unknown Check!' => 'Непозната провера!',
        'The check "%s" doesn\'t exist!' => 'Провера "%s" не постоји!',
        'Enter the password for the database user.' => 'Унеси лозинку за корисника базе података.',
        'Database %s' => 'База података %s',
        'Configure MySQL' => 'Подеси MySQL',
        'Enter the password for the administrative database user.' => 'Унеси лозинку за корисника административне базе података.',
        'Configure PostgreSQL' => 'Подеси PostgreSQL',
        'Configure Oracle' => 'Подеси Oracle',
        'Unknown database type "%s".' => 'Непознат тип базе података "%s".',
        'Please go back.' => 'Молимо идите назад.',
        'Create Database' => 'Креирај базу података',
        'Install OTOBO - Error' => 'Инсталирање OTOBO - грешка',
        'File "%s/%s.xml" not found!' => 'Датотека "%s/%s.xml" није пронађена!',
        'Contact your Admin!' => 'Контактирајте вашег администратора!',
        'System Settings' => 'Системска подешавања',
        'Syslog' => 'Системски лог',
        'Configure Mail' => 'Подеси имејл',
        'Mail Configuration' => 'Подешавање имејла',
        'Can\'t write Config file!' => 'Не могу да упишем конфигурациону датотеку!',
        'Unknown Subaction %s!' => 'Непозната субакција %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Не могу се повезати на базу података, Перл модул DBD::%s није инсталиран!',
        'Can\'t connect to database, read comment!' => 'Не могу се повезати на базу података, прочитајте коментар!',
        'Database already contains data - it should be empty!' => 'База података већ садржи податке - требало би да буде празна.',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Грешка: Молимо да проверите да ваша база података прихвата пакете по величини веће од %s MB  (тренутно прихвата пакете величине до %s MB). Молимо да прилагодите параметар max_allowed_packet подешавање у вашој бази података како би избегли грешке.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Грешка: Молимо да подесете вредност за innodb_log_file_size у вашој бази података на најмање %s MB (тренутно: %s MB, препоручено: %s MB). За више информација, молимо погледајте на %s.',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Без %s!',
        'No such user!' => 'Непознат корисник!',
        'Invalid calendar!' => 'Неисправан календар!',
        'Invalid URL!' => 'Неисправна адреса!',
        'There was an error exporting the calendar!' => 'Грешка приликом експортовања календара!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Неопходна конфигурација Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Аутентификација није успела од %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Ћаскање',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Преусмеравање чланка на другу имејл адресу',
        'Bounce' => 'Преусмери',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Одговори на све',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Пошаљи поново овај чланак',
        'Resend' => 'Пошаљи поново',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Преглед лога поруке за овај чланак',
        'Message Log' => 'Лог поруке',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Одговори на напомену',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Подели овај чланак',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Погледај извор овог Чланка',
        'Plain Format' => 'Неформатиран формат',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Одштампај овај чланак',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'Контактирајте нас на sales@otrs.com',
        'Get Help' => 'Тражи помоћ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Означено',
        'Unmark' => 'Неозначено',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Инсталирај поново пакет',
        'Re-install' => 'Инсталирај поново',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Шифровано',
        'Sent message encrypted to recipient!' => 'Послата шифрована порука примаоцу!',
        'Signed' => 'Потписано',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" заглавље пронађено, али је неисправно!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE" заглавље пронађено, али је неисправно!',
        'Ticket decrypted before' => 'Тикет је дешифрован пре',
        'Impossible to decrypt: private key for email was not found!' => 'Немогуће дешифровање: приватни кључ за ову адресу није пронађен!',
        'Successful decryption' => 'Успешно дешифровање',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Нису пронађени кључеви за шифровање за адресу: \'%s\'.',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Нису одабрани кључеви за шифровање за адресу: \'%s\'.',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Није могуће користити истекао кључ за шифровање за адресе: \'%s\'.',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Није могуће користити повучен кључ за шифровање за адресе: \'%s\'.',
        'Encrypt' => 'Шифровање',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Кључеви/сертификати ће бити приказани само за примаоце са више од једног кључева/сертификата. Први пронађени кључ/сертификат ће бити аутоматски одабран. Молимо проверите да ли је одабран исправан.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Имејл безбедност',
        'PGP sign' => 'PGP потписивање',
        'PGP sign and encrypt' => 'PGP потпис и шифровање',
        'PGP encrypt' => 'PGP шифровање',
        'SMIME sign' => 'SMIME потписивање',
        'SMIME sign and encrypt' => 'SMIME потпис и шифровање',
        'SMIME encrypt' => 'SMIME шифровање',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Није могуће користити истекао кључ за потписивање: \'%s\'.',
        'Cannot use revoked signing key: \'%s\'. ' => 'Није могуће користити повучен кључ за потписивање: \'%s\'.',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Нема кључева за потписивање за адресе \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Нема одабраних кључева за потписивање за адресе \'%s\'.',
        'Sign' => 'Потпис',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Кључеви/сертификати ће бити приказани само за пошиљаоце са више од једног кључева/сертификата. Први пронађени кључ/сертификат ће бити аутоматски одабран. Молимо проверите да ли је одабран исправан.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Приказан',
        'Refresh (minutes)' => 'Освежи (минута)',
        'off' => 'искључено',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Приказани клијент ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Приказани клијенти корисници',
        'Offline' => 'Није на вези',
        'User is currently offline.' => 'Корисник тренутно није на вези.',
        'User is currently active.' => 'Корисник је тренутно активан.',
        'Away' => 'Одсутан',
        'User was inactive for a while.' => 'Корисник није био активан неко време.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Време почетка тикета је подешено после времена завршетка!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Није могуће повезати се са OTOBO News сервером!',
        'Can\'t get OTOBO News from server!' => 'Не могу прибавити OTOBO News са сервера!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Није могуће повезази се са Product News сервером!',
        'Can\'t get Product News from server!' => 'Не могу прибавити Product News са сервера!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Није могуће повезати се са %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Приказани тикети',
        'Shown Columns' => 'Приказане колоне',
        'filter not active' => 'филтер није активан',
        'filter active' => 'филтер је активан',
        'This ticket has no title or subject' => 'Овај тикет нема наслов или предмет',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Седмодневна статистика',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Корисник је недоступан.',
        'Unavailable' => 'Недоступно',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Стандардан',
        'The following tickets are not updated: %s.' => 'Следећи тикети нису ажурирани: %s.',
        'h' => 'ч',
        'm' => 'м',
        'd' => 'д',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Овај тикет више не постоји, или тренутно немате дозволу за приступ истом. Можете предузети једну од следећих акција:',
        'This is a' => 'Ово је',
        'email' => 'имејл',
        'click here' => 'кликните овде',
        'to open it in a new window.' => 'за отварање у новом прозору.',
        'Year' => 'Година',
        'Hours' => 'Сати',
        'Minutes' => 'Минути',
        'Check to activate this date' => 'Проверите за активирање овог датума',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Немате дозволу!',
        'No Permission' => 'Нема дозволе',
        'Show Tree Selection' => 'Прикажи дрво избора',
        'Split Quote' => 'Подели квоту',
        'Remove Quote' => 'Уклони квоту.',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Повезано као',
        'Search Result' => 'Резултат претраге',
        'Linked' => 'Повезано',
        'Bulk' => 'Масовно',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Једноставан',
        'Unread article(s) available' => 'Располиживи непрочитани чланци',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Термин',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Претрага архиве',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Оператер на вези: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Има још ескалиралих тикета!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Молимо одаберите временску зону у личним подешавањима и потврдите кликом на дугме за чување.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Клијент на вези: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Одржавање система је активно!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Период одржавања система ће отпочети у: %s и очекивано је да се заврши у: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO системски сервис не ради.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Активирана је опција ван канцеларије, желите ли да је искључите?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Имате %s распоређено(а) неважеће(а) подешавање(а). Кликните овде за приказ неважећих подешавања.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Имате нераспоређених подешавања, да ли желите да их распоредите?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Конфигурација се освежава, молимо сачекајте...',
        'There is an error updating the system configuration!' => 'Грешка приликом освежавања системске конфигурације!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Не користите суперкориснички налог за рад са %s! Направите нове налоге за оператере и користите њих.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Молимо вас да проверите да сте изабрали бар један метод транспорта за обавезна обавештења.',
        'Preferences updated successfully!' => 'Поставке су успешно ажуриране!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(у току)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Молимо да одредите датум завршетка који је после датума почетка.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Потврди лозинку',
        'The current password is not correct. Please try again!' => 'Актуелна лозинка је нетачна. Молимо покушајте поново!',
        'Please supply your new password!' => 'Молимо да обезбедите нову лозинку!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Ова лозинка је забрањена тренутном системском конфигурацијом. Молимо контактирајте админстратора за додатна питања.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Лозинка не може бити ажурирана. Минимална дужина лозинке је %s знакова.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Лозинка не може бити ажурирана, мора садржати најмање 2 мала и 2 велика слова!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Лозинка не може бити ажурирана. Мора да садржи најнмање једну бројку.',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Лозинка не може бити ажурирана, мора садржати најмање 2 слова!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Временска зона успешно ажурирана!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'неважећи',
        'valid' => 'важећи',
        'No (not supported)' => 'Не (није подржано)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Није одабрана временска вредност са комплетном прошлошћу или комплетним тренутним и будућим релативним периодом.',
        'The selected time period is larger than the allowed time period.' =>
            'Изабрани временски период је дужи од дозвољеног.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Нема доступног временског опсега за актуелну изабрану вредност опсега на X оси.',
        'The selected date is not valid.' => 'Изабрани датум није важећи.',
        'The selected end time is before the start time.' => 'Изабрано време завршетка је пре времена почетка.',
        'There is something wrong with your time selection.' => 'Нешто није у реду са вашим избором времена.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Молимо да изаберете само један елемент или дозволите измене у време генерисања старта!',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Молимо да изаберете барем једну вредност овог поља или дозволите измену у време генерисања статистике.',
        'Please select one element for the X-axis.' => 'Молимо да изаберете један елемент за X-осу.',
        'You can only use one time element for the Y axis.' => 'Можете користити само један временски елемент за Y осу.',
        'You can only use one or two elements for the Y axis.' => 'Можете да користите само један или два елемента за Y осу.',
        'Please select at least one value of this field.' => 'Молимо да изаберете бар једну вредност за ово поље.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Молимо да обезбедите вредност или дозволите измене у време генерисања старта.',
        'Please select a time scale.' => 'Молимо да одаберете временски опсег.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Ваш интервал извештавања је прекратак, молимо употребите већи распон времена.',
        'second(s)' => 'секунде(е)',
        'quarter(s)' => 'тромесечје(а)',
        'half-year(s)' => 'полугодиште(а)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Молимо да уклоните следеће речи јер се не могу користити због ограничења тикета: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Одустани од промене и откључај ово подешавање',
        'Reset this setting to its default value.' => 'Поништи ово подешавање на подразумевану вредност',
        'Unable to load %s!' => 'Није могуће учитати %s!',
        'Content' => 'Садржај',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Откључајте за враћање у ред',
        'Lock it to work on it' => 'Закључајте за рад на тикету',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Прекини надзор',
        'Remove from list of watched tickets' => 'Уклони са листе праћених тикета',
        'Watch' => 'Посматрај',
        'Add to list of watched tickets' => 'Додај на листу праћених тикета',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Сортирај по',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Нови закључани тикети',
        'Locked Tickets Reminder Reached' => 'Достигнут подсетник закључаних тикета',
        'Locked Tickets Total' => 'Укупно закључних тикета',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Нови одговорни тикети',
        'Responsible Tickets Reminder Reached' => 'Достигнут подсетник одговорних тикета',
        'Responsible Tickets Total' => 'Укупно одговорних тикета',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Нови праћени тикети',
        'Watched Tickets Reminder Reached' => 'Достигнут подсетник праћених тикета',
        'Watched Tickets Total' => 'Укупно праћених тикета',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Динамичка поља тикета',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Учитавање ACL конфигурације није било могуће. Молимо проверите да ли је фајл исправан.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Пријава тренутно није могућа због планираног одржавања система.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => 'Сесија је истекла! Молимо покушајте касније!',
        'Session per user limit reached!' => 'Достигнуто ограничење броја сесија по кориснику!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Сесија је неважећа. Молимо пријавите се поново.',
        'Session has timed out. Please log in again.' => 'Време сесије је истекло. Молимо пријавите се поново.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Само PGP потпис',
        'PGP encrypt only' => 'Само PGP шифровање',
        'SMIME sign only' => 'Само SMIME потпис',
        'SMIME encrypt only' => 'Само SMIME шифровање',
        'PGP and SMIME not enabled.' => 'PGP и SMIME нису омогућени!',
        'Skip notification delivery' => 'Прескочи доставу обавештења',
        'Send unsigned notification' => 'Пошаљи непотписано обавештење',
        'Send unencrypted notification' => 'Пошаљи нешифовано обавештење',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Референтни списак конфигурационих опција',
        'This setting can not be changed.' => 'Ово подешавање се не може мењати.',
        'This setting is not active by default.' => 'Ово подешавање није подразумевано активно.',
        'This setting can not be deactivated.' => 'Ово подешавање се не може деактивирати.',
        'This setting is not visible.' => 'Ово подешавање није видљиво.',
        'This setting can be overridden in the user preferences.' => 'Ово подешавање може бити прегажено у личним подешавањима корисника.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Ово подешавање може бити прегажено у личним подешавањима корисника, али није подразумевано активно.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Клијент корисник "%s" већ постоји.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Ова адреса електронске поште је већ искоришћена за другог клијент корисника.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'пре/после',
        'between' => 'између',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'нпр. Text или Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Игнориши ово поље.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Ово поље је обавезно или',
        'The field content is too long!' => 'Садржај поља је предугачак!',
        'Maximum size is %s characters.' => 'Максимална величина је %s карактера.',

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
            'Учитавање конфигурације обавештења није било могуће. Молимо проверите да ли је фајл исправан.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Текст садржаја увезеног обавештења има више од 4000 карактера.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'није инсталирано',
        'installed' => 'инсталирано',
        'Unable to parse repository index document.' => 'Није могуће рашчланити спремиште индекса документа.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Нема пакета за верзију вашег система, у спремишту су само пакети за друге верзије.',
        'File is not installed!' => 'Датотека није инсталирана!',
        'File is different!' => 'Датотека је различита!',
        'Can\'t read file!' => 'Немогуће читање датотеке!',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '',
        'Package not verified by the OTOBO community!' => '',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'Процес "%s" и све информације везане за њега су успешно увезени.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Неактивно',
        'FadeAway' => 'У гашењу',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Не можете да контактирате сервер за регистрацију. Молимо покушајте поново касније.',
        'No content received from registration server. Please try again later.' =>
            'Садржај није примљен од сервера за регистрацију. Молимо покушајте поново касније.',
        'Can\'t get Token from sever' => 'Не могу прибавити токен од сервера',
        'Username and password do not match. Please try again.' => 'Корисничко име и лозинка се не поклапају. Молимо покушајте поново.',
        'Problems processing server result. Please try again later.' => 'Проблеми у обради резултата сервера. Молимо покушајте поново касније.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Збир',
        'week' => 'недеља',
        'quarter' => 'тромесечје',
        'half-year' => 'полугодиште',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Тип статуса',
        'Created Priority' => 'Направљени приоритети',
        'Created State' => 'Креирани статус',
        'Create Time' => 'Време креирања',
        'Pending until time' => 'Време чекања',
        'Close Time' => 'Време затварања',
        'Escalation' => 'Ескалација',
        'Escalation - First Response Time' => 'Ескалација - време првог одзива',
        'Escalation - Update Time' => 'Ескалација - време ажурирања',
        'Escalation - Solution Time' => 'Ескалација - време решавања',
        'Agent/Owner' => 'Оператер/Власник',
        'Created by Agent/Owner' => 'Креирао Оператер/Власник',
        'Assigned to Customer User Login' => 'Додељени клијент корисник',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Проценио',
        'Ticket/Article Accounted Time' => 'Обрачунато време',
        'Ticket Create Time' => 'Време отварања тикета',
        'Ticket Close Time' => 'Време затварања тикета',
        'Accounted time by Agent' => 'Обрачунато време по оператеру',
        'Total Time' => 'Укупно време',
        'Ticket Average' => 'Просечно време по тикету',
        'Ticket Min Time' => 'Минимално време тикета',
        'Ticket Max Time' => 'Максимално време тикета',
        'Number of Tickets' => 'Број тикета',
        'Article Average' => 'Просечно време по чланку',
        'Article Min Time' => 'Минимално време чланка',
        'Article Max Time' => 'Максимално време чланка',
        'Number of Articles' => 'Број чланака',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'неограничено',
        'Attributes to be printed' => 'Атрибути за штампу',
        'Sort sequence' => 'Редослед сортирања',
        'State Historic' => 'Историјат статуса',
        'State Type Historic' => 'Историјат типа статуса',
        'Historic Time Range' => 'Временски опсег историјата',
        'Number' => 'Број',
        'Last Changed' => 'Последни пут промењено',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Просечно време решења',
        'Solution Min Time' => 'Минимално време решења',
        'Solution Max Time' => 'Максимално време решења',
        'Solution Average (affected by escalation configuration)' => 'Просечно време решења (под утицајем поставки ескалације)',
        'Solution Min Time (affected by escalation configuration)' => 'Минимално време решења (под утицајем поставки ескалације)',
        'Solution Max Time (affected by escalation configuration)' => 'Максимално време решења (под утицајем поставки ескалације)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Просечно радно време решења (под утицајем поставки ескалације)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Минимално радно време решења (под утицајем поставки ескалације)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Максимално радно време решења (под утицајем поставки ескалације)',
        'First Response Average (affected by escalation configuration)' =>
            'Просечно време првог одговора (под утицајем поставки ескалације)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Минимално време првог одговора (под утицајем поставки ескалације)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Максимално време првог одговора (под утицајем поставки ескалације)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Просечно радно време првог одговора (под утицајем поставки ескалације)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Минимално радно време првог одговора (под утицајем поставки ескалације)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Максимално радно време првог одговора (под утицајем поставки ескалације)',
        'Number of Tickets (affected by escalation configuration)' => 'Број тикета (под утицајем поставки ескалације)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Дани',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Застареле табеле',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'У бази података су пронађене застареле табеле. Уколико су празне, табеле могу бити слободно уклоњене.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Присуство табеле',
        'Internal Error: Could not open file.' => 'Интерна грешка: Није могуће отворити датотеку.',
        'Table Check' => 'Провера табеле',
        'Internal Error: Could not read file.' => 'Интерна грешка: Није могуће прочитати датотеку.',
        'Tables found which are not present in the database.' => 'Пронађене табеле које нису присутне у бази података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Величина базе података',
        'Could not determine database size.' => 'Није могуће утврдити величину базе података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Верзија базе података',
        'Could not determine database version.' => 'Није могуће утврдити верзију базе података',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Карактерсет за повезивање клијента',
        'Setting character_set_client needs to be utf8.' => 'Подешавање character_set_client мора бити utf8.',
        'Server Database Charset' => 'Karakterset serverske baze podataka',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => 'Подешавање character_set_database мора бити \'utf8\'.',
        'Table Charset' => 'Табела карактерсета',
        'There were tables found which do not have \'utf8\' as charset.' =>
            'Пронађене су табеле које немају \'utf8\' као карактерсет.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Величина InnoDB лог датотеке',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Подешавање innodb_log_file_size мора бити барем 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Неисправне подразумеване вредности',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Пронађене су табеле са неисправним подразумеваним вредностима. Да бисте их аутоматски исправили, молимо покрените bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Максимална величина упита',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'Подешавање \'max_allowed_packet\' мора бити више од 64 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Величина кеш упита',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Подешавање \'query_cache_size\' мора бити коришћено (веће од 10 MB, али не више од 512 MB)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Подразумевани механизам за складиштење',
        'Table Storage Engine' => 'Механизам за складиштење табеле',
        'Tables with a different storage engine than the default engine were found.' =>
            'Пронађене су табеле са различитим механизмом за складиштење него што је предефинисани механизам.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Неопходан је MySQL 5.x или више.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG подешавање',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG мора бити подешен на al32utf8 (нпр. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT подешавање',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT мора бити подешен на \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL провера NLS_DATE_FORMAT подешавања',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Секвенце и окидачи примарних кључева',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'Пронађене су секвенце и/или окидачи са могућим погрешним називима. Молимо вас да им ручно промените називе.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Подешавање client_encoding мора бити UNICODE или UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Подешавање server_encoding мора бити UNICODE или UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Формат датума',
        'Setting DateStyle needs to be ISO.' => 'Подешавање DateStyle мора бити ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Секвенце примарних кључева',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'Пронађене су секвенце са могућим погрешним називима. Молимо вас да им ручно промените називе.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'Неопходан је PostgreSQL 9.2 или више.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO партиција на диску',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Коришћење диска',
        'The partition where OTOBO is located is almost full.' => 'Партиција на којој је смештен ОТРС је скоро пуна.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Партиција на којој је смештен ОТРС нема проблеме са простором.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Коришћење партиције на диску',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Расподела',
        'Could not determine distribution.' => 'Није могуће утврдити расподелу.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Кернел верзија',
        'Could not determine kernel version.' => 'Није могуће утврдити кернел верзију',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Оптерећење система',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Оптерећење система може бити највише број процесора које систем поседује (нпр. оптерећење од 8 или мање на систему са 8 језгара је у реду).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl модули',
        'Not all required Perl modules are correctly installed.' => 'Сви захтевани Perl модули нису коректно инсталирани.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Сигурносна провера Perl модула',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit је детектовао један или више рањивих Perl модула инсталираних на систему. Молимо обратите пажњу да су могући лажно позитивни резултати за дистрибуције које освежавају Perl модуле без промене њихове верзије.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::Audit није детектовао рањиве Perl модуле инсталиране на систему.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Слободни Swap простор (%)',
        'No swap enabled.' => 'Размењивање није активирано.',
        'Used Swap Space (MB)' => 'Употребљен Swap простор (MB)',
        'There should be more than 60% free swap space.' => 'Мора постојати више од 60 % слободног swap простора',
        'There should be no more than 200 MB swap space used.' => 'Не треба да буде више од 200 MB употребљеног Swap простора.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Стање индекса претраге чланака',
        'Indexed Articles' => 'Индексираних чланака',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Чланака по комуникационом каналу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Долазне комуникације',
        'Outgoing communications' => 'Одлазне комуникације',
        'Failed communications' => 'Неуспеле комуникације',
        'Average processing time of communications (s)' => 'Просечно време трајања комуникација (с)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Стање налога комуникационог лога (последњих 24 сата)',
        'No connections found.' => 'Нису пронађене конекције.',
        'ok' => 'у реду',
        'permanent connection errors' => 'трајне грешке у конекцији',
        'intermittent connection errors' => 'повремене грешке у конекцији',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Подешавања конфигурације',
        'Could not determine value.' => 'Није могуће утврдити вредност.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Системски сервис',
        'Daemon is running.' => 'Сервис ради.',
        'Daemon is not running.' => 'Сервис не ради.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Записи у бази података',
        'Ticket History Entries' => 'Историја уноса тикета',
        'Articles' => 'Чланци',
        'Attachments (DB, Without HTML)' => 'Прилози (база података, без HTML)',
        'Customers With At Least One Ticket' => 'Клијенти са бар једним тикетом',
        'Dynamic Field Values' => 'Вредности динамичког поља',
        'Invalid Dynamic Fields' => 'Неважећа динамичка поља.',
        'Invalid Dynamic Field Values' => 'Неважеће вредности динамичких поља.',
        'GenericInterface Webservices' => 'GenericInterface веб сервис',
        'Process Tickets' => 'Процес тикети',
        'Months Between First And Last Ticket' => 'Месеци између првог и последњег тикета',
        'Tickets Per Month (avg)' => 'Тикети месечно (просечно)',
        'Open Tickets' => 'Отворени тикети',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Подразумевано SOAP корисничко име и лозинка',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Сигурносни ризик: користите подразумевана подешавања за SOAP::User i SOAP::Password. Молимо промените га.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Предефинисана лозинка администратора',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Сигурносни ризик: агент налог root@localhost још увек има предефинисану лозинку. Молимо промените је или деактивирајте налог.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Ред за слање имејлова',
        'Emails queued for sending' => 'Број имејлова заказаних за слање',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (назив домена)',
        'Please configure your FQDN setting.' => 'Молимо да конфигуришете FQDN подешавање.',
        'Domain Name' => 'Назив домена',
        'Your FQDN setting is invalid.' => 'Ваша FQDN подешавања су неважећа.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Омогућено писање у систем датотека.',
        'The file system on your OTOBO partition is not writable.' => 'Није могуће писање у систем датотека на вашој OTOBO партицији.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Резервне копије прошлих конфигурација',
        'No legacy configuration backup files found.' => 'Нису пронађене резервне копије прошлих конфигурација.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Пронађене су резервне копије прошлих конфигурација у Kernel/Config/Backups, међутим могу бити неопходне за рад инсталираних пакета.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Резервне копије прошлих конфигурација више нису неопходне за рад инсталираних пакета, молимо уклоните их из Kernel/Config/Backups.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Статус инсталације пакета',
        'Some packages have locally modified files.' => 'Неки пакети садрже локално измењене датотеке.',
        'Some packages are not correctly installed.' => 'Неки пакети нису исправно инсталирани.',
        'Package Verification Status' => 'Статус верификације пакета',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => 'Статус пакета за верзију система',
        'Some packages are not allowed for the current framework version.' =>
            'Неки пакети нису дозвољени за верзију вашег система. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Листа пакета',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Подешавања сесија',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'Имејлови у реду чекања',
        'There are emails in var/spool that OTOBO could not process.' => 'Постоје имејлови у var/spool које OTOBO не може да обради.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Ваша подешавање SystemID је неважеће, треба да садржи само цифре.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Подразумевани тип тикета',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'Подешени подразумевани тип тикета је неважећи или недостаје. Молимо промените подешавање Ticket::Type::Default и изаберите важећи тип тикета.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Тикет индекс модул',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Имате више од 60.000 тикета и треба да користите StaticDB модул. Погледајте администраторско упутство (Подешавање перформанси) за више информација.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Неисправни корисници са закључаним тикетима',
        'There are invalid users with locked tickets.' => 'Постоје неисправни корисници са закључаним тикетима.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Не би требало да имате више од 8.000 отворених тикета у систему.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Модул за индексну претрагу тикета',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Процес индексирања ће укључити спремање оригиналног текста чланка у индексу претраге, без извршавања филтера или уклањања зауставних речи. Ово ће увећати величину индекса претраге и може успорити текстуалну претрагу.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Напуштени записи у ticket_lock_index табели',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Табела ticket_lock_index садржи неповезане записе. Молимо да покренете bin/otobo.Console.pl Maint::Ticket::QueueIndexCleanup да би очистили StaticDB индекс.',
        'Orphaned Records In ticket_index Table' => 'Напуштени записи у ticket_index табели',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Табела ticket_lindex садржи неповезане записе. Молимо да покренете bin/otobo.Console.pl Maint::Ticket::QueueIndexCleanup да би очистили StaticDB индекс.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Подешавања времена',
        'Server time zone' => 'Временска зона сервера',
        'OTOBO time zone' => 'OTOBO временска зона',
        'OTOBO time zone is not set.' => 'OTOBO временска зона није подешена.',
        'User default time zone' => 'Подразумевана временска зона корисника',
        'User default time zone is not set.' => 'Подразумевана временска зона корисника није подешена.',
        'Calendar time zone is not set.' => 'Временска зона календара није подешена.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - изгледи интерфејса оператера у коришћењу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - теме интерфејса оператера у коришћењу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - посебне статистике',
        'Agents using custom main menu ordering' => 'Оператери са прилагођеним редоследом главног менија',
        'Agents using favourites for the admin overview' => 'Оператери са омиљеним ставкама за администраторски преглед',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Веб сервер',
        'Loaded Apache Modules' => 'Учитани Apache модули',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM модел',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO захтева да Apache буде покренут са \'prefork\' MPM моделом.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Употреба CGI Accelerator',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'За повећање перформанси треба да користите FastCGI или mod_perl.',
        'mod_deflate Usage' => 'Употреба mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Молимо инсталирајте mod_deflate за убрзавање графичког интерфејса.',
        'mod_filter Usage' => 'Коришћење mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Молимо да инсталирате mod_filter ако је mod_deflate употребљен.',
        'mod_headers Usage' => 'Употреба mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Молимо инсталирајте mod_headers за убрзавање графичког интерфејса.',
        'Apache::Reload Usage' => 'Употреба Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ili Apache2::Reload се користе као Perl модул и PerlInitHandler ради заштите од рестартовања веб сервера током инсталирања или надоградње модула.',
        'Apache2::DBI Usage' => 'Употреба Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI би требало користити за боље перформансе са унапред успостављеним везама са базом података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Променљиве за окружење',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Сакупљање података подршке',
        'Support data could not be collected from the web server.' => 'Подаци подршке не могу бити прикупљени са веб сервера.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Веб сервер верзија',
        'Could not determine webserver version.' => 'Не може да препозна веб сервер верзију.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Детаљи истовремених корисника',
        'Concurrent Users' => 'Истовремени корисници',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'У реду',
        'Problem' => 'Проблем',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Подешавање %s не постоји!',
        'Setting %s is not locked to this user!' => 'Подешавање %s није закључано на овог корисника!',
        'Setting value is not valid!' => 'Вредност подешавања је неважећа!',
        'Could not add modified setting!' => 'Није могуће додати промењено подешавање!',
        'Could not update modified setting!' => 'Није могуће ажурирати промењено подешавање!',
        'Setting could not be unlocked!' => 'Није могуће откључати подешавање!',
        'Missing key %s!' => 'Недостаје кључ %s!',
        'Invalid setting: %s' => 'Неважеће подешавање: %s',
        'Could not combine settings values into a perl hash.' => 'Није било могуће искомбиновати вредност подешавања у perl мапу.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Није било могуће обезбедити распоређивање за UserID \'%s\'!',
        'All Settings' => 'Сва подешавања',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Подразумевано',
        'Value is not correct! Please, consider updating this field.' => 'Вредност није исправна! Молимо освежите ово поље.',
        'Value doesn\'t satisfy regex (%s).' => 'Вредност не задовољава регуларни израз (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Омогућен',
        'Disabled' => 'Онемогућен',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'Систем није успео да израчуна кориснички Date у OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'Систем није успео да израчуна кориснички DateTime у OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Вредност није исправна! Молимо освежите овај модул.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Вредност није исправна! Молимо освежите ово подешавање.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Поништавање времена откључавања.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Учесник ћаскања',
        'Chat Message Text' => 'Порука ћаскања',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Неуспешна пријава! Нетачно је унето ваше корисничко име или лозинка.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Аутентификација је успела, али подаци о клијенту нису пронађени у бази. Молимо контактирајте администратора.',
        'Can`t remove SessionID.' => 'SessionID се не може уклонити.',
        'Logout successful.' => 'Успешна одјава.',
        'Feature not active!' => 'Функција није активна!',
        'Sent password reset instructions. Please check your email.' => 'Упутство за ресет лозинке је послато. Молимо проверите ваше имејлове.',
        'Invalid Token!' => 'Неважећи Токен!',
        'Sent new password to %s. Please check your email.' => 'Послата нова лозинка за %s. Молимо проверите ваше имејлове.',
        'Error: invalid session.' => 'Грешка: неважећа сесија.',
        'No Permission to use this frontend module!' => 'Немате дозволу за  употребу овог корисничког модула!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Аутентификација је успела, али подаци о клијенту нису пронађени у извору клијената. Молимо контактирајте администратора.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Поништавање лозинке није успело. Молимо контактирајте администратора',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Ова имејл адреса већ постоји. Молимо, пријавите се или ресетујте вашу лозинку.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Регистрација ове имејл адресе није дозвољено. Молимо да контактирате подршку.',
        'Added via Customer Panel (%s)' => 'Додато преко клијентског панела (%s)',
        'Customer user can\'t be added!' => 'Не може се додати клијент корисник!',
        'Can\'t send account info!' => 'Не могу послати инфо о налогу!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Креиран је нови налог. Подаци за пријаву послати %с. Молимо проверите ваш имејл.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Акција "%s" није пронађена!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'неважећи-привремено',
        'Group for default access.' => 'Група за подразумеван приступ.',
        'Group of all administrators.' => 'Група свих администратора.',
        'Group for statistics access.' => 'Група за приступ статистици.',
        'new' => 'ново',
        'All new state types (default: viewable).' => 'Сви нови типови стања (подразумевано: видљиво).',
        'open' => 'отворени',
        'All open state types (default: viewable).' => 'Сви отворени типови стања (подразумевано: видљиво).',
        'closed' => 'затворени',
        'All closed state types (default: not viewable).' => 'Сви затворени типови стања (подразумевано: видљиво).',
        'pending reminder' => 'подсетник чекања',
        'All \'pending reminder\' state types (default: viewable).' => 'Сви типови стања "подсетник на чекању" (подразумевано: видљиво).',
        'pending auto' => 'аутоматско чекање',
        'All \'pending auto *\' state types (default: viewable).' => 'Сви типови стања "подсетник аутоматски *" (подразумевано: видљиво).',
        'removed' => 'уклоњени',
        'All \'removed\' state types (default: not viewable).' => 'Сви типови стања "уклоњено" (подразумевано: видљиво).',
        'merged' => 'спојено',
        'State type for merged tickets (default: not viewable).' => 'Тип стања за спојене тикете (подразумевано: није видљиво).',
        'New ticket created by customer.' => 'Нови тикет који је отворио клијент.',
        'closed successful' => 'затворено успешно',
        'Ticket is closed successful.' => 'Тикет је затворен успешно.',
        'closed unsuccessful' => 'затворено неуспешно',
        'Ticket is closed unsuccessful.' => 'Тикет је затворен неуспешно.',
        'Open tickets.' => 'Отворени тикети.',
        'Customer removed ticket.' => 'Клијент је уклонио тикет.',
        'Ticket is pending for agent reminder.' => 'Тикет је на чекању за оператерски подсетник.',
        'pending auto close+' => 'чекање на аутоматско затварање+',
        'Ticket is pending for automatic close.' => 'Тикет је на чекању за аутоматско затварање.',
        'pending auto close-' => 'чекање на аутоматско затварање-',
        'State for merged tickets.' => 'Статус за спојене тикете.',
        'system standard salutation (en)' => 'стандардни системски поздрав (en)',
        'Standard Salutation.' => 'Стандардни Поздрав',
        'system standard signature (en)' => 'стандардни системски потпис (en)',
        'Standard Signature.' => 'Стандардни потпис.',
        'Standard Address.' => 'Стандардна адреса.',
        'possible' => 'могуће',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Настављање на затворене тикете је могуће. Тикети ће бити поново отворени.',
        'reject' => 'одбаци',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Настављање на затворене тикете није могуће. Нови тикет неће бити креиран.',
        'new ticket' => 'нови тикет',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Настављање на затворене тикете није могуће. Нови тикет ће бити креиран.',
        'Postmaster queue.' => 'Postmaster ред.',
        'All default incoming tickets.' => ' Сви подразумевани долазни тикети.',
        'All junk tickets.' => 'Сви бесмислени тикети junk.',
        'All misc tickets.' => 'Сви други тикети.',
        'auto reply' => 'аутоматски одговор',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Аутоматски одговор који ће бити послат после креирања новог тикета.',
        'auto reject' => 'аутоматско одбацивање',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Аутоматска порука која ће бити послата након одбацивања наставка (у случају да је опција наставка за ред постављена на "одбаци").',
        'auto follow up' => 'аутоматско праћење',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Аутоматска потврда која ће бити послата након примања наставка у тикету (у случају да је опција наставка за ред постављена на "могуће").',
        'auto reply/new ticket' => 'аутоматски одговор/нови тикет',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Аутоматски одговор који ће бити послат након одбацивања наставка и креирања новог тикета (у случају да је опција наставка за ред постављена на "нови тикет").',
        'auto remove' => 'аутоматско уклањање',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Аутоматско уклањање ће бити послато кад клијент уклони захтев.',
        'default reply (after new ticket has been created)' => 'подразумевани одговор (после креирања новог тикета)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'подразумевано одбацивање (после настављања и одбацивања затвореног тикета)',
        'default follow-up (after a ticket follow-up has been added)' => 'подразумевано наствљање (после додавања настављања на тикет)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'подразумевано одбацивање/креиран нови тикет (после затвореног настављања са креирањем новог тикета)',
        'Unclassified' => 'Неразврстано',
        '1 very low' => '1 врло низак',
        '2 low' => '2 низак',
        '3 normal' => '3 нормалан',
        '4 high' => '4 висок',
        '5 very high' => '5 врло висок',
        'unlock' => 'откључан',
        'lock' => 'закључан',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'оператер',
        'system' => 'систем',
        'customer' => 'клијент',
        'Ticket create notification' => 'Обавештење о креирању тикета',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Добићете обавештење сваки пут кад се креира нови тикет у једном од ваших "Моји редови" или "Моји сервиси".',
        'Ticket follow-up notification (unlocked)' => 'Обавештење о настављању тикета (откључано)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Добићете обавештење када корисник пошаље наставак у откључаном тикету који се налази у "Моји редови" или "Моје услуге".',
        'Ticket follow-up notification (locked)' => 'Обавештење о настављању тикета (закључано)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Добићете обавештење када корисник пошаље наставак у закључаном тикету чији сте власник или одговорни.',
        'Ticket lock timeout notification' => 'Обавештење о истицању закључавања тикета',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Добићете обавештење одмах након аутоматског откључавања тикета чији сте власник.',
        'Ticket owner update notification' => 'Обавештење о ажурирању власника тикета',
        'Ticket responsible update notification' => 'Обавештење о ажурирању одговорног за тикет',
        'Ticket new note notification' => 'Обавештење о новој напомени тикета',
        'Ticket queue update notification' => 'Обавештење о ажурирању реда тикета',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Добићете обавештење ако се тикет премести у један од ваших "Моји редови".',
        'Ticket pending reminder notification (locked)' => 'Обавештење - подсетник тикета на чекању (закључано)',
        'Ticket pending reminder notification (unlocked)' => 'Обавештење - подсетник тикета на чекању (откључано)',
        'Ticket escalation notification' => 'Обавештење о ескалацији тикета',
        'Ticket escalation warning notification' => 'Обавештење о упозорењу на ескалацију тикета',
        'Ticket service update notification' => 'Обавештење о ажурирању услуге тикета',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Добићете обавештење ако се сервис тикета промени у један од ваших "Моји сервиси".',
        'Appointment reminder notification' => 'Обавештење подсетника о термину',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Добићете обавештење сваки пут кадa дође до времена подсетника за неки од ваших термина.',
        'Ticket email delivery failure notification' => 'Обавештење о неуспелом слању имејла тикета',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Грешка приликом AJAX комуникације. Статус: %s, грешка %s',
        'This window must be called from compose window.' => 'Овај прозор мора бити позван од стране прозора за писање.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Додај све',
        'An item with this name is already present.' => 'Већ је присутна тавка под овим именом.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ова ставка и даље садржи подставке. Да ли сте сигурни да желите да уклоните ову ставку укључујући и њене подставке?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Више',
        'Less' => 'Мање',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Притисните Ctrl+C (Cmd+C) за копирање',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Обриши овај прилог',
        'Deleting attachment...' => 'Брисање прилога...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Грешка приликом брисања прилога. Молимо проверите лог датотеку за више информација.',
        'Attachment was deleted successfully.' => 'Прилог је успешно обрисан.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Да ли стварно желите да обришете ово динамичко поље? Сви повезани подаци ће бити ИЗГУБЉЕНИ!',
        'Delete field' => 'Обриши поље',
        'Deleting the field and its data. This may take a while...' => 'Брисање поља и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Уклони ово динамичко поље',
        'Remove selection' => 'Уклони избор',
        'Do you really want to delete this generic agent job?' => 'Да ли стварно желите да обришете овај посао генеричког оператера?',
        'Delete this Event Trigger' => 'Obriši ovaj okidač događaja',
        'Duplicate event.' => 'Направи дупликат догађаја.',
        'This event is already attached to the job, Please use a different one.' =>
            'Овај догађај је приложен послу. Молимо користите неки други.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Дошло је до грешке приликом комуникације.',
        'Request Details' => 'Детаљи захтева',
        'Request Details for Communication ID' => 'Детаљи захтева за ID комуникације',
        'Show or hide the content.' => 'Покажи или сакриј садржај.',
        'Clear debug log' => 'Очисти отклањање грешака у логу',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Обриши модул за обраду грешке',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Није могуће додати нови окидач догађаја зато што догађај још увек није дефинисан.',
        'Delete this Invoker' => 'Обриши овог позиваоца',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Жао нам је, последњи услов не може бити уклоњен.',
        'Sorry, the only existing field can\'t be removed.' => 'Жао нам је, последње поље не може бити уклоњено.',
        'Delete conditions' => 'Обриши услове',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Мапирање за кључ %s',
        'Mapping for Key' => 'Мапирање за кључ',
        'Delete this Key Mapping' => 'Обриши мапирање за овај кључ',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Обриши ову операцију',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Клонирај веб сервис',
        'Delete operation' => 'Обриши операцију',
        'Delete invoker' => 'Обриши позиваоца',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'УПОЗОРЕЊЕ: Ако промените назив групе \'admin\' пре адекватног подешавања у системској конфигурацији, изгубићете приступ административном панелу! Уколико се то деси, вратите назив групи у admin помоћу SQL команде.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Обриши овај имејл налог',
        'Deleting the mail account and its data. This may take a while...' =>
            'Брисање имејл налога и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Да ли стварно желите да избришете овај језик за обавештења?',
        'Do you really want to delete this notification?' => 'Да ли стварно желите да обришете ово обавештење?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Да ли заиста желите да обришете овај кључ?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Ажурирање пакета је у току, кликните овде за статус напредовања.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'Ажурирање пакета је завршено. Кликните овде за резултате.',
        'No response from get package upgrade result.' => 'Без одговора од команде за унапређење пакета.',
        'Update all packages' => 'Ажурирај све пакете',
        'Dismiss' => 'Поништи',
        'Update All Packages' => 'Ажурирај све пакете',
        'No response from package upgrade all.' => 'Без одговора од команде за унапређење свих пакета.',
        'Currently not possible' => 'Тренутно није могуће',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Ова функција је тренутно искључена због ажурирања пакета у току.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Ова функција је тренутно искључена зато што OTOBO сервис не ради.',
        'Are you sure you want to update all installed packages?' => 'Да ли сте сигурни да желите да унапредите све инсталиране пакете?',
        'No response from get package upgrade run status.' => 'Без одговора од команде за статус унапређења пакета.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Обриши овај PostMaster филтер',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Брисање PostMaster филтера и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Уклони објекат са површине',
        'No TransitionActions assigned.' => 'Нема додељених транзиционих активности.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Још увек нема додељених дијалога. Само изаберите један дијалог активности из листе са леве стране и превуците га овде.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Ова активност се не може брисати, зато што је то почетак активности.',
        'Remove the Transition from this Process' => 'Уклони транзицију из овог процеса',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Уколико користите ово дугме или везу, напустићете екран и његов тренутни садржај ће бити аутоматски сачуван. Желите ли да наставите?',
        'Delete Entity' => 'Избриши објекат',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Ова активност је већ коришћена у процесу. Не можете је додавати два пута.',
        'Error during AJAX communication' => 'Грешка приликом AJAX комуникације',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Неповезана транзиција је већ постављена на површину. Молимо повежите прву транзицију пре него што поставите другу транзицију.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Ова транзиција је већ коришћена за ову активност. Не можете је користити два пута.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ова транзициона тктивност је већ коришћена у овој путањи. Не можете је користити два пута.',
        'Hide EntityIDs' => 'Сакриј EntityIDs',
        'Edit Field Details' => 'Уреди детаље поља',
        'Customer interface does not support articles not visible for customers.' =>
            'Клијентски интерфејс не подржава чланке који нису видљиви клијентима.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Жао нам је, последњи параметар не може бити уклоњен.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Да ли стварно желите да обришете овај сертификат?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Слање ажурирања...',
        'Support Data information was successfully sent.' => 'Информације подржаних података су успешно послате.',
        'Was not possible to send Support Data information.' => 'Није могуће послати информације подржаних података.',
        'Update Result' => 'Резултат ажурирања',
        'Generating...' => 'Генерисање...',
        'It was not possible to generate the Support Bundle.' => 'Није могуће генерисати Пакет подршке.',
        'Generate Result' => 'Генериши резултат',
        'Support Bundle' => 'Пакет подршке',
        'The mail could not be sent' => 'Имејл се не може послати',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Није могуће обележити ову ставку као неважећу. Сва зависна подешавања у конфигурацији морају бити прво измењена.',
        'Cannot proceed' => 'Није могуће наставити',
        'Update manually' => 'Ажурирај ручно',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Можете или ажурирати сва зависна подешавања аутоматски на промене које сте направили или да то одрадите ручно кликом на \'Aжурирај ручно\'.',
        'Save and update automatically' => 'Сачувај и ажурирај аутоматски',
        'Don\'t save, update manually' => 'Одустани и ажурирај ручно',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'Ставка коју тренутно гледате је део нераспоређене конфигурације, и није могуће уредити је у тренутном стању. Молимо сачекајте док подешавање не буде распоређено. Уколико нисте сигурни како да наставите, молимо контактирајте вашег администратора.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Учитавање...',
        'Search the System Configuration' => 'Претрага системске конфигурације',
        'Please enter at least one search word to find anything.' => 'Молимо унесите барем једну кључну реч да би сте нешто пронашли.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Нажалост, распоређивање тренутно није могуће, вероватно зато што други корисник већ распоређује. Молимо покушајте касније.',
        'Deploy' => 'Распореди',
        'The deployment is already running.' => 'Распоређивање је већ у току.',
        'Deployment successful. You\'re being redirected...' => 'Распоређивање успешно, бићете преусмерени...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Догодила се грешка. Молимо сачувајте сва подешавања која уређујете и проверите лог датотеку за више информација.',
        'Reset option is required!' => 'Поништавање је обавезно!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Обнављањем овог распореда сва подешавања ће бити враћена на вредност коју су имала у време распореда. Да ли стварно желите да наставите?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Кључеви са вредностима не могу бити промењени. Молимо уклоните овај пар кључ/вредност и додајте га поново.',
        'Unlock setting.' => 'Откључај подешавање.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Да ли стварно желите да обришете ово планирано оржавање система?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Обриши овај шаблон',
        'Deleting the template and its data. This may take a while...' =>
            'Брисање шаблона и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Скочи',
        'Timeline Month' => 'Месечна оса',
        'Timeline Week' => 'Седмична оса',
        'Timeline Day' => 'Дневна оса',
        'Previous' => 'Назад',
        'Resources' => 'Ресурси',
        'Su' => 'не',
        'Mo' => 'по',
        'Tu' => 'ут',
        'We' => 'ср',
        'Th' => 'че',
        'Fr' => 'пе',
        'Sa' => 'су',
        'This is a repeating appointment' => 'Овај термин се понавља',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Да ли желите да измени само ово или сва понављања?',
        'All occurrences' => 'Сва понављања',
        'Just this occurrence' => 'Само ово понављање',
        'Too many active calendars' => 'Превише активних календара',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Или прво искључите приказ неког календара или повећајте лимит у конфигурацији.',
        'Restore default settings' => 'Вратите подразумевана подешавања',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Да ли сте сигурни да желите да избришете овај термин? Ову операцију није могуће опозвати.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Прво одаберите клијент корисника, онда можете одабрати ID клијента за доделу овом тикету.',
        'Duplicated entry' => 'Двоструки унос',
        'It is going to be deleted from the field, please try again.' => 'Биће обрисано из поља, молимо покушајте поново.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Молимо унесите барем једну вредност претраге или * да би сте нешто пронашли.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Информације о OTOBO системском сервису',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Молимо проверите поља означена црвеним за важеће уносе.',
        'month' => 'месец',
        'Remove active filters for this widget.' => 'Уклони активне филтере за овај додатак.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Молимо сачекајте...',
        'Searching for linkable objects. This may take a while...' => 'Претрага објеката за повезивање. Ово може мало потрајати...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Да ли заиста желите да обришете ову везу?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Да ли користите додатак за претраживач као што су AdBlock или AdBlockPlus? Ово може резултирати у неколико проблема и топло препоручујемо да додате изузетак за ову страну.',
        'Do not show this warning again.' => 'Не приказуј поново ово упозорење.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Извините али не можете искључити све методе за обавештења означена као обавезна.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Извините али не можете искључити све методе за ово обавештење.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Напомињемо да најмање једно подешавање које сте изменили захтева поновно учитавање странице. Кликните овде за поновно учитавање екрана.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Догодила се непозната грешка. Молимо контактирајте администратора.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Пређи на десктоп мод',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Молимо да уклоните следеће речи из ваше претраге јер се не могу тражити:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Генериши',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Овај елемент има децу и тренутно не може бити уклоњен.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Да ли стварно желите да обришете ову статистику?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Одаберите ID клијента за доделу овом тикету',
        'Do you really want to continue?' => 'Да ли стварно желите да наставите?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...и још %s',
        ' ...show less' => '...прикажи мање',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Додај нови нацрт',
        'Delete draft' => 'Обриши нацрт',
        'There are no more drafts available.' => 'Тренутно нема више нацрта.',
        'It was not possible to delete this draft.' => 'Није било могуће обрисати овај нацрт.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Филтер за чланке',
        'Apply' => 'Примени',
        'Event Type Filter' => 'Филтер типа догађаја',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Померите навигациону траку',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Молимо да искључите мод компатибилности у Интернет експлореру!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Пређи на мобилни мод',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Грешка: провера претраживача није успела!',
        'Reload page' => 'Освежи страницу',
        'Reload page (%ss)' => 'Освежи страницу (%sс)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Скрипт %s није било могуће иницијализовати, јер %s није пронађен.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'Догодила се грешка! Молимо проверите лог претраживача за више информација!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Дошло је до једне или више грешака!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Успешна провера имејл подешавања.',
        'Error in the mail settings. Please correct and try again.' => 'Грешка у подешавању имејла. Молимо исправите и покушајте поново.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'Отвори ову ставку у новом прозору',
        'Please add values for all keys before saving the setting.' => 'Молимо унесите вредности за све кључеве пре него што сачувате подешавање.',
        'The key must not be empty.' => 'Кључ не сме бити празан.',
        'A key with this name (\'%s\') already exists.' => 'Кључ са овим називом (\'%s\') већ постоји.',
        'Do you really want to revert this setting to its historical value?' =>
            'Да ли стварно желите да поништите ово подешавање на његову претходну вредност?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Отвори избор датума',
        'Invalid date (need a future date)!' => 'Неисправан датум (неопходан датум у будућности)!',
        'Invalid date (need a past date)!' => 'Неисправан датум (неопходан датум у прошлости)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Није доступно',
        'and %s more...' => 'и %s више...',
        'Show current selection' => 'Прикажи тренутни избор',
        'Current selection' => 'Тренутни избор',
        'Clear all' => 'Очисти све',
        'Filters' => 'Филтери',
        'Clear search' => 'Очисти претрагу',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Ако напустите ову страницу, сви отворени прозори ће бити затворени!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Приказ овог екрана је већ отворен. Желите ли да га затворите и учитате овај уместо њега?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Није могуће отворити искачући прозор. Молимо да искључите блокаду искачућих прозора за ову апликацију.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Растуће сортирање,',
        'Descending sort applied, ' => 'Опадајуће сортирање,',
        'No sort applied, ' => 'Без сортирања,',
        'sorting is disabled' => 'сортирање је искључено',
        'activate to apply an ascending sort' => 'сортирај растуће',
        'activate to apply a descending sort' => 'сортирај опадајуће',
        'activate to remove the sort' => 'искључи сортирање',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Уклони филтер',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Тренутно нема слободних елемената за одабир.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Молимо да изаберете само једну датотеку за отпремање.',
        'Sorry, you can only upload one file here.' => 'Жао нам је, овде можете отпремити само једну датотеку.',
        'Sorry, you can only upload %s files.' => 'Жао намо је, можете отпремити само %s датотеке(а).',
        'Please only select at most %s files for upload.' => 'Молимо да изаберете највише %s датотеке(а) за отпремање.',
        'The following files are not allowed to be uploaded: %s' => 'Није дозвољено отпремање следећих датотека: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Следеће датотеке премашују највећу дозвољену величину од %s и нису биле отпремљене: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Следеће датотеке су већ биле отпремљене и нису додате поново: %s',
        'No space left for the following files: %s' => 'За следеће датотеке нема више места: %s',
        'Available space %s of %s.' => 'Расположив простор %s од %s.',
        'Upload information' => 'Информације о отпремању',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Догодила се непозната грешка приликом брисања прилога. Молимо покушајте поново. Ако се грешка поново, молимо контактирајте вашег администратора.',

        # JS File: Core.Language.UnitTest
        'yes' => 'да',
        'no' => 'не',
        'This is %s' => 'Ово је %s',
        'Complex %s with %s arguments' => 'Комплексан %s са %s аргумената',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'Нема информација.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Груписано',
        'Stacked' => 'Наслагано',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Проток',
        'Expanded' => 'Проширено',

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
