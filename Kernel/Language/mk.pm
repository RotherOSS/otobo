# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::Language::mk;

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
    $Self->{Completeness}        = 0.406904761904762;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ЛКП Менаџмент',
        'Actions' => 'Акции',
        'Create New ACL' => 'Креирај Ново ЛКП',
        'Deploy ACLs' => 'распоредување на ЛКП',
        'Export ACLs' => 'Извези ЛКПа',
        'Filter for ACLs' => 'Филтер за ЛКПа',
        'Just start typing to filter...' => 'Само почните да пишувате и да ги филтрираат ...',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Тука можеш да прикачиш конфигурациска датотека да увезеш ЛКПа во твојот систем. Датотеката треба да биде во .yml формат како извоз од ЛКП уредник модулот.',
        'This field is required.' => 'Ова поле е потребно.',
        'Overwrite existing ACLs?' => 'Презапиши постојачки ЛКПа?',
        'Upload ACL configuration' => 'Прикачи ЛКП конфигурација',
        'Import ACL configuration(s)' => 'Увези ЛКП конфигураци(а/и)',
        'Description' => 'Опис',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'За да креирате нов ЛКП можете или увоз ЛКП кои се извезуваат од друг систем или се создаде комплетен нов.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Менување на ЛКПата тука има само ефект на однесувањете на системот , ако ги распоредите податоците на ЛКП подоцна. Со распоредувањето на податоците на ЛКП, најново направените промени ќе бидат запишани во конфигурацијата.',
        'ACLs' => 'ЛКПа',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Забелешка: Оваа табела го претставува распоредот на извршување на ЛКПата. Ако имате потреба да го проментире распоредот на извршување на ЛКПата, ве молиме сменете ги имињата на засегнатите ЛКПа.',
        'ACL name' => 'ЛКП име',
        'Comment' => 'Коментари',
        'Validity' => 'Валидност',
        'Export' => 'Извоз',
        'Copy' => 'Копирај',
        'No data found.' => 'Не се пронајдени податоци.',
        'No matches found.' => 'Не е пронајдено.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'уреди ЛКП %s',
        'Edit ACL' => '',
        'Go to overview' => 'Оди на преглед',
        'Delete ACL' => 'Избриши ЛКП',
        'Delete Invalid ACL' => 'Избриши невалиден ЛКП',
        'Match settings' => 'прилагодувања на Натпревар',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Постави содветен критериум за ова ЛКП. Користи  \'Properties\' за да одговара на сегашниов екран или  \'PropertiesDatabase\' за да одговара на атрибутите на сегашниов тикет кој е во базата со податоци.',
        'Change settings' => 'Измени прилагодување',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Поставете ги промените за совшаѓањата со овој критериум. Имајте на ум дека \'Possible\' е белата листа, \'PossibleNot\' е црната листа.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Прикаже или скрие содржината',
        'Edit ACL Information' => '',
        'Name' => 'Име',
        'Stop after match' => 'Стоп по натпревар',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Зачувај',
        'or' => 'или',
        'Save and finish' => 'Зачувај и заврши',
        'Cancel' => 'Откажи',
        'Do you really want to delete this ACL?' => 'Дали навистина саката да го избиршете ова ЛКП?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Креирај нов ЛКП со доставување на податоци од формуларот. По креирањето на ЛКПто, ќе бидете во можност да го додадете конфигурациски ставки во режим на уредување.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '',
        'Add Calendar' => '',
        'Edit Calendar' => '',
        'Calendar Overview' => '',
        'Add new Calendar' => '',
        'Import Appointments' => '',
        'Calendar Import' => '',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '',
        'Overwrite existing entities' => 'Презапиши постојачки ентитети',
        'Upload calendar configuration' => '',
        'Import Calendar' => '',
        'Filter for Calendars' => '',
        'Filter for calendars' => '',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '',
        'Read only: users can see and export all appointments in the calendar.' =>
            '',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '',
        'Create: users can create and delete appointments in the calendar.' =>
            '',
        'Read/write: users can manage the calendar itself.' => '',
        'Group' => 'Група',
        'Changed' => 'Променето',
        'Created' => 'Креирано',
        'Download' => 'Превземи',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Календар',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => '',
        'Remove this entry' => 'Избришете го овој внес',
        'Remove' => 'Избриши',
        'Start date' => 'Почетен датум',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Редици ',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Додај внес',
        'Add' => 'Додади',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Прати',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'Врати се назад',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Прикачи',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Додај Известување',
        'Edit Notification' => 'Уреди го Известувањето',
        'Export Notifications' => '',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'List' => 'Листа',
        'Delete' => 'Избриши',
        'Delete this notification' => 'Избришете го ова известување',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Toggle this widget' => 'Префли го овој елемент',
        'Events' => 'Настани',
        'Event' => 'Настан',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Тип',
        'Title' => 'Наслов',
        'Location' => 'Локација',
        'Team' => '',
        'Resource' => '',
        'Recipients' => '',
        'Send to' => '',
        'Send to these agents' => '',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => '',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => '',
        'Transport' => '',
        'At least one method is needed per notification.' => '',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'Upgrade to %s' => 'Надградба на %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Subject' => 'Предмет',
        'Text' => 'Текст',
        'Message body' => '',
        'Add new notification language' => '',
        'Save Changes' => 'Зачувај Промени',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'Можеш да ги користиш следниве тагови',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'пример',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => 'Конфигурациски опции',
        'Example notification' => '',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'Управување со Прикачувања',
        'Add Attachment' => 'Додај Прикачување',
        'Edit Attachment' => 'Уреди прикачување',
        'Filter for Attachments' => 'Филтер за Прилози',
        'Filter for attachments' => '',
        'Filename' => 'Име на датотека',
        'Download file' => 'Преземи документ',
        'Delete this attachment' => 'Избриши го ова прикачување',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'Прилог',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Менаџмент за автоматски одговор',
        'Add Auto Response' => 'Додади Автоматски Одговор',
        'Edit Auto Response' => 'Уреди автоматски одговор',
        'Filter for Auto Responses' => 'Филтер за Автоматски Одговори',
        'Filter for auto responses' => '',
        'Response' => 'Одговор',
        'Auto response from' => 'Форма на автоматски одговор',
        'Reference' => 'Референца',
        'To get the first 20 character of the subject.' => 'Да се добијат првите 20 карактери на оваа предмет.',
        'To get the first 5 lines of the email.' => 'Да ги земете првите 5 линии од е-адресата.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'За да ги земеш атрибутите на натпис',
        'Options of the current customer user data' => 'Опции за сегашниот потрошувач кориснички податоци',
        'Ticket owner options' => 'сопственик на Тикет опции',
        'Ticket responsible options' => 'Тикет опции со одговорности',
        'Options of the current user who requested this action' => 'Опции за тековниот корисник кој побара оваа акција',
        'Options of the ticket data' => 'Опции од податоците на тикетот',
        'Options of ticket dynamic fields internal key values' => 'Опции за вредностите на внатрешни клучните на динамички полиња на тикет.',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Опции од тикет динамичките полиња прикажани вредности, корисни за Dropdown и Multiselect полиња',
        'Example response' => 'Пример одговор',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'Навестување',
        'Currently support data is only shown in this system.' => '',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Конфигурација',
        'Send support data' => 'Испрати податоци за поддршка',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Ажурирање',
        'System Registration' => 'Регистрација на Систем',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Регистрирај го овој Систем',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Систем Регистрацијата е оневозможена за вашиот систем. Ве молиме проверете ја вашата конфигурација.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',

        # Template: AdminCommunicationLog
        'Communication Log' => '',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '',
        'Filter for Communications' => '',
        'Filter for communications' => '',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => '',
        'Failing accounts' => '',
        'Some account problems' => '',
        'No account problems' => '',
        'No account activity' => '',
        'Number of accounts with problems: %s' => '',
        'Number of accounts with warnings: %s' => '',
        'Failing communications' => '',
        'No communication problems' => '',
        'No communication logs' => '',
        'Number of reported problems: %s' => '',
        'Open communications' => '',
        'No active communications' => '',
        'Number of open communications: %s' => '',
        'Average processing time' => '',
        'List of communications (%s)' => '',
        'Settings' => 'Подесувања',
        'Entries per page' => '',
        'No communications found.' => '',
        '%s s' => '',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '',
        'Account status for: %s' => '',
        'Status' => 'Статус',
        'Account' => '',
        'Edit' => 'Уреди',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Насока',
        'Start Time' => 'Време на започнување',
        'End Time' => 'Крај',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Приоритет',
        'Module' => 'Модул',
        'Information' => 'Информации',
        'No log entries found.' => '',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '',
        'Filter for Log Entries' => '',
        'Filter for log entries' => '',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => '',
        'No communication objects found.' => '',
        'Communication Log Details' => '',
        'Please select an entry from the list.' => '',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => '',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Назад до резултатите од барањето',
        'Select' => 'Избери',
        'Search' => 'Барај',
        'Wildcards like \'*\' are allowed.' => 'Дозволени се глобални знаци како "*".',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Валидно',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Управување со Клиенти',
        'Add Customer' => 'Додај потрошувач',
        'Edit Customer' => 'Уреди Клиент ',
        'List (only %s shown - more available)' => '',
        'total' => '',
        'Please enter a search term to look for customers.' => 'Ве молиме внесете термин за пребарување за пронаоѓање на клиентот.',
        'Customer ID' => '',
        'Please note' => 'Ве молиме имајте во предвид',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Менаџирај Потрошувач-Групни Релации',
        'Notice' => 'Напомена',
        'This feature is disabled!' => 'Ова карактеристика е оневозможена!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Искористи ја оваа опција ако сакате да дефинирате групни дозволи за клиентите.',
        'Enable it here!' => 'Овозможи тука!',
        'Edit Customer Default Groups' => 'Измени ја Стандардната Групи на Корисници',
        'These groups are automatically assigned to all customers.' => 'Овие групи се автоматски доделени на сите потрошувачи.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Филтер за Групи',
        'Select the customer:group permissions.' => 'Селектирај го потрушувачот:групни дозволи.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ако ништо не е селектирано, тогаш нема да има дозволи во оваа група(тикети нема да бидат достапни за овој потрошувач).',
        'Search Results' => 'Резултати од барањето',
        'Customers' => 'Корисници',
        'Groups' => 'Групи',
        'Change Group Relations for Customer' => 'Промени група за односи со клиенти',
        'Change Customer Relations for Group' => 'Промени Потрошувачки Релации за Група',
        'Toggle %s Permission for all' => 'Промени % s Дозвола за сите',
        'Toggle %s permission for %s' => 'Префрли %s дозволи за %s',
        'Customer Default Groups:' => 'За Кориснки Стандардна Група:',
        'No changes can be made to these groups.' => 'Неможат да се направат промени на овие групи.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Само читај пристап до тикет во оваа група/редица.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Целосен пристап за читање и запишување во оваа група/редица.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Управување со Корисници Клиенти',
        'Add Customer User' => 'Додади Корисник',
        'Edit Customer User' => 'Уреди Потрошувач Корисник',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Корисник-клиент е потребен за да имаат историјата на корисник и да се најавите преку кориснички панел.',
        'List (%s total)' => '',
        'Username' => 'Корисничко име',
        'Email' => 'е-пошта',
        'Last Login' => 'Последно Вклучување',
        'Login as' => 'Најави се како',
        'Switch to customer' => 'Премини на потрошувач',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Ова поле е задолжително и треба да биде валидна е-адреса.',
        'This email address is not allowed due to the system configuration.' =>
            'Оваа е-мајл адреса не е дозволена поради системската конфигурација.',
        'This email address failed MX check.' => 'Оваа е-адреса не задоволува МX поверка.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS проблем, ве молиме проверете ја вашата конфигурација и логовите со грешки.',
        'The syntax of this email address is incorrect.' => 'Синтаксата на оваа е-адреса е неточна.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Корисник',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => '',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Префрли активна состојба за сите',
        'Active' => 'Активно',
        'Toggle active state for %s' => 'Префрли активна состојба за %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Можете да ги менаџирате овие групи преко конфигурациските подесувања "CustomerGroupAlwaysGroups".',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Уреди стандардни срервиси',
        'Filter for Services' => 'Филтер за Услуги',
        'Filter for services' => '',
        'Services' => 'Услуги',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Управување со динамички полиња',
        'Add new field for object' => 'Додај ново поле за објектот',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'База на податоци',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'За да додадете ново поле, одберете тип на поле од листата на објекотот, објектот дефинита граници на полето и по негово креирање неможат да се променат.',
        'Dynamic Fields List' => 'Листа со динамички полиња',
        'Dynamic fields per page' => 'Динамички полиња по страници',
        'Label' => 'Етикета',
        'Order' => 'Подреди',
        'Object' => 'Објект',
        'Delete this field' => 'Избриши ова поле',

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
        'Dynamic Fields' => 'Динамички Полиња ',
        'Go back to overview' => 'Вратете се на преглед',
        'General' => 'Генерално',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ова поле е задолжително, и неговата вредност треба да е само со алфабетски и нумерички карактери.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Мора да е уникатно и само прифаќа алфанумерички карактери.',
        'Changing this value will require manual changes in the system.' =>
            'Променување на оваа вредност бара менуални промени во системот.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ова е името на приказ на екраните кога полето е активно.',
        'Field order' => 'Редослед на полето',
        'This field is required and must be numeric.' => 'Оваа поле е задолжително и мора да е нумеричко.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ова е распоредот по кој оваа поле ќе биде прикажано на екраните каде е активно.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Тип на објект',
        'Object type' => 'Тип на објект',
        'Internal field' => 'Внатрешно поле',
        'This field is protected and can\'t be deleted.' => 'Ова поле е заштитено и не можат да се избрише.',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Подесувања за Поле',
        'Default value' => 'Стандардна вредност',
        'This is the default value for this field.' => 'Ова е стандардната вредност за оваа поле.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Клуч',
        'Value' => 'Вредност',
        'Remove value' => 'Отстрани вредност',
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
        'Translatable values' => 'Преводливи вредности',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ако ја активирате оваа опција вредностите ќе бидат преведени на избраниот јазик.',
        'Note' => 'Забелешка',
        'You need to add the translations manually into the language translation files.' =>
            'Вие треба рачно да додадете преводи  во датотека со преводи.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Можни вредности',
        'Datatype' => '',
        'Filter' => 'Филтер',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Прикажи врска',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Тука можете да наведете опционален HTTP линк за вредноста на полето  во Прегледи и Зум екрани.',
        'Example' => 'Пример',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => '',
        'Driver' => '',
        'Server' => '',
        'Port' => '',
        'Table / View' => '',
        'User' => 'Корисник',
        'Password' => 'Лозинка',
        'Identifier' => 'Идентификатор',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => '',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Стандардна разлика на датуми',
        'This field must be numeric.' => 'Оваа после мора да е нумеричко.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Разликата од СЕГА (in seconds) за пресметување на стандардната вредност на полето (пример 3600 or -60).',
        'Define years period' => 'Дефинирај период во години',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Активирај ја оваа опција за да дефинираш фиксна граница на години (во иднината и во минатото) да бидат прикажани во делот на со години во полето.',
        'Years in the past' => 'Години во минатото',
        'Years in the past to display (default: 5 years).' => 'Години во минатото да се прикажат (стандардно: 5 години).',
        'Years in the future' => 'Години во иднината',
        'Years in the future to display (default: 5 years).' => 'Години во иднина да се прикажат (стандардно: 5 години).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => 'Забрани внесување на датуми',
        'Here you can restrict the entering of dates of tickets.' => 'Тука може да го ограничи внесувањето на датумите на билети.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Додади Вредност',
        'Add empty value' => 'Додај празна вредност',
        'Activate this option to create an empty selectable value.' => 'Активирајте ја оваа опција за да се создаде избор без вредности.',
        'Tree View' => 'Дрво Преглед',
        'Activate this option to display values as a tree.' => 'Вклучете ја оваа опција за прикажување на вредности како дрво.',

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
        'Fields' => 'Полиња',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Преглед',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Распоредување на елементите во листата е исто така овозможено со кликни повлечи и пушти.',
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
        'Reset' => 'Ресетирај',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Број на редови',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Наведете висина (во линии) за ова поле во режим на уредување.',
        'Number of cols' => 'Број на колони',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Наведи ја ширината (во карактери) за ова поле во режим на уредување.',
        'Check RegEx' => 'Провери RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Тука може да наведете регуларен израз за да се провери вредноста. Регуларнот израз ќе биде извршен со изменувачи xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Не валиден RegEx',
        'Error Message' => 'Пораќа за грешка',
        'Add RegEx' => 'Додај RegEx',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Шаблон',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Големина',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => '',
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
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Со овој модул, администарторите можат да праќаат пораки на агенти,групи или членови на групи.',
        'Create Administrative Message' => 'Креирај Административна Порака',
        'Your message was sent to' => 'Вашата порака е испратена до',
        'From' => 'Од',
        'Send message to users' => 'Испрати порака до корисниците',
        'Send message to group members' => 'Испрати порака до членовите на групата',
        'Group members need to have permission' => 'Членови на групата треба да имаат дозвола',
        'Send message to role members' => 'Прати порака на членови со улога',
        'Also send to customers in groups' => 'Исто така прати на потрошувачи во групи',
        'Body' => 'Тело',
        'Send' => 'Испрати',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Последен рок',
        'Run Now!' => 'Изврши Сега!',
        'Delete this task' => 'Избриши ја оваа задача',
        'Run this task' => 'Изврши ја оваа задача',
        'Job Settings' => 'Прилагодувања за работа',
        'Job name' => 'Име на работа',
        'The name you entered already exists.' => 'Името што го внесовте веќе постои.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Извршувачки Распоред',
        'Schedule minutes' => 'Распоред на минути',
        'Schedule hours' => 'Распоред на часови',
        'Schedule days' => 'Распоред на денови',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Моментално оваа генеричка работа на агент нема да се извршува автоматски.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'За да се овозможи автоматско извршување изберете најмалку една вредност од минути, часови и денови!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Настан Предизвикувачи',
        'List of all configured events' => 'Листа на сите конфигурирани настани',
        'Delete this event' => 'Избриши го настанот',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Додатно или алтернативо на периодично извршување, можете да дефинирате тикет настани кои ќе ја предизвикуваат оваа работа.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Ако настанот на билетот е отпуштен, ќе се примени билет филтер  за да се провери дали билетот пости. Само тогаш работата на тикетот ќе започне.',
        'Do you really want to delete this event trigger?' => 'Дали навистина сакате да го избришете овој предизвикувач на настан?',
        'Add Event Trigger' => 'Додај Настан Предизвикувач',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Изберете Тикет',
        '(e. g. 10*5155 or 105658*)' => '(пр. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(пр. 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(на пример: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Барај целосен текст во натписот (пр. "Mar*in" или "Baue*").',
        'To' => 'До',
        'Cc' => 'Cc',
        'Service' => 'Услуга',
        'Service Level Agreement' => 'Договор за Ниво на Услуга',
        'Queue' => 'Редица',
        'State' => 'Состојба',
        'Agent' => 'Агент',
        'Owner' => 'Сопственик',
        'Responsible' => 'Одговорен',
        'Ticket lock' => 'Заклучи тикет',
        'Dynamic fields' => '',
        'Add dynamic field' => '',
        'Create times' => 'Креирај времиња',
        'No create time settings.' => 'Не креира временски подесувања.',
        'Ticket created' => 'Создаден тикет',
        'Ticket created between' => 'Тикет креиран помеѓу',
        'and' => 'и',
        'Last changed times' => 'Последна промена на времето',
        'No last changed time settings.' => 'Не последно променети временски подесувања.',
        'Ticket last changed' => 'Последна промена на тикет',
        'Ticket last changed between' => 'Тикет последно променет помеѓу',
        'Change times' => 'Промена на време',
        'No change time settings.' => 'Не променети временски подесувања.',
        'Ticket changed' => 'Промена на тикет',
        'Ticket changed between' => 'Тикет променет помеѓу',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Затворено време',
        'No close time settings.' => 'Не затворени временски подесувања.',
        'Ticket closed' => 'Затворен тикет',
        'Ticket closed between' => 'Тикет затворен помеѓу',
        'Pending times' => 'Време на чекање',
        'No pending time settings.' => 'Не е во тек временски подесувања.',
        'Ticket pending time reached' => 'Тикет време на тек постигнато',
        'Ticket pending time reached between' => 'Тикет време на тек постигнато помеѓу',
        'Escalation times' => 'Време на ескалација',
        'No escalation time settings.' => 'Не ескалирачки временски подесувања.',
        'Ticket escalation time reached' => 'Достигнато е време на ескалација на тикетот',
        'Ticket escalation time reached between' => 'Тикет ескалациско време постигнато помеѓу',
        'Escalation - first response time' => 'Ескалација - време на првиот одговор',
        'Ticket first response time reached' => 'Прв одговор на тикет постигнато време',
        'Ticket first response time reached between' => 'Време на првиот одговор на тикетот достигнато помеѓу',
        'Escalation - update time' => 'Ескалација - ажурирај време',
        'Ticket update time reached' => 'Достигнато е времето за надградба на тикеток',
        'Ticket update time reached between' => 'Тикет време за надградби постигнато помеѓу',
        'Escalation - solution time' => 'Ескалација -  време за решение',
        'Ticket solution time reached' => 'Тикет време за решавање постигнато',
        'Ticket solution time reached between' => 'Време за решавање на тикетот постигнато помеѓу',
        'Archive search option' => 'Архивирај опции за барање',
        'Update/Add Ticket Attributes' => 'Ажурирање / Додај Атрибути за тикетот',
        'Set new service' => 'Постави нов сервис',
        'Set new Service Level Agreement' => 'Постави новов Договор за ниво на Сервис',
        'Set new priority' => 'Постави нов приоритет',
        'Set new queue' => 'Поставете нов ред',
        'Set new state' => 'Постави нова состјба',
        'Pending date' => 'Чекање до',
        'Set new agent' => 'Постави нов агент',
        'new owner' => 'новиот сопственик',
        'new responsible' => 'нова одговорност',
        'Set new ticket lock' => 'Поставете ново заклучување на тикетот',
        'New customer user ID' => '',
        'New customer ID' => 'Новиот ID кориснички ',
        'New title' => 'Нов наслов',
        'New type' => 'Нов тип',
        'Archive selected tickets' => 'Архива на избраните тикети',
        'Add Note' => 'Додај Белешка',
        'Visible for customer' => '',
        'Time units' => 'Временски единици',
        'Execute Ticket Commands' => 'Изврши Тикет Команди',
        'Send agent/customer notifications on changes' => 'Испрати известувања на агент / клиент за промени',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Оваа команда ќе биде извршена. ARG [0] ќе биде број на тикет. ARG [1] ID тикет.',
        'Delete tickets' => 'Избриши тикети',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Предупредување: Сите засегнати тикети ќе бидат избришани од базата на податоци и не можат да бидат вратени!',
        'Execute Custom Module' => 'Изврши Прилагоден Модул',
        'Param %s key' => 'Параметар %s клуч',
        'Param %s value' => 'Параметар %s вредност',
        'Results' => 'Резултати',
        '%s Tickets affected! What do you want to do?' => '%s Тикетите се опфатени! Што сакате да направите?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Предупредување: Ја искористивте опцијата ИЗБРИШИ. Сите избришани тикети ќе бидат изгубени!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'Тикетите се опфатени',
        'Age' => 'Возраст ',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Управување со Генерички интерфејс за Веб услуги',
        'Web Service Management' => '',
        'Debugger' => 'Дебагер',
        'Go back to web service' => 'Вратете се назад на веб сервис',
        'Clear' => 'Исчисти',
        'Do you really want to clear the debug log of this web service?' =>
            'Дали навистина сакате да го исчитите дебаг дневникот на веб сервисот?',
        'Request List' => 'Барана Листа',
        'Time' => 'Време',
        'Communication ID' => '',
        'Remote IP' => 'Далечинска IP',
        'Loading' => 'Вчитување',
        'Select a single request to see its details.' => 'Одбери единечно барање да ги видиш неговите детали.',
        'Filter by type' => 'Филтер по тип',
        'Filter from' => 'Филтер форма',
        'Filter to' => 'Филтер за',
        'Filter by remote IP' => 'Филтрирај спрема далечински IP',
        'Limit' => 'Лимит',
        'Refresh' => 'Освежи',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Сите конфигурациски податоци ќе бидат изгубени.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Ве молиме обезбедете уникатно име за овој веб сервис.',
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
        'Error message content filter' => '',
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
        'Error code' => '',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => '',
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
        'Do you really want to delete this invoker?' => 'Дали навистина сакате да го избришете овој invoker?',
        'Invoker Details' => 'Invoker Детали',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Името обично се користи за да ја повикате операција на далечинскиот веб сервис.',
        'Invoker backend' => 'Позадинско прикажување на повикувачи',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Овој OTOBO позадински повикувачки модул ќе биде повикан за да подготви податоци за испраќање на одалечен систем, и да ги испроцесира податочен одговор.',
        'Mapping for outgoing request data' => 'Мапирање за појдовно барање на податоци',
        'Configure' => 'Конфигурирај',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Податоците од повикувач на OTOBO ќе бидат обработени со оваа мапирање, за да го трансформира во вид на податоци на системот за далечинско очекува.',
        'Mapping for incoming response data' => 'Мапирање на пристигнувачки податочни одговори.',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Податоците за одговор ќе бидат обработени со оваа мапирање, за да го трансформира во вид на податоци на повикувач на очекувања на OTOBO.',
        'Asynchronous' => 'Асинхроно',
        'Condition' => 'Услов',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Овој повикувач ќе биде активиран од конфигурираните настани.',
        'Add Event' => 'Додај Настан',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'За да додадете нов настан изберете објект и име на настан и кликнете на "+" копчето',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Синхрони предизвикувачи на настано ќе бидат обработени директно во текот на веб-барање.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Врати се назад на',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Услови',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Тип на Поврзаност помеѓу Услови',
        'Remove this Condition' => 'Избриши го овој Услов',
        'Type of Linking' => 'Тип на Поврзаност',
        'Add a new Field' => 'Додади ново Поле',
        'Remove this Field' => 'Избриши го ова Поле',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => 'Додади Нов Услов',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Просто Мапирање',
        'Default rule for unmapped keys' => 'Подразбираме правило за немапирани клучеви',
        'This rule will apply for all keys with no mapping rule.' => 'Оваа правило ќе се однесува за сите типки без мапирачо правило.',
        'Default rule for unmapped values' => 'Подразбираме правило за немапирани вредности',
        'This rule will apply for all values with no mapping rule.' => 'Оваа правило ќе се однесува за сите вредности без мапирачко правило.',
        'New key map' => 'ново мапирање на клучеви',
        'Add key mapping' => 'Додај мапирање на оваа типка',
        'Mapping for Key ' => 'Мапирање на Клучот',
        'Remove key mapping' => 'Избриши маприрање',
        'Key mapping' => 'Мапирање клучеви',
        'Map key' => 'Мапирај типка',
        'matching the' => 'појавување на',
        'to new key' => 'до нова типка',
        'Value mapping' => 'Вредносно мапирање',
        'Map value' => 'Мапирачка вредност',
        'to new value' => 'на нова вредност',
        'Remove value mapping' => 'Избриши мапирачка вредност ',
        'New value map' => 'Нова мапирање на вредности',
        'Add value mapping' => 'Додај мапирчка вредност',
        'Do you really want to delete this key mapping?' => 'Дали навистина сакате да ги избришете мапирање клучеви?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => '',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => '',
        'Find next' => '',
        'Find previous' => '',
        'Find and replace' => '',
        'Find and replace all' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => '',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => '',
        'Replace' => '',
        'Remove regex' => '',
        'Add regex' => '',
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
        'Do you really want to delete this operation?' => 'Дали навистина сакате да ја избришете оваа операција?',
        'Operation Details' => 'Опрациски Детали',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Името обично се користи за да се јавите на овој веб сервис од друг оддалечен систем.',
        'Operation backend' => 'Оперативни позадински приказ',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Овој OTOBO позадински операциски модул ќе биде повикан интерно за да го испроцесира барањето , генерирајки податоци за одговорот.',
        'Mapping for incoming request data' => 'Мапирање за добивање на бараните податоци',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Побараните податоци ќе бидат процесирани со оваа мапирање , за да се трансформираат во вид на податочна форма која OTOBO ја очекува.',
        'Mapping for outgoing response data' => 'Мапирање за појдовни одговор на податоци',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Податочниот одговор ќе биде процесиран од страна на оваа мапирање, за да го трансформира во фрома која далечниот систем ја очекува.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Својства',
        'Route mapping for Operation' => 'Мапирачки рути за операција',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Дефинирај ја рутата која треба да биде мапирана за оваа операција. Променливите означени со \':\' ќе бидат мапирани со внесеното име и ќе бидат зачувани со останатите мапирања. (п.р. /Тикет/:ТикетID).',
        'Valid request methods for Operation' => 'Валидни методи за барање на работа',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ограничија ја оваа Операција на специфични побарани методи. Ако не се одберени методи сите барања ќе бидат прифатени.',
        'Maximum message length' => 'Максимална должина на пораката',
        'This field should be an integer number.' => 'Ова поле треба да биде цел број.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Тука може да наведете максималната големина (во бајти) на REST пораки кои OTOBO ќе ги обработува.',
        'Send Keep-Alive' => 'Испрати Остани-Активно',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Оваа конфигурација дефинира дали пристигнуваат конекции кои треба да се затворени или да се одржуваат.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Крајна точка',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Автентикација',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Корисничкото име за пристап за одалечен систем.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Лозинката за привилегиран корисник.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Прокси Сервер',
        'URI of a proxy server to be used (if needed).' => 'URI на proxy сервер да се користи (ако е потребно).',
        'e.g. http://proxy_hostname:8080' => 'п.р. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy Корисник',
        'The user name to be used to access the proxy server.' => 'Корисничко име за пристап на прокси сервер.',
        'Proxy Password' => 'Прокси Лозинка',
        'The password for the proxy user.' => 'Лозинка за прокси корисник.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Користи SSL Опции',
        'Show or hide SSL options to connect to the remote system.' => 'Прикаже или сокри SSL опции за поврзетење на оддалечен систем.',
        'Client Certificate' => '',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => '',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Целосната патека и име на издавачот на сертификат датотека со која потврдува владидност на SSL сертификат.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'п.р. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Директориум за Издавач на сертификати (CA) ',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Целосна патека од цертификат издавачот директориумот каде CA сертификатите се сместени во системот со датотеки.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'на пример: /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Контролор за мапирање на Повикувачи',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Контролерот на кој повикувачот треба да испраќа барања. Променливи означени со \':\'  ќе бидат заменети со податочните вредности и ќе бидат проследени со останатите во барањето. (п.р.  /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Валидно барање на командата за Повикувачи',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Специфични HTTP команди за да се користат со овој Повикувач (опционално).',
        'Default command' => 'Стандардната команда',
        'The default HTTP command to use for the requests.' => 'Стандардните HTTP команди за користење на барањата.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '',
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
        'SOAPAction separator' => 'Сепаратор на SOAP Aкција',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Простор за име',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI за да му даде SOAP контекст методи , намалувајќи нејаснотии.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
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
            'Тука може да наведете максималната големина (во бајти) на SOAP пораките кои OTOBO ќе ги процесира.',
        'Encoding' => 'Кодирање',
        'The character encoding for the SOAP message contents.' => 'Карактер енкодирање за содржината на SOAP пораката.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'на пример: utf-8, latin1, iso-8859-1, cp1250, итн.',
        'Sort options' => '',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'Името мора да биде уникатно.',
        'Clone' => 'Клонирај',
        'Export Web Service' => '',
        'Import web service' => 'Увези веб сервис',
        'Configuration File' => 'Конфигурациска Датотека',
        'The file must be a valid web service configuration YAML file.' =>
            'датотеката мора да биде валидна YAML конфигурирана датотека на веб сервис ',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Увези',
        'Configuration History' => '',
        'Delete web service' => 'Избриши веб сервис',
        'Do you really want to delete this web service?' => 'Дали навистина сакате да ја избришете овој веб сервис?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Откако ќе ја снимите конфигурацијата ќе бидете пренасочени повторно во уредувачкиот екран.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ако сакате да се вратите на преглед ,Ве молиме кликнете на копчето "Оди на преглед".',
        'Remote system' => 'Далечински систем',
        'Provider transport' => 'Обезбедувач на транспорт',
        'Requester transport' => 'Побарувач на транспотр',
        'Debug threshold' => 'Дебагирај праг на осетливост',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Во режимот на провајдерот, OTOBO нуди веб услуги кои се користат од страна на далечински системи.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Во побарувачки мод, OTOBO користи веб сервиси од далечински системи.',
        'Network transport' => 'Мрежен транспорт',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Операциите се индивидуален системски функции кои оддалечени системи може да побара.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Повикувачите подготвуваат податоци за барање на далечински веб серивс, и ги процесираат податоците за одговор.',
        'Controller' => 'Kонтролор',
        'Inbound mapping' => 'Влезно мапирање',
        'Outbound mapping' => 'Излезнo мапирење',
        'Delete this action' => 'Избриши ја оваа акција',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Најмалку една %s има контролер кој е или не е активна или не е присутна, ве молиме проверете на регистрација контролорот или избришете %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Историја',
        'Go back to Web Service' => 'Оди назад на Веб Сервис',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Овде можете да видите постари конфигурациски верзии на тековната веб службата, да ги извезубате или дури обновите.',
        'Configuration History List' => 'Исотриска Листа на Конфигурации',
        'Version' => 'Верзија',
        'Create time' => 'Креирај време',
        'Select a single configuration version to see its details.' => 'Изберете една конфигурациска верзија за да ги видите неговите детали.',
        'Export web service configuration' => 'Извези веб сервис конфигурација',
        'Restore web service configuration' => 'Враќање на конфигурација на веб сервис ',
        'Do you really want to restore this version of the web service configuration?' =>
            'Дали навистина сакате да ја вратите оваа верзија на конфигурацијата на веб сервисот?',
        'Your current web service configuration will be overwritten.' => 'Вашата моментална веб сервис конфигурација ќе бидат препишани.',

        # Template: AdminGroup
        'Group Management' => 'Менаџирање Група',
        'Add Group' => 'Додади Група',
        'Edit Group' => 'Уреди група',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Админот на група е задолжен за влез во админ просторот и групата со статистка е за влез во просторот со статистика.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Креирај нови групи за да се справи со дозволи за пристап на различни групи на агент (на пример: одделот за купување, одделот за поддршка, одделот за продажба, ...).',
        'It\'s useful for ASP solutions. ' => 'Корисно е за ASP решенија.',

        # Template: AdminLog
        'System Log' => 'Системско Пријавување',
        'Here you will find log information about your system.' => 'Тука можете да најдете запис информации за вашиот систем.',
        'Hide this message' => 'Сокриј ја оваа порака',
        'Recent Log Entries' => 'Скорешно Отворани Записи',
        'Facility' => 'Објект',
        'Message' => 'Порака',

        # Template: AdminMailAccount
        'Mail Account Management' => ' Управување со Маил профил',
        'Add Mail Account' => 'Додади Маил профил',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => '',
        'Host' => 'Домаќин',
        'Delete account' => 'Избриши профил',
        'Fetch mail' => 'Отвори пошта',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => 'Пример: mail.example.com',
        'IMAP Folder' => 'IMAP Папка',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Само модифицирај го ова ако треба да отвориш пота од различна папка од INBOX.',
        'Trusted' => 'Доверливи',
        'Dispatching' => 'Распределување',
        'Edit Mail Account' => 'Уреди го Маил профилот',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Филтер Тикет',
        'Lock' => 'Заклучува',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'Натпис Филтер',
        'Only for ArticleCreate and ArticleSend event' => 'Само за настанот креирање настан и праќање на член',
        'Article sender type' => 'Натпис тип на испраќач',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Ако се користи креирање натпис и праќање на натпис, ќе треба да наведете еден од член филтер. Ве молиме изберете барем една од член филтер полиња.',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Вклучи прилози на известување',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Известувањата се испратени на агент или клиент.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'За да ги добие првите 20 карактерот на предметот (од последниот натпис на агент).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'За да ги земете првите 5 линии од телото (од последниот натпис од агент).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'За да ги добие првите 20 карактерот на темата (од последниот натпис на клиентот).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'За да ги добие првите 5 карактерот на темата (од последниот натпис на потрошувачот).',
        'Attributes of the current customer user data' => '',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'Управување со PGP',
        'Add PGP Key' => 'Додај PGP Типка',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Со овој пат можете директно да го уредите привезокот конфигуриран во SysConfig.',
        'Introduction to PGP' => 'Вовед во PGP',
        'Bit' => 'Бит',
        'Fingerprint' => 'Белег',
        'Expires' => 'Истекува',
        'Delete this key' => 'Избриши го овој клуч',
        'PGP key' => 'PGP клуч',

        # Template: AdminPackageManager
        'Package Manager' => 'Пакет менаџер',
        'Uninstall Package' => '',
        'Uninstall package' => 'Деинсталирај пакет',
        'Do you really want to uninstall this package?' => 'Дали навистина сакате да го избришете пакетот?',
        'Reinstall package' => 'Инсталирај пакет повторно',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Дали навистина сакате да го реинсталирате овој пакет? Било каква мануелна промела ќе биде изгубена.',
        'Go to updating instructions' => '',
        'Go to the OTOBO customer portal' => '',
        'package information' => '',
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
            'Доколку имате повеќе прашања, со задоволство ќе ви одговориме.',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Инсталирај Пакет',
        'Update Package' => '',
        'Continue' => 'Продолжи',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Ве молиме осигурајте се дека вашата податочна база прифаќа пакети преку %s MB во големина (моментално прифача пакети до %s MB). Ве молиме адапртирајте го max_allowed_packet setting на вашата податочна база во предолед да избегнете грешки.',
        'Install' => 'Инсталирајте',
        'Update repository information' => 'Надгради складирана информација',
        'Cloud services are currently disabled.' => '',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => 'Он лајн Складиште',
        'Vendor' => 'Продавач',
        'Action' => 'Акција',
        'Module documentation' => 'документација за Модул',
        'Local Repository' => 'Локално Складиште',
        'This package is verified by OTOBOverify (tm)' => 'Овој пакет е потврден од OTOBOverify (tm)',
        'Uninstall' => 'Деинсталирај',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Пакетот не е правилно распореден! Ве молиме реинсталирајте го пакетот.',
        'Reinstall' => 'Реинсталиралација',
        'Features for %s customers only' => 'Карактеристики за %s само за потрошувачи',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Со %s, можете да имате корист од следниве опционални карактеристики. Ве молиме направете договор со %s ако ви требаат повеќе информации.',
        'Package Information' => '',
        'Download package' => 'Преземи пакет',
        'Rebuild package' => 'Ре издради пакет',
        'Metadata' => 'Метаподатоци',
        'Change Log' => 'Промени запис',
        'Date' => 'Датум',
        'List of Files' => 'Листа од Датотеки',
        'Permission' => 'Дозвола',
        'Download file from package!' => 'Преземи документ од пакет!',
        'Required' => 'Потребно',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Податочна разлика за датотеката %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Перформанско Пријавување',
        'Range' => 'Опсег',
        'last' => 'последен',
        'This feature is enabled!' => 'Оваа карактеристика е овозможена!',
        'Just use this feature if you want to log each request.' => 'Користија оваа опција само ако сакате да се пријавите на секое барање',
        'Activating this feature might affect your system performance!' =>
            'Активирајќи го ова својство може да има последици на перформансите на вашиот систем!',
        'Disable it here!' => 'Оневозможи го овде!',
        'Logfile too large!' => 'Записдатотеката е преголема!',
        'The logfile is too large, you need to reset it' => 'Пријавната датотеката е преголема, треба да го ресетирате',
        'Interface' => 'Интерфејс',
        'Requests' => 'Побарувања',
        'Min Response' => 'Минимален Одговор',
        'Max Response' => 'Максимален Одговор',
        'Average Response' => 'Просечен одговор',
        'Period' => 'Период',
        'minutes' => 'минути',
        'Min' => 'Минимално',
        'Max' => 'Максимално',
        'Average' => 'Просечно',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Филтер Менаџирање',
        'Add PostMaster Filter' => 'Додај PostMaster Филтер',
        'Edit PostMaster Filter' => 'Уреди PostMaster Филтер',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'За испраќање или филтрирање на пристигнувачки е-пораки соред насловот. Спарувајќи ги со користење на Регуларни Изрази е исто така возможно.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Ако сакате да одговара само со е-мејл адреса, користете EMAILADDRESS: info@example.com во "Од", "За" или "Cc".',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Ако користите Регуларни Изрази, вие исто така можете да ги користите совпаѓачките вредности во () како  [***] во \'Set\' акцијата.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Избриши го овој филтер',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Состојба на Филтерот',
        'AND Condition' => 'И Состојба',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ова поле треба да биде валиден регуларен израз за збор.',
        'Negate' => 'Негирај',
        'Set Email Headers' => 'Поставете е-мејл заглавија',
        'Set email header' => 'Постави наслов на е-адреса',
        'with value' => '',
        'The field needs to be a literal word.' => 'Ова поле треба да биде збор.',
        'Header' => 'Заглавие',

        # Template: AdminPriority
        'Priority Management' => 'Управување со Приоритет',
        'Add Priority' => 'Додади Приоритет',
        'Edit Priority' => 'Уреди Приоритет',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Управување со Процес',
        'Filter for Processes' => 'Филтрирај за Процесите',
        'Filter for processes' => '',
        'Create New Process' => 'Креирај нов процес',
        'Deploy All Processes' => 'Распореди ги сите процеси',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Овде можете да прикачи конфигурациска датотека за увоз на процесот на вашиот систем. Датотеката треба да биде во .yml формат извезно од страна на модул за управување со процесот .',
        'Upload process configuration' => 'Прикачи конфигурациски процес ',
        'Import process configuration' => 'Увези поцес конфигурација',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'За да креирате нов процес можете да увезете еден процес кој е извезена од друг систем или да создадете комплетено нов.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Промени во овие Процесите само што влијајат на однесувањето на системот, ако ги синхронизирате Процесираните податови. Со синхронизирање на Процесите, новите направени промени ќе бидат запишани во Конфигурацијата.',
        'Processes' => 'Процеси',
        'Process name' => 'Име на процес',
        'Print' => 'Испечати',
        'Export Process Configuration' => 'Извези Конфигурациски Процес',
        'Copy Process' => 'Копирај Процес',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => 'Оди Назад',
        'Please note, that changing this activity will affect the following processes' =>
            'Ве молиме имајте предвид дека менувањето на оваа активност ќе влијаат на следните процеси',
        'Activity' => 'Активност',
        'Activity Name' => 'Име Активности',
        'Activity Dialogs' => 'Активност Дијалог',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Дијалози на активност  можете да ги доделите во оваа активност со влечење на елементите со помош на глувчето од левата листа кон десната листа.',
        'Filter available Activity Dialogs' => 'Филтерите се достапни за Дијалози на активности',
        'Available Activity Dialogs' => 'Достапни Активност Дијалози',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => 'Креирај нова Дијалог на Активност ',
        'Assigned Activity Dialogs' => 'Доделени Активност Дијалози',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Ве молиме имајте во предвид со промени на оваа дијалог активност ќе влијаете на следниве активности',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Ве молиме имајте предвид дека клиент корисници нема да бидат во можност да ја види или користи следните области: Сопственик, Одговорен, Заклучучено, Време на чекање и Корисничко ID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Оваа Редица поле може да биде само искористено од потрошувачите кога креираат ков тикет.',
        'Activity Dialog' => ' Дијалог активности',
        'Activity dialog Name' => 'Активности дијалог Име',
        'Available in' => 'Достапен во',
        'Description (short)' => 'Опис (краток)',
        'Description (long)' => 'Опис (опширен)',
        'The selected permission does not exist.' => 'Селектираната дозвола не постои.',
        'Required Lock' => 'Потребен Клуч',
        'The selected required lock does not exist.' => 'Селектираниот клуч не постои.     ',
        'Submit Advice Text' => 'Потврди Текст за Совет',
        'Submit Button Text' => 'Потврди Текст на Копче',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Можете да додавате Полиња во овој Дијалог на Активности со помош на влечењена елементите со глувчето од левата листа до десната листа.',
        'Filter available fields' => 'Филтрирај достапни полиња',
        'Available Fields' => 'Достапни Полиња',
        'Assigned Fields' => 'Доделени Полиња',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Прикажи',

        # Template: AdminProcessManagementPath
        'Path' => 'Патека',
        'Edit this transition' => 'Измени ја оваа транзиција',
        'Transition Actions' => 'Транзициски Акции',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Можете да додавате Транзициски Акции на оваа Транзиција со помош на влечењена елементите со глувчето од левата листа до десната листа.',
        'Filter available Transition Actions' => 'Филтрирај достапни Транзициски Акции',
        'Available Transition Actions' => 'Достапни Транзициски Акции',
        'Create New Transition Action' => 'Креирај Нови Транзициски Акции',
        'Assigned Transition Actions' => 'Додадени Транзициски Акции',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Активности',
        'Filter Activities...' => 'Филтрирај Активности...',
        'Create New Activity' => 'Креирај Нова Активност',
        'Filter Activity Dialogs...' => 'Филтрирај го Дијалогот на Активности...',
        'Transitions' => 'Транзиции',
        'Filter Transitions...' => 'Филтрирај Транзиции...',
        'Create New Transition' => 'Креирај Нови Транзиции',
        'Filter Transition Actions...' => 'Филтрирај ги Транзициските Акции...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Измени Процес',
        'Print process information' => 'Испечати го процесот на информации',
        'Delete Process' => 'Избриши Процес',
        'Delete Inactive Process' => 'Избриши Неактивни Процеси',
        'Available Process Elements' => 'Достапни Елементи на Процес',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Елементите прикажани погоре во лентата можат да бидат преместени во канвасот десно со помош на влечење.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Тука може да се постават Активности на канвасот за да се додаде оваа Активност на Процесот.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'За да додадете Дијалог со Активности во постоечка Активност довлечете го Дијалогот со Активности од оваа лента до Активноста во канвасот.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Акциите можат да бидат додавани на Транзиција со влечење на Акцискиот Елемент врз името на Транзицијата.',
        'Edit Process Information' => 'Измени Информации на Процес',
        'Process Name' => 'Име на Процес',
        'The selected state does not exist.' => 'Избраната состојба не постои.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Додај и Измени Активност, Дијалог на Активности и Транзиции',
        'Show EntityIDs' => 'Прикажи ID на Ентитети',
        'Extend the width of the Canvas' => 'Прошири го конвасот',
        'Extend the height of the Canvas' => 'Зголеми ја висината на Канвасот',
        'Remove the Activity from this Process' => 'Избриши ја Активноста од овој Процес',
        'Edit this Activity' => 'Измени ја оваа Активност',
        'Save Activities, Activity Dialogs and Transitions' => 'Зачувај Активности, Дијалог на Активности и Транзиции',
        'Do you really want to delete this Process?' => 'Дали сте сигурни дека сакате да го избришете овој Процес?',
        'Do you really want to delete this Activity?' => 'Дали сте сигурни дека сакате да ја избришете оваа Активност?',
        'Do you really want to delete this Activity Dialog?' => 'Дали сте сигурни дека сакате да го избришете овој Дијалог на Активности?',
        'Do you really want to delete this Transition?' => 'Дали сте сигурни дека сакате да ја избришете оваа Транзиција?',
        'Do you really want to delete this Transition Action?' => 'Дали сте сигурни дека сакате да ја избришете оваа Акција на Транзиција?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Дали сигурно сакате да ја избришете оваа активност од канвасот? Овој процес може да биде прекинат со напуштање на прозорецот без зачувување.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Дали сте сигурни дека сакате да ја избришете транзицијата од канвасот? Овој процес може да се поврати само со напуштање на моменталната страница без да ја сочувате.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Во овој дел можете да креирате нов процес. За да го направите новиот процес достапен на членовите бидете сигурни дека неговата состојба е \'Активен\' и синхронизирајте ја вашата промена.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Почетна Активност',
        'Contains %s dialog(s)' => 'Содржи %s дијалоз(и)',
        'Assigned dialogs' => 'Додадени дијалози',
        'Activities are not being used in this process.' => 'Не се искористени Активности во овој процес.',
        'Assigned fields' => 'Додадени полиња',
        'Activity dialogs are not being used in this process.' => 'Не се искористени дијалози на Активности во овој процес.',
        'Condition linking' => 'Условно поврзување',
        'Transitions are not being used in this process.' => 'Не се искористени Транзиции во овој процес.',
        'Module name' => 'Име на Модул',
        'Transition actions are not being used in this process.' => 'Транзициските акции не се користат во овој процес.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Ве молиме имајте во обзир дека со менувањето на оваа транзиција ќе влијае на постоечките процеси.',
        'Transition' => 'Транзиција',
        'Transition Name' => 'Име на Транзиција',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Ве молиме имајте во предвид дека промената на оваа транзициска акција ќе влијае на процесот.',
        'Transition Action' => 'Транзициска Акција',
        'Transition Action Name' => 'Име на Транзициска Акција',
        'Transition Action Module' => 'Модул на Транзициска Акција',
        'Config Parameters' => 'Конфигурирај Параметри',
        'Add a new Parameter' => 'Додади нов Параметар',
        'Remove this Parameter' => 'Избриши го овој Параметар',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Додади Ред',
        'Edit Queue' => 'Измени Ред',
        'Filter for Queues' => 'Филтер за Редици',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'Веќе постои ред со ова име!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Под-редица на',
        'Unlock timeout' => 'Отклучи истек на време',
        '0 = no unlock' => '0 = без отклучување',
        'hours' => 'часови',
        'Only business hours are counted.' => 'Се сметаат само бизнис часови.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Доколку агент заклучи некој тикет а не го затвори пред времето за отклучување да истече, тикетот ќе биде отклучен и ќе биде достапен за други агенти.',
        'Notify by' => 'Извести од страна на',
        '0 = no escalation' => '0 = без ескалација',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Доколку не е додаден контакт на клиентот, било е-маил-интерен или телефон, на нов тикет пред времето дефинирано тука да истече, тикетот ќе биде ескалиран.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Доколку некој натпис е додаден преку е-пошта или корниснички портал, времето времето за надградба е ресетирано. Доколку не е постои кориснички контакт, е-пошта или телефон додаден на тикет пред дефинираното време да истече, тикетот ќе биде ескалиран.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Доколку тикетот не е затворен пред истекот на време, тикетот ќе биде ескалиран.',
        'Follow up Option' => 'Опција за Следење',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Одредува доколку тикетот е затворен дали ќе се отвори повторно, ќе биде одбиен или ќе води до отварање на нов тикет.',
        'Ticket lock after a follow up' => 'Заклучи тикет по следење',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Доколку тикетот е заклучен и клиентот испрати надоврзување на тикетот, тој пак ќе биде додаден на стариот сопственик.',
        'System address' => 'Системска адреса',
        'Will be the sender address of this queue for email answers.' => 'Ќе биде адреса на испраќачот на оваа редица на е-маил одговори.',
        'Default sign key' => 'Стандарден клуч за знак',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Поздрав',
        'The salutation for email answers.' => 'Поздрав на одговор на е-пошта.',
        'Signature' => 'Потпис',
        'The signature for email answers.' => 'Попис за одговор на е-пошта',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Управувај со Релации на Автоматски Одговори на Редици.',
        'Change Auto Response Relations for Queue' => 'Измени Релации на Автоматски Одговори на Редици',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => 'Автоматски Одговори',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Менаџирај Шаблон-Ред Релации',
        'Filter for Templates' => 'Филтер за Шаблони',
        'Filter for templates' => '',
        'Templates' => 'Шаблони',

        # Template: AdminRegistration
        'System Registration Management' => 'Управување со Регистрации на Системот',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTOBO-ID' => '',
        'Deregister System' => 'Дерегистрирај Систем',
        'Edit details' => 'Измени детали',
        'Show transmitted data' => 'Прикажи пренесени податоци',
        'Deregister system' => 'Дерегистрирај систем',
        'Overview of registered systems' => 'Преглед на регистрирани системи',
        'This system is registered with OTOBO Team.' => '',
        'System type' => 'Тип на Систем',
        'Unique ID' => 'Единствен ID',
        'Last communication with registration server' => 'Последна комуникација со серверот за регистрација',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            '',
        'Instructions' => 'Инструкции',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'OTOBO-ID Најава',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Прочитај повеќе',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Морате да бидете логирани со вашиот OTOBO-ID за да го регистрирате вашиот систем.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Твојот OTOBO-ID е адресата на е-пошта со која сте се регистрирале на OTOBO.com страната.',
        'Data Protection' => 'Заштита на личните податоци',
        'What are the advantages of system registration?' => 'Кои се привилегиите од регистрација на системот?',
        'You will receive updates about relevant security releases.' => 'Ќе добивате надградби за релевантни безбедносни изданија.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Со твојата регистрација на системот можеме да ги подобриме нашите сервиси за вас, бидејќи ги имаме достапни сите информации.',
        'This is only the beginning!' => 'Ова е само почетокот!',
        'We will inform you about our new services and offerings soon.' =>
            'Ќе ве информираме за нашите нови сервиси и понуди наскоро.',
        'Can I use OTOBO without being registered?' => 'Дали може да користам не-регистриран OTOBO?',
        'System registration is optional.' => 'Регистрација на системот е опционална.',
        'You can download and use OTOBO without being registered.' => 'Можете да го превземете и користите OTOBO без притоа тој да е регистриран.',
        'Is it possible to deregister?' => 'Дали е возможно да се де-регистрирате?',
        'You can deregister at any time.' => 'Можете да го де-регистрирате во било кое време.',
        'Which data is transfered when registering?' => 'Кои податоци се трансферирани при регистрација?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Комплетно Квалификувано Име на Домеин (FQDN), OTOBO верзија, Датабаза, Оперативен Систем и Perl верзија.',
        'Why do I have to provide a description for my system?' => 'Зошто морам да наведам опис за мојот систем?',
        'The description of the system is optional.' => 'Описот на системот е опционален.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Описот и типот на системот го специфирате за да ви помогне да го идентификуваате и менаџирате деталите на вашите регистрирани системи.',
        'How often does my OTOBO system send updates?' => 'Колку често OTOBO системот испраќа надградба?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Вашиот систем ќе праќа надградби до регистрацискиот сервер во регуларни интервали.',
        'Typically this would be around once every three days.' => 'Обично ова ќе биде наоколу на секои три дена.',
        'If you deregister your system, you will lose these benefits:' =>
            'Доколку го дерегистрирате вашиот систем, ќе ги изгубите овие бенефиции:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Морате да бидете најавени со вашиот OTOBO-ID за да го дерегистрирате вашиот систем.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Сеуште немате OTOBO-ID?',
        'Sign up now' => 'Приклучи се веднаш',
        'Forgot your password?' => 'Ја заборавивте вашата лозинка?',
        'Retrieve a new one' => 'Побарај нов',
        'Next' => 'Следен',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => 'Атрибут',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO верзија',
        'Operating System' => 'Оперативен систем',
        'Perl Version' => 'Perl Верзија',
        'Optional description of this system.' => 'Опционален опис на овој систем.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Регистрирај',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => 'Дерегистрирај',
        'You can modify registration settings here.' => 'Можете да ги измените подесувањата за регистрации тука.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'Нема податоци регуларно пратени од вашиот систем до %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Следните податоци се испраќаат минимум на секој 3-ти ден од вашиот систем до %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Податоците ќе бидат пренесени во JSON формат преку сигурносна https конекција.',
        'System Registration Data' => 'Податоци за Регистрација на Системот',
        'Support Data' => 'Податоци за Поддршка',

        # Template: AdminRole
        'Role Management' => 'Управување со Улоги',
        'Add Role' => 'Додади Улога',
        'Edit Role' => 'Измени Улога',
        'Filter for Roles' => 'Филтер за Улоги',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Креирај нова улога и додади група во истата. Потоа додади улога на корисниците.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Нема дефинирано улоги. Ве молиме употребето го копчето \'Додади\' за да креирате нова улога.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Управување со Улога-Група Релации',
        'Roles' => 'Улоги',
        'Select the role:group permissions.' => 'Избери ги дозволите за улога:група.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Доколку ништо не е изберено, тогаш нема дозволи во оваа група(тикетите нема да бидат достапни на оваа улога).',
        'Toggle %s permission for all' => 'Смени %s дозвола за сите',
        'move_into' => 'премести_во',
        'Permissions to move tickets into this group/queue.' => 'Дозволи за префрлување на тикети во оваа група/редица.',
        'create' => 'креирај',
        'Permissions to create tickets in this group/queue.' => 'Дозволи за креирање на тикети во оваа група/редица.',
        'note' => 'забелешка',
        'Permissions to add notes to tickets in this group/queue.' => 'Дозволи за додавање забелешки на тикети во оваа група/редица.',
        'owner' => 'сопственик',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Дозволи за промена на сопственикот на тикети во оваа група/редица.',
        'priority' => 'приоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Дозволи за промена на приоритетот на тикетот во оваа група/редица.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Управувај со Релации на Агент-Улога',
        'Add Agent' => 'Додади Агент',
        'Filter for Agents' => 'Филтрирање за Агенти',
        'Filter for agents' => '',
        'Agents' => 'Агенти',
        'Manage Role-Agent Relations' => 'Управувај со Релации на Улога-Агент',

        # Template: AdminSLA
        'SLA Management' => 'Управување со SLA',
        'Edit SLA' => 'Измени SLA',
        'Add SLA' => 'Додади SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Ве молиме пишувајте само броеви!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Управување со S/MIME',
        'Add Certificate' => 'Додади Сертификат',
        'Add Private Key' => 'Додади Приватен Клуч',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Филтер за сертификати',
        'To show certificate details click on a certificate icon.' => 'За прикажување на деталите на сертификат кликнете на иконата од сертификатот.',
        'To manage private certificate relations click on a private key icon.' =>
            'За управување на сопствени релации на сертификати кликнете на иконата со приватен клуч.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Тука може да додадете релации на ваши приватни сертификати, тие ќе бидат додадени во S/MIME потпис секогаш кога ќе го користите овој сертификат за да пристапите на е-пошта.',
        'See also' => 'Види исто така',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'На овој начин ќе можете директно да ги измените сертификатите и приватните клучеви во системот на датотеки.',
        'Hash' => 'Хаш',
        'Create' => 'Креирај',
        'Handle related certificates' => 'Справи се со поврзани сертификати',
        'Read certificate' => 'Прочитај сертификат',
        'Delete this certificate' => 'Избриши го овој сертификат',
        'File' => 'Датотека',
        'Secret' => 'Тајно',
        'Related Certificates for' => 'Поврзани Сертификати за',
        'Delete this relation' => 'Избриши ја оваа релација',
        'Available Certificates' => 'Достапни Сертификати',
        'Filter for S/MIME certs' => 'Филтрирање за S/MIME сертификати',
        'Relate this certificate' => 'Насочи го овој сертификат',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME Сертификат',
        'Certificate Details' => '',
        'Close this dialog' => 'Затвори го овој дијалог',

        # Template: AdminSalutation
        'Salutation Management' => 'Управување со Обраќања',
        'Add Salutation' => 'Додади Обраќање',
        'Edit Salutation' => 'Измени Обраќање',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'п.р.',
        'Example salutation' => 'Пример за обраќање',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Безбедносниот режим ќе биде (нормално) подесен по завршување на почетната инсталација.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Доколку безбедносниот режим не е активиран, активирајте го преку SysConfig бидејќи вашата апликација е веќе активна.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Кутија',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Тука можете да внесете SQL  за да пратите директно до апликациската база. Доколку не е можно да ја промените содржината во табелите, само селектираните пребарувања се овозможени.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Тука можете да пристапите до SQL за директно праќање до датабазата на апликацијата.',
        'Options' => 'Опции',
        'Only select queries are allowed.' => 'Само селектираните побарувања се овозможени.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Синтаксата на вашето SQL барање има грешка. Ве молиме проверете ја.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Постои барем еден параметар што фали од условите. Ве молиме поправете го.',
        'Result format' => 'Формат на резултат',
        'Run Query' => 'Стартувај Пребарување',
        '%s Results' => '',
        'Query is executed.' => 'Барањето е извршено.',

        # Template: AdminService
        'Service Management' => 'Управување со Сервиси',
        'Add Service' => 'Додади Сервис',
        'Edit Service' => 'Измени Сервис',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Под-сервис на',

        # Template: AdminSession
        'Session Management' => 'Управување со Сесии',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Сите сесии',
        'Agent sessions' => 'Сесија на агент',
        'Customer sessions' => 'Сесии на Клиент',
        'Unique agents' => 'Посебни агенти',
        'Unique customers' => 'Посебни клиенти',
        'Kill all sessions' => 'Прекини ги сите сесии',
        'Kill this session' => 'Прекини ја оваа сесија',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Сесија',
        'Kill' => 'Прекини',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Управување со Потписи',
        'Add Signature' => 'Додади Потпис',
        'Edit Signature' => 'Измени Потпис',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Пример за потпис',

        # Template: AdminState
        'State Management' => 'Управување со Состојба',
        'Add State' => 'Додади Состојба',
        'Edit State' => 'Измени Состојба',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Внимание',
        'Please also update the states in SysConfig where needed.' => 'Ве молиме дополнети ја состојбата на SysConfig каде што е потребно.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Тип на состојба',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Можете мануелно да го активирате испраќањето на Податоците за Поддршка со кликање на оваа копче:',
        'Send Update' => 'Испрати Надградба',
        'Currently this data is only shown in this system.' => 'Во моментот само овие податоци се прикажани во овој систем.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Збир од Податоците за поддршка(вклучувајки: информации за регистрација на системот, податоци за поддршка, листа од инсталирани пакети и локално изменети датотеки на изворни кодови) можат да бидат генерирани со притискање на ова копче:',
        'Generate Support Bundle' => 'Генерирај Збир од Податоци за поддршка',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Ве молиме изберете една од следните опции.',
        'Send by Email' => 'Прати преку Е-пошта',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Збирот од Податоците за поддршка е премногу голем за да се испрати преку е-пошта, оваа опција е исклучена.',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'Испраќање',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => 'Превземи Датотека',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Грешка: Податоците за поддршка не можат да бидат соберени(%s).',
        'Details' => 'Детали',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Управување со Системска Адреса на Е-Пошта',
        'Add System Email Address' => 'Додади Системска Е-Адреса',
        'Edit System Email Address' => 'Измени Системска Адреса за Е-Пошта',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Сите дојдовни е-пошти со оваа адреса во To или Cc ке бидат испратени до селектираната редица.',
        'Email address' => 'Е-адреса',
        'Display name' => 'Име за прикажување',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Името и е-адресата ќе ви бидат прикажани на поштата што вие ќе ја праќате.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
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
        'Changes Overview' => '',
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
        'Deploy selected changes' => '',

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
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '',
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
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Категорија',
        'Run search' => 'Почни со пребарување',

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
        'System Maintenance Management' => 'Управување со Одржување на Системот',
        'Schedule New System Maintenance' => 'Додади Системско Одржување во Потсетникот',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Постави период за одржување на системот за известување на Агентите и Клиентите дека системот ќе биде недостапен на одреден период.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Некое време пред да почне одржувањето корисникот ќе добие нотификација на секој екран известувајќи го за овој факт.',
        'Stop date' => 'Датум за крај',
        'Delete System Maintenance' => 'Избриши Одржување на Системот',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Невалиден Датум!',
        'Login message' => 'Порака при најава',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Прикажи порака за најава',
        'Notify message' => 'Порака за известување',
        'Manage Sessions' => 'Управувај со сесии',
        'All Sessions' => 'Сите сесии',
        'Agent Sessions' => 'Сесии на Агент',
        'Customer Sessions' => 'Клиентски Сесии',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Додади Шаблон',
        'Edit Template' => 'Измени Шаблон',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Темплејт преставува стандарден текст кој помага на вашите агенти да ги пишуваат и одговараат тикетите многу побрзо.',
        'Don\'t forget to add new templates to queues.' => 'Не заборавај да додадеш нови шаблони во редиците.',
        'Attachments' => 'Прилози',
        'Delete this entry' => 'Избриши го овој внес',
        'Do you really want to delete this template?' => '',
        'A standard template with this name already exists!' => 'Веќе постои шаблон под исто име!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Направи нов тип на темплејт кој поддржува паметни тагови',
        'Example template' => 'Пример за Шаблон',
        'The current ticket state is' => 'Состојбата на вашиот тикет е',
        'Your email address is' => 'Твојата е-адреса е',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Смени во активно за сите',
        'Link %s to selected %s' => 'Линк %s во селектирани %s',

        # Template: AdminType
        'Type Management' => 'Управување со Типови',
        'Add Type' => 'Додај Тип',
        'Edit Type' => 'Измени тип',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Веќе постои тип со исто име!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Управување Агенти',
        'Edit Agent' => 'Измени Агент',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Агентите ќе мораат да се справаат со тикетите.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Не заборавај да додадеш нов агент во групата или улога!',
        'Please enter a search term to look for agents.' => 'Ве молиме внесете клуч за пребарување на агенти.',
        'Last login' => 'Последна најава',
        'Switch to agent' => 'Префрли на агент',
        'Title or salutation' => '',
        'Firstname' => 'Име',
        'Lastname' => 'Презиме',
        'A user with this username already exists!' => 'Веќе постои корисник со ова корисничко име!',
        'Will be auto-generated if left empty.' => 'Ќе бидат генерирани автоматски доколку оставите празно место.',
        'Mobile' => 'Мобилен',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Управувај со Релации помеѓу Агенти и Групи',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Денес',
        'All-day' => '',
        'Repeat' => '',
        'Notification' => 'Известување',
        'Yes' => 'Да',
        'No' => 'Не',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Невалиден датум!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'ден(ови)',
        'week(s)' => 'недела(и)',
        'month(s)' => 'месец(и)',
        'year(s)' => 'година(ни)',
        'On' => 'Вклучено',
        'Monday' => 'Понеделник',
        'Mon' => 'Пон',
        'Tuesday' => 'Вторник',
        'Tue' => 'Вто',
        'Wednesday' => 'Среда',
        'Wed' => 'Сре',
        'Thursday' => 'Четврток',
        'Thu' => 'Чет',
        'Friday' => 'Петок',
        'Fri' => 'Пет',
        'Saturday' => 'Сабота',
        'Sat' => 'Саб',
        'Sunday' => 'Недела',
        'Sun' => 'Нед',
        'January' => 'Јануари',
        'Jan' => 'Јан',
        'February' => 'Февруари',
        'Feb' => 'Феб',
        'March' => 'Март',
        'Mar' => 'Мар',
        'April' => 'Април',
        'Apr' => 'Апр',
        'May_long' => 'Мај_долг ',
        'May' => 'Мај',
        'June' => 'Јуни',
        'Jun' => 'Јун',
        'July' => 'Јули',
        'Jul' => 'Јул',
        'August' => 'Август',
        'Aug' => 'Авг',
        'September' => 'Септември ',
        'Sep' => 'Сеп',
        'October' => 'Октомври',
        'Oct' => 'Окт',
        'November' => 'Ноември ',
        'Nov' => 'Нов',
        'December' => 'Декември',
        'Dec' => 'Дек',
        'Relative point of time' => '',
        'Link' => 'Линк',
        'Remove entry' => 'Избриши внес',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Информативен Центар за Клиенти',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Корисник Клиент',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Забелешка: Клиентот е невалиден!',
        'Start chat' => 'Започни конверзација',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Барај шаблон',
        'Create Template' => 'Креирај Шаблон',
        'Create New' => 'Креирај нов',
        'Save changes in template' => 'Зачувај промени во шаблонот',
        'Filters in use' => 'Филтри што се користат',
        'Additional filters' => 'Додатни филтери',
        'Add another attribute' => 'Додади нов атрибут',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Селектирај ги сите',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Измени опции за пребарување',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTOBO Daemon' => '',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Работна табла',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Утре',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Почеток',
        'none' => 'никој',

        # Template: AgentDashboardCalendarOverview
        'in' => 'во',

        # Template: AgentDashboardCommon
        'Save settings' => 'Зачувај подесувања',
        'Close this widget' => '',
        'more' => 'повеќе',
        'Available Columns' => 'Достапни Колони',
        'Visible Columns (order by drag & drop)' => 'Достапни Колумни (подреди ги со влечење и пуштање)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Отвори',
        'Closed' => 'Затвори',
        '%s open ticket(s) of %s' => '%s отворен тикет(и) од %s',
        '%s closed ticket(s) of %s' => '%s затворен(и) тикет(и) %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Ескалирани тикети',
        'Open tickets' => 'Отворени тикети',
        'Closed tickets' => 'Затворени тикети',
        'All tickets' => 'Сите тикети',
        'Archived tickets' => 'Архива на билети',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Телефонски тикет',
        'Email ticket' => 'Е-маил тикет',
        'New phone ticket from %s' => 'Нов телефонски тикет од %s',
        'New email ticket to %s' => 'Нов е-маил тикет до %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s е достапно!',
        'Please update now.' => 'Ве молиме надградете го одма.',
        'Release Note' => 'Забелешка при Пуштање',
        'Level' => 'Ниво',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Постиран пред %s .',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Содржината на оваа статистика се генерира за вас, ве молиме бидете стрпеливи.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Мои заклучени текети',
        'My watched tickets' => 'Мои надгледувани тикети',
        'My responsibilities' => 'Мои одговорности',
        'Tickets in My Queues' => 'Тикети во моит Редици',
        'Tickets in My Services' => 'Тикети во Мои Сервиси',
        'Service Time' => 'Време на Сервис',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Вкупно',

        # Template: AgentDashboardUserOnline
        'out of office' => 'надвор од канцеларија',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'до',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Назад',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'За да прифатите некои новости, лиценца или некои промени.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => '',
        'Current password' => 'Моментална лозинка',
        'New password' => 'Нова лозинка ',
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
        'Edit your preferences' => 'Измени ги твоите прилагодувања',
        'Personal Preferences' => '',
        'Preferences' => 'Параметри',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Исклучено',
        'End' => 'Крај',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTOBO at %s.' => '',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => 'Процес',
        'Split' => 'Одели',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTOBO' => '',
        'Dynamic Matrix' => '',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => '',
        'Each row contains data of one entity.' => '',
        'Static' => '',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => '',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Креирано од',
        'Changed by' => 'Променето од ',
        'Sum rows' => 'Сумирај редови',
        'Sum columns' => 'Сумирај колони',
        'Show as dashboard widget' => 'Прикажи како работна табла',
        'Cache' => 'Кеш',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'The ticket has been locked' => 'Тикетот е заклучен',
        'Undo & close' => '',
        'Ticket Settings' => 'Подесувања тикет',
        'Queue invalid.' => '',
        'Service invalid.' => 'Невалиден сервис.',
        'SLA invalid.' => '',
        'New Owner' => 'Нов Сопственик',
        'Please set a new owner!' => 'Во молиме селектирајте нов сопственик.',
        'Owner invalid.' => '',
        'New Responsible' => '',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Следна состојба',
        'State invalid.' => '',
        'For all pending* states.' => 'За сите состојби во тек.',
        'Add Article' => 'Додади Натпис',
        'Create an Article' => 'Креирај Натпис',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Тука може да избереш дополнителни агенти кои треба да примаат нотификации за новиот натпис..',
        'Text will also be received by' => '',
        'Text Template' => 'Шаблон за текст',
        'Setting a template will overwrite any text or attachment.' => 'Доколку изберете темплејт, текстот и прикачувањата ќе се пребришат.',
        'Invalid time!' => 'Невалидно време!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Скокни до',
        'You need a email address.' => 'Ви треба е-адреса.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Потребна е валидна e-mail адреса или не користете локална e-mail е-адреса.',
        'Next ticket state' => 'Следна состојба на тикет',
        'Inform sender' => 'Извести праќач',
        'Send mail' => 'Испрати пошта',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Опции за Тикети',
        'Send Email' => 'Испрати Е-Пошта',
        'Merge' => 'Спојување',
        'Merge to' => 'Спој во',
        'Invalid ticket identifier!' => 'Невалиден идентификатор на тикет!',
        'Merge to oldest' => 'Спој во најстари',
        'Link together' => 'Линкувај заедно',
        'Link to parent' => 'Линкувај до родител',
        'Unlock tickets' => 'Отклучи тикети',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Ве молиме изберете барем еден примател',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Одстрани Клиент на Тикет',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Ве молиме избришете го овој внес и внесете нов со коректна вредност.',
        'This address already exists on the address list.' => 'Оваа адреса веќе постои во листата на адреси.',
        'Remove Cc' => 'Избриши Cc',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Избриши Bcc',
        'Date Invalid!' => 'Невалиден датум!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'Корисничка информација',
        'Customer user' => 'Корисник клиент',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Направи Нов E-mail Тикет',
        'Example Template' => 'Пример за Шаблон',
        'To customer user' => 'До корисник клиент',
        'Please include at least one customer user for the ticket.' => 'Во молиме додавајте барем по еден регистриран корисник за тикетот.',
        'Select this customer as the main customer.' => 'Избери го овој клиент како главен клиент.',
        'Remove Ticket Customer User' => 'Избриши Тикет за Регистриран Корисник',
        'From queue' => 'Од редица',
        'Get all' => 'Избери сите',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'КреирајВреме',
        'Article' => 'Натпис',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Мора да користите број на тикет.',
        'A valid ticket number is required.' => 'Потребен е валиден број на тикет.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Потребна е валидна е-mail адреса.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Нова Редица.',
        'Move' => 'Премести',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Не се пронајдени информации за тикет.',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Селектирај го овој тикет',
        'Sender' => 'Испраќач',
        'First Response Time' => 'Прво време на одговор',
        'Update Time' => 'Ажурирај Време',
        'Solution Time' => 'Време за Решение',
        'Move ticket to a different queue' => 'Премести го тикетот во различен ред',
        'Change queue' => 'Измени редица',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Одстрани ги активните филтери за овој приказ.',
        'Tickets per page' => 'Тикети по страна',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Ресетирај преглед.',
        'Column Filters Form' => 'Форма за Филтрирање Колумни',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Подели Во Нов Телефонски Тикет',
        'Save Chat Into New Phone Ticket' => 'Зачувај Разговор Во Нов Телефонски Тикет',
        'Create New Phone Ticket' => 'Направи Нов Телефонски Тикет',
        'Please include at least one customer for the ticket.' => 'Ве молиме внесете барем еден клиент за тикетот.',
        'To queue' => 'Во редица',
        'Chat protocol' => 'Протокол за разговарање',
        'The chat will be appended as a separate article.' => 'Разговорите ќе бидат прикажани во посебна статија.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Обичен',
        'Download this email' => 'Зачувај ја оваа е-порака',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Креирај Нов Процесирачки Тикет',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Вклучи Тикет во некој Процес',

        # Template: AgentTicketSearch
        'Profile link' => 'Линк до Профил',
        'Output' => 'Излез',
        'Fulltext' => 'Целосно',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Креирано во Редицата',
        'Lock state' => 'Заклучена состојба',
        'Watcher' => 'Надгледувач',
        'Article Create Time (before/after)' => 'Креирај време на натпис (пред / потоа)',
        'Article Create Time (between)' => 'Време кога Натпис е креиран (помеѓу)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Креирај Време на Тикет (пред/потоа)',
        'Ticket Create Time (between)' => 'Време кога Тикетот е креиран (помеѓу)',
        'Ticket Change Time (before/after)' => 'Промени Време на Тикет (пред/потоа)',
        'Ticket Change Time (between)' => 'Време кога Тикетот е изменет (помеѓу)',
        'Ticket Last Change Time (before/after)' => 'Последна Промена на Тикет (пред/потоа)',
        'Ticket Last Change Time (between)' => 'Време кога Тикетот последен пат е изменет (помеѓу)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Време на Затворање на Тикет (пред/потоа)',
        'Ticket Close Time (between)' => 'Време кога Тикетот е затворен (помеѓу)',
        'Ticket Escalation Time (before/after)' => 'Ескалирачко Време на Тикет (пред/потоа)',
        'Ticket Escalation Time (between)' => 'Време на ескалација на Тикетот (помеѓу)',
        'Archive Search' => 'Барај во архива',

        # Template: AgentTicketZoom
        'Sender Type' => 'Тип на испраќач',
        'Save filter settings as default' => 'Зачувај ги подесувањата за филтрирање како стандардни',
        'Event Type' => 'Тип на Настан',
        'Save as default' => 'Сними како стандард',
        'Drafts' => '',
        'Change Queue' => 'Измени Редица',
        'There are no dialogs available at this point in the process.' =>
            'Нема слободни дијалози во оваа состојба во процесот.',
        'This item has no articles yet.' => 'Оваа ставка сеуште нема артикли.',
        'Ticket Timeline View' => 'Тикет Хронолошки Преглед',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Додај Филтер',
        'Set' => 'Сетирај',
        'Reset Filter' => 'Ресетирај Филтер',
        'No.' => 'Не.',
        'Unread articles' => 'Непрочитани натписи',
        'Via' => '',
        'Important' => 'Важно',
        'Unread Article!' => 'Непрочитан Натпис!',
        'Incoming message' => 'Дојдовни порака',
        'Outgoing message' => 'Појдовна порака',
        'Internal message' => 'Внатрешни порака',
        'Sending of this message has failed.' => '',
        'Resize' => 'Промени големина',
        'Mark this article as read' => 'Обележи ги овој натпис како прочитан',
        'Show Full Text' => 'Прикажи Цел Текст',
        'Full Article Text' => 'Целосен Текст на Натпис',
        'No more events found. Please try changing the filter settings.' =>
            'Не се пронајдени повеќе настани. Ве молиме изменете го филтерот на пребарувањето.',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'За да отворите линкови во следните натписи , можеби ќе треба да притиснете Ctrl или Cmd или Shift копчето додека кликнувате на линкот (во зависност од вашиот интернет пребарувач и оперативен систем).',
        'Close this message' => 'Затвори ја оваа порака.',
        'Image' => '',
        'PDF' => 'PDF',
        'Unknown' => 'Непознат ',
        'View' => 'Преглед',

        # Template: LinkTable
        'Linked Objects' => 'Поврзани Објекти ',

        # Template: TicketInformation
        'Archive' => 'Архивирај',
        'This ticket is archived.' => 'Овој тикет е архивиран',
        'Note: Type is invalid!' => '',
        'Pending till' => 'На чекање до',
        'Locked' => 'Заклучено',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Профилно време',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'За да ја заштитиме вашата приватност,  далечинската содржина е блокирана.',
        'Load blocked content.' => 'Вчитај блокирана содржина.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Можете да',
        'go back to the previous page' => '',

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
        'New Ticket' => 'Нов Тикет',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => '',
        'Traceback' => 'Следи',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript не е достапно',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Проблем со Прелистувач',
        'The browser you are using is too old.' => 'Пребарувачот што го користите е многу стар.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Ве молиме прегледајте ја документацијата или прашајте го вашиот администратор за повеќе информации.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'Ве молиме почекајте, ќе бидете пренасочени...',
        'Login' => 'Најава',
        'Your user name' => 'Вашето корисничко име',
        'User name' => 'Корисничко име',
        'Your password' => 'Вашата лозинка',
        'Forgot password?' => 'Ја заборавивте вашата лозинка?',
        'Your 2 Factor Token' => '',
        '2 Factor Token' => '',
        'Log In' => 'Најави се',
        'Request Account' => '',
        'Request New Password' => '',
        'Your User Name' => 'Вашето Корисничко Име',
        'A new password will be sent to your email address.' => '',
        'Create Account' => '',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '',
        'Your First Name' => 'Ваше Име',
        'Your Last Name' => 'Ваше Презиме',
        'Your email address (this will become your username)' => 'Вашиот e-mail (ќе стане корисничко име)',

        # Template: CustomerNavigationBar
        'Logout' => 'Одјава',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Добредојдовте!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Страна',
        'Tickets' => 'Тикети',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Профил',
        'e. g. 10*5155 or 105658*' => '',
        'CustomerID' => 'Корисничко ИД',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => '',
        'Time Restrictions' => '',
        'No time settings' => '',
        'All' => 'Сите',
        'Specific date' => 'Специфичен датум ',
        'Only tickets created' => '',
        'Date range' => 'Опсег на датум ',
        'Only tickets created between' => '',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => '',
        'Save as Template' => '',
        'Template Name' => '',
        'Pick a profile name' => '',
        'Output to' => 'Излез',

        # Template: CustomerTicketSearchResultShort
        'of' => 'од',
        'Search Results for' => '',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Reply' => 'Одговор',
        'Discard' => '',
        'Ticket Information' => 'Информација за билет',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => '',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Предупредување',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '',
        'Ticket fields' => '',

        # Template: Error
        'Send a bugreport' => '',
        'Expand' => 'Прошири',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'Edit personal preferences' => '',
        'Personal preferences' => '',
        'You are logged in as' => '',

        # Template: Installer
        'JavaScript not available' => '',
        'Step %s' => 'Чекор %s',
        'License' => 'Лиценца',
        'Database Settings' => '',
        'General Specifications and Mail Settings' => '',
        'Finish' => 'Крај',
        'Welcome to %s' => '',
        'Germany' => '',
        'Phone' => 'Телефон',
        'Switzerland' => '',
        'Web site' => '',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '',
        'Outbound mail type' => 'Тип',
        'Select outbound mail type.' => '',
        'Outbound mail port' => '',
        'Select outbound mail port.' => '',
        'SMTP host' => '',
        'SMTP host.' => '',
        'SMTP authentication' => '',
        'Does your SMTP host need authentication?' => '',
        'SMTP auth user' => '',
        'Username for SMTP auth.' => '',
        'SMTP auth password' => '',
        'Password for SMTP auth.' => '',
        'Configure Inbound Mail' => '',
        'Inbound mail type' => 'Тип',
        'Select inbound mail type.' => '',
        'Inbound mail host' => '',
        'Inbound mail host.' => '',
        'Inbound mail user' => 'Корисник',
        'User for inbound mail.' => '',
        'Inbound mail password' => 'Лозинка',
        'Password for inbound mail.' => '',
        'Result of mail configuration check' => '',
        'Check mail configuration' => '',
        'Skip this step' => '',

        # Template: InstallerDBResult
        'Done' => 'Завршено',
        'Error' => 'Грешка',
        'Database setup successful!' => '',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTOBO' => '',
        'Use an existing database for OTOBO' => '',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Ако сте поставиле лозинка за рут за вашата база на податоци, тоа мора да бидат внесени тука. Ако не, оставете го ова поле празно.',
        'Database name' => 'Податочнабаза име',
        'Check database settings' => '',
        'Result of database check' => '',
        'Database check successful.' => '',
        'Database User' => 'Податочнабаза Корисник',
        'New' => 'Нов',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            '',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '',
        'Restart your webserver' => '',
        'After doing so your OTOBO is up and running.' => '',
        'Start page' => '',
        'Your OTOBO Team' => '',

        # Template: InstallerLicense
        'Don\'t accept license' => '',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'СистемID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => '',
        'Fully qualified domain name of your system.' => '',
        'AdminEmail' => '',
        'Email address of the system administrator.' => '',
        'Organization' => '',
        'Log' => '',
        'LogModule' => '',
        'Log backend to use.' => '',
        'LogFile' => '',
        'Webfrontend' => '',
        'Default language' => '',
        'Default language.' => '',
        'CheckMXRecord' => '',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => '',
        'Add links' => '',
        'Delete links' => '',

        # Template: Login
        'Lost your password?' => '',
        'Back to login' => '',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
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
        'Message of the Day' => '',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => '',
        'Back to the previous page' => '',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Овозможено од',

        # Template: Pagination
        'Show first page' => '',
        'Show previous pages' => '',
        'Show page %s' => '',
        'Show next pages' => '',
        'Show last page' => '',

        # Template: PictureUpload
        'Need FormID!' => '',
        'No file found!' => '',
        'The file is not an image that can be shown inline!' => '',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => '',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Информирај Агент',

        # Template: PublicDefault
        'Welcome' => '',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Дозволи',
        'You can select one or more groups to define access for different agents.' =>
            'Можете да селектирате едена или повеќе групи за да дефинирате пристап за различни агенти.',
        'Result formats' => '',
        'Time Zone' => 'Временска зона',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Спроведува статистика како виџет кој агентите можат да го активираат на нивната Работна табла (dashboard).',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Доколку е сетирано во инвалидно, крајни членови нема да генерираат запис.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'X-оска ',
        'Configure Y-Axis' => '',
        'Y-axis' => '',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Ве молиме изберете само еден елемент за да го исклучите копчето „Фиксно“.',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Формат',
        'Exchange Axis' => 'Размени оски',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Немате селектирано елемент.',
        'Scale' => 'Скала',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => '',
        'Download PNG' => '',

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
        'This setting is disabled.' => '',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => '',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => '',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => '',
        'Add this setting to your favorites' => '',
        'Add to favourites' => '',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => '',
        'Edit this setting' => '',
        'Enable this setting' => '',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => '',
        'User modification' => '',
        'enabled' => '',
        'disabled' => '',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => '',
        'Cancel editing for all settings' => '',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => '',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => '',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => '',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => '',
        'Unlock' => 'Отклучи',
        'Welcome %s %s' => '',
        'Counter' => '',

        # Template: Warning
        'Go back to the previous page' => '',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => '',

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
        'Finished' => 'Завршено',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Додај нов внес',

        # JS Template: AddHashKey
        'Add key' => '',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => '',
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
        'CustomerIDs' => 'Корисничко IDs',
        'Fax' => 'Факс',
        'Street' => 'Улица',
        'Zip' => 'Поштенски код',
        'City' => 'Град',
        'Country' => 'Држава',
        'Mr.' => 'Г-дин.',
        'Mrs.' => 'Г-ѓа',
        'Address' => 'Адреса',
        'View system log messages.' => '',
        'Edit the system configuration settings.' => 'Уредување на систем за  конфигурирање на поставки.',
        'Update and extend your system with software packages.' => '',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ЛКП информации од базата на податоци не е во синхронизација со конфигурација на системот, Ве молиме распоредате ги  сите ЛКП.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'There was an error creating the ACL' => '',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => '',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
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
        '+5 minutes' => '',
        '+15 minutes' => '',
        '+30 minutes' => '',
        '+1 hour' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => '',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => '',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Додади прилог!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '',
        'Last 1 hour' => '',
        'Last 3 hours' => '',
        'Last 6 hours' => '',
        'Last 12 hours' => '',
        'Last 24 hours' => '',
        'Last week' => '',
        'Last month' => '',
        'Invalid StartTime: %s!' => '',
        'Successful' => '',
        'Processing' => '',
        'Failed' => 'Не успеа',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Информација',
        'Warn' => '',
        'days' => 'денови',
        'day' => 'ден',
        'hour' => 'час',
        'minute' => 'минут',
        'seconds' => 'секунди',
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
        'Customer company updated!' => 'Клиент компанијата е ажурирана!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => 'Додади клиент на компанија!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Клиентот е ажуриран!',
        'New phone ticket' => '',
        'New email ticket' => '',
        'Customer %s added' => 'Килент %s додадени',
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
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => '',

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
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'минут(и)',
        'hour(s)' => 'час(ови)',
        'Time unit' => 'Временска единица',
        'within the last ...' => 'во последните...',
        'within the next ...' => 'во рамките на следниот ...',
        'more than ... ago' => 'повеќе од ... ',
        'Unarchived tickets' => 'Не архвирани тикети',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'растечки',
        'descending' => 'намалувајќи',

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
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 минути',
        '15 minutes' => '15 минути',
        '30 minutes' => '',
        '1 hour' => '',
        '2 hours' => '',
        '3 hours' => '',
        '4 hours' => '',
        '5 hours' => '',
        '6 hours' => '',
        '12 hours' => '',
        '18 hours' => '',
        '1 day' => '',
        '2 days' => '',
        '3 days' => '',
        '4 days' => '',
        '6 days' => '',
        '1 week' => '',

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
        'xor' => '',
        'String' => '',
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
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTOBO as provider' => 'OTOBO како давател',
        'Operations' => '',
        'OTOBO as requester' => 'OТRS како барател',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Ажурирање група!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Маил профилот е додаден!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Испраќање на e-пошта На: полето.',
        'Dispatching by selected Queue.' => 'Распределба на селектираниот ред. ',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => '',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => '',
        'File is OK' => '',
        'Package has locally modified files.' => '',
        'Package not verified by the OTOBO Team!' => '',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => '',
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
            '',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '',
        'Can\'t get OTOBO Feature Add-on list from server!' => '',
        'Can\'t get OTOBO Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Додаден Приоритет!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Процес на управување со информации од базата на податоци не е во синхронизација со конфигурација на системот, ве молиме да ги преземете сите процеси.',
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
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => '',
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
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

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
        'Queue updated!' => 'Ажурирај редица!',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-никој-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Измени Релации на Редици за Шаблон',
        'Change Template Relations for Queue' => 'Измени Шаблонски Релации за Редица',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Продукција',
        'Test' => '',
        'Training' => 'Тренинг',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Улога е ажурирана!',
        'Role added!' => 'Додадена улога!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Смени Групни Релации за Улога',
        'Change Role Relations for Group' => 'Промени релации на Улоги за Група',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Промени Односи на Улога за Агент',
        'Change Agent Relations for Role' => 'Измени Агент Релации за Улога',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Ве молиме, прво активирајте %s !',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Ажуриран Потпис',
        'Signature added!' => 'Додаден Потпис',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Држава е додадена!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Систем за е-маил адреса е додаден!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => '',
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
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Измени Релации на Прилози за Шаблон',
        'Change Template Relations for Attachment' => 'Измени Релации на Шаблонот за Прикачување',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Типот е додаден!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Ажуриранње на Агент!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Измени Релации на Група за Агент',
        'Change Agent Relations for Group' => 'Измени Релации на Агент за Група',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Месец',
        'Week' => '',
        'Day' => 'Ден',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '',
        'Every Week' => '',
        'Every Month' => '',
        'Every Year' => '',
        'Custom' => '',
        'Daily' => '',
        'Weekly' => '',
        'Monthly' => '',
        'Yearly' => '',
        'every' => '',
        'for %s time(s)' => '',
        'until ...' => '',
        'for ... time(s)' => '',
        'until %s' => '',
        'No notification' => '',
        '%s minute(s) before' => '',
        '%s hour(s) before' => '',
        '%s day(s) before' => '',
        '%s week before' => '',
        'before the appointment starts' => '',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Историја на клиент',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => '',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => '',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'This feature is not available.' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => '',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Извинете, но  мора да бидете сопственик на овој билет за ова промена.',
        'Please change the owner first.' => 'Ве молиме првин променете го сопственикот.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => '',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Претходен Сопственик',
        'wrote' => 'напишано',
        'Message from' => 'Порака од',
        'End message' => 'Крај на порака',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
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
        'Address %s replaced with registered customer address.' => 'Адреса %s заменета со регистрирана клиент адреса.',
        'Customer user automatically added in Cc.' => 'Клиент корисници автоматски се додаваат во  Cc',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Тикет "% s" создадени!',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Следна недела',
        'Ticket Escalation View' => 'Прикажи Ескалирани Тикети',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Пренасочена порака од',
        'End forwarded message' => 'Заврши пренасочена порака',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Нов Натпис',
        'Pending' => 'Во очекување',
        'Reminder Reached' => 'Потсетникот е постигнат',
        'My Locked Tickets' => 'Мои Заклучени Тикети',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Заклучени Тикет.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'The selected process is invalid!' => 'Одбраниот процес е невалиден!',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => '',
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
        'Pending Date' => '',
        'for pending* states' => '',
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
        'Available tickets' => 'Достапни тикет',
        'including subqueues' => '',
        'excluding subqueues' => '',
        'QueueView' => 'РедицаПоглед',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Мои Одговорни Тикети',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'последно-пребарување',
        'Untitled' => '',
        'Ticket Number' => 'Број на тикет',
        'Ticket' => 'Тикет',
        'printed by' => '',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '',
        'Normal' => 'Нормално',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => 'во повеќе од ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Поглед на Сервис',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Статус Преглед',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Мои прегледани Тикет',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => '',
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
        'Outgoing Email' => '',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => '',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => '',
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
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Препрати натпис преку маил ',
        'Forward' => 'Напред',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Натписот неможе да биде отворед! Можеби е на друга страница со натписи?',
        'Show one article' => 'Прикажи еден натпис',
        'Show all articles' => 'Сприкажи ги сите натписи',
        'Show Ticket Timeline View' => 'Прикажи Тикети во Времеплов',

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
        'My Tickets' => '',
        'Company Tickets' => '',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '',
        'Created within the last' => 'Направено во последните',
        'Created more than ... ago' => 'Креирано пред ... ',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

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
        'Install OTOBO' => 'Инсталирај OTOBO',
        'Intro' => 'Вовед',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Селекција по база на податоци',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Внесете ја лозинката за корисникот во базата на податоци. ',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Внесете ја лозинката на корисникот за административната база на податоци.',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Креирај база на податоци',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Систем подесување ',
        'Syslog' => '',
        'Configure Mail' => 'Конфигуриранње на пошта',
        'Mail Configuration' => 'Конфигурирање на пошта',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'База на податоци веќе содржи податоци-таа треба да биде празна!',
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
        'Chat' => 'Онлајн разговор',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Преместување Член на друга маил адреса',
        'Bounce' => 'Отскокнување',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Одговори на сите',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Забележан одговор',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Поделени на овој член',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Обичен Формат',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Печати ја оваа статија',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Обележано',
        'Unmark' => 'Неозначено ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Шифрирано',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Потпишан',
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
        'Sign' => 'Потпис',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Прикажано',
        'Refresh (minutes)' => '',
        'off' => 'исклучено',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Покажи клиент корисник',
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
        'Shown Tickets' => 'Прикажани Тикети ',
        'Shown Columns' => 'Прикажи Колони',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Седумдневна статистика',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Стандардно',
        'The following tickets are not updated: %s.' => '',
        'h' => 'х',
        'm' => 'м',
        'd' => 'д',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Ова е',
        'email' => 'е-пошта',
        'click here' => 'кликни тука',
        'to open it in a new window.' => 'да го отвори во нов прозорец.',
        'Year' => 'Година',
        'Hours' => 'Часови',
        'Minutes' => 'Минути',
        'Check to activate this date' => 'Проверете за да го активирате овој датум',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Немате Дозвола!',
        'No Permission' => '',
        'Show Tree Selection' => 'Прикажи селекција на дрво',
        'Split Quote' => '',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',
        'Linked' => 'Поврзано',
        'Bulk' => 'Масовно',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Лајт',
        'Unread article(s) available' => 'Непрочитани статија (и) на располагање',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Присутен Агент: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Постојат повеќе ескалирани тикети!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Присутен Клиент %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => '',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Активирана е "Надворешна Конекција" , дали сакате да ја исклучите?',

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
            '',
        'Preferences updated successfully!' => 'Параметри успешно ажурирани!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Потврди ја лозинката',
        'The current password is not correct. Please try again!' => 'Тековната лозинка не е точна. Ве молиме обидете се повторно!',
        'Please supply your new password!' => '',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Не може да се ажурира лозинка, таа мора да биде најмалку %s карактери!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Не може да се ажурира лозинка, тоа мора да содржи најмалку 1 цифра!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'невалидно',
        'valid' => 'валидно',
        'No (not supported)' => 'Не (не е поддржано)',
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
        'second(s)' => 'секундa(и)',
        'quarter(s)' => '',
        'half-year(s)' => '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Содржина',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Отклучи за да го врати назад во редот ',
        'Lock it to work on it' => 'Затворете за работа со Тикет',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Негледана ',
        'Remove from list of watched tickets' => 'Отстрани од листа на гледани тикети',
        'Watch' => 'Гледа',
        'Add to list of watched tickets' => 'Додади во листа на прочитани тикет',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Подреди по',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Нови заклучени билети',
        'Locked Tickets Reminder Reached' => 'Заклучен Тикет Потсетник',
        'Locked Tickets Total' => 'Вкупно заклучени билети',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Нови одговорни билети',
        'Responsible Tickets Reminder Reached' => 'Одговорени Тикет Потсетник ',
        'Responsible Tickets Total' => 'Одговорени Тикети Вкупно',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Следени Нови Тикети',
        'Watched Tickets Reminder Reached' => 'Вкупно следни билети потсетник',
        'Watched Tickets Total' => 'Вкупно следни билети',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Во моментот не е можно да се најавите тоа се должи на закажанато одржување на системот.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => 'Сесија истече. Ве молиме обидете се повторно подоцна.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Сесијата е невалидна. Ве молиме најавете се повторно. ',
        'Session has timed out. Please log in again.' => 'Сесија истече. Ве молиме најавете се повторно.',

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
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
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
        'before/after' => 'пред/после',
        'between' => 'помеѓу',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Ова поле е задолжително или',
        'The field content is too long!' => 'Содржината на полето е премногу долга!',
        'Maximum size is %s characters.' => 'Максимална големина е %s карактери.',

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
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'инсталиран',
        'Unable to parse repository index document.' => 'Неможност за анализрање на складиштето на индекс документот. ',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Нема пакети за вашата верзија на системот, во складиштето се само пакети за друга верзија.',
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
        'Inactive' => 'Некативно',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Не може да се  регистрирате на серверот. Ве молиме обидете се повторно подоцна.',
        'No content received from registration server. Please try again later.' =>
            'Нема содржина добиена од серверот за регистрација. Ве молиме обидете се повторно подоцна.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Корисничкото име и лозинката не се совпаѓаат. Ве молиме обидете се повторно.',
        'Problems processing server result. Please try again later.' => 'Проблем со обработка на ресурсите за серверот. Ве молиме обидете се повторно подоцна.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Збир',
        'week' => 'недела',
        'quarter' => '',
        'half-year' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Креиран Приоритет',
        'Created State' => 'Создадена Држава',
        'Create Time' => 'Креирај Време',
        'Pending until time' => '',
        'Close Time' => 'Време на затварање',
        'Escalation' => 'Ескалација',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Агент/Сопственик',
        'Created by Agent/Owner' => 'Креирано од Агент/Сопственикот',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Eвалуација од страна',
        'Ticket/Article Accounted Time' => 'Тикет/Натпис Заведено Време',
        'Ticket Create Time' => 'Креирај време за Тикет',
        'Ticket Close Time' => 'Затвори време за тикет',
        'Accounted time by Agent' => 'Пресметано време по Агент',
        'Total Time' => 'Вкупно Време',
        'Ticket Average' => 'Просечен тикет',
        'Ticket Min Time' => 'Тикет Мин Време',
        'Ticket Max Time' => 'Максимално време за тикет',
        'Number of Tickets' => 'Број на Тикети',
        'Article Average' => 'Натпис Просек',
        'Article Min Time' => 'Натпис Мин Време',
        'Article Max Time' => 'Максимално време по билет',
        'Number of Articles' => 'Број на Натписи',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Атрибути за печатење',
        'Sort sequence' => 'Сортирај по редослед',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Број',
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
        'Days' => 'Денови ',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Присуство на табела',
        'Internal Error: Could not open file.' => 'Внатрешна грешка: Не може да ја отвори датотеката.',
        'Table Check' => 'Проверка за табела',
        'Internal Error: Could not read file.' => 'Внатрешна грешка: Не може да ја прочита датотеката.',
        'Tables found which are not present in the database.' => 'Пронајдени табели кои не се присутни во нашата база.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Големина на база на податоци ',
        'Could not determine database size.' => 'Неможе да се одреди големината на  база на податоци.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Верзија на база на податоци ',
        'Could not determine database version.' => 'Неможе да се одреди верзијата на  база на податоци.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Клиент Конкција Множзнаци ',
        'Setting character_set_client needs to be utf8.' => 'Поставување карактери_клиент треба да биде utf8.',
        'Server Database Charset' => 'Карактер сет серверска база на податоци',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Табела Множзнаци',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Максимално пребарувања по големина ',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Пребарување по Кеш Големина ',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Подесувањето  \'query_cache_size\' треба да се користи (повисока од 10 MB, но не повеќе од 512 МБ).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Стандардно Складирање на Мотор ',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Пронајдени се  табели со различи методи за складирање ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Потребно е MySQL 5.x или повисоко',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Подесување NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => 'Поставување NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT мора да биде поставено на "ГГГГ-ММ-ДД HH24: МИ: СС".',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Поставување NLS_DATE_FORMAT Проверете SQL ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Поставување client_encoding треба да биде Уникод или utf8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Поставување server_encoding треба да биде Уникод или utf8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Формат на Датум ',
        'Setting DateStyle needs to be ISO.' => 'Поставување на датумот стил треба да биде идентичен.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO диск партиција',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Користење на Диск ',
        'The partition where OTOBO is located is almost full.' => 'Партицијата каде што се наоѓа OTOBO е речиси полна.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Партицијата каде што се наоѓа OТРС нема проблеми во дисковен простор.  ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Користење партиции на дискови ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Дистрибуција',
        'Could not determine distribution.' => 'Неможе да се одреди дистрибуција.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Кернел Верзија ',
        'Could not determine kernel version.' => 'Не може да се утврди кернел верзија',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Системско оптоварување',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Системското оптеретување мора да биде на максимум број на Процесори кои системот ги има(пр. оптеретување со 8 на систем со 8 процесори е во ред).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl модули',
        'Not all required Perl modules are correctly installed.' => 'Не сите потребни Perl модули се правилно инсталирани.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Слободен swap простор (%)',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => 'Користени swap простор (MB)',
        'There should be more than 60% free swap space.' => 'Треба да има повеќе од 60% бесплатен swap простор.',
        'There should be no more than 200 MB swap space used.' => 'Не треба да има повеќе од 200 MB swap простор што се користи.',

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
        'Config Settings' => 'Конфигурациски Подесувања ',
        'Could not determine value.' => 'Не може да се одреди вредноста.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Евиденција на База на Податоци ',
        'Ticket History Entries' => 'Историја на Тикет Записи',
        'Articles' => 'Натписи',
        'Attachments (DB, Without HTML)' => 'Прилози (база на податоци, без HTML)',
        'Customers With At Least One Ticket' => 'Клиенти со најмалку еден тикет',
        'Dynamic Field Values' => 'Вредности на динамички полиња',
        'Invalid Dynamic Fields' => 'Невалидни Динамички Полиња ',
        'Invalid Dynamic Field Values' => 'Невалидни вредности на динамички полиња',
        'GenericInterface Webservices' => 'Генерички Интерфејс Веб Услуги ',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Месеци Помеѓу Првиот и Последниот Тикет',
        'Tickets Per Month (avg)' => 'Тикети За Месец (просечно)',
        'Open Tickets' => 'Отворени Тикети',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Безбедносен ризик: го користите стандардното поставување за SOAP :: Корисник и SOAP :: лозинка. Ве молиме да ги промените.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Стандардна Админ Лозинка ',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Безбедносен ризик: агент сметката на "root@localhost" \'уште има стандарднa лозинка. Ве молиме да ја промените или да ја поништите сметката.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => 'Име на Домеин ',
        'Your FQDN setting is invalid.' => 'Вашиот FQDN поставување е невалиден.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Датотечно Систем Запишување ',
        'The file system on your OTOBO partition is not writable.' => 'На датотечниот систем на вашиот OTOBO партиција не може да се запишува.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Некои од пакетите не се правилно инсталирани.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Пакет Листа ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Вашото Систем ИД  поставување е валидено, тоа треба да содржи само бројки. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Индекс на Тикет Модул ',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Имате повеќе од 60.000 билети и треба да se коristi  StaticDB задниот крај. Види admin рачно (перформанси) за повеќе информации',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Вие не треба да има повеќе од 8.000 отворен билети во вашиот систем.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Напуштени запис во ticket_lock_index Табела',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => 'Напуштени  запис во ticket_index Табела',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
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
        'Webserver' => 'Сервер',
        'Loaded Apache Modules' => 'Натоварено Apache модули',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Користење на Акселаторот ',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Треба да го користите FastCGI или mod_perl да се зголеми ефикасноста на вашите перформанси.',
        'mod_deflate Usage' => 'Користење mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Ве молиме инсталирајте mod_deflate да се подобри GUI брзина.',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => 'Користење mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Ве молиме инсталирајте mod_headers да се подобри GUI брзина.',
        'Apache::Reload Usage' => ' Користи Apache :: за  Освежи',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache :: превчитување или Apache2 :: Освежи треба да се користи како PerlModule и PerlInitHandler да се спречи рестартирање на веб серверот кога ќе инсталирате и надградувате  модули.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Локални Променливи',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Веб сервер верзија',
        'Could not determine webserver version.' => 'Неможе да се одреди сервер верзија.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Конкурентни Корисници',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Проблем',

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
            'Најавата не е успешна! Вашето корисничко име или лозинка се внесе погрешно',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'Функцијата не е активна!',
        'Sent password reset instructions. Please check your email.' => 'Испрати лозинка за ресетирање на инструкции. Ве молиме проверете ја вашата е-маил.',
        'Invalid Token!' => 'Невалиден Токен!',
        'Sent new password to %s. Please check your email.' => 'Испрати нова лозинка на %s. Ве молиме проверете ја вашата е-пошта.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Оваа  е-пошта веќе постои. Ве молиме најавете се или ресетирате ја вашата лозинка.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Оваа е-пошта  не е дозволено да се регистрираат. Ве молиме контактирајте го персоналот  за поддршка.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Нов профил е создаден. Испратете информации за најава %s. Ве молиме проверете ја вашата е-маил.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'невалиден-привремено',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'нов',
        'All new state types (default: viewable).' => '',
        'open' => 'отвори',
        'All open state types (default: viewable).' => '',
        'closed' => 'затворено',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'тековен потсетник',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => ' Во очекување на автомобили',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'Отстранети',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'споено',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'затворање успешно.',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'затворење неуспешно',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'очекување на автомобили во близина +',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'очекување на автомобили во близина -',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'возможно',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'отфрли',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'автоматско враќање',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'автоматцко одбивање',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'автоматско следење',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'автоматски одговор/нов никет ',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'автоматско отстранување ',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 многу ниска',
        '2 low' => '2 ниски',
        '3 normal' => '3 нормални',
        '4 high' => '4 високи',
        '5 very high' => '5 многу високи',
        'unlock' => 'Отклучен',
        'lock' => 'заклучување',
        'tmp_lock' => '',
        'agent' => 'агент',
        'system' => 'систем',
        'customer' => 'корисник',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Известување за истек на време на тикет и негово заклучување',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Додади ги сите',
        'An item with this name is already present.' => 'Веќе постои елемент со вакво име.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Оваа ставка сеуште содржи подставки. Дали сте сигурни дека сакате да ја избришете оваа ставка вклучувајки ги и нејзините подставки?',

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
            'Дали навистина сакате да го избришете ова динамичко после? СИТЕ поврзани податоци ќе бидат ИЗГУБЕНИ!',
        'Delete field' => 'Избриши поле',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Избриши го овој Настан Предизвикувач',
        'Duplicate event.' => 'Дупликат настан.',
        'This event is already attached to the job, Please use a different one.' =>
            'Овој настан е веќе во прилог на работа, Ве молиме да користите друг.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Се појави грешка за време на комуникацијата.',
        'Request Details' => 'Барани Детали',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Прикажи или сокриј ја содржината.',
        'Clear debug log' => 'Исчисти го дебагерскиот дневник',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Избриши го Повикувачот',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Избриши го ова Типковно Мапирање',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Избришија оваа операција',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Клонирај веб сервис',
        'Delete operation' => 'Избриши операција',
        'Delete invoker' => 'Избриши повикувач',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ПРЕДУПРЕДУВАЊЕ: Кога ќе се смени името на "admin" групата, пред донесувањето на соодветни измени во SysConfig, ќе биде заклучен администрацискиот панел! Ако тоа се случи, ве молиме да се реименувајте ја  групата назад во admin на SQL изјава.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '',
        'Do you really want to delete this notification?' => '',

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
        'Remove Entity from canvas' => 'Избриши Ентитет од канвас',
        'No TransitionActions assigned.' => 'Нема доделени Транзициски Акции.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Сеуште немате изберено дијалози. Изберете дијалог на активност од листата лево и повлечете го тука.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Оваа Активност неможе да се избрише бидејќи е Почетна Активност.',
        'Remove the Transition from this Process' => 'Избриши ја Транзицијата од овој Процес',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Доколку го користи ова копче или врска, ќе го напуштите овој екран и сегашната состојба ќе бидат снимени автоматски. Дали сакате да продолжите?',
        'Delete Entity' => 'Избриши Ентитет',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Оваа Активност е веќе искористена во некој Процес. Не можете да ја додадете двапати! ',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Постои неповрзана транзиција во овој канвас. Ве молиме да ја поврзете оваа транзиција пред да додадете нова.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Оваа Транзиција се веќе корисни за оваа Активност. Не можете да ја додадете двапати!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Оваа Транзициска Акција е веќе искористена во оваа Патека. Не можете да ја додадете двапати!',
        'Hide EntityIDs' => 'Сокриј ID на ентитети',
        'Edit Field Details' => 'Измени Детали на Поле',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Надградбата се Испраќа...',
        'Support Data information was successfully sent.' => 'Информациите за Податоци за Поддршка се успешно испратени.',
        'Was not possible to send Support Data information.' => 'Испраќањето на Податоците за Поддршка е невозможно.',
        'Update Result' => 'Дополни Резултат',
        'Generating...' => 'Генерирање...',
        'It was not possible to generate the Support Bundle.' => 'Не е можно да се генерира Збир од Податоци за поддршка.',
        'Generate Result' => 'Генерирај Резултат',
        'Support Bundle' => 'Збир од Податоци за поддршка',
        'The mail could not be sent' => 'Оваа пошта неможе да се испрати',

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
        'Loading...' => 'Се вчитува ...',
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
            'Дали навистина сакате да го избришете оваа системско одржување?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Претходно',
        'Resources' => '',
        'Su' => 'Нед',
        'Mo' => 'Пон',
        'Tu' => 'Вто',
        'We' => 'Сре',
        'Th' => 'Чет',
        'Fr' => 'Пет',
        'Sa' => 'Саб',
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
        'Duplicated entry' => 'Дупликат',
        'It is going to be deleted from the field, please try again.' => 'Ќе биде избришано од полето, ве молиме пробајте повторно.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => 'месец',
        'Remove active filters for this widget.' => 'Одстрани активни филтери за овој виџет.',

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
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => '',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Натпис филтер',
        'Apply' => 'Примени',
        'Event Type Filter' => 'Тип на Настан Филтер',

        # JS File: Core.Agent
        'Slide the navigation bar' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Исклучете го Модот за Компактибилност во Интернет Експлорер!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '',

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
        'One or more errors occurred!' => 'Настанаа една или повеќе грешки!',

        # JS File: Core.Installer
        'Mail check successful.' => '',
        'Error in the mail settings. Please correct and try again.' => '',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '',
        'Invalid date (need a future date)!' => '',
        'Invalid date (need a past date)!' => '',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => '',
        'Filters' => '',
        'Clear search' => '',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Не може да се popup прозорец. Ве молиме усклучете ги сите popup забрани за оваа апликација.',

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
        'There are currently no elements available to select from.' => 'Моментално нема елементи достапни за селектирање.',

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
        'yes' => 'да',
        'no' => 'не',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Групирано',
        'Stacked' => 'Рангирано',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Стрим',
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
