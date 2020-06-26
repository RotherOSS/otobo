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

package Kernel::Language::sw;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_States
    # month-day-year (e.g., "12/31/99")

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';
    $Self->{Completeness}        = 0.43952380952381;

    # csv separator
    $Self->{Separator}         = ',';

    $Self->{DecimalSeparator}  = '';
    $Self->{ThousandSeparator} = '';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Usimamizi wa ACL ',
        'Actions' => 'Matendo',
        'Create New ACL' => 'Tengeneza ACL mpya',
        'Deploy ACLs' => 'Tumia ACL',
        'Export ACLs' => 'Hamisha ACL',
        'Filter for ACLs' => 'Chuja kwa ajili ya ACL',
        'Just start typing to filter...' => 'Anza kuandika ili kuchuja',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hapa unaweza kupakia faili la usanidi ili kuingiza ACL katika mfumo wako. Faili linahitaji kuwa katika umbizo la .yml kama itakavyohamishwa na moduli ya kuhariri ya ACL.',
        'This field is required.' => 'Hili faili linahitajika',
        'Overwrite existing ACLs?' => 'Anduka juu ya ACLS zilizokuwepo?',
        'Upload ACL configuration' => 'Pakia usanidi wa ACL',
        'Import ACL configuration(s)' => 'Leta usanidi wa ACL',
        'Description' => 'Maelezo',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Kutengeneza ACL mpya unaweza kuleta ACL ambazo zimehamishwa kutoka kwenye mfumo mwingine au tengeneza mpya iliyokamilika.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Mabadiliko katika ACL hapa yanaathiri tabia ya mfumo, kama Unatumia data za ACL baadae. Kwa kutumia data za ACL, mabadiliko mapya yaliyofanywa yataandikwa kwneye usanidi.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Tafadhali zingatia: jedwali hili linawakilisha mpangilio wa utekelezaji wa ACL. Kama unahitaji kubadilisha mpangilio ambao ACL unatekelezwa, tafadhali badilisha majina ya ACL yaliyoathiwa.',
        'ACL name' => 'Jina la ACL',
        'Comment' => 'Maoni',
        'Validity' => 'Uhahali',
        'Export' => 'Hamisha',
        'Copy' => 'Nakili',
        'No data found.' => 'Hakuna data zilizopatikana',
        'No matches found.' => 'Hakuna zinazofanana zilizopatikana',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Hariri ACL %s',
        'Edit ACL' => '',
        'Go to overview' => 'Nenda kwenye mapitio',
        'Delete ACL' => 'Futa ACL',
        'Delete Invalid ACL' => 'Futa ACL ambazo ni halali',
        'Match settings' => 'Mipangilio ya kufanana',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Weka vigezo kwa hii ACL.Tumia \'Sifa\' kufananisha na skrini ya sasa au \'Hifadhidaya ya Sifa\' kufananisha viumbi vya sasa vya tiketi ambavyo vipo kwenye hiadhidata.',
        'Change settings' => 'Badili Mipangilio',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Weka unachotaka kubadillisha kama vigezo vinafanana. Weka akilini kwamba \'Wezekana\' ni orodha nyeupe, \'Haiwezekani\' ni orodha nyeusi.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Onyesha maudhui',
        'Edit ACL Information' => '',
        'Name' => 'Jina',
        'Stop after match' => 'Simama baada ya kufanana',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Hifadhi',
        'or' => 'Au',
        'Save and finish' => 'Hifadhi na maliza',
        'Cancel' => 'Futa',
        'Do you really want to delete this ACL?' => 'Je unahitaji kufuta ACL hii?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Tengeneza ACL mpya kwa kukusanya data. Baada ya kutengeneza ACL, utakuwa na uwezo wa kuongeza kipengee cha usanidi katika  ',

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
        'Overwrite existing entities' => 'Andika juu ya vipengele halisi vilivyopo',
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
        'Group' => 'Kundi',
        'Changed' => 'Ilibadilishwa',
        'Created' => 'Ilitengenezwa',
        'Download' => 'Pakua',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Kalenda',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => 'Sheria',
        'Remove this entry' => 'Ondoa ingizo hili',
        'Remove' => 'Ondoa',
        'Start date' => 'Tarehe ya kuanza',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Foleni',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Ongeza ingizo',
        'Add' => 'Ongeza',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Kusanya',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'Rudi nyuma',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Pakia',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Ongeza taarifa',
        'Edit Notification' => 'Hariri taarifa',
        'Export Notifications' => '',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'List' => 'Orodha',
        'Delete' => 'Futa',
        'Delete this notification' => 'Futa taarifa hii',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Toggle this widget' => 'Geuza kifaa hiki',
        'Events' => 'Matukio',
        'Event' => 'Kitendo',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Aina',
        'Title' => 'Mada',
        'Location' => 'Mahali',
        'Team' => '',
        'Resource' => '',
        'Recipients' => 'Wapokeaji',
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
        'Transport' => 'Safirisha',
        'At least one method is needed per notification.' => '',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'Upgrade to %s' => 'Boresha kwenda %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Subject' => 'Somo',
        'Text' => 'Nakala',
        'Message body' => '',
        'Add new notification language' => '',
        'Save Changes' => 'Hifadhi mabadiliko',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'Unaweza kutumia lebo zifuatazo',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'Mfano',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => 'Mchaguo wa usanidi',
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
        'Attachment Management' => 'Usimamizi wa kiambatisho',
        'Add Attachment' => 'Ongeza kiambatanisho',
        'Edit Attachment' => 'Hariri kiambatisho',
        'Filter for Attachments' => 'Chuja kwa ajili ya viambatanisho',
        'Filter for attachments' => '',
        'Filename' => 'Jina la faili',
        'Download file' => 'Pakua faili',
        'Delete this attachment' => 'Futa kiambatanisho',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'Kiambatanishi',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Usimamizi wa majibu wa kiautomatiki',
        'Add Auto Response' => 'Ongeza Majibu ya Kiautomatiki',
        'Edit Auto Response' => 'Hariri Majibu ya Kiautomatiki',
        'Filter for Auto Responses' => 'Chuja kwa ajili ya majibu ya otomatiki.',
        'Filter for auto responses' => '',
        'Response' => 'Majibu',
        'Auto response from' => 'Majibu automatiki kutoka',
        'Reference' => 'Marejeo',
        'To get the first 20 character of the subject.' => 'Kupata herufi 20 za kwanza za somo',
        'To get the first 5 lines of the email.' => 'Kupata mistari 5 ya kwanza ya barua pepe.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'Kupata sifa za makala',
        'Options of the current customer user data' => 'Chaguo la data za mtumiaji za mteja wa sasa',
        'Ticket owner options' => 'Chaguo la mmiliki wa tiketi',
        'Ticket responsible options' => 'Michaguo ya tiketi husika',
        'Options of the current user who requested this action' => 'Michaguo ya mtumiaji wa sasa ambae ameomba tendo hili.',
        'Options of the ticket data' => 'Chaguo la data ya tiketi',
        'Options of ticket dynamic fields internal key values' => 'Chaguo la thamani za muhimu za ndani za uga wenye nguvu wa tiketi.',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Chaguo la thamani za za uga wenye nguvu wa kuonyesa wa tiketi, inatumika katika uga wa Kuangushachini na Chaguowingi.',
        'Example response' => 'Majibu ya mfano',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'Dokezo',
        'Currently support data is only shown in this system.' => '',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Usanidi',
        'Send support data' => 'Tuma data za kusaidia',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Sasisha',
        'System Registration' => 'Usajili wa mfumo',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Sajili mfumo huu',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

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
        'Settings' => 'Mpangilio',
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
        'Status' => 'Hali/hadhi',
        'Account' => '',
        'Edit' => 'Hariri',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Muelekeo',
        'Start Time' => 'Muda wa Kuanza',
        'End Time' => 'Muda wa kumaliza',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Kipaumbele',
        'Module' => 'Moduli',
        'Information' => 'Taarifa',
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
        'Back to search results' => 'Rudi kwenye majibu ya utafutaji',
        'Select' => 'chagua',
        'Search' => 'Tafuta',
        'Wildcards like \'*\' are allowed.' => 'Wildkadi kama \'*\' zinaruhusiwa.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Halali',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Usimamizi wa mteja.',
        'Add Customer' => 'Ongeza wateja',
        'Edit Customer' => 'Badili mteja',
        'List (only %s shown - more available)' => '',
        'total' => '',
        'Please enter a search term to look for customers.' => 'Tafadhali ingiza neno la utafutaji kuwatafuta wateja.',
        'Customer ID' => 'Kitambulisho cha mteja',
        'Please note' => 'Tafadhali jua',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Simamia mahusiano ya Mteja-Kikundi',
        'Notice' => 'Taarifa',
        'This feature is disabled!' => 'Kipengele hiki hakijaruhusiwa.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Tumia kipengele hiki kama unataka kufafanua ruhusa za kikundi kwa wateja.',
        'Enable it here!' => 'Iruhusu hapa.',
        'Edit Customer Default Groups' => 'Hariri kikundi cha chaguo-msingi cha mteja',
        'These groups are automatically assigned to all customers.' => 'Makundi hata yamegaiwa kwa automatiki kwa wateja wote.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Chuja kwa ajili ya makundi',
        'Select the customer:group permissions.' => 'Chagua ruhusa za kikundi za mteja',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Kama hakuna kilichochaguliwa, basi hakuna ruhusa katika kikundi hiki (tiketi zitakuwa hazipatikani kwa wateja).',
        'Search Results' => 'Majibu ya kutafuta',
        'Customers' => 'Wateja',
        'Groups' => 'Makundi',
        'Change Group Relations for Customer' => 'Badili uhusiano wa kikundi kwa mteja',
        'Change Customer Relations for Group' => 'Badili uhusiano wa mteja kwa kikundi',
        'Toggle %s Permission for all' => 'Geuza ruhusa %s kwa wote',
        'Toggle %s permission for %s' => 'Geuza ruhusa %s kwa %s',
        'Customer Default Groups:' => 'Kikundi chaguo-msingi cha mteja',
        'No changes can be made to these groups.' => 'Hakuna mabadiliko yanayoweza kufanywa katika makundi haya.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Ufikivu wa kusoma tu kwenda kwenye tiketi katika kikundi hiki/foleni.',
        'rw' => 'soma andikka',
        'Full read and write access to the tickets in this group/queue.' =>
            'Ufikivu wote wa kusoma na kuandika kwenda kwenye tiketi katika kikundi hiki/foleni.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Usimamizi wa mtumiaji wa mteja',
        'Add Customer User' => 'Ongeza mtumiaji wa mteja',
        'Edit Customer User' => 'Hariri mtumiaji wa mteja',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Mtumiaji wa mteja anahitaji kuwa na historia ya mteja na kuingia kupitia paneli ya mteja.',
        'List (%s total)' => '',
        'Username' => 'Jina la mtumiaji',
        'Email' => 'Barua pepe',
        'Last Login' => 'Muingio wa mwisho',
        'Login as' => 'Ingia kama',
        'Switch to customer' => 'Badili kwenda kwa mteja',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Uga huu unahitajika na iwe anuani ya barua pepe halali',
        'This email address is not allowed due to the system configuration.' =>
            'Barua pepe hii hairuhusiwi kwasababu ya usanidi wa mfumo.',
        'This email address failed MX check.' => 'Barua pepe hii imeshindwa angalio la MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Matatizo katika DNS,  tafadhali anagalia usanidi wako na ingio katika makosa.',
        'The syntax of this email address is incorrect.' => 'Sintaksi katika barua pepe hii sio sawa.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Mteja',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Wateja watumiaji',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Geuza hali amilifu kwa wote',
        'Active' => 'Amilifu',
        'Toggle active state for %s' => 'Geuza hali amilifu kwa %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Unaweza kusimamia makundi haya kwa mpangilio wa usanidi \'\'Kikundicha mteja mara zote Makundi"',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Hariri huduma chaguo-msingi.',
        'Filter for Services' => 'Chuja kwa jili ya huduma',
        'Filter for services' => '',
        'Services' => 'Huduma',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Usimamizi wa uga wenye nguvu',
        'Add new field for object' => 'Ongeza uga mpya kwa kipengele',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Hifadhidata',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Kuongeza uga mpya, chagua aina ya uga kutoka kwenye orodha ya kipengele, kipengele kinafafanua mpaka wa uga na haiwezi kubadilishwa baada ya kutengeneza uga. ',
        'Dynamic Fields List' => 'Orodha ya uga wenye nguvu',
        'Dynamic fields per page' => 'Uga zenye nguvu kwa ukurasa',
        'Label' => 'Lebo',
        'Order' => 'Mpangilio',
        'Object' => 'Kipengele',
        'Delete this field' => 'Futa uga huu',

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
        'Dynamic Fields' => 'Sehemu zinazobadilika',
        'Go back to overview' => 'Rudi nyuma kwenye mapitio',
        'General' => 'Ujumla',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Uga huu unahitajika, na thamani iwe herufu na namba tu.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Lazima iwe ya kipekee na ikubali herufi na namba tu.',
        'Changing this value will require manual changes in the system.' =>
            'Kubadilisha thamani hii itahitaji mabadiliko ya mkono katika mfumo.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Hili ni jina litakaloonyeshwa kwenye skrini uga ukiwa amilifu.',
        'Field order' => 'Kitafuta uga',
        'This field is required and must be numeric.' => 'Uga huu unatakiwa na lazima iwe namba.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Huu ndio mpangilio ambao uga huu utaonyeshwa katika skrini ikiwa amilifu',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Aina ya uga',
        'Object type' => 'Aina ya kipengele',
        'Internal field' => 'Uga wa ndani',
        'This field is protected and can\'t be deleted.' => 'Uga huu unalindwa na hauwezi kufutwa.',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Mipangilio ya uga',
        'Default value' => 'Thamani chaguo-msingi',
        'This is the default value for this field.' => 'Hii ndio thamani chaguo-msingi kwa uga huu.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Ufunguo',
        'Value' => 'Thamani',
        'Remove value' => 'Ondoa thamani',
        'Add Field' => '',
        'Add value' => 'Ongeza thamani',
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
        'Translatable values' => 'Thamani zinazoweza kutafsirika.',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Kama utaamilisha chaguo hili thamani zitatafsiriwa kwa lugha ya mtumiaji.',
        'Note' => 'Kidokezo',
        'You need to add the translations manually into the language translation files.' =>
            'Unahitaji kuongeza utafsiri kwa mkono katika faili la tafsiri la lugha. ',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Thamani ziwezekanazo',
        'Datatype' => '',
        'Filter' => 'Chuja',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Onyesha kiungo',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hapa unaweza kubainisha kiungo cha HTTP cha hiari kwenye uga katika mapitio na skrini zilizokuzwa.',
        'Example' => 'Mfano',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Kituo tarishi',
        'Table / View' => '',
        'User' => 'Mtumiaji',
        'Password' => 'Neno la siri',
        'Identifier' => 'Kitambulisho',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Uchaguzi wa wingi',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Tofauti ya tarehe chaguo-msingi',
        'This field must be numeric.' => 'Uga huu lazima uwe wa namba.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Tofauti ya sasa(katika sekunde) kukadiria thamani ya chaguo-msingi ya uga (mfano 3600 au -60).',
        'Define years period' => 'Fafanua kipindi cha miaka',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Amilisha kipengele hiki ili kufafanua masafa ya miaka funge (kwa mbeleni na zamani) ili kuonyeshwa katika sehemu ya miaka ya uga.',
        'Years in the past' => 'Miaka ya nyuma',
        'Years in the past to display (default: 5 years).' => 'Miaka ya nyuma ya kuonyeshwa (chaguo-msingi: miaka 5).',
        'Years in the future' => 'Miaka ya wakati ujao.',
        'Years in the future to display (default: 5 years).' => 'Miaka ya wakti ujao itaonyesha (chaguo-msingi: miaka 5)',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => 'Zuia uingizaji wa tarehe',
        'Here you can restrict the entering of dates of tickets.' => 'Hapa unaweza kuzuia uingizaji wa tarehe wa tiketi.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Ongeza thamani',
        'Add empty value' => 'Ongeza thamani tupu',
        'Activate this option to create an empty selectable value.' => 'Amilisha chaguo hili kutengeneza thamani tupu inayowezakuchagulika.',
        'Tree View' => 'Mandhari ya mti',
        'Activate this option to display values as a tree.' => 'Amilisha chaguo hili kuonyesha thamani kama mti.',

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
        'Fields' => 'Uga',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Mapitio',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Kupanga elementi ndani ya orodha pia inawezekana kwa kukokota na kudondosha.',
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
        'Reset' => 'Kuweka',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Namba ya safu mlalo',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Bainisha urefu (katika mistari) kwa uga huu katika hali timizi ya uhariri ',
        'Number of cols' => 'Namba ya safu wima',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Bainisha upana (kwa herufi) kwa uga huu katika hali timzi ya uhariri',
        'Check RegEx' => 'Angalia RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hapa unaweza kubainisha maelezo ya kawaida kuangalia thamani. Regex itafanywa na kirekebishi xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx batili',
        'Error Message' => 'Ujumbe wa hitilafu/kosa',
        'Add RegEx' => 'Ongeza RegEx',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Kielezo',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Ukubwa',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Hii sehemu inatakiwa',
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
            'Na moduli hii, wasimamizi wanaweza kutuma ujumbe kwa mawakala, kikundi au wahusika wenye majukumu.',
        'Create Administrative Message' => 'Tengeneza ujumbe wa utawala.',
        'Your message was sent to' => 'Ujumbe wako ulitumwa',
        'From' => 'Kutoka',
        'Send message to users' => 'tuma meseji kwa watumiaji',
        'Send message to group members' => 'tuma meseji kwa memba wa grupu',
        'Group members need to have permission' => 'Wanakikundi wanahitaji kuwa na ruhusa.',
        'Send message to role members' => 'Tuma ujumbe kwa washiriki wenye majukumu. ',
        'Also send to customers in groups' => 'Pia tuma kwa wateja kwenye vikundi.',
        'Body' => 'Kiini',
        'Send' => 'tuma',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Mwisho kufanya ',
        'Run Now!' => 'Fanya sasa',
        'Delete this task' => 'Futa kazi hii',
        'Run this task' => 'Fanya kazi hii',
        'Job Settings' => 'Mipangilio ya kazi',
        'Job name' => 'Jina la kazi',
        'The name you entered already exists.' => 'Jina uliloingiza tayari lipo',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Ratiba ya utekelezaji',
        'Schedule minutes' => 'Dakika za ratiba',
        'Schedule hours' => 'Masaa ya ratiba',
        'Schedule days' => 'Siku za ratiba',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Kwa sasa kazi hii ya ujumla ya wakala haitofanya kazi kwa otomatiki.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Kuwezesha utendaji otomatiki chagua angalau thamani moja kutoka kwenye dakika, saa na siku!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Uchochezi wa tukio',
        'List of all configured events' => 'Orodha ya matukio yote yaliyosanidiwa',
        'Delete this event' => 'Futa tukio hili',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Kwa kuongeza au kwa mbadala katika utekelezaji wa muda, unaweza ukafafanua matukio ya tiketi ambayo yatachochea kazi hii.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Kama tukio la tiketi limefutwa, kichuja cha tiketi kitatumika kuangalia kama tiketi zinafanana. Kazi itafanywa kwenye tiketi tu.',
        'Do you really want to delete this event trigger?' => 'Je unataka kufuta kichocheo hiki cha tukio?',
        'Add Event Trigger' => 'Ongeza kichochezi tukio',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Chagua tiketi',
        '(e. g. 10*5155 or 105658*)' => '(Mfano 10*5155 au 105658)',
        '(e. g. 234321)' => '(Mfano 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(Mfano U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Tafuta nakala kamili katika makala (Mfano "Mar*in" au "Baue" ).',
        'To' => 'Kwenda',
        'Cc' => 'Kupitia kwa',
        'Service' => 'Huduma',
        'Service Level Agreement' => 'Kubaliano ya kivango cha huduma',
        'Queue' => 'Foleni',
        'State' => 'Hali',
        'Agent' => 'Wakala',
        'Owner' => 'Mmiliki',
        'Responsible' => 'Husika',
        'Ticket lock' => 'Kifungo cha tiketi',
        'Dynamic fields' => 'Uga wenye nguvu',
        'Add dynamic field' => '',
        'Create times' => 'Tengeneza muda',
        'No create time settings.' => 'Hakuna mipangilio ya kutengeneza muda',
        'Ticket created' => 'Tiketi imetengenezwa',
        'Ticket created between' => 'Tiketi imetengenezwa kati ya',
        'and' => 'na',
        'Last changed times' => 'Muda wa mwisho kubadilishwa',
        'No last changed time settings.' => 'Hakuna muda wa mwisho kubadilishwa',
        'Ticket last changed' => 'Tiketi imebadilishwa mwisho',
        'Ticket last changed between' => 'Tiketi imebadilishwa mwisho kati ya',
        'Change times' => 'Badili muda',
        'No change time settings.' => 'Hakuna mipangilio ya kubadili muda',
        'Ticket changed' => 'Tiketi imebadilishwa',
        'Ticket changed between' => 'Tiketi imebadilishwa katikati ya',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Mida ya kufunga ',
        'No close time settings.' => 'Hakuna mipangilio ya muda wa kufunga.',
        'Ticket closed' => 'Tiketi imefungwa',
        'Ticket closed between' => 'Tiketi inafungwa kati ya',
        'Pending times' => 'Muda wa kusubiri',
        'No pending time settings.' => 'Muda wa kusubiri wa tiketi umefika',
        'Ticket pending time reached' => 'Muda wa kusubiri wa tiketi umefika',
        'Ticket pending time reached between' => 'Muda wa kusubiri wa tiketi umefika kati ya',
        'Escalation times' => 'Eneza Muda',
        'No escalation time settings.' => 'Hakuna mipangilio ya kueneza muda',
        'Ticket escalation time reached' => 'Muda wa kueneza muda wa tiketi umefika',
        'Ticket escalation time reached between' => 'Muda wa kueneza tiketi umefika kati ya ',
        'Escalation - first response time' => 'Kupanda- muda wa majibu ya kwanza',
        'Ticket first response time reached' => 'Muda wa mwitiko wa kwanza wa tiketi umefika ',
        'Ticket first response time reached between' => 'Muda wa mwitiko wa kwanza wa tiketi ulifika kati ya',
        'Escalation - update time' => 'Kupanda-muda wa kusasisha',
        'Ticket update time reached' => 'Muda wa kusasisha tiketi umefika',
        'Ticket update time reached between' => 'Muda wa kusasisha tiketi ulifika kati ya',
        'Escalation - solution time' => 'Kupanda-Muda wa suluhu',
        'Ticket solution time reached' => 'Muda wa utatuzi wa tiketi umefika',
        'Ticket solution time reached between' => 'Muda wa utatuzi wa tiketi ulifika kati ya',
        'Archive search option' => 'Uchaguzi wa kutafuta nyaraka',
        'Update/Add Ticket Attributes' => 'Sasisha/ongeza sifa za tiketi',
        'Set new service' => 'Weka huduma mpya',
        'Set new Service Level Agreement' => 'Weka Kubaliano Jipya la kiwango la huduma',
        'Set new priority' => 'Weka kipaumbele kipya',
        'Set new queue' => 'Weka foleni mpya',
        'Set new state' => 'Weka hali mpya',
        'Pending date' => 'Tarehe inasubiri',
        'Set new agent' => 'Weka wakala mpya',
        'new owner' => 'Mmiliki mpya',
        'new responsible' => 'Kuwajibika kupya',
        'Set new ticket lock' => 'Weka kufunga kupya kwa tiketi',
        'New customer user ID' => '',
        'New customer ID' => 'Kitambulisho kipya cha mteja',
        'New title' => 'Kichwa cha habari kipya',
        'New type' => 'Aina mpya',
        'Archive selected tickets' => 'Tiketi zilizochaguliwa kutoka kwenye nyaraka',
        'Add Note' => 'Ongeza Kidokezo',
        'Visible for customer' => '',
        'Time units' => 'Kizio cha muda',
        'Execute Ticket Commands' => 'Tekeleza amri ya tiketi',
        'Send agent/customer notifications on changes' => 'Mtumie wakala/mteja taarifa kuhusu mabadiliko',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Amri hii itatekelezwa. Namba ya tiketi itakuwa ARG[0].ARG[1] ni kitambulisho cha tiketi',
        'Delete tickets' => 'Tiketi zilizofutwa ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Onyo: Tiketi zote zilizoathiriwa zitaondolewa kwenye hifadhi data and hazitorejeshwa.',
        'Execute Custom Module' => 'Tekeleza moduli maalum',
        'Param %s key' => 'Ufunguo wa kigezo %s',
        'Param %s value' => 'Thamani ya kigezo %s',
        'Results' => 'matokeo',
        '%s Tickets affected! What do you want to do?' => 'Tiketi %s zimeathirika. Unataka kufanya nini?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Onyo: Umetumia chaguo la kufuta. Tiketi zote zilizofutwa zitapotea!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'Tiketi zilizoathirika',
        'Age' => 'Umri',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Usimamizi wa huduma ya wavuti ya kiolesura cha jumla.',
        'Web Service Management' => '',
        'Debugger' => 'Anaye eua',
        'Go back to web service' => 'Rudi nyuma kwenye huduma za tovuti',
        'Clear' => 'safisha',
        'Do you really want to clear the debug log of this web service?' =>
            'Je unataka kufuta batli eua ya huduma ya tovuti.',
        'Request List' => 'Orodha ya maombi',
        'Time' => 'Muda',
        'Communication ID' => '',
        'Remote IP' => 'IP ya mbali',
        'Loading' => 'Pakia',
        'Select a single request to see its details.' => 'Chagua ombi moja kuona maelezo yake.',
        'Filter by type' => 'Chuja kwa aina',
        'Filter from' => 'Chuja kutoka',
        'Filter to' => 'Chuja kwenda',
        'Filter by remote IP' => 'Chuja kwa IP ya mbali',
        'Limit' => 'Upeo',
        'Refresh' => 'Onyesha upya',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'usanidishaji wote wa data utapotea.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Tafadhali weka jina la kipekee kwa ajili ya huduma ya tovuti hii.',
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
        'Do you really want to delete this invoker?' => 'Je unataka kufuta isababishi hiki?',
        'Invoker Details' => 'Undani wa Kisababishi',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Jina limeshatumika kuweka operesheni ya huduma ya tovuti wa mbali.',
        'Invoker backend' => 'Mazingira ya nyuma ya kisababishi',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Moduli ya mazingira ya nyuma ya kichochezi cha OTOBO itaitwa kuandaa data kutumwa katika mfumo wa mbali, na kushughulikia data zake za majibu.',
        'Mapping for outgoing request data' => 'Kuunganishwa kwa data za maombi zinazotoka nje.',
        'Configure' => 'Sanidi',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data kutoka kwa kichochezi cha OTOBO zitashughulikiwa na kuunganishwa huku, kubadilisha kuwa data ambayo mfumo wa mbali inaitarajia.',
        'Mapping for incoming response data' => 'Kuunganisha data za majibu zinazoingia ndani.',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Data za majibu zitashughulikiwa na kuunganishwa kwa ramani, kuibadilisha kuwa data ambayo kichochezi cha OTOBO kinaitarajia. ',
        'Asynchronous' => 'Solandanifu',
        'Condition' => 'Sharti',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Kichochezi kitashtuliwa na matukio yaliyosanidiwa.',
        'Add Event' => 'Ongeza tukio',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Kuongeza tukio jipya jagua kipengele cha tukio na jina la tukio na bofya kwenye kitufye "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Vichochezi vya tukio solandanifu vitashughulikiwa moja kwa moja wakati wa maombi ya tovuti.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Rusi nyuma kwenda',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Masharti',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Aina ya kunganisha kati ya masharti',
        'Remove this Condition' => 'Ondoa sharti hili',
        'Type of Linking' => 'Aina ya kiunganishi',
        'Add a new Field' => 'Ongeza uga mpya',
        'Remove this Field' => 'Ondoa uga huu',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => 'Ongeza sharti jipya',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Kuunganisha kwa urahisi',
        'Default rule for unmapped keys' => 'Sharti chaguo msingi kwa funguo za kuunganishwa.',
        'This rule will apply for all keys with no mapping rule.' => 'Sharti hili litatumika kwa funguo zote amabazo hazina sharti la kuunganisha.',
        'Default rule for unmapped values' => 'Sharti chaguo msingi kwa thamani ya kuunganishwa.',
        'This rule will apply for all values with no mapping rule.' => 'Sharti hili litatumika kwa thamani zote ambazo hazina sharti la kuunganisha.',
        'New key map' => 'Funguo mpya wa ramani',
        'Add key mapping' => 'Ongeza funguo ya ',
        'Mapping for Key ' => 'Unganisha kwa funguo',
        'Remove key mapping' => 'Ondoa kuunganisha kwa funguo',
        'Key mapping' => 'Kuunganisha kwa funguo',
        'Map key' => 'Kibonye cha ramani',
        'matching the' => 'Linganisha',
        'to new key' => 'Kwenda kwenye kibonye kipya',
        'Value mapping' => 'Thamani ya kuunganisha',
        'Map value' => 'Thamani ya kuunganisha',
        'to new value' => 'Kwa thamani mpya',
        'Remove value mapping' => 'Ondoa thamani ya kuunganisha',
        'New value map' => 'Thamani mpya ya kuunganisha',
        'Add value mapping' => 'Ongeza thamani ya kuunganisha',
        'Do you really want to delete this key mapping?' => 'Je unataka kufuta ufunguo huu wa kutengeneza ramani?',

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
        'Do you really want to delete this operation?' => 'Je unataka kufuta operesheni hii?',
        'Operation Details' => 'Undani wa operesheni',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Jina limeshatumika kuweka operesheni ya huduma ya tovuti wa mbali.',
        'Operation backend' => 'azingira ya nyuma ya mfumo',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Moduli ya mazingira ya nyuma ya uendeshaji ya OTOBO yataitwa ndani kushughulikia maombi, kutengeneza data kwa ajili ya majibu.',
        'Mapping for incoming request data' => 'Tengeneza ramani kwa ajili ya data za maombi zinazoingia.',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Data za majibu zitashughulikiwa na muunganisho huu, kuibadilisha kuifanya kuwa data inayotarajiwa na OTOBO.',
        'Mapping for outgoing response data' => 'Kuunganisha data za majibu zinazotoka nje.',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data za majimu zitashughulikiwa na kuunganishwa huku, kubadili kuwa data ambayo mfumo wa mbali unaitarajia.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Usafirishaji wa Mtandao',
        'Properties' => 'tabia',
        'Route mapping for Operation' => 'Kuunganisha njia kwa ajili ya uendeshaji',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Inafafanua njia ambayo inaunganishwa na uendeshaji huu.Thamani zinazobadilika zilizowekwa alama ya \':\' zinaunganishwa katika jina lililoingizwa na lililopitishwa na mengine katika uunganishaji. (mfano /Tiketi/:kitambulisho cha tiketi).',
        'Valid request methods for Operation' => 'Njia za maombi halali kwa ajili ya uendeshaji',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Weka kikomo kwa ajili ya uendeshaji huu kuwa njia za maombi maalum. Kama hakuna njia iliyochaguliwa maombi yote yatakubaliwa.',
        'Maximum message length' => 'Upeo urefu wa ujumbe',
        'This field should be an integer number.' => 'Uga huu uwe namba kamili.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Hapa unaweza kubainisha ukubwa wa upeo wa juu (katika baiti) wa jumbe zilizopumzika ambazo OTOBO itazishughulikia.',
        'Send Keep-Alive' => 'Tuna Weka-hai',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Usanidi huu unafafanua kama miunganisho ya kuingia ifungwe au iache hai.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Mwisho',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'uthibitisho',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Jina la mtumiaji litumike kufikia mfumo wa mbali.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Neno la siri kwa mtumiaji aliyependelewa.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Seva mbadala',
        'URI of a proxy server to be used (if needed).' => 'URI au seva mbadala itumike (Kama inahitajika).',
        'e.g. http://proxy_hostname:8080' => 'Mfano http://proxy_hostname:8080',
        'Proxy User' => 'Mtumiaji mbadala',
        'The user name to be used to access the proxy server.' => 'Jina la mtumiaji litakalotumika kufikia seva mbadala.',
        'Proxy Password' => 'Neno la siri mbadala',
        'The password for the proxy user.' => 'Neno la siri kwa ajili ya mtumiaji mbadala.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Tumia chaguo la SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Onyesha au ficha michaguo ya SSL kuunganisha ma mfumo wa mbali.',
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
            'Njia kamili na jina la faili la cheti cha mamlaka cha uhalalishaji ambacho kinahalisha cheti cha SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'mfano /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Mpangilio orodha wa Cheti cha Mamlaka (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Njia kamili na jina la mipangilio orodha ya cheti cha mamlaka ambazo zinahakikisha cheti SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'Mfano /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Kiendeshaji kiunganishaji kwa ajili ya kichochezi',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Kiendashaji ambacho kichochezi kinatakiwa kitume maombi kwenda. Vishika nafasi vimewekwa alama na \':\' kitabadilishwa na thamani ya data na itapitishwa na ombi. (mfano/Tiketi/:Kitambulisho cha tiketi=: Kuingia kwa mtumiaji & neno la siri=:neno la siri). ',
        'Valid request command for Invoker' => 'Amri halali ya maombi kwa ajili ya kichochezi',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Amri maalum ya HTTP ya kutumia kwa ajili ya maombi kwa ajili ya kichochezi hiki (Hiari). ',
        'Default command' => 'Sharti chaguo-msingi',
        'The default HTTP command to use for the requests.' => 'Sharti chaguo-msingi la HTTP kutumia kwa ajili ya maombi.',

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
        'SOAPAction separator' => 'Kitenganishi cha kitendo cha SOAP',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Nafasi ya jina',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI kuzipa njia za SOAP muktadha kupunguza utata.',
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
            'Hapa unaweza kubainisha ukubwa wa upeo wa juu (katika baiti) wa jumbe za SOAP ambazo OTOBO itazishughulikia.',
        'Encoding' => 'Usimbaji',
        'The character encoding for the SOAP message contents.' => 'Herufi za usimbaji kwa ajili ya maudhui ya ujumbe wa SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'mfano utf-8, latin1, iso-8859-1, cp1250, n.k.',
        'Sort options' => '',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'Jina lazima liwe la kipekee.',
        'Clone' => 'Nakala idhinishe',
        'Export Web Service' => '',
        'Import web service' => 'Leta huduma ya tovuti',
        'Configuration File' => 'Faili la usanidi',
        'The file must be a valid web service configuration YAML file.' =>
            'Faili lazima liwe faili halali la huduma ya tovuti la usanidi wa YAML.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'kuingiza',
        'Configuration History' => '',
        'Delete web service' => 'Futa huduma ya tovuti',
        'Do you really want to delete this web service?' => 'Je unataka kufuta huduma hii ya tovuti?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Baada ya kuhifadhi usanidi utaelekezwa tena kwenye skrini ya kuhariri.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Kama unataka kurudi katika maelezo tafadhali bofya kibonye cha "Rudi kwenye maelezo"',
        'Remote system' => 'Mfumo wa mbali',
        'Provider transport' => 'Kutoa usafiri',
        'Requester transport' => 'Usafiri wa muombaji',
        'Debug threshold' => 'Kizingiti cha ueuaji',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Katika hali tumizi ya mtoaji, OTOBO inatoa huduma za tovuti ambazo mifumo ya mbali.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Katika hali timizi ya muombaji, OTOBO inatumia huduma za tovuti kwa ajili ya mifumo ya mbali.',
        'Network transport' => 'Usafirishaji wa mtandao',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Uendeshaji ni kazi za mfumo binafsi ambao mifumo ya mbali inaweza kuomba.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Vichochezi vinaanda data kwa ajili ya kuomba huduma ya tovuti ya mbali, na ina shughulikia data zake za majibu.',
        'Controller' => 'Mdhibiti',
        'Inbound mapping' => 'Kuunganishwa kulikofungwa ndani',
        'Outbound mapping' => 'Kuunganishwa kulikofungwa nje',
        'Delete this action' => 'kufuta hatua hii',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Japo kila %s moja ina kiendeshaji ambacho hakipo amilifu au hakipo, tafadhali angalia usajili wa kiendeshaji au futa %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'historia',
        'Go back to Web Service' => 'Rudi nyuma kwenye huduma za tovuti',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hapa unaweza kuangalia matoleo yaliyopita ya usanidi wa huduma za tovuti za sasa, hamisha au zirudishe.',
        'Configuration History List' => 'Orodha ya historia ya usanidi',
        'Version' => 'toleo',
        'Create time' => 'Muda wa kutengeneza',
        'Select a single configuration version to see its details.' => 'Chagua toleo la usanidi mmoja kuona maelezo yake.',
        'Export web service configuration' => 'Hamisha usanidi wa huduma ya tovuti',
        'Restore web service configuration' => 'Rejesha usanidi wa huduma za wavuti.',
        'Do you really want to restore this version of the web service configuration?' =>
            'Je unataka kurejesha toleo hili la usanidi wa huduma za wavuti?',
        'Your current web service configuration will be overwritten.' => 'Usanidi wako wa sasa wa huduma za wavuti utaandikiwa kwa juu.',

        # Template: AdminGroup
        'Group Management' => 'Usimamizi wa kundi',
        'Add Group' => 'Kuongeza kundi',
        'Edit Group' => 'hariri kundi',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Kikundi cha kiongozi kiingie katika eneo la kiongozi na kikundi cha takwimu ili kupata eneo la takwimu.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Tengeneza makundi mapya kushughulikia ruhusa za kupata kwa ajili makundi mbalimbali ya wakala (mfano idara ya manunuzi, idara ya usaidizi, idara mauzo)',
        'It\'s useful for ASP solutions. ' => 'Inatumika kwa ufumbuzi wa ASP.',

        # Template: AdminLog
        'System Log' => 'Batli ya mfumo',
        'Here you will find log information about your system.' => 'Hapa utakuta taarifa batli kuhusu mfumo wako.',
        'Hide this message' => 'kuficha ujumbe huu',
        'Recent Log Entries' => 'Miingio ya batli ya sasa.',
        'Facility' => 'Kituo',
        'Message' => 'Ujumbe',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Usimamizi wa akaunti za barua',
        'Add Mail Account' => 'Kuongeza akaunti ya barua pepe',
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
        'System Configuration' => 'Usanidi wa Mfumo',
        'Host' => 'Mwenyeji',
        'Delete account' => 'kufuta akaunti',
        'Fetch mail' => 'Pakua barua pepe',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => 'Mfano: barua pepe.mfano.com',
        'IMAP Folder' => 'Kabrasha la IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Rekebisha hii tu kama unahitaji kupakua barua pepe kutoka kwenye kabrasha tofauti na kikasha cha ndani.',
        'Trusted' => 'kuaminiwa',
        'Dispatching' => 'Tuma',
        'Edit Mail Account' => 'Hariri akaunti ya barua pepe',

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
        'Ticket Filter' => 'Kichuja tiketi',
        'Lock' => 'funga',
        'SLA' => 'MKH',
        'Customer User ID' => '',
        'Article Filter' => 'Kichuja makala',
        'Only for ArticleCreate and ArticleSend event' => 'Kwaajili ya tukio la TengenezaMakala na TumaMakala tu',
        'Article sender type' => 'Aina ya mtumaji wa makala',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Kama TengenezaMakala au TumaMAkala inatumika kama kichocheo, unahitaji kubainisha kichuja makala pia. Tafadhali chagua japo uga wa kuchja makala mmoja',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Weka viambatanisho katika taarifa',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Taarifa zimetumwa kwa wakala au mteja',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Kupata herufi 20 za kwanza za somo (kutoka kwa wakala wa karibuni)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Kupata mistari 5 ya kwanza ya kiini (kutoka kwa wakala wa makala wa karibuni)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Kupata herufi 20 za kwanza za somo (kutoka kwa makala ya mteja wa karibuni)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Kupata mistari 5 ya kwanza ya kiini (kutoka kwa makala ya mteja wa karibuni)',
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
        'PGP Management' => 'Usimamizi PGP',
        'Add PGP Key' => 'Ongeza funguo ya PGP',
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
            'Kwa njia hii unaweza ukahariri moja kwa moja keyring iliyosanidiwa katika mfumo sanidi.',
        'Introduction to PGP' => 'Utangulizi wa PGP',
        'Bit' => 'Biti',
        'Fingerprint' => 'Alama za vidole',
        'Expires' => 'Malizika',
        'Delete this key' => 'Futa funguo hii',
        'PGP key' => 'Funguo ya PGP ',

        # Template: AdminPackageManager
        'Package Manager' => 'Msimamiz wa kifurushi',
        'Uninstall Package' => '',
        'Uninstall package' => 'Futa kifurushi',
        'Do you really want to uninstall this package?' => 'Je unataka kufuta kifurushi hiki?',
        'Reinstall package' => 'Sakinisha kifurushi',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Je unahitaji kusakinisha kifurushi hiki? Mabaidliko yoyote ya mkono yatapotea.',
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
            'Kama una maswali zaidi tungependa kuyajibu.',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Sanikisha kifueushi',
        'Update Package' => '',
        'Continue' => 'Endelea',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Tafadhali hakikisha hifadhidata yako inakubali vifurushi vya ukubwa zaidi ya MB %s (kwa sasa inakubali vifurush hadi MB %s). Tafadhali kubaliana na mipangilio ya Upeo mkubwa_ulioruhusiwa_wa kifurushi ya hifadhidata yako ili kuzuia makosa.',
        'Install' => 'Sakinisha',
        'Update repository information' => 'Sasisha taarifa zilizohifadhiwa',
        'Cloud services are currently disabled.' => '',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => 'Hifadhi ya mtandaoni',
        'Vendor' => 'Muuzaji',
        'Action' => 'Kitendo',
        'Module documentation' => 'Moduli za nyaraka',
        'Local Repository' => 'Hifadhi ya ndani',
        'This package is verified by OTOBOverify (tm)' => 'Kifurushi hiki kimethibitishwa na OTOBOthibitisha (tm)',
        'Uninstall' => 'Sakinusha',
        'Package not correctly deployed! Please reinstall the package.' =>
            'KIfurushi hakijatumiwa kwa usahihi. Tafadhali Sakini kifurushi tena.',
        'Reinstall' => 'Sakinisha',
        'Features for %s customers only' => 'Vipengele kwa wateja %s tu',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Na %s unaweza kufaidika na vipengele vifuatavyo vya hiari. Tafadhali weka mkataba na %s kama unataka taarifa zaidi.',
        'Package Information' => '',
        'Download package' => 'Pakua kifurushi',
        'Rebuild package' => 'Jenga kifurushi',
        'Metadata' => 'Metadata',
        'Change Log' => 'Badili Kuingia',
        'Date' => 'Tarehe',
        'List of Files' => 'Orodha ya mafaili',
        'Permission' => 'Ruhusa',
        'Download file from package!' => 'Pakua faili kutoka kwenye kifurushi',
        'Required' => 'Hitajika',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Tofauti ya faili kwa faili %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Utendaji batli',
        'Range' => 'Masafa',
        'last' => 'Mwisho',
        'This feature is enabled!' => 'Kipengele hiki kimeruhusiwa!',
        'Just use this feature if you want to log each request.' => 'Tumia kipengele hiki kama unataka kuingia kila ombi.',
        'Activating this feature might affect your system performance!' =>
            'kuamilisha kipengele hiki kunaweza kuathisi utendaji wa mfumo wako! ',
        'Disable it here!' => 'Usiiruhusu hapa',
        'Logfile too large!' => 'Faili la batli ni kubwa sana!',
        'The logfile is too large, you need to reset it' => 'Faili la batli ni kubwa, unahitaji kuliweka tena',
        'Interface' => 'Kiolesura',
        'Requests' => 'Maombi',
        'Min Response' => 'Majibu ya kima cha chini',
        'Max Response' => 'Majibu ya kima cha juu',
        'Average Response' => 'Majibu wa wastani',
        'Period' => 'Kipindi',
        'minutes' => 'Dakika',
        'Min' => 'Kima cha chini',
        'Max' => 'Kima cha juu',
        'Average' => 'Wastani',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Usimamizi wa kichuja cha Mkuu wa kuchapisha',
        'Add PostMaster Filter' => 'Ongeza kichuja Mkuu wa kuchapisha ',
        'Edit PostMaster Filter' => 'Hariri Kichuja Mkuu wa kuchapisha',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Kutuma au kuchuja barua pepe zinazoingia kulingana na kichwa cha habari za barua pepe. Fananisha kwa kutumia semi za mara kwa mara pia inawezekana.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Kama unataka kufananisha barua pepe tu, tumia ANUANI YA BARUA PEPE: info@example.com kwa kutoka, kwenda au Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Kama unatumia semi za mara kwa mara, pia unaweza kutumia thamani zinazofafana kwenye () kama [***] katika  kitendo cha \'Weka\'',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Futa kichuja hiki',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Masharti ya kuchuja',
        'AND Condition' => 'Masharti ya AND',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Uga unahitaji kuwa msemo wa mara kwa mara wa halali au neno halisi',
        'Negate' => 'Kanusha',
        'Set Email Headers' => 'Tuma kichwa cha habari cha barua pepe',
        'Set email header' => 'Weka kichwa cha habari cha barua pepe',
        'with value' => '',
        'The field needs to be a literal word.' => 'Uga unahitaji kuwa neno halisi',
        'Header' => 'Kichwa',

        # Template: AdminPriority
        'Priority Management' => 'Usimamizi wa kipaumbele',
        'Add Priority' => 'Ongeza Kipaumbele',
        'Edit Priority' => 'Hariri Kipaumbele',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Usimamizi wa mchakato',
        'Filter for Processes' => 'Chuja kwa aijili ya mchakato',
        'Filter for processes' => '',
        'Create New Process' => 'Tengeneza Mchakato mpya',
        'Deploy All Processes' => 'Tumia michakato yote',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hapa unaweza kupakia faili la kusanidi kuleta mchakato katika mfumo wako. Faili linahitaji kuwa katika muundo wa .yml kama lilivyopelekwa na moduli ya usimamizi wa mchakato.',
        'Upload process configuration' => 'Pakia usanidi wa mchakato',
        'Import process configuration' => 'Leta usanidi wa mchakato',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Kutengeenza mchakato mpya unaweza kuleta mchakato ambao uliumehamishwa kutoka kwenye mfumo mwingine au kutengeneza mpya uliokamilika.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Mabadiliko katika michakato hapa inaadhiri tabia ya mfumo, kama unalandanisha data za mchakato. Kwa kulandanisha michakato, mabadiliko mapya yaliyofanywa yataandikwa kwneye usanidi.',
        'Processes' => 'Michakato',
        'Process name' => 'Jina la mchakato',
        'Print' => 'Chapisha',
        'Export Process Configuration' => 'Hamisha usanidi wa mchakato',
        'Copy Process' => 'Nakili mchakato',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => 'Rudi nyuma',
        'Please note, that changing this activity will affect the following processes' =>
            'Tafadhali zingatia kwamba kubadilisha hiki kitendo itaadhiri michakato ifuatayo',
        'Activity' => 'Shughuli',
        'Activity Name' => 'Jina la shughuli',
        'Activity Dialogs' => 'Mazungumzo ya shughuli',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia Kisanduku kidadisi cha shughuli kwa shughuli hii kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Filter available Activity Dialogs' => 'Chuja mazungumzo yaliyopo ya shughuli',
        'Available Activity Dialogs' => 'Mazungumzo ya shughuli yaliyopo',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => 'Tengeneza mazungumzo ya shughuli mapya',
        'Assigned Activity Dialogs' => 'Kupewa mazungumzo ya shughuli',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Tafadhali zingatia kwamba mazunguzo haya ya shughuli itaathiri shughuli zifuatazo',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Tafadhali tambua kuwa watumiaji wa mteja hawataweza kuona au kutumia uga zifuatazo: Mmiliki, Kuwajibika, Funga, Muda wa kusubiri na kitambulisho cha mteja.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Uga wa foleni unaweza kutumika na wateja tu wakati wa kutengeneza tiketi mpya.',
        'Activity Dialog' => 'Kikadisi cha shughuli',
        'Activity dialog Name' => 'Jina la kidadisi cha shughuli',
        'Available in' => 'Inapatikana kwa ',
        'Description (short)' => 'Maelezo (fupi)',
        'Description (long)' => 'Maelezo (Ndefu)',
        'The selected permission does not exist.' => 'Ruhusa ilichaguliwa haipo.',
        'Required Lock' => 'Kufuli inayohitajika',
        'The selected required lock does not exist.' => 'Kufuli inayohitajika iliyochaguliwa haipo.',
        'Submit Advice Text' => 'Kusanya matini ya ushauri',
        'Submit Button Text' => 'Kusanya kitufe cha matini',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia uga kwa Kisanduku kidadisi hiki cha shughuli kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Filter available fields' => 'Chuja Uga zinazopatika',
        'Available Fields' => 'Uga uliopo',
        'Assigned Fields' => 'Uga zilizogaiwa',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Onyesha',

        # Template: AdminProcessManagementPath
        'Path' => 'Njia',
        'Edit this transition' => 'Hariri mpito huu',
        'Transition Actions' => 'Matendo ya mpito',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia matendo mpito kwa huu mpito kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Filter available Transition Actions' => 'Chuja matendo ya mpito yanayopatikana',
        'Available Transition Actions' => 'Matendo ya mpito yanayopatikana',
        'Create New Transition Action' => 'Tengeneza tendo jipya la mpito.',
        'Assigned Transition Actions' => 'Matendo ya mpito yaliyogaiwa',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Shughuli',
        'Filter Activities...' => 'Chuja shughuli',
        'Create New Activity' => 'Tengeneza shughuli nyingine',
        'Filter Activity Dialogs...' => 'Chuja Kidadisi cha shughuli ',
        'Transitions' => 'Mapito',
        'Filter Transitions...' => 'Chuja mapito',
        'Create New Transition' => 'Tengeneza mpito mpya',
        'Filter Transition Actions...' => 'Chuja matendo ya mpito...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Hariri mchakato',
        'Print process information' => 'Chapa taarifa za mchakato',
        'Delete Process' => 'Futa mchakato',
        'Delete Inactive Process' => 'Futa michakato isiyoamilifu.',
        'Available Process Elements' => 'Elementi za mchakato zinazopatikana',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementi zilizoorozeshwa juu ya huu mwambaa upande unawezwa kuhamishwa eneo la kanvasi kulia kwa kutumia kokota na dondosha.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Unaweza kuweka shuguli kwenye eneo la kanvasi ili kugawa hili tukio kwa mchakato.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Kuipa mazungumzo ya shuguli shughuli dondosha kipengele cha mazungumzo ya shughuli kutoka kwenye mwambaa upande huu juu ya shughuli iliyowekwa katika kanvasi.  ',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Vitendo vinaweza kugaiwa kwa Mpito kwa kudondosha Kipengele cha kitendo katika lebo ta Mpito.',
        'Edit Process Information' => 'Hariri taarifa za mchakato',
        'Process Name' => 'Jina la mchakato',
        'The selected state does not exist.' => 'Hali iliyochaguliwa haipo.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Ongeza na hariri shuguli, mazungumzo ya shuguli na mipito',
        'Show EntityIDs' => 'Onyesha kitambulisho cha ingizo',
        'Extend the width of the Canvas' => 'Ongeza upana wa kanvasi.',
        'Extend the height of the Canvas' => 'Ongeza urefu wa kanvasi.',
        'Remove the Activity from this Process' => 'Ondoa shughuli kutoka kwenye mchakato huu.',
        'Edit this Activity' => 'Hariri shughuli hii',
        'Save Activities, Activity Dialogs and Transitions' => 'Hifadhi shuguli, mazungumzo ya shuguli na mipito',
        'Do you really want to delete this Process?' => 'Je unataka kufuta mchakato huu?',
        'Do you really want to delete this Activity?' => 'Je unataka kufuta shughuli hii?',
        'Do you really want to delete this Activity Dialog?' => 'Je unataka kufuta Kidadisi kitendo?',
        'Do you really want to delete this Transition?' => 'Je unataka kufuta mpito huu?',
        'Do you really want to delete this Transition Action?' => 'Je unataka kufuta kitendo hiki cha mpito?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Je unataka kutoa kitendo hiki kwenye kanvasi? Hii inaweza kutokufanywa kwa kutoka kwenye skrini hii bila kuhifadhi. ',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Je unataka kutoa mpito huu kwenye kanvasi? Hii inaweza kutokufanywa kwa kutoka kwenye skrini hii bila kuhifadhi. ',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Katika skrini hii, unaweza kutengeneza mchakato mpya. Ili kufanya mchakato mpya utakaopatikana kwa watumiaji, tafadhali hakikisha unaweka hali yake kuwa \'Amilifu\' na landanisha baada ya kumaliza kazi yako.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Anza shughuli',
        'Contains %s dialog(s)' => 'Yenye %s mazungumzo',
        'Assigned dialogs' => 'Mazungumzo yaliyogaiwa',
        'Activities are not being used in this process.' => 'Shughuli hazitumiki katika mchakato huu.',
        'Assigned fields' => 'Uga zilizogaiwa',
        'Activity dialogs are not being used in this process.' => 'Mazungumzo ya shughuli hayatumiki katika mchakato huu.',
        'Condition linking' => 'Kuunganisha masharti',
        'Transitions are not being used in this process.' => 'Mipito haitumiki katika mchakato huu.',
        'Module name' => 'Jina la moduli',
        'Transition actions are not being used in this process.' => 'Vitendo vya mipito havitumiki katika mchakato huu.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Tafadhali zingatia kwamba kubadili mpito huu utaathiri michakato ifuatayo',
        'Transition' => 'Mpito',
        'Transition Name' => 'Jina la mpito',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Tafadhani zingatia kwamba ubadilishaji wa mpito huu utaathiri michakato ifuatayo',
        'Transition Action' => 'Kitendo cha mpito',
        'Transition Action Name' => 'Jina la kitendo cha mpito',
        'Transition Action Module' => 'Moduli ya kitendo cha mpito',
        'Config Parameters' => 'Vigezo vya usanidi',
        'Add a new Parameter' => 'Ongeza kigezo kipya',
        'Remove this Parameter' => 'Ondoa hiki kigezo',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Ongeza Foleni',
        'Edit Queue' => 'Hariri Foleni',
        'Filter for Queues' => 'Chuja kwa ajili ya foleni',
        'Filter for queues' => '',
        'A queue with this name already exists!' => '',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Foleni ya ',
        'Unlock timeout' => 'Fungua muda kuisha',
        '0 = no unlock' => '0= hakuna kutokufunga',
        'hours' => 'Masaa',
        'Only business hours are counted.' => 'Masaa ya kazi tu ndo yanahesabika.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Kama wakala amefunga tiketi na hajaifungua kabla ya muda wa wa kuisha kupita, tiketi itafunguliwa na na itakuwa inapatikana kwa mawakala wengine.',
        'Notify by' => 'Taarifu kwa',
        '0 = no escalation' => '0= hakuna kupanda',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Kama hakuna anwani ya mteja iliyoongezwa, barua pepe au simu, kwenye tiketi mpya kabla ya muda uliofafanuliwa hapa haujaisha, tiketi itapandishwa.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Kama kuna makala imeongezwa, kama ufuatiliaji kwa barua pepe au kituo cha mteja, muda wa kuenea wa kusasishwa umewekwa upya. Kama hakuna anuani ya mteja, au barua pepe ya nje au simu, iliyoongezwa kwenye tiketi kabla ya muda uliofafanuliwa hapa haujaisha, tiketi itaenezwa',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Kama tiketi imewekwa kufungwa kabla ya muda ulioowekwa hapa haujaisha, tiketi itaenezwa.',
        'Follow up Option' => 'Chaguo la kufuatilia',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Bainisha kama ufuatiliaji kwa tiketi zilizofungwa utafungua tiketi, kataliwa au itasababisha tiketi mpya.',
        'Ticket lock after a follow up' => 'Tiketi imefungwa baada ya ufuatiliaji.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Kama tiketi imefungwa na mteja ametuma ufuatiliaji tiketi itafunguliwa kwa mmiliki wa zamani.',
        'System address' => 'Anuani ya mfumo',
        'Will be the sender address of this queue for email answers.' => 'Itakuwa anuani ya mtumaji wa foleni kwa majibu ya barua pepe.',
        'Default sign key' => 'Funguo ya alama chaguo msingi',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Salamu',
        'The salutation for email answers.' => 'Salamu kwa majibu ya barua pepe',
        'Signature' => 'Saini',
        'The signature for email answers.' => 'Saini kwa majibu ya barua pepe',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Simamia mahusiano ya majibu ya otomatiki ya foleni',
        'Change Auto Response Relations for Queue' => 'Badili mahusiano ya majibu ya otomatiki kwa ajili ya foleni',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => 'Majibu ya otomatiki',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Simamia mahusiano ya kielezo cha foleni.',
        'Filter for Templates' => 'Kichujio cha kielezo',
        'Filter for templates' => '',
        'Templates' => 'Kielezo',

        # Template: AdminRegistration
        'System Registration Management' => 'Usimamizi usajili wa mfumo',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTOBO-ID' => '',
        'Deregister System' => 'Kufuta usajili wa mfumo',
        'Edit details' => 'Hariri maelezo',
        'Show transmitted data' => 'Onyesha data zilizotumwa',
        'Deregister system' => 'Futa usajili wa mfumo',
        'Overview of registered systems' => 'Marejeo ya mifumo iliyosajiliwa',
        'This system is registered with OTOBO Team.' => '',
        'System type' => 'Aina ya mfumo',
        'Unique ID' => 'Kitambulisho cha kipekee',
        'Last communication with registration server' => 'Mawasiliano ya mwisho na seva ya usajili.',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'OTOBO- ingia na kitambulidho',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Soma zaidi',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Unahitaji kuingia na kitambulisho chako cha OTOBO kusajili mfumo wako.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Kitambulisho chako cha OTOBO ni barua pepe uliyotumia kujiunga katika ukurasa wa tovuti wa OTOBO.com',
        'Data Protection' => 'Ulinzi wa data',
        'What are the advantages of system registration?' => 'Nini faida za usajili wa mfumo?',
        'You will receive updates about relevant security releases.' => 'Utapokea habari kuhusu matoleo yanayohusiana na usalama.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Kwa usajili wako wa mfumo tutaboresha huduma zetu kwa ajili yako, kwasababu tuna tarifa zote zinazohusika.',
        'This is only the beginning!' => 'Huu ni mwanzo tu!',
        'We will inform you about our new services and offerings soon.' =>
            'Tutakupa taarifa kuhusu huduma zetu mpya na ofa karibuni.',
        'Can I use OTOBO without being registered?' => 'Je ninawezakutumia OTOBO bila kujisajili?',
        'System registration is optional.' => 'Usajili wa mfumo ni mzuri.',
        'You can download and use OTOBO without being registered.' => 'Unaweza kupakua na kutumia OTOBO bila kusajiliwa.',
        'Is it possible to deregister?' => 'Inawezeka kujifuta?',
        'You can deregister at any time.' => 'Unaweza kujitoa muda wowote',
        'Which data is transfered when registering?' => 'Data gani zinatumwa wakati wa usajili?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Jina ka Kikoa lilifuzu Kamili (FQDN), Toleo la OTOBO, Hifadhi data, Mfumo endeshi na Toleo la Perl.',
        'Why do I have to provide a description for my system?' => 'Kwanini nitoe maelezo kwa ajili ya mfumo wangu.',
        'The description of the system is optional.' => 'Maelezo ya mfumo ni wa hiari.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Maelezo na aina ya mfumo unaobainisha unakusaidia kugundua na kusimamia maelezo ya mfumo wako uliosajiliwa.',
        'How often does my OTOBO system send updates?' => 'Ni kila baada ya muda gani mfumo wangu wa OTOBO unatuma ushasishwaji?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Mfumo utatuma visasihi kwenye seva ya usajili kila baada ya muda flani.',
        'Typically this would be around once every three days.' => 'Hii itakuwa kila mara moja kila  siku tatu',
        'If you deregister your system, you will lose these benefits:' =>
            'Kama utatoa usajili katika mfumo wako, utapoteza manufaa haya.',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Unahitaji kuingia na kitambulisho chako cha OTOBO kutoa usajili katika mfumo wako.',
        'OTOBO-ID' => 'Kitambulisho cha OTOBO',
        'You don\'t have an OTOBO-ID yet?' => 'Hauna kitambulisho cha OTOBO bado?',
        'Sign up now' => 'Jiandikishe sasa',
        'Forgot your password?' => 'Umesahau neno lako la siri?',
        'Retrieve a new one' => 'Pata jipya',
        'Next' => 'Baadae',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => 'Sifa',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'Toleo la OTOBO',
        'Operating System' => 'Mfumo endeshi',
        'Perl Version' => 'Toleo la perl',
        'Optional description of this system.' => 'Maelezo mafupi ya hiari ya mfumo huu.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Usajili',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => 'Ondoa usajili',
        'You can modify registration settings here.' => 'Unaweza kurekebisha mipangilio ya usajili hapa',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'Hakuna data za mara kwa mara zinazotumwa katika mfumo wako kwenda %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Data ifuatayo inatumwa kila siku 3 katika katika mfumo wako %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Data itatumwa katika umbizo la JSON kupitia muunganisho wa salama wa https.',
        'System Registration Data' => 'Data ya usajili wa mfumo',
        'Support Data' => 'Data za masaada',

        # Template: AdminRole
        'Role Management' => 'Usimamizi wa jukumu',
        'Add Role' => 'Ongeza jukumu',
        'Edit Role' => 'Hariri jukumu',
        'Filter for Roles' => 'Chuja kwa ajili ya majukumu',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Tengeneza jukumu na weka makundi ndani yake. Halafu ongeza jukumu kwa watumiaji.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Hakuna majukumu yalifafanuliwa.Tafadhali tumia kitufe \'Ongeza\' kutengeneza jukumu jipya.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Simamia mahusiano ya Jukumu-Kikundi',
        'Roles' => 'Majukumu',
        'Select the role:group permissions.' => 'Chagua jukumu: Ruhusa za kikundi',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Kama hakuna kilichochaguliwa, kutakuwa hakuna ruhusa katika kikundi hiki (tiketi hazitapatikana kwa ajili ya jukumu).  ',
        'Toggle %s permission for all' => 'Geuza ruhusa %s kwa wote',
        'move_into' => 'Hamisha_Utambulisho',
        'Permissions to move tickets into this group/queue.' => 'Ruhusa za kuhamisha tiketi katika kikundi/foleni.',
        'create' => 'Tengeneza',
        'Permissions to create tickets in this group/queue.' => 'Ruhusa ya kutengeneza tiketi katika kikundi/foleni.',
        'note' => 'Kidokezo',
        'Permissions to add notes to tickets in this group/queue.' => 'Ruhusa za kuongeza vidokezo kwenye tiketi katika kikundi/foleni.',
        'owner' => 'Mmiliki',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Ruhusa za kubadili mmiliki wa tiketi katika kikundi hiki/foleni.',
        'priority' => 'Kipaumbele',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Ruhusa za kubadilisha kipaumbele cha tiketi katika kikundi/foleni.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Simamia mahusiano ya Wakala-Jukumu',
        'Add Agent' => 'Oneza wakala',
        'Filter for Agents' => 'Chuja kwa ajili ya wakala',
        'Filter for agents' => '',
        'Agents' => 'Mawakala',
        'Manage Role-Agent Relations' => 'Simamia mahusiano ya Jukumu-Wakala',

        # Template: AdminSLA
        'SLA Management' => 'Usimamizi wa SLA',
        'Edit SLA' => 'Hariri SLA',
        'Add SLA' => 'Ongeza SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Tafadhali andika namba tu!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Usimamizi wa S/MIME ',
        'Add Certificate' => 'Ongeza cheti',
        'Add Private Key' => 'Ongeza kibonye binafsi',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Chuja kwa ajili ya vyeti',
        'To show certificate details click on a certificate icon.' => 'Kuonyesha undani wa vyeti bofya kwenye ikoni ya cheti',
        'To manage private certificate relations click on a private key icon.' =>
            'Kusimamia mahusiano ya cheti binafsi bofya kwenye ikoni ya kibonye binafsi.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hapa unaweza kuongeza mahusiano katika cheti chako binafsi, hizi zitajificha kwenye saini ya S/MIME muda wote unaotumia hiki cheti kusaini barua pepe. ',
        'See also' => 'Pia ona',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Kwa njia hii unaweza moja kwa moja kuhariri cheti na kibonye binafsi katika mfumo wa faili.',
        'Hash' => 'Kali',
        'Create' => 'Tengeneza',
        'Handle related certificates' => 'Mudu vyeti vinanyohusiana',
        'Read certificate' => 'Soma vyeti',
        'Delete this certificate' => 'Futa cheti hiki',
        'File' => 'Faili',
        'Secret' => 'Siri',
        'Related Certificates for' => 'Vyeti vinavyohusiana ',
        'Delete this relation' => 'Futa huu uhusiano ',
        'Available Certificates' => 'Vyeti vinavyopatikana',
        'Filter for S/MIME certs' => 'Chuja kwa ajili ya vyeti vya S/MIME ',
        'Relate this certificate' => 'Husisha hiki cheti',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Cheti cha S/MIME ',
        'Certificate Details' => '',
        'Close this dialog' => 'Funga mazungumzo haya',

        # Template: AdminSalutation
        'Salutation Management' => 'Usimamizi wa salamu',
        'Add Salutation' => 'Ongeza Salamu',
        'Edit Salutation' => 'Hariri salamu',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'Mfano',
        'Example salutation' => 'Mfano wa salamu',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Hali timizi salama (kawaida) itawekwa baada ya usanidi wa kwanza kumalizika.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Kama hali timizi salama haijaamilishwa, amilisha kwa kupitia Usanidi wa Mfumo kwasababu programu tumizi tayari inafanya kazi.',

        # Template: AdminSelectBox
        'SQL Box' => 'Kisanduku cha SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hapa unaweza kuingia SQL kutuma moja kwa moja kwenye hifadhi data ya programu. Haiwezekani kubadilisha yaliyomo kwenye jedwali, chagua tu foleni zinazoruhusiwa.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hapa unaweza kuingia SQL kutuma moja kwa moja kwenye hifadhi data ya programu.',
        'Options' => 'Chaguo',
        'Only select queries are allowed.' => 'Foleni zilizochaguliwa tu zinaruhusiwa.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Sintaksi ya ulizo lako la SQL lina makosa. Tafadhali liangalie.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Kuna japo parameta moja imepotea kwa ajili ya uunganishaji. Tafadhali iangalie.',
        'Result format' => 'Umbizo la matokeo',
        'Run Query' => 'Endesha ulizo.',
        '%s Results' => '',
        'Query is executed.' => 'Ulizo linatekelezwa.',

        # Template: AdminService
        'Service Management' => 'Usimamizi wa huduma',
        'Add Service' => 'Ongeza Huduma',
        'Edit Service' => 'Hariri huduma',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Huduma ya ',

        # Template: AdminSession
        'Session Management' => 'Usimamizi wa kipindi',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Vipindi vyote',
        'Agent sessions' => 'Vipindi vya wakala',
        'Customer sessions' => 'Vipindi vya mteja',
        'Unique agents' => 'Makala wa kipee',
        'Unique customers' => 'Wateja wa kipee',
        'Kill all sessions' => 'Ua vipindi vyote',
        'Kill this session' => 'Ua kipindi hiki',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Vipindi',
        'Kill' => 'Ua',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Usimamizi wa Saini',
        'Add Signature' => 'Ongeza Saini',
        'Edit Signature' => 'Hariri Saini',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Saini ya mfano',

        # Template: AdminState
        'State Management' => 'Usimamizi wa hali',
        'Add State' => 'Ongeza Hali',
        'Edit State' => 'Hariri hali',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Angalizo',
        'Please also update the states in SysConfig where needed.' => 'Tafadhali sasisha pia hali katika usanidi wa mfumo utapohitajika.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Aina ya hali',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Unaweza kuchochea kwa mkono data ya kusaidia kwa kutuma kwa kubofya kitufe:',
        'Send Update' => 'Tuma usasishaji',
        'Currently this data is only shown in this system.' => 'Kwasasa hii data inaonyeshwa katika mfumo huu',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Kifurushi cha msaada (Inahusisha: taarifa za usajili za mfumo, data za msaada, orodha ya vifurushi vilivyosanidiwa na mafaili ya chanzo msimbo yote yaliyorekebishwa) yanaweza kuundwa kwa kubofya kibonye hiki.',
        'Generate Support Bundle' => 'Tengeneza kifurushi cha msaada.',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Tafadhali chagua moja kati ya michaguo ifuatayo.',
        'Send by Email' => 'Tuma kwa barua pepe',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Kifurushi cha msaada ni kikubwa sana kukituma kwa barua pepe, chaguo hili halijawezeshwa.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Anwani ya barua pepe kwa mtumiaji huyu ni batili, chaguo hili halijawezeshwa.',
        'Sending' => 'Tuma',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => 'Pakua faili',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Kosa: Data auni hazikuweza kukusanywa (%s).',
        'Details' => 'Undani',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Mfumo wa Usimamizi wa anuani za barua pepe',
        'Add System Email Address' => 'Ongeza Anuani ya barua pepe ya mfumo',
        'Edit System Email Address' => 'Hariri Anuani ya Barua pepe ya Mfumo',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Barua pepe zote zinazoingia zenye hii anuani kwenye kutoka au Cc zitatumwa kwenye foleni iliyochaguliwa. ',
        'Email address' => 'Anuani ya barua pepe',
        'Display name' => 'Jina la kuonyesha',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Jina la kuonyesha na Anuani ya barua pepe zitaonyeshwa kwenye barua pepe unayotuma',
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
        'by' => 'Kwa',
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
        'Category' => 'Kategoria',
        'Run search' => 'Tafuta',

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
        'System Maintenance Management' => 'Usimamizi wa marekebisho ya mfumo',
        'Schedule New System Maintenance' => 'Panga ratiba ya matengenezo ya mfumo mapya',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Panga ratiba ya muda wa  matengenezo ya mfumo kwa kuwatangazia mawakala na wateja kuwa mfumo utakuwa chini kwa kipindi cha muda.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Muda flani kabla matengenezo ya mfumo hayajaanza watumiaji watapata taarifa kwenye kila skrini kuhusiana na jambo hili.',
        'Stop date' => 'Tarehe ya kusitisha',
        'Delete System Maintenance' => 'Futa matengenezo ya mfumo',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Tarehe batili',
        'Login message' => 'Ujumbe wa kuingia',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Onyesha ujumbe wa kuingia',
        'Notify message' => 'Ujumbe wa kutaarifu',
        'Manage Sessions' => 'Simamia vipindi',
        'All Sessions' => 'Vipindi vyote',
        'Agent Sessions' => 'Vipindi vya wakala',
        'Customer Sessions' => 'Vipindi vya mteja',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Ongeza kielezo',
        'Edit Template' => 'Hariri kielezo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Kielezo ni matini chaguo msingi mabayo yanawasaidia mawakala wako kuandika haraka tuketi, kujibu na kupeleka mbele.',
        'Don\'t forget to add new templates to queues.' => 'Usisahau kuongeza vielezo vipya katika foleni.',
        'Attachments' => 'Viambatanisho',
        'Delete this entry' => 'Futa ingizo hili',
        'Do you really want to delete this template?' => 'Kweli uanataka kufuta hiki kiolezo?',
        'A standard template with this name already exists!' => 'Kielezo cha kawaida kwa jina hili tayari kipo!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Tengeneza aina ya violezo kwa kusaidia tu lebo maizi.',
        'Example template' => 'Kielezo cha mfano',
        'The current ticket state is' => 'Hali ya tiketi ya sasa ni',
        'Your email address is' => 'Anuani yako ya barua pepe ni',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Geuza kuwa amilifi kwa wote',
        'Link %s to selected %s' => 'Unganisha %s kwa %s iliyochaguliwa',

        # Template: AdminType
        'Type Management' => 'Usimamizi wa aina',
        'Add Type' => 'Ongeza aina',
        'Edit Type' => 'Hariri aina',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Aina yenye jina hili tayari ipo!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Usimamizi wa wakala',
        'Edit Agent' => 'Hariri wakala',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Mawakala watahitajika kumud tiketi.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Usisahau kuongeza wakaal mpya kwenye vikundi na/au majukumu.',
        'Please enter a search term to look for agents.' => 'Tafadhali ingiza neno la kutafuta kuwatafuta mawakala.',
        'Last login' => 'Mwingio wa mwisho',
        'Switch to agent' => 'Badili kwa wakala',
        'Title or salutation' => '',
        'Firstname' => 'Jina la kwanza',
        'Lastname' => 'Jina la mwisho',
        'A user with this username already exists!' => 'Mtumiaji kwa jina hili la utumiaji tayari yupo!',
        'Will be auto-generated if left empty.' => 'Itazalisha otomatikali kama ikiachwa wazi.',
        'Mobile' => 'Simu ya mkononi',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Simamia mahusiano ya Wakala-Kikundi',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Leo',
        'All-day' => 'Siku nzima',
        'Repeat' => '',
        'Notification' => 'Taarifa',
        'Yes' => 'Ndio',
        'No' => 'Hapana',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Tarehe batili!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'Siku',
        'week(s)' => 'Wiki',
        'month(s)' => '(Mi)Mwezi',
        'year(s)' => '(Mi)Mwaka',
        'On' => 'Washa',
        'Monday' => 'Jumatatu',
        'Mon' => 'Jumatatu',
        'Tuesday' => 'Jumanne',
        'Tue' => 'Jumanne',
        'Wednesday' => 'Jumatano',
        'Wed' => 'Jumatano',
        'Thursday' => 'Alhamisi',
        'Thu' => 'Alhamisi',
        'Friday' => 'Ijumaa',
        'Fri' => 'Ijumaa',
        'Saturday' => 'Jumamosi',
        'Sat' => 'Jumamosi',
        'Sunday' => 'Jumapili',
        'Sun' => 'Jumapili',
        'January' => 'Januari',
        'Jan' => 'Jan',
        'February' => 'Februari',
        'Feb' => 'Feb',
        'March' => 'Machi',
        'Mar' => 'Machi',
        'April' => 'Aprili',
        'Apr' => 'Aprili',
        'May_long' => 'Mei',
        'May' => 'Mei',
        'June' => 'Juni',
        'Jun' => 'Jun',
        'July' => 'Julai',
        'Jul' => 'Julai',
        'August' => 'Agosti',
        'Aug' => 'Agosti',
        'September' => 'Septemba',
        'Sep' => 'Sep',
        'October' => 'Oktoba',
        'Oct' => 'Okt',
        'November' => 'Novemba',
        'Nov' => 'Nov',
        'December' => 'Desemba',
        'Dec' => 'Des',
        'Relative point of time' => '',
        'Link' => 'Kiungo',
        'Remove entry' => 'Toa ingizo',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kituo cha habari cha mteja',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Mtumiaji wa mteja',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Kidokezo: Mteja ni batili!',
        'Start chat' => 'Anza maongezi',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Tafuta kielezo',
        'Create Template' => 'Tengeneza kielezo',
        'Create New' => 'Tenngeneza mpya',
        'Save changes in template' => 'Hifadhi mabadiliko kwenye kielezo',
        'Filters in use' => 'Chuja katika kutumia',
        'Additional filters' => 'Vichuja vilivyoongezwa',
        'Add another attribute' => 'Ongeza sifa nyingine',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Chagua zote',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Badili michaguo ya utafutaji',

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
        'Dashboard' => 'Dashibodi',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Kesho',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Anza',
        'none' => 'hakuna',

        # Template: AgentDashboardCalendarOverview
        'in' => 'Ndani',

        # Template: AgentDashboardCommon
        'Save settings' => 'Hifadhi mipangilio',
        'Close this widget' => '',
        'more' => 'aidi',
        'Available Columns' => 'Safu wima zilizopo',
        'Visible Columns (order by drag & drop)' => 'Safuwima zinazoonekana (kwa oda ya kokota na dondosha)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Fungua',
        'Closed' => 'Fungwa',
        '%s open ticket(s) of %s' => 'Tiketi %s zilizowazi kati ya %s',
        '%s closed ticket(s) of %s' => 'Tiketi %s i(z)liyofungwa kati ya %s ',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tiketi za kupanda',
        'Open tickets' => 'Fungua tketi',
        'Closed tickets' => 'Tiketi zilizofungwa',
        'All tickets' => 'Tiketi zote',
        'Archived tickets' => 'Tiketi zilizohifadhiwa',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Tiketi ya simu',
        'Email ticket' => 'Tiketi ya barua pepe',
        'New phone ticket from %s' => 'Tiketi mpya za simu kutoka %s',
        'New email ticket to %s' => 'Tiketi mpya ya barua pepe kwenda %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s inapatikana',
        'Please update now.' => 'Tafadhali sasisha sasa.',
        'Release Note' => 'Matini ya toleo',
        'Level' => 'Kiwango',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Imechapishwa %s zilizopita.',

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
            'Yaliyomo ya takwimu hizi imeandaliwa kwa ajili yako, tafadhali kuwa na subira.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Tiketi zangu zilizofungwa',
        'My watched tickets' => 'Tiketi zangu zinazoangaliwa',
        'My responsibilities' => 'Majukumu yangu',
        'Tickets in My Queues' => 'Tiketi katika foleni yangu',
        'Tickets in My Services' => 'Tiketi zilizopo kwenye huduma',
        'Service Time' => 'Muda wa huduma',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Jumla',

        # Template: AgentDashboardUserOnline
        'out of office' => 'Nje ya office',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'Mpaka',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Nyuma',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Kukubali baadhi ya taarifa, lleseni au baadhi ya mabadiliko.',
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
        'Change password' => 'Badili neno la siri',
        'Current password' => 'Neno la siri la sasa',
        'New password' => 'Neno jipya la siri',
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
        'Edit your preferences' => 'Harir mapendeleo yako',
        'Personal Preferences' => '',
        'Preferences' => 'Pendekezo',
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
        'Off' => 'Zima',
        'End' => 'Mwisho',
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
        'Process' => 'Mchakato',
        'Split' => 'Gawanya',

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
        'Statistics' => 'Takwimu',
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
        'Created by' => 'Ilitengenezwa na',
        'Changed by' => 'Ilibadilishwa',
        'Sum rows' => 'Safu mlalo za jumla',
        'Sum columns' => 'Safu wima za jumla',
        'Show as dashboard widget' => 'Onyesha kifaa cha dashibodi',
        'Cache' => 'Hifadhi muda',
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
        'The ticket has been locked' => 'Tiketi imefungwa',
        'Undo & close' => '',
        'Ticket Settings' => 'Mipangilio ya tiketi',
        'Queue invalid.' => '',
        'Service invalid.' => 'HUduma batili.',
        'SLA invalid.' => '',
        'New Owner' => 'Mmiliki mpya.',
        'Please set a new owner!' => 'Tafadhali weka mmiliki mpya!',
        'Owner invalid.' => '',
        'New Responsible' => '',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Hali ijayo',
        'State invalid.' => '',
        'For all pending* states.' => '',
        'Add Article' => 'Ongeza makala',
        'Create an Article' => 'Tengeneza makala',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hapa unaweza kuchagua mawakala wa kuongezea ambao watapokea taarifa kuhusiana na makala mpya.',
        'Text will also be received by' => '',
        'Text Template' => 'Kielezo cha matini',
        'Setting a template will overwrite any text or attachment.' => 'Kuweka kiolezo kutaandika juu ya matini yoyote au kiambatisho.',
        'Invalid time!' => 'Muda batili!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Dunda kwenda ',
        'You need a email address.' => 'Unahitaji anwani ya barua pepe',
        'Need a valid email address or don\'t use a local email address.' =>
            'Unahitaji anwani halali ya barua pepe au usitumie anwani ya kawaida ya barua pepe.',
        'Next ticket state' => 'Hali ijayo ya tiketi.',
        'Inform sender' => 'Taarifu mtumaji.',
        'Send mail' => 'Tuma barua pepe',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Kitendo cha wingi cha tiketi.',
        'Send Email' => 'Tuma barua pepe',
        'Merge' => 'Ibuka',
        'Merge to' => 'Unganishwa kwa',
        'Invalid ticket identifier!' => 'Kitambulishi cha tiketi batili!',
        'Merge to oldest' => 'Unganishwa na kubwa kabisa',
        'Link together' => 'Unganisha pamoja',
        'Link to parent' => 'Unganisha na mzazi',
        'Unlock tickets' => 'Fungua tiketi',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Tafadhali ambatanisha mpokeaji japo mmoja',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Mtoe mteja wa tiketi',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Tafadhali toa ingizo hili na uweke jipya lenye thamani sahihi.',
        'This address already exists on the address list.' => 'Anwani hii tayari ipo katika orodha ya anwani',
        'Remove Cc' => 'Toa Cc.',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Toa Bcc',
        'Date Invalid!' => 'Tarehe batili',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'Taarifa za mteja',
        'Customer user' => 'Mtumiaji wa mteja',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Tengeneza tiketi ya barua pepe mpya',
        'Example Template' => 'Kiolezo cha mfano',
        'To customer user' => 'Kwenda kwa mtumiaji wa mteja',
        'Please include at least one customer user for the ticket.' => 'Tafadhali weka japo mtumiaji wa mteja mmoja kwa tiketi hii.',
        'Select this customer as the main customer.' => 'Chagua mteja huyu kama mteja mkuu.',
        'Remove Ticket Customer User' => 'Ondoa mtumiaji wa mteja wa tiketi',
        'From queue' => 'Kutoka kwenye foleni',
        'Get all' => 'Pata zote',

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
        'CreateTime' => 'Muda wa kutengeneza',
        'Article' => 'Makala',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Unahitaji kutumia namba ya tiketi',
        'A valid ticket number is required.' => 'Namba ya tiketi halali inatakiwa.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Anwani ya barua pepe halali inahitajika.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Foleni mpya',
        'Move' => 'Sogea',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Data za tiketi hazijapatikana',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Chagua tiketi hii',
        'Sender' => 'Mtumaji',
        'First Response Time' => 'Muda wa kwanza wa majibu',
        'Update Time' => 'Muda wa kusasisha',
        'Solution Time' => 'Muda wa ufumbuzi',
        'Move ticket to a different queue' => 'Hamisha tiketi kwenye foleni nyingine',
        'Change queue' => 'Badili foleni',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Ondoa kichuja amilifu kwa skrini hii.',
        'Tickets per page' => 'Tiketi kwa ukurasa',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Weka tena mapitio',
        'Column Filters Form' => 'Safu wima zinachujwa kutoka',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Gawanya kwenye tiketi za simu mpya',
        'Save Chat Into New Phone Ticket' => 'Hifadhi mazungumzo katika tiketi mpya ya simu',
        'Create New Phone Ticket' => 'Tengeneza tiketi mpya ya simu',
        'Please include at least one customer for the ticket.' => 'Tafadhali ambatanisha japo mteja mmoja kwa tiketi hii.',
        'To queue' => 'Kwenda kwenye foleni',
        'Chat protocol' => 'Itifaki ya mazungumzo',
        'The chat will be appended as a separate article.' => 'Mazungumzo yataambatishwa kama makala ya tofauti.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Wazi',
        'Download this email' => 'Pakua barua pepe hii',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Tengeneza tiketi mpya za mchakato',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Andikisha tiketi hii kuwa mchakato',

        # Template: AgentTicketSearch
        'Profile link' => 'Kiolesura cha maelezo mafupi',
        'Output' => 'Matokeo',
        'Fulltext' => 'Nakala yote',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Tengenezwa katika foleni',
        'Lock state' => 'Hali ya kufungwa',
        'Watcher' => 'Muangaliaji',
        'Article Create Time (before/after)' => 'Muda wa kutengeneza makala (Kabla/baada)',
        'Article Create Time (between)' => 'Muda wa kutengeneza makala (Kati ya)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Muda wa kutengeneza tiketi (Kabla/baada)',
        'Ticket Create Time (between)' => 'Muda wa kutengeneza tiketi (kati ya)',
        'Ticket Change Time (before/after)' => 'Muda wa kubadili tiketi (Kabla/baada)',
        'Ticket Change Time (between)' => 'Muda wa kubadili tiketi (kati ya)',
        'Ticket Last Change Time (before/after)' => 'Muda wa mwisho wa kubadili tiketi (kabla/baada)',
        'Ticket Last Change Time (between)' => 'Muda wa mwisho wa kubadili tiketi (kati ya)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Muda wa kufunga tiketi (kabla/baada)',
        'Ticket Close Time (between)' => 'Muda wa kufunga tiketi (kati ya)',
        'Ticket Escalation Time (before/after)' => 'Muda wa tiketi kupanda (baada/kabla)',
        'Ticket Escalation Time (between)' => 'Muda wa tiketi kupanda (kati ya)',
        'Archive Search' => 'Tafuta nyaraka',

        # Template: AgentTicketZoom
        'Sender Type' => 'Aina y amtumaji',
        'Save filter settings as default' => 'Hifadhi mipangilio ya kichuja kuwa chaguo-msingi',
        'Event Type' => 'Aina ya tukio',
        'Save as default' => 'Hifadhi kama chaguo-msingi',
        'Drafts' => '',
        'Change Queue' => 'Badili foleni',
        'There are no dialogs available at this point in the process.' =>
            'Hakuna mazungumzo yaliyopo katika hatua hii ya mchakato.',
        'This item has no articles yet.' => 'Kipengee hakina makala bado.',
        'Ticket Timeline View' => 'Mandhari ya kalenda ya matukio ya tiketi',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Ongeza kichuja',
        'Set' => 'Weka',
        'Reset Filter' => 'Weka tena kichuja',
        'No.' => 'Hapana.',
        'Unread articles' => 'Makala ambazo hazijasomwa',
        'Via' => '',
        'Important' => 'Muhimu',
        'Unread Article!' => 'Makala ambayo haijasomwa!',
        'Incoming message' => 'Ujumbe unaoingia',
        'Outgoing message' => 'Ujumbe unaotoka',
        'Internal message' => 'Ujumbe wa ndani',
        'Sending of this message has failed.' => '',
        'Resize' => 'Badilisha ukubwa',
        'Mark this article as read' => 'Weka alama kwa makala hii kama imeshasomwa.',
        'Show Full Text' => 'Onyesha nakala yote',
        'Full Article Text' => 'Nakala ya makala yote',
        'No more events found. Please try changing the filter settings.' =>
            'Hakuna matukio yaliyopatikana.Tafadhali jaribu kubadilisha mipangilio ya kuchuja.',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => 'Funga ujumbe huu',
        'Image' => '',
        'PDF' => 'PDF',
        'Unknown' => 'Haijulikani',
        'View' => 'Angalia',

        # Template: LinkTable
        'Linked Objects' => 'Vipengele vilivyounganishwa',

        # Template: TicketInformation
        'Archive' => 'Nyaraka',
        'This ticket is archived.' => 'Tiketi hii imewekwa kwenye nyaraka',
        'Note: Type is invalid!' => '',
        'Pending till' => 'Inasubiri hadi',
        'Locked' => 'Fungwa',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Muda wa kuhesabu',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Kulinda faragha yako,  yaliyomo ya mbali yamezuiliwa.',
        'Load blocked content.' => 'Pakia yaliyomo yaliyozuiliwa.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Unaweza',
        'go back to the previous page' => 'Rudi nyuma kwenye ukurasa uliopita',

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
        'New Ticket' => 'Tiketi mpya',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Makosa kwa undani',
        'Traceback' => 'Tafuta Nyuma',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript haipatikani',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Onyo la kivinjari',
        'The browser you are using is too old.' => 'Kivinjari unachotumia ni cha zamani sana.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Tafadhali angalia nyaraka au muulize kiongozi wako kwa taarifa zaidi.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'Tafadhali subiri kidogo, unaelekezwa....',
        'Login' => 'Ingia',
        'Your user name' => 'Jina lako lamtumiaji',
        'User name' => 'Jina la mtumiaji',
        'Your password' => 'Neno lako la siri',
        'Forgot password?' => 'Umesahau neno la siri?',
        'Your 2 Factor Token' => '',
        '2 Factor Token' => '',
        'Log In' => 'Ingia',
        'Request Account' => '',
        'Request New Password' => 'Ombi la neno jipya la siri',
        'Your User Name' => 'Jina lako la mtumiaji',
        'A new password will be sent to your email address.' => 'Neno jipya la siri litatumwa kwenye anwani yako ya barua pepe',
        'Create Account' => 'Tengeneza akaunti',
        'Please fill out this form to receive login credentials.' => 'Tafadhali jaza fomu hii kupokea hati za utambulisho za kuingia.',
        'How we should address you' => 'Jinsi tutakavyokutambulisha',
        'Your First Name' => 'Jina lako la kwanza',
        'Your Last Name' => 'Jina lako la mwisho',
        'Your email address (this will become your username)' => 'Anwani yako ya barua pepe (Hii itakuwa jina lako la utumiaji )',

        # Template: CustomerNavigationBar
        'Logout' => 'Toka',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Karibu ',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Kubaliano la kiwango cha huduma',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Ukurasa',
        'Tickets' => 'Tiketi',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Maelezo mafupi',
        'e. g. 10*5155 or 105658*' => 'Mfano 10*5155 au 105658',
        'CustomerID' => 'Kitambilisho cha mteja',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Aina',
        'Time Restrictions' => '',
        'No time settings' => 'Hakuna mipangilio ya muda',
        'All' => 'Yote',
        'Specific date' => 'Tarehe maalum',
        'Only tickets created' => 'Tiketi zilizotengenezwa tu',
        'Date range' => 'tarehe mbalimbali',
        'Only tickets created between' => 'Tiketi zilizotengenezwa kati ya',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Hifadhi kama kielezo?',
        'Save as Template' => 'Hifadhi kama kielezo',
        'Template Name' => 'Jina la kielezo',
        'Pick a profile name' => 'Chagua jina la umbo',
        'Output to' => 'Matokeo ya ',

        # Template: CustomerTicketSearchResultShort
        'of' => 'Ya',
        'Search Results for' => 'Majibu ya kutafuka kwa',
        'Remove this Search Term.' => 'Ondoa hii neno la kutafuta',

        # Template: CustomerTicketZoom
        'Reply' => 'Jibu',
        'Discard' => '',
        'Ticket Information' => 'Taarifa za tiketi',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => 'Panua makal',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Onyo',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Taarifa kuhusu tukio',
        'Ticket fields' => 'Uga wa tiketi',

        # Template: Error
        'Send a bugreport' => 'Tuma repoti yenye makosa',
        'Expand' => 'Panua',

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
        'Edit personal preferences' => 'Hariri mapendeleo binafsi',
        'Personal preferences' => '',
        'You are logged in as' => 'Umeingia kama',

        # Template: Installer
        'JavaScript not available' => 'JavaScript haipatikani',
        'Step %s' => 'Hatua %s',
        'License' => 'Leseni',
        'Database Settings' => 'Mipangilio ya hifadhi data',
        'General Specifications and Mail Settings' => 'Ubainishi wa jumla na mipangilio ya barua pepe',
        'Finish' => 'Maliza',
        'Welcome to %s' => '',
        'Germany' => '',
        'Phone' => 'Simu',
        'Switzerland' => '',
        'Web site' => 'Tovuti',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Sanidi barua pepe ya iliyofungwa nje',
        'Outbound mail type' => 'Aina ya barua pepe iliyofungwa nje',
        'Select outbound mail type.' => 'Chagua aina ya barua pepe iliyofungwa nje',
        'Outbound mail port' => 'Kituo tarishi cha barua pepe zilizofungwa nje',
        'Select outbound mail port.' => 'Chagua kituo tarishi cha barua pepe zilifungwa nje.',
        'SMTP host' => 'Mwenyeji wa SMTP',
        'SMTP host.' => 'Mwenyeji WA SMTP',
        'SMTP authentication' => 'Uthibitisho wa SMTP',
        'Does your SMTP host need authentication?' => 'Mwenyeji wako wa SMTP anahitaji uthibitisho?',
        'SMTP auth user' => 'Mtumiaji wa uthibitisho wa SMTP',
        'Username for SMTP auth.' => 'Jina la mtumiaji kwa ajjili ya uthibitisho wa SMTP ',
        'SMTP auth password' => 'Neno la siri la uthibitisho wa SMTP',
        'Password for SMTP auth.' => 'Neno la siri kwa ajili la uthibitisho wa SMTP',
        'Configure Inbound Mail' => 'Sanidi barua pepe za ndani',
        'Inbound mail type' => 'Aina za barua pepe za ndani',
        'Select inbound mail type.' => 'Chagua aina ya barua pepe za ndani',
        'Inbound mail host' => 'Mwenyeji wa barua pepe za ndani',
        'Inbound mail host.' => 'Mwenyeji wa barua  pepe za ndani.',
        'Inbound mail user' => 'Mtumiaji wa barua pepe za ndani',
        'User for inbound mail.' => 'Mtumiaji kwa ajili ya barua pepe za ndani.',
        'Inbound mail password' => 'Neno la siri barua pepe zilifungwa ndani',
        'Password for inbound mail.' => 'Neno la siri kwa ajili barua pepe zilifungwa ndani.',
        'Result of mail configuration check' => 'Matokeo ya maangalizi usanidi wa barua pepe',
        'Check mail configuration' => 'Angalia usanidi wa barua pepe',
        'Skip this step' => 'Ruka hatua hii',

        # Template: InstallerDBResult
        'Done' => 'Maliza',
        'Error' => 'Kasoro',
        'Database setup successful!' => 'Usanidi wa hifadhi data umefanikiwa!',

        # Template: InstallerDBStart
        'Install Type' => 'Sakinisha aina',
        'Create a new database for OTOBO' => 'Tengeneza hifadhi data mpya kwa ajili ya OTOBO',
        'Use an existing database for OTOBO' => 'Tumia hifadhi data iliyopo kwa ajili ya OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Kama umeweka neno la  siri shina kwa ajili ya hifadhi data, lazima liingizwe hapa. Kama sio, acha uga huu wazi.',
        'Database name' => 'Jina la hifadhi data',
        'Check database settings' => 'Angalia mipangilio ya hifadhi data',
        'Result of database check' => 'Matokeo ya maangilio ya hifadhi data',
        'Database check successful.' => 'Uangalizi wa hifadhi data umeefanikiwa.',
        'Database User' => 'Mtumiaji wa hifadhi data',
        'New' => 'Mpya',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Mtumiaji mpya wa hifadhi data wenye ruhusa kidogo watangenezwa katika mfumo huu wa OTOBO.',
        'Repeat Password' => 'Rudia neno la siri',
        'Generated password' => 'Neno la siri lilitongenezwa',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Maneno ya siri hayafanani',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Kuweza kutumia OTOBO ingiza mistari ifuatayo katika tungo amri yako kama mzizi.(Terminal/Shell) ',
        'Restart your webserver' => 'Washa upya seva ya tovuti',
        'After doing so your OTOBO is up and running.' => 'Baada ya kufanya hivyo OTOBO  itafanya kazi.',
        'Start page' => 'Ukurusa wa kuanza',
        'Your OTOBO Team' => 'Timu yako ya OTOBO',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Usikubali leseni',
        'Accept license and continue' => 'Kubali leseni na endelea',

        # Template: InstallerSystem
        'SystemID' => 'Kitambulisho cha Mfumo',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Kitambulishi cha mfumo. Kila namba ya tiketi na kila kitambulisho cha kipindi cha HTTP kina namba hii.',
        'System FQDN' => 'Mfumo FQDN',
        'Fully qualified domain name of your system.' => 'Jina la kikoa lilifudhu kamili la mfumo wako.',
        'AdminEmail' => 'Barua pepe ya kiongozi',
        'Email address of the system administrator.' => 'Barua pepe ya kiongozi wa mfumo.',
        'Organization' => 'Shirika',
        'Log' => 'Batli',
        'LogModule' => 'Moduli ya batli',
        'Log backend to use.' => 'Batli mazingira ya nyuma kutumia.',
        'LogFile' => 'Batli faili',
        'Webfrontend' => 'Mazingira ya mbele ya tovuti.',
        'Default language' => 'Lugha ya chaguo-msingi',
        'Default language.' => 'Lugha ya chaguo-msingi.',
        'CheckMXRecord' => 'Angalia rekodi ya MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Anwani za barua pepe ambazo zinaingizwa kwa mkono zinaangaliwa dhidi ya rekodi za MX zilizopatikana kwenye DNS. Usitumie chaguo hili kama DNS yako ipo taratibu au haitatui anwani za umma.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Kipengee#',
        'Add links' => 'Ongeza viungo',
        'Delete links' => 'Futa viungo',

        # Template: Login
        'Lost your password?' => 'Umepoteza neno lako la siri?',
        'Back to login' => 'Rudi kwenye kuingia',

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
        'Message of the Day' => 'Ujumbe wa siku',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Haki zisizotosha',
        'Back to the previous page' => 'Nyuma kwenye ukurasa uliopita',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Imewezeshwa na',

        # Template: Pagination
        'Show first page' => 'Onyesha ukurasa wa kwanza',
        'Show previous pages' => 'Onyesha kurasa zilizopita',
        'Show page %s' => 'Onyesha ukurasa %s',
        'Show next pages' => 'Onyesha kurasa zifuatazo',
        'Show last page' => 'Onyesha ukurasa wa mwisho',

        # Template: PictureUpload
        'Need FormID!' => 'Kitambulisho cha fomu kinahitajika!',
        'No file found!' => 'Hakuna faili lilipatikana',
        'The file is not an image that can be shown inline!' => 'Faili sio taswira ambayo inaweza kuonyeshwa ndani ya mstari.',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => 'Taarifa za mchakato',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Mtaarifu wakala',

        # Template: PublicDefault
        'Welcome' => '',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Ruhusa ',
        'You can select one or more groups to define access for different agents.' =>
            'Unaweza kuchagua kikundi kimoja na zaidi kuwapa ufikivu kwa mawakala mbalimbali.',
        'Result formats' => '',
        'Time Zone' => 'Majira ya saa',
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
            'Onyesha takwimu kama kifaa ambacho mawakala wanaweza kuamilisha dashibodi zao.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Kama imewekwa batili mtumiaji wa mwisho hawezi kutengeneza takwimu.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'Jira X',
        'Configure Y-Axis' => '',
        'Y-axis' => '',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Tafadhali chagua elementi moja tu au zina kibonye cha \'Pachikwa\'.',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Mpangilio',
        'Exchange Axis' => 'Jira ya kubadilishana',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Hakuna elementi iliyochaguliwa',
        'Scale' => 'Mzani',
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
        'OTOBO Test Page' => 'Ukurasa wa majaribio wa OTOBO',
        'Unlock' => 'fungua',
        'Welcome %s %s' => '',
        'Counter' => 'Kiesabuji',

        # Template: Warning
        'Go back to the previous page' => 'Rudi nyuma kwenye ukurasa uliopita',

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
        'Finished' => 'Maliza',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Ongeza ingizo jipya',

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
        'CustomerIDs' => 'Vitambulisho vya mteja',
        'Fax' => 'Faksi',
        'Street' => 'Mtaa',
        'Zip' => 'Posta',
        'City' => 'Mji',
        'Country' => 'Nchi',
        'Mr.' => 'Bwana',
        'Mrs.' => 'Bibi',
        'Address' => 'Anwani',
        'View system log messages.' => 'Angalia ujumbe wa batli ya mfumo.',
        'Edit the system configuration settings.' => 'Hakiki mipangilio ya usanidishaji wa mfumo. ',
        'Update and extend your system with software packages.' => 'Sasisha na panua mfumo wako kwa vifurushi vya programu.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Taarifa za ACL kutoka kwenye kihifadhi data hazilandani na mfumo uliosanidishwa, tafadhali eneza kwneye ACL zote.',
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
        'Attachment added!' => 'Kiambatisho kimeongezwa!',

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
        'Failed' => 'Shindwa',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => 'Eua',
        'Info' => 'Taarifa',
        'Warn' => '',
        'days' => 'Siku',
        'day' => 'Siku',
        'hour' => 'Saa',
        'minute' => 'Dakika',
        'seconds' => 'Sekunde',
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
        'Customer company updated!' => 'Kampuni ya mteja imesasishwa!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => 'Kampuni ya mteja imeongezwa!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Mteja amesasishwa!',
        'New phone ticket' => 'Tiketi mpy ya simu',
        'New email ticket' => 'Tiketi mpya ya barua pepe ',
        'Customer %s added' => 'Mteja %s ameongezwa',
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
        'minute(s)' => 'Dakika',
        'hour(s)' => '(Ma)Saa',
        'Time unit' => 'Kizio cha Muda',
        'within the last ...' => 'Ndani ya mwisho...',
        'within the next ...' => 'Ndani ya inayofuata...',
        'more than ... ago' => 'Zaidi ya...Iliyopita',
        'Unarchived tickets' => 'Tiketi ambazo hazijahifadhiwa',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'Kupanda',
        'descending' => 'Kushuka',

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
        '10 minutes' => 'Dakika 10',
        '15 minutes' => 'Dakika 15',
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
        'OTOBO as provider' => 'OTOBO kama mtoaji',
        'Operations' => 'Operesheni',
        'OTOBO as requester' => 'OTOBO kama  muombaji',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Kikundi kimesasishwa',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Akaunti ya barua pepe imeongezwa!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Tuma kwa barua pepe kwenda: uga.',
        'Dispatching by selected Queue.' => 'Tuma kwa foleni iliyochaguliwa.',

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
        'Priority added!' => 'Kipaumbele kimeongezwa!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Habari za usimamizi wa mchakato kutoka kwenye hifadhi data hazilandani na  mfumo uliosanidishwa, tafadhali landanisha michakato yote.',
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
        'Queue updated!' => 'Foleni imesasishwa!',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-hakuna-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Badili mahusiano ya foleni kwa ajili ya kielezo',
        'Change Template Relations for Queue' => 'Badili mahusiano ya foleni kwa ajili ya foleni',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Uzalishaji',
        'Test' => '',
        'Training' => 'Mafunzo',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Jukumu limesasishwa!',
        'Role added!' => 'Jukumu limeongezwa!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Badili mahusiano ya kikundi kwa jukumu',
        'Change Role Relations for Group' => 'Badilisha mahusiano ya jukumu kwa kikundi',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Badili mahusiano ya jukumu kwa wakala',
        'Change Agent Relations for Role' => 'Badili mahusiano ya wakala kwa jukumu',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Tafadhani amilisha %s kwanza!',

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
        'Signature updated!' => 'Saini imeisasishwa!',
        'Signature added!' => 'Saini imeongezwa',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Hali imeongezwa!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Barua pepe ya mfumo imeongezwa!',

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
        'Change Attachment Relations for Template' => 'Badili mahusiano ya kiambatanisho kwa kielezo',
        'Change Template Relations for Attachment' => 'Badili mahusiano ya kielezo kwa kielezo',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Aina imeongezwa!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Wakala amesasishwa',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Badili mahusiano ya kikundi kwa wakala',
        'Change Agent Relations for Group' => 'Badili mahusiano ya wakala kwa kikundi',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mwezi ',
        'Week' => '',
        'Day' => 'Siku',

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
        'Customer History' => '',

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
            'Samahani, unahitaji kuwa mmiliki wa tiketi kufanya kitendo hiki.',
        'Please change the owner first.' => 'Tafadhali badilisha mmiliki kwanza.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => '',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Mmiliki wa aliyepita!',
        'wrote' => 'Iliandika',
        'Message from' => 'Ujumbe wa maneno kutoka',
        'End message' => 'Mwisho wa Ujumbe wa maneno',

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
        'Address %s replaced with registered customer address.' => 'Anuani %s imebadilishwa na anuani ya mteja iliyosajiliwa',
        'Customer user automatically added in Cc.' => 'Mtumiaji wa mteja anaongezwa automatiki kwenye Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Tiketi "%s" zimetengenezwa!',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Wiki ijayo',
        'Ticket Escalation View' => 'Mandhari ya kupanda ya tiketi',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Peleka ujumbe wa maneno kutoka ',
        'End forwarded message' => 'Malizia ujumbe wa maneno uliotumwa',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Makala mpya',
        'Pending' => 'Inasubiri',
        'Reminder Reached' => 'Kikumbusho kimefika',
        'My Locked Tickets' => 'Tiketi zangu zilizofungwa',

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
        'Ticket locked.' => 'Tiketi imefungwa',

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
        'The selected process is invalid!' => 'Mchakato uliochaguliwa ipo batili.',
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
        'Pending Date' => 'Tarehe ya kusubiri',
        'for pending* states' => 'Kwa hali zinazosubiri',
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
        'Available tickets' => 'Tiketi zinazopatikana',
        'including subqueues' => '',
        'excluding subqueues' => '',
        'QueueView' => 'Angalia foleni',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Tiketi zangu zinazowajibika',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'Utafutaji wa mwisho',
        'Untitled' => '',
        'Ticket Number' => 'Namba ya tiketi',
        'Ticket' => 'Tiketi',
        'printed by' => 'Imechapishwa na ',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '',
        'Normal' => 'Kawaida',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => 'Ndani zaidi ya...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => '',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Angalia hali',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Tiketi zangu zilizoangaliwa',

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
        'Forward article via mail' => 'Peleka makala hii kwa barua pepe',
        'Forward' => 'Mbele',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Makala haiwezi kufunguliwa! Huenda ipo kwenye ukurasa mwingine wa makala.',
        'Show one article' => 'Onyesha makala moja',
        'Show all articles' => 'Onyesha makala zote',
        'Show Ticket Timeline View' => 'Onyesha mandhari ya kalenda ya matukio ya tiketi',

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
        'My Tickets' => 'Tiketi zangu',
        'Company Tickets' => 'Tiketi za kampuni',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '',
        'Created within the last' => 'Ilitengenezwa ndani ya ya mwisho',
        'Created more than ... ago' => 'Ilitengenezwa zaidi ya...iliyopita',
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
        'Install OTOBO' => 'Sakinisha OTOBO',
        'Intro' => 'Utangulizi',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Chaguo la hifadhi data',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Ingiza neno la siri kwa mtumiaji wa hifadhi data',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Ingiza neo la siri kwa mtumiaji wa utawala wa hifadhi data',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Tengeneza hifadhidata',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Mipangilio ya mfumo',
        'Syslog' => '',
        'Configure Mail' => 'Sanidi barua pepe',
        'Mail Configuration' => 'Usanidi wa barua pepe',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Hifadhi data ina data tayari-inatakiwa kuwa wazi!',
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
        'Chat' => 'Ongea',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Peleka makala kwenye anuani ya ujumbe nyingine',
        'Bounce' => 'Dunda',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Jibu wote',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Gawanya makala hii',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Umbizo la wazi',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Chapa makala hii',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Alama',
        'Unmark' => 'Toa alama',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Iliyosimbwa fiche',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Imesainiwa',
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
        'Sign' => 'Saini',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Onyeshwa',
        'Refresh (minutes)' => '',
        'off' => 'zima',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Onyesha watumiaji wa mteja',
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
        'Shown Tickets' => 'Onyesha tiketi',
        'Shown Columns' => 'Safuwima zilizoonyeshwa',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Takwimu za siku 7',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Kiwango',
        'The following tickets are not updated: %s.' => '',
        'h' => 'S',
        'm' => 'd',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Hii ni',
        'email' => 'barua pepe',
        'click here' => 'boya hapa',
        'to open it in a new window.' => 'Kuifungua kwenye window nyingine',
        'Year' => 'Mwakk',
        'Hours' => 'Masaa',
        'Minutes' => 'Dakika',
        'Check to activate this date' => 'Angalia kuamilisha tarehe hii',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Hakuna ruhusa',
        'No Permission' => '',
        'Show Tree Selection' => 'Onyesha chaguo la mti',
        'Split Quote' => 'Gawanya nukuu',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',
        'Linked' => 'Imeunganishwa',
        'Bulk' => 'Kwa wingi',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Nyepesi',
        'Unread article(s) available' => 'Makala ambayo hayajasomwa yanapatikana',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Wakala wa matandaoni: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Kuna tiketi zaidi zinazopanda! ',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Mteja wa mtandaoni: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => '',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Nje ya ofisi imewezeshwa, ungependa kuikatisha?',

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
        'Preferences updated successfully!' => 'Mapendeleo yamefanikiwa kusasishwa!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Hakiki neno la siri',
        'The current password is not correct. Please try again!' => 'Neno la siri la sasa haliko sahihi. Tafadhali jaribu tena!',
        'Please supply your new password!' => '',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Neno la siri haliwezi kusasishwa, Lazima liwe na japo herufi %s!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Neno la siri haliwezi kusasishwa, lazima liwe na japo tarakimu 1!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'isiyo halali',
        'valid' => 'Halali',
        'No (not supported)' => 'Hapana (Haina usaidizi)',
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
        'second(s)' => 'sekunde',
        'quarter(s)' => '',
        'half-year(s)' => '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Maudhui',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Fungua kuirudisha kwenye foleni',
        'Lock it to work on it' => 'Ifunge ufanyenayo kazi',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Usiangalie',
        'Remove from list of watched tickets' => 'Ondoa kwenye orodha ya tiketi zilizoangaliwa',
        'Watch' => 'Angalia',
        'Add to list of watched tickets' => 'Ongeza kwenye orodha ya tiketi zilizoangaliwa',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Panga kwa',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Funga tiketi mpya',
        'Locked Tickets Reminder Reached' => 'Ukumbusho wa tiketi zilizofungwa umefika',
        'Locked Tickets Total' => 'Jumla ya tiketi zilizofungwa',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Tiketi mpya zinazowajibika',
        'Responsible Tickets Reminder Reached' => 'Ukumbusho wa tiketi zinazowajibika umefika',
        'Responsible Tickets Total' => 'Jumla ya tiketi zinazowajibika',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Mpya ya tiketi zinazoangaliwa',
        'Watched Tickets Reminder Reached' => 'Ukumbusho wa tiketi zinazoangaliwa umefika',
        'Watched Tickets Total' => 'Jumla ya tiketi zinazoangaliwa',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Uga wenye nguvu wa tiketi',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Kwa sasa huwezi kuingia kwa sababu ya matengenezo ya mfumo.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => 'Upeo wa kipindi umefikiwa.Tafadhali jaribu tena baadae.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Kipindi batili. Tafadhani ingia tena.',
        'Session has timed out. Please log in again.' => 'Muda wa kipindi umeisha.Tafadhali jaribu tena baadae',

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
        'before/after' => 'kabla/baada',
        'between' => 'katikati',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Uga huu unahitajika au',
        'The field content is too long!' => 'Yaliyomo katika uga ni mengi sana!',
        'Maximum size is %s characters.' => 'Upeo wa juu wa ukubwa ni % miundo.',

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
        'installed' => 'Iliyosakinishwa',
        'Unable to parse repository index document.' => 'Imeshindwa kuchanganua hati ya kielezo cha hifadhi.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Hakuna vifurushi kwa ajili ya toleo la mfumo wako uliokutwa katika hifadhi hii, ina vifurushi kwa ajili ya matoleo mengine ya mfumo.',
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
        'Inactive' => 'Isiyo amilifu',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Huwezi kuwasiliana na seva ya usajili. Tafadhali jaribu tena baadae.',
        'No content received from registration server. Please try again later.' =>
            'Hakuna maudhui yaliyopokelewa kutoka kwenye seva ya usajili. Tafadhali jaribu tena baadae.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Jina la mtumiaji na neno la siri haviendani. Tafadhali jaribu tena.',
        'Problems processing server result. Please try again later.' => 'Matatizo katika kushughulikia majibu ya seva.Tafadhali jaribu tena baadae.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Jumla',
        'week' => 'Wiki',
        'quarter' => '',
        'half-year' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Kipaumbele kilichotengenezwa',
        'Created State' => 'Hali iliyotengenezwa',
        'Create Time' => 'Muda wa kutengeneza',
        'Pending until time' => '',
        'Close Time' => 'Muda wa kufunga',
        'Escalation' => 'Kupanda',
        'Escalation - First Response Time' => 'Kupanda - Muda wa kwanza wa kujibu',
        'Escalation - Update Time' => 'Kupanda - Rekebisha Muda',
        'Escalation - Solution Time' => 'Kupanda - Muda wa Suluhu',
        'Agent/Owner' => 'Wakala/Mmiliki',
        'Created by Agent/Owner' => 'Wakala/ Mmiliki aliyetengenezwa',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Tathiminishwa na',
        'Ticket/Article Accounted Time' => 'Muda uliohusika wa tiketi/makala',
        'Ticket Create Time' => 'Muda wa kutengeneza tiketi',
        'Ticket Close Time' => 'Muda wa kufunga tiketi',
        'Accounted time by Agent' => 'Muda una',
        'Total Time' => 'Jumla ya muda',
        'Ticket Average' => 'Wastani wa tiketi',
        'Ticket Min Time' => 'Kiwango cha chini cha muda ',
        'Ticket Max Time' => 'Kiwango cha juu cha muda',
        'Number of Tickets' => 'Namba ya tiketi',
        'Article Average' => 'Wastani wa makala',
        'Article Min Time' => 'Kiwango cha chini cha muda cha makala',
        'Article Max Time' => 'Kiwango cha juu cha muda cha makala',
        'Number of Articles' => 'Namba ya makala',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Viumbi vitachapishwa',
        'Sort sequence' => 'Panga mfuatano ',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Namba',
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
        'Days' => 'Siku',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Uwepo wa meza',
        'Internal Error: Could not open file.' => 'Kosa la ndani: Haikuweza kufungua faili',
        'Table Check' => 'Angalia meza',
        'Internal Error: Could not read file.' => 'Kosa la ndani: Haikuweza kusoma faili.',
        'Tables found which are not present in the database.' => 'Meza zilizopatikana hazipo kwenye hifadhi data',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Ukubwa wa hifadhi data',
        'Could not determine database size.' => 'haikuweza kutambua ukubwa wa hifadhi data',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Toleo la hifadhi data',
        'Could not determine database version.' => 'Haikuweza kutambua toleo la hifadhi data',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Seti ya herufi ya mahusiano ya mteja',
        'Setting character_set_client needs to be utf8.' => 'Mpangilio character_set_client nahitaji kuwa utf8.',
        'Server Database Charset' => 'Seti ya herufi ya hifadhi data ya seva',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Seti ya herufi ya jedwali',
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
        'Maximum Query Size' => 'Kiwango cha juu ukubwa wa ulizo',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Ukubwa wa hifadhi muda wa ulizo',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Mpangilio \'Ukubwa_wa hifadhi data_wa ulizo\' utumike ( kubwa zaidi ya MB 10 lakini sio zaidi ya MB 512).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Injini Chaguo msingi ya kuhifadhi ',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Meza zenye injini ya kuifadhi za tofauti na injini chaguo-msingi zimepatikana.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x au zaidi inahitajika.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Mipangilio ya NLS_LANG ',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => 'Mpangilio wa NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT lazima iwekwe kuwa \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Mpangilio wa NLS_DATE_FORMAT angalio la SQL',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Mpangilio client_encoding unahitaji kuwa UNICODE au UTF8',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Mpangilio server_encoding unahitaji kuwa UNICODE au UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Mpangilio wa tarehe',
        'Setting DateStyle needs to be ISO.' => 'Mpangilio DateStyle unahitaji kuwa ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Kitenga diski cha OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Matimizi ya diski',
        'The partition where OTOBO is located is almost full.' => 'Kitenga ambacho OTOBO imewekwa kinakaribia kujaa',
        'The partition where OTOBO is located has no disk space problems.' =>
            'Kitenga ambacho OTOBO imewekwa kina matatizo ya nafasi katika disk.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Matumizi ya vitenga diski',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Usambazaji',
        'Could not determine distribution.' => 'Haikuweza kutambua usambazaji.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Toleo la kiini',
        'Could not determine kernel version.' => 'Haikuweza kutambua aina ya kiini.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Pakia mfumo',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Kupakia mfumo unatakiwa kuwa na upeo wa juu wa namba za CPU ambazo mfumo unazo ( mfano. Mzigo wa 8 au chini ya mfumo kwa CPU nane ni sawa).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Moduli za Perl',
        'Not all required Perl modules are correctly installed.' => 'Sio kila moduli za perl zinesanidiwa kwa usahihi.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Nafasi ya kubadilishana ya bure (%)',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => 'Nafasi ya kubadilishana iliyotumika(MB)',
        'There should be more than 60% free swap space.' => 'Lazima kuna nafasi ya kubadilisha ya bure zaidi ya 60%.',
        'There should be no more than 200 MB swap space used.' => 'Hakuna zaidi ya MB 200 ya nafasi ilitumika ya kubadilishana.',

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
        'Config Settings' => 'Mipangilio ya kusanidi',
        'Could not determine value.' => 'Haikuweza kutambua thamani',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Rekodi ya hifadhi data',
        'Ticket History Entries' => 'Historia ya ingizo ya tiketi',
        'Articles' => 'Makala',
        'Attachments (DB, Without HTML)' => 'Viambatanisho (DB, bila ya HTML)',
        'Customers With At Least One Ticket' => 'Wateja wenye tiketi angalau zaidi ya moja',
        'Dynamic Field Values' => 'Thamani za uga zenye  nguvu',
        'Invalid Dynamic Fields' => 'Uga zenye nguvu batili',
        'Invalid Dynamic Field Values' => 'Thamani za uga wenye nguvu batili',
        'GenericInterface Webservices' => 'Huduma za wavuti za kiolesura cha jumla.',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Miezi kati ya tiketi ya kwanza na ya mwisho',
        'Tickets Per Month (avg)' => 'Tiketi za kila mwezi (wastani)',
        'Open Tickets' => 'Tiketi zilizo wazi',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Hatari ya usalama: Tumia mipangilio chaguo-msingi kwa SOAP:: Mtumiaji na SOAP::Neno la siri. Tafadhali badilisha.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Neno la siri chaguo-msingi la kiongozi',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Hatari y a usalama: Akaunti ya wakala root@locolhost bado lina neno la siri chaguo-msingi.Tafadhali libadilishe au batilisha akaunti.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => 'Jina la kikoa',
        'Your FQDN setting is invalid.' => 'Mipangilio yako ya FQDN ni batili.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Mfumo wa file unaandikika',
        'The file system on your OTOBO partition is not writable.' => 'Mfumo wa file katika kitenga chako cha OTOBO  hakiandikiki.',

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
        'Some packages are not correctly installed.' => 'kuna vifurishi havijasanikishwa kwa usahihi.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Orodha ya vifurushi',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Mipangilio ya kitambulisho chako cha mfumo ni batili, lazima iwe na namba tu.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Moduli ya kielezo cha tiketi',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Una zaidi ya tiketi 60,000 na mandharinyuma DBtuli. Angalia manyo ya kiongozi (kuboresha utendaji) kwa taarifa zaidi.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Usiwe na tiketi zilizowazi zaidi ya 8000 katika mfumo wako.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Rekodi zilizoachwa katika jedwali la Kielezo_Cha kufunga_Tiketi',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => 'Rekodi zilizoachwa katika jedwali la Kielezo_cha Tiketi.',
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
        'Webserver' => 'Seva ya tovuti',
        'Loaded Apache Modules' => 'Moduli za Apache zilizopakiwa',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Matumizi ya kichocheo cha CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Tumia FastCGI au mod_perl kuongeza uwezo wako.',
        'mod_deflate Usage' => 'Matumizi ya mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Tafadhali sanidi mod_deflate kuboresha kasi ya GUI.',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => 'Matumizi ya mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Tafadhali sanidi mod_deflate kuboresha kasi ya GUI.',
        'Apache::Reload Usage' => 'Apache::Pakia matumizi',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache:: Onesha upya au Apache 2:: Onesha upya itumike kama Moduli ya Perl na Per ya kuanzisha ya Kishiko kuzuia seva ya tovuti kuanza upya wakati wa usanidi na uboreshaji wa moduli.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Vishika nafsi vya mazingira',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Toleo la tovuti',
        'Could not determine webserver version.' => 'Haikuweza kutambua toleo la seva ya tovuti.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Watumiaji wa kwa pamoja',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'Sawa',
        'Problem' => 'Tatizo',

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
            'Kuingia kumeshindikana. Jina lako la mtumiaji au neno la siri lililoingizwa halikuwa sahihi.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'Kipengele hakipo amilifu.',
        'Sent password reset instructions. Please check your email.' => 'Maelezo ya kuweka upya neno la siri yametumwa. Tafadhali angalia barua pepe yako.',
        'Invalid Token!' => 'Tuzo batili!',
        'Sent new password to %s. Please check your email.' => 'Neno jipya la siri limetumwa kwa %s. Tafadhali angalia barua pepe yako.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Anwani ya barua pepe hii tayari ipo. Tafadhali ingia au weka upya neno lako la siri.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Anuani ya barua hii pepe hairuhusiwi kusajili. Tafadhali wasiliana na wafanyakazi wa msaada.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Akaunti mpya imetengenezwa. Taarifa za kuingia zimetumwa kwa %s. Tafadhali angalia barua pepe yako.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'isiyo halali kwa muda mfupi',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'mpya',
        'All new state types (default: viewable).' => '',
        'open' => 'fungua',
        'All open state types (default: viewable).' => '',
        'closed' => 'fungwa',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'Ukumbusho unaosuburia',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'Inasubiri kiautomatikali',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'ondolewa',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'liibuka',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'Ilifungwa kwa mafanikio',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'Ilifungwa bila mafanikio',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'Inasubiri kiautomatikali Kufunga',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'Funga otomatiki inasubiri-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'Inawezekana',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'Kataa',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'Jibu otomatiki',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'Kukataa otomatiki',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'Kufuatilia otomatiki',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'Jibu otomatiki/ tiketi mpya',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'Ondoa otomatiki',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 chini sana',
        '2 low' => '2 chini',
        '3 normal' => '3 kawaida',
        '4 high' => '4 juu',
        '5 very high' => '5 juu sana',
        'unlock' => 'fungua',
        'lock' => 'funga',
        'tmp_lock' => '',
        'agent' => 'wakala',
        'system' => 'mfumo',
        'customer' => 'mteja',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Taarifa ya muda wa kuisha wa kufunga tiketi',
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
        'Add all' => 'Ongeza zote',
        'An item with this name is already present.' => 'Kipengee kwa jina hili tayari kimeshaonyeshwa',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Hiki kipengee bado kina vipengee vidogo. Je unataka kuondoa kipengee hiki na vipengee vidogo',

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
            'Je unataka kufuta uga huu wenye nguvu? Data zote zinazohisika zitapotea!',
        'Delete field' => 'Futa uga',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Futa kichochezi cha tukio hili',
        'Duplicate event.' => 'Nakili tukio',
        'This event is already attached to the job, Please use a different one.' =>
            'Tukio hili tayari limeweambatanishwa na kazi, tafadhali tumia lingine.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Kosa limetokea wakati wa mawasiliano.',
        'Request Details' => 'Maelezo ya maombi',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Onyesha au ficha maudhui.',
        'Clear debug log' => 'Futa batli ya eua.',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Tufa kisababishi hiki',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Futa ufungu huu wa kuunganisha/kutengeneza ramani.',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Kufuta Operesheni hii',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Nakala idhinishe ya huduma ya tovuti',
        'Delete operation' => 'kufuta operesheni',
        'Delete invoker' => 'Tufa kisababishi ',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ONYO: Wakati unabadilisha jina la kikundi \'Kiongozi\', kabla ya kutengeneza mabadiliko sahihi katika usanidi wa mfumo, utafungiwa nje ya paneli ya uongozi! Kama hili likitokea, tafadhali kipe jina la zamani kikundi la kiongozi kwa kila kauli za SQL. ',

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
        'Remove Entity from canvas' => 'Ondoa kipengee halisi kutoka kwenye kanvasi.',
        'No TransitionActions assigned.' => 'Hakuna vitendo vya mpito vilivyogawiwa.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Hakuna Kidadisi kilochogaiwa. Chukua kikadisi shughuli kutoka kwenye orodha kushoto na ikokote hapa.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Shughuli haiwezi kufutwa kwasababu ni shughuli ya kuanza.',
        'Remove the Transition from this Process' => 'Ondoa mpito kutoka kwenye mchakato huu.',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Punde uonapo kibonye hiki au kiunganishi hiki, utaiacha skrini na hali yake ya sasa itahifadhiwa otomatiki. Je unataka kuendelea?',
        'Delete Entity' => 'Futa kipengee halisi',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Shuguli tayari imetumika katika mchakato. Huwezi kuongeza kwa mara ya pili.',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Mpito usiounganishwa tayari umefanyika katika kanvasi. Tafadhali unganisha mpito huu kwanza kabla haujaweka mpito mwingine.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Mpito huu umeshatumika katika shughuli hii. Huwezi kutumia mara mbili!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Kitendo cha mpito huu kimeshatumika katika njia hii. Huwezi kutumia mara mbili!',
        'Hide EntityIDs' => 'Ficha kitambulisho cha ingizo',
        'Edit Field Details' => 'Hariri maelezo ya uga',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Tuma Usasishaji...',
        'Support Data information was successfully sent.' => 'Wezesha taarifa za data imetumwa kwa mafanikio.',
        'Was not possible to send Support Data information.' => 'Haikuwezekana kutumwa kwa wezesha taarifa za data.',
        'Update Result' => 'Sasisha matokeo',
        'Generating...' => 'Tengeneza...',
        'It was not possible to generate the Support Bundle.' => 'Haikuwezekana kutengeneza kifurushi cha msaada.',
        'Generate Result' => 'Matokeo ya ujumla',
        'Support Bundle' => 'Kifurushi cha msaada',
        'The mail could not be sent' => 'Barua pepe haikuweza kutumwa',

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
        'Loading...' => 'Inapakia...',
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
            'Je unataka kufuta matengenezo haya ya mfumo yaliyokuwa kwenye ratika?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Iliyopita',
        'Resources' => '',
        'Su' => 'J2',
        'Mo' => 'J3',
        'Tu' => 'J4',
        'We' => 'J5',
        'Th' => 'Alh',
        'Fr' => 'Iju',
        'Sa' => 'Jmosi',
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
        'Duplicated entry' => 'Ingizo nakala pacha',
        'It is going to be deleted from the field, please try again.' => 'Itafutwa kutoka kwenye uga, tafadhali jaribu tena.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Tafadhali ingiza japo moja ya thamani ilitafutwa au * kutafuta yoyote.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Tafadhali angalia uga zote ziliizowekwa alama nyekundu kwa ajili ya maingizo batili.',
        'month' => 'Mwezi',
        'Remove active filters for this widget.' => 'Ondoa vichuja amilifu kwa hiki kifaa.',

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
        'Article filter' => 'Kichuja cha makala',
        'Apply' => 'Tekeleza',
        'Event Type Filter' => 'Kichuja cha aina ya tukio',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Telezesha mwambaa wa uabiri',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Tafadhali zima hali timizi tangamanifu ya kitafuta wavuti! ',

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
        'One or more errors occurred!' => 'Kosa moja au zaidi yametokea',

        # JS File: Core.Installer
        'Mail check successful.' => 'Barua pepe imeangaliwa kwa mafanikio',
        'Error in the mail settings. Please correct and try again.' => 'Kosa katika mipangilio ya barua pepe. Tafadhali rekebisha na jaribu tena.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Fungua chaguo la tarehe',
        'Invalid date (need a future date)!' => 'Tarehe batili (Tarehe ijayo inatakiwa)',
        'Invalid date (need a past date)!' => 'Tarehe batili (Tarehe ya zamani inahitajika)',

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
            'Kama unaondoka huu ukurasa, madirisha ibukizi  yote yaliyofunguliwa yatafungwa pia.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Kiibukizi katika skrini hii tayari imefunguliwa. Je unataka kufunga na kupakia hii hapa badala yake?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Haikuweza kufungua dirisha ibukizi.Tafadhali kataza vizuizi vya kiibukizi kwa programu-tumizi hii.',

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
        'There are currently no elements available to select from.' => 'Kwasasa hakuna elementi inayopatika kuchagua fomu.',

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
        'yes' => 'ndio',
        'no' => 'hapana',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Imewekwa kwenye makundi',
        'Stacked' => 'Ya omekezo',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Mfululizo',
        'Expanded' => 'Imepanuliwa',

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
