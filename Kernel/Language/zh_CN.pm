# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2005 zuowei <j2ee at hirain-sh.com>
# Copyright (C) 2008-2010 Never Min <never at qnofae.org>
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>,
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
# Copyright (C) 2011 Martin Liu <liuzh66 at gmail.com> http://martinliu.cn
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
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

package Kernel::Language::zh_CN;

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
    $Self->{Completeness}        = 0.929047619047619;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Actions' => '操作',
        'Create New ACL' => '创建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '导出ACL',
        'Filter for ACLs' => 'ACL过滤器',
        'Just start typing to filter...' => '在此输入过滤字符...',
        'Configuration Import' => '配置导入',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '你可以上传配置文件，以便将ACL导入到系统中。配置文件采用.yml格式，它可以从ACL管理模块中导出。',
        'This field is required.' => '该字段是必须的。',
        'Overwrite existing ACLs?' => '覆盖现有的ACL吗？',
        'Upload ACL configuration' => '上传ACL配置',
        'Import ACL configuration(s)' => '导入ACL配置',
        'Description' => '描述',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '为了创建ACL，你可以导入ACL配置或从头创建一个全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在这里的任何ACL的修改，仅将其保存在系统中。只有在部署ACL后，它才会起作用。',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '注意：列表中的ACL名称排序顺序决定了ACL的执行顺序。如果需要更改ACL的执行顺序，请修改相应的ACL名称。',
        'ACL name' => 'ACL名称',
        'Comment' => '注释',
        'Validity' => '有效性',
        'Export' => '导出',
        'Copy' => '复制',
        'No data found.' => '没有找到数据。',
        'No matches found.' => '没有找到相匹配的.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '编辑ACL %s',
        'Edit ACL' => '编辑ACL',
        'Go to overview' => '返回概览',
        'Delete ACL' => '删除ACL',
        'Delete Invalid ACL' => '删除无效的ACL',
        'Match settings' => '匹配条件',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '为ACL设置匹配条件。\'Properties\'用于匹配工单在内存中的属性\'，而\'PropertiesDatabase\'用于匹配工单在数据库中的属性。',
        'Change settings' => '操作动作',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '当匹配条件满足时执行规定的操作动作。记住：\'Possible\'表示允许(白名单)，\'PossibleNot\'表示禁止(黑名单)。',
        'Check the official %sdocumentation%s.' => '查看 %s 的官方文档 %s。',
        'Show or hide the content' => '显示或隐藏内容',
        'Edit ACL Information' => '编辑ACL信息',
        'Name' => '名称',
        'Stop after match' => '匹配后停止',
        'Edit ACL Structure' => '编辑ACL结构',
        'Save ACL' => '保存访问控制列表',
        'Save' => '保存',
        'or' => 'or（或）',
        'Save and finish' => '保存并完成',
        'Cancel' => '取消',
        'Do you really want to delete this ACL?' => '您真的想要删除这个ACL吗？',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通过填写表单数据实现ACL控制。创建ACL后，就可在编辑模式中添加ACL配置信息。',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '日历管理',
        'Add Calendar' => '添加日历',
        'Edit Calendar' => '编辑日历',
        'Calendar Overview' => '日历概览',
        'Add new Calendar' => '添加新的日历',
        'Import Appointments' => '导入预约',
        'Calendar Import' => '日历导入',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '你可以在这里上传一个配置文件来导入一个日历到系统中。这个文件必须是类似通过日历管理模块导出的.yml格式。',
        'Overwrite existing entities' => '覆盖现有条目',
        'Upload calendar configuration' => '上传日历配置',
        'Import Calendar' => '导入日历',
        'Filter for Calendars' => '日历筛选',
        'Filter for calendars' => '日历过滤器',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '根据组字段，系统通过用户的权限级别来允许用户能够访问的日历。',
        'Read only: users can see and export all appointments in the calendar.' =>
            '只读：用户可以看到和导出日历中所有的预约。',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '转移：用户可以修改日历中的预约，但不能修改选择的日历。',
        'Create: users can create and delete appointments in the calendar.' =>
            '创建：用户可以创建和删除日历中的预约。',
        'Read/write: users can manage the calendar itself.' => '读写：用户可以管理日历。',
        'Group' => '组',
        'Changed' => '修改时间',
        'Created' => '创建时间',
        'Download' => '下载',
        'URL' => '网址',
        'Export calendar' => '导出日历',
        'Download calendar' => '下载日历',
        'Copy public calendar URL' => '复制公共日历网址',
        'Calendar' => '日历',
        'Calendar name' => '日历名称',
        'Calendar with same name already exists.' => '已有同名的日历。',
        'Color' => '颜色',
        'Permission group' => '权限组',
        'Ticket Appointments' => '工单预约',
        'Rule' => '规则',
        'Remove this entry' => '删除该条目',
        'Remove' => '移除',
        'Start date' => '开始时间',
        'End date' => '结束日期',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '使用以下选项缩小能够自动创建工单预约的范围。',
        'Queues' => '队列',
        'Please select a valid queue.' => '请选择一个有效的队列。',
        'Search attributes' => '搜索属性',
        'Add entry' => '添加条目',
        'Add' => '添加',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '定义在这个日历中基于工单数据自动创建预约的规则。',
        'Add Rule' => '添加规则',
        'Submit' => '提交',

        # Template: AdminAppointmentImport
        'Appointment Import' => '预约导入',
        'Go back' => '返回',
        'Uploaded file must be in valid iCal format (.ics).' => '上传文件必须是有效的iCal格式(.ics)。',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '如果此处未列出所需的日历，请确保您至少有“创建”权限。',
        'Upload' => '上传',
        'Update existing appointments?' => '更新已有的预约吗？',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '相同UniqueID的日历中所有已有的预约都会被覆盖。',
        'Upload calendar' => '上传日历',
        'Import appointments' => '导入预约',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '预约通知管理',
        'Add Notification' => '添加通知',
        'Edit Notification' => '编辑通知',
        'Export Notifications' => '导出通知',
        'Filter for Notifications' => '通知过滤器',
        'Filter for notifications' => '通知过滤器',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '在这里你可以上传一个配置文件以便导入预约通知，必须是与预约通知模块导出的文件一样的.yml格式。',
        'Overwrite existing notifications?' => '覆盖现有的通知吗?',
        'Upload Notification configuration' => '上传通知配置',
        'Import Notification configuration' => '导入通知配置',
        'List' => '列表',
        'Delete' => '删除',
        'Delete this notification' => '删除通知',
        'Show in agent preferences' => '在服务人员偏好设置里显示',
        'Agent preferences tooltip' => '服务人员偏好设置提示',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '这个信息将会在服务人员偏好设置屏幕作为这个通知的提示信息显示。',
        'Toggle this widget' => '收起/展开小部件',
        'Events' => 'Events（事件）',
        'Event' => '事件',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '在这里你可以选择哪个事件将会触发这个通知，下面的预约过滤器可以选择符合特定条件的预约。',
        'Appointment Filter' => '预约过滤器',
        'Type' => '类型',
        'Title' => '标题',
        'Location' => '位置',
        'Team' => '团队',
        'Resource' => '资源',
        'Recipients' => '收件人',
        'Send to' => '发送给',
        'Send to these agents' => '发送给服务人员',
        'Send to all group members (agents only)' => '发送给组的所有成员（仅服务人员）',
        'Send to all role members' => '发送给角色的所有成员',
        'Send on out of office' => '不在办公室也发送',
        'Also send if the user is currently out of office.' => '用户设置了不在办公室时仍然发送。',
        'Once per day' => '一天一次',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '每个预约的通知使用选择的方式一天只发送一次。',
        'Notification Methods' => '通知方法',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '这里有几种发送给收件人的方法，请至少选择下面的一种方法。',
        'Enable this notification method' => '启用这个通知方法',
        'Transport' => '传输',
        'At least one method is needed per notification.' => '每个通知至少需要一种方法。',
        'Active by default in agent preferences' => '在服务人员偏好设置中默认激活',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '如果选中这个复选框，即使分配为收件人的服务人员在偏好设置中没有选择接收这个通知，这个通知仍然会发送给该服务人员。',
        'This feature is currently not available.' => '该功能当前不可用。',
        'Upgrade to %s' => '升级到 %s',
        'Please activate this transport in order to use it.' => '请激活此传输方式以使用它。',
        'No data found' => '没有找到数据',
        'No notification method found.' => '没有找到通知方法。',
        'Notification Text' => '通知内容',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '系统中没有或者没有启用这个语言，不需要时可以将通知内容删除。',
        'Remove Notification Language' => '删除通知语言',
        'Subject' => '主题',
        'Text' => '文本',
        'Message body' => '消息正文',
        'Add new notification language' => '添加通知语言',
        'Save Changes' => '保存更改',
        'Tag Reference' => '标签参考',
        'Notifications are sent to an agent.' => '发送给服务人员的通知。',
        'You can use the following tags' => '你可以使用以下的标记',
        'To get the first 20 character of the appointment title.' => '获取预约的前20个字符。',
        'To get the appointment attribute' => '获取预约的属性',
        ' e. g.' => ' 例如：',
        'To get the calendar attribute' => '获取日历的属性',
        'Attributes of the recipient user for the notification' => '通知收件人的属性',
        'Config options' => '系统配置数据',
        'Example notification' => '通知样例',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '额外的收件人邮件地址',
        'This field must have less then 200 characters.' => '这个字段不能超过200个字符。',
        'Article visible for customer' => '信件对客户的可见性',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '如果通知发送给客户或额外的邮件地址时创建一封信件。',
        'Email template' => '邮件模板',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '使用这个模板生成完整的邮件（仅对HTML邮件）。',
        'Enable email security' => '启用电子邮件安全',
        'Email security level' => '电子邮件安全级别',
        'If signing key/certificate is missing' => '如果签名密钥/证书丢失了',
        'If encryption key/certificate is missing' => '如果加密密钥/证书丢失了',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '编辑附件',
        'Filter for Attachments' => '附件过滤器',
        'Filter for attachments' => '附件过滤器',
        'Filename' => '文件名',
        'Download file' => '下载文件',
        'Delete this attachment' => '删除附件',
        'Do you really want to delete this attachment?' => '你是否确定要删除该附件？',
        'Attachment' => '附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自动响应管理',
        'Add Auto Response' => '添加自动响应',
        'Edit Auto Response' => '编辑自动响应',
        'Filter for Auto Responses' => '自动响应过滤器',
        'Filter for auto responses' => '自动响应过滤器',
        'Response' => '回复内容',
        'Auto response from' => '自动响应的发件人',
        'Reference' => 'ACL设置参考',
        'To get the first 20 character of the subject.' => '获取主题的前20个字符。',
        'To get the first 5 lines of the email.' => '获取邮件的前五行。',
        'To get the name of the ticket\'s customer user (if given).' => '获取工单的客户用户名字（如果有）。',
        'To get the article attribute' => '获取邮件的属性信息',
        'Options of the current customer user data' => '客户用户资料属性',
        'Ticket owner options' => '工单所有者属性',
        'Ticket responsible options' => '工单负责人属性',
        'Options of the current user who requested this action' => '工单提交者的属性',
        'Options of the ticket data' => '工单数据属性',
        'Options of ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '动态字段显示名称，用于下拉选择和复选框',
        'Example response' => '自动响应样例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '云服务管理',
        'Support Data Collector' => '支持数据收集工具',
        'Support data collector' => '支持数据收集工具',
        'Hint' => '提示',
        'Currently support data is only shown in this system.' => '当前的支持数据只是在系统中显示。',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => '配置',
        'Send support data' => '发送支持数据',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => '更新',
        'System Registration' => '系统注册',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '注册本系统',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '本系统的系统注册功能已被禁用，请检查你的配置。',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            '请注意：为了使用OTOBO云服务，需要先注册系统。',
        'Register this system' => '注册本系统',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '你可以在这里配置可用的云服务，其与%s的通信是安全的。',
        'Available Cloud Services' => '可用的云服务',

        # Template: AdminCommunicationLog
        'Communication Log' => '通信日志',
        'Time Range' => '时间范围',
        'Show only communication logs created in specific time range.' =>
            '仅显示指定时间范围内创建的通信日志。',
        'Filter for Communications' => '交互筛选',
        'Filter for communications' => '通信过滤器',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '在此屏幕中，你可以看到有关传入和外发通信的概览。',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '你可以通过单击列标题来更改列的排序和顺序。',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '如果你点击不同的条目，你将被重定向到关于此消息的详情屏幕。',
        'Status for: %s' => '%s的状态',
        'Failing accounts' => '失败的帐户',
        'Some account problems' => '一些帐户问题',
        'No account problems' => '没有帐户问题',
        'No account activity' => '没有帐户活动',
        'Number of accounts with problems: %s' => '问题帐户的数量：%s',
        'Number of accounts with warnings: %s' => '报警帐户的数量：%s',
        'Failing communications' => '失败的通信',
        'No communication problems' => '没有通信问题',
        'No communication logs' => '没有通信日志',
        'Number of reported problems: %s' => '报告的问题的数量：%s',
        'Open communications' => '处理通信',
        'No active communications' => '没有活动的通信',
        'Number of open communications: %s' => '处理通信的数量：%s',
        'Average processing time' => '平均处理时间',
        'List of communications (%s)' => '通信清单（%s）',
        'Settings' => '设置',
        'Entries per page' => '每页条目数',
        'No communications found.' => '没有找到通信。',
        '%s s' => '%s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '帐户状态',
        'Back to overview' => '返回总览界面',
        'Filter for Accounts' => '账号筛选',
        'Filter for accounts' => '帐户过滤器',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '你可以通过单击列标题来更改列的排序和顺序。',
        'Account status for: %s' => '%s的帐户状态',
        'Status' => '状态',
        'Account' => '帐户',
        'Edit' => '编辑',
        'No accounts found.' => '没有找到帐户。',
        'Communication Log Details (%s)' => '通信日志详情（%s）',
        'Direction' => '方向',
        'Start Time' => '开始时间',
        'End Time' => '结束时间',
        'No communication log entries found.' => '没有找到通信日志条目。',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '持续',

        # Template: AdminCommunicationLogObjectLog
        '#' => '序号',
        'Priority' => '优先级',
        'Module' => 'Module（模块）',
        'Information' => '信息',
        'No log entries found.' => '没有找到日志条目。',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '通信%s的详情视图开始于%s',
        'Filter for Log Entries' => '日志条目过滤器',
        'Filter for log entries' => '日志条目过滤器',
        'Show only entries with specific priority and higher:' => '仅显示具有特定和更高优先级的条目：',
        'Communication Log Overview (%s)' => '通信日志概览（%s）',
        'No communication objects found.' => '没有找到通信目标。',
        'Communication Log Details' => '通信日志详情',
        'Please select an entry from the list.' => '请从列表中选择一个条目。',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => '连接数据',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => '返回到搜索结果',
        'Select' => '选择',
        'Search' => '搜索',
        'Wildcards like \'*\' are allowed.' => '允许使用通配置符，例如\'*\'。',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => '有效',

        # Template: AdminCustomerCompany
        'Customer Management' => '客户管理',
        'Add Customer' => '添加客户',
        'Edit Customer' => '编辑客户',
        'List (only %s shown - more available)' => '列表 (目前显示%s-显示更多)',
        'total' => '总共',
        'Please enter a search term to look for customers.' => '请输入搜索条件以便检索客户资料.',
        'Customer ID' => '客户ID',
        'Please note' => '请注意',
        'This customer backend is read only!' => '客户后端是只读的！',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '管理客户与组的关系',
        'Notice' => 'Notice（注意）',
        'This feature is disabled!' => '该功能已关闭！',
        'Just use this feature if you want to define group permissions for customers.' =>
            '该功能用于为客户定义权限组。',
        'Enable it here!' => '在这里启用！',
        'Edit Customer Default Groups' => '定义客户的默认组',
        'These groups are automatically assigned to all customers.' => '默认组会自动分配给所有客户。',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '你可能通过配置设置"CustomerGroupCompanyAlwaysGroups"管理这些组。',
        'Filter for Groups' => '组过滤器',
        'Select the customer:group permissions.' => '选择客户:组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果没有选择，就不具备该组的任何权限 (客户不能创建或读取工单)。',
        'Search Results' => '搜索结果',
        'Customers' => '客户',
        'Groups' => '组',
        'Change Group Relations for Customer' => '此客户属于哪些组',
        'Change Customer Relations for Group' => '哪些客户属于此组',
        'Toggle %s Permission for all' => '全部授予/取消 %s 权限',
        'Toggle %s permission for %s' => '授予/取消 %s 权限给 %s',
        'Customer Default Groups:' => '客户的默认组:',
        'No changes can be made to these groups.' => '不能更改默认组.',
        'ro' => 'ro（只读）',
        'Read only access to the ticket in this group/queue.' => '对于组/队列中的工单具有 \'只读\'权限。',
        'rw' => 'rw（读写）',
        'Full read and write access to the tickets in this group/queue.' =>
            '对于组/队列中的工单具有完整的\'读写\'权限。',

        # Template: AdminCustomerUser
        'Customer User Management' => '客户用户管理',
        'Add Customer User' => '添加客户用户',
        'Edit Customer User' => '编辑客户用户',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '工单的客户历史信息需要有客户用户，客户界面登录也需要用客户用户。',
        'List (%s total)' => '列表（总共 %s）',
        'Username' => '用户名',
        'Email' => '邮件地址',
        'Last Login' => '上次登录时间',
        'Login as' => '登陆客户门户',
        'Switch to customer' => '切换到客户',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '这个客户后端是只读的，但可以修改客户的用户首选项！',
        'This field is required and needs to be a valid email address.' =>
            '必须输入有效的邮件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '邮件地址不符合系统配置要求。',
        'This email address failed MX check.' => '该邮件域名的MX记录检查无效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS问题，请检查你的配置和错误日志文件。',
        'The syntax of this email address is incorrect.' => '该邮件地址语法错误。',
        'This CustomerID is invalid.' => '这个客户ID是无效的。',
        'Effective Permissions for Customer User' => '客户用户的有效权限',
        'Group Permissions' => '组权限',
        'This customer user has no group permissions.' => '这个客户用户没有组权限。',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上表显示了客户用户的有效组权限，这个矩阵考虑了所有继承的权限（例如通过客户组）。 注意：此表没有考虑对此表单做了更改但没有提交的内容。',
        'Customer Access' => '客户访问',
        'Customer' => '客户',
        'This customer user has no customer access.' => '这个客户用户没有客户访问权限。',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上表显示了通过权限上下文为客户用户授予的客户访问权限。该矩阵考虑了所有继承的访问权限（例如通过客户组）。注意：此表没有考虑对此表单做了更改但没有提交的内容。',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '管理客户用户和客户的关联',
        'Select the customer user:customer relations.' => '选择客户用户关联的客户。',
        'Customer Users' => '客户用户',
        'Change Customer Relations for Customer User' => '修改客户用户和客户的关联',
        'Change Customer User Relations for Customer' => '修改客户关联的用户',
        'Toggle active state for all' => '全部激活/不激活状态',
        'Active' => 'Active（活动的）',
        'Toggle active state for %s' => '%s 激活/不激活状态',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '管理客户用户与组的关系',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '如果要为客户用户定义组权限，请使用此功能。',
        'Edit Customer User Default Groups' => '编辑客户用户的默认组',
        'These groups are automatically assigned to all customer users.' =>
            '这些组自动分配给所有的客户用户。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '你可能通过配置参数"CustomerGroupAlwaysGroups"定义默认组。',
        'Filter for groups' => '群组筛选',
        'Select the customer user - group permissions.' => '选择客户用户和组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '如果没有选择，就不具备该组的任何权限 (客户用户不能使用工单)。',
        'Customer User Default Groups:' => '客户用户的默认组：',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '管理客户-服务之间的联系',
        'Edit default services' => '修改默认服务',
        'Filter for Services' => '服务过滤器',
        'Filter for services' => '服务过滤器',
        'Services' => '服务',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '动态字段管理',
        'Add new field for object' => '为对象添加新的字段',
        'Filter for Dynamic Fields' => '动态字段过滤器',
        'Filter for dynamic fields' => '动态字段过滤器',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => '数据库',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '使用外部数据库作为此动态字段的可配置数据源。',
        'Web service' => 'Web服务',
        'External web services can be configured as data sources for this dynamic field.' =>
            '外部Web服务可以配置为该动态字段的数据源。',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '此功能允许将（多个）联系人信息添加到工单中。',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '为了增加一个新的字段，从对象列表中选择一个字段类型，对象定义了字段的范围并且不能在创建后修改。',
        'Dynamic Fields List' => '动态字段列表',
        'Dynamic fields per page' => '每页动态字段个数',
        'Label' => '标签',
        'Order' => '订单',
        'Object' => '对象',
        'Delete this field' => '删除这个字段',

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
        'Dynamic Fields' => '动态字段',
        'Go back to overview' => '返回概览',
        'General' => '一般',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '这个字段是必需的，且它的值只能是字母和数字。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '必须是唯一的且只接受字母和数字字符。',
        'Changing this value will require manual changes in the system.' =>
            '更改此值需要在系统中进行手动更改。',
        'This is the name to be shown on the screens where the field is active.' =>
            '这是在激活了该字段的屏幕上显示的名称。',
        'Field order' => '字段顺序',
        'This field is required and must be numeric.' => '这个字段是必需的且必须是数字。',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '这是在激活了该字段的屏幕上显示的顺序。',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '不可能使此条目无效，所有配置设置都必须事先更改。',
        'Field type' => '字段类型',
        'Object type' => '对象类型',
        'Internal field' => '内置字段',
        'This field is protected and can\'t be deleted.' => '这是内置字段，不能删除它。',
        'This dynamic field is used in the following config settings:' =>
            '这个动态字段已用于以下配置设置中：',
        'Field Settings' => '字段设置',
        'Default value' => '默认值',
        'This is the default value for this field.' => '这是该字段的默认值。',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => '键',
        'Value' => '值',
        'Remove value' => '删除值',
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
        'Translatable values' => '可翻译的值',
        'If you activate this option the values will be translated to the user defined language.' =>
            '如果激活此选项，这些值将被转换为用户定义的语言。',
        'Note' => '备注',
        'You need to add the translations manually into the language translation files.' =>
            '您需要将翻译手动添加到语言翻译文件中。',

        # Template: AdminDynamicFieldDB
        'Possible values' => '可能值',
        'Datatype' => '',
        'Filter' => '过滤器',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => '显示链接',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '可以为字段值指定一个可选的HTTP链接，以便其显示在工单概览和工单详情中。',
        'Example' => '样例',
        'Link for preview' => '连接预览',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '如果填写了内容，在工单详情屏幕中当鼠标移动到这个URL上方时将显示URL的预览。请注意：要使这个功能生效，还需要上面的常规URL字段也填写好了内容。',
        'SID' => '实例名',
        'Driver' => '',
        'Server' => '',
        'Port' => '端口',
        'Table / View' => '',
        'User' => '用户',
        'Password' => '密码',
        'Identifier' => '标识符',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => '多选框',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '默认的日期差',
        'This field must be numeric.' => '此字段必须是数字。',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '使用与“此刻”的时差(秒)计算默认值(例如，3600或-60)。',
        'Define years period' => '定义年期',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '激活此选项来定义固定的年份范围(过去的和未来的), 用于显示在此字段的年份中.',
        'Years in the past' => '过去的年数',
        'Years in the past to display (default: 5 years).' => '显示过去的年份 (默认: 5年)。',
        'Years in the future' => '未来的几年',
        'Years in the future to display (default: 5 years).' => '显示未来的年份 (默认: 5年)。',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '如果不应编码特殊字符（&、@、 :、 / 等），请使用“url”代替“uri”过滤器。',
        'Restrict entering of dates' => '限制输入日期',
        'Here you can restrict the entering of dates of tickets.' => '在这里可以限制输入工单日期。',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此选项, 创建可选择的空值.',
        'Tree View' => '树形视图',
        'Activate this option to display values as a tree.' => '激活此选项，将以树状形式显示值。',

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
        'Overview' => '概览',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '利用鼠标拖放动作还可以对元素进行排序。',
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
        'Number of rows' => '行数',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '在编辑模式中指定此字段的高度（行）。',
        'Number of cols' => '列宽',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '定义编辑屏幕的列宽（单位：字符）。',
        'Check RegEx' => '正则表达式检查',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '您可以在这里指定一个正则表达式来检查值是否符合要求，正则表达式将在编辑器的扩展内存中执行。',
        'RegEx' => '正则表达式',
        'Invalid RegEx' => '无效的正则表达式',
        'Error Message' => '错误消息',
        'Add RegEx' => '添加正则表达式',

        # Template: AdminDynamicFieldTitle
        'Template' => '模版',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => '大小',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => '这个字段是必需的',
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
        'Admin Message' => '管理消息',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '通过此模块，管理员可以给服务人员、组或角色发送消息。',
        'Create Administrative Message' => '创建管理员通知',
        'Your message was sent to' => '你的信息已被发送到',
        'From' => '发件人',
        'Send message to users' => '发送信息给注册用户',
        'Send message to group members' => '发送信息到组成员',
        'Group members need to have permission' => '组成员需要权限',
        'Send message to role members' => '发送信息到角色成员',
        'Also send to customers in groups' => '同样发送到该组的客户',
        'Body' => '内容',
        'Send' => '发送',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '自动任务管理',
        'Edit Job' => '编辑任务',
        'Add Job' => '添加任务',
        'Run Job' => '运行任务',
        'Filter for Jobs' => '任务筛选',
        'Filter for jobs' => '任务筛选',
        'Last run' => '最后运行',
        'Run Now!' => '现在运行!',
        'Delete this task' => '删除这个任务',
        'Run this task' => '执行这个任务',
        'Job Settings' => '任务设置',
        'Job name' => '任务名称',
        'The name you entered already exists.' => '你输入的名称已经存在。',
        'Automatic Execution (Multiple Tickets)' => '自动执行(针对多个工单)',
        'Execution Schedule' => '执行计划',
        'Schedule minutes' => '计划的分钟',
        'Schedule hours' => '计划的小时',
        'Schedule days' => '计划的天',
        'Automatic execution values are in the system timezone.' => '自动执行时间在系统时区中的值。',
        'Currently this generic agent job will not run automatically.' =>
            '目前这个自动任务不会自动运行。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要启用自动执行，则需指定执行的分钟、小时和天！',
        'Event Based Execution (Single Ticket)' => '基于事件执行(针对特定工单)',
        'Event Triggers' => '事件触发器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '删除这个事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '作为定期自动执行的补充或替代，您可以定义工单事件来触发这个任务的执行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工单事件被触发，工单过滤器将对工单进行检查看其条件是否匹配。任务只对匹配的工单发生作用。',
        'Do you really want to delete this event trigger?' => '您真的想要删除这个事件触发器吗？',
        'Add Event Trigger' => '添加事件触发器',
        'To add a new event select the event object and event name' => '要添加新事件，请选择事件对象和事件名称',
        'Select Tickets' => '选择工单',
        '(e. g. 10*5155 or 105658*)' => '（例如: 10*5144 或者 105658*）',
        '(e. g. 234321)' => '（例如: 234321）',
        'Customer user ID' => '客户用户ID',
        '(e. g. U5150)' => '（例如: U5150）',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文检索（例如："Mar*in" or "Baue*"）。',
        'To' => '收件人',
        'Cc' => '抄送',
        'Service' => '服务',
        'Service Level Agreement' => '服务级别协议',
        'Queue' => '队列',
        'State' => '状态',
        'Agent' => '服务人员',
        'Owner' => '所有者',
        'Responsible' => '负责人',
        'Ticket lock' => '工单锁定',
        'Dynamic fields' => '动态字段',
        'Add dynamic field' => '添加动态字段',
        'Create times' => '创建时间',
        'No create time settings.' => '没有创建时间。',
        'Ticket created' => '工单创建时间',
        'Ticket created between' => '工单创建时间（在...之间）',
        'and' => 'and（与）',
        'Last changed times' => '最后修改时间',
        'No last changed time settings.' => '没有最后修改时间设置。',
        'Ticket last changed' => '工单最后修改',
        'Ticket last changed between' => '工单最后修改时间（在...之间）',
        'Change times' => '修改时间',
        'No change time settings.' => '没有修改时间设置。',
        'Ticket changed' => '工单修改时间',
        'Ticket changed between' => '工单修改时间（在...之间）',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => '关闭时间',
        'No close time settings.' => '没有关闭时间设置。',
        'Ticket closed' => '工单关闭时间',
        'Ticket closed between' => '工单关闭时间（在...之间）',
        'Pending times' => '挂起时间',
        'No pending time settings.' => '没有挂起时间设置。',
        'Ticket pending time reached' => '工单挂起时间已到',
        'Ticket pending time reached between' => '工单挂起时间（在...之间）',
        'Escalation times' => '升级时间',
        'No escalation time settings.' => '没有升级时间设置。',
        'Ticket escalation time reached' => '工单升级时间已到',
        'Ticket escalation time reached between' => '工单升级时间（在...之间）',
        'Escalation - first response time' => '升级 - 首次响应时间',
        'Ticket first response time reached' => '工单升级 - 首次响应时间已到',
        'Ticket first response time reached between' => '工单升级 - 首次响应时间（在...之间）',
        'Escalation - update time' => '升级 - 更新时间',
        'Ticket update time reached' => '工单升级 - 更新时间已到',
        'Ticket update time reached between' => '工单升级 - 更新时间（在...之间）',
        'Escalation - solution time' => '升级 - 解决时间',
        'Ticket solution time reached' => '工单升级 - 解决时间已到',
        'Ticket solution time reached between' => '工单升级 - 解决时间（在...之间）',
        'Archive search option' => '归档搜索选项',
        'Update/Add Ticket Attributes' => '更新/添加工单属性',
        'Set new service' => '设置新服务',
        'Set new Service Level Agreement' => '设置新的服务级别协议',
        'Set new priority' => '设置新的优先级',
        'Set new queue' => '设置新的队列',
        'Set new state' => '设置新的状态',
        'Pending date' => '挂起时间',
        'Set new agent' => '设置新的服务人员',
        'new owner' => '指定所有者',
        'new responsible' => '指定负责人',
        'Set new ticket lock' => '工单锁定',
        'New customer user ID' => '新建客户用户ID',
        'New customer ID' => '指定客户ID',
        'New title' => '指定标题',
        'New type' => '指定类型',
        'Archive selected tickets' => '归档选中的工单',
        'Add Note' => '添加备注',
        'Visible for customer' => '对客户的可见性',
        'Time units' => '时间单元',
        'Execute Ticket Commands' => '执行工单指令',
        'Send agent/customer notifications on changes' => '给服务人员/客户发送通知',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '将执行这个命令, 第一个参数是工单编号，第二个参数是工单ID。',
        'Delete tickets' => '删除工单',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告：所有影响的工单将从数据库删除，且无法恢复！',
        'Execute Custom Module' => '执行定制模块',
        'Param %s key' => '参数 %s 的键',
        'Param %s value' => '参数 %s 的值',
        'Results' => '结果',
        '%s Tickets affected! What do you want to do?' => '%s 个工单将被影响！你确定要这么做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：你选择了"删除"指令，所有删除的工单都将丢失，无法恢复！',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '警告：%s 个工单将被影响，但一个任务执行时只能修改 %s 个工单！',
        'Affected Tickets' => '受影响的工单',
        'Age' => '总时长',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => '通用接口Web服务管理',
        'Web Service Management' => '管理WEB服务',
        'Debugger' => '调试器',
        'Go back to web service' => '返回到Web服务',
        'Clear' => '清空',
        'Do you really want to clear the debug log of this web service?' =>
            '您真的想要清空该Web服务的调试日志吗？',
        'Request List' => '请求列表',
        'Time' => '时间',
        'Communication ID' => '通信ID',
        'Remote IP' => '远程IP',
        'Loading' => '正在加载',
        'Select a single request to see its details.' => '选择一个请求，以便查看其详细信息。',
        'Filter by type' => '按类型过滤',
        'Filter from' => '按日期过滤(从)',
        'Filter to' => '按日期过滤(到)',
        'Filter by remote IP' => '按远程IP过滤',
        'Limit' => '限制',
        'Refresh' => '刷新',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '添加错误处理',
        'Edit ErrorHandling' => '编辑错误处理',
        'Do you really want to delete this error handling module?' => '你确定要删除这个错误处理模块吗?',
        'All configuration data will be lost.' => '所有配置数据将丢失。',
        'General options' => '一般选项',
        'The name can be used to distinguish different error handling configurations.' =>
            '该名称可用于区分不同的错误处理配置。',
        'Please provide a unique name for this web service.' => '请为这个Web服务提供一个唯一的名称。',
        'Error handling module backend' => '错误处理模块后端',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '这个OTOBO错误处理后端模块将被内部调用以处理错误处理机制。',
        'Processing options' => '处理选项',
        'Configure filters to control error handling module execution.' =>
            '配置过滤器来控制错误处理模块执行。',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '只有匹配所有配置的过滤器（如果有的话）的请求将触发模块执行。',
        'Operation filter' => '操作过滤器',
        'Only execute error handling module for selected operations.' => '只对选定的操作执行错误处理模块。',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '注意：接收传入请求数据时发生错误，操作未确定。 涉及此错误阶段的过滤器不应使用操作过滤器。',
        'Invoker filter' => '调用程序过滤器',
        'Only execute error handling module for selected invokers.' => '只对选定的调用程序执行错误处理模块。',
        'Error message content filter' => '错误消息内容过滤器',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '输入一个正则表达式来限制哪些错误消息应导致错误处理模块执行。',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '将考虑匹配错误消息主题和数据（如调试器错误条目中所示）。',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '示例：输入\'^.*401 Unauthorized.*\$\' ，仅处理与认证相关的错误。',
        'Error stage filter' => '错误阶段过滤器',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '只对特定处理阶段发生的错误执行错误处理模块。',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '示例：仅处理无法应用传出数据映射的错误。',
        'Error code' => '错误代码',
        'An error identifier for this error handling module.' => '该错误处理模块的错误标识符。',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '此标识符将在XSLT映射中可用，并在调试器输出中显示。',
        'Error message' => '错误消息',
        'An error explanation for this error handling module.' => '该错误处理模块的错误说明。',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '此消息将在XSLT映射中可用，并在调试器输出中显示。',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '定义在执行模块后是否应该停止处理，跳过所有剩余的模块，或者只跳过同一个后端的模块。',
        'Default behavior is to resume, processing the next module.' => '默认行为是恢复，处理下一个模块。',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '此模块允许配置失败请求的安排重试次数。',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '通用接口Web服务的默认行为是每个请求仅发送一次，在错误后不再安排发送。',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '如果针对个别请求执行多个能够计划重试的模块，则最后执行的模块是权威性的，并确定是否安排重试。',
        'Request retry options' => '请求重试选项',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '当请求导致错误处理模块执行（基于处理选项）时，将应用重试选项。',
        'Schedule retry' => '安排重试',
        'Should requests causing an error be triggered again at a later time?' =>
            '是否应该在稍后的时间再次触发引起错误的请求？',
        'Initial retry interval' => '初始重试间隔',
        'Interval after which to trigger the first retry.' => '间隔之后触发第一次重试。',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '注意：本次及后期所有的重试间隔都基于初始请求的错误处理模块的执行时间。',
        'Factor for further retries' => '进一步重试的因子',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '如果请求在第一次重试后仍然返回错误，定义是使用相同的间隔时间还是增加间隔时间来触发后续重试。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '示例：如果一个请求的初始间隔为“1分钟”、重试因子为“2”，初始触发在10:00，重试将触发在10:01（1分钟），10:03（2 * 1 = 2 分钟），10:07（2 * 2 = 4分钟），10:15（2 * 4 = 8分钟），...',
        'Maximum retry interval' => '最大重试间隔',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '如果选择重试间隔因子“1.5”或“2”，则可以通过定义允许的最大间隔时间来防止不期望的长间隔时间。',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '计算出超过最大重试间隔的间隔将自动相应缩短。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '示例：示例：如果一个请求的初始时间间隔为“1分钟”，重试因子为“2”，最大间隔为“5分钟”，初始触发在10:00，重试将触发在10:01（1分钟），10 ：03（2分钟），10:07（4分钟），10:12（8 => 5分钟），10:17，...',
        'Maximum retry count' => '最大重试次数',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '失败请求被丢弃之前的最大重试次数，不计入初始请求。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '示例：如果一个请求的初始时间间隔为“1分钟”，重试因子为“2”，最大重试次数为“2”，初始触发在10:00，将仅在10:01和10:03触发重试。',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '注意：如果配置了最大重试时间并且较早到达，则可能无法达到最大重试次数。',
        'This field must be empty or contain a positive number.' => '此字段必须为空或包含正数。',
        'Maximum retry period' => '最大重试时间',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '在丢弃失败请求之前重试的最长时间（基于初始请求的错误处理模块执行时间）。',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '在最大时间段之后正常触发的重试（根据重试间隔计算）将在最大时间段到达时自动触发一次。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '示例：如果一个请求的初始间隔为“1分钟”、重试因子为“2”、最大重试时间为“30分钟”，初始触发在10:00，重试将触发在10:01、10:03、10:07、10:15，最后在10：31 => 10:30触发一次。',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '注意：如果配置了最大重试次数并且较早到达，则可能无法达到最大重试时间。',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '添加调用程序',
        'Edit Invoker' => '编辑调用程序',
        'Do you really want to delete this invoker?' => '您真的想要删除这个调用程序吗？',
        'Invoker Details' => '调用程序详情',
        'The name is typically used to call up an operation of a remote web service.' =>
            '该名称通常用于调用远程Web服务的操作。',
        'Invoker backend' => '调用程序后端',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '这个OTOBO调用程序后端模块被调用后，负责准备需要发送给远程系统的数据，并处理它的响应数据。',
        'Mapping for outgoing request data' => '映射出站请求数据',
        'Configure' => '配置',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对OTOBO调用程序输出的数据进行处理，将它转换为远程系统所期待的数据。',
        'Mapping for incoming response data' => '映射入站请求数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            '这个映射将对响应数据进行处理，将它转换为OTOBO调用程序所期待的数据。',
        'Asynchronous' => '异步',
        'Condition' => '条件',
        'Edit this event' => '编辑这个事件',
        'This invoker will be triggered by the configured events.' => '配置事件将触发这个调用程序。',
        'Add Event' => '添加事件',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '要添加新事件，请选择事件对象和事件名称，然后单击“+”按钮',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '异步的事件触发器将由后端的OTOBO调度程序守护进程处理（推荐）。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步的事件触发器则是在web请求期间直接处理的。',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Web服务%s的通用接口调用程序事件设置',
        'Go back to' => '返回到',
        'Delete all conditions' => '删除所有条件',
        'Do you really want to delete all the conditions for this event?' =>
            '你确定要删除这个事件的所有条件吗？',
        'General Settings' => '常规设置',
        'Event type' => '事件类型',
        'Conditions' => '条件',
        'Conditions can only operate on non-empty fields.' => '条件只能作用于非空字段。',
        'Type of Linking between Conditions' => '条件之间的逻辑关系',
        'Remove this Condition' => '删除这个条件',
        'Type of Linking' => '链接关系',
        'Add a new Field' => '添加新的字段',
        'Remove this Field' => '删除这个字段',
        'And can\'t be repeated on the same condition.' => '同一条件中不能对相同字段使用“和”关系。',
        'Add New Condition' => '添加新的条件',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '简单映射',
        'Default rule for unmapped keys' => '未映射键的默认规则',
        'This rule will apply for all keys with no mapping rule.' => '这个规则将应用于所有没有映射规则的键。',
        'Default rule for unmapped values' => '未映射值的默认规则',
        'This rule will apply for all values with no mapping rule.' => '这个规则将应用于所有没有映射规则的值。',
        'New key map' => '新的键映射',
        'Add key mapping' => '添加键映射',
        'Mapping for Key ' => '键的映射 ',
        'Remove key mapping' => '删除键映射',
        'Key mapping' => '键映射',
        'Map key' => '映射键',
        'matching the' => '将匹配的',
        'to new key' => '映射到新键',
        'Value mapping' => '值映射',
        'Map value' => '映射值',
        'to new value' => '映射到新值',
        'Remove value mapping' => '删除值映射',
        'New value map' => '新的值映射',
        'Add value mapping' => '添加值映射',
        'Do you really want to delete this key mapping?' => '您真的想要删除这个键映射吗？',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '通用快捷键',
        'MacOS Shortcuts' => 'MacOS快捷键',
        'Comment code' => '注释代码',
        'Uncomment code' => '取消注释',
        'Auto format code' => '自动格式化代码',
        'Expand/Collapse code block' => '展开/收起代码块',
        'Find' => '查找',
        'Find next' => '查找下一个',
        'Find previous' => '查找上一个',
        'Find and replace' => '查找并替换',
        'Find and replace all' => '查找并替换所有',
        'XSLT Mapping' => 'XSLT映射',
        'XSLT stylesheet' => 'XSLT样式表',
        'The entered data is not a valid XSLT style sheet.' => '输入的数据不是有效的XSLT样式表。',
        'Here you can add or modify your XSLT mapping code.' => '您可以在此添加或修改XSLT映射代码。',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '编辑字段允许您使用不同的功能，如自动格式化、窗口调整大小以及标签和括号补齐。',
        'Data includes' => '数据包括',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '选择在早期请求/响应阶段创建的一组或多组要包含在可映射数据中的数据集合。',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '这些数据集合将出现在 \'/DataInclude/<DataSetName>\'的数据结构中（有关详细信息，请参阅实际请求的调试器输出）。',
        'Data key regex filters (before mapping)' => '数据键正则表达式过滤器（映射之前）',
        'Data key regex filters (after mapping)' => '数据键正则表达式过滤器（映射之后）',
        'Regular expressions' => '正则表达式',
        'Replace' => '替换',
        'Remove regex' => '移除正则表达式',
        'Add regex' => '添加正则表达式',
        'These filters can be used to transform keys using regular expressions.' =>
            '这些过滤器可用于使用正则表达式转换键。',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '数据结构将递归遍历，所有配置的正则表达式都将应用于所有键。',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '使用案例：例如删除不需要的键前缀或纠正作为XML元素名称无效的键。',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '示例1：搜索= \'^jira:\'/替换= \'\' ，可将 \'jira:element\' 变成\'element\'。',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '示例2：搜索 = \'^\' / 替换 = \'_\' ，可将\'16x16\' 变成\'_16x16\'。',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '示例3：搜索= \'^(?<number>\d+) (?<text>.+?)\$\' / 替换= \'_\$+{text}_\$+{number}\'，可将 \'16 elementname\' 变成 \'_elementname_16\'。',
        'For information about regular expressions in Perl please see here:' =>
            '有关Perl中正则表达式的信息，请参见：',
        'Perl regular expressions tutorial' => 'Perl正则表达式教程',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '如果需要修饰符，则必须在正则表达式中指定它们。',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '这里定义的正则表达式将在XSLT映射之前应用。',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '这里定义的正则表达式将在XSLT映射之后应用。',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '添加操作',
        'Edit Operation' => '编辑操作',
        'Do you really want to delete this operation?' => '您真的想要删除这个操作吗？',
        'Operation Details' => '操作详情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '这个名称通常用于从一个远程系统调用这个web服务操作。',
        'Operation backend' => '操作后端',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            '这个OTOBO操作后端模块将被调用，以便处理请求、生成响应数据。',
        'Mapping for incoming request data' => '映射传入请求数据',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            '这个映射将对请求数据进行处理，将它转换为OTOBO所期待的数据。',
        'Mapping for outgoing response data' => '映射出站响应数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对响应数据进行处理，以便将它转换成远程系统所期待的数据。',
        'Include Ticket Data' => '包含工单数据',
        'Include ticket data in response.' => '在响应中包含工单数据。',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '网络传输',
        'Properties' => '属性',
        'Route mapping for Operation' => '为操作路由映射',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '为这个操作定义获取映射的路由。以“:“作为标记的变量将得到输入名称和其它传递参数的映射。',
        'Valid request methods for Operation' => '操作的有效请求方法',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '限制这个操作使用指定的请求方法。如果没有选择方法，则所有的请求都可以接受。',
        'Maximum message length' => '消息的最大长度',
        'This field should be an integer number.' => '这个字段值应该是一个整数。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '在这里你可以指定OTOBO能够处理的REST消息的最大长度(以字节为单位)。',
        'Send Keep-Alive' => '发送Keep-Alive（保持连接）',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '此配置定义传入的连接应该关闭还是保持连接。',
        'Additional response headers' => '附加响应头',
        'Add response header' => '添加响应头',
        'Endpoint' => '端点',
        'URI to indicate specific location for accessing a web service.' =>
            '用于指示访问Web服务的特定位置的URI。',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '超时',
        'Timeout value for requests.' => '请求的超时值。',
        'Authentication' => 'Authentication（身份验证）',
        'An optional authentication mechanism to access the remote system.' =>
            '用于访问远程系统的可选认证机制。',
        'BasicAuth User' => '基本认证用户',
        'The user name to be used to access the remote system.' => '用于访问远程系统的用户名。',
        'BasicAuth Password' => '基本认证密码',
        'The password for the privileged user.' => '特权用户的密码。',
        'Use Proxy Options' => '使用代理选项',
        'Show or hide Proxy options to connect to the remote system.' => '显示或隐藏连接到远程系统的代理选项。',
        'Proxy Server' => '代理服务器',
        'URI of a proxy server to be used (if needed).' => '代理服务器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '例如：http://proxy_hostname:8080',
        'Proxy User' => '代理用户',
        'The user name to be used to access the proxy server.' => '访问代理服务器的用户名。',
        'Proxy Password' => '代理密码',
        'The password for the proxy user.' => '代理用户的密码。',
        'Skip Proxy' => '跳过代理',
        'Skip proxy servers that might be configured globally?' => '跳过可能已在全局配置的代理服务器吗？',
        'Use SSL Options' => '启用SSL选项',
        'Show or hide SSL options to connect to the remote system.' => '显示或隐藏用来连接远程系统SSL选项。',
        'Client Certificate' => '客户证书',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSL客户端证书文件的完整路径和名称（必须为PEM、DER或PKCS＃12格式）。',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => '例如： /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => '客户证书密钥',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSL客户端证书密钥文件的完整路径和名称（如果尚未包含在证书文件中）。',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => '例如： /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => '客户端证书密钥密码',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '如果密钥被加密，则此密码用于打开SSL证书。',
        'Certification Authority (CA) Certificate' => '认证机构（CA）证书',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '用来验证SSL证书的认证机构证书文件的完整路径和名称。',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => '例如：/opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '认证机构(CA)目录',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '认证机构目录的完整路径，文件系统中存储CA证书的地方。',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => '例如：/opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => '调用程序的控制器映射',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '控制器接受调用程序发送的请求。以“:“作为标记的变量将被数据值和其它传递参数替换。',
        'Valid request command for Invoker' => '调用程序有效的请求命令',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '调用程序用于请求的特定的HTTP命令。',
        'Default command' => '默认命令',
        'The default HTTP command to use for the requests.' => '用于请求的默认HTTP命令。',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '例如： https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => '设置SOAP动作',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '设置为“是”，发送填写了的SOAPAction 头。',
        'Set to "No" in order to send an empty SOAPAction header.' => '设置为“否”，发送空白SOAPAction 头。',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '设置为“是”，检查接收的SOAPAction头（如果不为空）。',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '设置为“否”，忽略接收的SOAPAction标头。',
        'SOAPAction scheme' => 'SOAPAction方案',
        'Select how SOAPAction should be constructed.' => '选择如何构建SOAPAction。',
        'Some web services require a specific construction.' => '某些Web服务需要特定的结构。',
        'Some web services send a specific construction.' => '某些Web服务发送一个特定的构造。',
        'SOAPAction separator' => 'SOAP动作分隔符',
        'Character to use as separator between name space and SOAP operation.' =>
            '用作名称空间和SOAP操作之间的分隔符的字符。',
        'Usually .Net web services use "/" as separator.' => '通常.Net的Web服务使用"/"作为分隔符。',
        'SOAPAction free text' => 'SOAPAction自由文本',
        'Text to be used to as SOAPAction.' => '要用作SOAPAction的文本。',
        'Namespace' => '命名空间',
        'URI to give SOAP methods a context, reducing ambiguities.' => '为SOAP方法指定URI(通用资源标识符), 以便消除二义性。',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => '请求名称方案',
        'Select how SOAP request function wrapper should be constructed.' =>
            '选择如何构建SOAP请求函数封装器。',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '“FunctionName”可用作实际调用程序/操作命名样例。',
        '\'FreeText\' is used as example for actual configured value.' =>
            '“FreeText”可用作实际配置值的样例。',
        'Request name free text' => '请求名称自定义字段',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '用于封装器名称后缀或替换的文本。',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '请考虑XML元素命名的限制（例如：不使用\'<\'和\'&\'）。',
        'Response name scheme' => '回复名称方案',
        'Select how SOAP response function wrapper should be constructed.' =>
            '选择如何构建SOAP回复函数封装器。',
        'Response name free text' => '回复名称自由文本',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            '在这里你可以指定OTOBO能够处理的SOAP消息的最大长度(以字节为单位)。',
        'Encoding' => '编码',
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符编码。',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '例如：utf-8, latin1, iso-8859-1, cp1250等等。',
        'Sort options' => '排序选项',
        'Add new first level element' => '添加新的第一级元素',
        'Element' => '元素',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '出站XML字段的排序顺序（下面的函数名称封装结构）-查看关于SOAP传输的文档。',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '添加Web服务',
        'Edit Web Service' => '编辑Web服务',
        'Clone Web Service' => '克隆Web服务',
        'The name must be unique.' => '名称必须是唯一的。',
        'Clone' => '克隆',
        'Export Web Service' => '导出Web服务',
        'Import web service' => '导入Web服务',
        'Configuration File' => '配置文件',
        'The file must be a valid web service configuration YAML file.' =>
            '必须是有效的Web服务配置文件(YAML格式)。',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '可以在此指定Web服务的名称。 如果此字段为空，则将使用配置文件的名称作为其名称。',
        'Import' => '导入',
        'Configuration History' => '配置历史',
        'Delete web service' => '删除Web服务',
        'Do you really want to delete this web service?' => '您真的想要删除这个Web服务吗？',
        'Ready2Adopt Web Services' => '即开即用的Web服务',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '你可以在这里激活即开即用的WEB服务，作为%s的一部分展示我们的最佳实践。',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '请注意：这些WEB服务可能依赖于其它仅在某些%s合同级别中才可用的模块(导入时会有详细提示信息)。',
        'Import Ready2Adopt web service' => '导入即开即用的WEB服务',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '你想从专家创建的WEB服务中受益吗？升级到%s 就能导入一些复杂的即开即用的WEB服务。',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件后，页面将再次转到编辑页面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果你想返回到概览，请点击"返回概览"按钮。',
        'Remote system' => '远程系统',
        'Provider transport' => '服务提供方传输',
        'Requester transport' => '服务请求方传输',
        'Debug threshold' => '调试阀值',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            '在提供方模式中，OTOBO为远程系统提供Web服务。',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            '在请求方模式中，OTOBO使用远程系统的Web服务。',
        'Network transport' => '网络传输',
        'Error Handling Modules' => '错误处理模块',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '错误处理模块用于在通信过程中发生错误时作出反应。 这些模块以特定的顺序执行，可以通过拖放来更改顺序。',
        'Backend' => '后端',
        'Add error handling module' => '添加错误处理模块',
        'Operations are individual system functions which remote systems can request.' =>
            '操作是各种不同的系统函数，可供远程系统请求调用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '调用程序为请求远程Web服务准备数据，并其响应的数据进行处理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '删除这个动作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一个 %s 的控制器未被激活或根本就不存在，请检查控制器注册或删除这个 %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '历史',
        'Go back to Web Service' => '返回到Web服务',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '在这里，你可以查看当前Web服务配置的旧版本，导出或恢复它们。',
        'Configuration History List' => '配置历史列表',
        'Version' => '版本',
        'Create time' => '创建时间',
        'Select a single configuration version to see its details.' => '选择一个配置版本，以便查看它的详细情况。',
        'Export web service configuration' => '导出Web服务配置',
        'Restore web service configuration' => '导入Web服务配置',
        'Do you really want to restore this version of the web service configuration?' =>
            '您真的想要恢复Web服务配置的这个版本吗？',
        'Your current web service configuration will be overwritten.' => '当前的Web服务配置将被覆盖。',

        # Template: AdminGroup
        'Group Management' => '组管理',
        'Add Group' => '添加组',
        'Edit Group' => '编辑组',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'admin组允许使用系统管理模块，stats组允许使用统计模块。',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '若要为不同的服务人员分配不同的访问权限，应创建新的组。(例如，采购部、支持部、销售部...)。 ',
        'It\'s useful for ASP solutions. ' => '它对ASP解决方案非常有用。 ',

        # Template: AdminLog
        'System Log' => '系统日志',
        'Here you will find log information about your system.' => '查看系统日志信息。',
        'Hide this message' => '隐藏此消息',
        'Recent Log Entries' => '最近的日志条目',
        'Facility' => '设施',
        'Message' => '消息',

        # Template: AdminMailAccount
        'Mail Account Management' => '邮件帐户管理',
        'Add Mail Account' => '添加邮件帐号',
        'Edit Mail Account for host' => '编辑邮件帐户，主机',
        'and user account' => '和用户帐户',
        'Filter for Mail Accounts' => '邮件帐户过滤器',
        'Filter for mail accounts' => '邮件帐户过滤器',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '同一帐户的所有传入电子邮件将在所选的队列中分派。',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '如果你的帐户被标记为受信任，则在到达时间已经存在的X-OTOBO标头（优先级等）将被保留并被使用，例如用于邮箱管理员过滤器。',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '外发电子邮件可以通过%s中的Sendmail开头的设置进行配置。',
        'System Configuration' => '系统配置',
        'Host' => '主机',
        'Delete account' => '删除帐号',
        'Fetch mail' => '查收邮件',
        'Do you really want to delete this mail account?' => '您确定要删除这个邮件帐户吗？',
        'Example: mail.example.com' => '样例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夹',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '仅当你打算从其它文件夹(非INBOX)读取邮件时，才有必要修改此项.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '编辑邮件帐号',

        # Template: AdminNavigationBar
        'Administration Overview' => '系统管理概览',
        'Filter for Items' => '条目过滤器',
        'Favorites' => '收藏夹',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '你可以移动鼠标到条目的右上角并点击星形图标来将条目添加到收藏夹。',
        'Links' => '链接',
        'View the admin manual on Github' => '查看Github上的管理手册',
        'No Matches' => '无匹配',
        'Sorry, your search didn\'t match any items.' => '对不起，你的搜索不匹配任何条目。',
        'Set as favorite' => '添加到收藏夹',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '工单通知管理',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '在这里你可以上传一个配置文件以便导入工单通知，必须是与工单通知模块导出的文件一样的.yml格式。',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '在这里你可以选择哪个事件将会触发这个通知，下面的工单过滤器可以选择符合特定条件的工单。',
        'Ticket Filter' => '工单过滤',
        'Lock' => '锁定',
        'SLA' => 'SLA',
        'Customer User ID' => '客户用户ID',
        'Article Filter' => '信件过滤器',
        'Only for ArticleCreate and ArticleSend event' => '仅对ArticleCreate和ArticleSend事件',
        'Article sender type' => '信件发送人类型',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '如果ArticleCreate或ArticleSend被用作触发事件，你还需要指定信件过滤条件，请至少选择一个信件过滤字段。',
        'Customer visibility' => '客户可见度',
        'Communication channel' => '通信渠道',
        'Include attachments to notification' => '通知包含附件',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '每个工单的通知使用选择的方式一天只发送一次。',
        'This field is required and must have less than 4000 characters.' =>
            '这个字段是必须的，并且不能超过4000个字符。',
        'Notifications are sent to an agent or a customer.' => '发送给服务人员或客户的通知。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '获取主题的前20个字符（最新的服务人员信件）。',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '获取邮件正文内容前5行（最新的服务人员信件）。',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '获取邮件主题的前20个字符（最新的客户信件）。',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '获取邮件正文内容前5行（最新的客户信件）。',
        'Attributes of the current customer user data' => '客户用户的属性',
        'Attributes of the current ticket owner user data' => '工单所有者的属性',
        'Attributes of the current ticket responsible user data' => '工单负责人的属性',
        'Attributes of the current agent user who requested this action' =>
            '请示此动作的服务人员的属性',
        'Attributes of the ticket data' => '工单的属性',
        'Ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '工单动态字段显示值，对下拉式和多项选择字段有用',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '使用逗号或分号分隔电子邮件地址。',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '你可以使用诸如<OTOBO_TICKET_DynamicField_...>之类的OTOBO标签来插入当前工单中的值。',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Add PGP Key' => '添加PGP密钥',
        'PGP support is disabled' => 'PGP支持已禁用',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            '要在OTOBO中使用PGP，你必须首先启用它。',
        'Enable PGP support' => '启用PGP支持',
        'Faulty PGP configuration' => '错误的PGP配置',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用PGP支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Configure it here!' => '在这里配置PGP！',
        'Check PGP configuration' => '检查PGP配置',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '通过此模块可以直接编辑在SysConfig中配置的密钥环。',
        'Introduction to PGP' => 'PGP介绍',
        'Bit' => '位',
        'Fingerprint' => '指纹',
        'Expires' => '过期',
        'Delete this key' => '删除密钥',
        'PGP key' => 'PGP密钥',

        # Template: AdminPackageManager
        'Package Manager' => '软件包管理器',
        'Uninstall Package' => '卸载软件包',
        'Uninstall package' => '卸载软件包',
        'Do you really want to uninstall this package?' => '是否确认卸载该软件包?',
        'Reinstall package' => '重新安装软件包',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '您真的想要重新安装该软包吗? 所有该模块的手工设置将丢失.',
        'Go to updating instructions' => '转到升级说明',
        'Go to the OTOBO customer portal' => '访问OTOBO客户门户',
        'package information' => '软件包信息',
        'Package installation requires a patch level update of OTOBO.' =>
            '安装软件包需要将OTOBO补丁级别更新。',
        'Package update requires a patch level update of OTOBO.' => '升级软件包需要将OTOBO补丁级别更新。',
        'Please note that your installed OTOBO version is %s.' => '请注意，您安装的OTOBO版本是%s。',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            '安装这个软件包，你需要升级OTOBO版本到%s或者更高。',
        'This package can only be installed on OTOBO version %s or older.' =>
            '这个软件包只能安装在OTOBO版本%s或者更低。',
        'This package can only be installed on OTOBO version %s or newer.' =>
            '这个软件包只能安装在OTOBO版本%s或者更高。',
        'Why should I keep OTOBO up to date?' => '为什么要保持OTOBO是最新的？',
        'You will receive updates about relevant security issues.' => '您将收到有关安全问题的更新。',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '你将收到所有其他有关OTOBO问题的更新。',
        'How can I do a patch level update if I don’t have a contract?' =>
            '如果没有合约，我怎么更新补丁级别？',
        'Please find all relevant information within the updating instructions at %s.' =>
            '请在升级说明%s中查找所有相关的信息。',
        'In case you would have further questions we would be glad to answer them.' =>
            '如果您还有其它问题，我们非常愿意答复您。',
        'Please visit our customer portal and file a request.' => '请访问我们的客户门户并提出请求。',
        'Install Package' => '安装软件包',
        'Update Package' => '更新软件包',
        'Continue' => '继续',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '请确认你的数据库能够接收大于%s MB的数据包（目前能够接收的最大数据包为%s MB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Install' => '安装',
        'Update repository information' => '更新软件仓库信息',
        'Cloud services are currently disabled.' => '云服务当前被禁用了。',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => '启用云服务',
        'Update all installed packages' => '更新所有已安装的软件包',
        'Online Repository' => '在线软件仓库',
        'Vendor' => '提供者',
        'Action' => '操作',
        'Module documentation' => '模块文档',
        'Local Repository' => '本地软件仓库',
        'This package is verified by OTOBOverify (tm)' => '此软件包已通过OTOBOverify(tm)的验证',
        'Uninstall' => '卸载',
        'Package not correctly deployed! Please reinstall the package.' =>
            '软件包未正确安装！请重新安装软件包。',
        'Reinstall' => '重新安装',
        'Features for %s customers only' => '仅%s 才能使用的功能',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '你能从%s 得到以下可选的功能特性，请联系%s 获取更多信息。',
        'Package Information' => '软件包信息',
        'Download package' => '下载该软件包',
        'Rebuild package' => '重新编译',
        'Metadata' => '元数据',
        'Change Log' => '更新记录',
        'Date' => '日期',
        'List of Files' => '文件清单',
        'Permission' => '权限',
        'Download file from package!' => '从软件包中下载这个文件！',
        'Required' => '必需的',
        'Primary Key' => '主密钥',
        'Auto Increment' => '自动增加',
        'SQL' => 'SQL',
        'File Differences for File %s' => '文件%s的文件差异',
        'File differences for file %s' => '文件跟%s 有差异',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日志',
        'Range' => '范围',
        'last' => '最后',
        'This feature is enabled!' => '该功能已启用！',
        'Just use this feature if you want to log each request.' => '如果想详细记录每个请求, 您可以使用该功能.',
        'Activating this feature might affect your system performance!' =>
            '启动该功能可能影响您的系统性能！',
        'Disable it here!' => '关闭该功能！',
        'Logfile too large!' => '日志文件过大！',
        'The logfile is too large, you need to reset it' => '日志文件太大，请重置日志文件',
        'Interface' => '界面',
        'Requests' => '请求',
        'Min Response' => '最快响应',
        'Max Response' => '最慢响应',
        'Average Response' => '平均响应',
        'Period' => '时长',
        'minutes' => '分钟',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '管理邮箱管理员过滤器',
        'Add PostMaster Filter' => '添加邮箱管理员过滤器',
        'Edit PostMaster Filter' => '编辑邮箱管理员过滤器',
        'Filter for PostMaster Filters' => '邮箱管理员过滤规则筛选',
        'Filter for PostMaster filters' => '邮箱管理员过滤规则筛选',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '基于邮件标头标记的分派或过滤。可以使用正则表达式进行匹配。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '如果你只想匹配某个邮件地址，可以在From、To或Cc中使用EMAILADDRESS:info@example.com这样的邮件格式。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '如果你使用了正则表达式，你可以取出()中匹配的值(需采用[***]这种格式)，在设置邮件标头的值时使用。',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '您还可以使用命名捕获%s并在\'Set\'操作中使用名称%s（例如Regexp：%s，Set 操作：%s）。 匹配到的EMAILADDRESS命名为\'%s\'。',
        'Delete this filter' => '删除此过滤器',
        'Do you really want to delete this postmaster filter?' => '您确定要删除这个邮箱管理员过滤器吗？',
        'A postmaster filter with this name already exists!' => '该邮箱管理员过滤器名称已被使用！',
        'Filter Condition' => '过滤器条件',
        'AND Condition' => '“与”条件',
        'Search header field' => '搜索标头字段',
        'for value' => '查找值',
        'The field needs to be a valid regular expression or a literal word.' =>
            '该栏位需使用有效的正则表达式或文字。',
        'Negate' => '求反',
        'Set Email Headers' => '设置邮件标头',
        'Set email header' => '设置邮件标头',
        'with value' => '使用值',
        'The field needs to be a literal word.' => '该字段需要输入文字。',
        'Header' => '标头',

        # Template: AdminPriority
        'Priority Management' => '优先级管理',
        'Add Priority' => '添加优先级',
        'Edit Priority' => '编辑优先级',
        'Filter for Priorities' => '优先级过滤器',
        'Filter for priorities' => '优先级过滤器',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '此优先级已存在于系统配置的一个设置中，需要更新设置以确认指向新的优先级！',
        'This priority is used in the following config settings:' => '这个优先级已用于以下的系统配置设置：',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '流程过滤器',
        'Filter for processes' => '流程筛选',
        'Create New Process' => '创建新的流程',
        'Deploy All Processes' => '部署所有流程',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '你可以上传流程配置文件，以便将流程配置导入到你的系统中。流程配置文件采用.yml格式，它可以从流程管理模块中导出。',
        'Upload process configuration' => '上传流程配置',
        'Import process configuration' => '导入流程配置',
        'Ready2Adopt Processes' => '即开即用的流程',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '你可以在此激活能展示我们最佳实践的即开即用的流程，请注意这可能需要一些额外的配置。',
        'Import Ready2Adopt process' => '导入即开即用的流程',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '为了创建新的流程，你可以导入从其它系统导出的流程配置文件，或者重新创建一个。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '对流程所做的一切修改仅保存在数据库中。只有执行部署流程操作后，才会生成或重新生成流程配置文件。',
        'Processes' => '流程',
        'Process name' => '流程名称',
        'Print' => '打印',
        'Export Process Configuration' => '导出流程配置',
        'Copy Process' => '复制流程',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '取消并关闭',
        'Go Back' => '返回',
        'Please note, that changing this activity will affect the following processes' =>
            '请注意，修改这个活动将影响以下流程',
        'Activity' => '活动',
        'Activity Name' => '活动名称',
        'Activity Dialogs' => '活动对话框',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个活动分配活动对话框。',
        'Filter available Activity Dialogs' => '可用的活动对话框过滤器',
        'Available Activity Dialogs' => '可用的活动对话框',
        'Name: %s, EntityID: %s' => '名称：%s， EntityID： %s',
        'Create New Activity Dialog' => '创建新的活动对话框',
        'Assigned Activity Dialogs' => '分配的活动对话框',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '请注意，修改这个活动对话框将影响以下活动',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '请注意，客户并不能看到或使用以下字段：Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '队列字段只能在客户创建新工单时使用。',
        'Activity Dialog' => '活动对话框',
        'Activity dialog Name' => '活动对话框名称',
        'Available in' => '在以下界面可用',
        'Description (short)' => '描述(简短)',
        'Description (long)' => '描述(详细)',
        'The selected permission does not exist.' => '选择的权限不存在。',
        'Required Lock' => '需要锁定',
        'The selected required lock does not exist.' => '选择的需要锁定不存在（无法锁定）。',
        'Submit Advice Text' => '提交按钮的建议文本',
        'Submit Button Text' => '提交按钮的文本',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个活动对话框分配字段。',
        'Filter available fields' => '可用字段的过滤器',
        'Available Fields' => '可用的字段',
        'Assigned Fields' => '分配的字段',
        'Communication Channel' => '通信渠道',
        'Is visible for customer' => '对客户可见',
        'Display' => 'Display（显示）',

        # Template: AdminProcessManagementPath
        'Path' => '路径',
        'Edit this transition' => '编辑这个转换',
        'Transition Actions' => '转换操作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个转换分配转换动作。',
        'Filter available Transition Actions' => '可用转换动作的过滤器',
        'Available Transition Actions' => '可用的转换操作',
        'Create New Transition Action' => '创建新的转换动作',
        'Assigned Transition Actions' => '分配的转换动作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '活动',
        'Filter Activities...' => '活动过滤器...',
        'Create New Activity' => '创建新的活动',
        'Filter Activity Dialogs...' => '活动对话框过滤器...',
        'Transitions' => '转换',
        'Filter Transitions...' => '转换过滤器...',
        'Create New Transition' => '创建新的转换',
        'Filter Transition Actions...' => '转换动作过滤器...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '编辑流程',
        'Print process information' => '打印流程信息',
        'Delete Process' => '删除流程',
        'Delete Inactive Process' => '删除非活动的流程',
        'Available Process Elements' => '可用的流程元素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '用鼠标拖放动作，可以将左侧栏目上方所列的元素放置在右侧的画布中。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '可能将活动拖放到画布中，以便为流程分配活动。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '为了给活动分配活动对话框，需要将左侧的活动对话框拖放到画布中的活动上。',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '要创建两个活动的连接，你可以先拖放转换元素到开始活动上，然后移动连接箭头的尾端到结束活动上。',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '为了给转换分配转换动作，需要将左侧转换动作拖放到转换标签上。',
        'Edit Process Information' => '编辑流程信息',
        'Process Name' => '流程名称',
        'The selected state does not exist.' => '选择的状态不存在。',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '添加并编辑活动、活动对话框和转换',
        'Show EntityIDs' => '显示实体编号',
        'Extend the width of the Canvas' => '扩展画布的宽度',
        'Extend the height of the Canvas' => '扩展画布的高度',
        'Remove the Activity from this Process' => '从流程中删除这个活动',
        'Edit this Activity' => '编辑这个活动',
        'Save Activities, Activity Dialogs and Transitions' => '保存活动、活动对话框和转换',
        'Do you really want to delete this Process?' => '您真的想要删除这个流程吗？',
        'Do you really want to delete this Activity?' => '您真的想要删除这个活动吗？',
        'Do you really want to delete this Activity Dialog?' => '您真的想要删除这个活动对话框吗？',
        'Do you really want to delete this Transition?' => '您真的想要删除这个转换吗？',
        'Do you really want to delete this Transition Action?' => '您真的想要删除这个转换动作吗？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您真的想要从画布中删除这个活动吗？不保存并离开此屏幕可撤销删除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您真的想要从画布中删除这个转换吗？不保存并离开此屏幕可撤销删除操作。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在这里，你可以创建新的流程。为了使新流程生效，请务必将流程的状态设置为“激活”，并在完成配置工作后执行部署流程操作。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '取消并关闭',
        'Start Activity' => '开始活动',
        'Contains %s dialog(s)' => '包含%s 个对话框',
        'Assigned dialogs' => '分配对话框',
        'Activities are not being used in this process.' => '该流程未使用活动。',
        'Assigned fields' => '分配的字段',
        'Activity dialogs are not being used in this process.' => '该流程未使用活动对话框。',
        'Condition linking' => '条件链接',
        'Transitions are not being used in this process.' => '该流程未使用转换。',
        'Module name' => '模块名称',
        'Transition actions are not being used in this process.' => '该流程未使用转换动作。',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '请注意，修改这个转换将影响以下流程',
        'Transition' => '转换',
        'Transition Name' => '转换名称',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '请注意，修改这个转换动作将影响以下流程',
        'Transition Action' => '转换动作',
        'Transition Action Name' => '转换动作名称',
        'Transition Action Module' => '转换动作模块',
        'Config Parameters' => '配置参数',
        'Add a new Parameter' => '添加新的参数',
        'Remove this Parameter' => '删除这个参数',

        # Template: AdminQueue
        'Queue Management' => '队列管理',
        'Add Queue' => '添加队列',
        'Edit Queue' => '编辑队列',
        'Filter for Queues' => '队列过滤器',
        'Filter for queues' => '队列过滤器',
        'A queue with this name already exists!' => '队列名已存在！',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '这个队列已存在于系统配置的一个设置中，需要更新设置以确认指向新的队列！',
        'Sub-queue of' => '父队列',
        'Unlock timeout' => '解锁超时',
        '0 = no unlock' => '0 = 不解锁',
        'hours' => '小时',
        'Only business hours are counted.' => '只计算上班时间。',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工单被锁定且在解锁超时之前未被关闭，则该工单将被解锁，以便其他服务人员能够处理该工单。',
        'Notify by' => '触发通知阈值',
        '0 = no escalation' => '0 = 不升级',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如客户通过门户或邮件发送跟进信件，则升级更新时间重置。 如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，工单未被关闭，该工单将升级。',
        'Follow up Option' => '跟进选项',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果在工单关闭后跟进，指定是重新处理工单、拒绝跟进还是创建新的工单。',
        'Ticket lock after a follow up' => '跟进后自动锁定工单',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果客户在工单关闭后发送跟进信件，则将该工单锁定给以前的所有者。',
        'System address' => '系统邮件地址',
        'Will be the sender address of this queue for email answers.' => '将作为邮件答复的队列的发件人地址。',
        'Default sign key' => '默认签名',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'PGP密钥或者S/MIME证书需要被添加标识符到选定的队列系统电子邮件地址，以便使用。',
        'Salutation' => '问候语',
        'The salutation for email answers.' => '回复邮件中的问候语。',
        'Signature' => '签名',
        'The signature for email answers.' => '回复邮件中的签名。',
        'This queue is used in the following config settings:' => '这个队列已用于以下的系统配置设置：',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理队列的自动响应',
        'Change Auto Response Relations for Queue' => '修改队列的自动响应关系',
        'This filter allow you to show queues without auto responses' => '这个过滤器允许显示没有自动响应的队列',
        'Queues without Auto Responses' => '没有自动响应的队列',
        'This filter allow you to show all queues' => '这个过滤器允许显示所有队列',
        'Show All Queues' => '显示所有队列',
        'Auto Responses' => '自动响应',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板与队列的对应关系',
        'Filter for Templates' => '模板过滤器',
        'Filter for templates' => '模板筛选',
        'Templates' => '模板',

        # Template: AdminRegistration
        'System Registration Management' => '系统注册管理',
        'Edit System Registration' => '编辑系统注册',
        'System Registration Overview' => '系统注册概览',
        'Register System' => '注册系统',
        'Validate OTOBO-ID' => '验证OTOBO-ID',
        'Deregister System' => '取消系统注册',
        'Edit details' => '编辑详细信息',
        'Show transmitted data' => '显示已传输的数据',
        'Deregister system' => '取消系统注册',
        'Overview of registered systems' => '注册系统概述',
        'This system is registered with OTOBO Team.' => '',
        'System type' => '系统类型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '与注册服务器上一次的通信',
        'System Registration not Possible' => '系统注册不可能',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            '请注意：如果OTOBO守护进程没有正确运行，你就不能注册你的系统！',
        'Instructions' => '说明',
        'System Deregistration not Possible' => '系统取消注册不可能',
        'OTOBO-ID Login' => 'OTOBO-ID登陆',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => '阅读更多',
        'You need to log in with your OTOBO-ID to register your system.' =>
            '为了注册系统，需要你先使用OTOBO-ID进行登陆。',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'OTOBO-ID是你在OTOBO.com网站注册的电子邮箱地址。',
        'Data Protection' => '数据保护',
        'What are the advantages of system registration?' => '系统注册有什么好处?',
        'You will receive updates about relevant security releases.' => '你将及时收到有关安全版本的更新信息。',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '你的系统注册有助于我们改善为你提供的服务，因为我们能获得必要的相关信息。',
        'This is only the beginning!' => '这仅仅是开始！',
        'We will inform you about our new services and offerings soon.' =>
            '有了新的服务和产品我们能很快通知你。',
        'Can I use OTOBO without being registered?' => '如果不进行系统注册，我还可以使用OTOBO吗?',
        'System registration is optional.' => '系统注册是可选的。',
        'You can download and use OTOBO without being registered.' => '不进行注册，你仍然可以下载和使用OTOBO。',
        'Is it possible to deregister?' => '可以取消注册吗？',
        'You can deregister at any time.' => '你可以随时取消系统注册。',
        'Which data is transfered when registering?' => '注册后，哪些数据会被上传?',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            '域名(FQDN)、OTOBO版本、数据库、操作系统和Perl版本。',
        'Why do I have to provide a description for my system?' => '为什么需要我提供有关注册系统的描述?',
        'The description of the system is optional.' => '注册系统的描述是可选的。',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '注册系统描述和类型有助于您识别和管理系统的细节。',
        'How often does my OTOBO system send updates?' => '我的OTOBO系统上传数据的频度?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '你的系统将定期向注册服务器发送更新。',
        'Typically this would be around once every three days.' => '通常这将是大约每3天1次。',
        'If you deregister your system, you will lose these benefits:' =>
            '如果你取消注册你的系统，你将失去以下好处：',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            '为了取消注册你的系统，你需要以OTOBO-ID登录。',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => '还没有OTOBO-ID吗？',
        'Sign up now' => '现在注册',
        'Forgot your password?' => '忘记密码了吗？',
        'Retrieve a new one' => '获取新的密码',
        'Next' => '下一步',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => '属性',
        'FQDN' => '正式域名',
        'OTOBO Version' => 'OTOBO版本',
        'Operating System' => '操作系统',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '本系统可选的描述。',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => '注册',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => '取消注册',
        'You can modify registration settings here.' => '你可以在这里修改注册设置。',
        'Overview of Transmitted Data' => '已传输的数据概览',
        'There is no data regularly sent from your system to %s.' => '你的系统还没有定期向%s 发送数据。',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '你的系统至少每3天向%s 发送一次以下数据。',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'JSON格式的数据将通过安全的HTTPS连接进行上传。',
        'System Registration Data' => '系统注册信息',
        'Support Data' => '支持数据',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add Role' => '添加角色',
        'Edit Role' => '编辑角色',
        'Filter for Roles' => '角色过滤器',
        'Filter for roles' => '角色过滤器',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '创建一个角色并将组加入角色,然后将角色赋给用户.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '还没有定义角色，请使用“添加”按钮来创建一个新的角色。',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色和组的关系',
        'Roles' => '角色',
        'Select the role:group permissions.' => '选择角色的组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果没有选择，角色就不会具有任何权限 (任何工单都看不见)。',
        'Toggle %s permission for all' => '全部授予/取消 %s 权限',
        'move_into' => '转移到',
        'Permissions to move tickets into this group/queue.' => '将工单转移到这个组/队列的权限。',
        'create' => 'create（创建）',
        'Permissions to create tickets in this group/queue.' => '在这个组/队列具有创建工单的权限。',
        'note' => 'note（备注）',
        'Permissions to add notes to tickets in this group/queue.' => '在这个组/队列具有添加备注的权限。',
        'owner' => 'owner（所有者）',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '在这个组/队列具有变更工单所有者的权限。',
        'priority' => '优先级',
        'Permissions to change the ticket priority in this group/queue.' =>
            '在这个组/队列具有更改工单优先级的权限。',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '管理服务人员与角色的关系',
        'Add Agent' => '添加服务人员',
        'Filter for Agents' => '服务人员过滤器',
        'Filter for agents' => '过滤服务人员',
        'Agents' => '服务人员',
        'Manage Role-Agent Relations' => '管理角色与服务人员的关系',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Edit SLA' => '编辑SLA',
        'Add SLA' => '添加SLA',
        'Filter for SLAs' => 'SLA过滤器',
        'Please write only numbers!' => '仅可填写数字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add Certificate' => '添加证书',
        'Add Private Key' => '添加私钥',
        'SMIME support is disabled' => 'SMIME支持已禁用',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '要在OTOBO中使用SMIME，你必须首先启用它。',
        'Enable SMIME support' => '启用SMIME支持',
        'Faulty SMIME configuration' => '错误的SMIME配置',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用SMIME支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Check SMIME configuration' => '检查SMIME配置',
        'Filter for Certificates' => '证书过滤器',
        'Filter for certificates' => '证书过滤器',
        'To show certificate details click on a certificate icon.' => '点击证书图标可显示证书详细信息。',
        'To manage private certificate relations click on a private key icon.' =>
            '点击私钥图标可管理私钥证书关系。',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '你可以在这里添加私钥关系，这些关系将嵌入到邮件的S/MIME签名中。',
        'See also' => '参见',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '这样你能够直接编辑文件系统中的证书和私匙。',
        'Hash' => '哈希',
        'Create' => '创建',
        'Handle related certificates' => '处理关联的证书',
        'Read certificate' => '读取证书',
        'Delete this certificate' => '删除这个证书',
        'File' => '文件',
        'Secret' => '机密',
        'Related Certificates for' => '关联证书',
        'Delete this relation' => '删除这个关联',
        'Available Certificates' => '可用的证书',
        'Filter for S/MIME certs' => 'S/MIME证书过滤器',
        'Relate this certificate' => '关联这个证书',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME证书',
        'Certificate Details' => '证书详情',
        'Close this dialog' => '关闭该对话框',

        # Template: AdminSalutation
        'Salutation Management' => '问候语管理',
        'Add Salutation' => '添加问候语',
        'Edit Salutation' => '编辑问候语',
        'Filter for Salutations' => '问候语过滤器',
        'Filter for salutations' => '问候语过滤器',
        'e. g.' => '例如：',
        'Example salutation' => '问候语样例',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '需要启用安全模式！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安装结束后，通常都设置系统为安全模式。',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '如果安全模式没有激活，可在系统运行时通过系统配置激活安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查询窗口',
        'Filter for Results' => '过滤结果',
        'Filter for results' => '过滤结果',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '你可以在这里输入SQL语句直接发送给数据库。不能修改表的内容，只允许select查询语句。',
        'Here you can enter SQL to send it directly to the application database.' =>
            '你可以在这里输入SQL语句直接发送给数据库。',
        'Options' => '选项',
        'Only select queries are allowed.' => '只允许select查询语句。',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查询的语法有一个错误，请核对。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少缺失一个参数，请检查。',
        'Result format' => '结果格式',
        'Run Query' => '执行查询',
        '%s Results' => '%s 的结果',
        'Query is executed.' => '查询已执行。',

        # Template: AdminService
        'Service Management' => '服务管理',
        'Add Service' => '添加服务',
        'Edit Service' => '编辑服务',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '服务名(含子服务)最大长度为200字符。',
        'Sub-service of' => '上一级服务',

        # Template: AdminSession
        'Session Management' => '会话管理',
        'Detail Session View for %s (%s)' => '%s(%s)会话详情视图',
        'All sessions' => '所有会话数',
        'Agent sessions' => '服务人员会话数',
        'Customer sessions' => '客户会话数',
        'Unique agents' => '实际服务人员数',
        'Unique customers' => '实际在线客户数',
        'Kill all sessions' => '终止所有会话',
        'Kill this session' => '终止该会话',
        'Filter for Sessions' => '会话过滤器',
        'Filter for sessions' => '会话过滤器',
        'Session' => '会话',
        'Kill' => '终止',
        'Detail View for SessionID: %s - %s' => '会话ID：%s - %s的详情视图',

        # Template: AdminSignature
        'Signature Management' => '签名管理',
        'Add Signature' => '添加签名',
        'Edit Signature' => '编辑签名',
        'Filter for Signatures' => '签名过滤器',
        'Filter for signatures' => '签名过滤器',
        'Example signature' => '签名样例',

        # Template: AdminState
        'State Management' => '工单状态管理',
        'Add State' => '添加工单状态',
        'Edit State' => '编辑工单状态',
        'Filter for States' => '状态过滤器',
        'Filter for states' => '状态过滤器',
        'Attention' => '注意',
        'Please also update the states in SysConfig where needed.' => '请同时在系统配置中需要的地方更新这些工单状态。',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '这个状态已存在于系统配置的一个设置中，需要更新设置以确认指向新的状态！',
        'State type' => '工单状态类型',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '无法使此条目无效，因为系统中没有其他合并状态！',
        'This state is used in the following config settings:' => '这个状态已用于以下的系统配置设置：',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => '启用云服务',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '你可以通过这个按钮手动发送支持数据：',
        'Send Update' => '发送更新',
        'Currently this data is only shown in this system.' => '目前支持数据只是在本地系统上显示。',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '点击以下按钮生成支持数据包（包括：系统注册信息、支持数据、已安装软件包列表和本地所有修改过的源代码文件）：',
        'Generate Support Bundle' => '生成支持数据包',
        'The Support Bundle has been Generated' => '已生成支持包',
        'Please choose one of the following options.' => '请选择以下的任一个选项。',
        'Send by Email' => '通过邮件发送',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '支持数据包太大无法通过邮件发送，本选项无法使用。',
        'The email address for this user is invalid, this option has been disabled.' =>
            '当前用户的邮件地址无效，本选项无法使用。',
        'Sending' => '发送中',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => '下载文件',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '错误：%s 无法收集支持数据。',
        'Details' => '详情',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '系统邮件地址管理',
        'Add System Email Address' => '添加统邮件地址',
        'Edit System Email Address' => '编辑统邮件地址',
        'Add System Address' => '添加系统地址',
        'Filter for System Addresses' => '系统地址过滤器',
        'Filter for system addresses' => '系统地址过滤器',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '对于所有接收到的邮件，如果在其To或Cc中出现了该系统邮件地址，则将邮件分派到选择的队列中。',
        'Email address' => '电子邮件地址',
        'Display name' => '显示名称',
        'This email address is already used as system email address.' => '这个电子邮件地址已经用于系统电子邮件地址。',
        'The display name and email address will be shown on mail you send.' =>
            '邮件地址和显示名称将在发送的邮件中显示。',
        'This system address cannot be set to invalid.' => '该系统地址不能设置为无效。',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '此系统地址不能设置为无效，因为它用于一个或多个队列或自动响应。',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '在线管理员文档',
        'System configuration' => '系统配置',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '使用左侧导航框中的树形结构浏览可用的设置。',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '使用下面的搜索字段或从顶部导航的搜索图标查找某些设置。',
        'Find out how to use the system configuration by reading the %s.' =>
            '通过阅读%s来了解如何使用系统配置。',
        'Search in all settings...' => '在所有设置中搜索...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '目前没有可用的设置。 在使用软件之前，请确保运行 \'otobo.Console.pl Maint::Config::Rebuild\'。',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '更改部署',
        'Help' => '帮助',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '这是所有设置的概览，如果现在启动它，它将成为部署的一部分。 可以通过点击右上角的图标来比较每个设置当前与其先前的状态。',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '要从部署中排除某些设置，请单击设置的顶部栏中的复选框。',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '默认情况下，只会部署你自己更改的设置。 如果您想部署其他用户更改的设置，请点击屏幕顶部的链接进入高级部署模式。',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '刚刚恢复部署，所有受影响的设置已从所选部署恢复到原状态。',
        'Please review the changed settings and deploy afterwards.' => '请查看已更改的设置，然后再进行部署。',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '一个空的更改列表意味着在当前受影响的设置状态和已恢复的状态之间没有差异。',
        'Changes Overview' => '更改概览',
        'There are %s changed settings which will be deployed in this run.' =>
            '有%s个更改的设置将在本次运行中部署。',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '切换到基本模式，仅部署由你更改的设置。',
        'You have %s changed settings which will be deployed in this run.' =>
            '你有%s个更改的设置将在本次运行中部署。',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '切换到高级模式，还可以部署其他用户更改的设置。',
        'There are no settings to be deployed.' => '没有要部署的设置。',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '切换到高级模式，查看其他用户更改的可部署设置。',
        'Deploy selected changes' => '部署所选更改',

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
            '这个组不包含任何设置， 请尝试浏览它的一个子组。',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '导入和导出',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '上传要导入到系统的文件（从系统配置模块导出的.yml格式）。',
        'Upload system configuration' => '上传系统配置',
        'Import system configuration' => '导入系统配置',
        'Download current configuration settings of your system in a .yml file.' =>
            '下载当前的系统配置设置到一个.yml文件。',
        'Include user settings' => '包括用户设置',
        'Export current configuration' => '导出当前配置',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '搜索',
        'Search for category' => '搜索类别',
        'Settings I\'m currently editing' => '我正在编辑的设置',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '搜索“%s”（在“%s”类别中）没有返回任何结果。',
        'Your search for "%s" in category "%s" returned one result.' => '搜索“%s”（在“%s”类别中）返回了一个结果。',
        'Your search for "%s" in category "%s" returned %s results.' => '搜索“%s”（在“%s”类别中）返回了%s个结果。',
        'You\'re currently not editing any settings.' => '你当前没有编辑任何设置。',
        'You\'re currently editing %s setting(s).' => '你正在编辑%s设置。',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '类别',
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
        'View a custom List of Settings' => '查看设置的自定义列表',
        'View single Setting: %s' => '查看单个设置：%s',
        'Go back to Deployment Details' => '返回到部署详情',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '系统维护管理',
        'Schedule New System Maintenance' => '安排新的系统维护',
        'Filter for System Maintenances' => '系统维护过滤器',
        'Filter for system maintenances' => '系统维护过滤器',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '安排一个系统维护期会通知服务人员或用户：本系统在这个时间段停止使用。',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '当到达维护时间之前, 当前登录到系统的用户将会在屏幕上收到一个通知。',
        'Stop date' => '结束时间',
        'Delete System Maintenance' => '删除系统维护',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '编辑系统维护',
        'Edit System Maintenance Information' => '编辑系统维护信息',
        'Date invalid!' => '日期无效!',
        'Login message' => '登录消息',
        'This field must have less then 250 characters.' => '这个字段不能超过250个字符。',
        'Show login message' => '显示登录消息',
        'Notify message' => '通知消息',
        'Manage Sessions' => '管理会话',
        'All Sessions' => '所有会话',
        'Agent Sessions' => '服务人员会话',
        'Customer Sessions' => '客户会话',
        'Kill all Sessions, except for your own' => '终止除本会话外的所有会话',

        # Template: AdminTemplate
        'Template Management' => '模板管理',
        'Add Template' => '添加模板',
        'Edit Template' => '编辑模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板就是一些能帮助服务人员快速创建、回复或转发工单的默认文本。',
        'Don\'t forget to add new templates to queues.' => '别忘了将新模板分配给队列。',
        'Attachments' => '附件',
        'Delete this entry' => '删除该条目',
        'Do you really want to delete this template?' => '您真的想要删除这个模板吗？',
        'A standard template with this name already exists!' => '模板名称已存在！',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '“Create创建”类型的模板只支持以下智能标签',
        'Example template' => '模板样例',
        'The current ticket state is' => '当前工单状态是',
        'Your email address is' => '你的邮件地址是',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '管理模板和附件的关联',
        'Toggle active for all' => '全部激活/不激活',
        'Link %s to selected %s' => '链接 %s 到选中的 %s',

        # Template: AdminType
        'Type Management' => '工单类型管理',
        'Add Type' => '添加工单类型',
        'Edit Type' => '编辑工单类型',
        'Filter for Types' => '类型过滤器',
        'Filter for types' => '类型过滤器',
        'A type with this name already exists!' => '类型名字已存在!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '这个类型已存在于系统配置的一个设置中，需要更新设置以确认指向新的类型态！',
        'This type is used in the following config settings:' => '这个类型已用于以下的系统配置设置：',

        # Template: AdminUser
        'Agent Management' => '服务人员管理',
        'Edit Agent' => '编辑服务人员',
        'Edit personal preferences for this agent' => '编辑这个服务人员的个人偏好设置',
        'Agents will be needed to handle tickets.' => '处理工单是需要服务人员的。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了为新增的服务人员分配组或角色权限！',
        'Please enter a search term to look for agents.' => '请输入一个搜索条件以便查找服务人员。',
        'Last login' => '最后一次登录',
        'Switch to agent' => '切换到服务人员',
        'Title or salutation' => '标题或问候语',
        'Firstname' => '名',
        'Lastname' => '姓',
        'A user with this username already exists!' => '这个用户名已被使用!',
        'Will be auto-generated if left empty.' => '如果为空，将自动生成密码。',
        'Mobile' => '手机',
        'Effective Permissions for Agent' => '服务人员的有效权限',
        'This agent has no group permissions.' => '这个服务人员没有组权限。',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '上表显示了服务人员的有效组权限。 矩阵考虑了所有继承的权限（例如通过角色继承）。',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '管理服务人员的组权限',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '日程概览',
        'Manage Calendars' => '管理日历',
        'Add Appointment' => '添加预约',
        'Today' => '今天',
        'All-day' => '全天',
        'Repeat' => '重复',
        'Notification' => '通知',
        'Yes' => '是',
        'No' => '否',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '没有找到日历。请先通过管理日历界面添加一个日历。',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '添加新的预约',
        'Calendars' => '日历',

        # Template: AgentAppointmentEdit
        'Basic information' => '基本信息',
        'Date/Time' => '日期 / 时间',
        'Invalid date!' => '无效日期!',
        'Please set this to value before End date.' => '请设置这个值为结束日期之前。',
        'Please set this to value after Start date.' => '请设置这个值为开始日期之后。',
        'This an occurrence of a repeating appointment.' => '这是一个重复预约的一次时间。',
        'Click here to see the parent appointment.' => '点击这里查看父预约。',
        'Click here to edit the parent appointment.' => '点击这里编辑父预约。',
        'Frequency' => '频率',
        'Every' => '每',
        'day(s)' => '天',
        'week(s)' => '星期',
        'month(s)' => '月',
        'year(s)' => '年',
        'On' => '开',
        'Monday' => '星期一',
        'Mon' => '一',
        'Tuesday' => '星期二',
        'Tue' => '二',
        'Wednesday' => '星期三',
        'Wed' => '三',
        'Thursday' => '星期四',
        'Thu' => '四',
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
        'Relative point of time' => '相对的时间',
        'Link' => '链接',
        'Remove entry' => '删除条目',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '客户信息中心',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '客户用户',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：客户是无效的！',
        'Start chat' => '开始聊天',
        'Video call' => '视频通话',
        'Audio call' => '语音通话',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '客户用户通讯录',
        'Search for recipients and add the results as \'%s\'.' => '搜索收件人并将结果添加为“%s”。',
        'Search template' => '搜索模板',
        'Create Template' => '创建模板',
        'Create New' => '创建搜索模板',
        'Save changes in template' => '保存变更到模板',
        'Filters in use' => '正在使用的过滤器',
        'Additional filters' => '其他可用的过滤器',
        'Add another attribute' => '增加另一个搜索条件',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '标识符“（客户）”的属性来自客户单位。',
        '(e. g. Term* or *Term*)' => '（例如： Term* 或 *Term*）',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '选择全部',
        'The customer user is already selected in the ticket mask.' => '客户用户已经在工单遮罩窗口中被选中。',
        'Select this customer user' => '选择这个客户用户',
        'Add selected customer user to' => '添加选中的客户用户到',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '修改搜索选项',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '客户用户信息中心',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO守护进程用来执行异步任务，例如：触发工单升级、发送电子邮件等等。',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'OTOBO守护进程正常运行是正确的系统操作所必需的。',
        'Starting the OTOBO Daemon' => '正在启动OTOBO守护进程',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '确保存在文件“%s”（没有.dist扩展名）。这个CRON任务会每5分钟检查一次OTOBO守护进程是否在运行，并在需要时启动它。',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '执行\'%s start\'确保\'otobo\'用户的cron任务是活动的。',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '5分钟后，在系统中执行\'bin/otobo.Daemon.pl status\'，检查OTOBO守护进程是否正常运行。',

        # Template: AgentDashboard
        'Dashboard' => '仪表板',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '新建预约',
        'Tomorrow' => '明天',
        'Soon' => '很快',
        '5 days' => '5天',
        'Start' => '开始',
        'none' => '无',

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Save settings' => '保存设置',
        'Close this widget' => '关闭这个小部件',
        'more' => '更多',
        'Available Columns' => '可用的字段',
        'Visible Columns (order by drag & drop)' => '显示的字段(可通过拖放调整顺序)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '变更客户关系',
        'Open' => 'Open（处理中）',
        'Closed' => '已关闭',
        '%s open ticket(s) of %s' => '%s个处理中的工单，共%s个',
        '%s closed ticket(s) of %s' => '%s个已关闭的工单，共%s个',
        'Edit customer ID' => '编辑客户ID',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升级的工单',
        'Open tickets' => '处理中的工单',
        'Closed tickets' => '已关闭的工单',
        'All tickets' => '所有工单',
        'Archived tickets' => '归档的工单',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '注意：客户用户无效！',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '客户用户信息',
        'Phone ticket' => '电话工单',
        'Email ticket' => '邮件工单',
        'New phone ticket from %s' => '来自于%s新的电话工单',
        'New email ticket to %s' => '给%s新的邮件工单',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s可用了！',
        'Please update now.' => '请现在更新。',
        'Release Note' => '版本说明',
        'Level' => '级别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '发布于%s之前。',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '统计widget（小部件）的配置有错误，请检查你的设置。',
        'Download as SVG file' => '下载为SVG格式的文件',
        'Download as PNG file' => '下载为PNG格式的文件',
        'Download as CSV file' => '下载为CSV格式的文件',
        'Download as Excel file' => '下载为Excel格式的文件',
        'Download as PDF file' => '下载为PDF格式的文件',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '请为统计小部件选择有效的图形输出格式。',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '正在为你处理统计数据，请耐心等待。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '这个统计当前还不能使用，需要统计管理员校正配置。',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '分配给客户用户',
        'Accessible for customer user' => '客户用户可访问',
        'My locked tickets' => '我锁定的工单',
        'My watched tickets' => '我关注的工单',
        'My responsibilities' => '我负责的工单',
        'Tickets in My Queues' => '我的队列中的工单',
        'Tickets in My Services' => '我服务的工单',
        'Service Time' => '服务时间',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '合计',

        # Template: AgentDashboardUserOnline
        'out of office' => '不在办公室',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直到',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => '后退',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => '接收新闻、许可证或者一些变更信息。',
        'Yes, accepted.' => '是的，接受。',

        # Template: AgentLinkObject
        'Manage links for %s' => '管理%s的链接',
        'Create new links' => '创建新链接',
        'Manage existing links' => '管理现有链接',
        'Link with' => '链接到',
        'Start search' => '开始搜索',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '目前没有链接。 请点击顶部的“创建新链接”将此项目链接到其他对象。',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => '修改密码',
        'Current password' => '当前密码',
        'New password' => '新密码',
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
        'Edit your preferences' => '编辑个人设置',
        'Personal Preferences' => '个人偏好设置',
        'Preferences' => '偏好设置',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '请注意：你现在编辑的是%s的偏好设置。',
        'Go back to editing this agent' => '去编辑这个服务人员',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '设置你的个人偏好。 通过单击右侧的钩形符号来保存每个设置。',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '你可以使用下面的导航树仅显示某些组的设置。',
        'Dynamic Actions' => '动态操作',
        'Filter settings...' => '过滤设置...',
        'Filter for settings' => '设置过滤器',
        'Save all settings' => '保存所有设置',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '头像功能已被系统管理员禁用，此处用你的简称替代。',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '你可以注册您的电子邮件地址%s（在%s）来更改您的头像图像。 请注意，由于缓存，可能需要一些时间才能使你的新头像变得可用。',
        'Off' => '关',
        'End' => '结束',
        'This setting can currently not be saved.' => '此设置目前无法保存。',
        'This setting can currently not be saved' => '此设置目前无法保存',
        'Save this setting' => '保存该设置',
        'Did you know? You can help translating OTOBO at %s.' => '你知道吗? 你也可以通过%s帮助翻译 OTOBO。',

        # Template: SettingsList
        'Reset to default' => '重置为默认',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '从右侧的组中选择您想要更改的设置。',
        'Did you know?' => '你知道吗？',
        'You can change your avatar by registering with your email address %s on %s' =>
            '你可以注册您的电子邮件地址%s（在%s网站）来更改你的头像',

        # Template: AgentSplitSelection
        'Target' => '目标',
        'Process' => '流程',
        'Split' => '拆分',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '统计管理',
        'Add Statistics' => '添加统计',
        'Read more about statistics in OTOBO' => '详细了解OTR关于统计的信息',
        'Dynamic Matrix' => '动态矩阵',
        'Each cell contains a singular data point.' => '每个单元格包含一个单数据点。',
        'Dynamic List' => '动态列表',
        'Each row contains data of one entity.' => '每行包含一个实体的数据。',
        'Static' => '静态',
        'Non-configurable complex statistics.' => '不可配置的复杂统计。',
        'General Specification' => '一般设定',
        'Create Statistic' => '创建统计',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '编辑统计',
        'Run now' => '立即运行',
        'Statistics Preview' => '统计预览',
        'Save Statistic' => '保存统计',

        # Template: AgentStatisticsImport
        'Import Statistics' => '导入统计',
        'Import Statistics Configuration' => '导入统计配置',

        # Template: AgentStatisticsOverview
        'Statistics' => '统计',
        'Run' => '运行',
        'Edit statistic "%s".' => '编辑统计“%s”。',
        'Export statistic "%s"' => '导出统计“%s”',
        'Export statistic %s' => '导出统计%s',
        'Delete statistic "%s"' => '删除统计“%s”',
        'Delete statistic %s' => '删除统计%s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '统计概览',
        'View Statistics' => '查看统计',
        'Statistics Information' => '统计信息',
        'Created by' => '创建人',
        'Changed by' => '修改人',
        'Sum rows' => '行汇总',
        'Sum columns' => '列汇总',
        'Show as dashboard widget' => '以仪表板小部件显示',
        'Cache' => '缓存',
        'This statistic contains configuration errors and can currently not be used.' =>
            '统计包含有错误配置，当前不能使用。',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '修改%s%s%s的自由文本',
        'Change Owner of %s%s%s' => '变更工单%s%s%s的所有者',
        'Close %s%s%s' => '关闭%s%s%s',
        'Add Note to %s%s%s' => '添加备注到',
        'Set Pending Time for %s%s%s' => '为%s%s%s添加挂起时间',
        'Change Priority of %s%s%s' => '变更工单%s%s%s的优先级',
        'Change Responsible of %s%s%s' => '变更工单%s%s%s的负责人',
        'The ticket has been locked' => '工单已锁定',
        'Undo & close' => '撤销并关闭',
        'Ticket Settings' => '工单设置',
        'Queue invalid.' => '队列无效。',
        'Service invalid.' => '服务无效。',
        'SLA invalid.' => 'SLA无效。',
        'New Owner' => '新的所有者',
        'Please set a new owner!' => '请指定新的所有者！',
        'Owner invalid.' => '所有者无效。',
        'New Responsible' => '新的负责人',
        'Please set a new responsible!' => '请指定新的负责人！',
        'Responsible invalid.' => '负责人无效。',
        'Next state' => '工单下一状态',
        'State invalid.' => '状态无效。',
        'For all pending* states.' => '适用于各种挂起状态。',
        'Add Article' => '添加信件',
        'Create an Article' => '创建一封信件',
        'Inform agents' => '通知服务人员',
        'Inform involved agents' => '通知相关服务人员',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '你可以在这里选择额外的服务人员，以收到这封信件的通知。',
        'Text will also be received by' => '内容也将被以下人员接收到',
        'Text Template' => '内容模板',
        'Setting a template will overwrite any text or attachment.' => '设置一个模板将覆盖任何文本或附件。',
        'Invalid time!' => '无效时间!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '退回%s%s%s',
        'Bounce to' => '退回到',
        'You need a email address.' => '需要一个邮件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一个有效的邮件地址，不可以使用本地邮件地址。',
        'Next ticket state' => '工单下一状态',
        'Inform sender' => '通知发送者',
        'Send mail' => '发送邮件',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工单批量操作',
        'Send Email' => '发送邮件',
        'Merge' => '合并',
        'Merge to' => '合并到',
        'Invalid ticket identifier!' => '无效的工单标识符!',
        'Merge to oldest' => '合并到最早提交的工单',
        'Link together' => '相互链接',
        'Link to parent' => '链接到上一级',
        'Unlock tickets' => '解锁工单',
        'Execute Bulk Action' => '执行批量操作',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '撰写工单%s%s%s的回复邮件',
        'This address is registered as system address and cannot be used: %s' =>
            '这个邮件地址：%s已被注册为系统邮件地址，不能使用。',
        'Please include at least one recipient' => '请包括至少一个收件人',
        'Select one or more recipients from the customer user address book.' =>
            '从客户用户通讯录中选择一个或多个收件人。',
        'Customer user address book' => '客户用户通讯录',
        'Remove Ticket Customer' => '移除工单客户',
        'Please remove this entry and enter a new one with the correct value.' =>
            '请删除这个条目并重新输入一个正确的值。',
        'This address already exists on the address list.' => '地址列表已有这个地址。',
        'Remove Cc' => '移除Cc',
        'Bcc' => '暗送',
        'Remove Bcc' => '移除Bcc',
        'Date Invalid!' => '日期无效！',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '变更工单%s%s%s的客户',
        'Customer Information' => '客户信息',
        'Customer user' => '客户用户',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '创建邮件工单',
        'Example Template' => '模板样例',
        'To customer user' => '选择客户用户',
        'Please include at least one customer user for the ticket.' => '请包括至少一个客户用户。',
        'Select this customer as the main customer.' => '选择这个客户用户作为主要联系人。',
        'Remove Ticket Customer User' => '移除客户用户',
        'From queue' => '从队列',
        'Get all' => '获取全部',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%s的外发邮件',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '重新发送电子邮件给%s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '工单%s：首次响应时间已超时(%s/%s)！',
        'Ticket %s: first response time will be over in %s/%s!' => '工单%s：首次响应时间将在%s/%s内超时！',
        'Ticket %s: update time is over (%s/%s)!' => '工单%s：更新时间已超时(%s/%s)！',
        'Ticket %s: update time will be over in %s/%s!' => '工单%s: 更新时间将在%s/%s内超时！',
        'Ticket %s: solution time is over (%s/%s)!' => '工单%s: 解决时间已超时(%s/%s)！',
        'Ticket %s: solution time will be over in %s/%s!' => '工单%s：解决时间将在%s/%s内超时！',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '转发%s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%s历史',
        'Filter for history items' => '历史条目过滤器',
        'Expand/collapse all' => '全部展开/折叠',
        'CreateTime' => '创建时间',
        'Article' => '信件',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '合并%s%s%s',
        'Merge Settings' => '合并设置',
        'You need to use a ticket number!' => '您需要使用一个工单编号!',
        'A valid ticket number is required.' => '需要有效的工单编号。',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '尝试输入工单编号或标题的一部分，以便进行搜索。',
        'Limit the search to tickets with same Customer ID (%s).' => '仅搜索具有相同客户ID（%s）的工单。',
        'Inform Sender' => '通知发送者',
        'Need a valid email address.' => '需要有效的邮件地址。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '转移%s%s%s',
        'New Queue' => '新队列',
        'Move' => '转移',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => '没有找到工单数据。',
        'Open / Close ticket action menu' => '处理/关闭工单动作的菜单',
        'Select this ticket' => '选择这个工单',
        'Sender' => '发件人',
        'First Response Time' => '首次响应时间',
        'Update Time' => '更新时间',
        'Solution Time' => '解决时间',
        'Move ticket to a different queue' => '将工单转移到另一个队列',
        'Change queue' => '更改队列',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '清除这个屏幕的过滤器。',
        'Tickets per page' => '工单数/页',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '频道丢失',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '刷新概览视图',
        'Column Filters Form' => '字段过滤器表单',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '拆分为新的电话工单',
        'Save Chat Into New Phone Ticket' => '保存聊天为新的电话工单',
        'Create New Phone Ticket' => '创建电话工单',
        'Please include at least one customer for the ticket.' => '请包括至少一个客户用户。',
        'To queue' => '队列',
        'Chat protocol' => '聊天协议',
        'The chat will be appended as a separate article.' => '将聊天内容作为单独的信件追加到工单。',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%s的电话',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '查看%s%s%s的邮件纯文本',
        'Plain' => '纯文本',
        'Download this email' => '下载该邮件',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '创建流程工单',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '注册工单到一个流程',

        # Template: AgentTicketSearch
        'Profile link' => '按模板搜索',
        'Output' => '搜索结果格式为',
        'Fulltext' => '全文',
        'Customer ID (complex search)' => 'CustomerID(复合搜索)',
        '(e. g. 234*)' => '(例如： 234*)',
        'Customer ID (exact match)' => 'CustomerID(精确匹配)',
        'Assigned to Customer User Login (complex search)' => '分配给客户用户登录名（复杂搜索）',
        '(e. g. U51*)' => '(例如：U51*)',
        'Assigned to Customer User Login (exact match)' => '分配给客户用户登录名（精确匹配）',
        'Accessible to Customer User Login (exact match)' => '可访问的客户用户登录名（精确匹配）',
        'Created in Queue' => '由队列中创建',
        'Lock state' => '锁定状态',
        'Watcher' => '关注人',
        'Article Create Time (before/after)' => '信件创建时间（在...之前/之后）',
        'Article Create Time (between)' => '信件创建时间（在...之间）',
        'Please set this to value before end date.' => '请设置这个值为结束日期之前。',
        'Please set this to value after start date.' => '请设置这个值为开始日期之后。',
        'Ticket Create Time (before/after)' => '工单创建时间（在...之前/之后）',
        'Ticket Create Time (between)' => '工单创建时间（在...之间）',
        'Ticket Change Time (before/after)' => '工单修改时间（在...之前/之后）',
        'Ticket Change Time (between)' => '工单修改时间（在...之间）',
        'Ticket Last Change Time (before/after)' => '工单最后修改时间（在...之前/之后）',
        'Ticket Last Change Time (between)' => '工单最后修改时间（在...之间）',
        'Ticket Pending Until Time (before/after)' => '工单挂起待定时间（之前/之后）',
        'Ticket Pending Until Time (between)' => '工单挂起待定时间（在...之间）',
        'Ticket Close Time (before/after)' => '工单关闭时间（在...之前/之后）',
        'Ticket Close Time (between)' => '工单关闭时间（在...之间）',
        'Ticket Escalation Time (before/after)' => '工单升级时间（在...之前/之后）',
        'Ticket Escalation Time (between)' => '工单升级时间（在...之间）',
        'Archive Search' => '归档搜索',

        # Template: AgentTicketZoom
        'Sender Type' => '发送人类型',
        'Save filter settings as default' => '将过滤器设置保存为默认过滤器',
        'Event Type' => '事件类型',
        'Save as default' => '保存为默认',
        'Drafts' => '草稿',
        'Change Queue' => '改变队列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中没有可用的活动对话框。',
        'This item has no articles yet.' => '此条目还没有信件。',
        'Ticket Timeline View' => '工单时间轴视图',
        'Article Overview - %s Article(s)' => '信件概览-%s个信件',
        'Page %s' => '第%s页',
        'Add Filter' => '添加过滤器',
        'Set' => '设置',
        'Reset Filter' => '重置过滤器',
        'No.' => 'NO.',
        'Unread articles' => '未读信件',
        'Via' => '通过',
        'Important' => '重要',
        'Unread Article!' => '未读信件!',
        'Incoming message' => '接收的消息',
        'Outgoing message' => '发出的消息',
        'Internal message' => '内部消息',
        'Sending of this message has failed.' => '发送这个消息已失败。',
        'Resize' => '调整大小',
        'Mark this article as read' => '标记该信件为已读',
        'Show Full Text' => '显示详细内容',
        'Full Article Text' => '详细内容',
        'No more events found. Please try changing the filter settings.' =>
            '没有找到更多的事件，请尝试修改过滤器设置。',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '通过%s',
        'by %s' => '来自%s',
        'Toggle article details' => '切换信件详情',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '此消息正在处理中。 已尝试发送%s次，下次重试将在%s。',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '要打开工单里的链接, 你可能需要单击链接的同时按住Ctrl或Cmd或Shift键(取决于您的浏览器和操作系统 ).',
        'Close this message' => '关闭本消息',
        'Image' => '图片',
        'PDF' => 'PDF',
        'Unknown' => '未知',
        'View' => '查看',

        # Template: LinkTable
        'Linked Objects' => '连接的对象',

        # Template: TicketInformation
        'Archive' => '归档',
        'This ticket is archived.' => '该工单已归档。',
        'Note: Type is invalid!' => '注意：类型无效！',
        'Pending till' => '挂起至',
        'Locked' => '锁定状态',
        '%s Ticket(s)' => '%s个工单',
        'Accounted time' => '所用工时',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '由于系统丢失了%s频道，无法预览该信件。',
        'Please re-install %s package in order to display this article.' =>
            '请重新安装%s软件包以显示该信件。',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '为了保护你的隐私,远程内容被阻挡。',
        'Load blocked content.' => '载入被阻挡的内容。',

        # Template: Breadcrumb
        'Home' => '首页',
        'Back to admin overview' => '返回到系统管理概览',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '这个功能需要启用云服务',
        'You can' => '你可以',
        'go back to the previous page' => '返回上一页',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '客户ID不可更改，不能将其他客户ID分配给这个工单。',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '首先选择一个客户用户，然后你可以选择一个客户ID来分配给这个工单。',
        'Select a customer ID to assign to this ticket.' => '选择要分配给这个工单的客户ID。',
        'From all Customer IDs' => '从所有的客户ID',
        'From assigned Customer IDs' => '从已分配的客户ID',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => '新建工单',

        # Template: CustomerError
        'An Error Occurred' => '发生了一个错误',
        'Error Details' => '详细错误信息',
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s发现可能有网络问题。 你可以尝试手动刷新此页面，也可以等浏览器自行重连。',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '连接在临时中断后已重连，因此本页面上的元素可能已无法正常工作。为了能重新正常使用所有的元素，强烈建议刷新本页面。',

        # Template: CustomerLogin
        'JavaScript Not Available' => '没有启用JavaScript',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '为了体验这个软件，你需要在浏览器中启用JavaScript。',
        'Browser Warning' => '浏览器的警告',
        'The browser you are using is too old.' => '你使用的游览器版本太老了。',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '本软件可以在大量的浏览器中运行，请升级到其中之一。',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 请向你的管理询问或参考相关文档.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => '请稍候，正在重定向...',
        'Login' => '登录',
        'Your user name' => '你的用户名',
        'User name' => '用户名',
        'Your password' => '你的密码',
        'Forgot password?' => '密码忘记?',
        'Your 2 Factor Token' => '你的双因素令牌',
        '2 Factor Token' => '双因素令牌',
        'Log In' => '登录',
        'Request Account' => '',
        'Request New Password' => '请求新密码',
        'Your User Name' => '你的用户名',
        'A new password will be sent to your email address.' => '新密码将会发送到您的邮箱中。',
        'Create Account' => '创建帐户',
        'Please fill out this form to receive login credentials.' => '请填写这个表单以便接收登录凭证。',
        'How we should address you' => '称谓',
        'Your First Name' => '名字',
        'Your Last Name' => '姓',
        'Your email address (this will become your username)' => '您的邮件地址（这将是你的登录用户名）',

        # Template: CustomerNavigationBar
        'Logout' => '注销',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => '欢迎！',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => '服务级别协议',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => '页',
        'Tickets' => '工单',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => '搜索条件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'CustomerID' => 'CustomerID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '对工单进行全文搜索（例如 "John*n" 或 "Will*"）',
        'Types' => '类型',
        'Time Restrictions' => '时间限制',
        'No time settings' => '没有设置时间',
        'All' => '全部',
        'Specific date' => '指定日期',
        'Only tickets created' => '仅工单创建时间',
        'Date range' => '日期范围',
        'Only tickets created between' => '仅工单创建时间区间',
        'Ticket Archive System' => '工单归档系统',
        'Save Search as Template?' => '将搜索保存为模板吗？',
        'Save as Template?' => '保存为模板吗？',
        'Save as Template' => '保存为模板',
        'Template Name' => '模板名称',
        'Pick a profile name' => '输入模板名称',
        'Output to' => '输出为',

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Search Results for' => '以下条件的搜索结果',
        'Remove this Search Term.' => '移除这个搜索词。',

        # Template: CustomerTicketZoom
        'Reply' => '回复',
        'Discard' => '',
        'Ticket Information' => '工单信息',
        'Categories' => '',
        'Further actions' => '',

        # Template: Chat
        'Expand article' => '展开信件',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => '警告',

        # Template: TileNewTicket
        'Issue%sa ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '事件信息',
        'Ticket fields' => '工单字段',

        # Template: Error
        'Send a bugreport' => '发送一个BUG报告',
        'Expand' => '展开',

        # Template: AttachmentList
        'Click to delete this attachment.' => '点击以删除这个附件。',

        # Template: DraftButtons
        'Update draft' => '更新草稿',
        'Save as new draft' => '另存为新的草稿',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '你已加载草稿“%s”。',
        'You have loaded the draft "%s". You last changed it %s.' => '你已加载草稿“%s”。 你最后更改了%s。',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '你已加载草稿“%s”。 最后更改了%s的是%s。',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '请注意，这个草稿已经过时了，因为这个草稿创建后该工单已经被修改过了。',

        # Template: Header
        'Edit personal preferences' => '编辑个人偏好设置',
        'Personal preferences' => '个人偏好设置',
        'You are logged in as' => '您已登录为',

        # Template: Installer
        'JavaScript not available' => 'JavaScript没有启用',
        'Step %s' => '第%s步',
        'License' => '许可证',
        'Database Settings' => '数据库设置',
        'General Specifications and Mail Settings' => '一般设定和邮件配置',
        'Finish' => '完成',
        'Welcome to %s' => '欢迎使用%s',
        'Germany' => '德国',
        'Phone' => '电话',
        'Switzerland' => '',
        'Web site' => '网址',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '外发邮件配置',
        'Outbound mail type' => '外发邮件类型',
        'Select outbound mail type.' => '选择外发邮件类型。',
        'Outbound mail port' => '外发邮件端口',
        'Select outbound mail port.' => '选择外发邮件端口。',
        'SMTP host' => 'SMTP服务器',
        'SMTP host.' => 'SMTP服务器。',
        'SMTP authentication' => 'SMTP认证',
        'Does your SMTP host need authentication?' => 'SMTP服务器是否需要认证？',
        'SMTP auth user' => 'SMTP认证用户名',
        'Username for SMTP auth.' => 'SMTP认证用户名。',
        'SMTP auth password' => 'SMTP认证密码',
        'Password for SMTP auth.' => 'SMTP认证密码。',
        'Configure Inbound Mail' => '接收邮件配置',
        'Inbound mail type' => '接收邮件类型',
        'Select inbound mail type.' => '选择接收邮件类型。',
        'Inbound mail host' => '接收邮件服务器',
        'Inbound mail host.' => '接收邮件服务器。',
        'Inbound mail user' => '接收邮件用户名',
        'User for inbound mail.' => '接收邮件用户名。',
        'Inbound mail password' => '接收邮件密码',
        'Password for inbound mail.' => '接收邮件密码。',
        'Result of mail configuration check' => '邮件配置检查结果',
        'Check mail configuration' => '检查邮件配置',
        'Skip this step' => '跳过这一步',

        # Template: InstallerDBResult
        'Done' => '完成',
        'Error' => 'Error（错误）',
        'Database setup successful!' => '数据库设置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安装类型',
        'Create a new database for OTOBO' => '为OTOBO创建新的数据库',
        'Use an existing database for OTOBO' => '使用现有的OTOBO数据库',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '如果你的数据库为root设置了密码，你必须在这里输入；否则，该字段为空。',
        'Database name' => '数据库名称',
        'Check database settings' => '测试数据库设置',
        'Result of database check' => '数据库检查结果',
        'Database check successful.' => '数据库检查完成。',
        'Database User' => '数据库用户',
        'New' => 'New（新建）',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            '已经为OTOBO系统创建了新的数据库普通用户。',
        'Repeat Password' => '重复输入密码',
        'Generated password' => '自动生成的密码',

        # Template: InstallerDBmysql
        'Passwords do not match' => '密码不匹配',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '为了能够使用OTOBO, 您必须以root身份在命令行中(Terminal/Shell)输入以下行。',
        'Restart your webserver' => '重启web服务器',
        'After doing so your OTOBO is up and running.' => '完成这些后，您的OTOBO系统就启动并运行了。',
        'Start page' => '开始页面',
        'Your OTOBO Team' => 'OTOBO团队',

        # Template: InstallerLicense
        'Don\'t accept license' => '不同意许可',
        'Accept license and continue' => '同意许可并继续',

        # Template: InstallerSystem
        'SystemID' => '系统ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '系统的标识符，每个工单编号和HTTP会话ID均包含系统ID。',
        'System FQDN' => '系统正式域名',
        'Fully qualified domain name of your system.' => '系统FQDN（正式域名）。',
        'AdminEmail' => '管理员地址',
        'Email address of the system administrator.' => '系统管理员邮件地址。',
        'Organization' => '组织',
        'Log' => '日志',
        'LogModule' => '日志模块',
        'Log backend to use.' => '日志后端使用。',
        'LogFile' => '日志文件',
        'Webfrontend' => 'Web前端',
        'Default language' => '默认语言',
        'Default language.' => '默认语言。',
        'CheckMXRecord' => '检查MX记录',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '手动输入的电子邮件地址将通过DNS服务器验证MX记录。如果DNS服务器响应慢或无法提供公网解析，请不要使用此选项。',

        # Template: LinkObject
        'Delete link' => '删除链接',
        'Delete Link' => '删除链接',
        'Object#' => '对象号',
        'Add links' => '添加链接',
        'Delete links' => '删除链接',

        # Template: Login
        'Lost your password?' => '忘记密码?',
        'Back to login' => '重新登录',

        # Template: MetaFloater
        'Scale preview content' => '缩放预览内容',
        'Open URL in new tab' => '在新的标签页打开链接',
        'Close preview' => '关闭预览',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '这个网站不允许被嵌入，无法提供预览。',

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
        'Feature not Available' => '功能不可用',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '抱歉，当前的OTOBO不能用于移动终端。如果你想在移动终端上使用，你可以切换到桌面模式或使用普通桌面终端。',

        # Template: Motd
        'Message of the Day' => '今日消息',
        'This is the message of the day. You can edit this in %s.' => '这是今日消息，你可以在文件%s中编辑它的内容。',

        # Template: NoPermission
        'Insufficient Rights' => '没有足够的权限',
        'Back to the previous page' => '返回前一页',

        # Template: Alert
        'Alert' => '警告',
        'Powered by' => '技术支持：',

        # Template: Pagination
        'Show first page' => '首页',
        'Show previous pages' => '前一页',
        'Show page %s' => '第%s页',
        'Show next pages' => '后一页',
        'Show last page' => '尾页',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID！',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一个可以显示的图像!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '没有找到可以配置的通知。',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '接收通知\'%s\'的消息，通过传输方法\'%s\'。',

        # Template: ActivityDialogHeader
        'Process Information' => '流程信息',
        'Dialog' => '对话框',

        # Template: Article
        'Inform Agent' => '通知服务人员',

        # Template: PublicDefault
        'Welcome' => '欢迎',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '这是OTOBO默认的公共界面！没有操作参数。',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '你可以安装一个定制的有公共界面的公共模块（通过软件包管理器），例如FAQ知识库模块。',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '权限',
        'You can select one or more groups to define access for different agents.' =>
            '你可以为不同的服务人员选择一个或多个组以定义访问权限。',
        'Result formats' => '结果格式',
        'Time Zone' => '时区',
        'The selected time periods in the statistic are time zone neutral.' =>
            '统计的选定时间段是时区中立的（无时区）。',
        'Create summation row' => '创建汇总行',
        'Generate an additional row containing sums for all data rows.' =>
            '生成一个额外的行来包含所有数据行的汇总。',
        'Create summation column' => '创建汇总列',
        'Generate an additional column containing sums for all data columns.' =>
            '生成一个额外的列来包含所有数据列的汇总。',
        'Cache results' => '缓存结果',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '在缓存中保存统计结果，以便在相同配置（需要至少一个选定的时间字段）时能够用于随后的视图。',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '将该统计变为小部件，以便服务人员能够在仪表板中激活使用。',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '请注意，这个统计启用为仪表板小部件将激活缓存功能。',
        'If set to invalid end users can not generate the stat.' => '如果设置为无效，将无法生成统计。',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '这个统计的配置还有如下问题：',
        'You may now configure the X-axis of your statistic.' => '你可以现在配置统计的X轴（横坐标轴）。',
        'This statistic does not provide preview data.' => '这个统计没有预览数据。',
        'Preview format' => '预览格式',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '请注意，预览使用随机数据，并且没有过滤数据。',
        'Configure X-Axis' => '配置X轴',
        'X-axis' => 'X轴',
        'Configure Y-Axis' => '配置Y轴',
        'Y-axis' => 'Y轴',
        'Configure Filter' => '配置过滤器',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '请只选择一个元素或使“固定”复选框未被选中。',
        'Absolute period' => '绝对时间段',
        'Between %s and %s' => '在%s 和 %s之间',
        'Relative period' => '相对时间段',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '过去完成%s，当前和即将完成%s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '统计生成后不允许修改这个元素。',

        # Template: StatsParamsWidget
        'Format' => '格式',
        'Exchange Axis' => '转换坐标轴',
        'Configurable Params of Static Stat' => '静态统计的可配置参数',
        'No element selected.' => '没有选择元素。',
        'Scale' => '时间刻度',
        'show more' => '显示更多',
        'show less' => '收起',

        # Template: D3
        'Download SVG' => '下载SVG',
        'Download PNG' => '下载PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '选定的时间段定义了统计收集数据的默认时间范围。',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '定义报表中数据点拆分为选定时间区间的时间间隔。',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '请记住：Y轴的时间刻度必须大于X轴的时间刻度（例如：X轴=>月，Y轴=>年）。',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => '这个设置已被禁用。',
        'This setting is fixed but not deployed yet!' => '这个设置已修正，但尚未部署！',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '这个设置目前已在%s中覆盖，所以无法在这里更改！',
        'Changing this setting is only available in a higher config level!' =>
            '更改此设置仅适用于更高的配置级别！',
        '%s (%s) is currently working on this setting.' => '%s（%s）正在处理这个设置。',
        'Toggle advanced options for this setting' => '显示/隐藏此设置的高级选项',
        'Disable this setting, so it is no longer effective' => '禁用此设置，因此它不再有效',
        'Disable' => '禁用',
        'Enable this setting, so it becomes effective' => '启用此设置，使其生效',
        'Enable' => '启用',
        'Reset this setting to its default state' => '将此设置重置为默认状态',
        'Reset setting' => '重置设置',
        'Allow users to adapt this setting from within their personal preferences' =>
            '允许用户从个人偏好设置中调整这个设置',
        'Allow users to update' => '允许用户更新',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '不再允许用户在个人偏好设置中调整这个设置',
        'Forbid users to update' => '禁止用户更新',
        'Show user specific changes for this setting' => '显示这个设置的用户特定变更',
        'Show user settings' => '显示用户设置',
        'Copy a direct link to this setting to your clipboard' => '将这个设置的直接链接复制到剪贴板',
        'Copy direct link' => '复制直接链接',
        'Remove this setting from your favorites setting' => '从你的收藏夹中删除这个设置',
        'Remove from favourites' => '从收藏夹中移除',
        'Add this setting to your favorites' => '将这个设置添加到你的收藏夹',
        'Add to favourites' => '添加到收藏夹',
        'Cancel editing this setting' => '取消编辑这个设置',
        'Save changes on this setting' => '保存这个设置的更改',
        'Edit this setting' => '编辑这个设置',
        'Enable this setting' => '启用这个设置',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '此组不包含任何设置。 请尝试浏览其中一个子组或另一个组。',

        # Template: SettingsListCompare
        'Now' => '立即',
        'User modification' => '用户修改',
        'enabled' => '已启用',
        'disabled' => '已禁用',
        'Setting state' => '设置状态',

        # Template: Actions
        'Edit search' => '编辑搜索',
        'Go back to admin: ' => '返回到系统管理： ',
        'Deployment' => '部署',
        'My favourite settings' => '我收藏的设置',
        'Invalid settings' => '设置无效',

        # Template: DynamicActions
        'Filter visible settings...' => '过滤可见的设置...',
        'Enable edit mode for all settings' => '启用所有设置的编辑模式',
        'Save all edited settings' => '保存所有编辑过的设置',
        'Cancel editing for all settings' => '取消编辑所有设置',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '这个小部件的所有操作仅适用于右侧可见的设置。',

        # Template: Help
        'Currently edited by me.' => '目前由我编辑。',
        'Modified but not yet deployed.' => '已修改但尚未部署。',
        'Currently edited by another user.' => '目前由其他用户编辑。',
        'Different from its default value.' => '与其默认值不同。',
        'Save current setting.' => '保存当前设置。',
        'Cancel editing current setting.' => '取消编辑当前设置。',

        # Template: Navigation
        'Navigation' => '导航',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO测试页',
        'Unlock' => '解锁',
        'Welcome %s %s' => '欢迎使用%s %s',
        'Counter' => '计数器',

        # Template: Warning
        'Go back to the previous page' => '返回前一页',

        # JS Template: CalendarSettingsDialog
        'Show' => '显示',

        # JS Template: FormDraftAddDialog
        'Draft title' => '草稿标题',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '信件显示',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '你确定要删除“%s”吗？',
        'Confirm' => '确认',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '加载中，请稍候...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '点击以选择一个文件上传。',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => '单击以选择文件或将文件拖放到这里。',
        'Click to select a file or just drop it here.' => '单击以选择一个文件或将文件拖放到这里。',
        'Uploading...' => '上传中...',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => '流程状态',
        'Running' => '正在运行',
        'Finished' => '完成',
        'No package information available.' => '没有可用的软件包信息。',

        # JS Template: AddButton
        'Add new entry' => '添加新条目',

        # JS Template: AddHashKey
        'Add key' => '添加键',

        # JS Template: DialogDeployment
        'Deployment comment...' => '部署注释...',
        'This field can have no more than 250 characters.' => '此字段不能超过250个字符。',
        'Deploying, please wait...' => '正在部署，请稍候...',
        'Preparing to deploy, please wait...' => '准备部署，请稍候...',
        'Deploy now' => '现在部署',
        'Try again' => '重试',

        # JS Template: DialogReset
        'Reset options' => '重置选项',
        'Reset setting on global level.' => '在全局级别重置设置。',
        'Reset globally' => '全局重置',
        'Remove all user changes.' => '移除所有的用户更改。',
        'Reset locally' => '本地重置',
        'user(s) have modified this setting.' => '用户已经修改过此设置。',
        'Do you really want to reset this setting to it\'s default value?' =>
            '你确定要重置这个设置到它的默认值吗？',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '可以使用类别选择来将导航树限制在选择的类别中。一旦选择了某个类别，导航树将被重新构建。',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '数据库后端',
        'CustomerIDs' => '客户ID',
        'Fax' => '传真',
        'Street' => '街道',
        'Zip' => '邮编',
        'City' => '城市',
        'Country' => '国家',
        'Mr.' => '先生',
        'Mrs.' => '女士',
        'Address' => '地址',
        'View system log messages.' => '查看系统日志信息。',
        'Edit the system configuration settings.' => '编辑系统配置。',
        'Update and extend your system with software packages.' => '更新或安装系统的软件包或模块。',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '数据库中的ACL信息与系统配置不一致，请部署所有ACL。',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '由于未知错误不能导入ACL，请检查OTOBO日志以获得更多信息',
        'The following ACLs have been added successfully: %s' => '下列ACL已经成功添加：%s',
        'The following ACLs have been updated successfully: %s' => '下列ACL已经成功更新：%s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '在添加/更新下列ACL：%s 时出现一些错误，请检查OTOBO日志以获得更多信息。',
        'There was an error creating the ACL' => '创建ACL时出现了一个错误',
        'Need ACLID!' => '需要ACLID！',
        'Could not get data for ACLID %s' => '不能获得ACLID为%s 的数据',
        'There was an error updating the ACL' => '更新ACL时出现了一个错误',
        'There was an error setting the entity sync status.' => '设置条目同步状态时出现了一个错误。',
        'There was an error synchronizing the ACLs.' => '部署ACL时出现了一个错误。',
        'ACL %s could not be deleted' => '不能删除ACL %s',
        'There was an error getting data for ACL with ID %s' => '获得ID为%s 的ACL的数据时出现了一个错误',
        '%s (copy) %s' => '%s (副本) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '请注意，超级用户帐户（UserID 1）将忽略ACL限制。',
        'Exact match' => '完全匹配',
        'Negated exact match' => '完全匹配取反',
        'Regular expression' => '正则表达式',
        'Regular expression (ignore case)' => '正则表达式（忽略大小写）',
        'Negated regular expression' => '正则表达式取反',
        'Negated regular expression (ignore case)' => '正则表达式（忽略大小写）取反',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '系统不能创建日历！',
        'Please contact the administrator.' => '请联系系统管理员。',
        'No CalendarID!' => '没有日历ID！',
        'You have no access to this calendar!' => '你无权访问这个日历！',
        'Error updating the calendar!' => '更新日历出错！',
        'Couldn\'t read calendar configuration file.' => '不能读取日历的配置文件。',
        'Please make sure your file is valid.' => '请确保你的文件是有效的。',
        'Could not import the calendar!' => '无法导入这个日历！',
        'Calendar imported!' => '日历已导入！',
        'Need CalendarID!' => '需要日历ID！',
        'Could not retrieve data for given CalendarID' => '无法返回给定的日历ID的数据',
        'Successfully imported %s appointment(s) to calendar %s.' => '成功将预约%s导入到日历%s。',
        '+5 minutes' => '+5分钟',
        '+15 minutes' => '+15分钟',
        '+30 minutes' => '+30分钟',
        '+1 hour' => '+1小时',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '没有权限',
        'System was unable to import file!' => '系统无法导入文件！',
        'Please check the log for more information.' => '更多信息请检查日志。',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '这个通知的名字已存在!',
        'Notification added!' => '通知已添加！',
        'There was an error getting data for Notification with ID:%s!' =>
            '获取ID为%s的通知数据时出现了一个错误！',
        'Unknown Notification %s!' => '未知通知 %s！',
        '%s (copy)' => '%s (副本)',
        'There was an error creating the Notification' => '创建通知时出现了一个错误',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '由于一个未知错误不能导入通知，请检查OTOBO日志以获取更多信息',
        'The following Notifications have been added successfully: %s' =>
            '下列通知已成功添加：%s',
        'The following Notifications have been updated successfully: %s' =>
            '下列通知已成功更新：%s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '添加/更新下列通知时出现错误：%s，请检查OTOBO日志以获取更多信息。',
        'Notification updated!' => '通知已更新！',
        'Agent (resources), who are selected within the appointment' => '这个预约选择的服务人员（资源）',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '所有对这个预约（日历）至少有读权限的服务人员',
        'All agents with write permission for the appointment (calendar)' =>
            '所有对这个预约（日历）有写权限的服务人员',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '附件已添加！',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '自动响应已添加！',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '无效的通讯ID！',
        'All communications' => '所有通信',
        'Last 1 hour' => '最近1小时',
        'Last 3 hours' => '最近3小时',
        'Last 6 hours' => '最近6小时',
        'Last 12 hours' => '最近12小时',
        'Last 24 hours' => '最近24小时',
        'Last week' => '最近一周',
        'Last month' => '最近一月',
        'Invalid StartTime: %s!' => '无效的开始时间：%s！',
        'Successful' => '成功',
        'Processing' => '处理',
        'Failed' => '失败',
        'Invalid Filter: %s!' => '无效的过滤器：%s！',
        'Less than a second' => '不到一秒钟',
        'sorted descending' => '降序排序',
        'sorted ascending' => '升序排序',
        'Trace' => '跟踪',
        'Debug' => 'Debug（调试）',
        'Info' => 'Info（信息）',
        'Warn' => '警告',
        'days' => '天',
        'day' => '天',
        'hour' => '小时',
        'minute' => '分钟',
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
        'Customer company updated!' => '客户单位已更新！',
        'Dynamic field %s not found!' => '没有找到动态字段“%s”！',
        'Unable to set value for dynamic field %s!' => '不能设置动态字段%s 的值！',
        'Customer Company %s already exists!' => '客户单位 %s 已经存在！',
        'Customer company added!' => '客户单位已添加！',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '找不到\'CustomerGroupPermissionContext（客户组权限上下文）\'的配置！',
        'Please check system configuration.' => '请检查系统配置。',
        'Invalid permission context configuration:' => '无效的权限上下文配置：',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '客户已更新！',
        'New phone ticket' => '创建电话工单',
        'New email ticket' => '创建邮件工单',
        'Customer %s added' => '客户%s已添加',
        'Customer user updated!' => '客户用户已更新！',
        'Same Customer' => '同一客户',
        'Direct' => '直接',
        'Indirect' => '间接',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '修改组的客户用户关系',
        'Change Group Relations for Customer User' => '修改客户用户的组关系',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '分配客户用户到服务',
        'Allocate Services to Customer User' => '分配服务到客户用户',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '不是有效的字段配置',
        'Objects configuration is not valid' => '不是有效的对象配置',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '不能正确地重置动态字段顺序，请检查错误日志以获得更多详细信息。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '没有定义的子动作。',
        'Need %s' => '需要%s',
        'Add %s field' => '添加%s字段',
        'The field does not contain only ASCII letters and numbers.' => '这个字段不是仅包含ASCII字符和数字。',
        'There is another field with the same name.' => '存在同名的另一字段。',
        'The field must be numeric.' => '这个字段必须是数字。',
        'Need ValidID' => '需要有效的ID',
        'Could not create the new field' => '不能创建这个新字段',
        'Need ID' => '需要ID',
        'Could not get data for dynamic field %s' => '不能获得动态字段%s 的数据',
        'Change %s field' => '修改%s字段',
        'The name for this field should not change.' => '不能更改这个字段的名称。',
        'Could not update the field %s' => '不能更新字段 %s',
        'Currently' => '当前',
        'Unchecked' => '未检查',
        'Checked' => '已检查',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => '这个字段值是重复的。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '防止未来的日期条目',
        'Prevent entry of dates in the past' => '防止过去的日期条目',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => '设置被其它用户锁定！',
        'System was not able to reset the setting!' => '系统无法重置该设置！',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '选择至少一个收件人。',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '分钟',
        'hour(s)' => '小时',
        'Time unit' => '时间单位',
        'within the last ...' => '在最近...之内',
        'within the next ...' => '在未来...',
        'more than ... ago' => '在...之前',
        'Unarchived tickets' => '未归档的工单',
        'archive tickets' => '归档工单',
        'restore tickets from archive' => '从归档中恢复工单',
        'Need Profile!' => '需要配置文件！',
        'Got no values to check.' => '没有检查到值。',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '请移除以下不能用于工单选择的词语：',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '需要WebserviceID！',
        'Could not get data for WebserviceID %s' => '不能获得WebserviceID %s的数据',
        'ascending' => '升序',
        'descending' => '降序',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '需要通信类型！',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '通信类型需要是“Requester（请求者）”或“Provider（提供者）”！',
        'Invalid Subaction!' => '无效的子动作！',
        'Need ErrorHandlingType!' => '需要ErrorHandlingType （错误处理类型）！',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType （错误处理类型）%s没有注册',
        'Could not update web service' => '无法更新WEB服务',
        'Need ErrorHandling' => '需要错误处理',
        'Could not determine config for error handler %s' => '无法确定错误处理程序%s的配置',
        'Invoker processing outgoing request data' => '调用模块正在处理发出的请求数据',
        'Mapping outgoing request data' => '正在匹配发出的请求数据',
        'Transport processing request into response' => '传输模块正在处理响应请求',
        'Mapping incoming response data' => '正在匹配传入的响应数据',
        'Invoker processing incoming response data' => '调用模块正在处理传入的响应数据',
        'Transport receiving incoming request data' => '传输模块正在接收传入的请求数据',
        'Mapping incoming request data' => '正在匹配传入的请求数据',
        'Operation processing incoming request data' => '操作模块正在处理传入的请求数据',
        'Mapping outgoing response data' => '正在匹配发出的响应数据',
        'Transport sending outgoing response data' => '传输模块正在发送发出的请求数据',
        'skip same backend modules only' => '只跳过相同的后台模块',
        'skip all modules' => '跳过所有模块',
        'Operation deleted' => '操作已删除',
        'Invoker deleted' => '调用程序已删除',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0秒',
        '15 seconds' => '15秒',
        '30 seconds' => '30秒',
        '45 seconds' => '45秒',
        '1 minute' => '1分钟',
        '2 minutes' => '2分钟',
        '3 minutes' => '3分钟',
        '4 minutes' => '4分钟',
        '5 minutes' => '5分钟',
        '10 minutes' => '10 分钟',
        '15 minutes' => '15 分钟',
        '30 minutes' => '30分钟',
        '1 hour' => '1小时',
        '2 hours' => '2小时',
        '3 hours' => '3小时',
        '4 hours' => '4小时',
        '5 hours' => '5小时',
        '6 hours' => '6小时',
        '12 hours' => '12小时',
        '18 hours' => '18小时',
        '1 day' => '1天',
        '2 days' => '2天',
        '3 days' => '3天',
        '4 days' => '4天',
        '6 days' => '6天',
        '1 week' => '1周',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '不能确定调用程序%s 的配置',
        'InvokerType %s is not registered' => '调用程序类型 %s 没有注册',
        'MappingType %s is not registered' => '映射类型%s 没有注册',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '需要调用程序！',
        'Need Event!' => '需要事件！',
        'Could not get registered modules for Invoker' => '无法获得调用程序的注册模块',
        'Could not get backend for Invoker %s' => '不能获得调用程序 %s的后端',
        'The event %s is not valid.' => '事件 %s 无效。',
        'Could not update configuration data for WebserviceID %s' => '不能更新WebserviceID %s的配置数据',
        'This sub-action is not valid' => '这个子动作无效',
        'xor' => 'xor（异或）',
        'String' => '字符串',
        'Regexp' => '正则表达式',
        'Validation Module' => '验证模块',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '出站数据的简单映射',
        'Simple Mapping for Incoming Data' => '传入数据的简单映射',
        'Could not get registered configuration for action type %s' => '不能获得操作类型%s 的注册配置',
        'Could not get backend for %s %s' => '不能获得 %s %s的后端',
        'Keep (leave unchanged)' => '保持（保持不变）',
        'Ignore (drop key/value pair)' => '忽略（丢弃键/值对）',
        'Map to (use provided value as default)' => '映射到（使用提供的值作为默认值）',
        'Exact value(s)' => '准确值',
        'Ignore (drop Value/value pair)' => '忽略（丢弃键/值对）',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '出站数据的XSLT映射',
        'XSLT Mapping for Incoming Data' => '传入数据的XSLT映射',
        'Could not find required library %s' => '不能找到需要的库%s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '处理前的传出请求数据（RequesterRequestInput）',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '映射前的传出请求数据（RequesterRequestPrepareOutput）',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '映射后的传出请求数据（RequesterRequestMapOutput）',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '映射前的传入响应数据（RequesterResponseInput）',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '错误处理后的传出错误处理程序数据（RequesterErrorHandlingOutput）',
        'Incoming request data before mapping (ProviderRequestInput)' => '映射前的传入请求数据（ProviderRequestInput）',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '映射后的传入请求数据（ProviderRequestMapOutput）',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '映射前的传出响应数据（ProviderResponseInput）',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '错误处理后的传出错误处理程序数据（ProviderErrorHandlingOutput）',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => '不能确定操作%s 的配置',
        'OperationType %s is not registered' => '操作类型%s 没有注册',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '需要有效的子动作！',
        'This field should be an integer.' => '该字段应为整数。',
        'File or Directory not found.' => '找不到文件或目录。',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '存在同名的另一WEB服务。',
        'There was an error updating the web service.' => '更新WEB服务时出现了一个错误。',
        'There was an error creating the web service.' => '创建WEB服务时出现了一个错误。',
        'Web service "%s" created!' => 'Web服务“%s”已经创建！',
        'Need Name!' => '需要名称！',
        'Need ExampleWebService!' => '需要WEB服务示例！',
        'Could not load %s.' => '不能载入 %s。',
        'Could not read %s!' => '不能读取 %s！',
        'Need a file to import!' => '导入需要一个文件！',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '导入的文件没有有效的YAML内容！请检查OTOBO日志以获取详细信息',
        'Web service "%s" deleted!' => 'Web服务“%s”已经删除！',
        'OTOBO as provider' => 'OTOBO作为服务提供方',
        'Operations' => '操作',
        'OTOBO as requester' => 'OTOBO作为服务请求方',
        'Invokers' => '调用程序',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '没有 WebserviceHistoryID ！',
        'Could not get history data for WebserviceHistoryID %s' => '不能获取WebserviceHistoryID为%s的历史数据',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '组已更新！',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '邮件账号已添加！',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '电子邮件帐户提取已被另一个进程提取。 请稍后再试！',
        'Dispatching by email To: field.' => '按收件人(To:)分派。',
        'Dispatching by selected Queue.' => '按所选队列分派。',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '创建该工单的服务人员',
        'Agent who owns the ticket' => '拥有这个工单的服务人员',
        'Agent who is responsible for the ticket' => '对这个工单负责的服务人员',
        'All agents watching the ticket' => '所有关注这个工单的服务人员',
        'All agents with write permission for the ticket' => '所有对这个工单有写权限的服务人员',
        'All agents subscribed to the ticket\'s queue' => '所有关注了工单所在队列的服务人员',
        'All agents subscribed to the ticket\'s service' => '所有关注了工单服务的服务人员',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '所有关注了工单所在队列和工单所属服务的服务人员',
        'Customer user of the ticket' => '该工单的客户用户',
        'All recipients of the first article' => '第一封信件的所有收件人',
        'All recipients of the last article' => '最近一封信件的所有收件人',
        'Invisible to customer' => '客户不可见',
        'Visible to customer' => '对客户可见',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP环境不能正常工作，请检查日志获取更多信息！',
        'Need param Key to delete!' => '需要参数“密钥”才能删除！',
        'Key %s deleted!' => '密钥%s 已删除！',
        'Need param Key to download!' => '需要参数“密钥”才能下载！',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '抱歉，在Apache配置文件中需要Apache::Reload作为PerlModule和PerlInitHandler。另请查看scripts/apache2-httpd.include.conf。或者您也可以使用命令行工具bin/otobo.Console.pl来安装软件包！',
        'No such package!' => '没有这个软件包！',
        'No such file %s in package!' => '软件包中没有%s 文件！',
        'No such file %s in local file system!' => '本地文件系统中没有%s 文件！',
        'Can\'t read %s!' => '不能读取%s！',
        'File is OK' => '文件正常',
        'Package has locally modified files.' => '软件包中有本地修改过的文件。',
        'Package not verified by the OTOBO Team!' => '',
        'Not Started' => '没有启动',
        'Updated' => '更新时间',
        'Already up-to-date' => '已经是最新的',
        'Installed' => '安装时间',
        'Not correctly deployed' => '没有已经正确地部署',
        'Package updated correctly' => '软件包已正确地更新',
        'Package was already updated' => '软件包已经更新',
        'Dependency installed correctly' => '依赖软件已正确地安装',
        'The package needs to be reinstalled' => '需要重新安装这个软件包',
        'The package contains cyclic dependencies' => '软件包包含循环依赖项',
        'Not found in on-line repositories' => '在线软件库中找不到',
        'Required version is higher than available' => '所需版本高于可用版本',
        'Dependencies fail to upgrade or install' => '无法更新或安装依赖软件',
        'Package could not be installed' => '软件包无法安装',
        'Package could not be upgraded' => '软件包无法更新',
        'Repository List' => '软件仓库列表',
        'No packages found in selected repository. Please check log for more info!' =>
            '在选定的软件仓库中找不到软件包， 请查看日志以获取更多信息！',
        'Package not verified due a communication issue with verification server!' =>
            '不能验证软件包，因为与验证服务器无法正常通信！',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '不能连接到OTOBO附加功能列表服务器！',
        'Can\'t get OTOBO Feature Add-on list from server!' => '不能从服务器获取OTOBO附加功能列表！',
        'Can\'t get OTOBO Feature Add-on from server!' => '不能从服务器获取OTOBO附加功能！',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '没有这个过滤器：%s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '优先级已添加!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '数据库中的流程管理信息与系统配置不一致，请同步所有流程。',
        'Need ExampleProcesses!' => '需要ExampleProcesses！',
        'Need ProcessID!' => '需要流程ID！',
        'Yes (mandatory)' => '是（强制）',
        'Unknown Process %s!' => '未知的流程 %s！',
        'There was an error generating a new EntityID for this Process' =>
            '为这个流程生成新的实体ID时出现了一个错误',
        'The StateEntityID for state Inactive does not exists' => '状态为‘非活动的’的StateEntityID不存在',
        'There was an error creating the Process' => '创建该流程时出现了一个错误',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '为流程实体：%s设置实体同步状态时出现了一个错误',
        'Could not get data for ProcessID %s' => '不能获取ID为 %s的流程数据',
        'There was an error updating the Process' => '更新该流程时出现了一个错误',
        'Process: %s could not be deleted' => '不能删除流程：%s',
        'There was an error synchronizing the processes.' => '同步该流程时出现了一个错误。',
        'The %s:%s is still in use' => '%s:%s 仍在使用中',
        'The %s:%s has a different EntityID' => '%s:%s 有一个不同的EntityID',
        'Could not delete %s:%s' => '不能删除 %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '为 %s 实体： %s 设置实体同步状态时出现了一个错误',
        'Could not get %s' => '不能获取 %s',
        'Need %s!' => '需要 %s！',
        'Process: %s is not Inactive' => '流程： %s 的状态不是‘非活动的’',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '为这个活动生成新的EntityID时出现了一个错误',
        'There was an error creating the Activity' => '创建活动时出现了一个错误',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '设置活动实体： %s的同步状态时出现了一个错误',
        'Need ActivityID!' => '需要ActivityID！',
        'Could not get data for ActivityID %s' => '不能获得ActivityID %s的数据',
        'There was an error updating the Activity' => '更新活动时出现了一个错误',
        'Missing Parameter: Need Activity and ActivityDialog!' => '参数缺失：需要活动或活动对话框！',
        'Activity not found!' => '没有找到活动！',
        'ActivityDialog not found!' => '没有找到活动对话框！',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '活动对话框已经分配给活动，不能重复添加活动对话框！',
        'Error while saving the Activity to the database!' => '保存活动到数据库时出错！',
        'This subaction is not valid' => '这个子操作无效',
        'Edit Activity "%s"' => '编辑活动“%s”',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '为这个活动对话框生成一个新EntityID时出现了一个错误',
        'There was an error creating the ActivityDialog' => '创建这个活动对话框时出现了一个错误',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '设置活动对话框实体的同步状态时出现了一个错误',
        'Need ActivityDialogID!' => '需要ActivityDialogID！',
        'Could not get data for ActivityDialogID %s' => '不能获得ActivityDialogID %s的数据',
        'There was an error updating the ActivityDialog' => '更新活动对话框时出现了一个错误',
        'Edit Activity Dialog "%s"' => '编辑活动对话框“%s”',
        'Agent Interface' => '服务人员界面',
        'Customer Interface' => '客户界面',
        'Agent and Customer Interface' => '服务人员和客户界面',
        'Do not show Field' => '不显示字段',
        'Show Field' => '显示字段',
        'Show Field As Mandatory' => '显示字段为必填',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '编辑路径',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '为这个转换生成新的EntityID时出现了一个错误',
        'There was an error creating the Transition' => '创建转换时出现了一个错误',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '设置转换实体的同步状态时出现了一个错误',
        'Need TransitionID!' => '需要TransitionID！',
        'Could not get data for TransitionID %s' => '不能获得TransitionID %s的数据',
        'There was an error updating the Transition' => '更新转换时出现了一个错误',
        'Edit Transition "%s"' => '编辑转换“%s”',
        'Transition validation module' => '转换验证模块',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '至少需要一个有效的配置参数。',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '为这个转换动作生成一个新的EntityID时出现了一个错误',
        'There was an error creating the TransitionAction' => '创建转换动作时出现了一个错误',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '设置转换动作实体：%s的同步状态时出现了一个错误',
        'Need TransitionActionID!' => '需要TransitionActionID！',
        'Could not get data for TransitionActionID %s' => '不能获得TransitionActionID %s的数据',
        'There was an error updating the TransitionAction' => '更新转换动作时出现了一个错误',
        'Edit Transition Action "%s"' => '编辑转换操作“%s”',
        'Error: Not all keys seem to have values or vice versa.' => '错误：不是所有键都有值，或存在没有键的值。',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => '队列已更新！',
        'Don\'t use :: in queue name!' => '不要在队列名称中使用双冒号 “::”！',
        'Click back and change it!' => '点击返回并修改它！',
        '-none-' => '-无-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '没有自动响应的队列',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '修改模板的队列关系',
        'Change Template Relations for Queue' => '修改队列的模板关系',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '生产',
        'Test' => '测试',
        'Training' => '培训',
        'Development' => '开发',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '角色已更新！',
        'Role added!' => '角色已添加！',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => '为角色指定组权限',
        'Change Role Relations for Group' => '为组指定角色权限',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '角色',
        'Change Role Relations for Agent' => '为服务人员指定角色',
        'Change Agent Relations for Role' => '为角色指定服务人员',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '请首先激活%s！',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME环境没有正常工作，请检查日志以获取更多信息！',
        'Need param Filename to delete!' => '需要参数文件名才能删除！',
        'Need param Filename to download!' => '需要参数文件名才能下载！',
        'Needed CertFingerprint and CAFingerprint!' => '需要证书指纹和认证机构指纹！',
        'CAFingerprint must be different than CertFingerprint' => '认证机构指纹必须与证书指纹不同',
        'Relation exists!' => '关系已经存在！',
        'Relation added!' => '关系已添加！',
        'Impossible to add relation!' => '不可能添加关系！',
        'Relation doesn\'t exists' => '关系不存在',
        'Relation deleted!' => '关系已删除！',
        'Impossible to delete relation!' => '不可能删除关系！',
        'Certificate %s could not be read!' => '不能读取证书 %s ！',
        'Needed Fingerprint' => '需要指纹',
        'Handle Private Certificate Relations' => '处理私有证书关系',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '问候语已添加！',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '签名已更新!',
        'Signature added!' => '签名已添加!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '状态已添加！',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '不能读取文件%s！',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '系统邮件地址已添加！',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '无效的设置',
        'There are no invalid settings active at this time.' => '当前没有使用无效的设置。',
        'You currently don\'t have any favourite settings.' => '你目前没有收藏任何设置。',
        'The following settings could not be found: %s' => '找不到以下设置：%s',
        'Import not allowed!' => '不允许导入！',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            '由于一个未知错误不能导入系统配置，请检查OTOBO日志以获取更多信息。',
        'Category Search' => '搜索类别',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            '某些导入的设置不在配置的当前状态中，或者无法进行更新。 请查看OTOBO日志了解更多信息。',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '锁定之前需要启用该设置！',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '你无法编辑此设置，因为%s（%s）目前正在编辑。',
        'Missing setting name!' => '缺少设置名称！',
        'Missing ResetOptions!' => '缺少重置选项！',
        'System was not able to lock the setting!' => '系统无法锁定该设置！',
        'System was unable to update setting!' => '系统无法更新该设置！',
        'Missing setting name.' => '缺少设置名称。',
        'Setting not found.' => '没有找到设置。',
        'Missing Settings!' => '缺少设置！',

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
        'Start date shouldn\'t be defined after Stop date!' => '开始日期不能在结束日期之后！',
        'There was an error creating the System Maintenance' => '创建系统维护时出现了一个错误',
        'Need SystemMaintenanceID!' => '需要SystemMaintenanceID！',
        'Could not get data for SystemMaintenanceID %s' => '不能获得SystemMaintenanceID %s的数据',
        'System Maintenance was added successfully!' => '系统维护添加成功！',
        'System Maintenance was updated successfully!' => '系统维护更新成功！',
        'Session has been killed!' => '会话已经被终止掉！',
        'All sessions have been killed, except for your own.' => '除了本会话外，所有会话都已经被kill掉。',
        'There was an error updating the System Maintenance' => '更新系统维护时出现了一个错误',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '不能删除系统维护条目：%s！',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '模板已更新！',
        'Template added!' => '模板已添加！',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '为模板指定附件',
        'Change Template Relations for Attachment' => '为附件指定模板',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '需要类型！',
        'Type added!' => '类型已添加！',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '服务人员已更新！',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '修改此服务人员的组权限',
        'Change Agent Relations for Group' => '为此组选择服务人员的权限',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '月',
        'Week' => '周',
        'Day' => '日',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '所有预约',
        'Appointments assigned to me' => '分配给我的预约',
        'Showing only appointments assigned to you! Change settings' => '仅显示分配给你的预约！修改设置',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '没有找到预约！',
        'Never' => '永不',
        'Every Day' => '每天',
        'Every Week' => '每周',
        'Every Month' => '每月',
        'Every Year' => '每年',
        'Custom' => '定制',
        'Daily' => '每天一次',
        'Weekly' => '每周一次',
        'Monthly' => '每月一次',
        'Yearly' => '每年一次',
        'every' => '每',
        'for %s time(s)' => '%s次',
        'until ...' => '直到...',
        'for ... time(s)' => '...次',
        'until %s' => '直到%s',
        'No notification' => '没有通知',
        '%s minute(s) before' => '%s分钟前',
        '%s hour(s) before' => '%s小时前',
        '%s day(s) before' => '%s天前',
        '%s week before' => '%s周前',
        'before the appointment starts' => '在预约开始前',
        'after the appointment has been started' => '在预约开始后',
        'before the appointment ends' => '在预约结束前',
        'after the appointment has been ended' => '在预约结束后',
        'No permission!' => '没有权限！',
        'Cannot delete ticket appointment!' => '不能删除工单预约！',
        'No permissions!' => '没有权限！',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s 更多',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '客户历史',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '没有指定收件人字段！',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '没有%s 的配置',
        'Statistic' => '统计',
        'No preferences for %s!' => '没有%s的偏好设置！',
        'Can\'t get element data of %s!' => '不能获得%s 的元素数据！',
        'Can\'t get filter content data of %s!' => '不能获得%s 的过滤器内容数据！',
        'Customer Name' => '客户名字',
        'Customer User Name' => '客户用户姓名',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '需要SourceObject（源对象）和SourceKey（源键）！',
        'You need ro permission!' => '需要ro只读权限！',
        'Can not delete link with %s!' => '不能删除到%s的链接！',
        '%s Link(s) deleted successfully.' => '成功删除%s个链接。',
        'Can not create link with %s! Object already linked as %s.' => '不能创建到 %s 的连接！对象已连接为 %s。',
        'Can not create link with %s!' => '不能创建到%s的链接！',
        '%s links added successfully.' => '成功添加%s个链接。',
        'The object %s cannot link with other object!' => '对象 %s 不能被其它对象链接！',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '参数“组”是必需的！',
        'This feature is not available.' => '',
        'Updated user preferences' => '用户偏好设置已更新',
        'System was unable to deploy your changes.' => '系统无法部署你的变更。',
        'Setting not found!' => '没有找到设置！',
        'System was unable to reset the setting!' => '系统无法重置该设置！',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '流程工单',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '缺失参数“%s”。',
        'Invalid Subaction.' => '无效的子动作。',
        'Statistic could not be imported.' => '不能导入统计。',
        'Please upload a valid statistic file.' => '请上传一个有效的统计文件。',
        'Export: Need StatID!' => '导出：需要StatID（统计ID）！',
        'Delete: Get no StatID!' => '删除：没有StatID（统计ID）！',
        'Need StatID!' => '需要StatID（统计ID）！',
        'Could not load stat.' => '不能载入统计。',
        'Add New Statistic' => '添加新的统计',
        'Could not create statistic.' => '不能创建统计。',
        'Run: Get no %s!' => '运行：没有获得 %s！',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '没有指定TicketID 工单编号！',
        'You need %s permissions!' => '需要%s 权限！',
        'Loading draft failed!' => '加载草稿失败！',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '只有工单的所有者才能执行此操作。',
        'Please change the owner first.' => '请先更改工单的所有者.',
        'FormDraft functionality disabled!' => '表单草稿功能已禁用！',
        'Draft name is required!' => '草稿名称是必需的！',
        'FormDraft name %s is already in use!' => '表单草稿的名称%s已使用！',
        'Could not perform validation on field %s!' => '不能验证字段%s ！',
        'No subject' => '没有主题',
        'Could not delete draft!' => '无法删除草稿！',
        'Previous Owner' => '前一个所有者',
        'wrote' => '写道',
        'Message from' => '消息来自',
        'End message' => '消息结束',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '需要%s！',
        'Plain article not found for article %s!' => '信件 %s 的纯文本没有找到！',
        'Article does not belong to ticket %s!' => '信件不属于工单%s！',
        'Can\'t bounce email!' => '不能退回邮件！',
        'Can\'t send email!' => '不能发送邮件！',
        'Wrong Subaction!' => '错误的子操作！',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '不能锁定工单，没有指定工单编辑！',
        'Ticket (%s) is not unlocked!' => '工单（%s）没有解锁！',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，下列工单将被忽略：%s。',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，此工单将被忽略：%s。',
        'You need to select at least one ticket.' => '你需要选择至少一个工单。',
        'Bulk feature is not enabled!' => '批量操作功能还没有启用！',
        'No selectable TicketID is given!' => '没有指定可选择的工单编号！',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '你要么没有选择工单，要么只选择了已被其他服务人员锁定的工单。',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，下列工单将被忽略：%s。',
        'The following tickets were locked: %s.' => '下列工单已被锁定：%s。',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '如果主题只包含工单钩子，则信件主题将为空！',
        'Address %s replaced with registered customer address.' => '地址%s已被注册的客户地址所替换。',
        'Customer user automatically added in Cc.' => '客户用户被自动地添加到Cc中.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '工单“%s”已创建!',
        'No Subaction!' => '没有子操作！',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '没有获得工单编号！',
        'System Error!' => '系统错误！',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '没有指定信件ID！',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '下周',
        'Ticket Escalation View' => '工单升级视图',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '没有找到信件%s！',
        'Forwarded message from' => '已转发的消息来自',
        'End forwarded message' => '转发消息结束',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '不能显示历史，没有指定工单编号！',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '不能锁定工单，没有指定工单编号！',
        'Sorry, the current owner is %s!' => '抱歉，当前所有者是：%s！',
        'Please become the owner first.' => '请首先成为所有者。',
        'Ticket (ID=%s) is locked by %s!' => '工单（ID=%s）已被 %s 锁定！',
        'Change the owner!' => '变更所有者！',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '新信件',
        'Pending' => '挂起',
        'Reminder Reached' => '提醒时间已过',
        'My Locked Tickets' => '我锁定的工单',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '不能将工单合并到它自己！',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '你需要转换权限！',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '聊天不是活动的。',
        'No permission.' => '没有权限。',
        '%s has left the chat.' => '%s已经离开了聊天。',
        'This chat has been closed and will be removed in %s hours.' => '这个聊天已经关闭，将在%s小时内删除。',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '工单已锁定.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '没有ArticleID！',
        'This is not an email article.' => '这不是电子邮件信件。',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '不能读取纯文本信件！可能在后端没有纯文件邮件！读取后端消息。',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '需要TicketID 工单编号！',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '不能获取ActivityDialogEntityID “%s”！',
        'No Process configured!' => '还没有配置流程！',
        'The selected process is invalid!' => '所选择的流程无效!',
        'Process %s is invalid!' => '流程%s 无效！',
        'Subaction is invalid!' => '子操作无效！',
        'Parameter %s is missing in %s.' => '缺失参数“%s”，在“%s”。',
        'No ActivityDialog configured for %s in _RenderAjax!' => '在函数_RenderAjax中 %s 没有配置活动对话框！',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '在函数_GetParam 中没有获得流程 %s 的开始活动实体ID或开始活动对话框实体ID！',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '在函数_GetParam 中不能获取工单编号为 %s 的工单！',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '不能确定活动实体ID，动态字段或配置不正确！',
        'Process::Default%s Config Value missing!' => 'Process::Default%s 没有配置值！',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '没有获得流程实体ID，或者没有获得工单ID和活动对话框实体ID！',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '不能获得流程实体ID为“%s”的开始活动和开始活动对话框！',
        'Can\'t get Ticket "%s"!' => '不能获得工单“%s”！',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '不能获得工单“%s”的流程实体ID或活动实体ID！',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '不能获得活动实体ID “%s”的活动配置！',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '不能获得活动对话框实体ID “%s”的活动对话框配置！',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '不能获取活动对话框“%s”的动态字段“%s”的数据！',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '挂起时间只能在同一个活动对话框配置了状态或状态ID时使用。活动对话框：%s！',
        'Pending Date' => '挂起时间',
        'for pending* states' => '针对各种挂起状态',
        'ActivityDialogEntityID missing!' => '缺少ActivityDialogEntityID（活动对话框实体ID）！',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '不能获得ActivityDialogEntityID（活动对话框实体ID） “%s”的配置！',
        'Couldn\'t use CustomerID as an invisible field.' => '不能将CustomerID（客户ID）用作不可见字段。',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '缺少ProcessEntityID（流程实体ID），请检查您的模板文件ActivityDialogHeader.tt！',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '流程“%s”没有配置开始活动或开始活动对话框！',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '不能为流程实体ID为“%s”的流程创建工单！',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '不能设置流程实体ID “%s”在工单ID “%s”中！',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '不能设置活动实体ID “%s”在工单ID “%s”中！',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '不能存储活动对话框，无效的工单ID： %s！',
        'Invalid TicketID: %s!' => '无效的工单ID： “%s”！',
        'Missing ActivityEntityID in Ticket %s!' => '在工单 “%s”中缺少活动实体ID！',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '此步骤不再属于工单“%s%s%s”流程的当前活动！ 另一位用户在此期间改变了这个工单。请关闭此窗口，再重新加载这个工单。',
        'Missing ProcessEntityID in Ticket %s!' => '在工单 “%s”中缺少流程实体ID！',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置动态字段“%s”的值，工单ID为“%s”，活动对话框 “%s”！',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置工单 “%s”的挂起时间，活动对话框 “%s”！',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '错误的活动对话框字段配置：%s 不能设置为Display => 1/显示字段（请修改它的配置为Display => 0/不显示字段或Display => 2 /强制显示字段）！',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置“%s”，工单ID为“%s”，活动对话框 “%s”！',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s 默认配置缺失！',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s 默认配置无效！',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '未锁定的工单',
        'including subqueues' => '包含子队列',
        'excluding subqueues' => '排除子队列',
        'QueueView' => '队列视图',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '我负责的工单',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '上次搜索',
        'Untitled' => '无标题',
        'Ticket Number' => '工单编号',
        'Ticket' => '工单',
        'printed by' => '打印人：',
        'CustomerID (complex search)' => 'CustomerID(复合搜索)',
        'CustomerID (exact match)' => 'CustomerID(精确匹配)',
        'Invalid Users' => '无效用户',
        'Normal' => '普通',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => '不超过...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '功能没有启用！',
        'Service View' => '服务视图',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => '状态视图',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '我关注的工单',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '功能没有激活',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '连接已删除',
        'Ticket Locked' => '工单已锁定',
        'Pending Time Set' => '挂起时间设置',
        'Dynamic Field Updated' => '动态字段已更新',
        'Outgoing Email (internal)' => '外发邮件-内部',
        'Ticket Created' => '工单已创建',
        'Type Updated' => '类型已更新',
        'Escalation Update Time In Effect' => '实际升级更新时间',
        'Escalation Update Time Stopped' => '升级更新时间已停止',
        'Escalation First Response Time Stopped' => '升级首次响应时间已停止',
        'Customer Updated' => '客户用户已更新',
        'Internal Chat' => '内部聊天',
        'Automatic Follow-Up Sent' => '发送自动跟进',
        'Note Added' => '已增加备注',
        'Note Added (Customer)' => '已增加备注-客户用户',
        'SMS Added' => '短信已添加',
        'SMS Added (Customer)' => '短信已添加（客户）',
        'State Updated' => '状态已更新',
        'Outgoing Answer' => '答复',
        'Service Updated' => '服务已更新',
        'Link Added' => '连接已增加',
        'Incoming Customer Email' => '客户来信',
        'Incoming Web Request' => '进入的WEB请求',
        'Priority Updated' => '优先级已更新',
        'Ticket Unlocked' => '工单已解锁',
        'Outgoing Email' => '外发邮件',
        'Title Updated' => '主题已更新',
        'Ticket Merged' => '工单已合并',
        'Outgoing Phone Call' => '致电',
        'Forwarded Message' => '已转发的消息',
        'Removed User Subscription' => '已移除的用户订阅',
        'Time Accounted' => '所用时间',
        'Incoming Phone Call' => '来电',
        'System Request.' => '系统请求。',
        'Incoming Follow-Up' => '进入的跟进',
        'Automatic Reply Sent' => '发送自动回复',
        'Automatic Reject Sent' => '自动拒绝已发送',
        'Escalation Solution Time In Effect' => '实际升级解决时间',
        'Escalation Solution Time Stopped' => '升级解决时间已停止',
        'Escalation Response Time In Effect' => '实际升级响应时间',
        'Escalation Response Time Stopped' => '升级响应时间已停止',
        'SLA Updated' => 'SLA 已更新',
        'External Chat' => '外部聊天',
        'Queue Changed' => '队列已变更',
        'Notification Was Sent' => '通知已发送',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '这个工单不存在，或者它的当前状态下你无权访问它。',
        'Missing FormDraftID!' => '缺少表单草稿ID！',
        'Can\'t get for ArticleID %s!' => '不能获得ID为“%s”的信件！',
        'Article filter settings were saved.' => '信件过滤器设置已保存。',
        'Event type filter settings were saved.' => '事件类型过滤器设置已保存。',
        'Need ArticleID!' => '需要信件ID！',
        'Invalid ArticleID!' => '无效的信件ID！',
        'Forward article via mail' => '通过邮件转发信件',
        'Forward' => '转发',
        'Fields with no group' => '没有分组的字段',
        'Invisible only' => '仅不可见的',
        'Visible only' => '仅可见的',
        'Visible and invisible' => '所有的',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '不能打开信件！或许它在另外一个信件页面上打开了？',
        'Show one article' => '显示单一信件',
        'Show all articles' => '显示所有信件',
        'Show Ticket Timeline View' => '以时间轴视图显示工单',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '没有获取到表单ID。',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '错误：文件无法正确删除，请联系您的管理员（缺少文件ID）。',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '需要信件ID！',
        'No TicketID for ArticleID (%s)!' => '信件ID (%s)没有工单ID！',
        'HTML body attachment is missing!' => '缺少HTML body附件！',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '需要文件ID和信件ID！',
        'No such attachment (%s)!' => '没有这个附件（%s）！',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '检查系统配置 %s::QueueDefault 的设置。',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '检查系统配置 %s::TicketTypeDefault 的设置。',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '您没有足够的权限在默认队列中创建工单。',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '需要客户ID！',
        'My Tickets' => '我的工单',
        'Company Tickets' => '单位工单',
        'Untitled!' => '未命名！',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '客户用户真实姓名',
        'Created within the last' => '在最近...之内创建的',
        'Created more than ... ago' => '在...之前创建的',
        'Please remove the following words because they cannot be used for the search:' =>
            '请移除以下不能用于搜索的词语：',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '不能重新处理工单，在这个队列不可能！',
        'Create a new ticket!' => '创建一个新工单！',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '激活了安全模式！',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '如果你要重新运行安装程序，请在系统配置中禁用安全模式。',
        'Directory "%s" doesn\'t exist!' => '目录 “%s”不存在！',
        'Configure "Home" in Kernel/Config.pm first!' => '首先在文件Kernel/Config.pm中配置“Home”！',
        'File "%s/Kernel/Config.pm" not found!' => '没有找到文件“%s/Kernel/Config.pm”！',
        'Directory "%s" not found!' => '没有找到目录“%s”！',
        'Install OTOBO' => '安装OTOBO',
        'Intro' => '介绍',
        'Kernel/Config.pm isn\'t writable!' => '文件Kernel/Config.pm不可写入！',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '如果你要使用安装器，设置WEB服务器用户对文件Kernel/Config.pm有写权限！',
        'Database Selection' => '数据库选择',
        'Unknown Check!' => '未知的检查！',
        'The check "%s" doesn\'t exist!' => '检查“%s”不存在！',
        'Enter the password for the database user.' => '输入数据库用户密码。',
        'Database %s' => '数据库%s',
        'Configure MySQL' => '配置MySQL',
        'Enter the password for the administrative database user.' => '输入数据库管理员密码。',
        'Configure PostgreSQL' => '配置PostgreSQL',
        'Configure Oracle' => '配置ORACLE',
        'Unknown database type "%s".' => '未知的数据库类型“%s”。',
        'Please go back.' => '请返回。',
        'Create Database' => '创建数据库',
        'Install OTOBO - Error' => '安装OTOBO - 错误',
        'File "%s/%s.xml" not found!' => '没有找到文件“%s/%s.xml”！',
        'Contact your Admin!' => '联系你的系统管理员！',
        'System Settings' => '系统设置',
        'Syslog' => 'Syslog',
        'Configure Mail' => '配置邮件',
        'Mail Configuration' => '邮件配置',
        'Can\'t write Config file!' => '不能写入配置文件！',
        'Unknown Subaction %s!' => '未知的子操作 %s！',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '不能连接到数据库，没有安装Perl模块 DBD::%s！',
        'Can\'t connect to database, read comment!' => '不能连接到数据库，读取注释！',
        'Database already contains data - it should be empty!' => '数据库中已包含数据 - 应该清空它！',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '错误：请确认你的数据库能够接收大于%sMB的数据包（目前能够接收的最大数据包为%sMB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '错误：请设置数据库参数innodb_log_file_size至少为%s MB（当前：%s MB，推荐：%s MB），请参阅 %s 获取更多信息。',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '没有%s!',
        'No such user!' => '没有这个用户！',
        'Invalid calendar!' => '无效日历！',
        'Invalid URL!' => '无效网址！',
        'There was an error exporting the calendar!' => '导出日历时出错！',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '需要配置 Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => '从 %s 身份认证失败！',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => '聊天',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '将邮件退回到另一个邮箱地址',
        'Bounce' => '退回',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '回复所有',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '重发这个信件',
        'Resend' => '重发',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '查看这个信件的消息日志详细信息',
        'Message Log' => '消息日志',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '回复为备注',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '拆分信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '查看这个信件的源',
        'Plain Format' => '纯文本格式',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '打印信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '请通过sales@otrs.com联系我们',
        'Get Help' => '获取帮助',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '标记',
        'Unmark' => '取消标记',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '重新安装软件包',
        'Re-install' => '重新安装',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => '已加密',
        'Sent message encrypted to recipient!' => '发送加密消息到收件人！',
        'Signed' => '已签名',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '发现无效的“PGP签名消息”头标识！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '发现无效的“S/MIME签名消息”头标识！',
        'Ticket decrypted before' => '工单解密在……之前',
        'Impossible to decrypt: private key for email was not found!' => '无法解密：没有找到邮件的私钥！',
        'Successful decryption' => '成功解密',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 没有加密密钥可用。 ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 没有选择加密密钥。 ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 无法使用过期的加密密钥。 ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 不能使用已撤销的加密密钥。 ',
        'Encrypt' => '加密',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '密钥/证书只会显示给具有多个密钥/证书的收件人，找到的第一个密钥/证书将被预选，请确保选择了正确的密钥/证书。',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '电子邮件安全',
        'PGP sign' => 'PGP签名',
        'PGP sign and encrypt' => 'PGP签名和加密',
        'PGP encrypt' => 'PGP加密',
        'SMIME sign' => 'SMIME签名',
        'SMIME sign and encrypt' => 'SMIME签名和加密',
        'SMIME encrypt' => 'SMIME加密',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '不能使用过期的签名密钥：\'%s\'。 ',
        'Cannot use revoked signing key: \'%s\'. ' => '不能使用已撤销的签名密钥：“%s”。 ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '没有签名密钥可用于地址：\'%s\'。',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '地址：\'%s\'没有选择签名密钥。',
        'Sign' => '签名',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '密钥/证书只会显示给具有多个密钥/证书的发件人，找到的第一个密钥/证书将被预选，请确保选择了正确的密钥/证书。',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '显示',
        'Refresh (minutes)' => '刷新（分钟）',
        'off' => '关',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '显示客户ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '显示客户用户',
        'Offline' => '离线',
        'User is currently offline.' => '用户当前离线。',
        'User is currently active.' => '用户当前已激活。',
        'Away' => '离开',
        'User was inactive for a while.' => '用户暂时未激活。',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '工单开始时间被设置在结束时间之后！',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => '无法连接OTOBO新闻服务器！',
        'Can\'t get OTOBO News from server!' => '无法从服务器获取OTOBO新闻！',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '无法连接到产品新闻服务器！',
        'Can\'t get Product News from server!' => '无法从服务器获取产品新闻！',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '无法连接到%s！',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => '显示工单',
        'Shown Columns' => '显示字段',
        'filter not active' => '过滤器没有激活',
        'filter active' => '过滤器是活动的',
        'This ticket has no title or subject' => '这个工单没有标题或主题',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '最近7天统计',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '用户设置他们的状态为不可用。',
        'Unavailable' => '不可用',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => '标准',
        'The following tickets are not updated: %s.' => '下列工单没有更新：%s。',
        'h' => '时',
        'm' => '分',
        'd' => '天',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '这个工单不存在，或者它的当前状态下你无权访问它。你可以采取下列操作之一：',
        'This is a' => '这是一个',
        'email' => '电子邮件',
        'click here' => '点击这里',
        'to open it in a new window.' => '在新窗口中打开。',
        'Year' => '年',
        'Hours' => '小时',
        'Minutes' => '分钟',
        'Check to activate this date' => '选中它，以便激活这个日期',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '无权限!',
        'No Permission' => '没有权限',
        'Show Tree Selection' => '显示树状选项',
        'Split Quote' => '拆分引用',
        'Remove Quote' => '移除引用',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '链接为',
        'Search Result' => '搜索结果',
        'Linked' => '已链接',
        'Bulk' => '批量',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => '精简',
        'Unread article(s) available' => '未读信件',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '预约',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '归档搜索',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => '在线服务人员：%s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '还有更多升级的工单！',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '请在偏好设置中选择一个时区，然后单击保存按钮进行确认。',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => '在线客户: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '正在进行系统维护！',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '一次系统维护将开始于：%s，预计结束时间为：%s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO守护进程没有运行。',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '你已设置为不在办公室，是否取消它?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '您已经部署了%s个无效的设置，点击此处显示无效的设置。',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '你有取消部署的设置，是否要部署它们？',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '配置正在更新，请耐心等待...',
        'There is an error updating the system configuration!' => '更新系统配置时出现错误！',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '不要用超级用户帐户使用%s！ 创建新的服务人员，并使用这些帐户进行工作。',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '请确保您已经为强制通知选择至少一种传输方法。',
        'Preferences updated successfully!' => '偏好设置更新成功！',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '（进行中）',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '请指定在开始时间之后的结束时间。',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => '重复新密码',
        'The current password is not correct. Please try again!' => '当前密码不正确，请重新输入！',
        'Please supply your new password!' => '请提供你的新密码!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '当前系统配置禁止此密码，如有其他问题，请联系管理员。',
        'Can\'t update password, it must be at least %s characters long!' =>
            '无法修改密码，密码至少需要%s个字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '无法更新密码，必须至少包含2个小写字母和2个大写字母！',
        'Can\'t update password, it must contain at least 1 digit!' => '无法修改密码，密码至少需要1个数字字符！',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '无法更新密码，必须至少包含2个字母字符！',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '时区更新成功！',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '无效',
        'valid' => '有效',
        'No (not supported)' => '不支持',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '没有选择过去完成的或“当前+即将”完成的相对时间值。',
        'The selected time period is larger than the allowed time period.' =>
            '选择的时间段超出了允许的时间段。',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'X轴没有可用的时间刻度值。',
        'The selected date is not valid.' => '选择的日期无效。',
        'The selected end time is before the start time.' => '选择的结束日期在开始日期之前。',
        'There is something wrong with your time selection.' => '您选择的时间有一些问题。',
        'Please select only one element or allow modification at stat generation time.' =>
            '请只选择一个元素或允许在统计生成时修改。',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '请选择至少一个值或允许在统计生成时修改。',
        'Please select one element for the X-axis.' => '请为X轴选择一个元素。',
        'You can only use one time element for the Y axis.' => '您只能在Y轴上使用一个时间元素。',
        'You can only use one or two elements for the Y axis.' => '您只能在Y轴上使用一个或两个元素。',
        'Please select at least one value of this field.' => '请为这个字段选择至少一个值。',
        'Please provide a value or allow modification at stat generation time.' =>
            '请提供至少一个值或允许在统计生成时修改。',
        'Please select a time scale.' => '请选择一个时间刻度。',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '您的报表时间间隔太短，请使用更大一点的时间刻度。',
        'second(s)' => '秒',
        'quarter(s)' => '一刻钟',
        'half-year(s)' => '半年',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '请删除以下不能用于工单限制的词语：%s。',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '取消编辑并解锁此设置',
        'Reset this setting to its default value.' => '将这个设置重置为默认值。',
        'Unable to load %s!' => '无法加载%s！',
        'Content' => '值',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '解锁并释放工单到队列',
        'Lock it to work on it' => '锁定并处理工单',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '取消关注',
        'Remove from list of watched tickets' => '从关注工单列表中移除',
        'Watch' => '关注',
        'Add to list of watched tickets' => '添加到关注工单列表',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '排序',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => '新的锁定工单数',
        'Locked Tickets Reminder Reached' => '提醒过的锁定工单数',
        'Locked Tickets Total' => '锁定工单总数',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '负责的新工单数',
        'Responsible Tickets Reminder Reached' => '提醒过的负责的工单数',
        'Responsible Tickets Total' => '负责的工单总数',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '关注的新工单数',
        'Watched Tickets Reminder Reached' => '关注且提醒过的工单数',
        'Watched Tickets Total' => '关注的工单总数',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '工单动态字段',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '无法读取ACL配置文件。 请确保该文件有效。',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '当前正在执行计划内的系统维护，暂时无法登录。',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => '会话数量已超，请过会再试。',
        'Session per user limit reached!' => '达到用户会话限制！',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '会话无效，请重新登录。',
        'Session has timed out. Please log in again.' => '会话超时，请重新登录。',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '仅PGP签名',
        'PGP encrypt only' => '仅PGP加密',
        'SMIME sign only' => '仅SMIME签名',
        'SMIME encrypt only' => '仅SMIME加密',
        'PGP and SMIME not enabled.' => '没有启用PGP和SMIME。',
        'Skip notification delivery' => '跳过通知递送',
        'Send unsigned notification' => '发送未签名的通知',
        'Send unencrypted notification' => '发送未加密的通知',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '配置选项参考手册',
        'This setting can not be changed.' => '这个设置不能修改。',
        'This setting is not active by default.' => '这个设置默认没有激活。',
        'This setting can not be deactivated.' => '不能使这个设置失效。',
        'This setting is not visible.' => '这个设置不可见。',
        'This setting can be overridden in the user preferences.' => '这个设置可以在用户偏好设置中被覆盖。',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '这个设置可以在用户偏好设置中被覆盖，但默认不会处于活动状态。。',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '客户用户“%s”已经存在。',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '这个电子邮件地址已被其他客户用户使用。',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => '在...之前/之后',
        'between' => '在...之间',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '如：Text或Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '忽略该字段。',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '这个字段是必填的',
        'The field content is too long!' => '字段值太长了！',
        'Maximum size is %s characters.' => '最多%s个字符。',

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
            '无法读取通知配置文件。 请确保该文件有效。',
        'Imported notification has body text with more than 4000 characters.' =>
            '导入的通知包含的正文文本超过4000个字符。',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '没有安装',
        'installed' => '已安装',
        'Unable to parse repository index document.' => '无法解析软件仓库索引文档。',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '软件仓库中没有当前系统版本可用的软件包。',
        'File is not installed!' => '文件没有安装！',
        'File is different!' => '文件被修改！',
        'Can\'t read file!' => '不能读取文件！',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '',
        'Package not verified by the OTOBO community!' => '',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '流程“%s”及其所有数据已成功导入。',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '非活动的',
        'FadeAway' => '消退',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '不能连接到注册服务器，请稍后重试。',
        'No content received from registration server. Please try again later.' =>
            '注册服务器未返回有效信息，请稍后重试。',
        'Can\'t get Token from sever' => '不能从服务器获取令牌',
        'Username and password do not match. Please try again.' => '用户名与密码不匹配，请重试。',
        'Problems processing server result. Please try again later.' => '处理服务器返回信息时出现问题，请稍后重试。',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '总和',
        'week' => '星期',
        'quarter' => '一刻钟',
        'half-year' => '半年',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '工单状态类型',
        'Created Priority' => '创建的优先级',
        'Created State' => '创建的状态',
        'Create Time' => '创建时间',
        'Pending until time' => '挂起待定时间',
        'Close Time' => '关闭时间',
        'Escalation' => '升级',
        'Escalation - First Response Time' => '首次响应时间升级',
        'Escalation - Update Time' => '更新时间升级',
        'Escalation - Solution Time' => '解决时间升级',
        'Agent/Owner' => '服务人员/所有者',
        'Created by Agent/Owner' => '创建人',
        'Assigned to Customer User Login' => '分配给客户用户登录名',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '评估方法',
        'Ticket/Article Accounted Time' => '工单/信件所用工时',
        'Ticket Create Time' => '工单创建时间',
        'Ticket Close Time' => '工单关闭时间',
        'Accounted time by Agent' => '服务人员处理工单所用工时',
        'Total Time' => '时间总合',
        'Ticket Average' => '工单平均处理时间',
        'Ticket Min Time' => '工单最小处理时间',
        'Ticket Max Time' => '工单最大处理时间',
        'Number of Tickets' => '工单数',
        'Article Average' => '信件平均处理时间',
        'Article Min Time' => '信件最小处理时间',
        'Article Max Time' => '信件最大处理时间',
        'Number of Articles' => '信件数',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '无限制',
        'Attributes to be printed' => '要打印的属性',
        'Sort sequence' => '排序',
        'State Historic' => '状态历史',
        'State Type Historic' => '工单状态类型历史',
        'Historic Time Range' => '历史信息的时间范围',
        'Number' => '编号',
        'Last Changed' => '最近更改',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '平均解决时间',
        'Solution Min Time' => '最小解决时间',
        'Solution Max Time' => '最大解决时间',
        'Solution Average (affected by escalation configuration)' => '平均解决时间（受升级配置影响）',
        'Solution Min Time (affected by escalation configuration)' => '最小解决时间（受升级配置影响）',
        'Solution Max Time (affected by escalation configuration)' => '最大解决时间（受升级配置影响）',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '平均解决工作时间（受升级配置影响）',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '最小解决工作时间（受升级配置影响）',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '最大解决工作时间（受升级配置影响）',
        'First Response Average (affected by escalation configuration)' =>
            '平均首次响应时间（受升级配置影响）',
        'First Response Min Time (affected by escalation configuration)' =>
            '最小首次响应时间（受升级配置影响）',
        'First Response Max Time (affected by escalation configuration)' =>
            '最大首次响应时间（受升级配置影响）',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '平均首次响应工作时间（受升级配置影响）',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '最小首次响应工作时间（受升级配置影响）',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '最大首次响应工作时间（受升级配置影响）',
        'Number of Tickets (affected by escalation configuration)' => '工单数量（受升级配置影响）',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => '天',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '过时的表',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '在数据库中找到了过时的表，如果空的话可以将其删除。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '表存在',
        'Internal Error: Could not open file.' => '内部错误：不能打开文件。',
        'Table Check' => '表检查',
        'Internal Error: Could not read file.' => '内部错误：不能读取文件。',
        'Tables found which are not present in the database.' => '数据库中不存在的表。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '数据库大小',
        'Could not determine database size.' => '不能确定数据库大小。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '数据库版本',
        'Could not determine database version.' => '不能确定数据库版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '客户端连接字符集',
        'Setting character_set_client needs to be utf8.' => 'character_set_client 需要设置为utf8。',
        'Server Database Charset' => '服务器端数据库字符集',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => 'character_set_database 需要设置为\'utf8\'。',
        'Table Charset' => '表字符集',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '字符集没有设置成 \'utf8\'的表。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB日志文件大小',
        'The setting innodb_log_file_size must be at least 256 MB.' => '参数innodb_log_file_size必须设置为至少256MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '无效的默认值',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '找到具有无效的默认值的表。 为了自动修复它，请运行：bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '最大查询大小',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '\'max_allowed_packet\'必须设置为大于64MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '查询缓存大小',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '参数\'query_cache_size\'必须设置且大于10MB小于512MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '默认的存储引擎',
        'Table Storage Engine' => '表存储引擎',
        'Tables with a different storage engine than the default engine were found.' =>
            '以下表使用的存储引擎与默认存储引擎不同。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '需要MySQL 5.X或更高版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG设置',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG必须设置为al32utf8（例如：GERMAN_GERMANY.AL32UTF8）。',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT设置',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT 必须设置为\'YYYY-MM-DD HH24:MI:SS\'。',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL检查NLS_DATE_FORMAT设置',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '主键序列和触发器',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '发现下面的序列和/或触发器可能有错误的名称， 请手动重命名。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'client_encoding 需要设置为UNICODE或UTF8。',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encoding 需要设置为UNICODE或UTF8。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '日期格式',
        'Setting DateStyle needs to be ISO.' => '设置日期格式为国际标准格式。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '主键序列',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '发现下面的序列可能有错误的名称， 请手动重命名。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '需要PostgreSQL 9.2或更高版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO磁盘分区',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '硬盘使用情况',
        'The partition where OTOBO is located is almost full.' => 'OTOBO分区已经快满了。',
        'The partition where OTOBO is located has no disk space problems.' =>
            'OTOBO分区没有磁盘空间问题了。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '硬盘使用情况',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '发行版本',
        'Could not determine distribution.' => '不能确定发行版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '内核版本',
        'Could not determine kernel version.' => '不能确定内核版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '系统负载',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '系统负载最大值为系统CPU数（例如：8CPU的系统负载小于等于8才是正常的）。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl 模块',
        'Not all required Perl modules are correctly installed.' => '部分Perl模块没有正确安装。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Perl 模块 Audit',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit 报告一个或多个已安装的 Perl 模块是否存在已知漏洞。 请注意，在不更改版本号的情况下修补Perl模块的发行版可能存在误报。',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '在已安装的Perl模块中 CPAN::Audit 未报告出任何已知漏洞。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '可用的交换空间(%)',
        'No swap enabled.' => '没有启用交换空间。',
        'Used Swap Space (MB)' => '交换分区已使用(MB)',
        'There should be more than 60% free swap space.' => '需要至少60%的可用交换空间。',
        'There should be no more than 200 MB swap space used.' => '交换空间不应该使用超过200MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => '信件搜索索引状态',
        'Indexed Articles' => '索引过的信件',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '信件/通信渠道',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => '传入的通信',
        'Outgoing communications' => '外发的通信',
        'Failed communications' => '失败的通信',
        'Average processing time of communications (s)' => '通信平均处理时间',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '通讯日志帐号状态（最近24小时）',
        'No connections found.' => '找不到连接。',
        'ok' => 'OK',
        'permanent connection errors' => '永久性连接错误',
        'intermittent connection errors' => '间歇性连接错误',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => '配置设置',
        'Could not determine value.' => '不能确定参数值。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '守护进程',
        'Daemon is running.' => '守护进程正在运行。',
        'Daemon is not running.' => '守护进程没有运行。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => '数据库记录',
        'Ticket History Entries' => '工单历史条目',
        'Articles' => '信件',
        'Attachments (DB, Without HTML)' => '附件（DB，不包括HTML文件）',
        'Customers With At Least One Ticket' => '至少有一个工单的客户',
        'Dynamic Field Values' => '动态字段值',
        'Invalid Dynamic Fields' => '无效的动态字段',
        'Invalid Dynamic Field Values' => '无效的动态字段值',
        'GenericInterface Webservices' => '通用接口Web服务',
        'Process Tickets' => '流程工单',
        'Months Between First And Last Ticket' => '最早和最后工单的月数',
        'Tickets Per Month (avg)' => '平均每月工单数',
        'Open Tickets' => '处理中的工单',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '默认的SOAP用户名和密码',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '安全风险：你使用了默认的SOAP::User和SOAP::Password设置，请修改。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => '默认的系统管理员密码',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '安全风险：服务人员帐户root@localhost还在使用默认密码。请修改密码或禁用此帐户。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '电子邮件发送队列',
        'Emails queued for sending' => '已排队准备发送的电子邮件',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => '正式域名',
        'Please configure your FQDN setting.' => '请配置您的正式域名。',
        'Domain Name' => '域名',
        'Your FQDN setting is invalid.' => '您的正式域名无效。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => '文件系统是可写的',
        'The file system on your OTOBO partition is not writable.' => 'OTOBO分区所有文件系统是不可写的。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '遗留的配置备份',
        'No legacy configuration backup files found.' => '找不到遗留的配置备份文件。',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '在 Kernel/Config/Backups 文件夹中找到的旧版配置备份文件，但某些软件包可能仍然需要它们。',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '已安装的软件包不再需要旧的配置备份文件，请从 Kernel/Config/Backups 文件夹中删除它们。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => '软件包安装状态',
        'Some packages have locally modified files.' => '一些软件包有在本地修改过的文件。',
        'Some packages are not correctly installed.' => '一些软件包没有正确安装。',
        'Package Verification Status' => '软件包验证状态',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '软件包框架版本状态',
        'Some packages are not allowed for the current framework version.' =>
            '一些软件包无法在当前的框架版本中使用。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => '软件包列表',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '会话配置设置',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '假脱机邮件',
        'There are emails in var/spool that OTOBO could not process.' => 'var/spool 目录下有一些OTOBO无法处理的邮件。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '您的系统ID设置无效，它只能包含数字。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '默认工单类型',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '配置的默认工单类型无效或缺失，请修改设置Ticket::Type::Default，选择一个有效的工单类型。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => '工单索引模块',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '您已经超过60000个工单，应该使用后端静态数据库。请参阅管理员手册（性能调优部分）查阅更多信息。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '有锁定的工单的无效用户',
        'There are invalid users with locked tickets.' => '出现了有锁定的工单的无效用户。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '您的系统不能有超过8000个处理中的工单。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '工单搜索索引模块',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '索引进程强制将原始信件文本存储在信件搜索索引中，而不执行过滤器或应用停用词列表。 这将增加搜索索引的大小，从而可能减慢全文搜索。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_index 表中的孤儿记录',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_lock_index 表中包含孤儿记录。请运行bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup"清理静态数据库的索引。',
        'Orphaned Records In ticket_index Table' => 'ticket_index 表中的孤儿记录',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_index表中包含孤儿记录，请运行bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup"，清理静态数据库的索引。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '时间设置',
        'Server time zone' => '服务器时区',
        'OTOBO time zone' => 'OTOBO时区',
        'OTOBO time zone is not set.' => 'OTOBO时区未设置。',
        'User default time zone' => '用户默认时区',
        'User default time zone is not set.' => '用户默认时区未设置。',
        'Calendar time zone is not set.' => '日历时区未设置。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '用户界面 - 服务人员皮肤用法',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '用户界面 - 服务人员主题用法',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => '用户界面 - 特殊的统计',
        'Agents using custom main menu ordering' => '服务人员使用定制的主菜单排序',
        'Agents using favourites for the admin overview' => '服务人员在系统管理概览使用收藏夹',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'WEB服务器',
        'Loaded Apache Modules' => '已载入的Apache模块',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM多路处理模块',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO需要apache运行“prefork”MPM多路处理模块。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI加速器用法',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '您应该使用FastCGI或mod_perl来提升性能。',
        'mod_deflate Usage' => 'mod_deflate用法',
        'Please install mod_deflate to improve GUI speed.' => '安装模块mod_deflate来提升GUI的速度。',
        'mod_filter Usage' => 'mod_filter用法',
        'Please install mod_filter if mod_deflate is used.' => '如果使用了mod_deflate，请安装使用mod_filter模块。',
        'mod_headers Usage' => 'mod_headers用法',
        'Please install mod_headers to improve GUI speed.' => '安装模块mod_headers来提升GUI的速度。',
        'Apache::Reload Usage' => 'Apache::Reload用法',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload或Apache2::Reload应该被用作PERL模块和PERL初始化处理程序，以防止在安装和升级模块时WEB服务器重启。',
        'Apache2::DBI Usage' => 'Apache2::DBI用法',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '应该用Apache2::DBI的预先数据库连接来获得更好的性能。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '环境变量',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '收集支持数据',
        'Support data could not be collected from the web server.' => '不能从WEB服务器收集支持数据。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'WEB服务器版本',
        'Could not determine webserver version.' => '不能确定WEB服务器版本。',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '并发用户详细信息',
        'Concurrent Users' => '并发用户数',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '好',
        'Problem' => '问题',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '设置%s不存在！',
        'Setting %s is not locked to this user!' => '设置%s未锁定到这个用户！',
        'Setting value is not valid!' => '设置值无效！',
        'Could not add modified setting!' => '无法添加修改过的设置！',
        'Could not update modified setting!' => '无法更新修改过的设置！',
        'Setting could not be unlocked!' => '设置无法解锁！',
        'Missing key %s!' => '缺失键%s！',
        'Invalid setting: %s' => '无效的设置：%s',
        'Could not combine settings values into a perl hash.' => '无法将设置值组合成一个perl哈希。',
        'Can not lock the deployment for UserID \'%s\'!' => '无法锁定用户ID为 \'%s\'的部署！',
        'All Settings' => '所有设置',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '默认',
        'Value is not correct! Please, consider updating this field.' => '值不正确！ 请考虑更新这个字段。',
        'Value doesn\'t satisfy regex (%s).' => '值不满足正则表达式（%s）。',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '已启用',
        'Disabled' => '已禁用',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '系统无法在OTOBOTimeZone中计算用户的日期！',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '系统无法在OTOBOTimeZone中计算用户的日期时间！',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '值不正确！ 请考虑更新这个模块。',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '值不正确！ 请考虑更新这个设置。',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '重置解锁时间。',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '聊天参与人',
        'Chat Message Text' => '聊天消息文本',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '登录失败！用户名或密码错误。',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '认证成功，但在数据库中没有找到用户数据记录，请联系系统管理员。',
        'Can`t remove SessionID.' => '不能移除会话ID。',
        'Logout successful.' => '成功注销。',
        'Feature not active!' => '功能尚未激活!',
        'Sent password reset instructions. Please check your email.' => '密码重置说明已发送，请检查邮件。',
        'Invalid Token!' => '令牌无效！',
        'Sent new password to %s. Please check your email.' => '新密码已发送到%s，请检查邮件。',
        'Error: invalid session.' => '错误：无效会话。',
        'No Permission to use this frontend module!' => '没有权限使用这个前端界面模块！',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '认证成功，但是后端没有发现此客户的记录，请联系系统管理员。',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '重置密码未成功，请联系系统管理员。',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '这个e-mail地址已经存在，请直接登录或重置密码。',
        'This email address is not allowed to register. Please contact support staff.' =>
            '这个email地址无法注册，请联系支持人员。',
        'Added via Customer Panel (%s)' => '通过客户界面已添加（%s）',
        'Customer user can\'t be added!' => '不能添加客户用户！',
        'Can\'t send account info!' => '不能发送帐户信息！',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帐户创建成功。登录信息发送到%s，请查收邮件。',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '没有找到操作“%s”！',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => '暂时无效',
        'Group for default access.' => '具有默认权限的组。',
        'Group of all administrators.' => '所有管理员的组。',
        'Group for statistics access.' => '具有统计权限的组。',
        'new' => 'new-新建',
        'All new state types (default: viewable).' => '所有新工单的状态类型（默认：可查看）。',
        'open' => 'open-处理中',
        'All open state types (default: viewable).' => '所有处理中的工单的状态类型（默认：可查看）。',
        'closed' => 'closed-已关闭',
        'All closed state types (default: not viewable).' => '所有已关闭工单的状态类型（默认：不可查看）。',
        'pending reminder' => '挂起提醒',
        'All \'pending reminder\' state types (default: viewable).' => '所有挂起提醒的工单的状态类型（默认：可查看）。',
        'pending auto' => '等待自动',
        'All \'pending auto *\' state types (default: viewable).' => '所有等待自动成功/失败关闭的工单的状态类型（默认：可查看）。',
        'removed' => 'removed-已删除',
        'All \'removed\' state types (default: not viewable).' => '所有已移除工单的状态类型（默认：不可查看）。',
        'merged' => 'merged-已合并',
        'State type for merged tickets (default: not viewable).' => '合并的工单的状态类型（默认：不可查看）。',
        'New ticket created by customer.' => '客户创建的新工单。',
        'closed successful' => 'closed successful-成功关闭',
        'Ticket is closed successful.' => '工单已经成功关闭。',
        'closed unsuccessful' => 'closed unsuccessful-失败关闭',
        'Ticket is closed unsuccessful.' => '工单没有成功关闭。',
        'Open tickets.' => '处理工单。',
        'Customer removed ticket.' => '客户移除工单。',
        'Ticket is pending for agent reminder.' => '工单为服务人员提醒而挂起。',
        'pending auto close+' => '挂起等待成功关闭',
        'Ticket is pending for automatic close.' => '工单等待自动关闭而挂起。',
        'pending auto close-' => '挂起等待失败关闭',
        'State for merged tickets.' => '已合并工单的状态。',
        'system standard salutation (en)' => '系统标准问候语（英）',
        'Standard Salutation.' => '标准问候语。',
        'system standard signature (en)' => '系统标准签名（英）',
        'Standard Signature.' => '标准签名。',
        'Standard Address.' => '标准地址。',
        'possible' => '可能',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '跟进已关闭工单是可能的，这将会重新处理工单。',
        'reject' => '拒绝',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '跟进已关闭工单是不可能的，不会创建新工单。',
        'new ticket' => '新建工单',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '不能跟进已关闭工单，这将会创建一个新的工单。',
        'Postmaster queue.' => '邮箱管理员队列。',
        'All default incoming tickets.' => '所有默认进入的工单。',
        'All junk tickets.' => '所有的垃圾工单。',
        'All misc tickets.' => '所有的杂项工单。',
        'auto reply' => 'auto reply-自动回复',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '创建新工单后会发送自动答复。',
        'auto reject' => 'auto reject 自动拒绝',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '跟进工单被拒绝后会发送自动拒绝（在队列跟进选项设置为“拒绝”时）。',
        'auto follow up' => 'auto follow up-自动跟进',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '跟进工单被接受后会发送自动确认（在队列跟进选项设置为“可能”时）。',
        'auto reply/new ticket' => '自动回复/新工单',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '跟进工单被拒绝并创建新工单后会发送自动响应（在队列跟进选项设置为“新建工单”时）。',
        'auto remove' => 'auto remove-自动移除',
        'Auto remove will be sent out after a customer removed the request.' =>
            '客户移除请求后会发送自动移除。',
        'default reply (after new ticket has been created)' => '默认答复（新工单创建后）',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '默认拒绝（跟进已关闭工单被拒绝后）',
        'default follow-up (after a ticket follow-up has been added)' => '默认跟进（添加工单跟进后）',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '默认拒绝并创建新工单（跟进已关闭工单则创建新工单）',
        'Unclassified' => '未分类',
        '1 very low' => '1-非常低',
        '2 low' => '2-低',
        '3 normal' => '3-正常',
        '4 high' => '4-高',
        '5 very high' => '5-非常高',
        'unlock' => '未锁定',
        'lock' => '锁定',
        'tmp_lock' => '临时锁',
        'agent' => '服务人员',
        'system' => '系统',
        'customer' => '客户',
        'Ticket create notification' => '工单创建通知',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '每当创建一个新的工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (unlocked)' => '工单跟进通知（解锁）',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '如果一个客户用户发送了一个跟进到一个解锁工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (locked)' => '工单跟进通知（锁定）',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '如果一个客户用户发送了一个跟进到你是所有者或负责人的工单时，你都将收到一个通知。',
        'Ticket lock timeout notification' => '工单锁定超时通知',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '你是所有者的工单一被自动解锁你就会收到一个通知。',
        'Ticket owner update notification' => '工单所有者更新通知',
        'Ticket responsible update notification' => '工单负责人更新通知',
        'Ticket new note notification' => '工单添加备注通知',
        'Ticket queue update notification' => '工单队列更新通知',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '如果一个工单被转移到了你设置的“我的队列”之一，你将收到一个通知。',
        'Ticket pending reminder notification (locked)' => '工单挂起提醒通知（锁定）',
        'Ticket pending reminder notification (unlocked)' => '工单挂起提醒通知（解锁）',
        'Ticket escalation notification' => '工单升级通知',
        'Ticket escalation warning notification' => '工单升级警告通知',
        'Ticket service update notification' => '工单服务更新通知',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '如果一个工单的服务变更为你设置的“我的服务”之一，你将收到一个通知。',
        'Appointment reminder notification' => '预约提醒通知',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '每当你的一个预约到达提醒时间时，你就会收到一个通知。',
        'Ticket email delivery failure notification' => '工单邮件发送失败通知',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'AJAX通信时发生错误。 状态：%s，错误：%s',
        'This window must be called from compose window.' => '必须从撰写窗口调用此窗口。',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '添加所有',
        'An item with this name is already present.' => '名称相同的条目已存在。',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '该条目中包含子条目。您真的想要删除这个条目及其子条目吗？',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '更多',
        'Less' => '更少',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '按Ctrl + C（Cmd + C）复制到剪贴板',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '删除这个附件',
        'Deleting attachment...' => '正在删除附件...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '删除附件时出错。 请检查日志以获取更多信息。',
        'Attachment was deleted successfully.' => '附件已成功删除。',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '您真的想要删除这个动态字段吗? 所有关联的数据将丢失!',
        'Delete field' => '删除字段',
        'Deleting the field and its data. This may take a while...' => '正在删除这个动态字段及其相关数据，可能还要等一会儿...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '删除此动态字段',
        'Remove selection' => '删除选择',
        'Do you really want to delete this generic agent job?' => '您真的想要删除这个自动任务吗？',
        'Delete this Event Trigger' => '删除这个事件触发器',
        'Duplicate event.' => '复制事件。',
        'This event is already attached to the job, Please use a different one.' =>
            '该事件已经附加到任务，请重新选择。',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '在通信时发生一个错误。',
        'Request Details' => '请求详细信息',
        'Request Details for Communication ID' => '通信ID的请求详细信息',
        'Show or hide the content.' => '显示或隐藏该内容.',
        'Clear debug log' => '清空调试日志',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '删除错误处理模块',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '无法添加一个新的事件触发器，因为没有设置事件。',
        'Delete this Invoker' => '删除这个调用程序',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '对不起，唯一存在的条件是无法删除的。',
        'Sorry, the only existing field can\'t be removed.' => '对不起，唯一存在的字段是无法删除的。',
        'Delete conditions' => '删除条件',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '键 %s的映射',
        'Mapping for Key' => '键的映射',
        'Delete this Key Mapping' => '删除这个键映射',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '删除这个操作',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '克隆Web服务',
        'Delete operation' => '删除操作',
        'Delete invoker' => '删除调用程序',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告：当您更改\'管理\'组的名称时，在SysConfig作出相应的变化之前，你将被管理面板锁住！如果发生这种情况，请用SQL语句把组名改回到\'admin\'。',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '删除这个邮件帐户',
        'Deleting the mail account and its data. This may take a while...' =>
            '正在删除这个邮件帐户及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '您真的要删除这个通知语言吗？',
        'Do you really want to delete this notification?' => '您真的想要删除这个通知?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '您真的要删除该键吗？',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '有一个程序包升级过程正在运行，点击这里查看有关升级进度的状态信息。',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '最近完成了一个软件包的升级，点击这里查看结果。',
        'No response from get package upgrade result.' => '获取软件包升级结果时没有响应。',
        'Update all packages' => '更新所有软件包',
        'Dismiss' => '取消',
        'Update All Packages' => '更新所有软件包',
        'No response from package upgrade all.' => '获取全部软件包升级结果时没有响应。',
        'Currently not possible' => '目前不可能',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '由于正在进行软件包升级，因此目前已被禁用。',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            '由于OTOBO守护进程没有运行，这个选项当前被禁用。',
        'Are you sure you want to update all installed packages?' => '您确定要更新所有已安装的软件包吗？',
        'No response from get package upgrade run status.' => '获取软件包升级运行状态时没有响应。',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '删除此PostMasterFilter（邮箱管理员过滤器）',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '删除这个邮件管理员过滤器及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '从画布中删除实体',
        'No TransitionActions assigned.' => '没有分配转换动作。',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '没有分配活动对话框。请从左侧列表中选择一个活动对话框，并将它拖放到这里。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能删除这个活动，因为它是开始活动。',
        'Remove the Transition from this Process' => '从流程中删除这个转换',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦你使用这个按钮或链接,您将离开这个界面且当前状态将被自动保存。你想要继续吗?',
        'Delete Entity' => '删除实体',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括这个活动，你不能重复添加活动！',
        'Error during AJAX communication' => 'AJAX通信时发生错误',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '画布上已经有一个未连接的转换。在设置另一个转换之前，请先连接这个转换。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '活动已经使用了这个转换，你不能重复添加转换！',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路径已经使用了这个转换动作，你不能重复添加转换动作！',
        'Hide EntityIDs' => '隐藏实体编号',
        'Edit Field Details' => '编辑字段详情',
        'Customer interface does not support articles not visible for customers.' =>
            '客户界面不支持客户不可见的信件。',
        'Sorry, the only existing parameter can\'t be removed.' => '对不起，唯一存在的参数是无法删除的。',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '你确定要删除这个证书吗？',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '正在发送更新...',
        'Support Data information was successfully sent.' => '诊断信息已发送成功。',
        'Was not possible to send Support Data information.' => '不能发送支持数据。',
        'Update Result' => '更新结果',
        'Generating...' => '正在生成...',
        'It was not possible to generate the Support Bundle.' => '无法生成支持数据包。',
        'Generate Result' => '打包结果',
        'Support Bundle' => '支持数据包',
        'The mail could not be sent' => '邮件无法发送',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '无法将此条目设置为无效。 所有受影响的配置设置必须事先更改。',
        'Cannot proceed' => '无法继续',
        'Update manually' => '手动更新',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '为了反映您刚刚做出的更改，您可以自动更新受影响的设置，也可以点击“手动更新”。',
        'Save and update automatically' => '保存并自动更新',
        'Don\'t save, update manually' => '不保存，手动更新',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '您当前正在查看的条目是尚未部署的配置设置的一部分，这使得无法在当前状态下进行编辑，请等待设置部署后再编辑。 如果您不确定下一步该怎么办，请与系统管理员联系。',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '载入中...',
        'Search the System Configuration' => '搜索系统配置',
        'Please enter at least one search word to find anything.' => '请输入至少一个搜索词以查找任何内容。',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '很遗憾，现在不能开始部署，也许是因为另一个服务人员已经开始部署了。 请稍后再试。',
        'Deploy' => '部署',
        'The deployment is already running.' => '部署已经在运行。',
        'Deployment successful. You\'re being redirected...' => '部署成功。 您正在重定向...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '有一个错误。 请保存您正在编辑的所有设置，并检查日志以获取更多信息。',
        'Reset option is required!' => '必须重置选项！',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '通过恢复此部署，所有设置将恢复为开始部署时所具有的值。 你确定要继续吗？',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '带有值的键不能被重命名。 请删除此键/值对，然后重新添加它。',
        'Unlock setting.' => '解锁设置。',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '您真的要删除这个已安排的系统维护吗？',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '删除这个模板',
        'Deleting the template and its data. This may take a while...' =>
            '删除这个模板及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '跳转',
        'Timeline Month' => '月时间表',
        'Timeline Week' => '周时间表',
        'Timeline Day' => '每日时间表',
        'Previous' => '上一步',
        'Resources' => '资源',
        'Su' => '日',
        'Mo' => '一',
        'Tu' => '二',
        'We' => '三',
        'Th' => '四',
        'Fr' => '五',
        'Sa' => '六',
        'This is a repeating appointment' => '这是一个重复的预约',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '你想仅编辑本次预约的时间还是重复预约所有的时间？',
        'All occurrences' => '所有预约',
        'Just this occurrence' => '仅本次预约',
        'Too many active calendars' => '激活的日历太多',
        'Please either turn some off first or increase the limit in configuration.' =>
            '请关闭一些日历或者在配置中增加限制数。',
        'Restore default settings' => '恢复默认设置',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '你真的要删除这个预约吗？这个操作无法回退。',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '首先选择一个客户用户，然后选择一个客户ID来分配给这个工单。',
        'Duplicated entry' => '重复条目',
        'It is going to be deleted from the field, please try again.' => '将自动删除这个重复的地址，请再试一次。',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '请至少输入一个搜索条件或输入*搜索所有。',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => '关于OTOBO守护进程的信息',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '请检查标记为红色的字段，需要输入有效的值。',
        'month' => '月',
        'Remove active filters for this widget.' => '移除这个小部件的活动过滤器。',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '请稍候...',
        'Searching for linkable objects. This may take a while...' => '正在搜索可链接的对象，可能还要等一会儿...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '你确定要删除这个链接吗？',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '您是否使用像AdBlock或AdBlockPlus这样的浏览器插件？ 这可能会导致一些问题，我们强烈建议您为此域添加例外。',
        'Do not show this warning again.' => '不要再显示这个警告。',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '抱歉，你不能将标记为强制的通知的所有传输方法都禁用掉。',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '抱歉，你不能将本通知的所有传输方法都禁用掉。',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '请注意，你更改的设置至少有一个需要重新加载页面。 点击这里重新加载当前屏幕。',
        'An unknown error occurred. Please contact the administrator.' =>
            '出现未知错误，请联系管理员。',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '切换到桌面模式',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '请移除以下不能用于搜索的词语：',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '生成',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '这个元素有子元素，目前不能被删除。',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '您真的要删除这个统计吗？',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '选择要分配给这个工单的客户ID',
        'Do you really want to continue?' => '您真的要继续吗？',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...还有%s',
        ' ...show less' => ' ...显示少量',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '添加新的草稿',
        'Delete draft' => '删除草稿',
        'There are no more drafts available.' => '没有更多的草稿可用。',
        'It was not possible to delete this draft.' => '不能删除这个草稿。',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '信件过滤器',
        'Apply' => '应用',
        'Event Type Filter' => '事件类型过滤器',

        # JS File: Core.Agent
        'Slide the navigation bar' => '滑动导航栏',
        'Please turn off Compatibility Mode in Internet Explorer!' => '请关闭IE的兼容模式！',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '切换到移动模式',

        # JS File: Core.App
        'Error: Browser Check failed!' => '错误：浏览器检查失败！',
        'Reload page' => '刷新页面',
        'Reload page (%ss)' => '刷新页面（%ss）',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '命名空间%s无法初始化，因为找不到%s。',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '发生错误！ 请查看浏览器错误日志了解更多详情！',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '发生了一个或多个错误!',

        # JS File: Core.Installer
        'Mail check successful.' => '邮件配置检查成功完成。',
        'Error in the mail settings. Please correct and try again.' => '邮件设置错误, 请修改后再试一次。',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '在新窗口中打开此节点',
        'Please add values for all keys before saving the setting.' => '在保存设置之前，请添加所有键的值。',
        'The key must not be empty.' => '键不能为空。',
        'A key with this name (\'%s\') already exists.' => '此名称（\'%s\'）的键已存在。',
        'Do you really want to revert this setting to its historical value?' =>
            '你确定要把这个设置恢复到它的历史值吗？',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '打开日历',
        'Invalid date (need a future date)!' => '无效的日期（需使用未来的日期）！',
        'Invalid date (need a past date)!' => '无效的日期（需使用过去的日期）！',

        # JS File: Core.UI.InputFields
        'Not available' => '不可用',
        'and %s more...' => '还有%s...',
        'Show current selection' => '显示当前选择',
        'Current selection' => '当前选择',
        'Clear all' => '清除所有',
        'Filters' => '过滤器',
        'Clear search' => '清除搜索',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '如果你现在离开该页, 所有弹出的窗口也随之关闭!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一个弹出屏幕已经打开，你想先关闭它再打开一个吗？',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '无法打开弹出窗口，请禁用本应用的弹出屏幕拦截设置。',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '已应用升序排序， ',
        'Descending sort applied, ' => '已应用降序排序， ',
        'No sort applied, ' => '没有应用排序， ',
        'sorting is disabled' => '排序被禁用',
        'activate to apply an ascending sort' => '激活以应用升序排序',
        'activate to apply a descending sort' => '激活以应用降序排序',
        'activate to remove the sort' => '激活以取消排序',

        # JS File: Core.UI.Table
        'Remove the filter' => '移除过滤器',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '目前没有可供选择的元素。',

        # JS File: Core.UI
        'Please only select one file for upload.' => '请只选择一个文件进行上传。',
        'Sorry, you can only upload one file here.' => '对不起，您只能在这里上传一个文件。',
        'Sorry, you can only upload %s files.' => '对不起，您只能在这里上传%s个文件。',
        'Please only select at most %s files for upload.' => '请至少选择%s个文件进行上传。',
        'The following files are not allowed to be uploaded: %s' => '不允许上传以下文件：%s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '以下文件超过允许的单个文件最大大小%s，没有上传的文件有：%s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '以下文件已上传，没有重复上传：%s',
        'No space left for the following files: %s' => '以下文件没有可用空间：%s',
        'Available space %s of %s.' => '可用空间%s，总共%s。',
        'Upload information' => '上传信息',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '删除附件时发生未知错误，请再试一次。 如果错误仍然存在，请与系统管理员联系。',

        # JS File: Core.Language.UnitTest
        'yes' => '是',
        'no' => '否',
        'This is %s' => '这是%s',
        'Complex %s with %s arguments' => '复杂%s，带有%s参数',

        # JS File: OTOBOLineChart
        'No Data Available.' => '没有可用数据。',

        # JS File: OTOBOMultiBarChart
        'Grouped' => '分组的',
        'Stacked' => '堆叠的',

        # JS File: OTOBOStackedAreaChart
        'Stream' => '流',
        'Expanded' => '展开的',

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
