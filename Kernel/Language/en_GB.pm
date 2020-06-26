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

package Kernel::Language::en_GB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_Kingdom
    # day-month-year (e.g., "31/12/99")

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%T - %D/%M/%Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.618095238095238;

    # csv separator
    $Self->{Separator}         = ',';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL Management',
        'Actions' => 'Actions',
        'Create New ACL' => 'Create New ACL',
        'Deploy ACLs' => 'Deploy ACLs',
        'Export ACLs' => 'Export ACLs',
        'Filter for ACLs' => 'Filter for ACLs',
        'Just start typing to filter...' => 'Just start typing to filter...',
        'Configuration Import' => 'Configuration Import',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.',
        'This field is required.' => 'This field is required.',
        'Overwrite existing ACLs?' => 'Overwrite existing ACLs?',
        'Upload ACL configuration' => 'Upload ACL configuration',
        'Import ACL configuration(s)' => 'Import ACL configuration(s)',
        'Description' => 'Description',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Changes to the ACLs here only affect the behaviour of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.',
        'ACL name' => 'ACL name',
        'Comment' => 'Comment',
        'Validity' => 'Validity',
        'Export' => 'Export',
        'Copy' => 'Copy',
        'No data found.' => 'No data found.',
        'No matches found.' => 'No matches found.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Edit ACL %s',
        'Edit ACL' => '',
        'Go to overview' => 'Go to overview',
        'Delete ACL' => 'Delete ACL',
        'Delete Invalid ACL' => 'Delete Invalid ACL',
        'Match settings' => 'Match settings',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.',
        'Change settings' => 'Change settings',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Show or hide the content',
        'Edit ACL Information' => '',
        'Name' => 'Name',
        'Stop after match' => 'Stop after match',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Save',
        'or' => 'or',
        'Save and finish' => 'Save and finish',
        'Cancel' => 'Cancel',
        'Do you really want to delete this ACL?' => 'Do you really want to delete this ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.',

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
        'Overwrite existing entities' => 'Overwrite existing entities',
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
        'Group' => 'Group',
        'Changed' => 'Changed',
        'Created' => 'Created',
        'Download' => 'Download',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Calendar',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => 'Rule',
        'Remove this entry' => 'Remove this entry',
        'Remove' => 'Remove',
        'Start date' => 'Start date',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Queues',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Add entry',
        'Add' => 'Add',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Submit',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'Go back',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Upload',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Add Notification',
        'Edit Notification' => 'Edit Notification',
        'Export Notifications' => 'Export Notifications',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Overwrite existing notifications?',
        'Upload Notification configuration' => 'Upload Notification configuration',
        'Import Notification configuration' => 'Import Notification configuration',
        'List' => 'List',
        'Delete' => 'Delete',
        'Delete this notification' => 'Delete this notification',
        'Show in agent preferences' => 'Show in agent preferences',
        'Agent preferences tooltip' => 'Agent preferences tooltip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'This message will be shown on the agent preferences screen as a tooltip for this notification.',
        'Toggle this widget' => 'Toggle this widget',
        'Events' => 'Events',
        'Event' => 'Event',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Type',
        'Title' => 'Title',
        'Location' => 'Location',
        'Team' => '',
        'Resource' => '',
        'Recipients' => 'Recipients',
        'Send to' => 'Send to',
        'Send to these agents' => 'Send to these agents',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'Send to all role members',
        'Send on out of office' => 'Send on out of office',
        'Also send if the user is currently out of office.' => 'Also send if the user is currently out of office.',
        'Once per day' => 'Once per day',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => 'Notification Methods',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.',
        'Enable this notification method' => 'Enable this notification method',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'At least one method is needed per notification.',
        'Active by default in agent preferences' => 'Active by default in agent preferences',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.',
        'This feature is currently not available.' => 'This feature is currently not available.',
        'Upgrade to %s' => 'Upgrade to %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'No data found',
        'No notification method found.' => 'No notification method found.',
        'Notification Text' => 'Notification Text',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.',
        'Remove Notification Language' => 'Remove Notification Language',
        'Subject' => 'Subject',
        'Text' => 'Text',
        'Message body' => 'Message body',
        'Add new notification language' => 'Add new notification language',
        'Save Changes' => 'Save Changes',
        'Tag Reference' => 'Tag Reference',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'You can use the following tags',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => ' e. g.',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => 'Attributes of the recipient user for the notification',
        'Config options' => 'Config options',
        'Example notification' => 'Example notification',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Additional recipient email addresses',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'An article will be created if the notification is sent to the customer or an additional email address.',
        'Email template' => 'Email template',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Use this template to generate the complete email (only for HTML emails).',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'Attachment Management',
        'Add Attachment' => 'Add Attachment',
        'Edit Attachment' => 'Edit Attachment',
        'Filter for Attachments' => 'Filter for Attachments',
        'Filter for attachments' => '',
        'Filename' => 'Filename',
        'Download file' => 'Download file',
        'Delete this attachment' => 'Delete this attachment',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'Attachment',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Auto Response Management',
        'Add Auto Response' => 'Add Auto Response',
        'Edit Auto Response' => 'Edit Auto Response',
        'Filter for Auto Responses' => 'Filter for Auto Responses',
        'Filter for auto responses' => '',
        'Response' => 'Response',
        'Auto response from' => 'Auto response from',
        'Reference' => 'Reference',
        'To get the first 20 character of the subject.' => 'To get the first 20 character of the subject.',
        'To get the first 5 lines of the email.' => 'To get the first 5 lines of the email.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'To get the article attribute',
        'Options of the current customer user data' => 'Options of the current customer user data',
        'Ticket owner options' => 'Ticket owner options',
        'Ticket responsible options' => 'Ticket responsible options',
        'Options of the current user who requested this action' => 'Options of the current user who requested this action',
        'Options of the ticket data' => 'Options of the ticket data',
        'Options of ticket dynamic fields internal key values' => 'Options of ticket dynamic fields internal key values',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields',
        'Example response' => 'Example response',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud Service Management',
        'Support Data Collector' => 'Support Data Collector',
        'Support data collector' => 'Support data collector',
        'Hint' => 'Hint',
        'Currently support data is only shown in this system.' => 'Currently support data is only shown in this system.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Configuration',
        'Send support data' => 'Send support data',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Update',
        'System Registration' => 'System Registration',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Register this System',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'System Registration is disabled for your system. Please check your configuration.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Please note that the use of OTOBO cloud services requires the system to be registered.',
        'Register this system' => 'Register this system',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Here you can configure available cloud services that communicate securely with %s.',
        'Available Cloud Services' => 'Available Cloud Services',

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
        'Settings' => 'Settings',
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
        'Status' => 'Status',
        'Account' => '',
        'Edit' => 'Edit',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Direction',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Priority',
        'Module' => 'Module',
        'Information' => 'Information',
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
        'Contact with data' => 'Contact with data',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Back to search results',
        'Select' => 'Select',
        'Search' => 'Search',
        'Wildcards like \'*\' are allowed.' => 'Wildcards like \'*\' are allowed.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Valid',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Customer Management',
        'Add Customer' => 'Add Customer',
        'Edit Customer' => 'Edit Customer',
        'List (only %s shown - more available)' => 'List (only %s shown - more available)',
        'total' => 'total',
        'Please enter a search term to look for customers.' => 'Please enter a search term to look for customers.',
        'Customer ID' => 'Customer ID',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Manage Customer-Group Relations',
        'Notice' => 'Notice',
        'This feature is disabled!' => 'This feature is disabled!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Just use this feature if you want to define group permissions for customers.',
        'Enable it here!' => 'Enable it here!',
        'Edit Customer Default Groups' => 'Edit Customer Default Groups',
        'These groups are automatically assigned to all customers.' => 'These groups are automatically assigned to all customers.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Filter for Groups',
        'Select the customer:group permissions.' => 'Select the customer:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).',
        'Search Results' => 'Search Results',
        'Customers' => 'Customers',
        'Groups' => 'Groups',
        'Change Group Relations for Customer' => 'Change Group Relations for Customer',
        'Change Customer Relations for Group' => 'Change Customer Relations for Group',
        'Toggle %s Permission for all' => 'Toggle %s Permission for all',
        'Toggle %s permission for %s' => 'Toggle %s permission for %s',
        'Customer Default Groups:' => 'Customer Default Groups:',
        'No changes can be made to these groups.' => 'No changes can be made to these groups.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Read only access to the ticket in this group/queue.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Full read and write access to the tickets in this group/queue.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Customer User Management',
        'Add Customer User' => 'Add Customer User',
        'Edit Customer User' => 'Edit Customer User',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Customer user are needed to have a customer history and to login via customer panel.',
        'List (%s total)' => 'List (%s total)',
        'Username' => 'Username',
        'Email' => 'Email',
        'Last Login' => 'Last Login',
        'Login as' => 'Login as',
        'Switch to customer' => 'Switch to customer',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'This field is required and needs to be a valid email address.',
        'This email address is not allowed due to the system configuration.' =>
            'This email address is not allowed due to the system configuration.',
        'This email address failed MX check.' => 'This email address failed MX check.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS problem, please check your configuration and the error log.',
        'The syntax of this email address is incorrect.' => 'The syntax of this email address is incorrect.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Customer',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Customer Users',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Toggle active state for all',
        'Active' => 'Active',
        'Toggle active state for %s' => 'Toggle active state for %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Edit default services',
        'Filter for Services' => 'Filter for Services',
        'Filter for services' => '',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Dynamic Fields Management',
        'Add new field for object' => 'Add new field for object',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.',
        'Dynamic Fields List' => 'Dynamic Fields List',
        'Dynamic fields per page' => 'Dynamic fields per page',
        'Label' => 'Label',
        'Order' => 'Order',
        'Object' => 'Object',
        'Delete this field' => 'Delete this field',

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
        'Dynamic Fields' => 'Dynamic Fields',
        'Go back to overview' => 'Go back to overview',
        'General' => 'General',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'This field is required, and the value should be alphabetic and numeric characters only.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Must be unique and only accept alphabetic and numeric characters.',
        'Changing this value will require manual changes in the system.' =>
            'Changing this value will require manual changes in the system.',
        'This is the name to be shown on the screens where the field is active.' =>
            'This is the name to be shown on the screens where the field is active.',
        'Field order' => 'Field order',
        'This field is required and must be numeric.' => 'This field is required and must be numeric.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'This is the order in which this field will be shown on the screens where is active.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Field type',
        'Object type' => 'Object type',
        'Internal field' => 'Internal field',
        'This field is protected and can\'t be deleted.' => 'This field is protected and can\'t be deleted.',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Field Settings',
        'Default value' => 'Default value',
        'This is the default value for this field.' => 'This is the default value for this field.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Key',
        'Value' => 'Value',
        'Remove value' => 'Remove value',
        'Add Field' => '',
        'Add value' => 'Add value',
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
        'Translatable values' => 'Translatable values',
        'If you activate this option the values will be translated to the user defined language.' =>
            'If you activate this option the values will be translated to the user defined language.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'You need to add the translations manually into the language translation files.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Possible values',
        'Datatype' => '',
        'Filter' => 'Filter',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Show link',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.',
        'Example' => 'Example',
        'Link for preview' => 'Link for preview',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Port',
        'Table / View' => '',
        'User' => 'User',
        'Password' => 'Password',
        'Identifier' => 'Identifier',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Multiselect',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Default date difference',
        'This field must be numeric.' => 'This field must be numeric.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).',
        'Define years period' => 'Define years period',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.',
        'Years in the past' => 'Years in the past',
        'Years in the past to display (default: 5 years).' => 'Years in the past to display (default: 5 years).',
        'Years in the future' => 'Years in the future',
        'Years in the future to display (default: 5 years).' => 'Years in the future to display (default: 5 years).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => 'Restrict entering of dates',
        'Here you can restrict the entering of dates of tickets.' => 'Here you can restrict the entering of dates of tickets.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Add Value',
        'Add empty value' => 'Add empty value',
        'Activate this option to create an empty selectable value.' => 'Activate this option to create an empty selectable value.',
        'Tree View' => 'Tree View',
        'Activate this option to display values as a tree.' => 'Activate this option to display values as a tree.',

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
        'Fields' => 'Fields',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Overview',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Ordering the elements within the list is also possible by drag \'n\' drop.',
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
        'Reset' => 'Reset',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Number of rows',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Specify the height (in lines) for this field in the edit mode.',
        'Number of cols' => 'Number of cols',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Specify the width (in characters) for this field in the edit mode.',
        'Check RegEx' => 'Check RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Invalid RegEx',
        'Error Message' => 'Error Message',
        'Add RegEx' => 'Add RegEx',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Template',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Size',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'This field is required',
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
            'With this module, administrators can send messages to agents, group or role members.',
        'Create Administrative Message' => 'Create Administrative Message',
        'Your message was sent to' => 'Your message was sent to',
        'From' => 'From',
        'Send message to users' => 'Send message to users',
        'Send message to group members' => 'Send message to group members',
        'Group members need to have permission' => 'Group members need to have permission',
        'Send message to role members' => 'Send message to role members',
        'Also send to customers in groups' => 'Also send to customers in groups',
        'Body' => 'Body',
        'Send' => 'Send',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Last run',
        'Run Now!' => 'Run Now!',
        'Delete this task' => 'Delete this task',
        'Run this task' => 'Run this task',
        'Job Settings' => 'Job Settings',
        'Job name' => 'Job name',
        'The name you entered already exists.' => 'The name you entered already exists.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Execution Schedule',
        'Schedule minutes' => 'Schedule minutes',
        'Schedule hours' => 'Schedule hours',
        'Schedule days' => 'Schedule days',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Currently this generic agent job will not run automatically.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'To enable automatic execution select at least one value from minutes, hours and days!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Event Triggers',
        'List of all configured events' => 'List of all configured events',
        'Delete this event' => 'Delete this event',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.',
        'Do you really want to delete this event trigger?' => 'Do you really want to delete this event trigger?',
        'Add Event Trigger' => 'Add Event Trigger',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Select Tickets',
        '(e. g. 10*5155 or 105658*)' => '(e. g. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(e. g. 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(e. g. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fulltext-search in article (e. g. "Mar*in" or "Baue*").',
        'To' => 'To',
        'Cc' => 'Cc',
        'Service' => 'Service',
        'Service Level Agreement' => 'Service Level Agreement',
        'Queue' => 'Queue',
        'State' => 'State',
        'Agent' => 'Agent',
        'Owner' => 'Owner',
        'Responsible' => 'Responsible',
        'Ticket lock' => 'Ticket lock',
        'Dynamic fields' => 'Dynamic fields',
        'Add dynamic field' => '',
        'Create times' => 'Create times',
        'No create time settings.' => 'No create time settings.',
        'Ticket created' => 'Ticket created',
        'Ticket created between' => 'Ticket created between',
        'and' => 'and',
        'Last changed times' => 'Last changed times',
        'No last changed time settings.' => 'No last changed time settings.',
        'Ticket last changed' => 'Ticket last changed',
        'Ticket last changed between' => 'Ticket last changed between',
        'Change times' => 'Change times',
        'No change time settings.' => 'No change time settings.',
        'Ticket changed' => 'Ticket changed',
        'Ticket changed between' => 'Ticket changed between',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Close times',
        'No close time settings.' => 'No close time settings.',
        'Ticket closed' => 'Ticket closed',
        'Ticket closed between' => 'Ticket closed between',
        'Pending times' => 'Pending times',
        'No pending time settings.' => 'No pending time settings.',
        'Ticket pending time reached' => 'Ticket pending time reached',
        'Ticket pending time reached between' => 'Ticket pending time reached between',
        'Escalation times' => 'Escalation times',
        'No escalation time settings.' => 'No escalation time settings.',
        'Ticket escalation time reached' => 'Ticket escalation time reached',
        'Ticket escalation time reached between' => 'Ticket escalation time reached between',
        'Escalation - first response time' => 'Escalation - first response time',
        'Ticket first response time reached' => 'Ticket first response time reached',
        'Ticket first response time reached between' => 'Ticket first response time reached between',
        'Escalation - update time' => 'Escalation - update time',
        'Ticket update time reached' => 'Ticket update time reached',
        'Ticket update time reached between' => 'Ticket update time reached between',
        'Escalation - solution time' => 'Escalation - solution time',
        'Ticket solution time reached' => 'Ticket solution time reached',
        'Ticket solution time reached between' => 'Ticket solution time reached between',
        'Archive search option' => 'Archive search option',
        'Update/Add Ticket Attributes' => 'Update/Add Ticket Attributes',
        'Set new service' => 'Set new service',
        'Set new Service Level Agreement' => 'Set new Service Level Agreement',
        'Set new priority' => 'Set new priority',
        'Set new queue' => 'Set new queue',
        'Set new state' => 'Set new state',
        'Pending date' => 'Pending date',
        'Set new agent' => 'Set new agent',
        'new owner' => 'new owner',
        'new responsible' => 'new responsible',
        'Set new ticket lock' => 'Set new ticket lock',
        'New customer user ID' => '',
        'New customer ID' => 'New customer ID',
        'New title' => 'New title',
        'New type' => 'New type',
        'Archive selected tickets' => 'Archive selected tickets',
        'Add Note' => 'Add Note',
        'Visible for customer' => '',
        'Time units' => 'Time units',
        'Execute Ticket Commands' => 'Execute Ticket Commands',
        'Send agent/customer notifications on changes' => 'Send agent/customer notifications on changes',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.',
        'Delete tickets' => 'Delete tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Warning: All affected tickets will be removed from the database and cannot be restored!',
        'Execute Custom Module' => 'Execute Custom Module',
        'Param %s key' => 'Param %s key',
        'Param %s value' => 'Param %s value',
        'Results' => 'Results',
        '%s Tickets affected! What do you want to do?' => '%s Tickets affected! What do you want to do?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Warning: You used the DELETE option. All deleted tickets will be lost!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Warning: There are %s tickets affected but only %s may be modified during one job execution!',
        'Affected Tickets' => 'Affected Tickets',
        'Age' => 'Age',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface Web Service Management',
        'Web Service Management' => '',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Go back to web service',
        'Clear' => 'Clear',
        'Do you really want to clear the debug log of this web service?' =>
            'Do you really want to clear the debug log of this web service?',
        'Request List' => 'Request List',
        'Time' => 'Time',
        'Communication ID' => '',
        'Remote IP' => 'Remote IP',
        'Loading' => 'Loading',
        'Select a single request to see its details.' => 'Select a single request to see its details.',
        'Filter by type' => 'Filter by type',
        'Filter from' => 'Filter from',
        'Filter to' => 'Filter to',
        'Filter by remote IP' => 'Filter by remote IP',
        'Limit' => 'Limit',
        'Refresh' => 'Refresh',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'All configuration data will be lost.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Please provide a unique name for this web service.',
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
        'Do you really want to delete this invoker?' => 'Do you really want to delete this invoker?',
        'Invoker Details' => 'Invoker Details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'The name is typically used to call up an operation of a remote web service.',
        'Invoker backend' => 'Invoker backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.',
        'Mapping for outgoing request data' => 'Mapping for outgoing request data',
        'Configure' => 'Configure',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.',
        'Mapping for incoming response data' => 'Mapping for incoming response data',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.',
        'Asynchronous' => 'Asynchronous',
        'Condition' => 'Condition',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'This invoker will be triggered by the configured events.',
        'Add Event' => 'Add Event',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'To add a new event select the event object and event name and click on the "+" button',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchronous event triggers would be processed directly during the web request.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Go back to',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Conditions',
        'Conditions can only operate on non-empty fields.' => 'Conditions can only operate on non-empty fields.',
        'Type of Linking between Conditions' => 'Type of Linking between Conditions',
        'Remove this Condition' => 'Remove this Condition',
        'Type of Linking' => 'Type of Linking',
        'Add a new Field' => 'Add a new Field',
        'Remove this Field' => 'Remove this Field',
        'And can\'t be repeated on the same condition.' => 'And can\'t be repeated on the same condition.',
        'Add New Condition' => 'Add New Condition',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mapping Simple',
        'Default rule for unmapped keys' => 'Default rule for unmapped keys',
        'This rule will apply for all keys with no mapping rule.' => 'This rule will apply for all keys with no mapping rule.',
        'Default rule for unmapped values' => 'Default rule for unmapped values',
        'This rule will apply for all values with no mapping rule.' => 'This rule will apply for all values with no mapping rule.',
        'New key map' => 'New key map',
        'Add key mapping' => 'Add key mapping',
        'Mapping for Key ' => 'Mapping for Key ',
        'Remove key mapping' => 'Remove key mapping',
        'Key mapping' => 'Key mapping',
        'Map key' => 'Map key',
        'matching the' => 'matching the',
        'to new key' => 'to new key',
        'Value mapping' => 'Value mapping',
        'Map value' => 'Map value',
        'to new value' => 'to new value',
        'Remove value mapping' => 'Remove value mapping',
        'New value map' => 'New value map',
        'Add value mapping' => 'Add value mapping',
        'Do you really want to delete this key mapping?' => 'Do you really want to delete this key mapping?',

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
        'Do you really want to delete this operation?' => 'Do you really want to delete this operation?',
        'Operation Details' => 'Operation Details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'The name is typically used to call up this web service operation from a remote system.',
        'Operation backend' => 'Operation backend',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'This OTOBO operation backend module will be called internally to process the request, generating data for the response.',
        'Mapping for incoming request data' => 'Mapping for incoming request data',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.',
        'Mapping for outgoing response data' => 'Mapping for outgoing response data',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Properties',
        'Route mapping for Operation' => 'Route mapping for Operation',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Valid request methods for Operation',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.',
        'Maximum message length' => 'Maximum message length',
        'This field should be an integer number.' => 'This field should be an integer number.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.',
        'Send Keep-Alive' => 'Send Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'This configuration defines if incoming connections should get closed or kept alive.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Endpoint',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Authentication',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'The user name to be used to access the remote system.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'The password for the privileged user.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Proxy Server',
        'URI of a proxy server to be used (if needed).' => 'URI of a proxy server to be used (if needed).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy User',
        'The user name to be used to access the proxy server.' => 'The user name to be used to access the proxy server.',
        'Proxy Password' => 'Proxy Password',
        'The password for the proxy user.' => 'The password for the proxy user.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Use SSL Options',
        'Show or hide SSL options to connect to the remote system.' => 'Show or hide SSL options to connect to the remote system.',
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
            'The full path and name of the certification authority certificate file that validates SSL certificate.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) Directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'The full path of the certification authority directory where the CA certificates are stored in the file system.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'e.g. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Controller mapping for Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Valid request command for Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'A specific HTTP command to use for the requests with this Invoker (optional).',
        'Default command' => 'Default command',
        'The default HTTP command to use for the requests.' => 'The default HTTP command to use for the requests.',

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
        'SOAPAction separator' => 'SOAPAction separator',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI to give SOAP methods a context, reducing ambiguities.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => 'Request name scheme',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Select how SOAP request function wrapper should be constructed.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' is used as example for actual invoker/operation name.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' is used as example for actual configured value.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Text to be used to as function wrapper name suffix or replacement.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').',
        'Response name scheme' => 'Response name scheme',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Select how SOAP response function wrapper should be constructed.',
        'Response name free text' => 'Response name free text',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.',
        'Encoding' => 'Encoding',
        'The character encoding for the SOAP message contents.' => 'The character encoding for the SOAP message contents.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => 'Sort options',
        'Add new first level element' => 'Add new first level element',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'The name must be unique.',
        'Clone' => 'Clone',
        'Export Web Service' => '',
        'Import web service' => 'Import web service',
        'Configuration File' => 'Configuration File',
        'The file must be a valid web service configuration YAML file.' =>
            'The file must be a valid web service configuration YAML file.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Import',
        'Configuration History' => '',
        'Delete web service' => 'Delete web service',
        'Do you really want to delete this web service?' => 'Do you really want to delete this web service?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'After you save the configuration you will be redirected again to the edit screen.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'If you want to return to overview please click the "Go to overview" button.',
        'Remote system' => 'Remote system',
        'Provider transport' => 'Provider transport',
        'Requester transport' => 'Requester transport',
        'Debug threshold' => 'Debug threshold',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'In provider mode, OTOBO offers web services which are used by remote systems.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'In requester mode, OTOBO uses web services of remote systems.',
        'Network transport' => 'Network transport',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Operations are individual system functions which remote systems can request.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers prepare data for a request to a remote web service, and process its response data.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Inbound mapping',
        'Outbound mapping' => 'Outbound mapping',
        'Delete this action' => 'Delete this action',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'History',
        'Go back to Web Service' => 'Go back to Web Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Here you can view older versions of the current web service\'s configuration, export or even restore them.',
        'Configuration History List' => 'Configuration History List',
        'Version' => 'Version',
        'Create time' => 'Create time',
        'Select a single configuration version to see its details.' => 'Select a single configuration version to see its details.',
        'Export web service configuration' => 'Export web service configuration',
        'Restore web service configuration' => 'Restore web service configuration',
        'Do you really want to restore this version of the web service configuration?' =>
            'Do you really want to restore this version of the web service configuration?',
        'Your current web service configuration will be overwritten.' => 'Your current web service configuration will be overwritten.',

        # Template: AdminGroup
        'Group Management' => 'Group Management',
        'Add Group' => 'Add Group',
        'Edit Group' => 'Edit Group',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'The admin group is to get in the admin area and the stats group to get stats area.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ',
        'It\'s useful for ASP solutions. ' => 'It\'s useful for ASP solutions. ',

        # Template: AdminLog
        'System Log' => 'System Log',
        'Here you will find log information about your system.' => 'Here you will find log information about your system.',
        'Hide this message' => 'Hide this message',
        'Recent Log Entries' => 'Recent Log Entries',
        'Facility' => 'Facility',
        'Message' => 'Message',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Mail Account Management',
        'Add Mail Account' => 'Add Mail Account',
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
        'Host' => 'Host',
        'Delete account' => 'Delete account',
        'Fetch mail' => 'Fetch mail',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => 'Example: mail.example.com',
        'IMAP Folder' => 'IMAP Folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Only modify this if you need to fetch mail from a different folder than INBOX.',
        'Trusted' => 'Trusted',
        'Dispatching' => 'Dispatching',
        'Edit Mail Account' => 'Edit Mail Account',

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
        'Ticket Notification Management' => 'Ticket Notification Management',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.',
        'Ticket Filter' => 'Ticket Filter',
        'Lock' => 'Lock',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'Article Filter',
        'Only for ArticleCreate and ArticleSend event' => 'Only for ArticleCreate and ArticleSend event',
        'Article sender type' => 'Article sender type',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Include attachments to notification',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notify user just once per day about a single ticket using a selected transport.',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Notifications are sent to an agent or a customer.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'To get the first 20 character of the subject (of the latest agent article).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'To get the first 5 lines of the body (of the latest agent article).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'To get the first 20 character of the subject (of the latest customer article).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'To get the first 5 lines of the body (of the latest customer article).',
        'Attributes of the current customer user data' => 'Attributes of the current customer user data',
        'Attributes of the current ticket owner user data' => 'Attributes of the current ticket owner user data',
        'Attributes of the current ticket responsible user data' => 'Attributes of the current ticket responsible user data',
        'Attributes of the current agent user who requested this action' =>
            'Attributes of the current agent user who requested this action',
        'Attributes of the ticket data' => 'Attributes of the ticket data',
        'Ticket dynamic fields internal key values' => 'Ticket dynamic fields internal key values',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'PGP Management',
        'Add PGP Key' => 'Add PGP Key',
        'PGP support is disabled' => 'PGP support is disabled',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'To be able to use PGP in OTOBO, you have to enable it first.',
        'Enable PGP support' => 'Enable PGP support.',
        'Faulty PGP configuration' => 'Faulty PGP configuration',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.',
        'Configure it here!' => 'Configure it here!',
        'Check PGP configuration' => 'Check PGP configuration',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'In this way you can directly edit the keyring configured in SysConfig.',
        'Introduction to PGP' => 'Introduction to PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Expires',
        'Delete this key' => 'Delete this key',
        'PGP key' => 'PGP key',

        # Template: AdminPackageManager
        'Package Manager' => 'Package Manager',
        'Uninstall Package' => '',
        'Uninstall package' => 'Uninstall package',
        'Do you really want to uninstall this package?' => 'Do you really want to uninstall this package?',
        'Reinstall package' => 'Reinstall package',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Do you really want to reinstall this package? Any manual changes will be lost.',
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
            'In case you would have further questions we would be glad to answer them.',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Install Package',
        'Update Package' => '',
        'Continue' => 'Continue',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.',
        'Install' => 'Install',
        'Update repository information' => 'Update repository information',
        'Cloud services are currently disabled.' => 'Cloud services are currently disabled.',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => 'Enable cloud services',
        'Update all installed packages' => '',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Vendor',
        'Action' => 'Action',
        'Module documentation' => 'Module documentation',
        'Local Repository' => 'Local Repository',
        'This package is verified by OTOBOverify (tm)' => 'This package is verified by OTOBOverify (tm)',
        'Uninstall' => 'Uninstall',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Package not correctly deployed. Please reinstall the package.',
        'Reinstall' => 'Reinstall',
        'Features for %s customers only' => 'Features for %s customers only',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.',
        'Package Information' => '',
        'Download package' => 'Download package',
        'Rebuild package' => 'Rebuild package',
        'Metadata' => 'Metadata',
        'Change Log' => 'Change Log',
        'Date' => 'Date',
        'List of Files' => 'List of FIles',
        'Permission' => 'Permission',
        'Download file from package!' => 'Download file from package!',
        'Required' => 'Required',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'File differences for file %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'Range' => 'Range',
        'last' => 'last',
        'This feature is enabled!' => 'This feature is enabled!',
        'Just use this feature if you want to log each request.' => 'Just use this feature if you want to log each request.',
        'Activating this feature might affect your system performance!' =>
            'Activating this feature might affect your system performance!',
        'Disable it here!' => 'Disable it here!',
        'Logfile too large!' => 'Logfile too large!',
        'The logfile is too large, you need to reset it' => 'The logfile is too large, you need to reset it',
        'Interface' => 'Interface',
        'Requests' => 'Requests',
        'Min Response' => 'Min Response',
        'Max Response' => 'Max Response',
        'Average Response' => 'Average Response',
        'Period' => 'Period',
        'minutes' => 'minutes',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Average',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Filter Management',
        'Add PostMaster Filter' => 'Add PostMaster Filter',
        'Edit PostMaster Filter' => 'Edit PostMaster Filter',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Delete this filter',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter Condition',
        'AND Condition' => 'AND Condition',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'The field needs to be a valid regular expression or a literal word.',
        'Negate' => 'Negate',
        'Set Email Headers' => 'Set Email Headers',
        'Set email header' => 'Set email header',
        'with value' => '',
        'The field needs to be a literal word.' => 'The field needs to be a literal word.',
        'Header' => 'Header',

        # Template: AdminPriority
        'Priority Management' => 'Priority Management',
        'Add Priority' => 'Add Priority',
        'Edit Priority' => 'Edit Priority',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Process Management',
        'Filter for Processes' => 'Filter for Processes',
        'Filter for processes' => '',
        'Create New Process' => 'Create New Process',
        'Deploy All Processes' => 'Deploy All Processes',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.',
        'Upload process configuration' => 'Upload process configuration',
        'Import process configuration' => 'Import process configuration',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'To create a new Process you can either import a Process that was exported from another system or create a complete new one.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Changes to the Processes here only affect the behaviour of the system, if you synchronise the Process data. By synchronising the Processes, the newly made changes will be written to the Configuration.',
        'Processes' => 'Processes',
        'Process name' => 'Process name',
        'Print' => 'Print',
        'Export Process Configuration' => 'Export Process Configuration',
        'Copy Process' => 'Copy Process',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancel & close',
        'Go Back' => 'Go Back',
        'Please note, that changing this activity will affect the following processes' =>
            'Please note, that changing this activity will affect the following processes',
        'Activity' => 'Activity',
        'Activity Name' => 'Activity Name',
        'Activity Dialogs' => 'Activity Dialogs',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.',
        'Filter available Activity Dialogs' => 'Filter available Activity Dialogs',
        'Available Activity Dialogs' => 'Available Activity Dialogs',
        'Name: %s, EntityID: %s' => 'Name: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Create New Activity Dialog',
        'Assigned Activity Dialogs' => 'Assigned Activity Dialogs',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Please note that changing this activity dialog will affect the following activities',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'The Queue field can only be used by customers when creating a new ticket.',
        'Activity Dialog' => 'Activity Dialog',
        'Activity dialog Name' => 'Activity dialog Name',
        'Available in' => 'Available in',
        'Description (short)' => 'Description (short)',
        'Description (long)' => 'Description (long)',
        'The selected permission does not exist.' => 'The selected permission does not exist.',
        'Required Lock' => 'Required Lock',
        'The selected required lock does not exist.' => 'The selected required lock does not exist.',
        'Submit Advice Text' => 'Submit Advice Text',
        'Submit Button Text' => 'Submit Button Text',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.',
        'Filter available fields' => 'Filter available fields',
        'Available Fields' => 'Available Fields',
        'Assigned Fields' => 'Assigned Fields',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Display',

        # Template: AdminProcessManagementPath
        'Path' => 'Path',
        'Edit this transition' => 'Edit this transition',
        'Transition Actions' => 'Transition Actions',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.',
        'Filter available Transition Actions' => 'Filter available Transition Actions',
        'Available Transition Actions' => 'Available Transition Actions',
        'Create New Transition Action' => 'Create New Transition Action',
        'Assigned Transition Actions' => 'Assigned Transition Actions',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Activities',
        'Filter Activities...' => 'Filter Activities...',
        'Create New Activity' => 'Create New Activity',
        'Filter Activity Dialogs...' => 'Filter Activity Dialogs...',
        'Transitions' => 'Transitions',
        'Filter Transitions...' => 'Filter Transitions...',
        'Create New Transition' => 'Create New Transition',
        'Filter Transition Actions...' => 'Filter Transition Actions...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Edit Process',
        'Print process information' => 'Print process information',
        'Delete Process' => 'Delete Process',
        'Delete Inactive Process' => 'Delete Inactive Process',
        'Available Process Elements' => 'Available Process Elements',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'You can place Activities on the canvas area to assign this Activity to the Process.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.',
        'Edit Process Information' => 'Edit Process Information',
        'Process Name' => 'Process Name',
        'The selected state does not exist.' => 'The selected state does not exist.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Add and Edit Activities, Activity Dialogs and Transitions',
        'Show EntityIDs' => 'Show EntityIDs',
        'Extend the width of the Canvas' => 'Extend the width of the Canvas',
        'Extend the height of the Canvas' => 'Extend the height of the Canvas',
        'Remove the Activity from this Process' => 'Remove the Activity from this Process',
        'Edit this Activity' => 'Edit this Activity',
        'Save Activities, Activity Dialogs and Transitions' => 'Save Activities, Activity Dialogs and Transitions',
        'Do you really want to delete this Process?' => 'Do you really want to delete this Process?',
        'Do you really want to delete this Activity?' => 'Do you really want to delete this Activity?',
        'Do you really want to delete this Activity Dialog?' => 'Do you really want to delete this Activity Dialog?',
        'Do you really want to delete this Transition?' => 'Do you really want to delete this Transition?',
        'Do you really want to delete this Transition Action?' => 'Do you really want to delete this Transition Action?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronise after completing your work.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Start Activity',
        'Contains %s dialog(s)' => 'Contains %s dialog(s)',
        'Assigned dialogs' => 'Assigned dialogs',
        'Activities are not being used in this process.' => 'Activities are not being used in this process.',
        'Assigned fields' => 'Assigned fields',
        'Activity dialogs are not being used in this process.' => 'Activity dialogs are not being used in this process.',
        'Condition linking' => 'Condition linking',
        'Transitions are not being used in this process.' => 'Transitions are not being used in this process.',
        'Module name' => 'Module name',
        'Transition actions are not being used in this process.' => 'Transition actions are not being used in this process.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Please note that changing this transition will affect the following processes',
        'Transition' => 'Transition',
        'Transition Name' => 'Transition Name',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Please note that changing this transition action will affect the following processes',
        'Transition Action' => 'Transition Action',
        'Transition Action Name' => 'Transition Action Name',
        'Transition Action Module' => 'Transition Action Module',
        'Config Parameters' => 'Config Parameters',
        'Add a new Parameter' => 'Add a new Parameter',
        'Remove this Parameter' => 'Remove this Parameter',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Add Queue',
        'Edit Queue' => 'Edit Queue',
        'Filter for Queues' => 'Filter for Queues',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'A queue with this name already exists!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Sub-queue of',
        'Unlock timeout' => 'Unlock timeout',
        '0 = no unlock' => '0 = no unlock',
        'hours' => 'hours',
        'Only business hours are counted.' => 'Only business hours are counted.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.',
        'Notify by' => 'Notify by',
        '0 = no escalation' => '0 = no escalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.',
        'Follow up Option' => 'Follow up Option',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.',
        'Ticket lock after a follow up' => 'Ticket lock after a follow up',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.',
        'System address' => 'System address',
        'Will be the sender address of this queue for email answers.' => 'Will be the sender address of this queue for email answers.',
        'Default sign key' => 'Default sign key',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Salutation',
        'The salutation for email answers.' => 'The salutation for email answers.',
        'Signature' => 'Signature',
        'The signature for email answers.' => 'The signature for email answers.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Manage Queue-Auto Response Relations',
        'Change Auto Response Relations for Queue' => 'Change Auto Response Relations for Queue',
        'This filter allow you to show queues without auto responses' => 'This filter allow you to show queues without auto responses',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => 'This filter allow you to show all queues',
        'Show All Queues' => '',
        'Auto Responses' => 'Auto Responses',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Manage Template-Queue Relations',
        'Filter for Templates' => 'Filter for Templates',
        'Filter for templates' => '',
        'Templates' => 'Templates',

        # Template: AdminRegistration
        'System Registration Management' => 'System Registration Management',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTOBO-ID' => '',
        'Deregister System' => 'Deregister System',
        'Edit details' => 'Edit details',
        'Show transmitted data' => 'Show transmitted data',
        'Deregister system' => 'Deregister system',
        'Overview of registered systems' => 'Overview of registered systems',
        'This system is registered with OTOBO Team.' => '',
        'System type' => 'System type',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'Last communication with registration server',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!',
        'Instructions' => 'Instructions',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'OTOBO-ID Login',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Read more',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'You need to log in with your OTOBO-ID to register your system.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.',
        'Data Protection' => 'Data Protection',
        'What are the advantages of system registration?' => 'What are the advantages of system registration?',
        'You will receive updates about relevant security releases.' => 'You will receive updates about relevant security releases.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'With your system registration we can improve our services for you, because we have all relevant information available.',
        'This is only the beginning!' => 'This is only the beginning!',
        'We will inform you about our new services and offerings soon.' =>
            'We will inform you about our new services and offerings soon.',
        'Can I use OTOBO without being registered?' => 'Can I use OTOBO without being registered?',
        'System registration is optional.' => 'System registration is optional.',
        'You can download and use OTOBO without being registered.' => 'You can download and use OTOBO without being registered.',
        'Is it possible to deregister?' => 'Is it possible to deregister?',
        'You can deregister at any time.' => 'You can deregister at any time.',
        'Which data is transfered when registering?' => 'Which data is transfered when registering?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.',
        'Why do I have to provide a description for my system?' => 'Why do I have to provide a description for my system?',
        'The description of the system is optional.' => 'The description of the system is optional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'The description and system type you specify help you to identify and manage the details of your registered systems.',
        'How often does my OTOBO system send updates?' => 'How often does my OTOBO system send updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Your system will send updates to the registration server at regular intervals.',
        'Typically this would be around once every three days.' => 'Typically this would be around once every three days.',
        'If you deregister your system, you will lose these benefits:' =>
            'If you deregister your system, you will lose these benefits:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'You need to log in with your OTOBO-ID to deregister your system.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'You don\'t have an OTOBO-ID yet?',
        'Sign up now' => 'Sign up now',
        'Forgot your password?' => 'Forgot your password?',
        'Retrieve a new one' => 'Retrieve a new one',
        'Next' => 'Next',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => 'Attribute',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO Version',
        'Operating System' => 'Operating System',
        'Perl Version' => 'Perl Version',
        'Optional description of this system.' => 'Optional description of this system.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Register',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => 'Deregister',
        'You can modify registration settings here.' => 'You can modify registration settings here.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'There is no data regularly sent from your system to %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'The following data is sent at minimum every 3 days from your system to %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'The data will be transferred in JSON format via a secure https connection.',
        'System Registration Data' => 'System Registration Data',
        'Support Data' => 'Support Data',

        # Template: AdminRole
        'Role Management' => 'Role Management',
        'Add Role' => 'Add Role',
        'Edit Role' => 'Edit Role',
        'Filter for Roles' => 'Filter for Roles',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Create a role and put groups in it. Then add the role to the users.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'There are no roles defined. Please use the \'Add\' button to create a new role.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Manage Role-Group Relations',
        'Roles' => 'Roles',
        'Select the role:group permissions.' => 'Select the role:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).',
        'Toggle %s permission for all' => 'Toggle %s permission for all',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => 'Permissions to move tickets into this group/queue.',
        'create' => 'create',
        'Permissions to create tickets in this group/queue.' => 'Permissions to create tickets in this group/queue.',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissions to add notes to tickets in this group/queue.',
        'owner' => 'owner',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissions to change the owner of tickets in this group/queue.',
        'priority' => 'priority',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissions to change the ticket priority in this group/queue.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Manage Agent-Role Relations',
        'Add Agent' => 'Add Agent',
        'Filter for Agents' => 'Filter for Agents',
        'Filter for agents' => '',
        'Agents' => 'Agents',
        'Manage Role-Agent Relations' => 'Manage Role-Agent Relations',

        # Template: AdminSLA
        'SLA Management' => 'SLA Management',
        'Edit SLA' => 'Edit SLA',
        'Add SLA' => 'Add SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Please write only numbers!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME Management',
        'Add Certificate' => 'Add Certificate',
        'Add Private Key' => 'Add Private Key',
        'SMIME support is disabled' => 'SMIME support is disabled',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'To be able to use SMIME in OTOBO, you have to enable it first.',
        'Enable SMIME support' => 'Enable SMIME support',
        'Faulty SMIME configuration' => 'Faulty SMIME configuration',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.',
        'Check SMIME configuration' => 'Check SMIME configuration',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filter for certificates',
        'To show certificate details click on a certificate icon.' => 'To show certificate details click on a certificate icon.',
        'To manage private certificate relations click on a private key icon.' =>
            'To manage private certificate relations click on a private key icon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.',
        'See also' => 'See also',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'In this way you can directly edit the certification and private keys in file system.',
        'Hash' => 'Hash',
        'Create' => 'Create',
        'Handle related certificates' => 'Handle related certificates',
        'Read certificate' => 'Read certificate',
        'Delete this certificate' => 'Delete this certificate',
        'File' => 'File',
        'Secret' => 'Secret',
        'Related Certificates for' => 'Related Certificates for',
        'Delete this relation' => 'Delete this relation',
        'Available Certificates' => 'Available Certificates',
        'Filter for S/MIME certs' => 'Filter for S/MIME certs',
        'Relate this certificate' => 'Relate this certificate',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME Certificate',
        'Certificate Details' => '',
        'Close this dialog' => 'Close this dialog',

        # Template: AdminSalutation
        'Salutation Management' => 'Salutation Management',
        'Add Salutation' => 'Add Salutation',
        'Edit Salutation' => 'Edit Salutation',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'e. g.',
        'Example salutation' => 'Example salutation',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure mode will (normally) be set after the initial installation is completed.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'If secure mode is not activated, activate it via SysConfig because your application is already running.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Here you can enter SQL to send it directly to the application database.',
        'Options' => 'Options',
        'Only select queries are allowed.' => 'Only select queries are allowed.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'The syntax of your SQL query has a mistake. Please check it.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'There is at least one parameter missing for the binding. Please check it.',
        'Result format' => 'Result format',
        'Run Query' => 'Run Query',
        '%s Results' => '',
        'Query is executed.' => 'Query is executed.',

        # Template: AdminService
        'Service Management' => 'Service Management',
        'Add Service' => 'Add Service',
        'Edit Service' => 'Edit Service',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Sub-service of',

        # Template: AdminSession
        'Session Management' => 'Session Management',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'All sessions',
        'Agent sessions' => 'Agent sessions',
        'Customer sessions' => 'Customer sessions',
        'Unique agents' => 'Unique agents',
        'Unique customers' => 'Unique customers',
        'Kill all sessions' => 'Kill all sessions',
        'Kill this session' => 'Kill this session',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Session',
        'Kill' => 'Kill',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Signature Management',
        'Add Signature' => 'Add Signature',
        'Edit Signature' => 'Edit Signature',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Example signature',

        # Template: AdminState
        'State Management' => 'State Management',
        'Add State' => 'Add State',
        'Edit State' => 'Edit State',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Attention',
        'Please also update the states in SysConfig where needed.' => 'Please also update the states in SysConfig where needed.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'State type',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => 'Enable Cloud Services',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'You can manually trigger the Support Data sending by pressing this button:',
        'Send Update' => 'Send Update',
        'Currently this data is only shown in this system.' => 'Currently this data is only shown in this system.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:',
        'Generate Support Bundle' => 'Generate Support Bundle',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Please choose one of the following options.',
        'Send by Email' => 'Send by Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'The support bundle is too large to send it by email, this option has been disabled.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'The email address for this user is invalid, this option has been disabled.',
        'Sending' => 'Sending',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => 'Download File',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Error: Support data could not be collected (%s).',
        'Details' => 'Details',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'System Email Addresses Management',
        'Add System Email Address' => 'Add System Email Address',
        'Edit System Email Address' => 'Edit System Email Address',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'All incoming email with this address in To or Cc will be dispatched to the selected queue.',
        'Email address' => 'Email address',
        'Display name' => 'Display name',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'The display name and email address will be shown on mail you send.',
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
        'by' => 'by',
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
        'Category' => 'Category',
        'Run search' => 'Run search',

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
        'System Maintenance Management' => 'System Maintenance Management',
        'Schedule New System Maintenance' => 'Schedule New System Maintenance',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.',
        'Stop date' => 'Stop date',
        'Delete System Maintenance' => 'Delete System Maintenance',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Date invalid!',
        'Login message' => 'Login message',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Show login message',
        'Notify message' => 'Notify message',
        'Manage Sessions' => 'Manage Sessions',
        'All Sessions' => 'All Sessions',
        'Agent Sessions' => 'Agent Sessions',
        'Customer Sessions' => 'Customer Sessions',
        'Kill all Sessions, except for your own' => 'Kill all Sessions, except for your own',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Add Template',
        'Edit Template' => 'Edit Template',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'A template is a default text which helps your agents to write faster tickets, answers or forwards.',
        'Don\'t forget to add new templates to queues.' => 'Don\'t forget to add new templates to queues.',
        'Attachments' => 'Attachments',
        'Delete this entry' => 'Delete this entry',
        'Do you really want to delete this template?' => 'Do you really want to delete this template?',
        'A standard template with this name already exists!' => 'A standard template with this name already exists!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Create type templates only supports this smart tags',
        'Example template' => 'Example template',
        'The current ticket state is' => 'The current ticket state is',
        'Your email address is' => 'Your email address is',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Toggle active for all',
        'Link %s to selected %s' => 'Link %s to selected %s',

        # Template: AdminType
        'Type Management' => 'Type Management',
        'Add Type' => 'Add Type',
        'Edit Type' => 'Edit Type',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'A type with this name already exists!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Agent Management',
        'Edit Agent' => 'Edit Agent',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Agents will be needed to handle tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Don\'t forget to add a new agent to groups and/or roles!',
        'Please enter a search term to look for agents.' => 'Please enter a search term to look for agents.',
        'Last login' => 'Last login',
        'Switch to agent' => 'Switch to agent',
        'Title or salutation' => 'Title or salutation',
        'Firstname' => 'Firstname',
        'Lastname' => 'Lastname',
        'A user with this username already exists!' => 'A user with this username already exists!',
        'Will be auto-generated if left empty.' => 'Will be auto-generated if left empty.',
        'Mobile' => 'Mobile',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Manage Agent-Group Relations',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Today',
        'All-day' => 'All-day',
        'Repeat' => '',
        'Notification' => 'Notification',
        'Yes' => 'Yes',
        'No' => 'No',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Invalid date!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'day(s)',
        'week(s)' => 'week(s)',
        'month(s)' => 'month(s)',
        'year(s)' => 'year(s)',
        'On' => 'On',
        'Monday' => 'Monday',
        'Mon' => 'Mon',
        'Tuesday' => 'Tuesday',
        'Tue' => 'Tue',
        'Wednesday' => 'Wednesday',
        'Wed' => 'Wed',
        'Thursday' => 'Thursday',
        'Thu' => 'Thu',
        'Friday' => 'Friday',
        'Fri' => 'Fri',
        'Saturday' => 'Saturday',
        'Sat' => 'Sat',
        'Sunday' => 'Sunday',
        'Sun' => 'Sun',
        'January' => 'January',
        'Jan' => 'Jan',
        'February' => 'February',
        'Feb' => 'Feb',
        'March' => 'March',
        'Mar' => 'Mar',
        'April' => 'April',
        'Apr' => 'Apr',
        'May_long' => 'May',
        'May' => 'May',
        'June' => 'June',
        'Jun' => 'Jun',
        'July' => 'July',
        'Jul' => 'Jul',
        'August' => 'August',
        'Aug' => 'Aug',
        'September' => 'September',
        'Sep' => 'Sep',
        'October' => 'October',
        'Oct' => 'Oct',
        'November' => 'November',
        'Nov' => 'Nov',
        'December' => 'December',
        'Dec' => 'Dec',
        'Relative point of time' => '',
        'Link' => 'Link',
        'Remove entry' => 'Remove entry',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Customer Information Center',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Customer User',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Note: Customer is invalid!',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Search template',
        'Create Template' => 'Create Template',
        'Create New' => 'Create New',
        'Save changes in template' => 'Save changes in template',
        'Filters in use' => 'Filters in use',
        'Additional filters' => 'Additional filters',
        'Add another attribute' => 'Add another attribute',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Select all',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Change search options',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'A running OTOBO Daemon is mandatory for correct system operation.',
        'Starting the OTOBO Daemon' => 'Starting the OTOBO Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Tomorrow',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Start',
        'none' => 'none',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Save settings' => 'Save settings',
        'Close this widget' => 'Close this widget',
        'more' => 'more',
        'Available Columns' => 'Available Columns',
        'Visible Columns (order by drag & drop)' => 'Visible Columns (order by drag & drop)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Open',
        'Closed' => 'Closed',
        '%s open ticket(s) of %s' => '%s open ticket(s) of %s',
        '%s closed ticket(s) of %s' => '%s closed ticket(s) of %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Escalated tickets',
        'Open tickets' => 'Open tickets',
        'Closed tickets' => 'Closed tickets',
        'All tickets' => 'All tickets',
        'Archived tickets' => 'Archived tickets',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Phone ticket',
        'Email ticket' => 'Email ticket',
        'New phone ticket from %s' => 'New phone ticket from %s',
        'New email ticket to %s' => 'New email ticket to %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is available!',
        'Please update now.' => 'Please update now.',
        'Release Note' => 'Release Note',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Posted %s ago.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'The configuration for this statistic widget contains errors, please review your settings.',
        'Download as SVG file' => 'Download as SVG file',
        'Download as PNG file' => 'Download as PNG file',
        'Download as CSV file' => 'Download as CSV file',
        'Download as Excel file' => 'Download as Excel file',
        'Download as PDF file' => 'Download as PDF file',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Please select a valid graph output format in the configuration of this widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'The content of this statistic is being prepared for you, please be patient.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'My locked tickets',
        'My watched tickets' => 'My watched tickets',
        'My responsibilities' => 'My responsibilities',
        'Tickets in My Queues' => 'Tickets in My Queues',
        'Tickets in My Services' => 'Tickets in My Services',
        'Service Time' => 'Service Time',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => 'out of office',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'until',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Back',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'To accept some news, a license or some changes.',
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
        'Change password' => 'Change password',
        'Current password' => 'Current password',
        'New password' => 'New password',
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
        'Edit your preferences' => 'Edit your preferences',
        'Personal Preferences' => '',
        'Preferences' => 'Preferences',
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
        'Off' => 'Off',
        'End' => 'End',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTOBO at %s.' => 'Did you know? You can help translating OTOBO at %s.',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => 'Target',
        'Process' => 'Process',
        'Split' => 'Split',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTOBO' => '',
        'Dynamic Matrix' => 'Dynamic Matrix',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Dynamic List',
        'Each row contains data of one entity.' => '',
        'Static' => 'Static',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'General Specification',
        'Create Statistic' => 'Create Statistic',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Run now',
        'Statistics Preview' => 'Statistics Preview',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistics',
        'Run' => 'Run',
        'Edit statistic "%s".' => 'Edit statistic "%s".',
        'Export statistic "%s"' => 'Export statistic "%s"',
        'Export statistic %s' => 'Export statistic %s',
        'Delete statistic "%s"' => 'Delete statistic "%s"',
        'Delete statistic %s' => 'Delete statistic %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Created by',
        'Changed by' => 'Changed by',
        'Sum rows' => 'Sum rows',
        'Sum columns' => 'Sum columns',
        'Show as dashboard widget' => 'Show as dashboard widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'This statistic contains configuration errors and can currently not be used.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Change Free Text of %s%s%s',
        'Change Owner of %s%s%s' => 'Change Owner of %s%s%s',
        'Close %s%s%s' => 'Close %s%s%s',
        'Add Note to %s%s%s' => 'Add Note to %s%s%s',
        'Set Pending Time for %s%s%s' => 'Set Pending Time for %s%s%s',
        'Change Priority of %s%s%s' => 'Change Priority of %s%s%s',
        'Change Responsible of %s%s%s' => 'Change Responsible of %s%s%s',
        'The ticket has been locked' => 'The ticket has been locked',
        'Undo & close' => 'Undo & close',
        'Ticket Settings' => 'Ticket Settings',
        'Queue invalid.' => '',
        'Service invalid.' => 'Service invalid.',
        'SLA invalid.' => '',
        'New Owner' => 'New Owner',
        'Please set a new owner!' => 'Please set a new owner!',
        'Owner invalid.' => '',
        'New Responsible' => 'New Responsible',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Next state',
        'State invalid.' => '',
        'For all pending* states.' => 'For all pending* states.',
        'Add Article' => 'Add Article',
        'Create an Article' => 'Create an Article',
        'Inform agents' => 'Inform agents',
        'Inform involved agents' => 'Inform involved agents',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Here you can select additional agents which should receive a notification regarding the new article.',
        'Text will also be received by' => 'Text will also be received by',
        'Text Template' => 'Text Template',
        'Setting a template will overwrite any text or attachment.' => 'Setting a template will overwrite any text or attachment.',
        'Invalid time!' => 'Invalid time!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Bounce %s%s%s',
        'Bounce to' => 'Bounce to',
        'You need a email address.' => 'You need a email address.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Need a valid email address or don\'t use a local email address.',
        'Next ticket state' => 'Next ticket state',
        'Inform sender' => 'Inform sender',
        'Send mail' => 'Send mail',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Bulk Action',
        'Send Email' => 'Send Email',
        'Merge' => 'Merge',
        'Merge to' => 'Merge to',
        'Invalid ticket identifier!' => 'Invalid ticket identifier!',
        'Merge to oldest' => 'Merge to oldest',
        'Link together' => 'Link together',
        'Link to parent' => 'Link to parent',
        'Unlock tickets' => 'Unlock tickets',
        'Execute Bulk Action' => 'Execute Bulk Action',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Compose Answer for %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'This address is registered as system address and cannot be used: %s',
        'Please include at least one recipient' => 'Please include at least one recipient',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Remove Ticket Customer',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Please remove this entry and enter a new one with the correct value.',
        'This address already exists on the address list.' => 'This address already exists on the address list.',
        'Remove Cc' => 'Remove Cc',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Remove Bcc',
        'Date Invalid!' => 'Date Invalid!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Change Customer of %s%s%s',
        'Customer Information' => 'Customer Information',
        'Customer user' => 'Customer user',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Create New Email Ticket',
        'Example Template' => 'Example Template',
        'To customer user' => 'To customer user',
        'Please include at least one customer user for the ticket.' => 'Please include at least one customer user for the ticket.',
        'Select this customer as the main customer.' => 'Select this customer as the main customer.',
        'Remove Ticket Customer User' => 'Remove Ticket Customer User',
        'From queue' => 'From queue',
        'Get all' => 'Get all',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Outbound Email for %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: first response time is over (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: first response time will be over in %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s: update time is over (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: update time will be over in %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: solution time is over (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: solution time will be over in %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Forward %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'History of %s%s%s',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'Created',
        'Article' => 'Article',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Merge %s%s%s',
        'Merge Settings' => 'Merge Settings',
        'You need to use a ticket number!' => 'You need to use a ticket number!',
        'A valid ticket number is required.' => 'A valid ticket number is required.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Need a valid email address.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Move %s%s%s',
        'New Queue' => 'New Queue',
        'Move' => 'Move',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'No ticket data found.',
        'Open / Close ticket action menu' => 'Open / Close ticket action menu',
        'Select this ticket' => 'Select this ticket',
        'Sender' => 'Sender',
        'First Response Time' => 'First Response Time',
        'Update Time' => 'Update Time',
        'Solution Time' => 'Solution Time',
        'Move ticket to a different queue' => 'Move ticket to a different queue',
        'Change queue' => 'Change queue',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Remove active filters for this screen.',
        'Tickets per page' => 'Tickets per page',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Reset overview',
        'Column Filters Form' => 'Column Filters Form',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Split Into New Phone Ticket',
        'Save Chat Into New Phone Ticket' => 'Save Chat Into New Phone Ticket',
        'Create New Phone Ticket' => 'Create New Phone Ticket',
        'Please include at least one customer for the ticket.' => 'Please include at least one customer for the ticket.',
        'To queue' => 'To queue',
        'Chat protocol' => 'Chat protocol',
        'The chat will be appended as a separate article.' => 'The chat will be appended as a separate article.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Phone Call for %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'View Email Plain Text for %s%s%s',
        'Plain' => 'Plain',
        'Download this email' => 'Download this email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Create New Process Ticket',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Enroll Ticket into a Process',

        # Template: AgentTicketSearch
        'Profile link' => 'Profile link',
        'Output' => 'Output',
        'Fulltext' => 'Fulltext',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Created in Queue',
        'Lock state' => 'Lock state',
        'Watcher' => 'Watcher',
        'Article Create Time (before/after)' => 'Article Create Time (before/after)',
        'Article Create Time (between)' => 'Article Create Time (between)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Ticket Create Time (before/after)',
        'Ticket Create Time (between)' => 'Ticket Create Time (between)',
        'Ticket Change Time (before/after)' => 'Ticket Change Time (before/after)',
        'Ticket Change Time (between)' => 'Ticket Change Time (between)',
        'Ticket Last Change Time (before/after)' => 'Ticket Last Change Time (before/after)',
        'Ticket Last Change Time (between)' => 'Ticket Last Change Time (between)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Ticket Close Time (before/after)',
        'Ticket Close Time (between)' => 'Ticket Close Time (between)',
        'Ticket Escalation Time (before/after)' => 'Ticket Escalation Time (before/after)',
        'Ticket Escalation Time (between)' => 'Ticket Escalation Time (between)',
        'Archive Search' => 'Archive Search',

        # Template: AgentTicketZoom
        'Sender Type' => 'Sender Type',
        'Save filter settings as default' => 'Save filter settings as default',
        'Event Type' => 'Event Type',
        'Save as default' => 'Save as default',
        'Drafts' => '',
        'Change Queue' => 'Change Queue',
        'There are no dialogs available at this point in the process.' =>
            'There are no dialogs available at this point in the process.',
        'This item has no articles yet.' => 'This item has no articles yet.',
        'Ticket Timeline View' => 'Ticket Timeline View',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Add Filter',
        'Set' => 'Set',
        'Reset Filter' => 'Reset Filter',
        'No.' => 'No.',
        'Unread articles' => 'Unread articles',
        'Via' => '',
        'Important' => 'Important',
        'Unread Article!' => 'Unread Article!',
        'Incoming message' => 'Incoming message',
        'Outgoing message' => 'Outgoing message',
        'Internal message' => 'Internal message',
        'Sending of this message has failed.' => '',
        'Resize' => 'Resize',
        'Mark this article as read' => 'Mark this article as read',
        'Show Full Text' => 'Show Full Text',
        'Full Article Text' => 'Full Article Text',
        'No more events found. Please try changing the filter settings.' =>
            'No more events found. Please try changing the filter settings.',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).',
        'Close this message' => 'Close this message',
        'Image' => '',
        'PDF' => '',
        'Unknown' => 'Unknown',
        'View' => 'View',

        # Template: LinkTable
        'Linked Objects' => 'Linked Objects',

        # Template: TicketInformation
        'Archive' => 'Archive',
        'This ticket is archived.' => 'This ticket is archived.',
        'Note: Type is invalid!' => 'Note: Type is invalid!',
        'Pending till' => 'Pending till',
        'Locked' => 'Locked',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Accounted time',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'To protect your privacy, remote content was blocked.',
        'Load blocked content.' => 'Load blocked content.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'You can',
        'go back to the previous page' => 'go back to the previous page',

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
        'New Ticket' => 'New Ticket',

        # Template: CustomerError
        'An Error Occurred' => 'An Error Occurred',
        'Error Details' => 'Error Details',
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript Not Available',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Browser Warning',
        'The browser you are using is too old.' => 'The browser you are using is too old.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Please see the documentation or ask your admin for further information.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'One moment please, you are being redirected...',
        'Login' => 'Login',
        'Your user name' => 'Your user name',
        'User name' => 'User name',
        'Your password' => 'Your password',
        'Forgot password?' => 'Forgot password?',
        'Your 2 Factor Token' => 'Your 2 Factor Token',
        '2 Factor Token' => '2 Factor Token',
        'Log In' => 'Log In',
        'Request Account' => '',
        'Request New Password' => 'Request New Password',
        'Your User Name' => 'Your User Name',
        'A new password will be sent to your email address.' => 'A new password will be sent to your email address.',
        'Create Account' => 'Create Account',
        'Please fill out this form to receive login credentials.' => 'Please fill out this form to receive login credentials.',
        'How we should address you' => 'How we should address you',
        'Your First Name' => 'Your First Name',
        'Your Last Name' => 'Your Last Name',
        'Your email address (this will become your username)' => 'Your email address (this will become your username)',

        # Template: CustomerNavigationBar
        'Logout' => 'Logout',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Welcome!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Page',
        'Tickets' => 'Tickets',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Profile',
        'e. g. 10*5155 or 105658*' => 'e. g. 10*5155 or 105658*',
        'CustomerID' => 'CustomerID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Types',
        'Time Restrictions' => '',
        'No time settings' => 'No time settings',
        'All' => 'All',
        'Specific date' => 'Specific date',
        'Only tickets created' => 'Only tickets created',
        'Date range' => 'Date range',
        'Only tickets created between' => 'Only tickets created between',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Save as Template?',
        'Save as Template' => 'Save as Template',
        'Template Name' => 'Template Name',
        'Pick a profile name' => 'Pick a profile name',
        'Output to' => 'Output to',

        # Template: CustomerTicketSearchResultShort
        'of' => 'of',
        'Search Results for' => 'Search Results for',
        'Remove this Search Term.' => 'Remove this Search Term.',

        # Template: CustomerTicketZoom
        'Reply' => 'Reply',
        'Discard' => '',
        'Ticket Information' => 'Ticket Information',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => 'Expand article',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Warning',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Event Information',
        'Ticket fields' => 'Ticket fields',

        # Template: Error
        'Send a bugreport' => 'Send a bugreport',
        'Expand' => 'Expand',

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
        'Edit personal preferences' => 'Edit personal preferences',
        'Personal preferences' => '',
        'You are logged in as' => 'You are logged in as',

        # Template: Installer
        'JavaScript not available' => 'JavaScript not available',
        'Step %s' => 'Step %s',
        'License' => 'Licence',
        'Database Settings' => 'Database Settings',
        'General Specifications and Mail Settings' => 'General Specifications and Mail Settings',
        'Finish' => 'Finish',
        'Welcome to %s' => 'Welcome to %s',
        'Germany' => '',
        'Phone' => 'Phone',
        'Switzerland' => '',
        'Web site' => 'Web site',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configure Outbound Mail',
        'Outbound mail type' => 'Outbound mail type',
        'Select outbound mail type.' => 'Select outbound mail type.',
        'Outbound mail port' => 'Outbound mail port',
        'Select outbound mail port.' => 'Select outbound mail port.',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP authentication',
        'Does your SMTP host need authentication?' => 'Does your SMTP host need authentication?',
        'SMTP auth user' => 'SMTP auth user',
        'Username for SMTP auth.' => 'Username for SMTP auth.',
        'SMTP auth password' => 'SMTP auth password',
        'Password for SMTP auth.' => 'Password for SMTP auth.',
        'Configure Inbound Mail' => 'Configure Inbound Mail',
        'Inbound mail type' => 'Inbound mail type',
        'Select inbound mail type.' => 'Select inbound mail type.',
        'Inbound mail host' => 'Inbound mail host',
        'Inbound mail host.' => 'Inbound mail host.',
        'Inbound mail user' => 'Inbound mail user',
        'User for inbound mail.' => 'User for inbound mail.',
        'Inbound mail password' => 'Inbound mail password',
        'Password for inbound mail.' => 'Password for inbound mail.',
        'Result of mail configuration check' => 'Result of mail configuration check',
        'Check mail configuration' => 'Check mail configuration',
        'Skip this step' => 'Skip this step',

        # Template: InstallerDBResult
        'Done' => 'Done',
        'Error' => 'Error',
        'Database setup successful!' => 'Database setup successful!',

        # Template: InstallerDBStart
        'Install Type' => 'Install Type',
        'Create a new database for OTOBO' => 'Create a new database for OTOBO',
        'Use an existing database for OTOBO' => 'Use an existing database for OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'If you have set a root password for your database, it must be entered here. If not, leave this field empty.',
        'Database name' => 'Database name',
        'Check database settings' => 'Check database settings',
        'Result of database check' => 'Result of database check',
        'Database check successful.' => 'Database check successful.',
        'Database User' => 'Database User',
        'New' => 'New',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'A new database user with limited permissions will be created for this OTOBO system.',
        'Repeat Password' => 'Repeat Password',
        'Generated password' => 'Generated password',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Passwords do not match',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.',
        'Restart your webserver' => 'Restart your webserver',
        'After doing so your OTOBO is up and running.' => 'After doing so your OTOBO is up and running.',
        'Start page' => 'Start page',
        'Your OTOBO Team' => 'Your OTOBO Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Don\'t accept licence',
        'Accept license and continue' => 'Accept license and continue',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'The identifier of the system. Each ticket number and each HTTP session ID contain this number.',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'Fully qualified domain name of your system.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => 'Email address of the system administrator.',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModule',
        'Log backend to use.' => 'Log backend to use.',
        'LogFile' => 'LogFile',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'Default language',
        'Default language.' => 'Default language.',
        'CheckMXRecord' => 'CheckMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Object#',
        'Add links' => 'Add links',
        'Delete links' => 'Delete links',

        # Template: Login
        'Lost your password?' => 'Lost your password?',
        'Back to login' => 'Back to login',

        # Template: MetaFloater
        'Scale preview content' => 'Scale preview content',
        'Open URL in new tab' => 'Open URL in new tab',
        'Close preview' => 'Close preview',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',

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
            'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.',

        # Template: Motd
        'Message of the Day' => 'Message of the Day',
        'This is the message of the day. You can edit this in %s.' => 'This is the message of the day. You can edit this in %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Insufficient Rights',
        'Back to the previous page' => 'Back to the previous page',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => 'Show first page',
        'Show previous pages' => 'Show previous pages',
        'Show page %s' => 'Show page %s',
        'Show next pages' => 'Show next pages',
        'Show last page' => 'Show last page',

        # Template: PictureUpload
        'Need FormID!' => 'Need FormID!',
        'No file found!' => 'No file found!',
        'The file is not an image that can be shown inline!' => 'The file is not an image that can be shown inline!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'No user configurable notifications found.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Receive messages for notification \'%s\' by transport method \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Process Information',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Inform Agent',

        # Template: PublicDefault
        'Welcome' => 'Welcome',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'This is the default public interface of OTOBO! There was no action parameter given.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissions',
        'You can select one or more groups to define access for different agents.' =>
            'You can select one or more groups to define access for different agents.',
        'Result formats' => 'Result formats',
        'Time Zone' => 'Time Zone',
        'The selected time periods in the statistic are time zone neutral.' =>
            'The selected time periods in the statistic are time zone neutral.',
        'Create summation row' => 'Create summation row',
        'Generate an additional row containing sums for all data rows.' =>
            'Generate an additional row containing sums for all data rows.',
        'Create summation column' => 'Create summation column',
        'Generate an additional column containing sums for all data columns.' =>
            'Generate an additional column containing sums for all data columns.',
        'Cache results' => 'Cache results',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Provide the statistic as a widget that agents can activate in their dashboard.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.',
        'If set to invalid end users can not generate the stat.' => 'If set to invalid end users can not generate the stat.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'There are problems in the configuration of this statistic:',
        'You may now configure the X-axis of your statistic.' => 'You may now configure the X-axis of your statistic.',
        'This statistic does not provide preview data.' => 'This statistic does not provide preview data.',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Please note that the preview uses random data and does not consider data filters.',
        'Configure X-Axis' => 'Configure X-Axis',
        'X-axis' => 'X-axis',
        'Configure Y-Axis' => 'Configure Y-Axis',
        'Y-axis' => 'Y-axis',
        'Configure Filter' => 'Configure Filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Please select only one element or turn off the button \'Fixed\'.',
        'Absolute period' => 'Absolute period',
        'Between %s and %s' => '',
        'Relative period' => 'Relative period',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'The past complete %s and the current+upcoming complete %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Do not allow changes to this element when the statistic is generated.',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Exchange Axis',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'No element selected.',
        'Scale' => 'Scale',
        'show more' => 'show more',
        'show less' => 'show less',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'The selected time period defines the default time frame for this statistic to collect data from.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Defines the time unit that will be used to split the selected time period into reporting data points.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).',

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
        'OTOBO Test Page' => 'OTOBO Test Page',
        'Unlock' => 'Unlock',
        'Welcome %s %s' => 'Welcome %s %s',
        'Counter' => 'Counter',

        # Template: Warning
        'Go back to the previous page' => 'Go back to the previous page',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Confirm',

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
        'Finished' => 'Finished',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Add new entry',

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
        'CustomerIDs' => 'CustomerIDs',
        'Fax' => 'Fax',
        'Street' => 'Street',
        'Zip' => 'Postcode',
        'City' => 'City',
        'Country' => 'Country',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Address' => '',
        'View system log messages.' => 'View system log messages.',
        'Edit the system configuration settings.' => 'Edit the system configuration settings.',
        'Update and extend your system with software packages.' => 'Update and extend your system with software packages.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information',
        'The following ACLs have been added successfully: %s' => 'The following ACLs have been added successfully: %s',
        'The following ACLs have been updated successfully: %s' => 'The following ACLs have been updated successfully: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.',
        'There was an error creating the ACL' => 'There was an error creating the ACL',
        'Need ACLID!' => 'Need ACLID!',
        'Could not get data for ACLID %s' => 'Could not get data for ACLID %s',
        'There was an error updating the ACL' => 'There was an error updating the ACL',
        'There was an error setting the entity sync status.' => 'There was an error setting the entity sync status.',
        'There was an error synchronizing the ACLs.' => 'There was an error synchronizing the ACLs.',
        'ACL %s could not be deleted' => 'ACL %s could not be deleted',
        'There was an error getting data for ACL with ID %s' => 'There was an error getting data for ACL with ID %s',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Exact match',
        'Negated exact match' => 'Negated exact match',
        'Regular expression' => 'Regular expression',
        'Regular expression (ignore case)' => 'Regular expression (ignore case)',
        'Negated regular expression' => 'Negated regular expression',
        'Negated regular expression (ignore case)' => 'Negated regular expression (ignore case)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '',
        'Please contact the administrator.' => 'Please contact the administrator.',
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
        'Notification added!' => 'Notification added!',
        'There was an error getting data for Notification with ID:%s!' =>
            'There was an error getting data for Notification with ID:%s!',
        'Unknown Notification %s!' => 'Unknown Notification %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'There was an error creating the Notification',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information',
        'The following Notifications have been added successfully: %s' =>
            'The following Notifications have been added successfully: %s',
        'The following Notifications have been updated successfully: %s' =>
            'The following Notifications have been updated successfully: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.',
        'Notification updated!' => 'Notification updated!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Attachment added!',

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
        'Failed' => '',
        'Invalid Filter: %s!' => 'Invalid Filter: %s!',
        'Less than a second' => '',
        'sorted descending' => 'sorted descending',
        'sorted ascending' => 'sorted ascending',
        'Trace' => '',
        'Debug' => 'Debug',
        'Info' => 'Info',
        'Warn' => '',
        'days' => 'days',
        'day' => 'day',
        'hour' => 'hour',
        'minute' => 'minute',
        'seconds' => 'seconds',
        'second' => 'second',

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
        'Customer company updated!' => 'Customer company updated!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Customer Company %s already exists!',
        'Customer company added!' => 'Customer company added!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Customer updated!',
        'New phone ticket' => 'New phone ticket',
        'New email ticket' => 'New email ticket',
        'Customer %s added' => 'Customer %s added',
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
        'Fields configuration is not valid' => 'Fields configuration is not valid',
        'Objects configuration is not valid' => 'Objects configuration is not valid',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Could not reset Dynamic Field order properly, please check the error log for more details.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Undefined subaction.',
        'Need %s' => 'Need %s',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'The field does not contain only ASCII letters and numbers.',
        'There is another field with the same name.' => 'There is another field with the same name.',
        'The field must be numeric.' => 'The field must be numeric.',
        'Need ValidID' => 'Need ValidID',
        'Could not create the new field' => 'Could not create the new field',
        'Need ID' => 'Need ID',
        'Could not get data for dynamic field %s' => 'Could not get data for dynamic field %s',
        'Change %s field' => '',
        'The name for this field should not change.' => 'The name for this field should not change.',
        'Could not update the field %s' => 'Could not update the field %s',
        'Currently' => 'Currently',
        'Unchecked' => 'Unchecked',
        'Checked' => 'Checked',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'This field value is duplicated.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Prevent entry of dates in the future',
        'Prevent entry of dates in the past' => 'Prevent entry of dates in the past',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to reset the setting!' => '',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Select at least one recipient.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minute(s)',
        'hour(s)' => 'hour(s)',
        'Time unit' => 'Time unit',
        'within the last ...' => 'within the last ...',
        'within the next ...' => 'within the next ...',
        'more than ... ago' => 'more than ... ago',
        'Unarchived tickets' => 'Unarchived tickets',
        'archive tickets' => 'archive tickets',
        'restore tickets from archive' => 'restore tickets from archive',
        'Need Profile!' => 'Need Profile!',
        'Got no values to check.' => 'Got no values to check.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Please remove the following words because they cannot be used for the ticket selection:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Need WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Could not get data for WebserviceID %s',
        'ascending' => 'ascending',
        'descending' => 'descending',

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
        '10 minutes' => '10 minutes',
        '15 minutes' => '15 minutes',
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
        'Could not determine config for invoker %s' => 'Could not determine config for invoker %s',
        'InvokerType %s is not registered' => 'InvokerType %s is not registered',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'Could not update configuration data for WebserviceID %s',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Could not get registered configuration for action type %s',
        'Could not get backend for %s %s' => 'Could not get backend for %s %s',
        'Keep (leave unchanged)' => 'Keep (leave unchanged)',
        'Ignore (drop key/value pair)' => 'Ignore (drop key/value pair)',
        'Map to (use provided value as default)' => 'Map to (use provided value as default)',
        'Exact value(s)' => 'Exact value(s)',
        'Ignore (drop Value/value pair)' => 'Ignore (drop Value/value pair)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => 'Could not find required library %s',
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
        'Could not determine config for operation %s' => 'Could not determine config for operation %s',
        'OperationType %s is not registered' => 'OperationType %s is not registered',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'There is another web service with the same name.',
        'There was an error updating the web service.' => 'There was an error updating the web service.',
        'There was an error creating the web service.' => 'There was an error creating the web service.',
        'Web service "%s" created!' => 'Web service "%s" created!',
        'Need Name!' => 'Need Name!',
        'Need ExampleWebService!' => 'Need ExampleWebService!',
        'Could not load %s.' => '',
        'Could not read %s!' => 'Could not read %s!',
        'Need a file to import!' => 'Need a file to import!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'The imported file has not valid YAML content! Please check OTOBO log for details',
        'Web service "%s" deleted!' => 'Web service "%s" deleted!',
        'OTOBO as provider' => 'OTOBO as provider',
        'Operations' => '',
        'OTOBO as requester' => 'OTOBO as requester',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Got no WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Could not get history data for WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Group updated!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Mail account added!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Dispatching by email To: field.',
        'Dispatching by selected Queue.' => 'Dispatching by selected Queue.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Agent who owns the ticket',
        'Agent who is responsible for the ticket' => 'Agent who is responsible for the ticket',
        'All agents watching the ticket' => 'All agents watching the ticket',
        'All agents with write permission for the ticket' => 'All agents with write permission for the ticket',
        'All agents subscribed to the ticket\'s queue' => 'All agents subscribed to the ticket\'s queue',
        'All agents subscribed to the ticket\'s service' => 'All agents subscribed to the ticket\'s service',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'All agents subscribed to both the ticket\'s queue and service',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP environment is not working. Please check log for more info!',
        'Need param Key to delete!' => 'Need param Key to delete!',
        'Key %s deleted!' => 'Key %s deleted!',
        'Need param Key to download!' => 'Need param Key to download!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!',
        'No such package!' => 'No such package!',
        'No such file %s in package!' => 'No such file %s in package!',
        'No such file %s in local file system!' => 'No such file %s in local file system!',
        'Can\'t read %s!' => 'Can\'t read %s!',
        'File is OK' => '',
        'Package has locally modified files.' => 'Package has locally modified files.',
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
            'Package not verified due a communication issue with verification server!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Can\'t connect to OTOBO Feature Add-on list server!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Can\'t get OTOBO Feature Add-on list from server!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Can\'t get OTOBO Feature Add-on from server!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'No such filter: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Priority added!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Process Management information from database is not in sync with the system configuration, please synchronise all processes.',
        'Need ExampleProcesses!' => 'Need ExampleProcesses!',
        'Need ProcessID!' => 'Need ProcessID!',
        'Yes (mandatory)' => 'Yes (mandatory)',
        'Unknown Process %s!' => 'Unknown Process %s!',
        'There was an error generating a new EntityID for this Process' =>
            'There was an error generating a new EntityID for this Process',
        'The StateEntityID for state Inactive does not exists' => 'The StateEntityID for state Inactive does not exists',
        'There was an error creating the Process' => 'There was an error creating the Process',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'There was an error setting the entity sync status for Process entity: %s',
        'Could not get data for ProcessID %s' => 'Could not get data for ProcessID %s',
        'There was an error updating the Process' => 'There was an error updating the Process',
        'Process: %s could not be deleted' => 'Process: %s could not be deleted',
        'There was an error synchronizing the processes.' => 'There was an error synchronising the processes.',
        'The %s:%s is still in use' => 'The %s:%s is still in use',
        'The %s:%s has a different EntityID' => 'The %s:%s has a different EntityID',
        'Could not delete %s:%s' => 'Could not delete %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'There was an error setting the entity sync status for %s entity: %s',
        'Could not get %s' => 'Could not get %s',
        'Need %s!' => 'Need %s!',
        'Process: %s is not Inactive' => 'Process: %s is not Inactive',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'There was an error generating a new EntityID for this Activity',
        'There was an error creating the Activity' => 'There was an error creating the Activity',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'There was an error setting the entity sync status for Activity entity: %s',
        'Need ActivityID!' => 'Need ActivityID!',
        'Could not get data for ActivityID %s' => 'Could not get data for ActivityID %s',
        'There was an error updating the Activity' => 'There was an error updating the Activity',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Missing Parameter: Need Activity and ActivityDialog!',
        'Activity not found!' => 'Activity not found!',
        'ActivityDialog not found!' => 'ActivityDialog not found!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!',
        'Error while saving the Activity to the database!' => 'Error while saving the Activity to the database!',
        'This subaction is not valid' => 'This subaction is not valid',
        'Edit Activity "%s"' => 'Edit Activity "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'There was an error generating a new EntityID for this ActivityDialog',
        'There was an error creating the ActivityDialog' => 'There was an error creating the ActivityDialog',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'There was an error setting the entity sync status for ActivityDialog entity: %s',
        'Need ActivityDialogID!' => 'Need ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Could not get data for ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'There was an error updating the ActivityDialog',
        'Edit Activity Dialog "%s"' => 'Edit Activity Dialog "%s"',
        'Agent Interface' => 'Agent Interface',
        'Customer Interface' => 'Customer Interface',
        'Agent and Customer Interface' => 'Agent and Customer Interface',
        'Do not show Field' => 'Do not show Field',
        'Show Field' => 'Show Field',
        'Show Field As Mandatory' => 'Show Field As Mandatory',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Edit Path',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'There was an error generating a new EntityID for this Transition',
        'There was an error creating the Transition' => 'There was an error creating the Transition',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'There was an error setting the entity sync status for Transition entity: %s',
        'Need TransitionID!' => 'Need TransitionID!',
        'Could not get data for TransitionID %s' => 'Could not get data for TransitionID %s',
        'There was an error updating the Transition' => 'There was an error updating the Transition',
        'Edit Transition "%s"' => 'Edit Transition "%s"',
        'Transition validation module' => 'Transition validation module',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'At least one valid config parameter is required.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'There was an error generating a new EntityID for this TransitionAction',
        'There was an error creating the TransitionAction' => 'There was an error creating the TransitionAction',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'There was an error setting the entity sync status for TransitionAction entity: %s',
        'Need TransitionActionID!' => 'Need TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Could not get data for TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'There was an error updating the TransitionAction',
        'Edit Transition Action "%s"' => 'Edit Transition Action "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Error: Not all keys seem to have values or vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Queue updated!',
        'Don\'t use :: in queue name!' => 'Don\'t use :: in queue name!',
        'Click back and change it!' => 'Click back and change it!',
        '-none-' => '-none-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Queues ( without auto responses )',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Change Queue Relations for Template',
        'Change Template Relations for Queue' => 'Change Template Relations for Queue',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '',
        'Test' => '',
        'Training' => '',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Role updated!',
        'Role added!' => 'Role added!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Change Group Relations for Role',
        'Change Role Relations for Group' => 'Change Role Relations for Group',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Change Role Relations for Agent',
        'Change Agent Relations for Role' => 'Change Agent Relations for Role',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Please activate %s first!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME environment is not working. Please check log for more info!',
        'Need param Filename to delete!' => 'Need param Filename to delete!',
        'Need param Filename to download!' => 'Need param Filename to download!',
        'Needed CertFingerprint and CAFingerprint!' => 'Needed CertFingerprint and CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint must be different than CertFingerprint',
        'Relation exists!' => 'Relation exists!',
        'Relation added!' => 'Relation added!',
        'Impossible to add relation!' => 'Impossible to add relation!',
        'Relation doesn\'t exists' => 'Relation doesn\'t exists',
        'Relation deleted!' => 'Relation deleted!',
        'Impossible to delete relation!' => 'Impossible to delete relation!',
        'Certificate %s could not be read!' => 'Certificate %s could not be read!',
        'Needed Fingerprint' => 'Needed Fingerprint',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Salutation added!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Signature updated!',
        'Signature added!' => 'Signature added!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'State added!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'File %s could not be read!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'System e-mail address added!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Import not allowed!',
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
        'Start date shouldn\'t be defined after Stop date!' => 'Start date shouldn\'t be defined after Stop date!',
        'There was an error creating the System Maintenance' => 'There was an error creating the System Maintenance',
        'Need SystemMaintenanceID!' => 'Need SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Could not get data for SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Session has been killed!',
        'All sessions have been killed, except for your own.' => 'All sessions have been killed, except for your own.',
        'There was an error updating the System Maintenance' => 'There was an error updating the System Maintenance',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Was not possible to delete the SystemMaintenance entry: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Template updated!',
        'Template added!' => 'Template added!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Change Attachment Relations for Template',
        'Change Template Relations for Attachment' => 'Change Template Relations for Attachment',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Need Type!',
        'Type added!' => 'Type added!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agent updated!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Change Group Relations for Agent',
        'Change Agent Relations for Group' => 'Change Agent Relations for Group',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Month',
        'Week' => '',
        'Day' => 'Day',

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
        'Customer History' => 'Customer History',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'No such config for %s',
        'Statistic' => 'Statistic',
        'No preferences for %s!' => 'No preferences for %s!',
        'Can\'t get element data of %s!' => 'Can\'t get element data of %s!',
        'Can\'t get filter content data of %s!' => 'Can\'t get filter content data of %s!',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Need SourceObject and SourceKey!',
        'You need ro permission!' => 'You need ro permission!',
        'Can not delete link with %s!' => 'Can not delete link with %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => 'Can not create link with %s! Object already linked as %s.',
        'Can not create link with %s!' => 'Can not create link with %s!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => 'The object %s cannot link with other object!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param Group is required!',
        'This feature is not available.' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Process ticket',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parameter %s is missing.',
        'Invalid Subaction.' => 'Invalid Subaction.',
        'Statistic could not be imported.' => 'Statistic could not be imported.',
        'Please upload a valid statistic file.' => 'Please upload a valid statistic file.',
        'Export: Need StatID!' => 'Export: Need StatID!',
        'Delete: Get no StatID!' => 'Delete: Get no StatID!',
        'Need StatID!' => 'Need StatID!',
        'Could not load stat.' => 'Could not load stat.',
        'Add New Statistic' => 'Add New Statistic',
        'Could not create statistic.' => 'Could not create statistic.',
        'Run: Get no %s!' => 'Run: Get no %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'No TicketID is given!',
        'You need %s permissions!' => 'You need %s permissions!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Sorry, you need to be the ticket owner to perform this action.',
        'Please change the owner first.' => 'Please change the owner first.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'Could not perform validation on field %s!',
        'No subject' => 'No subject',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Previous Owner',
        'wrote' => 'wrote',
        'Message from' => 'Message from',
        'End message' => 'End message',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s is needed!',
        'Plain article not found for article %s!' => 'Plain article not found for article %s!',
        'Article does not belong to ticket %s!' => 'Article does not belong to ticket %s!',
        'Can\'t bounce email!' => 'Can\'t bounce email!',
        'Can\'t send email!' => 'Can\'t send email!',
        'Wrong Subaction!' => 'Wrong Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Can\'t lock Tickets, no TicketIDs are given!',
        'Ticket (%s) is not unlocked!' => 'Ticket (%s) is not unlocked!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => 'Bulk feature is not enabled!',
        'No selectable TicketID is given!' => 'No selectable TicketID is given!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Address %s replaced with registered customer address.',
        'Customer user automatically added in Cc.' => 'Customer user automatically added in Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Ticket "%s" created!',
        'No Subaction!' => 'No Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Got no TicketID!',
        'System Error!' => 'System Error!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Next week',
        'Ticket Escalation View' => 'Ticket Escalation View',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Forwarded message from',
        'End forwarded message' => 'End forwarded message',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Can\'t show history, no TicketID is given!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Can\'t lock Ticket, no TicketID is given!',
        'Sorry, the current owner is %s!' => 'Sorry, the current owner is %s!',
        'Please become the owner first.' => 'Please become the owner first.',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket (ID=%s) is locked by %s!',
        'Change the owner!' => 'Change the owner!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'New Article',
        'Pending' => 'Pending',
        'Reminder Reached' => 'Reminder Reached',
        'My Locked Tickets' => 'My Locked Tickets',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Can\'t merge ticket with itself!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'You need move permissions!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat is not active.',
        'No permission.' => 'No permission.',
        '%s has left the chat.' => '%s has left the chat.',
        'This chat has been closed and will be removed in %s hours.' => 'This chat has been closed and will be removed in %s hours.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket locked.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'No ArticleID!',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Need TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Couldn\'t get ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'No Process configured!',
        'The selected process is invalid!' => 'The selected process is invalid!',
        'Process %s is invalid!' => 'Process %s is invalid!',
        'Subaction is invalid!' => 'Subaction is invalid!',
        'Parameter %s is missing in %s.' => 'Parameter %s is missing in %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'No ActivityDialog configured for %s in _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Couldn\'t get Ticket for TicketID: %s in _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Config Value missing!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Can\'t get Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Can\'t get Activity configuration for ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Can\'t get data for Field "%s" of ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!',
        'Pending Date' => 'Pending Date',
        'for pending* states' => 'for pending* states',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID missing!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Couldn\'t get Config for ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Missing ProcessEntityID, check your ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'No StartActivityDialog or StartActivityDialog for Process "%s" configured!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Couldn\'t create ticket for Process with ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Could not store ActivityDialog, invalid TicketID: %s!',
        'Invalid TicketID: %s!' => 'Invalid TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Missing ActivityEntityID in Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'Missing ProcessEntityID in Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Default Config for Process::Default%s missing!',
        'Default Config for Process::Default%s invalid!' => 'Default Config for Process::Default%s invalid!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Available tickets',
        'including subqueues' => 'including subqueues',
        'excluding subqueues' => 'excluding subqueues',
        'QueueView' => 'QueueView',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'My Responsible Tickets',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'last-search',
        'Untitled' => 'Untitled',
        'Ticket Number' => 'Ticket Number',
        'Ticket' => 'Ticket',
        'printed by' => 'printed by',
        'CustomerID (complex search)' => 'CustomerID (complex search)',
        'CustomerID (exact match)' => 'CustomerID (exact match)',
        'Invalid Users' => 'Invalid Users',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'in more than ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Feature not enabled!',
        'Service View' => 'Service View',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Status View',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'My Watched Tickets',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Feature is not active',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Link Deleted',
        'Ticket Locked' => 'Ticket Locked',
        'Pending Time Set' => 'Pending Time Set',
        'Dynamic Field Updated' => 'Dynamic Field Updated',
        'Outgoing Email (internal)' => 'Outgoing Email (internal)',
        'Ticket Created' => 'Ticket Created',
        'Type Updated' => 'Type Updated',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'Escalation Update Time Stopped',
        'Escalation First Response Time Stopped' => 'Escalation First Response Time Stopped',
        'Customer Updated' => 'Customer Updated',
        'Internal Chat' => 'Internal Chat',
        'Automatic Follow-Up Sent' => 'Automatic Follow-Up Sent',
        'Note Added' => 'Note Added',
        'Note Added (Customer)' => 'Note Added (Customer)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'State Updated',
        'Outgoing Answer' => 'Outgoing Answer',
        'Service Updated' => 'Service Updated',
        'Link Added' => 'Link Added',
        'Incoming Customer Email' => 'Incoming Customer Email',
        'Incoming Web Request' => 'Incoming Web Request',
        'Priority Updated' => 'Priority Updated',
        'Ticket Unlocked' => 'Ticket Unlocked',
        'Outgoing Email' => 'Outgoing Email',
        'Title Updated' => 'Title Updated',
        'Ticket Merged' => 'Ticket Merged',
        'Outgoing Phone Call' => 'Outgoing Phone Call',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => 'Time Accounted',
        'Incoming Phone Call' => 'Incoming Phone Call',
        'System Request.' => '',
        'Incoming Follow-Up' => 'Incoming Follow-Up',
        'Automatic Reply Sent' => 'Automatic Reply Sent',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => 'Escalation Solution Time Stopped',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'Escalation Response Time Stopped',
        'SLA Updated' => 'SLA Updated',
        'External Chat' => 'External Chat',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => 'Can\'t get for ArticleID %s!',
        'Article filter settings were saved.' => 'Article filter settings were saved.',
        'Event type filter settings were saved.' => 'Event type filter settings were saved.',
        'Need ArticleID!' => 'Need ArticleID!',
        'Invalid ArticleID!' => 'Invalid ArticleID!',
        'Forward article via mail' => 'Forward article via mail',
        'Forward' => 'Forward',
        'Fields with no group' => 'Fields with no group',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Article could not be opened! Perhaps it is on another article page?',
        'Show one article' => 'Show one article',
        'Show all articles' => 'Show all articles',
        'Show Ticket Timeline View' => 'Show Ticket Timeline View',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => 'No TicketID for ArticleID (%s)!',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID and ArticleID are needed!',
        'No such attachment (%s)!' => 'No such attachment (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Check SysConfig setting for %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Check SysConfig setting for %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Need CustomerID!',
        'My Tickets' => 'My Tickets',
        'Company Tickets' => 'Company Tickets',
        'Untitled!' => 'Untitled!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Customer Realname',
        'Created within the last' => 'Created within the last',
        'Created more than ... ago' => 'Created more than ... ago',
        'Please remove the following words because they cannot be used for the search:' =>
            'Please remove the following words because they cannot be used for the search:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Can\'t reopen ticket, not possible in this queue!',
        'Create a new ticket!' => 'Create a new ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode active!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'Directory "%s" doesn\'t exist!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Configure "Home" in Kernel/Config.pm first!',
        'File "%s/Kernel/Config.pm" not found!' => 'File "%s/Kernel/Config.pm" not found!',
        'Directory "%s" not found!' => 'Directory "%s" not found!',
        'Install OTOBO' => 'Install OTOBO',
        'Intro' => 'Intro',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm isn\'t writable!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!',
        'Database Selection' => 'Database Selection',
        'Unknown Check!' => 'Unknown Check!',
        'The check "%s" doesn\'t exist!' => 'The check "%s" doesn\'t exist!',
        'Enter the password for the database user.' => 'Enter the password for the database user.',
        'Database %s' => 'Database %s',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Enter the password for the administrative database user.',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'Unknown database type "%s".',
        'Please go back.' => '',
        'Create Database' => 'Create Database',
        'Install OTOBO - Error' => 'Install OTOBO - Error',
        'File "%s/%s.xml" not found!' => 'File "%s/%s.xml" not found!',
        'Contact your Admin!' => 'Contact your Admin!',
        'System Settings' => 'System Settings',
        'Syslog' => '',
        'Configure Mail' => 'Configure Mail',
        'Mail Configuration' => 'Mail Configuration',
        'Can\'t write Config file!' => 'Can\'t write Config file!',
        'Unknown Subaction %s!' => 'Unknown Subaction %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Can\'t connect to database, Perl module DBD::%s not installed!',
        'Can\'t connect to database, read comment!' => 'Can\'t connect to database, read comment!',
        'Database already contains data - it should be empty!' => 'Database already contains data - it should be empty!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.',

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
        'Need config Package::RepositoryAccessRegExp' => 'Need config Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Authentication failed from %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Bounce Article to a different mail address',
        'Bounce' => 'Bounce',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Reply All',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Reply to note',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Split this article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'View the source for this Article',
        'Plain Format' => 'Plain Format',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Print this article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Mark',
        'Unmark' => 'Unmark',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypted',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Signed',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" header found, but invalid!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE" header found, but invalid!',
        'Ticket decrypted before' => 'Ticket decrypted before',
        'Impossible to decrypt: private key for email was not found!' => 'Impossible to decrypt: private key for email was not found!',
        'Successful decryption' => 'Successful decryption',

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
        'Sign' => 'Sign',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Shown',
        'Refresh (minutes)' => '',
        'off' => 'off',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Shown customer users',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'The start time of a ticket has been set after the end time!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => '',
        'Can\'t get OTOBO News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Shown Tickets',
        'Shown Columns' => 'Shown Columns',
        'filter not active' => 'filter not active',
        'filter active' => 'filter active',
        'This ticket has no title or subject' => 'This ticket has no title or subject',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7 Day Stats',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'h',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'This is a',
        'email' => 'email',
        'click here' => 'click here',
        'to open it in a new window.' => 'to open it in a new window.',
        'Year' => 'Year',
        'Hours' => 'Hours',
        'Minutes' => 'Minutes',
        'Check to activate this date' => 'Check to activate this date',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'No Permission!',
        'No Permission' => 'No Permission',
        'Show Tree Selection' => 'Show Tree Selection',
        'Split Quote' => 'Split Quote',
        'Remove Quote' => 'Remove Quote',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Linked as',
        'Search Result' => 'Search Result',
        'Linked' => 'Linked',
        'Bulk' => 'Bulk',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Lite',
        'Unread article(s) available' => 'Unread article(s) available',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Online Agent: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'There are more escalated tickets!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Online Customer %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO Daemon is not running.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'You have Out of Office enabled, would you like to disable it?',

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
            'Please make sure you\'ve chosen at least one transport method for mandatory notifications.',
        'Preferences updated successfully!' => 'Preferences updated successfully!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(in process)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Please specify an end date that is after the start date.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Verify password',
        'The current password is not correct. Please try again!' => 'The current password is not correct. Please try again!',
        'Please supply your new password!' => 'Please supply your new password!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Can\'t update password, it must be at least %s characters long!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Can\'t update password, it must contain at least 1 digit!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'invalid',
        'valid' => 'valid',
        'No (not supported)' => 'No (not supported)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'No past complete or the current+upcoming complete relative time value selected.',
        'The selected time period is larger than the allowed time period.' =>
            'The selected time period is larger than the allowed time period.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'No time scale value available for the current selected time scale value on the X axis.',
        'The selected date is not valid.' => 'The selected date is not valid.',
        'The selected end time is before the start time.' => 'The selected end time is before the start time.',
        'There is something wrong with your time selection.' => 'There is something wrong with your time selection.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Please select only one element or allow modification at stat generation time.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Please select at least one value of this field or allow modification at stat generation time.',
        'Please select one element for the X-axis.' => 'Please select one element for the X-axis.',
        'You can only use one time element for the Y axis.' => 'You can only use one time element for the Y axis.',
        'You can only use one or two elements for the Y axis.' => 'You can only use one or two elements for the Y axis.',
        'Please select at least one value of this field.' => 'Please select at least one value of this field.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Please provide a value or allow modification at stat generation time.',
        'Please select a time scale.' => 'Please select a time scale.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Your reporting time interval is too small, please use a larger time scale.',
        'second(s)' => 'second(s)',
        'quarter(s)' => 'quarter(s)',
        'half-year(s)' => 'half-year(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Please remove the following words because they cannot be used for the ticket restrictions: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Content',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Unlock to give it back to the queue',
        'Lock it to work on it' => 'Lock it to work on it',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Unwatch',
        'Remove from list of watched tickets' => 'Remove from list of watched tickets',
        'Watch' => 'Watch',
        'Add to list of watched tickets' => 'Add to list of watched tickets',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Order by',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Locked Tickets New',
        'Locked Tickets Reminder Reached' => 'Locked Tickets Reminder Reached',
        'Locked Tickets Total' => 'Locked Tickets Total',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Responsible Tickets New',
        'Responsible Tickets Reminder Reached' => 'Responsible Tickets Reminder Reached',
        'Responsible Tickets Total' => 'Responsible Tickets Total',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Watched Tickets New',
        'Watched Tickets Reminder Reached' => 'Watched Tickets Reminder Reached',
        'Watched Tickets Total' => 'Watched Tickets Total',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Ticket Dynamic Fields',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'It is currently not possible to login due to a scheduled system maintenance.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => 'Session limit reached! Please try again later.',
        'Session per user limit reached!' => 'Session per user limit reached!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Session invalid. Please log in again.',
        'Session has timed out. Please log in again.' => 'Session has timed out. Please log in again.',

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
        'Configuration Options Reference' => 'Configuration Options Reference',
        'This setting can not be changed.' => 'This setting can not be changed.',
        'This setting is not active by default.' => 'This setting is not active by default.',
        'This setting can not be deactivated.' => 'This setting can not be deactivated.',
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
        'before/after' => 'before/after',
        'between' => 'between',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'This field is required or',
        'The field content is too long!' => 'The field content is too long!',
        'Maximum size is %s characters.' => 'Maximum size is %s characters.',

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
        'not installed' => 'not installed',
        'installed' => 'installed',
        'Unable to parse repository index document.' => 'Unable to parse repository index document.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'No packages for your framework version found in this repository, it only contains packages for other framework versions.',
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
        'Inactive' => '',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Can\'t contact registration server. Please try again later.',
        'No content received from registration server. Please try again later.' =>
            'No content received from registration server. Please try again later.',
        'Can\'t get Token from sever' => 'Can\'t get Token from sever',
        'Username and password do not match. Please try again.' => 'Username and password do not match. Please try again.',
        'Problems processing server result. Please try again later.' => 'Problems processing server result. Please try again later.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '',
        'week' => 'week',
        'quarter' => 'quarter',
        'half-year' => 'half-year',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'State Type',
        'Created Priority' => 'Created Priority',
        'Created State' => 'Created State',
        'Create Time' => 'Create Time',
        'Pending until time' => '',
        'Close Time' => 'Close Time',
        'Escalation' => 'Escalation',
        'Escalation - First Response Time' => 'Escalation - First Response Time',
        'Escalation - Update Time' => 'Escalation - Update Time',
        'Escalation - Solution Time' => 'Escalation - Solution Time',
        'Agent/Owner' => 'Agent/Owner',
        'Created by Agent/Owner' => 'Created by Agent/Owner',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluation by',
        'Ticket/Article Accounted Time' => 'Ticket/Article Accounted Time',
        'Ticket Create Time' => 'Ticket Create Time',
        'Ticket Close Time' => 'Ticket Close Time',
        'Accounted time by Agent' => 'Accounted time by Agent',
        'Total Time' => 'Total Time',
        'Ticket Average' => 'Ticket Average',
        'Ticket Min Time' => 'Ticket Min Time',
        'Ticket Max Time' => 'Ticket Max Time',
        'Number of Tickets' => 'Number of Tickets',
        'Article Average' => 'Article Average',
        'Article Min Time' => 'Article Min Time',
        'Article Max Time' => 'Article Max Time',
        'Number of Articles' => 'Number of Articles',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'unlimited',
        'Attributes to be printed' => 'Attributes to be printed',
        'Sort sequence' => 'Sort sequence',
        'State Historic' => 'State Historic',
        'State Type Historic' => 'State Type Historic',
        'Historic Time Range' => 'Historic Time Range',
        'Number' => 'Number',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Solution Average',
        'Solution Min Time' => 'Solution Min Time',
        'Solution Max Time' => 'Solution Max Time',
        'Solution Average (affected by escalation configuration)' => 'Solution Average (affected by escalation configuration)',
        'Solution Min Time (affected by escalation configuration)' => 'Solution Min Time (affected by escalation configuration)',
        'Solution Max Time (affected by escalation configuration)' => 'Solution Max Time (affected by escalation configuration)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Solution Working Time Average (affected by escalation configuration)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Solution Min Working Time (affected by escalation configuration)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Solution Max Working Time (affected by escalation configuration)',
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
        'Number of Tickets (affected by escalation configuration)' => 'Number of Tickets (affected by escalation configuration)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Days',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Table Presence',
        'Internal Error: Could not open file.' => 'Internal Error: Could not open file.',
        'Table Check' => 'Table Check',
        'Internal Error: Could not read file.' => 'Internal Error: Could not read file.',
        'Tables found which are not present in the database.' => 'Tables found which are not present in the database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Database Size',
        'Could not determine database size.' => 'Could not determine database size.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Database Version',
        'Could not determine database version.' => 'Could not determine database version.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Client Connection Charset',
        'Setting character_set_client needs to be utf8.' => 'Setting character_set_client needs to be utf8.',
        'Server Database Charset' => 'Server Database Charset',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Table Charset',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log File Size',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'The setting innodb_log_file_size must be at least 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximum Query Size',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Query Cache Size',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Default Storage Engine',
        'Table Storage Engine' => 'Table Storage Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tables with a different storage engine than the default engine were found.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x or higher is required.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG Setting',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT Setting',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Setting SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Setting client_encoding needs to be UNICODE or UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Setting server_encoding needs to be UNICODE or UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Date Format',
        'Setting DateStyle needs to be ISO.' => 'Setting DateStyle needs to be ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO Disk Partition',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Disk Usage',
        'The partition where OTOBO is located is almost full.' => 'The partition where OTOBO is located is almost full.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'The partition where OTOBO is located has no disk space problems.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Disk Partitions Usage',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Could not determine distribution.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel Version',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'System Load',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modules',
        'Not all required Perl modules are correctly installed.' => 'Not all required Perl modules are correctly installed.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Free Swap Space (%)',
        'No swap enabled.' => 'No swap enabled.',
        'Used Swap Space (MB)' => 'Used Swap Space (MB)',
        'There should be more than 60% free swap space.' => 'There should be more than 60% free swap space.',
        'There should be no more than 200 MB swap space used.' => 'There should be no more than 200 MB swap space used.',

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
        'Config Settings' => 'Config Settings',
        'Could not determine value.' => 'Could not determine value.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Daemon is not running.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Database Records',
        'Ticket History Entries' => 'Ticket History Entries',
        'Articles' => 'Articles',
        'Attachments (DB, Without HTML)' => 'Attachments (DB, Without HTML)',
        'Customers With At Least One Ticket' => 'Customers With At Least One Ticket',
        'Dynamic Field Values' => 'Dynamic Field Values',
        'Invalid Dynamic Fields' => 'Invalid Dynamic Fields',
        'Invalid Dynamic Field Values' => 'Invalid Dynamic Field Values',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Months Between First And Last Ticket',
        'Tickets Per Month (avg)' => 'Tickets Per Month (avg)',
        'Open Tickets' => 'Open Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Default SOAP Username And Password',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Default Admin Password',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (domain name)',
        'Please configure your FQDN setting.' => 'Please configure your FQDN setting.',
        'Domain Name' => 'Domain Name',
        'Your FQDN setting is invalid.' => 'Your FQDN setting is invalid.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'File System Writable',
        'The file system on your OTOBO partition is not writable.' => 'The file system on your OTOBO partition is not writable.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Package Installation Status',
        'Some packages have locally modified files.' => 'Some packages have locally modified files.',
        'Some packages are not correctly installed.' => 'Some packages are not correctly installed.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Package List',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Your SystemID setting is invalid, it should only contain digits.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Default Ticket Type',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Ticket Index Module',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Invalid Users with Locked Tickets',
        'There are invalid users with locked tickets.' => 'There are invalid users with locked tickets.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'You should not have more than 8,000 open tickets in your system.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket Search Index Module',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Orphaned Records In ticket_lock_index Table',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.',
        'Orphaned Records In ticket_index Table' => 'Orphaned Records In ticket_index Table',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Time Settings',
        'Server time zone' => 'Server time zone',
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
        'Loaded Apache Modules' => 'Loaded Apache Modules',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM model',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO requires apache to be run with the \'prefork\' MPM model.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator Usage',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'You should use FastCGI or mod_perl to increase your performance.',
        'mod_deflate Usage' => 'mod_deflate Usage',
        'Please install mod_deflate to improve GUI speed.' => 'Please install mod_deflate to improve GUI speed.',
        'mod_filter Usage' => 'mod_filter Usage',
        'Please install mod_filter if mod_deflate is used.' => 'Please install mod_filter if mod_deflate is used.',
        'mod_headers Usage' => 'mod_headers Usage',
        'Please install mod_headers to improve GUI speed.' => 'Please install mod_headers to improve GUI speed.',
        'Apache::Reload Usage' => 'Apache::Reload Usage',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.',
        'Apache2::DBI Usage' => 'Apache2::DBI Usage',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI should be used to get a better performance  with pre-established database connections.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Environment Variables',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver Version',
        'Could not determine webserver version.' => 'Could not determine webserver version.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Concurrent Users Details',
        'Concurrent Users' => 'Concurrent Users',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problem',

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
        'Default' => 'Default',
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
        'Reset of unlock time.' => 'Reset of unlock time.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login failed! Your user name or password was entered incorrectly.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Logout successful.',
        'Feature not active!' => 'Feature not active!',
        'Sent password reset instructions. Please check your email.' => 'Sent password reset instructions. Please check your email.',
        'Invalid Token!' => 'Invalid Token!',
        'Sent new password to %s. Please check your email.' => 'Sent new password to %s. Please check your email.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => 'No Permission to use this frontend module!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'The email address already exists. Please log in or reset your password.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'This email address is not allowed to register. Please contact support staff.',
        'Added via Customer Panel (%s)' => 'Added via Customer Panel (%s)',
        'Customer user can\'t be added!' => 'Customer user can\'t be added!',
        'Can\'t send account info!' => 'Can\'t send account info!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'New account created. Sent login information to %s. Please check your email.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Action "%s" not found!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'invalid-temporarily',
        'Group for default access.' => 'Group for default access.',
        'Group of all administrators.' => 'Group of all administrators.',
        'Group for statistics access.' => 'Group for statistics access.',
        'new' => 'new',
        'All new state types (default: viewable).' => 'All new state types (default: viewable).',
        'open' => 'open',
        'All open state types (default: viewable).' => 'All open state types (default: viewable).',
        'closed' => 'closed',
        'All closed state types (default: not viewable).' => 'All closed state types (default: not viewable).',
        'pending reminder' => 'pending reminder',
        'All \'pending reminder\' state types (default: viewable).' => 'All \'pending reminder\' state types (default: viewable).',
        'pending auto' => 'pending auto',
        'All \'pending auto *\' state types (default: viewable).' => 'All \'pending auto *\' state types (default: viewable).',
        'removed' => 'removed',
        'All \'removed\' state types (default: not viewable).' => 'All \'removed\' state types (default: not viewable).',
        'merged' => 'merged',
        'State type for merged tickets (default: not viewable).' => 'State type for merged tickets (default: not viewable).',
        'New ticket created by customer.' => 'New ticket created by customer.',
        'closed successful' => 'closed successful',
        'Ticket is closed successful.' => 'Ticket is closed successful.',
        'closed unsuccessful' => 'closed unsuccessful',
        'Ticket is closed unsuccessful.' => 'Ticket is closed unsuccessful.',
        'Open tickets.' => 'Open tickets.',
        'Customer removed ticket.' => 'Customer removed ticket.',
        'Ticket is pending for agent reminder.' => 'Ticket is pending for agent reminder.',
        'pending auto close+' => 'pending auto close+',
        'Ticket is pending for automatic close.' => 'Ticket is pending for automatic close.',
        'pending auto close-' => 'pending auto close-',
        'State for merged tickets.' => 'State for merged tickets.',
        'system standard salutation (en)' => 'system standard salutation (en)',
        'Standard Salutation.' => 'Standard Salutation.',
        'system standard signature (en)' => 'system standard signature (en)',
        'Standard Signature.' => 'Standard Signature.',
        'Standard Address.' => 'Standard Address.',
        'possible' => 'possible',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Follow-ups for closed tickets are possible. Ticket will be reopened.',
        'reject' => 'reject',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Follow-ups for closed tickets are not possible. No new ticket will be created.',
        'new ticket' => 'new ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Postmaster queue.',
        'All default incoming tickets.' => 'All default incoming tickets.',
        'All junk tickets.' => 'All junk tickets.',
        'All misc tickets.' => 'All misc tickets.',
        'auto reply' => 'auto reply',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatic reply which will be sent out after a new ticket has been created.',
        'auto reject' => 'auto reject',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").',
        'auto follow up' => 'auto follow up',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").',
        'auto reply/new ticket' => 'auto reply/new ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").',
        'auto remove' => 'auto remove',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Auto remove will be sent out after a customer removed the request.',
        'default reply (after new ticket has been created)' => 'default reply (after new ticket has been created)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'default reject (after follow-up and rejected of a closed ticket)',
        'default follow-up (after a ticket follow-up has been added)' => 'default follow-up (after a ticket follow-up has been added)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'default reject/new ticket created (after closed follow-up with new ticket creation)',
        'Unclassified' => 'Unclassified',
        '1 very low' => '1 very low',
        '2 low' => '2 low',
        '3 normal' => '3 normal',
        '4 high' => '4 high',
        '5 very high' => '5 very high',
        'unlock' => 'unlock',
        'lock' => 'lock',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'agent',
        'system' => 'system',
        'customer' => 'customer',
        'Ticket create notification' => 'Ticket create notification',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".',
        'Ticket follow-up notification (unlocked)' => 'Ticket follow-up notification (unlocked)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".',
        'Ticket follow-up notification (locked)' => 'Ticket follow-up notification (locked)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.',
        'Ticket lock timeout notification' => 'Ticket lock timeout notification',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'You will receive a notification as soon as a ticket owned by you is automatically unlocked.',
        'Ticket owner update notification' => 'Ticket owner update notification',
        'Ticket responsible update notification' => 'Ticket responsible update notification',
        'Ticket new note notification' => 'Ticket new note notification',
        'Ticket queue update notification' => 'Ticket queue update notification',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'You will receive a notification if a ticket is moved into one of your "My Queues".',
        'Ticket pending reminder notification (locked)' => 'Ticket pending reminder notification (locked)',
        'Ticket pending reminder notification (unlocked)' => 'Ticket pending reminder notification (unlocked)',
        'Ticket escalation notification' => 'Ticket escalation notification',
        'Ticket escalation warning notification' => 'Ticket escalation warning notification',
        'Ticket service update notification' => 'Ticket service update notification',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'You will receive a notification if a ticket\'s service is changed to one of your "My Services".',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Add all',
        'An item with this name is already present.' => 'An item with this name is already present.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'This item still contains sub items. Are you sure you want to remove this item including its sub items?',

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
            'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Delete field' => 'Delete field',
        'Deleting the field and its data. This may take a while...' => 'Deleting the field and its data. This may take a while...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Remove selection',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Delete this Event Trigger',
        'Duplicate event.' => 'Duplicate event.',
        'This event is already attached to the job, Please use a different one.' =>
            'This event is already attached to the job, Please use a different one.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'An error occurred during communication.',
        'Request Details' => 'Request Details',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Show or hide the content.',
        'Clear debug log' => 'Clear debug log',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Delete this Invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Delete this Key Mapping',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Delete this Operation',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Clone web service',
        'Delete operation' => 'Delete operation',
        'Delete invoker' => 'Delete invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?' => 'Do you really want to delete this notification?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => 'Dismiss',
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
        'Remove Entity from canvas' => 'Remove Entity from canvas',
        'No TransitionActions assigned.' => 'No TransitionActions assigned.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'This Activity cannot be deleted because it is the Start Activity.',
        'Remove the Transition from this Process' => 'Remove the Transition from this Process',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Delete Entity' => 'Delete Entity',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'This Activity is already used in the Process. You cannot add it twice!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'This TransitionAction is already used in this Path. You cannot use it twice!',
        'Hide EntityIDs' => 'Hide EntityIDs',
        'Edit Field Details' => 'Edit Field Details',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Sending Update...',
        'Support Data information was successfully sent.' => 'Support Data information was successfully sent.',
        'Was not possible to send Support Data information.' => 'Was not possible to send Support Data information.',
        'Update Result' => 'Update Result',
        'Generating...' => 'Generating...',
        'It was not possible to generate the Support Bundle.' => 'It was not possible to generate the Support Bundle.',
        'Generate Result' => 'Generate Result',
        'Support Bundle' => 'Support Bundle',
        'The mail could not be sent' => 'The mail could not be sent',

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
        'Loading...' => 'Loading...',
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
            'Do you really want to delete this scheduled system maintenance?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Previous',
        'Resources' => '',
        'Su' => 'Su',
        'Mo' => 'Mo',
        'Tu' => 'Tu',
        'We' => 'We',
        'Th' => 'Th',
        'Fr' => 'Fr',
        'Sa' => 'Sa',
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
        'Duplicated entry' => 'Duplicated entry',
        'It is going to be deleted from the field, please try again.' => 'It is going to be deleted from the field, please try again.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Please enter at least one search value or * to find anything.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Information about the OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Please check the fields marked as red for valid inputs.',
        'month' => 'month',
        'Remove active filters for this widget.' => 'Remove active filters for this widget.',

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
            'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Sorry, but you can\'t disable all methods for this notification.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Switch to desktop mode',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Please remove the following words from your search as they cannot be searched for:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Do you really want to delete this statistic?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Do you really want to continue?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Article filter',
        'Apply' => 'Apply',
        'Event Type Filter' => 'Event Type Filter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Slide the navigation bar',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Please turn off Compatibility Mode in Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Switch to mobile mode',

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
        'One or more errors occurred!' => 'One or more errors occurred!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Mail check successful.',
        'Error in the mail settings. Please correct and try again.' => 'Error in the mail settings. Please correct and try again.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Open date selection',
        'Invalid date (need a future date)!' => 'Invalid date (need a future date)!',
        'Invalid date (need a past date)!' => 'Invalid date (need a past date)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Not available',
        'and %s more...' => 'and %s more...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Clear all',
        'Filters' => 'Filters',
        'Clear search' => 'Clear search',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'If you now leave this page, all open popup windows will be closed, too!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Could not open popup window. Please disable any popup blockers for this application.',

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
        'There are currently no elements available to select from.' => 'There are currently no elements available to select from.',

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
        'yes' => 'yes',
        'no' => 'no',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Grouped',
        'Stacked' => 'Stacked',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Stream',
        'Expanded' => 'Expanded',

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
