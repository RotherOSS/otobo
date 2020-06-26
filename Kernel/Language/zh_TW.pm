# --
# OTOBO is a web-based ticketing system for service organisations.
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
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
package Kernel::Language::zh_TW;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y.%M.%D %T';
    $Self->{DateFormatLong}      = ' %A %Y/%M/%D %T';
    $Self->{DateFormatShort}     = '%Y.%M.%D';
    $Self->{DateInputFormat}     = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';
    $Self->{Completeness}        = 0.414285714285714;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Actions' => '操作',
        'Create New ACL' => '創建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '導出ACL',
        'Filter for ACLs' => '過濾ACL',
        'Just start typing to filter...' => '在這邊輸入過濾字串...',
        'Configuration Import' => '配置導入',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '您可以上傳配置文件，以便將ACL導入至系統中。配置文件採用.yml格式，它可以從ACL管理模塊中導出。',
        'This field is required.' => '該字段是必須的。',
        'Overwrite existing ACLs?' => '覆蓋ACL',
        'Upload ACL configuration' => '上傳ACL配置',
        'Import ACL configuration(s)' => '導入ACL配置',
        'Description' => '描述',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '為了創建ACL，您可以導入ACL配置或從頭創建一個全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在這裡的任何ACL的修改，僅將其保存在系統中。只有在部署ACL後，它才會起作用。',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '註意：列表中的ACL名稱排序順序決定了ACL的執行順序。如果需要更改ACL的執行順序，請修改相應的ACL名稱。',
        'ACL name' => 'ACL名稱',
        'Comment' => '註釋',
        'Validity' => '有效性',
        'Export' => '導出',
        'Copy' => '複製',
        'No data found.' => '沒有找到數據。',
        'No matches found.' => '沒有找到相匹配的.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '編輯ACL %s',
        'Edit ACL' => '編輯 ACL',
        'Go to overview' => '返回概覽',
        'Delete ACL' => '刪除ACL',
        'Delete Invalid ACL' => '刪除無效的ACL',
        'Match settings' => '匹配條件',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '為ACL設置匹配條件。\'Properties\'用於匹配工單在内存中的屬性\'，而\'PropertiesDatabase\'用於匹配工單在數據庫中的屬性。',
        'Change settings' => '操作動作',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '當匹配條件滿足時執行規定的操作動作。記住：\'Possible\'表示允許(白名單)，\'PossibleNot\'表示禁止(黑名單)。',
        'Check the official %sdocumentation%s.' => '檢查官方%s文件%s。',
        'Show or hide the content' => '顯示或隱藏内容',
        'Edit ACL Information' => '編輯 ACL 資訊',
        'Name' => '名稱',
        'Stop after match' => '匹配後停止',
        'Edit ACL Structure' => '編輯 ACL 結構',
        'Save ACL' => '儲存 ACL',
        'Save' => '保存',
        'or' => '在',
        'Save and finish' => '保存並完成',
        'Cancel' => '取消',
        'Do you really want to delete this ACL?' => '您確定要刪除這個ACL嗎？',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通過填寫表數據實現ACL控制。創建ACL後，就可在編輯模式中添加ACL配置信息。',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '月曆管理',
        'Add Calendar' => '新增行事曆',
        'Edit Calendar' => '編輯行事曆',
        'Calendar Overview' => '行事曆概覽',
        'Add new Calendar' => '新增新行事曆',
        'Import Appointments' => '匯入預約',
        'Calendar Import' => '匯入行事曆',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '',
        'Overwrite existing entities' => '',
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
        'Group' => '組',
        'Changed' => '修改於',
        'Created' => '創建於',
        'Download' => '下載',
        'URL' => 'URL',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => '日曆',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '顏色',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => '規則',
        'Remove this entry' => '刪除該條目',
        'Remove' => '刪除',
        'Start date' => '',
        'End date' => '結束日期',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => '隊列',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => '添加條目',
        'Add' => '添加',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => '提交',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => '返回',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => '上傳',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '預約通知管理',
        'Add Notification' => '添加通知',
        'Edit Notification' => '編輯通知',
        'Export Notifications' => '導出通知',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => '覆寫現存通知？',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'List' => '列表',
        'Delete' => '刪除',
        'Delete this notification' => '刪除通知',
        'Show in agent preferences' => '顯示於服務員喜好設定',
        'Agent preferences tooltip' => '服務員喜好設定工具題示',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Toggle this widget' => '收起/展開Widget',
        'Events' => '事件',
        'Event' => '事件',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '預約過濾',
        'Type' => '類型',
        'Title' => '標題',
        'Location' => '位置',
        'Team' => '團隊',
        'Resource' => '資源',
        'Recipients' => '接收人',
        'Send to' => '發送至',
        'Send to these agents' => '發送至此服務員',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '每日一次',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => '通知方式',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => '啓用此通知方式',
        'Transport' => '',
        'At least one method is needed per notification.' => '',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'Upgrade to %s' => '升級至 %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => '沒有找到數據。',
        'No notification method found.' => '沒有找到通知方式。',
        'Notification Text' => '',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Subject' => '主題',
        'Text' => '正文',
        'Message body' => '訊息內容',
        'Add new notification language' => '添加新通知語言',
        'Save Changes' => '保存更改',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => '您可以使用以下的標記',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => '例如',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => '系統配置數據',
        'Example notification' => '通知範例',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => '電郵模板',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '編輯附件',
        'Filter for Attachments' => '過濾附件',
        'Filter for attachments' => '',
        'Filename' => '文件名稱',
        'Download file' => '下載文件',
        'Delete this attachment' => '刪除附件',
        'Do you really want to delete this attachment?' => '您確定要刪除此附件？',
        'Attachment' => '附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自動回復管理',
        'Add Auto Response' => '添加自動回復',
        'Edit Auto Response' => '編輯自動回復',
        'Filter for Auto Responses' => '過濾回復',
        'Filter for auto responses' => '',
        'Response' => '回復内容',
        'Auto response from' => '自動回復的發件人',
        'Reference' => '相關参考',
        'To get the first 20 character of the subject.' => '顯示主題的前20個字節',
        'To get the first 5 lines of the email.' => '顯示郵件的前五行',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => '信件數據屬性',
        'Options of the current customer user data' => '用戶資料屬性',
        'Ticket owner options' => '工單所有者屬性',
        'Ticket responsible options' => '工單負責人屬性',
        'Options of the current user who requested this action' => '工單提交者的屬性',
        'Options of the ticket data' => '工單數據屬性',
        'Options of ticket dynamic fields internal key values' => '工單動態字段内部鍵值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '動態字段顯示名稱，用於下拉選擇和複選框',
        'Example response' => '這裡有一個範例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '雲端服務管理',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => '提示',
        'Currently support data is only shown in this system.' => '',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => '配置',
        'Send support data' => '發送支援數據',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => '更新',
        'System Registration' => '系統註冊',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '登記此系統',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '登記此系統',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '可使用的雲端服務',

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
        'Settings' => '設置',
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
        'Status' => '狀態',
        'Account' => '',
        'Edit' => '編輯',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => '方向',
        'Start Time' => '開始時間',
        'End Time' => '結束時間',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => '優先級',
        'Module' => '模組',
        'Information' => '信息',
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
        'Back to search results' => '返回至搜索結果',
        'Select' => '選擇',
        'Search' => '搜索',
        'Wildcards like \'*\' are allowed.' => '允許使用通配置符，例如\'*\'。',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => '有效',

        # Template: AdminCustomerCompany
        'Customer Management' => '用戶單位管理',
        'Add Customer' => '添加用戶單位',
        'Edit Customer' => '編輯用戶單位',
        'List (only %s shown - more available)' => '',
        'total' => '總計',
        'Please enter a search term to look for customers.' => '請輸入搜索條件以便檢索用戶單位資料.',
        'Customer ID' => '用戶編號',
        'Please note' => '請注意',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '管理用戶與組的歸屬關係',
        'Notice' => '註意',
        'This feature is disabled!' => '該功能已關閉',
        'Just use this feature if you want to define group permissions for customers.' =>
            '該功能用於為用戶定義權限組。',
        'Enable it here!' => '打開該功能',
        'Edit Customer Default Groups' => '定義用戶的默認組',
        'These groups are automatically assigned to all customers.' => '默認組會自動指派給所有用戶。',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => '過濾組',
        'Select the customer:group permissions.' => '選擇用戶:組權限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果沒有選擇，就不具備該組的任何權限 (用戶不能創建或讀取工單)。',
        'Search Results' => '搜索結果',
        'Customers' => '用戶單位',
        'Groups' => '組',
        'Change Group Relations for Customer' => '此用戶屬於哪些組',
        'Change Customer Relations for Group' => '哪些用戶屬於此組',
        'Toggle %s Permission for all' => '切換%s權限給全部',
        'Toggle %s permission for %s' => '切換%s權限給%s',
        'Customer Default Groups:' => '用戶的默認組:',
        'No changes can be made to these groups.' => '不能更改默認組.',
        'ro' => '唯讀',
        'Read only access to the ticket in this group/queue.' => '對於組/隊列中的工單具有 \'讀\' 的權限',
        'rw' => '可讀寫',
        'Full read and write access to the tickets in this group/queue.' =>
            '對於組/隊列中的工單具有 \'讀和寫\' 的權限',

        # Template: AdminCustomerUser
        'Customer User Management' => '用戶管理',
        'Add Customer User' => '添加用戶',
        'Edit Customer User' => '編輯用戶',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '用戶資料用於記錄工單歷史並允許用戶訪問服務台門戶網站。',
        'List (%s total)' => '',
        'Username' => '用戶名',
        'Email' => '郵件地址',
        'Last Login' => '上次登錄時間',
        'Login as' => '登陸用戶門戶',
        'Switch to customer' => '切換至用戶',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            '必須輸入有效的郵件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '郵件地址不符合系統配置要求。',
        'This email address failed MX check.' => '該郵件域名的MX記錄檢查無效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS問題，請檢查您的配置和錯誤日誌文件。',
        'The syntax of this email address is incorrect.' => '該郵件地址語法錯誤。',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => '客戶',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => '用戶',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => '切換激活狀態給全部',
        'Active' => '啟用',
        'Toggle active state for %s' => '切換激活狀態給%s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '您可能通過配置参數"CustomerGroupAlwaysGroups"定義默認組。',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => '修改默認服務',
        'Filter for Services' => '過濾服務',
        'Filter for services' => '',
        'Services' => '服務',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '動態字段管理',
        'Add new field for object' => '為對象添加新的字段',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => '數據庫',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '動態字段列表',
        'Dynamic fields per page' => '每頁動態字段個數',
        'Label' => '標記',
        'Order' => '順序',
        'Object' => '對象',
        'Delete this field' => '刪除這個字段',

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
        'Dynamic Fields' => '動態字段',
        'Go back to overview' => '返回概況',
        'General' => '常規',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '這個字段是必需的，且它的值只能是字母和數字。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '必須是唯一的且只有接受字母和數字字符',
        'Changing this value will require manual changes in the system.' =>
            '只能對數據庫中直接操作才能修改這個值',
        'This is the name to be shown on the screens where the field is active.' =>
            '標記值作為字段名稱顯示在屏幕上',
        'Field order' => '字段順序',
        'This field is required and must be numeric.' => '這個字段是必需的且必須是數字',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '決定動態字段在屏幕上的顯示順序',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => '字段類型',
        'Object type' => '對象類型',
        'Internal field' => '内置字段',
        'This field is protected and can\'t be deleted.' => '這是内置字段，不能刪除它。',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => '字段設置',
        'Default value' => '默認值',
        'This is the default value for this field.' => '此值是字段的默認值',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => '鍵',
        'Value' => '值',
        'Remove value' => '刪除值',
        'Add Field' => '',
        'Add value' => '添加值',
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
        'Translatable values' => '可翻譯的值',
        'If you activate this option the values will be translated to the user defined language.' =>
            '激活此項，將用自定義的語言翻譯字段值',
        'Note' => '備註',
        'You need to add the translations manually into the language translation files.' =>
            '需要您手動將翻譯内容添加到翻譯文件中',

        # Template: AdminDynamicFieldDB
        'Possible values' => '可選值',
        'Datatype' => '',
        'Filter' => '過濾器',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => '顯示鏈接',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '可以為字段值指定一個可選的HTTP鏈接，以便其顯示在工單概況和工單詳情中。',
        'Example' => '範例',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => '',
        'Driver' => '',
        'Server' => '',
        'Port' => '',
        'Table / View' => '',
        'User' => '用戶',
        'Password' => '密碼',
        'Identifier' => '標識符',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => '多選',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '默認的日期差',
        'This field must be numeric.' => '字段值必須是數字字符',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '用“此刻”的時差(秒)計算默認值(例如，3600或-60)',
        'Define years period' => '定義年期',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '啟用此選項來定義固定的年份範圍 (過去和未來), 用於顯示在此字段的年份中.',
        'Years in the past' => '過去的幾年',
        'Years in the past to display (default: 5 years).' => '顯示過去的幾年 (默認: 5年)',
        'Years in the future' => '未來的幾年',
        'Years in the future to display (default: 5 years).' => '顯示未來的幾年 (默認: 5年)',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => '日期限制輸入',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此選項, 創建可選擇的空值.',
        'Tree View' => '樹狀視圖',
        'Activate this option to display values as a tree.' => '激活此項，將以樹狀形式顯示值',

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
        'Fields' => '字段',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => '概況',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '利用鼠標拖放動作還可以對元素進行排序。',
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
        'Reset' => '重置',

        # Template: AdminDynamicFieldText
        'Number of rows' => '行數',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '定義編輯窗口的行數',
        'Number of cols' => '列寬',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '定義編輯窗口的列寬',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => '出錯信息',
        'Add RegEx' => '',

        # Template: AdminDynamicFieldTitle
        'Template' => '模板',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => '大小',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => '這個字段是必需的',
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
            '通過此模塊，管理員可以按組和角色給服務人員和用戶發送消息。',
        'Create Administrative Message' => '創建管理員通知',
        'Your message was sent to' => '您的信息已被發送到',
        'From' => '發件人',
        'Send message to users' => '發送信息給註冊用戶',
        'Send message to group members' => '發送信息到組成員',
        'Group members need to have permission' => '組成員需要權限',
        'Send message to role members' => '發送信息到角色成員',
        'Also send to customers in groups' => '同樣發送到該組的用戶',
        'Body' => '内容',
        'Send' => '發送',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => '最後運行',
        'Run Now!' => '現在運行!',
        'Delete this task' => '刪除這個任務',
        'Run this task' => '執行這個任務',
        'Job Settings' => '任務設置',
        'Job name' => '任務名稱',
        'The name you entered already exists.' => '您輸入的名稱已經存在。',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => '按計劃執行',
        'Schedule minutes' => '分',
        'Schedule hours' => '時',
        'Schedule days' => '日',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            '目前該計劃任務不會自動運行',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要啟用自動執行，則需選擇分鐘，時間或天',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => '事件觸發器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '刪除這個事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '此外，為了让此任務定期反復地執行，您需要定義工單事件，以便觸發任務的執行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工單事件被觸發，工單過濾器將對工單進行檢查看其條件是否匹配。任務只對匹配的工單發生作用。',
        'Do you really want to delete this event trigger?' => '您確定要刪除這個事件觸發器嗎？',
        'Add Event Trigger' => '添加事件觸發器',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => '選取工單',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer user ID' => '',
        '(e. g. U5150)' => '例如: U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文檢索（例如："Mar*in" or "Baue*"）',
        'To' => '收件人',
        'Cc' => '抄送',
        'Service' => '服務',
        'Service Level Agreement' => '服務水平協議',
        'Queue' => '隊列',
        'State' => '狀態',
        'Agent' => '服務人員',
        'Owner' => '所有者',
        'Responsible' => '負責人',
        'Ticket lock' => '工單鎖定',
        'Dynamic fields' => '動態字段',
        'Add dynamic field' => '',
        'Create times' => '創建時間',
        'No create time settings.' => '沒有創建時間。',
        'Ticket created' => '工單創建時間(相對)',
        'Ticket created between' => '工單創建時間(絕對)',
        'and' => '及',
        'Last changed times' => '最後更新時間',
        'No last changed time settings.' => '沒有最後更新時間設定',
        'Ticket last changed' => '最後更新的工單',
        'Ticket last changed between' => '',
        'Change times' => '修改時間',
        'No change time settings.' => '沒有修改時間',
        'Ticket changed' => '修改工單時間(相對)',
        'Ticket changed between' => '工單修改時間(絕對)',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => '關閉時間',
        'No close time settings.' => '沒有關閉時間',
        'Ticket closed' => '工單關閉時間(相對)',
        'Ticket closed between' => '工單關閉時間(絕對)',
        'Pending times' => '掛起時間',
        'No pending time settings.' => '沒有掛起時間',
        'Ticket pending time reached' => '工單掛起時間(相對)',
        'Ticket pending time reached between' => '工單掛起時間(絕對)',
        'Escalation times' => '升級時間',
        'No escalation time settings.' => '沒有升級時間',
        'Ticket escalation time reached' => '工單升級時間(相對)',
        'Ticket escalation time reached between' => '工單升級時間(絕對)',
        'Escalation - first response time' => '升級 - 第一響應時間',
        'Ticket first response time reached' => '工單升級 - 第一響應時間(相對)',
        'Ticket first response time reached between' => '工單升級 - 第一響應時間(絕對)',
        'Escalation - update time' => '升級 - 更新時間',
        'Ticket update time reached' => '工單升級 - 更新時間(相對)',
        'Ticket update time reached between' => '工單升級 - 更新時間(絕對)',
        'Escalation - solution time' => '升級 - 解決時間',
        'Ticket solution time reached' => '工單升級 - 解決時間(相對)',
        'Ticket solution time reached between' => '工單升級 - 解決時間(絕對)',
        'Archive search option' => '歸檔查詢選項',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => '設置新服務',
        'Set new Service Level Agreement' => '指定服務水平協議',
        'Set new priority' => '指定優先級',
        'Set new queue' => '指定隊列',
        'Set new state' => '指定狀態',
        'Pending date' => '掛起時間',
        'Set new agent' => '指定服務人員',
        'new owner' => '指定所有者',
        'new responsible' => '指定負責人',
        'Set new ticket lock' => '工單鎖定',
        'New customer user ID' => '',
        'New customer ID' => '指定用戶ID',
        'New title' => '指定稱謂',
        'New type' => '指定類型',
        'Archive selected tickets' => '歸檔選中的工單',
        'Add Note' => '添加備註',
        'Visible for customer' => '',
        'Time units' => '時間',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => '給服務人員/用戶發送通知',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '將執行這個命令, 第一個参數是工單 編號，第二個参數是工單的標識符.',
        'Delete tickets' => '刪除工單',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告：所有影響的工單從數據庫刪除，將無法恢復！',
        'Execute Custom Module' => '執行客戶化模塊',
        'Param %s key' => '参數 %s key',
        'Param %s value' => '参數 %s value',
        'Results' => '結果',
        '%s Tickets affected! What do you want to do?' => '%s 個工單將被影響！您確定要這麼做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：您選擇了"刪除"指令。所有刪除的工單數據將無法恢復。',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => '受影響的工單',
        'Age' => '總時長',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => '通用接口Web服務管理',
        'Web Service Management' => '',
        'Debugger' => '調試器',
        'Go back to web service' => '返回到Web服務',
        'Clear' => '刪除',
        'Do you really want to clear the debug log of this web service?' =>
            '您確定要刪除該Web服務的調試日誌嗎？',
        'Request List' => '請求列表',
        'Time' => '時間',
        'Communication ID' => '',
        'Remote IP' => '遠程IP',
        'Loading' => '連載',
        'Select a single request to see its details.' => '選擇一個請求，以便查看其詳細信息。',
        'Filter by type' => '按類型過濾',
        'Filter from' => '按日期過濾(從)',
        'Filter to' => '按日期過濾(至)',
        'Filter by remote IP' => '按遠程IP過濾',
        'Limit' => '限制',
        'Refresh' => '刷新',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => '所有配置數據將丢失。',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => '請為這個Web服務提供一個唯一的名稱。',
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
        'Do you really want to delete this invoker?' => '您確定要刪除這個調用程序嗎？',
        'Invoker Details' => '調用程序詳情',
        'The name is typically used to call up an operation of a remote web service.' =>
            '這個名字通常用於調用遠程web服務的一個操作',
        'Invoker backend' => '調用程序後端',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '這個OTOBO調用程序後端模塊被調用後，負責準備需要發送給遠程系統的數據，並處理它的響應數據。',
        'Mapping for outgoing request data' => '映射出站請求數據',
        'Configure' => '配置',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '這個映射將對OTOBO調用程序輸出的數據進行處理，將它轉換為遠程系統所期待的數據。',
        'Mapping for incoming response data' => '映射入站請求數據',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            '這個映射將對響應數據進行處理，將它轉換為OTOBO調用程序所期待的數據。',
        'Asynchronous' => '異步的',
        'Condition' => '條件',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => '配置事件將觸發這個調用程序。',
        'Add Event' => '添事件',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '選擇事件對象和事件名稱，然後點擊"+"按鈕，即可添加新的事件。',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步事件觸發則是在web請求期間直接處理的。',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => '返回到',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => '條件',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => '條件之間的邏輯關系',
        'Remove this Condition' => '刪除這個條件',
        'Type of Linking' => '鏈接類型',
        'Add a new Field' => '添加新的字段',
        'Remove this Field' => '刪除這個字段',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => '添加新的條件',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '映射簡單',
        'Default rule for unmapped keys' => '未映射鍵的默認規則',
        'This rule will apply for all keys with no mapping rule.' => '這個規則將應用於所有沒有映射規則的鍵。',
        'Default rule for unmapped values' => '未映射值的默認規則',
        'This rule will apply for all values with no mapping rule.' => '這個規則將應用於所有沒有映射規則的值。',
        'New key map' => '新的鍵映射',
        'Add key mapping' => '添加鍵映射',
        'Mapping for Key ' => '',
        'Remove key mapping' => '刪除鍵映射',
        'Key mapping' => '鍵映射',
        'Map key' => '映射鍵',
        'matching the' => '將匹配的',
        'to new key' => '映射到新鍵',
        'Value mapping' => '值映射',
        'Map value' => '映射值',
        'to new value' => '映射到新值',
        'Remove value mapping' => '刪除值映射',
        'New value map' => '新的值映射',
        'Add value mapping' => '添加值映射',
        'Do you really want to delete this key mapping?' => '您確定要刪除這個鍵映射嗎？',

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
        'Do you really want to delete this operation?' => '您確定要刪除這個操作嗎？',
        'Operation Details' => '操作詳情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '這個名稱通常用於從一個遠程系統調用這個web服務操作。',
        'Operation backend' => '操作後端',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            '這個OTOBO操作後端模塊將被調用，以便處理請求、為響應生成數據。',
        'Mapping for incoming request data' => '映射傳入請求數據',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            '這個映射將對請求數據進行處理，將它轉換為OTOBO所期待的數據。',
        'Mapping for outgoing response data' => '映射出站響應數據',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '這個映射將對響應數據進行處理，以便將它轉換成遠程系統所期待的數據。',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => '屬性',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => '消息的最大長度',
        'This field should be an integer number.' => '這個字段值應該是一個整數。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => '端點',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => '驗証',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => '用於訪問遠程系統的用戶名。',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => '特權用戶的密碼。',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => '代理服務器',
        'URI of a proxy server to be used (if needed).' => '代理服務器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '代理用戶',
        'The user name to be used to access the proxy server.' => '訪問代理服務器的用戶名。',
        'Proxy Password' => '代理密碼',
        'The password for the proxy user.' => '代理用戶的密碼。',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => '啟用SSL選項',
        'Show or hide SSL options to connect to the remote system.' => '顯示或隱藏用來連接遠程系統SSL選項。',
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
            '用來驗証SSL証書的認証機構証書文件的完整路徑和名稱。',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '認証機構(CA)目錄',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '認証機構目錄的完整路徑，文件系統中存儲CA証書存儲地方。',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => '',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '默認指令',
        'The default HTTP command to use for the requests.' => '',

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
        'SOAPAction separator' => 'SOAP動作分隔符',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => '命名空間',
        'URI to give SOAP methods a context, reducing ambiguities.' => '為SOAP方法指定URI(通用資源標識符), 以便消除二義性。',
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
            '在這裡您可以指定OTOBO能夠處理的SOAP消息的最大長度(以字節為單位)。',
        'Encoding' => '編碼',
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符編碼',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'Sort options' => '排序選項',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => '名稱必須是唯一的。',
        'Clone' => '克隆',
        'Export Web Service' => '',
        'Import web service' => '導入Web服務',
        'Configuration File' => '配置文件',
        'The file must be a valid web service configuration YAML file.' =>
            '必須是有效的Web服務配置文件(yaml格式)。',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => '導入',
        'Configuration History' => '',
        'Delete web service' => '刪除Web服務',
        'Do you really want to delete this web service?' => '您確定要刪除這個Web服務嗎？',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件後，頁面將再次轉至編輯頁面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果您想返回到概況，請點擊"返回概況"按鈕。',
        'Remote system' => '遠程系統',
        'Provider transport' => '服務提供方傳輸',
        'Requester transport' => '服務請求方傳輸',
        'Debug threshold' => '調試閥值',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            '在提供方模式中，OTOBO為遠程系統提供Web服務。',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            '在請求方模式中，OTOBO使用遠程系統的Web服務。',
        'Network transport' => '網絡傳輸',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            '操作是各種不同的系統功能，可供遠程系統請求調用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '調用程序為請求遠程Web服務准備數據，並其響應的數據進行處理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '刪除這個動作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一個%s的控制器未被激活或根本就不存在，請檢查控制器註冊或刪除這個%s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '歷史',
        'Go back to Web Service' => '返回到Web服務',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '在這裡，您可以查看當前Web服務配置的舊版本，導出或恢復它們。',
        'Configuration History List' => '配置歷史列表',
        'Version' => '版本',
        'Create time' => '創建時間',
        'Select a single configuration version to see its details.' => '選擇一個配置版本，以便查看它的詳細情況。',
        'Export web service configuration' => '導出Web服務配置',
        'Restore web service configuration' => '導入Web服務配置',
        'Do you really want to restore this version of the web service configuration?' =>
            '您確定要恢復Web服務配置的這個版本嗎？',
        'Your current web service configuration will be overwritten.' => '當前的Web服務配置將被覆蓋',

        # Template: AdminGroup
        'Group Management' => '組管理',
        'Add Group' => '添加組',
        'Edit Group' => '編輯組',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'admin組允許使用系統管理模塊，stats組允許使用統計模塊。',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '若要為不同的服務人員分配不同的訪問權限，應創建新的組。(例如，採購部、支持部、銷售部、...)',
        'It\'s useful for ASP solutions. ' => '這對於ASP解決方案它很有用。',

        # Template: AdminLog
        'System Log' => '系統日誌',
        'Here you will find log information about your system.' => '查看系統日誌信息。',
        'Hide this message' => '隱藏此消息',
        'Recent Log Entries' => '最近的日誌',
        'Facility' => '設施',
        'Message' => '訊息',

        # Template: AdminMailAccount
        'Mail Account Management' => '管理郵件接收地址',
        'Add Mail Account' => '添加郵件帳號',
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
        'Host' => '主機',
        'Delete account' => '刪除帳號',
        'Fetch mail' => '查收郵件',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => '範例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夾',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '僅當您打算從其它文件夾(非INBOX)讀取郵件時，才有必要修改此項.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '編輯郵件接收地址',

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
        'Ticket Notification Management' => '工單通知管理',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => '工單過濾',
        'Lock' => '鎖定',
        'SLA' => '服務級別協議',
        'Customer User ID' => '',
        'Article Filter' => '信件過濾器',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article sender type' => '',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => '通知包含附件',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => '發送給服務人員或用戶的通知。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '截取主題的前20個字符（最新的服務人員信件）',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '截取郵件正文内容前5行（最新的服務人員信件）',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '截取郵件主題的前20個字符（最新的用戶信件）',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '截取郵件正文内容前5行（最新的用戶信件）',
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
        'PGP Management' => 'PGP管理',
        'Add PGP Key' => '添加PGP密鑰',
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
            '通過此模塊可以直接編輯在SysConfig中配置的密鑰環。',
        'Introduction to PGP' => 'PGP介紹',
        'Bit' => '位',
        'Fingerprint' => '指紋',
        'Expires' => '過期',
        'Delete this key' => '刪除密鑰',
        'PGP key' => 'PGP密鑰',

        # Template: AdminPackageManager
        'Package Manager' => '軟件包管理',
        'Uninstall Package' => '',
        'Uninstall package' => '卸載軟件包',
        'Do you really want to uninstall this package?' => '是否確認卸載該軟件包?',
        'Reinstall package' => '重新安裝軟件包',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '您確定要重新安裝該軟包嗎? 所有該模塊的手工設置將丢失.',
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
            '如果您還有其它問題，我們非常願意答復您。',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => '安裝軟件包',
        'Update Package' => '',
        'Continue' => '繼續',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '請確認您的數據庫能夠接收大於%sMB的數據包（目前能夠接收的最大數據包為%sMB）。為了避免程序報錯，請調整數據庫max_allowed_packet参數。',
        'Install' => '安裝',
        'Update repository information' => '更新軟件倉庫信息',
        'Cloud services are currently disabled.' => '',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => '在綫軟件倉庫',
        'Vendor' => '提供者',
        'Action' => '操作',
        'Module documentation' => '模塊文檔',
        'Local Repository' => '本地軟件倉庫',
        'This package is verified by OTOBOverify (tm)' => '此軟件包已通過OTOBOverify(tm)的驗証',
        'Uninstall' => '卸載',
        'Package not correctly deployed! Please reinstall the package.' =>
            '軟件包未正確安裝！請重新安裝軟件包。',
        'Reinstall' => '重新安裝',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => '',
        'Download package' => '下載該軟件包',
        'Rebuild package' => '重新編譯',
        'Metadata' => '元數據',
        'Change Log' => '更新記錄',
        'Date' => '日期',
        'List of Files' => '文件清單',
        'Permission' => '權限',
        'Download file from package!' => '從軟件包中下載這個文件',
        'Required' => '必需的',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => '文件跟%s有差異',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日誌',
        'Range' => '範圍',
        'last' => '最後',
        'This feature is enabled!' => '該功能已啟用',
        'Just use this feature if you want to log each request.' => '如果想詳細記錄每個請求, 您可以使用該功能.',
        'Activating this feature might affect your system performance!' =>
            '啟動該功能可能影響您的系統性能',
        'Disable it here!' => '關閉該功能',
        'Logfile too large!' => '日誌文件過大',
        'The logfile is too large, you need to reset it' => '日誌文件太大，請重新初始化。',
        'Interface' => '界面',
        'Requests' => '請求',
        'Min Response' => '最快回應',
        'Max Response' => '最慢回應',
        'Average Response' => '平均回應',
        'Period' => '時長',
        'minutes' => '分鐘',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '郵件過濾器管理',
        'Add PostMaster Filter' => '添加郵件過濾器',
        'Edit PostMaster Filter' => '編輯郵件過濾器',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '基於郵件頭標記的分派或過濾。可以使用正則表達式進行匹配。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '如果您只想匹配某個郵件地址，可以在From、To或Cc中使用EMAILADDRESS:info@example.com這樣的郵件格式。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '如果您使用了正則表達式，您可以取出()中匹配的值，再將它寫入OTOBO標記中(需採用[***]這種格式。)',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => '刪除此過濾器',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => '過濾條件',
        'AND Condition' => '與條件',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '該欄位需使用有效的正則表達式或文字。',
        'Negate' => '求反',
        'Set Email Headers' => '設置郵件頭',
        'Set email header' => '',
        'with value' => '',
        'The field needs to be a literal word.' => '該字段需要輸入文字。',
        'Header' => '信息頭',

        # Template: AdminPriority
        'Priority Management' => '優先級管理',
        'Add Priority' => '添加優先級',
        'Edit Priority' => '編輯優先級',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '過濾流程',
        'Filter for processes' => '',
        'Create New Process' => '創建新的流程',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '您可以上傳流程配置文件，以便將流程配置導入至您的系統中。流程配置文件採用.yml格式，它可以從流程管理模塊中導出。',
        'Upload process configuration' => '上傳流程配置',
        'Import process configuration' => '導入流程配置',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '為了創建新的流程，您可以導入流程配置文件或從新創建它。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '對流程所做的一切修改僅保存在數據庫中。只有執行同步操作後，才會生成或重新生成流程配置文件。',
        'Processes' => '流程',
        'Process name' => '流程名稱',
        'Print' => '打印',
        'Export Process Configuration' => '導出流程配置',
        'Copy Process' => '複製流程',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => '返回',
        'Please note, that changing this activity will affect the following processes' =>
            '請注意，修改這個環節將影響以下流程',
        'Activity' => '環節',
        'Activity Name' => '環節名稱',
        'Activity Dialogs' => '環節操作',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個環節指派環節操作。',
        'Filter available Activity Dialogs' => '過濾可選的環節操作',
        'Available Activity Dialogs' => '可選的環節操作',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => '創建新環節操作',
        'Assigned Activity Dialogs' => '指派的環節操作',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '請注意，修改這個環節操作將影響以下環節',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '請注意，用戶並不能看到或對以下字段時行操作：Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '環節操作',
        'Activity dialog Name' => '環節操作名稱',
        'Available in' => '有效界面',
        'Description (short)' => '描述(簡短)',
        'Description (long)' => '描述(詳細)',
        'The selected permission does not exist.' => '選擇的權限不存在',
        'Required Lock' => '需要鎖定',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '提交建議文本',
        'Submit Button Text' => '提交按鈕文本',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個環節操作指派字段。',
        'Filter available fields' => '過濾可選的字段',
        'Available Fields' => '可選的字段',
        'Assigned Fields' => '指排的字段',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => '顯示',

        # Template: AdminProcessManagementPath
        'Path' => '路徑',
        'Edit this transition' => '編輯這個轉向',
        'Transition Actions' => '轉向動作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個轉向指派轉向動作。',
        'Filter available Transition Actions' => '過濾可選的轉向動作',
        'Available Transition Actions' => '可選的轉向動作',
        'Create New Transition Action' => '創建新的轉向動作',
        'Assigned Transition Actions' => '指派的轉向動作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '環節',
        'Filter Activities...' => '過濾環節...',
        'Create New Activity' => '創建新的環節',
        'Filter Activity Dialogs...' => '過濾環節操作...',
        'Transitions' => '轉向',
        'Filter Transitions...' => '過濾轉向...',
        'Create New Transition' => '創建新的轉向',
        'Filter Transition Actions...' => '過濾轉向操作...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '編輯流程',
        'Print process information' => '打印流程信息',
        'Delete Process' => '刪除流程',
        'Delete Inactive Process' => '刪除非活動的流程',
        'Available Process Elements' => '可選的流程元素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '通過鼠標拖放動作，可以將左側欄目上方所列的元素放置在右側的畫布中。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '可能將環節拖放至畫布中，以便為流程指派環節。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '為了給環節指派環節操作，需要將左側的環節操作拖放至畫布中的環節上。',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '為了給轉向指派轉向動作，需要將左側轉向動作拖放至轉向標簽上。',
        'Edit Process Information' => '編輯流程信息',
        'Process Name' => '流程名稱',
        'The selected state does not exist.' => '選擇的狀態不存在',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '添加並編輯環節、環節操作和轉向',
        'Show EntityIDs' => '顯示實體編號',
        'Extend the width of the Canvas' => '擴展畫布的寬度',
        'Extend the height of the Canvas' => '擴展畫布的高度',
        'Remove the Activity from this Process' => '從這個流程中刪除該環節',
        'Edit this Activity' => '編輯該環節',
        'Save Activities, Activity Dialogs and Transitions' => '保存環節、環節操作和轉向',
        'Do you really want to delete this Process?' => '您確定要刪除這個流程嗎？',
        'Do you really want to delete this Activity?' => '您確定要刪除這個環節嗎？',
        'Do you really want to delete this Activity Dialog?' => '您確定要刪除這個環節操作嗎？',
        'Do you really want to delete this Transition?' => '您確定要刪除這個轉向嗎？',
        'Do you really want to delete this Transition Action?' => '您確定要刪除這個轉向動作嗎？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您確定要從畫布中刪除這個環節嗎？不保存並退出此窗口可撤銷刪除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您確定要從畫布中刪除這個轉向嗎？不保存並退出此窗口可撤銷刪除操作。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在這裡，您可以創建新的流程。為了使新流程生效，請務必將流程的狀態設置為“激活”，將在完成配置工作後執行同步操作。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => '開始環節',
        'Contains %s dialog(s)' => '包含%s操作',
        'Assigned dialogs' => '指派操作',
        'Activities are not being used in this process.' => '該流程未使用環節',
        'Assigned fields' => '指派字段',
        'Activity dialogs are not being used in this process.' => '該流程未使用環節操作',
        'Condition linking' => '條件鏈接',
        'Transitions are not being used in this process.' => '該流程未使用轉向',
        'Module name' => '模塊名稱',
        'Transition actions are not being used in this process.' => '該流程未使用轉向動作',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '請注意，修改這個轉向將影響以下流程。',
        'Transition' => '轉向',
        'Transition Name' => '轉向名稱',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '請注意，修改這個轉向動作將影響以下流程。',
        'Transition Action' => '轉向動作',
        'Transition Action Name' => '轉向動作名稱',
        'Transition Action Module' => '轉向動作模塊',
        'Config Parameters' => '配置参數',
        'Add a new Parameter' => '添加新的参數',
        'Remove this Parameter' => '刪除這個参數',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => '添加隊列',
        'Edit Queue' => '編輯隊列',
        'Filter for Queues' => '過濾隊列',
        'Filter for queues' => '',
        'A queue with this name already exists!' => '',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => '子隊列',
        'Unlock timeout' => '超時解鎖',
        '0 = no unlock' => '永不解鎖',
        'hours' => '小時',
        'Only business hours are counted.' => '只計算上班時間',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工單被鎖定且在鎖定超時之前未被關閉，則該工單將被解鎖，以便其他服務人員處理該工單.',
        'Notify by' => '超時觸發通知',
        '0 = no escalation' => '0 = 不升級  ',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定義的時間之前，服務人員沒有對新工單添加任何信件(無論是郵件-外部或電話)，該工單將升級.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如用戶通過門戶或郵件發送跟進信件，則對升級更新時間進行復位. 如果在此所定義的時間之前，服務人員沒有對新工單添加任何信件，無論是郵件-外部或電話，該工單將升級.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定義的時間之前，工單未被關閉，該工單將升級.',
        'Follow up Option' => '跟進選項',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果用戶在工單關閉後發送跟進信件，您是允許、拒絕、還是創建新工單?',
        'Ticket lock after a follow up' => '跟進後自動鎖定工單',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果用戶在工單關閉後發送跟進信件，則將該工單鎖定給以前的所有者.',
        'System address' => '系統郵件地址',
        'Will be the sender address of this queue for email answers.' => '回復郵件的發送地址',
        'Default sign key' => '默認回復簽名',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => '回復抬頭',
        'The salutation for email answers.' => '回復郵件中的抬頭',
        'Signature' => '回復簽名',
        'The signature for email answers.' => '回復郵件中的簽名',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理隊列的自動回復',
        'Change Auto Response Relations for Queue' => '設置隊列的自動回復',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => '自動回復',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板與隊列的對應關系',
        'Filter for Templates' => '過濾模板',
        'Filter for templates' => '',
        'Templates' => '模板',

        # Template: AdminRegistration
        'System Registration Management' => '系統註冊管理',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTOBO-ID' => '',
        'Deregister System' => '取消系統註冊',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '取消系統註冊',
        'Overview of registered systems' => '註冊系統概述',
        'This system is registered with OTOBO Team.' => '',
        'System type' => '系統類型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '與註冊服務器上一次的通訊',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'OTOBO-ID登陸',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => '閱讀全部',
        'You need to log in with your OTOBO-ID to register your system.' =>
            '為了註冊系統，需要您先使用OTOBO-ID進行登陸。',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'OTOBO-ID是您的一個郵件地址，用於在OTOBO.com網頁進行註冊和登陸。',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '系統註冊有什麼好處?',
        'You will receive updates about relevant security releases.' => '您將及時收到有關安全版本的更新信息。',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '有助於我們改善服務，因為我們從您處獲得了必要的相關信息。',
        'This is only the beginning!' => '這僅僅是開始！',
        'We will inform you about our new services and offerings soon.' =>
            '我們會向您發布更多服務和產品。',
        'Can I use OTOBO without being registered?' => '如果不進行系統註冊，我還可以使用OTOBO嗎?',
        'System registration is optional.' => '系統註冊是可選的。',
        'You can download and use OTOBO without being registered.' => '不進行註冊，您仍然可以下載和使用OTOBO',
        'Is it possible to deregister?' => '可以取消註冊嗎？',
        'You can deregister at any time.' => '您可以隨時取消系統註冊',
        'Which data is transfered when registering?' => '註冊後，哪些數據會被上傳?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            '域名(FQDN)、OTOBO版本、數據庫、操作系統和Perl版本。',
        'Why do I have to provide a description for my system?' => '為什麼需要我提供有關註冊系統的描述?',
        'The description of the system is optional.' => '註冊系統的描述是可選的。',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '註冊系統描述和類型有助於您識别和管理系統的細節。',
        'How often does my OTOBO system send updates?' => '我的OTOBO系統上傳數據的頻度?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '您的系統將定期向註冊服務器發送更新。',
        'Typically this would be around once every three days.' => '通常這將是大约每3天1次。',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            '',
        'OTOBO-ID' => '',
        'You don\'t have an OTOBO-ID yet?' => '還沒有OTOBO-ID嗎？',
        'Sign up now' => '現在註冊',
        'Forgot your password?' => '忘記密碼了嗎？',
        'Retrieve a new one' => '獲取新的密碼',
        'Next' => '下一步',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => '屬性',
        'FQDN' => '',
        'OTOBO Version' => 'OTOBO版本',
        'Operating System' => '操作系統',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '這個系統可選的描述。',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => '註冊',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => '取消註冊',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add Role' => '添加角色',
        'Edit Role' => '編輯角色',
        'Filter for Roles' => '過濾角色',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '創建一個角色並將組加入角色,然後將角色赋給用戶.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '有沒有角色定義. 請使用 \'添加\' 按鈕來創建一個新的角色',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色的組權限',
        'Roles' => '角色',
        'Select the role:group permissions.' => '選擇角色:組權限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果沒有選擇，就不會具有任何權限 (任何工單都看不見)',
        'Toggle %s permission for all' => '切換%s權限給全部',
        'move_into' => '',
        'Permissions to move tickets into this group/queue.' => '對於組/隊列中的工單具有 \'轉移隊列\' 的權限',
        'create' => '',
        'Permissions to create tickets in this group/queue.' => '對於組/隊列具有 \'創建工單\' 的權限',
        'note' => '備註',
        'Permissions to add notes to tickets in this group/queue.' => '對於組/隊列具有 \'添加備註\' 的權限',
        'owner' => '',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '對於組/隊列具有 \'所有者\' 的權限',
        'priority' => '優先級',
        'Permissions to change the ticket priority in this group/queue.' =>
            '對於組/隊列中的工單具有 \'更改優先級\' 的權限',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '定義服務人員的角色',
        'Add Agent' => '添加服務人員',
        'Filter for Agents' => '查找服務人員',
        'Filter for agents' => '',
        'Agents' => '服務人員',
        'Manage Role-Agent Relations' => '管理服務人員的角色',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Edit SLA' => '編輯SLA',
        'Add SLA' => '添加SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => '僅可填寫數字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add Certificate' => '添加証書',
        'Add Private Key' => '添加個人私鑰',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => '過濾証書',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => '参見',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '這樣您能夠直接編輯文件系統中的証書和私匙。',
        'Hash' => 'Hash',
        'Create' => '創建',
        'Handle related certificates' => '處理關聯的証書',
        'Read certificate' => '讀取証書',
        'Delete this certificate' => '刪除這個証書',
        'File' => '文件',
        'Secret' => '機密',
        'Related Certificates for' => '關聯証書',
        'Delete this relation' => '刪除這個關聯',
        'Available Certificates' => '可選的証書',
        'Filter for S/MIME certs' => '',
        'Relate this certificate' => '關聯這個証書',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME証書',
        'Certificate Details' => '',
        'Close this dialog' => '關閉該對話',

        # Template: AdminSalutation
        'Salutation Management' => '回復抬頭管理',
        'Add Salutation' => '添加回復抬頭',
        'Edit Salutation' => '編輯回復抬頭',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => '例如',
        'Example salutation' => '這裡有一個範例',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安裝結束後，安全模式通常將被設置',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '系統已啟用，請通過SysConfig啟用安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查詢窗口',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '這裡您可以輸入並運行數據庫SQL的命令。',
        'Options' => '選項',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查詢的語法有一個錯誤，請核對。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少有一個参數丢失，請核對。',
        'Result format' => '結果格式',
        'Run Query' => '執行查詢',
        '%s Results' => '',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => '服務管理',
        'Add Service' => '添加服務',
        'Edit Service' => '編輯服務',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => '子服務',

        # Template: AdminSession
        'Session Management' => '會話管理',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => '所有會話',
        'Agent sessions' => '服務人員會話',
        'Customer sessions' => '用戶會話',
        'Unique agents' => '實際服務人員',
        'Unique customers' => '實際在綫用戶',
        'Kill all sessions' => '终止所有會話',
        'Kill this session' => '终止該會話',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => '會話',
        'Kill' => '终止',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => '回復簽名管理',
        'Add Signature' => '添加回復簽名',
        'Edit Signature' => '編輯回復簽名',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => '簽名範例',

        # Template: AdminState
        'State Management' => '工單狀態管理',
        'Add State' => '添加工單狀態',
        'Edit State' => '編輯工單狀態',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => '注意',
        'Please also update the states in SysConfig where needed.' => '請同時在SysConfig中需要地方更新這些狀態。',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => '工單狀態類型',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Currently this data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => '發件人',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => '詳情',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '郵件發送地址管理',
        'Add System Email Address' => '添加郵件發送地址',
        'Edit System Email Address' => '編輯郵件發送地址',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '對於所有接收到的郵件，如果在其郵件中的To或Cc中出現了這些郵件發送地址，則將接收到的郵件分派給郵件發送地址所指定的隊列中。',
        'Email address' => '郵件發送地址',
        'Display name' => '名稱',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            '郵件地址和名稱將在郵件中顯示。',
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
        'by' => '由',
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
        'Category' => '類别',
        'Run search' => '搜索',

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
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => '',
        'Delete System Maintenance' => '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => '日期無效!',
        'Login message' => '',
        'This field must have less then 250 characters.' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => '添加模板',
        'Edit Template' => '編輯模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板中的正文幫助服務人員快速始建、回復或轉發工單。',
        'Don\'t forget to add new templates to queues.' => '别忘了將新模板指派給隊列',
        'Attachments' => '附件',
        'Delete this entry' => '刪除該條目',
        'Do you really want to delete this template?' => '你確定要删除這個模板嗎？',
        'A standard template with this name already exists!' => '',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '模板舉例',
        'The current ticket state is' => '當前工單狀態是',
        'Your email address is' => '您的郵件地址是',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => '切換激活全部',
        'Link %s to selected %s' => '鏈接%s到選中的%s',

        # Template: AdminType
        'Type Management' => '工單類型管理',
        'Add Type' => '添加工單類型',
        'Edit Type' => '編輯工單類型',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => '',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => '服務人員管理',
        'Edit Agent' => '編輯服務人員',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => '處理工單是服務人員職責。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了為服務人員指派組或角色權限！',
        'Please enter a search term to look for agents.' => '請輸入一個搜索條件以便查找服務人員。',
        'Last login' => '最後一次登錄',
        'Switch to agent' => '切換服務人員',
        'Title or salutation' => '',
        'Firstname' => '名',
        'Lastname' => '姓',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '如果為空，將自動生成密碼。',
        'Mobile' => '手機',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '定義服務人員的組權限',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '行事曆管理',
        'Add Appointment' => '增加預約',
        'Today' => '今天',
        'All-day' => '全日',
        'Repeat' => '重複',
        'Notification' => '系統通知',
        'Yes' => '是',
        'No' => '否',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '基本資訊',
        'Date/Time' => '日期/時間',
        'Invalid date!' => '無效日期!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => '天',
        'week(s)' => '週',
        'month(s)' => '月',
        'year(s)' => '年',
        'On' => '開啟',
        'Monday' => '星期一',
        'Mon' => '一',
        'Tuesday' => '星期二',
        'Tue' => '三月',
        'Wednesday' => '星期三',
        'Wed' => '星期三',
        'Thursday' => '星期四',
        'Thu' => '收件人',
        'Friday' => '星期五',
        'Fri' => '五',
        'Saturday' => '星期六',
        'Sat' => '六',
        'Sunday' => '星期天',
        'Sun' => '日',
        'January' => '一月',
        'Jan' => '一月',
        'February' => '二月',
        'Feb' => '二月',
        'March' => '三月',
        'Mar' => '三月',
        'April' => '四月',
        'Apr' => '四月',
        'May_long' => '五月',
        'May' => '五月',
        'June' => '六月',
        'Jun' => '六月',
        'July' => '七月',
        'Jul' => '七月',
        'August' => '八月',
        'Aug' => '八月',
        'September' => '九月',
        'Sep' => '九月',
        'October' => '十月',
        'Oct' => '十月',
        'November' => '十一月',
        'Nov' => '十一月',
        'December' => '十二月',
        'Dec' => '十二月',
        'Relative point of time' => '',
        'Link' => '鏈接',
        'Remove entry' => '刪除條目',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '用戶信息中心',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '用戶',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：用戶是無效的！',
        'Start chat' => '',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => '搜索模板',
        'Create Template' => '創建模板',
        'Create New' => '創建',
        'Save changes in template' => '保存變更為模板',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => '增加另一個搜索條件',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '選擇全部',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '修改搜索選項',

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
        'Dashboard' => '儀表板',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => '明天',
        'Soon' => '',
        '5 days' => '',
        'Start' => '開始',
        'none' => '無',

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Save settings' => '保存設置',
        'Close this widget' => '關閉此工具',
        'more' => '更多',
        'Available Columns' => '可選擇的字段',
        'Visible Columns (order by drag & drop)' => '顯示的字段(通過拖拽可調整順序)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => '處理中',
        'Closed' => '已關閉',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升級的工單',
        'Open tickets' => '處理中的工單',
        'Closed tickets' => '已關閉的工單',
        'All tickets' => '所有工單',
        'Archived tickets' => '歸檔的工單',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => '電話工單',
        'Email ticket' => '郵件工單',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is 可用！',
        'Please update now.' => '請現在更新',
        'Release Note' => '版本說明',
        'Level' => '級别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '發布於%s之前',

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
            '正在為您處理統計數據，請耐心等待。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => '我鎖定的工單',
        'My watched tickets' => '我訂閱的工單',
        'My responsibilities' => '我負責的工單',
        'Tickets in My Queues' => '我隊列中的工單',
        'Tickets in My Services' => '',
        'Service Time' => '服務時間',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '總計',

        # Template: AgentDashboardUserOnline
        'out of office' => '不在辦公室',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直至',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => '上一步',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => '接收新聞、許可証或者一些動態信息。',
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
        'Change password' => '修改密碼',
        'Current password' => '當前密碼',
        'New password' => '新密碼',
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
        'Edit your preferences' => '編輯個人設置',
        'Personal Preferences' => '個人設置',
        'Preferences' => '個人設置',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '調整您的個人設置，記得按下右邊的儲存按鈕。',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '您可以使用註冊時的電子郵件 %s 來 %s 登記就能變更頭像。
請注意，更換頭像需要一點時間才會生效。',
        'Off' => '關閉',
        'End' => '結束',
        'This setting can currently not be saved.' => '目前無法儲存此設定',
        'This setting can currently not be saved' => '目前無法儲存此設定',
        'Save this setting' => '儲存設定',
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
        'Target' => '目標',
        'Process' => '流程',
        'Split' => '拆分',

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
        'Statistics' => '統計',
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
        'Created by' => '創建人',
        'Changed by' => '修改人',
        'Sum rows' => '行合計',
        'Sum columns' => '列合計',
        'Show as dashboard widget' => '作為儀表板顯示部件',
        'Cache' => '緩存',
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
        'The ticket has been locked' => '工單已鎖定',
        'Undo & close' => '',
        'Ticket Settings' => '工單設置',
        'Queue invalid.' => '',
        'Service invalid.' => '服務無效。',
        'SLA invalid.' => '',
        'New Owner' => '新所有者',
        'Please set a new owner!' => '請指定新的所有者！',
        'Owner invalid.' => '',
        'New Responsible' => '',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => '工單狀態',
        'State invalid.' => '',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Text will also be received by' => '',
        'Text Template' => '文本模板',
        'Setting a template will overwrite any text or attachment.' => '',
        'Invalid time!' => '無效時間!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => '退回到 ',
        'You need a email address.' => '需要一個郵件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一個有效的郵件地址，同時不可以使用本地郵件地址。',
        'Next ticket state' => '工單狀態',
        'Inform sender' => '通知發送者',
        'Send mail' => '發送!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工單批量處理',
        'Send Email' => '發送郵件',
        'Merge' => '合併',
        'Merge to' => '合併到',
        'Invalid ticket identifier!' => '無效的工單標識符!',
        'Merge to oldest' => '合併至最早提交的工單',
        'Link together' => '相互鏈接',
        'Link to parent' => '鏈接到上一級',
        'Unlock tickets' => '工單解鎖',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => '請包括至少一個收件人',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => '刪除工單用戶',
        'Please remove this entry and enter a new one with the correct value.' =>
            '請刪除這個條目並重新輸入一個正確的值。',
        'This address already exists on the address list.' => '地址列表已有這個地址。',
        'Remove Cc' => '刪除Cc',
        'Bcc' => '暗送',
        'Remove Bcc' => '刪除Bcc',
        'Date Invalid!' => '日期無效！',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => '客戶訊息',
        'Customer user' => '用戶',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '創建郵件工單',
        'Example Template' => '',
        'To customer user' => '選擇用戶',
        'Please include at least one customer user for the ticket.' => '請包括至少一個工單用戶。',
        'Select this customer as the main customer.' => '選擇這個用戶作為主用戶',
        'Remove Ticket Customer User' => '刪除工單用戶',
        'From queue' => '隊列',
        'Get all' => '獲取全部',

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
        'CreateTime' => '創建時間',
        'Article' => '信件',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => '您需要使用一個工單編號!',
        'A valid ticket number is required.' => '需要有效的工單編號。',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => '需要有效的郵件地址。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => '新隊列',
        'Move' => '轉移',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => '沒有找到工單數據。',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'Sender' => '發件人',
        'First Response Time' => '第一響應時間',
        'Update Time' => '更新時間',
        'Solution Time' => '解決時間',
        'Move ticket to a different queue' => '將工單轉移到另一個隊列',
        'Change queue' => '更改隊列',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '清除此屏的過濾器',
        'Tickets per page' => '工單數/頁',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => '創建電話工單',
        'Please include at least one customer for the ticket.' => '請包括至少一個工單用戶。',
        'To queue' => '隊列',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => '純文本',
        'Download this email' => '下載該郵件',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '創建流程工單',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Profile link' => '按模板搜索',
        'Output' => '搜索結果顯示為',
        'Fulltext' => '全文',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => '隊列中創建',
        'Lock state' => '鎖定狀態',
        'Watcher' => '訂閱人',
        'Article Create Time (before/after)' => '信件創建時間(相對)',
        'Article Create Time (between)' => '信件創建時間(絕對)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => '工單創建時間(相對)',
        'Ticket Create Time (between)' => '工單創建時間(絕對)',
        'Ticket Change Time (before/after)' => '工單更新時間(相對)',
        'Ticket Change Time (between)' => '工單更新時間(絕對)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => '工單關閉時間(相對)',
        'Ticket Close Time (between)' => '工單關閉時間(絕對)',
        'Ticket Escalation Time (before/after)' => '工單升級時間(相對)',
        'Ticket Escalation Time (between)' => '工單升級時間(絕對)',
        'Archive Search' => '歸檔搜索',

        # Template: AgentTicketZoom
        'Sender Type' => '發送人類型',
        'Save filter settings as default' => '將過濾器作為缺省設置並保存',
        'Event Type' => '',
        'Save as default' => '',
        'Drafts' => '',
        'Change Queue' => '改變隊列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中沒有環節操作。',
        'This item has no articles yet.' => '此條目沒有信件。',
        'Ticket Timeline View' => '',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => '添加過濾器',
        'Set' => '設置',
        'Reset Filter' => '重置過濾器',
        'No.' => '編號：',
        'Unread articles' => '未讀信件',
        'Via' => '',
        'Important' => '重要',
        'Unread Article!' => '未讀信件!',
        'Incoming message' => '接收的信息',
        'Outgoing message' => '發出的信息',
        'Internal message' => '内部信息',
        'Sending of this message has failed.' => '',
        'Resize' => '調整大小',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',

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
        'Close this message' => '',
        'Image' => '',
        'PDF' => '',
        'Unknown' => '',
        'View' => '瀏覽',

        # Template: LinkTable
        'Linked Objects' => '已連接的對象',

        # Template: TicketInformation
        'Archive' => '歸檔',
        'This ticket is archived.' => '該工單已歸檔',
        'Note: Type is invalid!' => '',
        'Pending till' => '掛起至',
        'Locked' => '鎖定狀態',
        '%s Ticket(s)' => '',
        'Accounted time' => '所用時間',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '為了保護您的隱私,遠程内容被阻擋。',
        'Load blocked content.' => '載入被阻擋的内容。',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => '您可以',
        'go back to the previous page' => '返回上一頁',

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
        'New Ticket' => '新的工單',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => '詳細錯誤信息',
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => '沒有啟用 JavaScript',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => '提示',
        'The browser you are using is too old.' => '您使用的游覽器太舊了.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 請向您的管理詢問或参考相關文檔.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => '',
        'Login' => '登錄',
        'Your user name' => '您的用戶名',
        'User name' => '用戶名',
        'Your password' => '您的密碼',
        'Forgot password?' => '密碼遺忘?',
        'Your 2 Factor Token' => '',
        '2 Factor Token' => '',
        'Log In' => '登錄',
        'Request Account' => '',
        'Request New Password' => '請求新密碼',
        'Your User Name' => '您的用戶名',
        'A new password will be sent to your email address.' => '新密碼將會發送到您的郵箱中',
        'Create Account' => '創建帳戶',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '稱謂',
        'Your First Name' => '名字',
        'Your Last Name' => '姓',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Logout' => '退出',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => '歡迎！',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => '服務水平協議',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => '頁',
        'Tickets' => '工單',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => '搜索條件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'CustomerID' => '客戶編號',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => '類型',
        'Time Restrictions' => '',
        'No time settings' => '',
        'All' => '全部',
        'Specific date' => '',
        'Only tickets created' => '工單創建於',
        'Date range' => '',
        'Only tickets created between' => '工單創建自',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => '保存為模板',
        'Save as Template' => '保存為模板',
        'Template Name' => '模板名稱',
        'Pick a profile name' => '',
        'Output to' => '輸出為',

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Search Results for' => '搜索結果',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Reply' => '回復',
        'Discard' => '',
        'Ticket Information' => '工單信息',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => '展開信件',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => '警告',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '事件信息',
        'Ticket fields' => '工單字段',

        # Template: Error
        'Send a bugreport' => '發送一個錯誤報告',
        'Expand' => '展開',

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
        'Edit personal preferences' => '編輯個人設置',
        'Personal preferences' => '個人設置',
        'You are logged in as' => '您已登錄為',

        # Template: Installer
        'JavaScript not available' => 'JavaScript沒有啟用',
        'Step %s' => '第 %s 步',
        'License' => '許可証',
        'Database Settings' => '數據庫設置',
        'General Specifications and Mail Settings' => '一般設定和郵件配置',
        'Finish' => '完成',
        'Welcome to %s' => '',
        'Germany' => '',
        'Phone' => '電話',
        'Switzerland' => '',
        'Web site' => '網址',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '外發郵件配置',
        'Outbound mail type' => '外發郵件類型',
        'Select outbound mail type.' => '選擇外發郵件類型。',
        'Outbound mail port' => '外發郵件端口',
        'Select outbound mail port.' => '選擇外發郵件端口。',
        'SMTP host' => 'SMTP服務器',
        'SMTP host.' => 'SMTP服務器。',
        'SMTP authentication' => 'SMTP認証',
        'Does your SMTP host need authentication?' => 'SMTP服務器是否需要驗証？',
        'SMTP auth user' => 'SMTP認証用戶名',
        'Username for SMTP auth.' => 'SMTP認証用戶名。',
        'SMTP auth password' => 'SMTP認証密碼',
        'Password for SMTP auth.' => 'SMTP認証密碼。',
        'Configure Inbound Mail' => '接收郵件配置',
        'Inbound mail type' => '接收郵件類型',
        'Select inbound mail type.' => '選擇接收郵件類型。',
        'Inbound mail host' => '接收郵件服務器',
        'Inbound mail host.' => '接收郵件服務器。',
        'Inbound mail user' => '接收郵件用戶名',
        'User for inbound mail.' => '接收郵件用戶名。',
        'Inbound mail password' => '接收郵件密碼',
        'Password for inbound mail.' => '接收郵件密碼',
        'Result of mail configuration check' => '郵件服務器配置檢查結果',
        'Check mail configuration' => '檢查郵件配置',
        'Skip this step' => '跳過這一步',

        # Template: InstallerDBResult
        'Done' => '確認',
        'Error' => '錯誤',
        'Database setup successful!' => '數據庫設置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安裝類型',
        'Create a new database for OTOBO' => '為OTOBO創建新的數據庫',
        'Use an existing database for OTOBO' => '使用現有的數據庫',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '如果您的數據庫為root設置了密碼，您必須在這裡輸入；否則，該字段為空。',
        'Database name' => '數據庫名稱',
        'Check database settings' => '測試數據庫設置',
        'Result of database check' => '數據庫檢查結果',
        'Database check successful.' => '數據庫檢查完成.',
        'Database User' => '數據庫用戶',
        'New' => '新建',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            '已經為OTOBO系統創建了新的數據庫用戶',
        'Repeat Password' => '重復輸入密碼',
        'Generated password' => '發送自動生成的密碼',

        # Template: InstallerDBmysql
        'Passwords do not match' => '密碼不匹配',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '為了能夠使用OTOBO, 您必須以root身份輸入以下行在命令行中(Terminal/Shell).',
        'Restart your webserver' => '請重啟您web服務器.',
        'After doing so your OTOBO is up and running.' => '完成後，您可以啟動OTOBO系統了.',
        'Start page' => '開始頁面',
        'Your OTOBO Team' => '您的OTOBO小組.',

        # Template: InstallerLicense
        'Don\'t accept license' => '不同意',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => '系統ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '每個工單和HTTP會話ID包含系統標識符。',
        'System FQDN' => '系統全稱域名',
        'Fully qualified domain name of your system.' => '系統FQDN（全稱域名）',
        'AdminEmail' => '管理員地址',
        'Email address of the system administrator.' => '系統管理員郵件地址。',
        'Organization' => '組織',
        'Log' => '日誌',
        'LogModule' => '日誌模塊',
        'Log backend to use.' => '日誌後台使用。',
        'LogFile' => '日誌文件',
        'Webfrontend' => 'Web 前端',
        'Default language' => '默認語言',
        'Default language.' => '默認語言',
        'CheckMXRecord' => '檢查MX記錄',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '手動輸入的電子郵件地址將通過DNS服務器驗証MX記錄。如果DNS服務器響應慢或無法提供公網解析，請不要使用此選項。',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => '對象#',
        'Add links' => '添加鏈接',
        'Delete links' => '刪除鏈接',

        # Template: Login
        'Lost your password?' => '忘記密碼?',
        'Back to login' => '重新登錄',

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
        'Message of the Day' => '今日消息',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => '沒有足夠的權限',
        'Back to the previous page' => '返回前一頁',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => '首頁',
        'Show previous pages' => '前一頁',
        'Show page %s' => '第 %s 頁',
        'Show next pages' => '後一頁',
        'Show last page' => '尾頁',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一個可以顯示的圖像!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => '',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => '通知服務人員',

        # Template: PublicDefault
        'Welcome' => '歡迎',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '權限',
        'You can select one or more groups to define access for different agents.' =>
            '可選中一個或多個組以便定義不同服務人員。',
        'Result formats' => '',
        'Time Zone' => '時區',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '緩存結果',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '將該統計作為部件顯示在儀表板中.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => '如果設置為無效，將無法生成統計。',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '設定X軸',
        'X-axis' => 'X軸',
        'Configure Y-Axis' => '設定Y軸',
        'Y-axis' => 'Y軸',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '請只選擇一個元素或使“固定”復選框未被選中。',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => '格式',
        'Exchange Axis' => '轉換軸',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => '沒有被選参數',
        'Scale' => '時間刻度',
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
        'OTOBO Test Page' => 'OTOBO測試頁',
        'Unlock' => '解鎖',
        'Welcome %s %s' => '歡迎 %s %s',
        'Counter' => '計數器',

        # Template: Warning
        'Go back to the previous page' => '返回前一頁',

        # JS Template: CalendarSettingsDialog
        'Show' => '顯示',

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
        'Finished' => '完成',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => '添加新條目',

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
        'CustomerIDs' => '客戶編號',
        'Fax' => '傳真',
        'Street' => '街道',
        'Zip' => '郵編',
        'City' => '城市',
        'Country' => '國家',
        'Mr.' => '先生',
        'Mrs.' => '女士',
        'Address' => '地址',
        'View system log messages.' => '查看系統日誌信息',
        'Edit the system configuration settings.' => '編輯系統配置。',
        'Update and extend your system with software packages.' => '更新或安裝系統的軟件包或模塊.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '數據庫中的ACL信息與系統配置不一致，請部署所有ACL。',
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
        'Please contact the administrator.' => '請聯繫系統管理員',
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
        'Notification added!' => '通知已被添加!',
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
        'Notification updated!' => '通知已被更新!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '附件已添加！',

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
        'Failed' => '失敗',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => '除錯',
        'Info' => '詳情',
        'Warn' => '',
        'days' => '天',
        'day' => '天',
        'hour' => '小時',
        'minute' => '分鐘',
        'seconds' => '秒',
        'second' => '秒',

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
        'Customer company updated!' => '用戶單位已更新！',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '客戶公司 %S 已經存在!',
        'Customer company added!' => '用戶單位已添加！',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '用戶已更新！',
        'New phone ticket' => '創建電話工單',
        'New email ticket' => '創建郵件工單',
        'Customer %s added' => '用戶%s已添加',
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
        'Currently' => '現時',
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
        'minute(s)' => '分鐘',
        'hour(s)' => '小時',
        'Time unit' => '時間單位',
        'within the last ...' => '在過去的...',
        'within the next ...' => '在接下來的...',
        'more than ... ago' => '...之前',
        'Unarchived tickets' => '未歸檔的工單',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => '升序',
        'descending' => '降序',

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
        '10 minutes' => '10 分鐘',
        '15 minutes' => '15 分鐘',
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
        'String' => '字串',
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
        'Need Name!' => '需要名稱!',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '無法讀取 %S!',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTOBO as provider' => 'OTOBO作為服務提供方',
        'Operations' => '',
        'OTOBO as requester' => 'OTOBO作為服務請求方',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '組已更新！',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '郵件帳號已添加！',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => '按收件人(To:)分派.',
        'Dispatching by selected Queue.' => '按所選隊列分派.',

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
        'Priority added!' => '優先級已添加!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '數據庫中的流程管理信息與系統配置不一致，請同步所有流程。',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '是 (必須)',
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
        'Activity not found!' => '沒有找到活動!',
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
        'Agent Interface' => '服務員界面',
        'Customer Interface' => '客戶界面',
        'Agent and Customer Interface' => '服務員及客戶界面',
        'Do not show Field' => '不要顯示字段',
        'Show Field' => '顯示字段',
        'Show Field As Mandatory' => '顯示字段為必須',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '編輯路徑',

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
        'Queue updated!' => '隊列已更新！',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-無-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '為模板設置隊列',
        'Change Template Relations for Queue' => '為隊列設置模板',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '生產',
        'Test' => '',
        'Training' => '培訓',
        'Development' => '開發',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '角色已更新！',
        'Role added!' => '角色已添加！',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => '選擇此角色具有的組權限',
        'Change Role Relations for Group' => '選擇此組具有的角色權限',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => '選擇此服務人員的角色',
        'Change Agent Relations for Role' => '選擇此角色的服務人員',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '請首先激活%s！',

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
        'Signature updated!' => '簽名已更新!',
        'Signature added!' => '簽名已添加!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '狀態已添加！',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '系統郵件地址已添加！',

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
        'Template updated!' => '模板已被更新!',
        'Template added!' => '模板已被添加!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '為模板指定附件',
        'Change Template Relations for Attachment' => '為附件指定模板',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => '類型已添加！',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '服務人員已更新！',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '選擇此服務人員具備的組權限',
        'Change Agent Relations for Group' => '為此組選擇服務人員的權限',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '月',
        'Week' => '週',
        'Day' => '日',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '每天',
        'Every Week' => '每週',
        'Every Month' => '每月',
        'Every Year' => '每年',
        'Custom' => '自訂',
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
        'Customer History' => '客戶歷史',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '統計',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '客戶名稱',
        'Customer User Name' => '用戶名',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '您需要唯讀權限!',
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
            '只有工單的所有者才能執行此操作。',
        'Please change the owner first.' => '請先更改工單的所有者.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => '沒有主旨',
        'Could not delete draft!' => '',
        'Previous Owner' => '前一個所有者',
        'wrote' => '寫道',
        'Message from' => '來自的訊息',
        'End message' => '結束訊息',

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
        'Address %s replaced with registered customer address.' => '%s地址已被用戶註冊的地址所替換',
        'Customer user automatically added in Cc.' => '用戶被自動地添加到Cc中.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '工單："%s"已創建!',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '系統錯誤!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '下週',
        'Ticket Escalation View' => '工單升級視圖',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => '從轉發的郵件',
        'End forwarded message' => '結束轉發消息',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '更改擁有者!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '新信件',
        'Pending' => '掛起',
        'Reminder Reached' => '提醒時間已過',
        'My Locked Tickets' => '我鎖定的工單',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '沒有權限。',
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '工單已鎖定.',

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
        'The selected process is invalid!' => '所選處理無效！',
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
        'Pending Date' => '掛起時間',
        'for pending* states' => '針對掛起狀態',
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
        'Available tickets' => '未鎖定的工單',
        'including subqueues' => '',
        'excluding subqueues' => '',
        'QueueView' => '隊列視圖',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '我負責的工單',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '上次搜索',
        'Untitled' => '',
        'Ticket Number' => '工單編號',
        'Ticket' => '工單',
        'printed by' => '打印',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '無效的用戶',
        'Normal' => '普通',
        'CSV' => '',
        'Excel' => '',
        'in more than ...' => '...內',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '沒有啓用功能!',
        'Service View' => '服務檢閱模式',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => '狀態視圖',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '我訂閱的工單',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '功能尚未啟用',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '已刪除的連結',
        'Ticket Locked' => '已鎖定的工單',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => '已創建的工單',
        'Type Updated' => '已更新的類型',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => ' 已更新的客戶',
        'Internal Chat' => '',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => '',
        'Note Added (Customer)' => '',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => '已更新的狀態',
        'Outgoing Answer' => '',
        'Service Updated' => '已更新的服務',
        'Link Added' => '已添加的連結',
        'Incoming Customer Email' => '',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => '外發電郵',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => '打出的電話通話',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => '打進的電話通話',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '自動回覆已發送',
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
        'Forward article via mail' => '通過郵件轉發信件',
        'Forward' => '轉發',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => '顯示單一信件',
        'Show all articles' => '顯示所有信件',
        'Show Ticket Timeline View' => '',

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
        'My Tickets' => '我的工單',
        'Company Tickets' => '單位工單',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '客戶真實名稱',
        'Created within the last' => '在過去的...創建',
        'Created more than ... ago' => '在...之前創建',
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
        'Install OTOBO' => '安裝OTOBO',
        'Intro' => '介紹',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => '數據庫選擇',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => '輸入數據庫用戶密碼。',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => '輸入數據庫管理員密碼。',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => '創建數據庫',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '聯系您的管理員!',
        'System Settings' => '數據庫設置 ',
        'Syslog' => '',
        'Configure Mail' => '配置郵件',
        'Mail Configuration' => '郵件配置',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => '數據庫中已包含數據 - 應該刪除它！',
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
        'Chat' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '',
        'Bounce' => '退回',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '回復所有',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '拆分信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => '純文本格式',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '打印信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '標記',
        'Unmark' => '取消標記',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => '已加密',
        'Sent message encrypted to recipient!' => '',
        'Signed' => '已簽名',
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
        'Sign' => '簽名',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '顯示',
        'Refresh (minutes)' => '',
        'off' => '關閉',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '顯示用戶',
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
        'Shown Tickets' => '顯示工單',
        'Shown Columns' => '顯示字段',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '最近7天統計',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => '標準',
        'The following tickets are not updated: %s.' => '',
        'h' => '時',
        'm' => '分',
        'd' => '天',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => '這是一個',
        'email' => 'E-Mail',
        'click here' => '點擊這裡',
        'to open it in a new window.' => '在新窗口中打開它',
        'Year' => '年',
        'Hours' => '小時',
        'Minutes' => '分鐘',
        'Check to activate this date' => '選中它，以便設置這個日期',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => '無權限!',
        'No Permission' => '沒有權限',
        'Show Tree Selection' => '顯示樹狀選單',
        'Split Quote' => '',
        'Remove Quote' => '移除佇列',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '搜尋結果',
        'Linked' => '已鏈接',
        'Bulk' => '批量',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => '精簡',
        'Unread article(s) available' => '未讀信件',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '預約',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => '在綫服務人員：%s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '有更多升級的工單',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '請在設置中選擇並保存您的時區.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => '在綫用戶: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO Daemon未在運行',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '您已設置為不在辦公室，是否取消它?',

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
        'Preferences updated successfully!' => '設置更新成功！',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(進行中)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => '重複新密碼',
        'The current password is not correct. Please try again!' => '當前密碼不正確，請重新輸入！',
        'Please supply your new password!' => '請提供您的新密碼!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            '無法更改密碼，密碼至少需要%s個字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => '無法更改密碼，密碼至少需要1個數字字符！',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '無效',
        'valid' => '有效',
        'No (not supported)' => '不支持',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '選取的日期為無效。',
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
        'second(s)' => '秒',
        'quarter(s)' => '季',
        'half-year(s)' => '半年',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => '值',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '解鎖並釋放工單至隊列',
        'Lock it to work on it' => '鎖定並處理工單',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '取消訂閱',
        'Remove from list of watched tickets' => '取消訂閱此工單',
        'Watch' => '訂閱',
        'Add to list of watched tickets' => '訂閱此工單',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '排序',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => '鎖定工單(未讀信件)',
        'Locked Tickets Reminder Reached' => '鎖定工單(提醒時間已過)',
        'Locked Tickets Total' => '鎖定工單總數',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '負責的工單(未讀信件)',
        'Responsible Tickets Reminder Reached' => '負責的工單(提醒時間已過)',
        'Responsible Tickets Total' => '負責工單總數',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '訂閱工單(未讀信件)',
        'Watched Tickets Reminder Reached' => '訂閱工單(提醒時間已過)',
        'Watched Tickets Total' => '訂閱工單總數',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '系統維護中，請稍後再登入。',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => '超過會話數量，請稍後再試.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '會話無效，請重新登錄.',
        'Session has timed out. Please log in again.' => '會話超時，請重新登錄.',

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
        'before/after' => '相對',
        'between' => '之間',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '此欄位為必須或',
        'The field content is too long!' => '欄位內容過長!',
        'Maximum size is %s characters.' => '最大長度為 %s 字元。',

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
        'not installed' => '沒有安裝',
        'installed' => '已安裝',
        'Unable to parse repository index document.' => '無法解釋軟件倉庫索引文檔',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '軟件倉庫中沒有當前系統版本可用的軟件包。',
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
        'Inactive' => '非活動的',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '無法聯繫註冊伺服器。 請稍後再試。',
        'No content received from registration server. Please try again later.' =>
            '未從註冊伺服器收到回應。 請稍後再試。',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => '帳號密碼錯誤，請重新輸入。',
        'Problems processing server result. Please try again later.' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '總和',
        'week' => '週',
        'quarter' => '季',
        'half-year' => '半年',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '狀態類別',
        'Created Priority' => '創建的優先級',
        'Created State' => '創建的狀態',
        'Create Time' => '創建時間',
        'Pending until time' => '',
        'Close Time' => '關閉時間',
        'Escalation' => '升級',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => '服務人員/所有者',
        'Created by Agent/Owner' => '創建人',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '評估方法',
        'Ticket/Article Accounted Time' => '工單/信件所佔用的時間',
        'Ticket Create Time' => '工單創建時間',
        'Ticket Close Time' => '工單關閉時間',
        'Accounted time by Agent' => '服務人員處理工單所用的時間',
        'Total Time' => '時間總合',
        'Ticket Average' => '工單平均處理時間',
        'Ticket Min Time' => '工單最小處理時間',
        'Ticket Max Time' => '工單最大處理時間',
        'Number of Tickets' => '工單數',
        'Article Average' => '信件平均處理時間',
        'Article Min Time' => '信件最小處理時間',
        'Article Max Time' => '信件最大處理時間',
        'Number of Articles' => '信件數',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => '打印的屬性',
        'Sort sequence' => '排序',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => '編號',
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
        'Days' => '日',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '數據庫大小',
        'Could not determine database size.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '數據庫版本',
        'Could not determine database version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => '',
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
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => ' ',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG 設定',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '日期格式',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '磁碟用量',
        'The partition where OTOBO is located is almost full.' => '',
        'The partition where OTOBO is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => '',
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
        'Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => '',
        'Ticket History Entries' => '',
        'Articles' => '文章',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Open Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => '預設管理員密碼',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '域名',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTOBO partition is not writable.' => '',

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
        'Some packages are not correctly installed.' => '',
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
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '伺服器時區',
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
        'Webserver' => '',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => '並發用戶數',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '',
        'Problem' => '',

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
        'Default' => '默許',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '啟用',
        'Disabled' => '禁用',

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
            '登錄失敗！用戶名或密碼錯誤。',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '成功登出',
        'Feature not active!' => '該功能尚未啟用！',
        'Sent password reset instructions. Please check your email.' => '密碼初始化說明已發送，請檢查郵件。',
        'Invalid Token!' => '無效的標記',
        'Sent new password to %s. Please check your email.' => '新密碼已發送到%s，請檢查郵件。',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '這個e-mail已存在，請登入系統或更改您的密碼。',
        'This email address is not allowed to register. Please contact support staff.' =>
            '這個e-mail不允許註冊，請聯繫技術人員。',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帳戶創建成功。登錄信息發送到%s，請查收郵件。',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => '暫時無效',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => '新建',
        'All new state types (default: viewable).' => '',
        'open' => '處理中',
        'All open state types (default: viewable).' => '',
        'closed' => '已關閉',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => '掛起提醒',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => '自動掛起',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => '已刪除',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => '已合併',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => '成功關閉',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => '失敗關閉',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => '掛起自動關閉+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => '掛起自動關閉-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => '可能',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => '拒絕',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '新工單',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => '自動回復',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => '自動拒絕',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => '自動跟進',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => '自動回復新工單',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => '自動刪除',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1-非常低',
        '2 low' => '2-低',
        '3 normal' => '3-正常',
        '4 high' => '4-高',
        '5 very high' => '5-非常高',
        'unlock' => '未鎖定',
        'lock' => '鎖定',
        'tmp_lock' => '',
        'agent' => '服務人員',
        'system' => '系統',
        'customer' => '用戶單位',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => '工單鎖定超時通知',
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
        'Appointment reminder notification' => '預約提醒通知',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '每當您的預約達到提醒時間時，您將收到通知。',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '添加所有',
        'An item with this name is already present.' => '名稱相同的條目已存在。',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '該條目中包含子條目。您確定要刪除這個條目及其子條目嗎？',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '更多',
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
            '您確定要刪除這個動態字段嗎? 所有關聯的數據將丢失!',
        'Delete field' => '刪除字段',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => '刪除這個事件觸發器',
        'Duplicate event.' => '重複的事件',
        'This event is already attached to the job, Please use a different one.' =>
            '',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '在通訊時發生一個錯誤。',
        'Request Details' => '請求詳細信息',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => '顯示或隱藏該内容.',
        'Clear debug log' => '刪除調試日誌',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => '刪除這個調用程序',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => '刪除這個鍵映射',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '刪除這個操作',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '克隆Web服務',
        'Delete operation' => '刪除操作',
        'Delete invoker' => '刪除調用程序',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告：當您更改\'管理\'組的名稱時，在SysConfig作出相應的變化之前，您將被管理面板鎖住！如果發生這種情況，請用SQL語句把組名改回到\'admin\'',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '您確定要刪除此通知語言？',
        'Do you really want to delete this notification?' => '您確定要刪除此通知？',

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
        'Remove Entity from canvas' => '從畫布中刪除實體',
        'No TransitionActions assigned.' => '沒有轉向動作被指派',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '沒有指派的環節操作。請從左側列表中選擇一個環節操作，並將它拖放到這裡。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能刪除這個環節，因為它是開始環節。',
        'Remove the Transition from this Process' => '從該流程中刪除轉向',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦您使用這個按鈕或鏈接,您將退出這個界面且當前狀態將被自動保存。您想要繼續嗎?',
        'Delete Entity' => '刪除實體',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括這個環節，您不能重復添加環節。',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '畫布上已經有一個未連接的轉向。在設置另一個轉向之前，請先連接這個轉向。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '環節已經使用了這個轉向，您不能重復添加轉向。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路徑已經使用了這個轉向動作，您不能重復添加轉向動作。',
        'Hide EntityIDs' => '隱藏實體編號',
        'Edit Field Details' => '編輯字段詳情',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',

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
        'Loading...' => '加載中...',
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
            '',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => '上一步',
        'Resources' => '',
        'Su' => '日',
        'Mo' => '一',
        'Tu' => '二',
        'We' => '三',
        'Th' => '四',
        'Fr' => '五',
        'Sa' => '六',
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
        'Duplicated entry' => '重復條目',
        'It is going to be deleted from the field, please try again.' => '將自動刪除這個重復的地址，請再試一次。',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '請至少輸入一個搜索條件或 *。',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => '月',
        'Remove active filters for this widget.' => '',

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
            '您已成功變更設定，必須重新加載頁面來使變更生效。
點此重新整理頁面。',
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
        'Do you really want to continue?' => '您確定繼續?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '信件過濾器',
        'Apply' => '應用',
        'Event Type Filter' => '',

        # JS File: Core.Agent
        'Slide the navigation bar' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',

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
        'One or more errors occurred!' => '一個或多個錯誤!',

        # JS File: Core.Installer
        'Mail check successful.' => '郵件配置檢查完成',
        'Error in the mail settings. Please correct and try again.' => '郵件設置錯誤, 請重新修正.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '打開日歷',
        'Invalid date (need a future date)!' => '無效的日期（需使用未來的日期）！',
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
            '如果您現在離開該頁, 所有彈出的窗口也隨之關閉!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一個彈出窗口已經打開，是否繼續關閉？',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '無法打開彈出窗口，請禁用彈出窗口攔截。',

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
        'There are currently no elements available to select from.' => '目前沒有可供選擇的元素。',

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
        'yes' => '是',
        'no' => '否',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => '',
        'Stacked' => '',

        # JS File: OTOBOStackedAreaChart
        'Stream' => '',
        'Expanded' => '',

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
